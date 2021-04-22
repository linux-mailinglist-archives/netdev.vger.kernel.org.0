Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3161D368392
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbhDVPln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236487AbhDVPla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:41:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 634E26145B;
        Thu, 22 Apr 2021 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619106055;
        bh=shOi8BaShBs4zJ+AU2a2ivzPf3vLDNF93EiUsHT5vYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWefUTDNYx1RmRbxE3tZDEgA1kEj4Ww6QZ8Y5/FWOGsOBQiI1SjIIj+Y962CwYsuI
         Ka+0H1we5k8XyYuA/lbLAtbjVpSELzg6O57EurCv+LYjXf+33mctpbbtwcOcsHXqe9
         vbMgC0Eyq7hILm7LcyK+4hTKpSB/CD3/KWAd/eV9g8cXRSCHTb12J9I9AqA+pDENIe
         P/0CP7qa81Mm4HKEitJ/q6LH2zkxkNhhthDuh47lWla/Y8w+wMwI+MY+BVJVKghdDB
         Ud+mMFjp+DgW8rZ1o2YH1/8ojOSuzL8/Tau5X5J2JHBMK58jgnTz2utKpXTHkToYUW
         v/4x0Luub1QOg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 5/7] ethtool: add nlchk for redirecting to netlink
Date:   Thu, 22 Apr 2021 08:40:48 -0700
Message-Id: <20210422154050.3339628-6-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422154050.3339628-1-kuba@kernel.org>
References: <20210422154050.3339628-1-kuba@kernel.org>
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
index b01a29bcf069..f4a7d396f487 100644
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
@@ -6270,6 +6271,7 @@ int main(int argc, char **argp)
 	int (*func)(struct cmd_context *);
 	struct cmd_context ctx = {};
 	nl_func_t nlfunc = NULL;
+	nl_chk_t nlchk = NULL;
 	bool no_dev;
 	int ret;
 	int k;
@@ -6329,6 +6331,7 @@ int main(int argc, char **argp)
 		argc--;
 		func = args[k].func;
 		nlfunc = args[k].nlfunc;
+		nlchk = args[k].nlchk;
 		no_dev = args[k].no_dev;
 		goto opt_found;
 	}
@@ -6348,7 +6351,7 @@ int main(int argc, char **argp)
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

