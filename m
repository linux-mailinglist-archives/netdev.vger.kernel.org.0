Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460D925BDEC
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgICIzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:17 -0400
Received: from mail.katalix.com ([3.9.82.81]:42256 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgICIzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:09 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 0A80D86C7D;
        Thu,  3 Sep 2020 09:55:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123307; bh=rW994aukxFBDu4uo1hb1aDhDKa09HH4/k5Zz9wMtkHc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=204/6]=20l2tp:=20capt
         ure=20more=20tx=20errors=20in=20data=20plane=20stats|Date:=20Thu,=
         20=203=20Sep=202020=2009:54:50=20+0100|Message-Id:=20<202009030854
         52.9487-5-tparkin@katalix.com>|In-Reply-To:=20<20200903085452.9487
         -1-tparkin@katalix.com>|References:=20<20200903085452.9487-1-tpark
         in@katalix.com>;
        b=BORobbYt9HfNowtsdm45loWW46eqPSnQOvF2cRrgV9FXO5RVfqaKNNvml48dAJHzb
         AcU4hdNAHodCe791EXrEuBWVSKK8SSzX9kiWczjsTARYSCffhlMcaIQo06L9Oird71
         UMbWEcBBRMW2T/q23xqWyuOwD3HkiqXeWNXMCoIXUpNAiZ8Bx91wElN3KdNWNjau1F
         wRD7eTyVBjzVEVB4IZJmZYO0KJah9NfLyeEiAgxGNLckuiHyt7Uoo3e5GYsU/QPVAJ
         5OZu186V3sxwGWv73UX1ke48KQbCZN+01zFHxl7Rl1GEtiaD8Vo3VARwkRnRdfbdng
         784N3av6YZyKg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 4/6] l2tp: capture more tx errors in data plane stats
Date:   Thu,  3 Sep 2020 09:54:50 +0100
Message-Id: <20200903085452.9487-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_xmit_skb has a number of failure paths which are not reflected in
the tunnel and session statistics because the stats are updated by
l2tp_xmit_core.  Hence any errors occurring before l2tp_xmit_core is
called are missed from the statistics.

Refactor the transmit path slightly to capture all error paths.

l2tp_xmit_skb now leaves all the actual work of transmission to
l2tp_xmit_core, and updates the statistics based on l2tp_xmit_core's
return code.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 71 +++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index da66a6ed8993..d2672df7e65a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -985,56 +985,39 @@ static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf)
 	return bufp - optr;
 }
 
-static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, struct flowi *fl)
+/* Queue the packet to IP for output: tunnel socket lock must be held */
+static int l2tp_xmit_queue(struct l2tp_tunnel *tunnel, struct sk_buff *skb, struct flowi *fl)
 {
-	struct l2tp_tunnel *tunnel = session->tunnel;
-	unsigned int len = skb->len;
-	int error;
+	int err;
 
-	/* Queue the packet to IP for output */
 	skb->ignore_df = 1;
 	skb_dst_drop(skb);
 #if IS_ENABLED(CONFIG_IPV6)
 	if (l2tp_sk_is_v6(tunnel->sock))
-		error = inet6_csk_xmit(tunnel->sock, skb, NULL);
+		err = inet6_csk_xmit(tunnel->sock, skb, NULL);
 	else
 #endif
-		error = ip_queue_xmit(tunnel->sock, skb, fl);
+		err = ip_queue_xmit(tunnel->sock, skb, fl);
 
-	/* Update stats */
-	if (error >= 0) {
-		atomic_long_inc(&tunnel->stats.tx_packets);
-		atomic_long_add(len, &tunnel->stats.tx_bytes);
-		atomic_long_inc(&session->stats.tx_packets);
-		atomic_long_add(len, &session->stats.tx_bytes);
-	} else {
-		atomic_long_inc(&tunnel->stats.tx_errors);
-		atomic_long_inc(&session->stats.tx_errors);
-	}
+	return err >= 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
 }
 
-/* If caller requires the skb to have a ppp header, the header must be
- * inserted in the skb data before calling this function.
- */
-int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
+static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb)
 {
-	int data_len = skb->len;
 	struct l2tp_tunnel *tunnel = session->tunnel;
+	unsigned int data_len = skb->len;
 	struct sock *sk = tunnel->sock;
-	struct flowi *fl;
-	struct udphdr *uh;
-	struct inet_sock *inet;
-	int headroom;
-	int uhlen = (tunnel->encap == L2TP_ENCAPTYPE_UDP) ? sizeof(struct udphdr) : 0;
-	int udp_len;
+	int headroom, uhlen, udp_len;
 	int ret = NET_XMIT_SUCCESS;
+	struct inet_sock *inet;
+	struct udphdr *uh;
 
 	/* Check that there's enough headroom in the skb to insert IP,
 	 * UDP and L2TP headers. If not enough, expand it to
 	 * make room. Adjust truesize.
 	 */
-	headroom = NET_SKB_PAD + sizeof(struct iphdr) +
-		uhlen + session->hdr_len;
+	uhlen = (tunnel->encap == L2TP_ENCAPTYPE_UDP) ? sizeof(*uh) : 0;
+	headroom = NET_SKB_PAD + sizeof(struct iphdr) + uhlen + session->hdr_len;
 	if (skb_cow_head(skb, headroom)) {
 		kfree_skb(skb);
 		return NET_XMIT_DROP;
@@ -1048,8 +1031,7 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
 
 	/* Reset skb netfilter state */
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
-			      IPSKB_REROUTED);
+	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED | IPSKB_REROUTED);
 	nf_reset_ct(skb);
 
 	bh_lock_sock(sk);
@@ -1069,7 +1051,6 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
 	}
 
 	inet = inet_sk(sk);
-	fl = &inet->cork.fl;
 	switch (tunnel->encap) {
 	case L2TP_ENCAPTYPE_UDP:
 		/* Setup UDP header */
@@ -1097,12 +1078,34 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
 		break;
 	}
 
-	l2tp_xmit_core(session, skb, fl);
+	ret = l2tp_xmit_queue(tunnel, skb, &inet->cork.fl);
+
 out_unlock:
 	bh_unlock_sock(sk);
 
 	return ret;
 }
+
+/* If caller requires the skb to have a ppp header, the header must be
+ * inserted in the skb data before calling this function.
+ */
+int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
+{
+	unsigned int len = skb->len;
+	int ret;
+
+	ret = l2tp_xmit_core(session, skb);
+	if (ret == NET_XMIT_SUCCESS) {
+		atomic_long_inc(&session->tunnel->stats.tx_packets);
+		atomic_long_add(len, &session->tunnel->stats.tx_bytes);
+		atomic_long_inc(&session->stats.tx_packets);
+		atomic_long_add(len, &session->stats.tx_bytes);
+	} else {
+		atomic_long_inc(&session->tunnel->stats.tx_errors);
+		atomic_long_inc(&session->stats.tx_errors);
+	}
+	return ret;
+}
 EXPORT_SYMBOL_GPL(l2tp_xmit_skb);
 
 /*****************************************************************************
-- 
2.17.1

