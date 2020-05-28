Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094D61E7047
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437530AbgE1XWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437509AbgE1XVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AFBB7AFEF;
        Thu, 28 May 2020 23:21:42 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CD5ABE32D2; Fri, 29 May 2020 01:21:42 +0200 (CEST)
Message-Id: <75c256f1009f9b6e1a0402343c7780103f01ae4b.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 07/21] netlink: add netlink handler for gfeatures (-k)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:42 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -k <dev>" subcommand using ETHTOOL_MSG_FEATURES_GET
netlink message. This retrieves and displays names and values of netdev
feature flags, traditionally provided by ioctl request ETHTOOL_GFEATURES
(and some older ones).

Unlike ioctl, the netlink code does not query kernel for values of legacy
flags (ETH_FLAG_*) and computes their value from features grouped under
such flag instead so that it can get slightly different results than ioctl
implementation in cases where some new feature is not considered by kernel
code (kernel fix is going to be submitted soon).

This commit also registers the callback with monitor code so that the
monitor can display ETHTOOL_MSG_FEATURES_NTF notifications.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am        |   1 +
 common.c           |  30 ++++++
 common.h           |  19 ++++
 ethtool.c          |  65 ++----------
 netlink/bitset.c   |  18 ++++
 netlink/bitset.h   |   1 +
 netlink/extapi.h   |   2 +
 netlink/features.c | 241 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/monitor.c  |   8 ++
 netlink/netlink.h  |   1 +
 10 files changed, 331 insertions(+), 55 deletions(-)
 create mode 100644 netlink/features.c

diff --git a/Makefile.am b/Makefile.am
index b3ffae52f1e9..36ee50a9dd0c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,6 +31,7 @@ ethtool_SOURCES += \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
+		  netlink/features.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/common.c b/common.c
index f9c41a32d3a3..2630e73aa601 100644
--- a/common.c
+++ b/common.c
@@ -47,6 +47,36 @@ const struct flag_info flags_msglvl[] = {
 };
 const unsigned int n_flags_msglvl = ARRAY_SIZE(flags_msglvl) - 1;
 
