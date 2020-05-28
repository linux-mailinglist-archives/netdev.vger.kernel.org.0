Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618711E7046
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437527AbgE1XWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437494AbgE1XVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B231AAFF1;
        Thu, 28 May 2020 23:21:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D4347E32D2; Fri, 29 May 2020 01:21:47 +0200 (CEST)
Message-Id: <2fb667862b0922fbff9583ebebc62d6267c20ce6.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 08/21] netlink: add netlink handler for sfeatures (-K)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:47 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -K <dev> ..." subcommand to set netdev feature flags
using ETHTOOL_MSG_FEATURES_SET netlink message. These are traditionally set
using ETHTOOL_SFEATURES ioctl request (and some older ones).

Unlike with ioctl, an attempt to set a value of a "group flag" (e.g. "tso"
or "txcsum") translates to a request to set all features in that group
(rather than letting kernel to do that); this can be a different set of
features than kernel uses (kernel fix is going to be submitted soon).

Output of the command also explicitly marks features with values changed
without being requested (e.g. because of dependencies).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c          |   1 +
 netlink/bitset.c   |  23 +++-
 netlink/bitset.h   |   1 +
 netlink/extapi.h   |   2 +
 netlink/features.c | 285 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 307 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 4749f3ae52a5..7fbf159baf69 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5219,6 +5219,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-K|--features|--offload",
 		.func	= do_sfeatures,
+		.nlfunc	= nl_sfeatures,
 		.help	= "Set protocol offload and other features",
 		.xhelp	= "		FEATURE on|off ...\n"
 	},
diff --git a/netlink/bitset.c b/netlink/bitset.c
index 291ac7170272..130bcdb5b52c 100644
--- a/netlink/bitset.c
+++ b/netlink/bitset.c
@@ -153,7 +153,8 @@ err:
 	return true;
 }
 
-uint32_t *get_compact_bitset_value(const struct nlattr *bitset)
+static uint32_t *get_compact_bitset_attr(const struct nlattr *bitset,
+					 uint16_t type)
 {
 	const struct nlattr *tb[ETHTOOL_A_BITSET_MAX + 1] = {};
 	DECLARE_ATTR_TB_INFO(tb);
@@ -161,14 +162,26 @@ uint32_t *get_compact_bitset_value(const struct nlattr *bitset)
 	int ret;
 
 	ret = mnl_attr_parse_nested(bitset, attr_cb, &tb_info);
-	if (ret < 0 ||
-	    !tb[ETHTOOL_A_BITSET_SIZE] || !tb[ETHTOOL_A_BITSET_VALUE])
+	if (ret < 0)
+		return NULL;
+	if (!tb[ETHTOOL_A_BITSET_SIZE] || !tb[ETHTOOL_A_BITSET_VALUE] ||
+	    !tb[type])
 		return NULL;
 	count = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_SIZE]);
-	if (8 * mnl_attr_get_payload_len(tb[ETHTOOL_A_BITSET_VALUE]) < count)
+	if (8 * mnl_attr_get_payload_len(tb[type]) < count)
 		return NULL;
 
-	return mnl_attr_get_payload(tb[ETHTOOL_A_BITSET_VALUE]);
+	return mnl_attr_get_payload(tb[type]);
+}
+
+uint32_t *get_compact_bitset_value(const struct nlattr *bitset)
+{
+	return get_compact_bitset_attr(bitset, ETHTOOL_A_BITSET_VALUE);
+}
+
+uint32_t *get_compact_bitset_mask(const struct nlattr *bitset)
+{
+	return get_compact_bitset_attr(bitset, ETHTOOL_A_BITSET_MASK);
 }
 
 int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
diff --git a/netlink/bitset.h b/netlink/bitset.h
index 9f3230981e40..4c9cdac0e8d8 100644
--- a/netlink/bitset.h
+++ b/netlink/bitset.h
@@ -21,6 +21,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 bool bitset_is_compact(const struct nlattr *bitset);
 bool bitset_is_empty(const struct nlattr *bitset, bool mask, int *retptr);
 uint32_t *get_compact_bitset_value(const struct nlattr *bitset);
+uint32_t *get_compact_bitset_mask(const struct nlattr *bitset);
 int walk_bitset(const struct nlattr *bitset, const struct stringset *labels,
 		bitset_walk_callback cb, void *data);
 
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 81c1de0df1e6..0dbcc8eb2e7b 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -21,6 +21,7 @@ int nl_gset(struct cmd_context *ctx);
 int nl_sset(struct cmd_context *ctx);
 int nl_permaddr(struct cmd_context *ctx);
 int nl_gfeatures(struct cmd_context *ctx);
+int nl_sfeatures(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -46,6 +47,7 @@ static inline void nl_monitor_usage(void)
 #define nl_sset			NULL
 #define nl_permaddr		NULL
 #define nl_gfeatures		NULL
+#define nl_sfeatures		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/features.c b/netlink/features.c
index 76c16dbf2e13..8b5b8588ca23 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -239,3 +239,288 @@ int nl_gfeatures(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, features_reply_cb);
 }
