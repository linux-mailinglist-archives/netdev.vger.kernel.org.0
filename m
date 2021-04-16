Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036A036251C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 18:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhDPQDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 12:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236319AbhDPQDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 12:03:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E966613C5;
        Fri, 16 Apr 2021 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618588975;
        bh=8z5lKHCm0f7+e0op8ccRiy6NP6vudR1KwrTluU8fwFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcExsPtzpaAPVscNiNvVrU9qxaoaJh2qKfeCq9iliKomOerJDbtUEN3eNyI154h/D
         DyPz0dolR9mtjj0F2/v8lEBrCCCk5XO7sYtdubu7xAXxyvq3tOYUGtoFoPu0H+6FHY
         pWvpUZJAEwr/4rj/OKE9RLneVs+uNJ7CYRB84Tr8/q4SJ5UOKsVjNn9WUvjX2maPP0
         jaElrfXvuFi/l3xQXHzFLrAmq5OUcdVuaeI64fXdDPGZrOITN0J8HwBHUxHXy9wW0U
         Mao5E5mFZGTRXSYa1nyopouVuh2AzYs/zWhMgd5OK7gRijZO1U+/Men5TZSr4HpayM
         JHpzmH/bFFvoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, idosch@nvidia.com
Cc:     mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC ethtool 5/6] ethtool: add nlchk for redirecting to netlink
Date:   Fri, 16 Apr 2021 09:02:51 -0700
Message-Id: <20210416160252.2830567-6-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416160252.2830567-1-kuba@kernel.org>
References: <20210416160252.2830567-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.c         | 5 ++++-
 netlink/extapi.h  | 5 +++--
 netlink/netlink.c | 9 +++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 0933bc02ce5e..b07fd9292d77 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5608,6 +5608,7 @@ struct option {
 	const char	*opts;
 	bool		no_dev;
 	int		(*func)(struct cmd_context *);
+	nl_chk_t	nlchk;
 	nl_func_t	nlfunc;
 	const char	*help;
 	const char	*xhelp;
@@ -6269,6 +6270,7 @@ int main(int argc, char **argp)
 	int (*func)(struct cmd_context *);
 	struct cmd_context ctx = {};
 	nl_func_t nlfunc = NULL;
+	nl_chk_t nlchk = NULL;
 	bool no_dev;
 	int ret;
 	int k;
@@ -6328,6 +6330,7 @@ int main(int argc, char **argp)
 		argc--;
 		func = args[k].func;
 		nlfunc = args[k].nlfunc;
+		nlchk = args[k].nlchk;
 		no_dev = args[k].no_dev;
 		goto opt_found;
 	}
@@ -6347,7 +6350,7 @@ int main(int argc, char **argp)
 	}
 	ctx.argc = argc;
 	ctx.argp = argp;
-	netlink_run_handler(&ctx, nlfunc, !func);
+	netlink_run_handler(&ctx, nlchk, nlfunc, !func);
 
 	ret = ioctl_init(&ctx, no_dev);
 	if (ret)
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 5cadacce08e8..d6036a39e920 100644
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
diff --git a/netlink/netlink.c b/netlink/netlink.c
index ffe06339f099..4cee9b23b28f 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -452,14 +452,15 @@ static void netlink_done(struct cmd_context *ctx)
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
@@ -467,6 +468,10 @@ void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
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
2.30.2

