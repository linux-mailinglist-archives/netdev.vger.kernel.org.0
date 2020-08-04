Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB8623B4A4
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgHDFyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:54:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37443 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726398AbgHDFyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VZ6YDJD55kpYQ33m1APvTAf4DIZYbqpLUJ1HTP7ssRA=;
        b=i+50HbGCnpIyczkT4mE53WBPVHzduzQfYAC4NPpSIaAA2e0P3+QvlSN83b23DrTUoqaQM3
        tzocz1KvDQHwzpIbnT9fsBvpv2AQqqKz4ythkytK5qORFcpHrmpN945wCCzQKCto9AWD4i
        hCd8Nn9ryP77LSti2DCLpn5Ev4Lup7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-WYat1sdqPD-Ww2Z6qu7cTQ-1; Tue, 04 Aug 2020 01:54:10 -0400
X-MC-Unique: WYat1sdqPD-Ww2Z6qu7cTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77D92106B24E;
        Tue,  4 Aug 2020 05:54:08 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4B911001B2C;
        Tue,  4 Aug 2020 05:54:05 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/6] Support PMTU discovery with bridged UDP tunnels
Date:   Tue,  4 Aug 2020 07:53:41 +0200
Message-Id: <cover.1596520062.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, PMTU discovery for UDP tunnels only works if packets are
routed to the encapsulating interfaces, not bridged.

This results from the fact that we generally don't have valid routes
to the senders we can use to relay ICMP and ICMPv6 errors, and makes
PMTU discovery completely non-functional for VXLAN and GENEVE ports of
both regular bridges and Open vSwitch instances.

If the sender is local, and packets are forwarded to the port by a
regular bridge, all it takes is to generate a corresponding route
exception on the encapsulating device. The bridge then finds the route
exception carrying the PMTU value estimate as it forwards frames, and
relays ICMP messages back to the socket of the local sender. Patch 1/6
fixes this case.

If the sender resides on another node, we actually need to reply to
IP and IPv6 packets ourselves and send these ICMP or ICMPv6 errors
back, using the same encapsulating device. Patch 2/6, based on an
original idea by Florian Westphal, adds the needed functionality,
while patches 3/6 and 4/6 add matching support for VXLAN and GENEVE.

Finally, 5/6 and 6/6 introduce selftests for all combinations of
inner and outer IP versions, covering both VXLAN and GENEVE, with
both regular bridges and Open vSwitch instances.

v2: Add helper to check for any bridge port, skip oif check for PMTU
    routes for bridge ports only, split IPv4 and IPv6 helpers and
    functions (all suggested by David Ahern)

Stefano Brivio (6):
  ipv4: route: Ignore output interface in FIB lookup for PMTU route
  tunnels: PMTU discovery support for directly bridged IP packets
  vxlan: Support for PMTU discovery on directly bridged links
  geneve: Support for PMTU discovery on directly bridged links
  selftests: pmtu.sh: Add tests for bridged UDP tunnels
  selftests: pmtu.sh: Add tests for UDP tunnels handled by Open vSwitch

 drivers/net/bareudp.c               |   5 +-
 drivers/net/geneve.c                |  55 ++++-
 drivers/net/vxlan.c                 |  47 +++-
 include/linux/netdevice.h           |   5 +
 include/net/dst.h                   |  10 -
 include/net/ip_tunnels.h            |   2 +
 net/ipv4/ip_tunnel_core.c           | 244 +++++++++++++++++++
 net/ipv4/route.c                    |   5 +
 tools/testing/selftests/net/pmtu.sh | 347 +++++++++++++++++++++++++++-
 9 files changed, 691 insertions(+), 29 deletions(-)

-- 
2.27.0

