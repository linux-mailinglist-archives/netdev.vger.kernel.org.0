Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D904424EF84
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgHWTkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgHWTk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C1AB3AEC4;
        Sun, 23 Aug 2020 19:40:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2D9CB6030D; Sun, 23 Aug 2020 21:40:27 +0200 (CEST)
Message-Id: <7bf829e6ec7b80b6a4e69cf59f54a36b1934fab9.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 4/9] ioctl: make argc counters unsigned
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:27 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use unsigned int for cmd_context::argc and local variables used for
command line argument count. These counters may never get negative and are
often compared to unsigned expressions.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c  | 24 ++++++++++++------------
 internal.h |  2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 6c12452be7b4..7c7e98957c80 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -223,9 +223,9 @@ static void parse_generic_cmdline(struct cmd_context *ctx,
 				  struct cmdline_info *info,
 				  unsigned int n_info)
 {
-	int argc = ctx->argc;
+	unsigned int argc = ctx->argc;
 	char **argp = ctx->argp;
-	int i, idx;
+	unsigned int i, idx;
 	int found;
 
 	for (i = 0; i < argc; i++) {
@@ -2724,9 +2724,9 @@ static int do_sset(struct cmd_context *ctx)
 	u32 msglvl_wanted = 0;
 	u32 msglvl_mask = 0;
 	struct cmdline_info cmdline_msglvl[n_flags_msglvl];
-	int argc = ctx->argc;
+	unsigned int argc = ctx->argc;
 	char **argp = ctx->argp;
-	int i;
+	unsigned int i;
 	int err = 0;
 
 	for (i = 0; i < n_flags_msglvl; i++)
@@ -3671,7 +3671,7 @@ static int do_grxfh(struct cmd_context *ctx)
 	struct ethtool_rxfh *rss;
 	u32 rss_context = 0;
 	u32 i, indir_bytes;
-	int arg_num = 0;
+	unsigned int arg_num = 0;
 	char *hkey;
 	int err;
 
@@ -4832,9 +4832,8 @@ static int do_gtunable(struct cmd_context *ctx)
 {
 	struct ethtool_tunable_info *tinfo = tunables_info;
 	char **argp = ctx->argp;
-	int argc = ctx->argc;
-	int i;
-	int j;
+	unsigned int argc = ctx->argc;
+	unsigned int i, j;
 
 	if (argc < 1)
 		exit_bad_args();
@@ -4876,7 +4875,7 @@ static int do_gtunable(struct cmd_context *ctx)
 
 static int do_get_phy_tunable(struct cmd_context *ctx)
 {
-	int argc = ctx->argc;
+	unsigned int argc = ctx->argc;
 	char **argp = ctx->argp;
 
 	if (argc < 1)
@@ -4980,9 +4979,9 @@ static int do_reset(struct cmd_context *ctx)
 {
 	struct ethtool_value resetinfo;
 	__u32 data;
-	int argc = ctx->argc;
+	unsigned int argc = ctx->argc;
 	char **argp = ctx->argp;
-	int i;
+	unsigned int i;
 
 	if (argc == 0)
 		exit_bad_args();
@@ -5270,7 +5269,8 @@ static int do_sfec(struct cmd_context *ctx)
 	enum { ARG_NONE, ARG_ENCODING } state = ARG_NONE;
 	struct ethtool_fecparam feccmd;
 	int fecmode = 0, newmode;
-	int rv, i;
+	unsigned int i;
+	int rv;
 
 	for (i = 0; i < ctx->argc; i++) {
 		if (!strcmp(ctx->argp[i], "encoding")) {
diff --git a/internal.h b/internal.h
index 8ae1efab5b5c..d096a28abfa2 100644
--- a/internal.h
+++ b/internal.h
@@ -221,7 +221,7 @@ struct cmd_context {
 	const char *devname;	/* net device name */
 	int fd;			/* socket suitable for ethtool ioctl */
 	struct ifreq ifr;	/* ifreq suitable for ethtool ioctl */
-	int argc;		/* number of arguments to the sub-command */
+	unsigned int argc;	/* number of arguments to the sub-command */
 	char **argp;		/* arguments to the sub-command */
 	unsigned long debug;	/* debugging mask */
 	bool json;		/* Output JSON, if supported */
-- 
2.28.0

