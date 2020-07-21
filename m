Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B4228796
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgGURlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbgGURlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B272C0619DC
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E84F193AC4;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352782; bh=RRQyIjEJR8DQzt1Xh4uOhEHXAPiUnf9Iy9AoI7ULbd8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2019/29]=20l2tp:=20use=20a=20function=20to=20render=20tunnel=2
         0address=20in=20l2tp_debugfs|Date:=20Tue,=2021=20Jul=202020=2018:3
         2:11=20+0100|Message-Id:=20<20200721173221.4681-20-tparkin@katalix
         .com>|In-Reply-To:=20<20200721173221.4681-1-tparkin@katalix.com>|R
         eferences:=20<20200721173221.4681-1-tparkin@katalix.com>;
        b=1+kwjc+zBgZGhBqlyp1eMD4crRlDE2LzgV3aCy4fjbywHsGAKxl6xwLZfQ9V+JTXp
         JZU7yecU45DG+gvCOxfUE7Xk2kmh+URa5NTieyFC+pavVd6HQlvPjX6EZfc3JGS0d6
         4MS0zud4/RQZaHOv/FEPeKCZ4TREycZFaQH+HnmjuaGcp5sTxv1zB6iKoviQv3RPRo
         X+aXUOD8hYnDSwsAWTT8DJmJNnALg7zwIjG+9QxaQ6SSPSUpHCFnYqyMBoWh1W7b68
         prDXFyR8/zz6+btimE/ROyYz5RnyeH4a9ADBNBmQwejyp/XJX26aXVeGs/nrQgeQv+
         g8FwhXVftCePw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 19/29] l2tp: use a function to render tunnel address in l2tp_debugfs
Date:   Tue, 21 Jul 2020 18:32:11 +0100
Message-Id: <20200721173221.4681-20-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The L2TP tunnel socket address may be IPv4 or IPv6.

The conditionally compiled code for IPv6 support confused checkpatch's
indentation and brace checking.

To avoid the warning, and make the code somewhat easier to read, split
the address rendering out into a function where the conditional
compilation can be handled more cleanly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_debugfs.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 800a17b988be..d8cddc82da4b 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -121,6 +121,25 @@ static void l2tp_dfs_seq_stop(struct seq_file *p, void *v)
 	}
 }
 
+static void l2tp_dfs_seq_tunnel_show_addr(struct seq_file *m, struct l2tp_tunnel *tunnel)
+{
+	struct inet_sock *inet = inet_sk(tunnel->sock);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (tunnel->sock->sk_family == AF_INET6) {
+		const struct ipv6_pinfo *np = inet6_sk(tunnel->sock);
+
+		seq_printf(m, " from %pI6c to %pI6c\n", &np->saddr, &tunnel->sock->sk_v6_daddr);
+	}
+#endif
+	if (tunnel->sock->sk_family == AF_INET)
+		seq_printf(m, " from %pI4 to %pI4\n", &inet->inet_saddr, &inet->inet_daddr);
+
+	if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
+		seq_printf(m, " source port %hu, dest port %hu\n",
+			   ntohs(inet->inet_sport), ntohs(inet->inet_dport));
+}
+
 static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 {
 	struct l2tp_tunnel *tunnel = v;
@@ -144,23 +163,8 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 	read_unlock_bh(&tunnel->hlist_lock);
 
 	seq_printf(m, "\nTUNNEL %u peer %u", tunnel->tunnel_id, tunnel->peer_tunnel_id);
-	if (tunnel->sock) {
-		struct inet_sock *inet = inet_sk(tunnel->sock);
-
-#if IS_ENABLED(CONFIG_IPV6)
-		if (tunnel->sock->sk_family == AF_INET6) {
-			const struct ipv6_pinfo *np = inet6_sk(tunnel->sock);
-
-			seq_printf(m, " from %pI6c to %pI6c\n",
-				   &np->saddr, &tunnel->sock->sk_v6_daddr);
-		} else
-#endif
-		seq_printf(m, " from %pI4 to %pI4\n",
-			   &inet->inet_saddr, &inet->inet_daddr);
-		if (tunnel->encap == L2TP_ENCAPTYPE_UDP)
-			seq_printf(m, " source port %hu, dest port %hu\n",
-				   ntohs(inet->inet_sport), ntohs(inet->inet_dport));
-	}
+	if (tunnel->sock)
+		l2tp_dfs_seq_tunnel_show_addr(m, tunnel);
 	seq_printf(m, " L2TPv%d, %s\n", tunnel->version,
 		   tunnel->encap == L2TP_ENCAPTYPE_UDP ? "UDP" :
 		   tunnel->encap == L2TP_ENCAPTYPE_IP ? "IP" :
-- 
2.17.1

