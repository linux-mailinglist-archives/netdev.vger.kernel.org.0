Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E773C2AB843
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgKIMa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:30:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:41180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgKIMa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 07:30:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73F76ABDE;
        Mon,  9 Nov 2020 12:30:57 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3F19E60344; Mon,  9 Nov 2020 13:30:57 +0100 (CET)
Message-Id: <2e9c1ddf2de785c168ad8e8906f3e2fd0f1f95e2.1604924742.git.mkubecek@suse.cz>
In-Reply-To: <cover.1604924742.git.mkubecek@suse.cz>
References: <cover.1604924742.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 2/2] netlink: fix leaked instances of struct nl_socket
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, Ivan Vecera <ivecera@redhat.com>
Date:   Mon,  9 Nov 2020 13:30:57 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Valgrind detected memory leaks caused by missing cleanup of netlink
context's ethnl_socket, ethnl2_socket and rtnl_socket. Also, contrary to
its description, nlsock_done() does not free struct nl_socket itself.
Fix nlsock_done() to free the structure and use it to dispose of sockets
pointed to by struct nl_context members.

Fixes: 50efb3cdd2bb ("netlink: netlink socket wrapper and helpers")
Fixes: 87307c30724d ("netlink: initialize ethtool netlink socket")
Fixes: 7f3585b22a4b ("netlink: add handler for permaddr (-P)")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/netlink.c | 11 ++++++++---
 netlink/nlsock.c  |  3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index aaaabdd3048e..ffe06339f099 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -435,11 +435,16 @@ out_free:
 
 static void netlink_done(struct cmd_context *ctx)
 {
-	if (!ctx->nlctx)
+	struct nl_context *nlctx = ctx->nlctx;
+
+	if (!nlctx)
 		return;
 
-	free(ctx->nlctx->ops_info);
-	free(ctx->nlctx);
+	nlsock_done(nlctx->ethnl_socket);
+	nlsock_done(nlctx->ethnl2_socket);
+	nlsock_done(nlctx->rtnl_socket);
+	free(nlctx->ops_info);
+	free(nlctx);
 	ctx->nlctx = NULL;
 	cleanup_all_strings();
 }
diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index ef31d8c33b29..0ec2738d81d2 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -395,8 +395,11 @@ out_msgbuff:
  */
 void nlsock_done(struct nl_socket *nlsk)
 {
+	if (!nlsk)
+		return;
 	if (nlsk->sk)
 		mnl_socket_close(nlsk->sk);
 	msgbuff_done(&nlsk->msgbuff);
 	memset(nlsk, '\0', sizeof(*nlsk));
+	free(nlsk);
 }
-- 
2.29.2

