Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5415C28BB55
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389332AbgJLOud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:50:33 -0400
Received: from mail.efficios.com ([167.114.26.124]:60676 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389179AbgJLOuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:50:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 43BF62EA05B;
        Mon, 12 Oct 2020 10:50:31 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Lmg4qct2joTX; Mon, 12 Oct 2020 10:50:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 8002E2EA058;
        Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 8002E2EA058
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1602514230;
        bh=gUVxy+w1j0BD9TTwQVdU1mJ9SdqfH2wgwt1qmAnsPt4=;
        h=From:To:Date:Message-Id;
        b=Embw51+dOdb2Igu9ZehQVbkEQ3iZ8QtXU81m2uLnDFH0sjK3rr1Y7przzOzl2YHZp
         3nW+Ql47ymo5Hk73T68fW+5PQwFmJVeyFiBSL/0hfx5YW4tN2nl85I0Nta818LGwXo
         yOVkw8//IjKh5ZC6cy6nl9dyR9GndqSY6SaW8mECV4BihDlsm/5Ei4JpkzvPo4NKrz
         HoucjgECkfCeyC75PZkiLNWOSVCFZ04tCZb0PZQ1bIrQJ6a3YTcnquzEtfwPFhNH4i
         HbW+wUtXbNGxMVfnCGDSPHfdtfddjxbVbW+4qt14LwjFCCEj9wE49zJ4xafzb1G6xB
         gUwpXGsVaweXw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id g9Ewr83L4DrT; Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 5ED8A2EA308;
        Mon, 12 Oct 2020 10:50:30 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/3] ipv6/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)
Date:   Mon, 12 Oct 2020 10:50:15 -0400
Message-Id: <20201012145016.2023-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201012145016.2023-1-mathieu.desnoyers@efficios.com>
References: <20201012145016.2023-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per RFC4443, the destination address field for ICMPv6 error messages
is copied from the source address field of the invoking packet.

In configurations with Virtual Routing and Forwarding tables, looking up
which routing table to use for sending ICMPv6 error messages is
currently done by using the destination net_device.

If the source and destination interfaces are within separate VRFs, or
one in the global routing table and the other in a VRF, looking up the
source address of the invoking packet in the destination interface's
routing table will fail if the destination interface's routing table
contains no route to the invoking packet's source address.

One observable effect of this issue is that traceroute6 does not work in
the following cases:

- Route leaking between global routing table and VRF
- Route leaking between VRFs

Use the source device routing table when sending ICMPv6 error
messages.

[ In the context of ipv4, it has been pointed out that a similar issue
  may exist with ICMP errors triggered when forwarding between network
  namespaces. It would be worthwhile to investigate whether ipv6 has
  similar issues, but is outside of the scope of this investigation. ]

[ Testing shows that similar issues exist with ipv6 unreachable /
  fragmentation needed messages.  However, investigation of this
  additional failure mode is beyond this investigation's scope. ]

Link: https://tools.ietf.org/html/rfc4443
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
Changes since v1:
- Introduce icmp6_get_route_lookup_dev.
- Use skb->dev for routing table lookup, because it is guaranteed to be
  non-NULL.
---
 net/ipv6/icmp.c       | 7 +++++--
 net/ipv6/ip6_output.c | 2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a4e4912ad607..91209a2760aa 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -501,8 +501,11 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		iif = icmp6_iif(skb);
 	} else {
-		dst = skb_dst(skb);
-		iif = l3mdev_master_ifindex(dst ? dst->dev : skb->dev);
+		/*
+		 * The source device is used for looking up which routing table
+		 * to use for sending an ICMP error.
+		 */
+		iif = l3mdev_master_ifindex(skb->dev);
 	}
 
 	/*
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c78e67d7747f..cd623068de53 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -468,8 +468,6 @@ int ip6_forward(struct sk_buff *skb)
 	 *	check and decrement ttl
 	 */
 	if (hdr->hop_limit <= 1) {
-		/* Force OUTPUT device used as source address */
-		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT, 0);
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 
-- 
2.17.1

