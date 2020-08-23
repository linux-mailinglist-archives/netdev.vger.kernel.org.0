Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA98724EF85
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHWTke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:50778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgHWTkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C73CCAEB1;
        Sun, 23 Aug 2020 19:40:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 332606030D; Sun, 23 Aug 2020 21:40:30 +0200 (CEST)
Message-Id: <92e8bbdd5149635334f7fb0f716a29cbadeb917f.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 5/9] ioctl: get rid of signed/unsigned comparison
 warnings
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:30 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comparison between signed and unsigned values is fragile and causes
compiler warnings with recent compilers and stricter CFLAGS. Prevent such
comparisons either by properly declaring variables (mostly loop iterators)
as unsigned or by explicitly casting one side of the comparison.

v2: rework argc related changes and split them into a separate patch

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 7c7e98957c80..3c30824016d5 100644
--- a/ethtool.c
+++ b/ethtool.c
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
@@ -3869,7 +3871,7 @@ static int do_srxfh(struct cmd_context *ctx)
 	char *hfunc_name = NULL;
 	char *hkey = NULL;
 	int err = 0;
-	int i;
+	unsigned int i;
 	u32 arg_num = 0, indir_bytes = 0;
 	u32 req_hfunc = 0;
 	u32 entry_size = sizeof(rss_head.rss_config[0]);
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
-- 
2.28.0

