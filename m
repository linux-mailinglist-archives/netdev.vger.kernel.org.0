Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A02F3718E4
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhECQJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231199AbhECQJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D5F613BB;
        Mon,  3 May 2021 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620058117;
        bh=czfPcq9R6oOqK2Vk4ytm25nIlT5/32c6F4r7/aOO4gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3cnBK2ySiwwdUftoH71ZTHtSV+gu6OBxMuf3moxpWaTGjlfcPAmqUYjZVOsklJ+7
         iVbI/cEb84RRYz3U9S5SdOMYcnmYr1BudsKntqwflAWTNyIQESAQXdgje/4C0GCu1d
         LZT/SJpnt89/TZ8B4GMAhBI931IoUGJ2UjhgdJRY5u5IjIzgv2ahiVF/HQ8hKo+IgO
         rS7lblN6LGaAoWJlBg/YN9Vkd0Y87XdOtldvFujGpRGbXFeTv/T1yRBOfP/yamWrGt
         POiECI8p/1ESjzCLvzd1bc6JVqnLB3wIenlENpyrgObF7Ku/bcZEBPBr8WLR23FUA+
         Zj3YzaO7wbNrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PACTH ethtool-next v3 5/7] ethtool: add nlchk for redirecting to netlink
Date:   Mon,  3 May 2021 09:08:28 -0700
Message-Id: <20210503160830.555241-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503160830.555241-1-kuba@kernel.org>
References: <20210503160830.555241-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support commands which differ from the ioctl implementation
add a new callback which can check if the arguments on the command
line indicate that the request should be sent over netlink.
The decision should be inferred from the arguments, rather
than an explicit --netlink argument.

v3: fix --disable-netlink build

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.c         | 5 ++++-
 netlink/extapi.h  | 6 ++++--
 netlink/netlink.c | 9 +++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 7d2165155f23..0002bb21ad7e 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5620,6 +5620,7 @@ struct option {
 	const char	*opts;
 	bool		no_dev;
 	int		(*func)(struct cmd_context *);
+	nl_chk_t	nlchk;
 	nl_func_t	nlfunc;
 	const char	*help;
 	const char	*xhelp;
@@ -6282,6 +6283,7 @@ int main(int argc, char **argp)
 	int (*func)(struct cmd_context *);
 	struct cmd_context ctx = {};
 	nl_func_t nlfunc = NULL;
+	nl_chk_t nlchk = NULL;
 	bool no_dev;
 	int ret;
 	int k;
@@ -6341,6 +6343,7 @@ int main(int argc, char **argp)
 		argc--;
 		func = args[k].func;
 		nlfunc = args[k].nlfunc;
+		nlchk = args[k].nlchk;
 		no_dev = args[k].no_dev;
 		goto opt_found;
 	}
@@ -6360,7 +6363,7 @@ int main(int argc, char **argp)
 	}
 	ctx.argc = argc;
 	ctx.argp = argp;
-	netlink_run_handler(&ctx, nlfunc, !func);
+	netlink_run_handler(&ctx, nlchk, nlfunc, !func);
 
 	ret = ioctl_init(&ctx, no_dev);
 	if (ret)
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 5cadacce08e8..b4530efae0c3 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -11,11 +11,12 @@ struct cmd_context;
 struct nl_context;
 
 typedef int (*nl_func_t)(struct cmd_context *);
+typedef bool (*nl_chk_t)(struct cmd_context *);
 
 #ifdef ETHTOOL_ENABLE_NETLINK
 
-void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
-			 bool no_fallback);
+void netlink_run_handler(struct cmd_context *ctx, nl_chk_t nlchk,
+			 nl_func_t nlfunc, bool no_fallback);
 
 int nl_gset(struct cmd_context *ctx);
 int nl_sset(struct cmd_context *ctx);
@@ -47,6 +48,7 @@ void nl_monitor_usage(void);
 #else /* ETHTOOL_ENABLE_NETLINK */
 
 static inline void netlink_run_handler(struct cmd_context *ctx __maybe_unused,
+				       nl_chk_t nlchk __maybe_unused,
 				       nl_func_t nlfunc __maybe_unused,
 				       bool no_fallback)
 {
diff --git a/netlink/netlink.c b/netlink/netlink.c
index 54830ae48ce8..ef0d82542327 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -454,14 +454,15 @@ static void netlink_done(struct cmd_context *ctx)
 /**
  * netlink_run_handler() - run netlink handler for subcommand
  * @ctx:         command context
+ * @nlchk:       netlink capability check
  * @nlfunc:      subcommand netlink handler to call
  * @no_fallback: there is no ioctl fallback handler
  *
  * This function returns only if ioctl() handler should be run as fallback.
  * Otherwise it exits with appropriate return code.
  */
-void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
-			 bool no_fallback)
+void netlink_run_handler(struct cmd_context *ctx, nl_chk_t nlchk,
+			 nl_func_t nlfunc, bool no_fallback)
 {
 	bool wildcard = ctx->devname && !strcmp(ctx->devname, WILDCARD_DEVNAME);
 	bool wildcard_unsupported, ioctl_fallback;
@@ -469,6 +470,10 @@ void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
 	const char *reason;
 	int ret;
 
+	if (nlchk && !nlchk(ctx)) {
+		reason = "ioctl-only request";
+		goto no_support;
+	}
 	if (ctx->devname && strlen(ctx->devname) >= ALTIFNAMSIZ) {
 		fprintf(stderr, "device name '%s' longer than %u characters\n",
 			ctx->devname, ALTIFNAMSIZ - 1);
-- 
2.31.1

