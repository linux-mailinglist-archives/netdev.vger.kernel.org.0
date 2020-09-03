Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3390C25BDEE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgICIzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:08 -0400
Received: from mail.katalix.com ([3.9.82.81]:42248 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgICIzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:06 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 5924786C66;
        Thu,  3 Sep 2020 09:55:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123304; bh=q+EN6yNdO2ne8Wnyn8bu96jTEBPDBqaNhA6uFkKMEjI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=201/6]=20l2tp:=20remo
         ve=20header=20length=20param=20from=20l2tp_xmit_skb|Date:=20Thu,=2
         0=203=20Sep=202020=2009:54:47=20+0100|Message-Id:=20<2020090308545
         2.9487-2-tparkin@katalix.com>|In-Reply-To:=20<20200903085452.9487-
         1-tparkin@katalix.com>|References:=20<20200903085452.9487-1-tparki
         n@katalix.com>;
        b=lTrZqhPrxcKastR7RCHCTNfjdD+qlA0QXKdBT/mybKtVKHkxOlYs4Iuix/Tlbgnfh
         2AaRB47CjNDBcFBgOIwXLLYZhYZ8OCCEzqhlorBTn0f9tFiTcMIau16y29y2pJJsdV
         BZZR/3sapC25e/FHUxTudLto94gmzPvXJ5CrSnUaus5Nm/4XvntMai+f8Iv4CiOibo
         I4j+E2MlAKUFsMuJzRIGZLI/Md2QZRW0QHohX2uXybe7aET4/5mKna3h4wF2UMYPNA
         T6thRD7ns2irQY6GB5xO+jTVRkRAl5eUzPw3yksMS0CXO8BUbYVvg4IUkcjTKFE6fH
         CoIXZhsC1SkDw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 1/6] l2tp: remove header length param from l2tp_xmit_skb
Date:   Thu,  3 Sep 2020 09:54:47 +0100
Message-Id: <20200903085452.9487-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers pass the session structure's hdr_len field as the header
length parameter to l2tp_xmit_skb.

Since we're passing a pointer to the session structure to l2tp_xmit_skb
anyway, there's not much point breaking the header length out as a
separate argument.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 10 +++++-----
 net/l2tp/l2tp_core.h |  3 +--
 net/l2tp/l2tp_eth.c  |  2 +-
 net/l2tp/l2tp_ppp.c  |  4 ++--
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 560c687f5457..c95b58b2ab3c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1017,7 +1017,7 @@ static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
 /* If caller requires the skb to have a ppp header, the header must be
  * inserted in the skb data before calling this function.
  */
-int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len)
+int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb)
 {
 	int data_len = skb->len;
 	struct l2tp_tunnel *tunnel = session->tunnel;
@@ -1035,7 +1035,7 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 	 * make room. Adjust truesize.
 	 */
 	headroom = NET_SKB_PAD + sizeof(struct iphdr) +
-		uhlen + hdr_len;
+		uhlen + session->hdr_len;
 	if (skb_cow_head(skb, headroom)) {
 		kfree_skb(skb);
 		return NET_XMIT_DROP;
@@ -1043,9 +1043,9 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 
 	/* Setup L2TP header */
 	if (tunnel->version == L2TP_HDR_VER_2)
-		l2tp_build_l2tpv2_header(session, __skb_push(skb, hdr_len));
+		l2tp_build_l2tpv2_header(session, __skb_push(skb, session->hdr_len));
 	else
-		l2tp_build_l2tpv3_header(session, __skb_push(skb, hdr_len));
+		l2tp_build_l2tpv3_header(session, __skb_push(skb, session->hdr_len));
 
 	/* Reset skb netfilter state */
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
@@ -1079,7 +1079,7 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 		uh = udp_hdr(skb);
 		uh->source = inet->inet_sport;
 		uh->dest = inet->inet_dport;
-		udp_len = uhlen + hdr_len + data_len;
+		udp_len = uhlen + session->hdr_len + data_len;
 		uh->len = htons(udp_len);
 
 		/* Calculate UDP checksum if configured to do so */
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 07249c5f22ef..5550a42dda04 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -261,8 +261,7 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb);
 
 /* Transmit path helpers for sending packets over the tunnel socket. */
 void l2tp_session_set_header_len(struct l2tp_session *session, int version);
-int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb,
-		  int hdr_len);
+int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb);
 
 /* Pseudowire management.
  * Pseudowires should register with l2tp core on module init, and unregister
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 657edad1263e..6cd97c75445c 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -76,7 +76,7 @@ static netdev_tx_t l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev
 	struct l2tp_eth *priv = netdev_priv(dev);
 	struct l2tp_session *session = priv->session;
 	unsigned int len = skb->len;
-	int ret = l2tp_xmit_skb(session, skb, session->hdr_len);
+	int ret = l2tp_xmit_skb(session, skb);
 
 	if (likely(ret == NET_XMIT_SUCCESS)) {
 		atomic_long_add(len, &priv->tx_bytes);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 450637ffa557..998e0c6abf25 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -316,7 +316,7 @@ static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
 	}
 
 	local_bh_disable();
-	l2tp_xmit_skb(session, skb, session->hdr_len);
+	l2tp_xmit_skb(session, skb);
 	local_bh_enable();
 
 	sock_put(sk);
@@ -375,7 +375,7 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	skb->data[1] = PPP_UI;
 
 	local_bh_disable();
-	l2tp_xmit_skb(session, skb, session->hdr_len);
+	l2tp_xmit_skb(session, skb);
 	local_bh_enable();
 
 	sock_put(sk);
-- 
2.17.1

