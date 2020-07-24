Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC9122C94E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGXPcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGXPcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:32:06 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D33C7C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:32:05 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id DFFD98AD92;
        Fri, 24 Jul 2020 16:32:04 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=n4ErZG1al9W3VkTjlBOk+Fzuxshktb2qVg0TxsmzzZ8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=201/9]=20l2tp:=20avoid=20multipl
         e=20assignments|Date:=20Fri,=2024=20Jul=202020=2016:31:49=20+0100|
         Message-Id:=20<20200724153157.9366-2-tparkin@katalix.com>|In-Reply
         -To:=20<20200724153157.9366-1-tparkin@katalix.com>|References:=20<
         20200724153157.9366-1-tparkin@katalix.com>;
        b=P47bgQU7r7qyUztJW+AdUBCR+DLhGCnu31yn3xb/gxC25huMa5eHz7lz6FFp3Ai3m
         0XFmKLCH4ipBVfbngZBHqzxixtRPKPxGqs7iSjx6uvoBKWdC1l29jWlMbe8M5VW6qS
         aWqJd/Fp20kQ3D6r9wniTyF46FW0xSaoAd8PzFw/jeCMVzmbXGsoYBTFJRF28BRC4r
         bIfjB5ppcULjYmF0vIa/Uq4WuLo263/TZNqcnNMsWCthSRT8drIz3JcL5y47oqYPhq
         Kc4zo3c5QtIlYcNLFeUy4qg/VssNVRotz79kPWslu05yGP7GKNpi/nRN43sB9IjqlT
         BfU1/amZb8WdQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 1/9] l2tp: avoid multiple assignments
Date:   Fri, 24 Jul 2020 16:31:49 +0100
Message-Id: <20200724153157.9366-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warns about multiple assignments.

Update l2tp accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c |  6 +++---
 net/l2tp/l2tp_ip.c   | 12 ++++++++----
 net/l2tp/l2tp_ip6.c  |  6 ++++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7e3523015d6f..b871cceeff7c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -621,8 +621,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      int length)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
+	u32 ns = 0, nr = 0;
 	int offset;
-	u32 ns, nr;
 
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
@@ -644,7 +644,6 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	 * the control of the LNS.  If no sequence numbers present but
 	 * we were expecting them, discard frame.
 	 */
-	ns = nr = 0;
 	L2TP_SKB_CB(skb)->has_seq = 0;
 	if (tunnel->version == L2TP_HDR_VER_2) {
 		if (hdrflags & L2TP_HDRFLAG_S) {
@@ -826,7 +825,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	}
 
 	/* Point to L2TP header */
-	optr = ptr = skb->data;
+	optr = skb->data;
+	ptr = skb->data;
 
 	/* Get L2TP header flags */
 	hdrflags = ntohs(*(__be16 *)ptr);
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index d81564cf1e7f..a159cb2bf0f4 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -124,7 +124,8 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 		goto discard;
 
 	/* Point to L2TP header */
-	optr = ptr = skb->data;
+	optr = skb->data;
+	ptr = skb->data;
 	session_id = ntohl(*((__be32 *)ptr));
 	ptr += 4;
 
@@ -153,7 +154,8 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 			goto discard_sess;
 
 		/* Point to L2TP header */
-		optr = ptr = skb->data;
+		optr = skb->data;
+		ptr = skb->data;
 		ptr += 4;
 		pr_debug("%s: ip recv\n", tunnel->name);
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, ptr, length);
@@ -284,8 +286,10 @@ static int l2tp_ip_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	    chk_addr_ret != RTN_MULTICAST && chk_addr_ret != RTN_BROADCAST)
 		goto out;
 
-	if (addr->l2tp_addr.s_addr)
-		inet->inet_rcv_saddr = inet->inet_saddr = addr->l2tp_addr.s_addr;
+	if (addr->l2tp_addr.s_addr) {
+		inet->inet_rcv_saddr = addr->l2tp_addr.s_addr;
+		inet->inet_saddr = addr->l2tp_addr.s_addr;
+	}
 	if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
 		inet->inet_saddr = 0;  /* Use device */
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 614febf8dd0d..bc757bc7e264 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -137,7 +137,8 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 		goto discard;
 
 	/* Point to L2TP header */
-	optr = ptr = skb->data;
+	optr = skb->data;
+	ptr = skb->data;
 	session_id = ntohl(*((__be32 *)ptr));
 	ptr += 4;
 
@@ -166,7 +167,8 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 			goto discard_sess;
 
 		/* Point to L2TP header */
-		optr = ptr = skb->data;
+		optr = skb->data;
+		ptr = skb->data;
 		ptr += 4;
 		pr_debug("%s: ip recv\n", tunnel->name);
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, ptr, length);
-- 
2.17.1

