Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8051B23AE79
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgHCUxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:53:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727003AbgHCUxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B9KJ6HdsZiRL7htQ+eo+qFZGKDtoR3L6P2OLn6VpXrI=;
        b=Jc4HAMg/PtcPJxm+EDjgfzdmkBbKH3WQWGAk56sgq77rEezlnlLAY5CSviFW8vZffHzxYJ
        rlAVNE0TUZBZqD8u5WFiCaGa4EVU04LiB3LYP9vwAFc432KxH0ZwDznhADFiSmCMw5W8Kl
        02q0L0kJ4isFH+Hf3c9punkXoqicYGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-2ZoZZGKKMXijqY3t937otg-1; Mon, 03 Aug 2020 16:53:45 -0400
X-MC-Unique: 2ZoZZGKKMXijqY3t937otg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04A7A8015FB;
        Mon,  3 Aug 2020 20:53:44 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD66210013C1;
        Mon,  3 Aug 2020 20:53:40 +0000 (UTC)
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
Subject: [PATCH net-next 0/6] Support PMTU discovery with bridged UDP tunnels
Date:   Mon,  3 Aug 2020 22:52:08 +0200
Message-Id: <cover.1596487323.git.sbrivio@redhat.com>
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

Stefano Brivio (6):
  ipv4: route: Ignore output interface in FIB lookup for PMTU route
  tunnels: PMTU discovery support for directly bridged IP packets
  vxlan: Support for PMTU discovery on directly bridged links
  geneve: Support for PMTU discovery on directly bridged links
  selftests: pmtu.sh: Add tests for bridged UDP tunnels
  selftests: pmtu.sh: Add tests for UDP tunnels handled by Open vSwitch

 drivers/net/bareudp.c               |   5 +-
 drivers/net/geneve.c                |  57 ++++-
 drivers/net/vxlan.c                 |  49 +++-
 include/net/dst.h                   |  10 -
 include/net/ip_tunnels.h            |  88 +++++++
 net/ipv4/ip_tunnel_core.c           | 122 ++++++++++
 net/ipv4/route.c                    |   1 +
 tools/testing/selftests/net/pmtu.sh | 347 +++++++++++++++++++++++++++-
 8 files changed, 650 insertions(+), 29 deletions(-)

-- 
2.27.0

