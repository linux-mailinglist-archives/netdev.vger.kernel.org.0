Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519173F43CF
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 05:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhHWDS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 23:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhHWDS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 23:18:57 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32DCC061575;
        Sun, 22 Aug 2021 20:18:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629688693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Z1Hh5wWV41gbyuhJN3abIA+9gChn8bbFfF4TW2obKU=;
        b=CDdQ1JG2iZjwBlI4QV8BgfHbsiVrArqxODTen8H35pkiOhn+T0efcWmoCCm610gu+3toQV
        bwE6/sXg0+6q3TLjVZJ6+Gs+quHjXfPP+pWPyaCnQ5IzaNZNBjZx56M3FqfvMvZMfO2Gqq
        bo5oWNHz0v/NkdENoQoxn4hbOVTrP2Q=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: ipv4: Move ip_options_fragment() out of loop
Date:   Mon, 23 Aug 2021 11:17:59 +0800
Message-Id: <20210823031759.25395-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ip_options_fragment() only called when iter->offset is equal to zero,
so move it out of loop, and inline 'Copy the flags to each fragment.'
As also, remove the unused parameter in ip_frag_ipcb().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/ip_output.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6b04a88466b2..9a8f05d5476e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -606,18 +606,6 @@ void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
 }
 EXPORT_SYMBOL(ip_fraglist_init);
 
-static void ip_fraglist_ipcb_prepare(struct sk_buff *skb,
-				     struct ip_fraglist_iter *iter)
-{
-	struct sk_buff *to = iter->frag;
-
-	/* Copy the flags to each fragment. */
-	IPCB(to)->flags = IPCB(skb)->flags;
-
-	if (iter->offset == 0)
-		ip_options_fragment(to);
-}
-
 void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 {
 	unsigned int hlen = iter->hlen;
@@ -663,7 +651,7 @@ void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
 EXPORT_SYMBOL(ip_frag_init);
 
 static void ip_frag_ipcb(struct sk_buff *from, struct sk_buff *to,
-			 bool first_frag, struct ip_frag_state *state)
+			 bool first_frag)
 {
 	/* Copy the flags to each fragment. */
 	IPCB(to)->flags = IPCB(from)->flags;
@@ -837,12 +825,13 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
+		ip_options_fragment(iter.frag);
 
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
 			if (iter.frag) {
-				ip_fraglist_ipcb_prepare(skb, &iter);
+				IPCB(iter.frag)->flags = IPCB(skb)->flags;
 				ip_fraglist_prepare(skb, &iter);
 			}
 
@@ -897,7 +886,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			err = PTR_ERR(skb2);
 			goto fail;
 		}
-		ip_frag_ipcb(skb, skb2, first_frag, &state);
+		ip_frag_ipcb(skb, skb2, first_frag);
 
 		/*
 		 *	Put this fragment into the sending queue.
-- 
2.32.0

