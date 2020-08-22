Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FE424E824
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgHVO7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 10:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgHVO73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 10:59:29 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A468EC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 07:59:27 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id C0CAE86BDE;
        Sat, 22 Aug 2020 15:59:18 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598108358; bh=/hRj69VSaGaIS5oBMeKxUgi0NIVi6txlUXEEMTXDp5Q=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=20v2=201/9]=20l2tp:=2
         0don't=20log=20data=20frames|Date:=20Sat,=2022=20Aug=202020=2015:5
         9:01=20+0100|Message-Id:=20<20200822145909.6381-2-tparkin@katalix.
         com>|In-Reply-To:=20<20200822145909.6381-1-tparkin@katalix.com>|Re
         ferences:=20<20200822145909.6381-1-tparkin@katalix.com>;
        b=Vh1EwwhYz5H0e7wRrEwx2DAgeYPvgof2CvXtox9Bkph1YfErsZIdUC1PnwH0tXLCy
         /obkR+vnKCpMi/8Yu9P28+XJdDi4xj7wDqF/TCgbw3GZVrXm1tH58JV526AvfjQJvH
         SgrSWlKWz/qSu0Wf+s1lzNafVsZ+NH+zdvJ8bvb6ppsu979iE6UmsRkumNhm3il/2+
         PKVPN+UVorRRPY5vM6l/NX2opdqu16raZ5VyiU9xFTgr53u1V0RaqqIYMbPNqHqR9b
         qyeth8NPAXaRUp17frqsw9ZSW66LW7RmGSnGWS4Q2e938XjUl5WECddCJYszipfJRr
         ZK7gZTpT9p+LA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next v2 1/9] l2tp: don't log data frames
Date:   Sat, 22 Aug 2020 15:59:01 +0100
Message-Id: <20200822145909.6381-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822145909.6381-1-tparkin@katalix.com>
References: <20200822145909.6381-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp had logging to trace data frame receipt and transmission, including
code to dump packet contents.  This was originally intended to aid
debugging of core l2tp packet handling, but is of limited use now that
code is stable.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 58 +++++---------------------------------------
 net/l2tp/l2tp_eth.c  | 11 ---------
 net/l2tp/l2tp_ip.c   | 15 ------------
 net/l2tp/l2tp_ip6.c  | 15 ------------
 net/l2tp/l2tp_ppp.c  |  8 ------
 5 files changed, 6 insertions(+), 101 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 701fc72ad9f4..077f7952912d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -660,7 +660,6 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      int length)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
-	u32 ns = 0, nr = 0;
 	int offset;
 
 	/* Parse and check optional cookie */
@@ -686,32 +685,21 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	L2TP_SKB_CB(skb)->has_seq = 0;
 	if (tunnel->version == L2TP_HDR_VER_2) {
 		if (hdrflags & L2TP_HDRFLAG_S) {
-			ns = ntohs(*(__be16 *)ptr);
-			ptr += 2;
-			nr = ntohs(*(__be16 *)ptr);
-			ptr += 2;
-
 			/* Store L2TP info in the skb */
-			L2TP_SKB_CB(skb)->ns = ns;
+			L2TP_SKB_CB(skb)->ns = ntohs(*(__be16 *)ptr);
 			L2TP_SKB_CB(skb)->has_seq = 1;
+			ptr += 2;
+			/* Skip past nr in the header */
+			ptr += 2;
 
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: recv data ns=%u, nr=%u, session nr=%u\n",
-				 session->name, ns, nr, session->nr);
 		}
 	} else if (session->l2specific_type == L2TP_L2SPECTYPE_DEFAULT) {
 		u32 l2h = ntohl(*(__be32 *)ptr);
 
 		if (l2h & 0x40000000) {
-			ns = l2h & 0x00ffffff;
-
 			/* Store L2TP info in the skb */
-			L2TP_SKB_CB(skb)->ns = ns;
+			L2TP_SKB_CB(skb)->ns = l2h & 0x00ffffff;
 			L2TP_SKB_CB(skb)->has_seq = 1;
-
-			l2tp_dbg(session, L2TP_MSG_SEQ,
-				 "%s: recv data ns=%u, session nr=%u\n",
-				 session->name, ns, session->nr);
 		}
 		ptr += 4;
 	}
@@ -853,16 +841,6 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 		goto error;
 	}
 
-	/* Trace packet contents, if enabled */
-	if (tunnel->debug & L2TP_MSG_DATA) {
-		length = min(32u, skb->len);
-		if (!pskb_may_pull(skb, length))
-			goto error;
-
-		pr_debug("%s: recv\n", tunnel->name);
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, skb->data, length);
-	}
-
 	/* Point to L2TP header */
 	optr = skb->data;
 	ptr = skb->data;
