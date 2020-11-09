Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6DA2AB842
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgKIMaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:30:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:41022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgKIMaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 07:30:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E416ABDE;
        Mon,  9 Nov 2020 12:30:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 39E9560344; Mon,  9 Nov 2020 13:30:54 +0100 (CET)
Message-Id: <2f9ce041168369105b3734aa3ff6f08bb5600620.1604924742.git.mkubecek@suse.cz>
In-Reply-To: <cover.1604924742.git.mkubecek@suse.cz>
References: <cover.1604924742.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/2] netlink: fix use after free in
 netlink_run_handler()
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, Ivan Vecera <ivecera@redhat.com>
Date:   Mon,  9 Nov 2020 13:30:54 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Valgrind detected use after free in netlink_run_handler(): some members of
struct nl_context are accessed after the netlink context is freed by
netlink_done(). Use local variables to store the two flags and check them
instead.

Fixes: 6c19c0d559c8 ("netlink: use genetlink ops information to decide about fallback")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/netlink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index f655f6ea25b7..aaaabdd3048e 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -457,6 +457,7 @@ void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
 			 bool no_fallback)
 {
 	bool wildcard = ctx->devname && !strcmp(ctx->devname, WILDCARD_DEVNAME);
+	bool wildcard_unsupported, ioctl_fallback;
 	struct nl_context *nlctx;
 	const char *reason;
 	int ret;
@@ -478,14 +479,17 @@ void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
 	nlctx = ctx->nlctx;
 
 	ret = nlfunc(ctx);
+	wildcard_unsupported = nlctx->wildcard_unsupported;
+	ioctl_fallback = nlctx->ioctl_fallback;
 	netlink_done(ctx);
-	if (no_fallback || ret != -EOPNOTSUPP || !nlctx->ioctl_fallback) {
-		if (nlctx->wildcard_unsupported)
+
+	if (no_fallback || ret != -EOPNOTSUPP || !ioctl_fallback) {
+		if (wildcard_unsupported)
 			fprintf(stderr, "%s\n",
 				"subcommand does not support wildcard dump");
 		exit(ret >= 0 ? ret : 1);
 	}
-	if (nlctx->wildcard_unsupported)
+	if (wildcard_unsupported)
 		reason = "subcommand does not support wildcard dump";
 	else
 		reason = "kernel netlink support for subcommand missing";
-- 
2.29.2