+const struct off_flag_def off_flag_def[] = {
+	{ "rx",     "rx-checksumming",		    "rx-checksum",
+	  ETHTOOL_GRXCSUM, ETHTOOL_SRXCSUM, ETH_FLAG_RXCSUM,	0 },
+	{ "tx",     "tx-checksumming",		    "tx-checksum-*",
+	  ETHTOOL_GTXCSUM, ETHTOOL_STXCSUM, ETH_FLAG_TXCSUM,	0 },
+	{ "sg",     "scatter-gather",		    "tx-scatter-gather*",
+	  ETHTOOL_GSG,	   ETHTOOL_SSG,     ETH_FLAG_SG,	0 },
+	{ "tso",    "tcp-segmentation-offload",	    "tx-tcp*-segmentation",
+	  ETHTOOL_GTSO,	   ETHTOOL_STSO,    ETH_FLAG_TSO,	0 },
+	{ "ufo",    "udp-fragmentation-offload",    "tx-udp-fragmentation",
+	  ETHTOOL_GUFO,	   ETHTOOL_SUFO,    ETH_FLAG_UFO,	0 },
+	{ "gso",    "generic-segmentation-offload", "tx-generic-segmentation",
+	  ETHTOOL_GGSO,	   ETHTOOL_SGSO,    ETH_FLAG_GSO,	0 },
+	{ "gro",    "generic-receive-offload",	    "rx-gro",
+	  ETHTOOL_GGRO,	   ETHTOOL_SGRO,    ETH_FLAG_GRO,	0 },
+	{ "lro",    "large-receive-offload",	    "rx-lro",
+	  0,		   0,		    ETH_FLAG_LRO,
+	  KERNEL_VERSION(2,6,24) },
+	{ "rxvlan", "rx-vlan-offload",		    "rx-vlan-hw-parse",
+	  0,		   0,		    ETH_FLAG_RXVLAN,
+	  KERNEL_VERSION(2,6,37) },
+	{ "txvlan", "tx-vlan-offload",		    "tx-vlan-hw-insert",
+	  0,		   0,		    ETH_FLAG_TXVLAN,
+	  KERNEL_VERSION(2,6,37) },
+	{ "ntuple", "ntuple-filters",		    "rx-ntuple-filter",
+	  0,		   0,		    ETH_FLAG_NTUPLE,	0 },
+	{ "rxhash", "receive-hashing",		    "rx-hashing",
+	  0,		   0,		    ETH_FLAG_RXHASH,	0 },
+};
+
 void print_flags(const struct flag_info *info, unsigned int n_info, u32 value)
 {
 	const char *sep = "";
diff --git a/common.h b/common.h
index 3a680114a7c2..b74fdfa030b3 100644
--- a/common.h
+++ b/common.h
@@ -19,6 +19,25 @@ struct flag_info {
 extern const struct flag_info flags_msglvl[];
 extern const unsigned int n_flags_msglvl;
 
+struct off_flag_def {
+	const char *short_name;
+	const char *long_name;
+	const char *kernel_name;
+	u32 get_cmd, set_cmd;
+	u32 value;
+	/* For features exposed through ETHTOOL_GFLAGS, the oldest
+	 * kernel version for which we can trust the result.  Where
+	 * the flag was added at the same time the kernel started
+	 * supporting the feature, this is 0 (to allow for backports).
+	 * Where the feature was supported before the flag was added,
+	 * it is the version that introduced the flag.
+	 */
+	u32 min_kernel_ver;
+};
+
+#define OFF_FLAG_DEF_SIZE 12
+extern const struct off_flag_def off_flag_def[OFF_FLAG_DEF_SIZE];
+
 void print_flags(const struct flag_info *info, unsigned int n_info, u32 value);
 int dump_wol(struct ethtool_wolinfo *wol);
 void dump_mdix(u8 mdix, u8 mdix_ctrl);
diff --git a/ethtool.c b/ethtool.c
index 900880aff8d6..4749f3ae52a5 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -102,51 +102,6 @@ struct cmdline_info {
 	void *seen_val;
 };
 
-struct off_flag_def {
-	const char *short_name;
-	const char *long_name;
-	const char *kernel_name;
-	u32 get_cmd, set_cmd;
-	u32 value;
-	/* For features exposed through ETHTOOL_GFLAGS, the oldest
-	 * kernel version for which we can trust the result.  Where
-	 * the flag was added at the same time the kernel started
-	 * supporting the feature, this is 0 (to allow for backports).
-	 * Where the feature was supported before the flag was added,
-	 * it is the version that introduced the flag.
-	 */
-	u32 min_kernel_ver;
-};
-static const struct off_flag_def off_flag_def[] = {
-	{ "rx",     "rx-checksumming",		    "rx-checksum",
-	  ETHTOOL_GRXCSUM, ETHTOOL_SRXCSUM, ETH_FLAG_RXCSUM,	0 },
-	{ "tx",     "tx-checksumming",		    "tx-checksum-*",
-	  ETHTOOL_GTXCSUM, ETHTOOL_STXCSUM, ETH_FLAG_TXCSUM,	0 },
-	{ "sg",     "scatter-gather",		    "tx-scatter-gather*",
-	  ETHTOOL_GSG,	   ETHTOOL_SSG,     ETH_FLAG_SG,	0 },
-	{ "tso",    "tcp-segmentation-offload",	    "tx-tcp*-segmentation",
-	  ETHTOOL_GTSO,	   ETHTOOL_STSO,    ETH_FLAG_TSO,	0 },
-	{ "ufo",    "udp-fragmentation-offload",    "tx-udp-fragmentation",
-	  ETHTOOL_GUFO,	   ETHTOOL_SUFO,    ETH_FLAG_UFO,	0 },
-	{ "gso",    "generic-segmentation-offload", "tx-generic-segmentation",
-	  ETHTOOL_GGSO,	   ETHTOOL_SGSO,    ETH_FLAG_GSO,	0 },
-	{ "gro",    "generic-receive-offload",	    "rx-gro",
-	  ETHTOOL_GGRO,	   ETHTOOL_SGRO,    ETH_FLAG_GRO,	0 },
-	{ "lro",    "large-receive-offload",	    "rx-lro",
-	  0,		   0,		    ETH_FLAG_LRO,
-	  KERNEL_VERSION(2,6,24) },
-	{ "rxvlan", "rx-vlan-offload",		    "rx-vlan-hw-parse",
-	  0,		   0,		    ETH_FLAG_RXVLAN,
-	  KERNEL_VERSION(2,6,37) },
-	{ "txvlan", "tx-vlan-offload",		    "tx-vlan-hw-insert",
-	  0,		   0,		    ETH_FLAG_TXVLAN,
-	  KERNEL_VERSION(2,6,37) },
-	{ "ntuple", "ntuple-filters",		    "rx-ntuple-filter",
-	  0,		   0,		    ETH_FLAG_NTUPLE,	0 },
-	{ "rxhash", "receive-hashing",		    "rx-hashing",
-	  0,		   0,		    ETH_FLAG_RXHASH,	0 },
-};
-
 struct feature_def {
 	char name[ETH_GSTRING_LEN];
 	int off_flag_index; /* index in off_flag_def; negative if none match */
@@ -155,7 +110,7 @@ struct feature_def {
 struct feature_defs {
 	size_t n_features;
 	/* Number of features each offload flag is associated with */
-	unsigned int off_flag_matched[ARRAY_SIZE(off_flag_def)];
+	unsigned int off_flag_matched[OFF_FLAG_DEF_SIZE];
 	/* Name and offload flag index for each feature */
 	struct feature_def def[0];
 };
@@ -1423,7 +1378,7 @@ static void dump_features(const struct feature_defs *defs,
 	int indent;
 	int i, j;
 
-	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
+	for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
 		/* Don't show features whose state is unknown on this
 		 * kernel version
 		 */
@@ -1742,7 +1697,7 @@ static struct feature_defs *get_feature_defs(struct cmd_context *ctx)
 		defs->def[i].off_flag_index = -1;
 
 		for (j = 0;
-		     j < ARRAY_SIZE(off_flag_def) &&
+		     j < OFF_FLAG_DEF_SIZE &&
 			     defs->def[i].off_flag_index < 0;
 		     j++) {
 			const char *pattern =
@@ -2190,7 +2145,7 @@ get_features(struct cmd_context *ctx, const struct feature_defs *defs)
 
 	state->off_flags = 0;
 
-	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
+	for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
 		value = off_flag_def[i].value;
 		if (!off_flag_def[i].get_cmd)
 			continue;
@@ -2306,8 +2261,7 @@ static int do_sfeatures(struct cmd_context *ctx)
 	/* Generate cmdline_info for legacy flags and kernel-named
 	 * features, and parse our arguments.
 	 */
-	cmdline_features = calloc(2 * ARRAY_SIZE(off_flag_def) +
-				  defs->n_features,
+	cmdline_features = calloc(2 * OFF_FLAG_DEF_SIZE + defs->n_features,
 				  sizeof(cmdline_features[0]));
 	if (!cmdline_features) {
 		perror("Cannot parse arguments");
@@ -2315,7 +2269,7 @@ static int do_sfeatures(struct cmd_context *ctx)
 		goto err;
 	}
 	j = 0;
-	for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
+	for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
 		flag_to_cmdline_info(off_flag_def[i].short_name,
 				     off_flag_def[i].value,
 				     &off_flags_wanted, &off_flags_mask,
@@ -2332,7 +2286,7 @@ static int do_sfeatures(struct cmd_context *ctx)
 			&FEATURE_WORD(efeatures->features, i, valid),
 			&cmdline_features[j++]);
 	parse_generic_cmdline(ctx, &any_changed, cmdline_features,
-			      2 * ARRAY_SIZE(off_flag_def) + defs->n_features);
+			      2 * OFF_FLAG_DEF_SIZE + defs->n_features);
 	free(cmdline_features);
 
 	if (!any_changed) {
@@ -2352,7 +2306,7 @@ static int do_sfeatures(struct cmd_context *ctx)
 		 * related features that the user did not specify and that
 		 * are not fixed.  Warn if all related features are fixed.
 		 */
-		for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
+		for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
 			int fixed = 1;
 
 			if (!(off_flags_mask & off_flag_def[i].value))
@@ -2393,7 +2347,7 @@ static int do_sfeatures(struct cmd_context *ctx)
 			goto err;
 		}
 	} else {
-		for (i = 0; i < ARRAY_SIZE(off_flag_def); i++) {
+		for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
 			if (!off_flag_def[i].set_cmd)
 				continue;
 			if (off_flags_mask & off_flag_def[i].value) {
@@ -5259,6 +5213,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-k|--show-features|--show-offload",
 		.func	= do_gfeatures,
+		.nlfunc	= nl_gfeatures,
 		.help	= "Get state of protocol offload and other features"
 	},
 	{
diff --git a/netlink/bitset.c b/netlink/bitset.c
index ed109ec1d2c0..291ac7170272 100644
--- a/netlink/bitset.c
+++ b/netlink/bitset.c
@@ -153,6 +153,24 @@ err:
 	return true;
 }
 
+uint32_t *get_compact_bitset_value(const struct nlattr *bitset)
+{
+	const struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	unsigned int count;
+	int ret;
+
+	ret = mnl_attr_parse_nested(bitset, attr_cb, &tb_info);
+	if (ret < 0 ||
+	    !tb[ETHTOOL_A_BITSET_SIZE] || !tb[ETHTOOL_A_BITSET_VALUE])
+		return NULL;
+	count = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
+	if (8 * mnl_attr_get_payload_len(tb[ETHTOOL_A_BITSET_VALUE]) < count)
+		return NULL;
+
+	return mnl_attr_get_payload(tb[ETHTOOL_A_BITSET_VALUE]);
+}
+
 int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
 		bitset_walk_callback cb, void *data)
 {
diff --git a/netlink/bitset.h b/netlink/bitset.h
index 4b587d2c8a04..9f3230981e40 100644
--- a/netlink/bitset.h
+++ b/netlink/bitset.h
@@ -20,6 +20,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 		    int *retptr);
 bool bitset_is_compact(const struct nlattr *bitset);
 bool bitset_is_empty(const struct nlattr *bitset, bool mask, int *retptr);
+uint32_t *get_compact_bitset_value(const struct nlattr *bitset);
 int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
 		bitset_walk_callback cb, void *data);
 
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 9484b4c5ae7e..81c1de0df1e6 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -20,6 +20,7 @@ void netlink_run_handler(struct cmd_context *ctx, nl_func_t nlfunc,
 int nl_gset(struct cmd_context *ctx);
 int nl_sset(struct cmd_context *ctx);
 int nl_permaddr(struct cmd_context *ctx);
+int nl_gfeatures(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -44,6 +45,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gset			NULL
 #define nl_sset			NULL
 #define nl_permaddr		NULL
+#define nl_gfeatures		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/features.c b/netlink/features.c
new file mode 100644
index 000000000000..76c16dbf2e13
--- /dev/null
+++ b/netlink/features.c
@@ -0,0 +1,241 @@
+/*
+ * features.c - netlink implementation of netdev features commands
+ *
+ * Implementation of "ethtool -k <dev>".
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "strset.h"
+#include "bitset.h"
+
+/* FEATURES_GET */
+
+struct feature_results {
+	uint32_t	*hw;
+	uint32_t	*wanted;
+	uint32_t	*active;
+	uint32_t	*nochange;
+	unsigned int	count;
+	unsigned int	words;
+};
+
+static int prepare_feature_results(const struct nlattr *const *tb,
+				   struct feature_results *dest)
+{
+	unsigned int count;
+	int ret;
+
+	memset(dest, '\0', sizeof(*dest));
+	if (!tb[ETHTOOL_A_FEATURES_HW] || !tb[ETHTOOL_A_FEATURES_WANTED] ||
+	    !tb[ETHTOOL_A_FEATURES_ACTIVE] || !tb[ETHTOOL_A_FEATURES_NOCHANGE])
+		return -EFAULT;
+	count = bitset_get_count(tb[ETHTOOL_A_FEATURES_HW], &ret);
+	if (ret < 0)
+		return -EFAULT;
+	if ((bitset_get_count(tb[ETHTOOL_A_FEATURES_WANTED], &ret) != count) ||
+	    (bitset_get_count(tb[ETHTOOL_A_FEATURES_ACTIVE], &ret) != count) ||
+	    (bitset_get_count(tb[ETHTOOL_A_FEATURES_NOCHANGE], &ret) != count))
+		return -EFAULT;
+	dest->hw = get_compact_bitset_value(tb[ETHTOOL_A_FEATURES_HW]);
+	dest->wanted = get_compact_bitset_value(tb[ETHTOOL_A_FEATURES_WANTED]);
+	dest->active = get_compact_bitset_value(tb[ETHTOOL_A_FEATURES_ACTIVE]);
+	dest->nochange =
+		get_compact_bitset_value(tb[ETHTOOL_A_FEATURES_NOCHANGE]);
+	if (!dest->hw || !dest->wanted || !dest->active || !dest->nochange)
+		return -EFAULT;
+	dest->count = count;
+	dest->words = (count + 31) / 32;
+
+	return 0;
+}
+
+static bool feature_on(const uint32_t *bitmap, unsigned int idx)
+{
+	return bitmap[idx / 32] & (1 << (idx % 32));
+}
+
+static void dump_feature(const struct feature_results *results,
+			 const uint32_t *ref, const uint32_t *ref_mask,
+			 unsigned int idx, const char *name, const char *prefix)
+{
+	const char *suffix = "";
+
+	if (!name || !*name)
+		return;
+	if (ref) {
+		if (ref_mask && !feature_on(ref_mask, idx))
+			return;
+		if ((!ref_mask || feature_on(ref_mask, idx)) &&
+		    (feature_on(results->active, idx) == feature_on(ref, idx)))
+			return;
+	}
+
+	if (!feature_on(results->hw, idx) || feature_on(results->nochange, idx))
+		suffix = " [fixed]";
+	else if (feature_on(results->active, idx) !=
+		 feature_on(results->wanted, idx))
+		suffix = feature_on(results->wanted, idx) ?
+			" [requested on]" : " [requested off]";
+	printf("%s%s: %s%s\n", prefix, name,
+	       feature_on(results->active, idx) ? "on" : "off", suffix);
+}
+
+/* this assumes pattern contains no more than one asterisk */
+static bool flag_pattern_match(const char *name, const char *pattern)
+{
+	const char *p_ast = strchr(pattern, '*');
+
+	if (p_ast) {
+		size_t name_len = strlen(name);
+		size_t pattern_len = strlen(pattern);
+
+		if (name_len + 1 < pattern_len)
+			return false;
+		if (strncmp(name, pattern, p_ast - pattern))
+			return false;
+		pattern_len -= (p_ast - pattern) + 1;
+		name += name_len  - pattern_len;
+		pattern = p_ast + 1;
+	}
+	return !strcmp(name, pattern);
+}
+
+int dump_features(const struct nlattr *const *tb,
+		  const struct stringset *feature_names)
+{
+	struct feature_results results;
+	unsigned int i, j;
+	int *feature_flags = NULL;
+	int ret;
+
+	ret = prepare_feature_results(tb, &results);
+	if (ret < 0)
+		return -EFAULT;
+
+	ret = -ENOMEM;
+	feature_flags = calloc(results.count, sizeof(feature_flags[0]));
+	if (!feature_flags)
+		goto out_free;
+
+	/* map netdev features to legacy flags */
+	for (i = 0; i < results.count; i++) {
+		const char *name = get_string(feature_names, i);
+		feature_flags[i] = -1;
+
+		if (!name || !*name)
+			continue;
+		for (j = 0; j < OFF_FLAG_DEF_SIZE; j++) {
+			const char *flag_name = off_flag_def[j].kernel_name;
+
+			if (flag_pattern_match(name, flag_name)) {
+				feature_flags[i] = j;
+				break;
+			}
+		}
+	}
+	/* show legacy flags and their matching features first */
+	for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
+		unsigned int n_match = 0;
+		bool flag_value = false;
+
+		/* no kernel with netlink interface supports UFO */
+		if (off_flag_def[i].value == ETH_FLAG_UFO)
+			continue;
+
+		for (j = 0; j < results.count; j++) {
+			if (feature_flags[j] == i) {
+				n_match++;
+				flag_value = flag_value ||
+					feature_on(results.active, j);
+			}
+		}
+		if (n_match != 1)
+			printf("%s: %s\n", off_flag_def[i].long_name,
+			       flag_value ? "on" : "off");
+		if (n_match == 0)
+			continue;
+		for (j = 0; j < results.count; j++) {
+			const char *name = get_string(feature_names, j);
+
+			if (feature_flags[j] != i)
+				continue;
+			if (n_match == 1)
+				dump_feature(&results, NULL, NULL, j,
+					     off_flag_def[i].long_name, "");
+			else
+				dump_feature(&results, NULL, NULL, j, name,
+					     "\t");
+		}
+	}
+	/* and, finally, remaining netdev_features not matching legacy flags */
+	for (i = 0; i < results.count; i++) {
+		const char *name = get_string(feature_names, i);
+
+		if (!name || !*name || feature_flags[i] >= 0)
+			continue;
+		dump_feature(&results, NULL, NULL, i, name, "");
+	}
+
+out_free:
+	free(feature_flags);
+	return 0;
+}
+
+int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	const struct stringset *feature_names;
+	struct nl_context *nlctx = data;
+	bool silent;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	if (!nlctx->is_monitor) {
+		ret = netlink_init_ethnl2_socket(nlctx);
+		if (ret < 0)
+			return MNL_CB_ERROR;
+	}
+	feature_names = global_stringset(ETH_SS_FEATURES, nlctx->ethnl2_socket);
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return silent ? MNL_CB_OK : MNL_CB_ERROR;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_FEATURES_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (silent)
+		putchar('\n');
+	printf("Features for %s:\n", nlctx->devname);
+	ret = dump_features(tb, feature_names);
+	return (silent || !ret) ? MNL_CB_OK : MNL_CB_ERROR;
+}
+
+int nl_gfeatures(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_FEATURES_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_FEATURES_GET,
+				      ETHTOOL_A_FEATURES_HEADER,
+				      ETHTOOL_FLAG_COMPACT_BITSETS);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, features_reply_cb);
+}
diff --git a/netlink/monitor.c b/netlink/monitor.c
index e20db5fc79d4..a572e3c38463 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -31,6 +31,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_DEBUG_NTF,
 		.cb	= debug_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_FEATURES_NTF,
+		.cb	= features_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -102,6 +106,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-s|--change",
 		.cmd		= ETHTOOL_MSG_DEBUG_NTF,
 	},
+	{
+		.pattern	= "-k|--show-features|--show-offload|-K|--features|--offload",
+		.cmd		= ETHTOOL_MSG_FEATURES_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 4419be0f751a..98e38ff2d7b0 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -62,6 +62,7 @@ int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int features_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 static inline void copy_devname(char *dst, const char *src)
 {
-- 
2.26.2

