Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A342287A3
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730818AbgGURmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgGURlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:02 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FD02C0619DC
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:02 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 25A3393AFC;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=R0kRdMxgVXikgks+AHOxXVmgUdx3JpMmrDmIRfLbakE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2013/29]=20l2tp:=20avoid=20multiple=20assignments|Date:=20Tue,
         =2021=20Jul=202020=2018:32:05=20+0100|Message-Id:=20<2020072117322
         1.4681-14-tparkin@katalix.com>|In-Reply-To:=20<20200721173221.4681
         -1-tparkin@katalix.com>|References:=20<20200721173221.4681-1-tpark
         in@katalix.com>;
        b=wlmGb8q8PrmYfGm8wSpBfNBl54nL7PzFnmrzSFH0S7n2eHmEFqjF9t0At/IEu374Q
         VPthA7kFW22co51AsOM3j2EXnm16i8HmENaBLmJuAa+QGtG1daGlAHMNZydqw8p5FW
         PxdWQ7N29qoKGdjFbqwtuOVt3R++OcFCdBvmwoCXjr/1KCTEF1fgEuDl24WSHArFLv
         hkUqDztHZCNYjWg4Tv6Fig/8MjlGNSZZKx6yu5BkgLmBsJN6tkk5gblyoCEG10nnz+
         29zthNTqEOjzwsRVSVxTUMW1d0iFYEJqmBSo9QkvaYL7kGNyYeQanl4v63SCNyeCeQ
         HY4U7z0JBgbbA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 13/29] l2tp: avoid multiple assignments
Date:   Tue, 21 Jul 2020 18:32:05 +0100
Message-Id: <20200721173221.4681-14-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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
index acba7757bd79..7218925edbf2 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -619,8 +619,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      int length)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
+	u32 ns = 0, nr = 0;
 	int offset;
-	u32 ns, nr;
 
 	/* Parse and check optional cookie */
 	if (session->peer_cookie_len > 0) {
@@ -642,7 +642,6 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	 * the control of the LNS.  If no sequence numbers present but
 	 * we were expecting them, discard frame.
 	 */
-	ns = nr = 0;
 	L2TP_SKB_CB(skb)->has_seq = 0;
 	if (tunnel->version == L2TP_HDR_VER_2) {
 		if (hdrflags & L2TP_HDRFLAG_S) {
@@ -824,7 +823,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
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

