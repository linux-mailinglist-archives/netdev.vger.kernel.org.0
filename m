Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3683EBB41
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhHMRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhHMRUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 491A7610FA;
        Fri, 13 Aug 2021 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875185;
        bh=zG+qyrxHc7C3vCydiAsEVqOoD/bgDwdfLcMKehmrTkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fx4cXuaeLrWDOfS2XSa8nCcxuff4OZLdxmUtS1aixUklc1YXBmrDWllJ+B+Tm7h4h
         nSEBTZZXTnnzpBEcvp9c6TUTOp2yQIypXkNvO7vIxqhGkmeFrP/EWdcbelF1or70iC
         Y9+IE7oyiReBlHETKu9+w24YGtdPWy66EJddyIHm7QW52X7bs47cquA/S7TOVpTlbZ
         fUmjwqxdWBdceNVAiaK2r5YQcsRAI0nXLDMpmJjq5nFQE4+5hvMSti/jUOAwfjA3db
         wmS3IWZZtEzLMpDbUJ3hq11J4SmsXwUN1Bxyq4/mf9qeLyFqljl7/vFn53jV7InC8r
         +9aCwqaR/ysgw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dcavalca@fb.com, filbranden@fb.com,
        michel@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool 2/3] ethtool: use dummy args[] entry for no-args case
Date:   Fri, 13 Aug 2021 10:19:37 -0700
Message-Id: <20210813171938.1127891-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813171938.1127891-1-kuba@kernel.org>
References: <20210813171938.1127891-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code flow further by adding a struct option
entry for the no-args case (e.g. "ethtool eth0").

This leads to a slight change in the help output, there
will now be an extra space between FLAGS and DEVICE in
that case:

  ethtool [ FLAGS ]  DEVNAME	Display standard information about device

but hopefully that's okay.

Note that this patch adds a false-positive warning with GCC 11:

ethtool.c: In function ‘find_option’:
ethtool.c:6082:29: warning: offset ‘1’ outside bounds of constant string [-Warray-bounds]
 6082 |                         opt += len + 1;
      |                         ~~~~^~~~~~~~~~

we'll never get to that code if the string is empty.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 8cf1b13e4176..9e02fe4f09a5 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5627,6 +5627,13 @@ struct option {
 };
 
 static const struct option args[] = {
+	{
+		/* "default" entry when no switch is used */
+		.opts	= "",
+		.func	= do_gset,
+		.nlfunc	= nl_gset,
+		.help	= "Display standard information about device",
+	},
 	{
 		.opts	= "-s|--change",
 		.func	= do_sset,
@@ -6041,10 +6048,7 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
 
 	/* ethtool -h */
 	fprintf(stdout, PACKAGE " version " VERSION "\n");
-	fprintf(stdout,
-		"Usage:\n"
-		"        ethtool [ FLAGS ] DEVNAME\t"
-		"Display standard information about device\n");
+	fprintf(stdout,	"Usage:\n");
 	for (i = 0; args[i].opts; i++) {
 		fputs("        ethtool [ FLAGS ] ", stdout);
 		fprintf(stdout, "%s %s\t%s\n",
@@ -6287,11 +6291,7 @@ static int ioctl_init(struct cmd_context *ctx, bool no_dev)
 
 int main(int argc, char **argp)
 {
-	int (*func)(struct cmd_context *);
 	struct cmd_context ctx = {};
-	nl_func_t nlfunc = NULL;
-	nl_chk_t nlchk = NULL;
-	bool no_dev;
 	int ret;
 	int k;
 
@@ -6345,22 +6345,16 @@ int main(int argc, char **argp)
 		exit_bad_args();
 
 	k = find_option(*argp);
-	if (k >= 0) {
+	if (k > 0) {
 		argp++;
 		argc--;
-		func = args[k].func;
-		nlfunc = args[k].nlfunc;
-		nlchk = args[k].nlchk;
-		no_dev = args[k].no_dev;
 	} else {
 		if ((*argp)[0] == '-')
 			exit_bad_args();
-		nlfunc = nl_gset;
-		func = do_gset;
-		no_dev = false;
+		k = 0;
 	}
 
-	if (!no_dev) {
+	if (!args[k].no_dev) {
 		ctx.devname = *argp++;
 		argc--;
 
@@ -6369,11 +6363,11 @@ int main(int argc, char **argp)
 	}
 	ctx.argc = argc;
 	ctx.argp = argp;
-	netlink_run_handler(&ctx, nlchk, nlfunc, !func);
+	netlink_run_handler(&ctx, args[k].nlchk, args[k].nlfunc, !args[k].func);
 
-	ret = ioctl_init(&ctx, no_dev);
+	ret = ioctl_init(&ctx, args[k].no_dev);
 	if (ret)
 		return ret;
 
-	return func(&ctx);
+	return args[k].func(&ctx);
 }
-- 
2.31.1

