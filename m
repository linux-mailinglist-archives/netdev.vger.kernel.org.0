Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B553B103F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFVW4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhFVW4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 18:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE39D61107;
        Tue, 22 Jun 2021 22:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624402478;
        bh=o7seISUNB4f/eTt96A55r1Jq41yJV74Z9zrPMMzgLo0=;
        h=From:To:Cc:Subject:Date:From;
        b=brMxoqcPCnJAtAvYG7R1qoZtfF0NqFQMqbm83gB3CGdtdu8eNiKVVbF158RYEEsz8
         cxHMumVVOrUB/2fO3JRoAgYbYcyHKwTD3J+ZpyPjE0lHFW8abGCjm3SacUxm9v7ZXE
         RZ0Igme8T4I2hWYeF207G2jRIjUpqUSNaigTmuKq7Uc6T+QtDAEJfb5HlT8nqJ2zNb
         5B0QpAaSt1OXlHWKGNRpXO0gMh2RCFFy5Khkhxl9b/O2pumNbhhVF1Y5RXZ+eDDXyY
         dNSs3hUT5eOpcn3VSN9A3zOuiSjOl475+wi3BFhtvEqwPV11BSwhBsEYrLnaDi63SQ
         Voz/WpWEdqbjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/2] net: ip: refactor SG checks
Date:   Tue, 22 Jun 2021 15:50:56 -0700
Message-Id: <20210622225057.2108592-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a number of rt->dst.dev->features & NETIF_F_SG checks
scattered throughout the code. Shorten the lines by caching
the result of this check.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/ip_output.c  | 13 ++++++-------
 net/ipv6/ip6_output.c | 13 ++++++-------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3efc7d658f6..90031f5446bd 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -981,12 +981,14 @@ static int __ip_append_data(struct sock *sk,
 	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
+	bool has_sg, paged, extra_uref = false;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref = false;
 	u32 tskey = 0;
 
 	skb = skb_peek_tail(queue);
 
+	has_sg = rt->dst.dev->features & NETIF_F_SG;
+
 	exthdrlen = !skb ? rt->dst.header_len : 0;
 	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
 	paged = !!cork->gso_size;
@@ -1023,8 +1025,7 @@ static int __ip_append_data(struct sock *sk,
 		if (!uarg)
 			return -ENOBUFS;
 		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
+		if (has_sg && csummode == CHECKSUM_PARTIAL) {
 			paged = true;
 		} else {
 			uarg->zerocopy = 0;
@@ -1074,8 +1075,7 @@ static int __ip_append_data(struct sock *sk,
 			fraglen = datalen + fragheaderlen;
 			pagedlen = 0;
 
-			if ((flags & MSG_MORE) &&
-			    !(rt->dst.dev->features&NETIF_F_SG))
+			if ((flags & MSG_MORE) && !has_sg)
 				alloclen = mtu;
 			else if (!paged)
 				alloclen = fraglen;
@@ -1174,8 +1174,7 @@ static int __ip_append_data(struct sock *sk,
 		if (copy > length)
 			copy = length;
 
-		if (!(rt->dst.dev->features&NETIF_F_SG) &&
-		    skb_tailroom(skb) >= copy) {
+		if (!has_sg && skb_tailroom(skb) >= copy) {
 			unsigned int off;
 
 			off = skb->len;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..c667b7e2856f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1444,8 +1444,8 @@ static int __ip6_append_data(struct sock *sk,
 	struct ipv6_txoptions *opt = v6_cork->opt;
 	int csummode = CHECKSUM_NONE;
 	unsigned int maxnonfragsize, headersize;
+	bool has_sg, paged, extra_uref = false;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref = false;
 
 	skb = skb_peek_tail(queue);
 	if (!skb) {
@@ -1453,6 +1453,8 @@ static int __ip6_append_data(struct sock *sk,
 		dst_exthdrlen = rt->dst.header_len - rt->rt6i_nfheader_len;
 	}
 
+	has_sg = rt->dst.dev->features & NETIF_F_SG;
+
 	paged = !!cork->gso_size;
 	mtu = cork->gso_size ? IP6_MAX_MTU : cork->fragsize;
 	orig_mtu = mtu;
@@ -1515,8 +1517,7 @@ static int __ip6_append_data(struct sock *sk,
 		if (!uarg)
 			return -ENOBUFS;
 		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
+		if (has_sg && csummode == CHECKSUM_PARTIAL) {
 			paged = true;
 		} else {
 			uarg->zerocopy = 0;
@@ -1582,8 +1583,7 @@ static int __ip6_append_data(struct sock *sk,
 			fraglen = datalen + fragheaderlen;
 			pagedlen = 0;
 
-			if ((flags & MSG_MORE) &&
-			    !(rt->dst.dev->features&NETIF_F_SG))
+			if ((flags & MSG_MORE) && !has_sg)
 				alloclen = mtu;
 			else if (!paged)
 				alloclen = fraglen;
@@ -1698,8 +1698,7 @@ static int __ip6_append_data(struct sock *sk,
 		if (copy > length)
 			copy = length;
 
-		if (!(rt->dst.dev->features&NETIF_F_SG) &&
-		    skb_tailroom(skb) >= copy) {
+		if (!has_sg && skb_tailroom(skb) >= copy) {
 			unsigned int off;
 
 			off = skb->len;
-- 
2.31.1

