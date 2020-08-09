Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADFB240025
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgHIVY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:24:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:57492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgHIVY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 17:24:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EB0C6ABE9
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 21:24:45 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id F38557F447; Sun,  9 Aug 2020 23:24:25 +0200 (CEST)
Message-Id: <0365573afe3649e47c1aa2490e1818a50613ee0a.1597007533.git.mkubecek@suse.cz>
In-Reply-To: <cover.1597007532.git.mkubecek@suse.cz>
References: <cover.1597007532.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 3/7] ioctl: get rid of signed/unsigned comparison
 warnings
To:     netdev@vger.kernel.org
Date:   Sun,  9 Aug 2020 23:24:25 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comparison between signed and unsigned values is fragile and causes
compiler warnings with recent compilers and stricter CFLAGS. Prevent such
comparisons either by properly declaring variables (mostly loop iterators)
as unsigned or by explicitly casting one side of the comparison.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 4fa7a2c1716f..d9dcd0448c02 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -225,8 +225,8 @@ static void parse_generic_cmdline(struct cmd_context *ctx,
 {
 	int argc = ctx->argc;
 	char **argp = ctx->argp;
-	int i, idx;
-	int found;
+	unsigned int idx;
+	int i, found;
 
 	for (i = 0; i < argc; i++) {
 		found = 0;
@@ -641,8 +641,9 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "200000baseCR4/Full" },
 	};
 	int indent;
-	int did1, new_line_pend, i;
+	int did1, new_line_pend;
 	int fecreported = 0;
+	unsigned int i;
 
 	/* Indent just like the separate functions used to */
 	indent = strlen(prefix) + 14;
@@ -1071,7 +1072,7 @@ void dump_hex(FILE *file, const u8 *data, int len, int offset)
 static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
 		     struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 {
-	int i;
+	unsigned int i;
 
 	if (gregs_dump_raw) {
 		fwrite(regs->data, regs->len, 1, stdout);
@@ -1128,7 +1129,8 @@ static int dump_eeprom(int geeprom_dump_raw,
 static int dump_test(struct ethtool_test *test,
 		     struct ethtool_gstrings *strings)
 {
-	int i, rc;
+	unsigned int i;
+	int rc;
 
 	rc = test->flags & ETH_TEST_FL_FAILED;
 	fprintf(stdout, "The test result is %s\n", rc ? "FAIL" : "PASS");
@@ -1359,7 +1361,7 @@ static void dump_one_feature(const char *indent, const char *name,
 	       : "");
 }
 
-static int linux_version_code(void)
+static unsigned int linux_version_code(void)
 {
 	struct utsname utsname;
 	unsigned version, patchlevel, sublevel = 0;
@@ -1375,10 +1377,10 @@ static void dump_features(const struct feature_defs *defs,
 			  const struct feature_state *state,
 			  const struct feature_state *ref_state)
 {
-	int kernel_ver = linux_version_code();
-	u32 value;
+	unsigned int kernel_ver = linux_version_code();
+	unsigned int i, j;
 	int indent;
-	int i, j;
+	u32 value;
 
 	for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
 		/* Don't show features whose state is unknown on this
@@ -1411,7 +1413,7 @@ static void dump_features(const struct feature_defs *defs,
 
 		/* Show matching features */
 		for (j = 0; j < defs->n_features; j++) {
-			if (defs->def[j].off_flag_index != i)
+			if (defs->def[j].off_flag_index != (int)i)
 				continue;
 			if (defs->off_flag_matched[i] != 1)
 				/* Show all matching feature states */
@@ -1668,8 +1670,8 @@ static struct feature_defs *get_feature_defs(struct cmd_context *ctx)
 {
 	struct ethtool_gstrings *names;
 	struct feature_defs *defs;
+	unsigned int i, j;
 	u32 n_features;
-	int i, j;
 
 	names = get_stringset(ctx, ETH_SS_FEATURES, 0, 1);
 	if (names) {
@@ -2236,8 +2238,8 @@ static int do_sfeatures(struct cmd_context *ctx)
 	struct cmdline_info *cmdline_features;
 	struct feature_state *old_state, *new_state;
 	struct ethtool_value eval;
+	unsigned int i, j;
 	int err, rc;
-	int i, j;
 
 	defs = get_feature_defs(ctx);
 	if (!defs) {
@@ -2317,7 +2319,7 @@ static int do_sfeatures(struct cmd_context *ctx)
 				continue;
 
 			for (j = 0; j < defs->n_features; j++) {
-				if (defs->def[j].off_flag_index != i ||
+				if (defs->def[j].off_flag_index != (int)i ||
 				    !FEATURE_BIT_IS_SET(
 					    old_state->features.features,
 					    j, available) ||
@@ -2724,9 +2726,9 @@ static int do_sset(struct cmd_context *ctx)
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
@@ -3869,7 +3871,7 @@ static int do_srxfh(struct cmd_context *ctx)
 	char *hfunc_name = NULL;
 	char *hkey = NULL;
 	int err = 0;
-	int i;
+	unsigned int i;
 	u32 arg_num = 0, indir_bytes = 0;
 	u32 req_hfunc = 0;
 	u32 entry_size = sizeof(rss_head.rss_config[0]);
@@ -3880,7 +3882,7 @@ static int do_srxfh(struct cmd_context *ctx)
 	if (ctx->argc < 1)
 		exit_bad_args();
 
-	while (arg_num < ctx->argc) {
+	while (arg_num < (unsigned int)ctx->argc) {
 		if (!strcmp(ctx->argp[arg_num], "equal")) {
 			++arg_num;
 			rxfhindir_equal = get_int_range(ctx->argp[arg_num],
@@ -3894,7 +3896,7 @@ static int do_srxfh(struct cmd_context *ctx)
 		} else if (!strcmp(ctx->argp[arg_num], "weight")) {
 			++arg_num;
 			rxfhindir_weight = ctx->argp + arg_num;
-			while (arg_num < ctx->argc &&
+			while (arg_num < (unsigned int)ctx->argc &&
 			       isdigit((unsigned char)ctx->argp[arg_num][0])) {
 				++arg_num;
 				++num_weights;
@@ -4135,7 +4137,8 @@ static int do_flash(struct cmd_context *ctx)
 
 static int do_permaddr(struct cmd_context *ctx)
 {
-	int i, err;
+	unsigned int i;
+	int err;
 	struct ethtool_perm_addr *epaddr;
 
 	epaddr = malloc(sizeof(struct ethtool_perm_addr) + MAX_ADDR_LEN);
@@ -4750,7 +4753,7 @@ static int do_stunable(struct cmd_context *ctx)
 	struct cmdline_info cmdline_tunable[TUNABLES_INFO_SIZE];
 	struct ethtool_tunable_info *tinfo = tunables_info;
 	int changed = 0;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < TUNABLES_INFO_SIZE; i++) {
 		cmdline_tunable[i].name = tunable_strings[tinfo[i].t_id];
@@ -4833,8 +4836,8 @@ static int do_gtunable(struct cmd_context *ctx)
 	struct ethtool_tunable_info *tinfo = tunables_info;
 	char **argp = ctx->argp;
 	int argc = ctx->argc;
+	unsigned int j;
 	int i;
-	int j;
 
 	if (argc < 1)
 		exit_bad_args();
-- 
2.28.0

