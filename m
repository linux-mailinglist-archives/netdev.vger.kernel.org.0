Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6734E570
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhC3KaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhC3K3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/g5746S7cQ6XMelVy0eNDh93PHETmdX+BHxHG7UfUHg=;
        b=CpJsIYqi4QBU7m4T1QEnpwNZbWVDRtYsjAPkoK6W33/XLak4EfRJDC+rrZ/UiVCj94/2km
        2SXQZGClNPhOm0ORCtmlYHjZ5QhDLYiALv+7W6FMRASFsqKvB2Fs+U3Jzfq5WI1DKG+pL0
        UNEH4+4zGnZbKKFCuT2Z0ROorqwUq5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-1-_0f2jLM76eF9L6VroGXg-1; Tue, 30 Mar 2021 06:29:47 -0400
X-MC-Unique: 1-_0f2jLM76eF9L6VroGXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D2D9801814;
        Tue, 30 Mar 2021 10:29:45 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABB8C19C45;
        Tue, 30 Mar 2021 10:29:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 0/8] udp: GRO L4 improvements
Date:   Tue, 30 Mar 2021 12:28:48 +0200
Message-Id: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves the UDP L4 - either 'forward' or 'frag_list' -
co-existence with UDP tunnel GRO, allowing the first to take place
correctly even for encapsulated UDP traffic.

The first for patches are mostly bugfixes, addressing some GRO 
edge-cases when both tunnels and L4 are present, enabled and in use.

The next 3 patches avoid unneeded segmentation when UDP GRO
traffic traverses in the receive path UDP tunnels.

Finally, some self-tests are included, covering the relevant
GRO scenarios.

Even if most patches are actually bugfixes, this series is
targeting net-next, as overall it makes available a new feature.

v2 -> v3:
 - no code changes, more verbose commit messages and comment in
   patch 1/8

v1 -> v2:
 - restrict post segmentation csum fixup to the only the relevant pkts
 - use individual 'accept_gso_type' fields instead of whole gso bitmask
   (Willem)
 - use only ipv6 addesses from test range in self-tests (Willem)
 - hopefully clarified most individual patches commit messages

Paolo Abeni (8):
  udp: fixup csum for GSO receive slow path
  udp: skip L4 aggregation for UDP tunnel packets
  udp: properly complete L4 GRO over UDP tunnel packet
  udp: never accept GSO_FRAGLIST packets
  vxlan: allow L4 GRO passthrough
  geneve: allow UDP L4 GRO passthrou
  bareudp: allow UDP L4 GRO passthrou
  selftests: net: add UDP GRO forwarding self-tests

 drivers/net/bareudp.c                     |   1 +
 drivers/net/geneve.c                      |   1 +
 drivers/net/vxlan.c                       |   1 +
 include/linux/udp.h                       |  22 +-
 include/net/udp.h                         |  23 ++
 net/ipv4/udp.c                            |   5 +
 net/ipv4/udp_offload.c                    |  27 ++-
 net/ipv6/udp.c                            |   1 +
 net/ipv6/udp_offload.c                    |   3 +-
 tools/testing/selftests/net/Makefile      |   1 +
 tools/testing/selftests/net/udpgro_fwd.sh | 251 ++++++++++++++++++++++
 11 files changed, 323 insertions(+), 13 deletions(-)
 create mode 100755 tools/testing/selftests/net/udpgro_fwd.sh

-- 
2.26.2