@@ -883,12 +861,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	length = skb->len;
 
 	/* If type is control packet, it is handled by userspace. */
-	if (hdrflags & L2TP_HDRFLAG_T) {
-		l2tp_dbg(tunnel, L2TP_MSG_DATA,
-			 "%s: recv control packet, len=%d\n",
-			 tunnel->name, length);
+	if (hdrflags & L2TP_HDRFLAG_T)
 		goto error;
-	}
 
 	/* Skip flags */
 	ptr += 2;
@@ -953,9 +927,6 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!tunnel)
 		goto pass_up;
 
-	l2tp_dbg(tunnel, L2TP_MSG_DATA, "%s: received %d bytes\n",
-		 tunnel->name, skb->len);
-
 	if (l2tp_udp_recv_core(tunnel, skb))
 		goto pass_up;
 
@@ -1049,23 +1020,6 @@ static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
 	unsigned int len = skb->len;
 	int error;
 
-	/* Debug */
-	if (session->send_seq)
-		l2tp_dbg(session, L2TP_MSG_DATA, "%s: send %zd bytes, ns=%u\n",
-			 session->name, data_len, session->ns - 1);
-	else
-		l2tp_dbg(session, L2TP_MSG_DATA, "%s: send %zd bytes\n",
-			 session->name, data_len);
-
-	if (session->debug & L2TP_MSG_DATA) {
-		int uhlen = (tunnel->encap == L2TP_ENCAPTYPE_UDP) ? sizeof(struct udphdr) : 0;
-		unsigned char *datap = skb->data + uhlen;
-
-		pr_debug("%s: xmit\n", session->name);
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-				     datap, min_t(size_t, 32, len - uhlen));
-	}
-
 	/* Queue the packet to IP for output */
 	skb->ignore_df = 1;
 	skb_dst_drop(skb);
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 7ed2b4eced94..657edad1263e 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -128,17 +128,6 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	struct net_device *dev;
 	struct l2tp_eth *priv;
 
-	if (session->debug & L2TP_MSG_DATA) {
-		unsigned int length;
-
-		length = min(32u, skb->len);
-		if (!pskb_may_pull(skb, length))
-			goto error;
-
-		pr_debug("%s: eth recv\n", session->name);
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, skb->data, length);
-	}
-
 	if (!pskb_may_pull(skb, ETH_HLEN))
 		goto error;
 
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index df2a35b5714a..7086d97f293c 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -118,7 +118,6 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
 	struct iphdr *iph;
-	int length;
 
 	if (!pskb_may_pull(skb, 4))
 		goto discard;
@@ -147,20 +146,6 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	if (!tunnel)
 		goto discard_sess;
 
-	/* Trace packet contents, if enabled */
-	if (tunnel->debug & L2TP_MSG_DATA) {
-		length = min(32u, skb->len);
-		if (!pskb_may_pull(skb, length))
-			goto discard_sess;
-
-		/* Point to L2TP header */
-		optr = skb->data;
-		ptr = skb->data;
-		ptr += 4;
-		pr_debug("%s: ip recv\n", tunnel->name);
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, ptr, length);
-	}
-
 	if (l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
 		goto discard_sess;
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index bc757bc7e264..409ea8927f6c 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -131,7 +131,6 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel = NULL;
 	struct ipv6hdr *iph;
-	int length;
 
 	if (!pskb_may_pull(skb, 4))
 		goto discard;
@@ -160,20 +159,6 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	if (!tunnel)
 		goto discard_sess;
 
-	/* Trace packet contents, if enabled */
-	if (tunnel->debug & L2TP_MSG_DATA) {
-		length = min(32u, skb->len);
-		if (!pskb_may_pull(skb, length))
-			goto discard_sess;
-
-		/* Point to L2TP header */
-		optr = skb->data;
-		ptr = skb->data;
-		ptr += 4;
-		pr_debug("%s: ip recv\n", tunnel->name);
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, ptr, length);
-	}
-
 	if (l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
 		goto discard_sess;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 13c3153b40d6..ee1663a3ca7b 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -237,17 +237,9 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
 	if (sk->sk_state & PPPOX_BOUND) {
 		struct pppox_sock *po;
 
-		l2tp_dbg(session, L2TP_MSG_DATA,
-			 "%s: recv %d byte data frame, passing to ppp\n",
-			 session->name, data_len);
-
 		po = pppox_sk(sk);
 		ppp_input(&po->chan, skb);
 	} else {
-		l2tp_dbg(session, L2TP_MSG_DATA,
-			 "%s: recv %d byte data frame, passing to L2TP socket\n",
-			 session->name, data_len);
-
 		if (sock_queue_rcv_skb(sk, skb) < 0) {
 			atomic_long_inc(&session->stats.rx_errors);
 			kfree_skb(skb);
-- 
2.17.1