+
+/* FEATURES_SET */
+
+struct sfeatures_context {
+	uint32_t		req_mask[0];
+};
+
+static int find_feature(const char *name,
+			const struct stringset *feature_names)
+{
+	const unsigned int count = get_count(feature_names);
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		if (!strcmp(name, get_string(feature_names, i)))
+			return i;
+
+	return -1;
+}
+
+static int fill_feature(struct nl_msg_buff *msgbuff, const char *name, bool val)
+{
+	struct nlattr *bit_attr;
+
+	bit_attr = ethnla_nest_start(msgbuff, ETHTOOL_A_BITSET_BITS_BIT);
+	if (!bit_attr)
+		return -EMSGSIZE;
+	if (ethnla_put_strz(msgbuff, ETHTOOL_A_BITSET_BIT_NAME, name))
+		return -EMSGSIZE;
+	if (ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_BIT_VALUE, val))
+		return -EMSGSIZE;
+	mnl_attr_nest_end(msgbuff->nlhdr, bit_attr);
+
+	return 0;
+}
+
+static void set_sf_req_mask(struct nl_context *nlctx, unsigned int idx)
+{
+	struct sfeatures_context *sfctx = nlctx->cmd_private;
+
+	sfctx->req_mask[idx / 32] |= (1 << (idx % 32));
+}
+
+static int fill_legacy_flag(struct nl_context *nlctx, const char *flag_name,
+			    const struct stringset *feature_names, bool val)
+{
+	struct nl_msg_buff *msgbuff = &nlctx->ethnl_socket->msgbuff;
+	const unsigned int count = get_count(feature_names);
+	unsigned int i, j;
+	int ret;
+
+	for (i = 0; i < OFF_FLAG_DEF_SIZE; i++) {
+		const char *pattern;
+
+		if (strcmp(flag_name, off_flag_def[i].short_name) &&
+		    strcmp(flag_name, off_flag_def[i].long_name))
+			continue;
+		pattern = off_flag_def[i].kernel_name;
+
+		for (j = 0; j < count; j++) {
+			const char *name = get_string(feature_names, j);
+
+			if (flag_pattern_match(name, pattern)) {
+				ret = fill_feature(msgbuff, name, val);
+				if (ret < 0)
+					return ret;
+				set_sf_req_mask(nlctx, j);
+			}
+		}
+
+		return 0;
+	}
+
+	return 1;
+}
+
+int fill_sfeatures_bitmap(struct nl_context *nlctx,
+			  const struct stringset *feature_names)
+{
+	struct nl_msg_buff *msgbuff = &nlctx->ethnl_socket->msgbuff;
+	struct nlattr *bitset_attr;
+	struct nlattr *bits_attr;
+	int ret;
+
+	ret = -EMSGSIZE;
+	bitset_attr = ethnla_nest_start(msgbuff, ETHTOOL_A_FEATURES_WANTED);
+	if (!bitset_attr)
+		return ret;
+	bits_attr = ethnla_nest_start(msgbuff, ETHTOOL_A_BITSET_BITS);
+	if (!bits_attr)
+		goto err;
+
+	while (nlctx->argc > 0) {
+		bool val;
+
+		if (!strcmp(*nlctx->argp, "--")) {
+			nlctx->argp++;
+			nlctx->argc--;
+			break;
+		}
+		ret = -EINVAL;
+		if (nlctx->argc < 2 ||
+		    (strcmp(nlctx->argp[1], "on") &&
+		     strcmp(nlctx->argp[1], "off"))) {
+			fprintf(stderr,
+				"ethtool (%s): flag '%s' for parameter '%s' is"
+				" not followed by 'on' or 'off'\n",
+				nlctx->cmd, nlctx->argp[1], nlctx->param);
+			goto err;
+		}
+
+		val = !strcmp(nlctx->argp[1], "on");
+		ret = fill_legacy_flag(nlctx, nlctx->argp[0], feature_names,
+				       val);
+		if (ret > 0) {
+			ret = fill_feature(msgbuff, nlctx->argp[0], val);
+			if (ret == 0) {
+				int idx = find_feature(nlctx->argp[0],
+						       feature_names);
+
+				if (idx >= 0)
+					set_sf_req_mask(nlctx, idx);
+			}
+		}
+		if (ret < 0)
+			goto err;
+
+		nlctx->argp += 2;
+		nlctx->argc -= 2;
+	}
+
+	ethnla_nest_end(msgbuff, bits_attr);
+	ethnla_nest_end(msgbuff, bitset_attr);
+	return 0;
+err:
+	ethnla_nest_cancel(msgbuff, bitset_attr);
+	return ret;
+}
+
+static void show_feature_changes(struct nl_context *nlctx,
+				 const struct nlattr *const *tb)
+{
+	struct sfeatures_context *sfctx = nlctx->cmd_private;
+	const struct stringset *feature_names;
+	const uint32_t *wanted_mask;
+	const uint32_t *active_mask;
+	const uint32_t *wanted_val;
+	const uint32_t *active_val;
+	unsigned int count, words;
+	unsigned int i;
+	bool diff;
+	int ret;
+
+	feature_names = global_stringset(ETH_SS_FEATURES, nlctx->ethnl_socket);
+	count = get_count(feature_names);
+	words = DIV_ROUND_UP(count, 32);
+
+	if (!tb[ETHTOOL_A_FEATURES_WANTED] || !tb[ETHTOOL_A_FEATURES_ACTIVE])
+		goto err;
+	if (bitset_get_count(tb[ETHTOOL_A_FEATURES_WANTED], &ret) != count ||
+	    ret < 0)
+		goto err;
+	if (bitset_get_count(tb[ETHTOOL_A_FEATURES_ACTIVE], &ret) != count ||
+	    ret < 0)
+		goto err;
+	wanted_val = get_compact_bitset_value(tb[ETHTOOL_A_FEATURES_WANTED]);
+	wanted_mask = get_compact_bitset_mask(tb[ETHTOOL_A_FEATURES_WANTED]);
+	active_val = get_compact_bitset_value(tb[ETHTOOL_A_FEATURES_ACTIVE]);
+	active_mask = get_compact_bitset_mask(tb[ETHTOOL_A_FEATURES_ACTIVE]);
+	if (!wanted_val || !wanted_mask || !active_val || !active_mask)
+		goto err;
+
+	diff = false;
+	for (i = 0; i < words; i++)
+		if (wanted_mask[i] || active_mask[i])
+			diff = true;
+	if (!diff)
+		return;
+
+	/* result is not exactly as requested, show differences */
+	printf("Actual changes:\n");
+	for (i = 0; i < count; i++) {
+		const char *name = get_string(feature_names, i);
+
+		if (!name)
+			continue;
+		if (!feature_on(wanted_mask, i) && !feature_on(active_mask, i))
+			continue;
+		printf("%s: ", name);
+		if (feature_on(wanted_mask, i))
+			/* we requested a value but result is different */
+			printf("%s [requested %s]",
+			       feature_on(wanted_val, i) ? "off" : "on",
+			       feature_on(wanted_val, i) ? "on" : "off");
+		else if (!feature_on(sfctx->req_mask, i))
+			/* not requested but changed anyway */
+			printf("%s [not requested]",
+			       feature_on(active_val, i) ? "on" : "off");
+		else
+			printf("%s", feature_on(active_val, i) ? "on" : "off");
+		fputc('\n', stdout);
+	}
+
+	return;
+err:
+	fprintf(stderr, "malformed diff info from kernel\n");
+}
+
+int sfeatures_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct genlmsghdr *ghdr = (const struct genlmsghdr *)(nlhdr + 1);
+	const struct nlattr *tb[ETHTOOL_A_FEATURES_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	const char *devname;
+	int ret;
+
+	if (ghdr->cmd != ETHTOOL_MSG_FEATURES_SET_REPLY) {
+		fprintf(stderr, "warning: unexpected reply message type %u\n",
+			ghdr->cmd);
+		return MNL_CB_OK;
+	}
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	devname = get_dev_name(tb[ETHTOOL_A_FEATURES_HEADER]);
+	if (strcmp(devname, nlctx->devname)) {
+		fprintf(stderr, "warning: unexpected message for device %s\n",
+			devname);
+		return MNL_CB_OK;
+	}
+
+	show_feature_changes(nlctx, tb);
+	return MNL_CB_OK;
+}
+
+int nl_sfeatures(struct cmd_context *ctx)
+{
+	const struct stringset *feature_names;
+	struct nl_context *nlctx = ctx->nlctx;
+	struct sfeatures_context *sfctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	unsigned int words;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_FEATURES_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "-K";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->cmd_private = &sfctx;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	feature_names = global_stringset(ETH_SS_FEATURES, nlctx->ethnl_socket);
+	words = (get_count(feature_names) + 31) / 32;
+	sfctx = malloc(sizeof(*sfctx) + words * sizeof(sfctx->req_mask[0]));
+	if (!sfctx)
+		return -ENOMEM;
+	memset(sfctx, '\0',
+	       sizeof(*sfctx) + words * sizeof(sfctx->req_mask[0]));
+	nlctx->cmd_private = sfctx;
+
+	nlctx->devname = ctx->devname;
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_FEATURES_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_FEATURES_HEADER, ctx->devname,
+			       ETHTOOL_FLAG_COMPACT_BITSETS))
+		return -EMSGSIZE;
+	ret = fill_sfeatures_bitmap(nlctx, feature_names);
+	if (ret < 0)
+		return ret;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 92;
+	ret = nlsock_process_reply(nlsk, sfeatures_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	return nlctx->exit_code ?: 92;
+}
-- 
2.26.2

