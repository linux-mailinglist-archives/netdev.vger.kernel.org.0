Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCC1291C1B
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgJRTfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731462AbgJRTZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:25:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4E6222C8;
        Sun, 18 Oct 2020 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049155;
        bh=1b/ax91nGnq8bh0X5y2HQqQf0UqwUuwYT2L9Mw+KzBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXZ+YFgQOJ8d24uWYh4mE+ZIxvjIhDqa3Z8aC0B6+UHPqQqiVNewCQId7hINpeNAp
         p4wzE48kFLhyqDr7BI3Gnrd/avW3H+uvgIP6m9qSKV5z7O9XC+ESqSRHhh5FX+OCoY
         ahfdp0CXpTamwKjziOFMlOGeoeUmYM0IoP42DFK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/52] ipv6/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)
Date:   Sun, 18 Oct 2020 15:24:57 -0400
Message-Id: <20201018192530.4055730-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 272928d1cdacfc3b55f605cb0e9115832ecfb20c ]

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
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c       | 7 +++++--
 net/ipv6/ip6_output.c | 2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index c5f2b17b7ee1a..36c29df70fb6e 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -481,8 +481,11 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
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
index 5198bc1232045..140fffe5358ba 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -470,8 +470,6 @@ int ip6_forward(struct sk_buff *skb)
 	 *	check and decrement ttl
 	 */
 	if (hdr->hop_limit <= 1) {
-		/* Force OUTPUT device used as source address */
-		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT, 0);
 		__IP6_INC_STATS(net, ip6_dst_idev(dst),
 				IPSTATS_MIB_INHDRERRORS);
-- 
2.25.1

