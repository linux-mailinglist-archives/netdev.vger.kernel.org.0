Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FE24EF81
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHWTkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:50592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgHWTkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC73FAEB1;
        Sun, 23 Aug 2020 19:40:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1CEA66030D; Sun, 23 Aug 2020 21:40:18 +0200 (CEST)
Message-Id: <06083ab4701848eeb56afec9a5d8b757dd6cb399.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 1/9] netlink: get rid of signed/unsigned comparison
 warnings
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:18 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use unsigned types where appropriate to get rid of compiler warnings about
comparison between signed and unsigned integer values in netlink code.

v2: avoid casts in dump_features()

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/features.c | 6 +++---
 netlink/netlink.c  | 4 ++--
 netlink/netlink.h  | 2 +-
 netlink/nlsock.c   | 2 +-
 netlink/parser.c   | 2 +-
 netlink/settings.c | 6 +++---
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/netlink/features.c b/netlink/features.c
index 133529da2b9f..c4105435f39d 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -109,9 +109,9 @@ static bool flag_pattern_match(const char *name, const char *pattern)
 int dump_features(const struct nlattr *const *tb,
 		  const struct stringset *feature_names)
 {
+	unsigned int *feature_flags = NULL;
 	struct feature_results results;
 	unsigned int i, j;
-	int *feature_flags = NULL;
 	int ret;
 
 	ret = prepare_feature_results(tb, &results);
@@ -126,7 +126,7 @@ int dump_features(const struct nlattr *const *tb,
 	/* map netdev features to legacy flags */
 	for (i = 0; i < results.count; i++) {
 		const char *name = get_string(feature_names, i);
-		feature_flags[i] = -1;
+		feature_flags[i] = UINT_MAX;
 
 		if (!name || !*name)
 			continue;
@@ -177,7 +177,7 @@ int dump_features(const struct nlattr *const *tb,
 	for (i = 0; i < results.count; i++) {
 		const char *name = get_string(feature_names, i);
 
-		if (!name || !*name || feature_flags[i] >= 0)
+		if (!name || !*name || feature_flags[i] != UINT_MAX)
 			continue;
 		dump_feature(&results, NULL, NULL, i, name, "");
 	}
diff --git a/netlink/netlink.c b/netlink/netlink.c
index 76b6e825b1d0..e42d57076a4b 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -33,9 +33,9 @@ int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data __maybe_unused)
 int attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct attr_tb_info *tb_info = data;
-	int type = mnl_attr_get_type(attr);
+	uint16_t type = mnl_attr_get_type(attr);
 
-	if (type >= 0 && type <= tb_info->max_type)
+	if (type <= tb_info->max_type)
 		tb_info->tb[type] = attr;
 
 	return MNL_CB_OK;
diff --git a/netlink/netlink.h b/netlink/netlink.h
index a4984c82ae76..dd4a02bcc916 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -45,7 +45,7 @@ struct nl_context {
 	const char		*cmd;
 	const char		*param;
 	char			**argp;
-	int			argc;
+	unsigned int		argc;
 	bool			ioctl_fallback;
 	bool			wildcard_unsupported;
 };
diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index c3f09b6ee9ab..ef31d8c33b29 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -168,7 +168,7 @@ static void debug_msg(struct nl_socket *nlsk, const void *msg, unsigned int len,
  *
  * Return: error code extracted from the message
  */
-static int nlsock_process_ack(struct nlmsghdr *nlhdr, ssize_t len,
+static int nlsock_process_ack(struct nlmsghdr *nlhdr, unsigned long len,
 			      unsigned int suppress_nlerr, bool pretty)
 {
 	const struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
diff --git a/netlink/parser.c b/netlink/parser.c
index 395bd5743af9..c5a368a65a7a 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -604,7 +604,7 @@ static int parse_numeric_bitset(struct nl_context *nlctx, uint16_t type,
 		parser_err_invalid_value(nlctx, arg);
 		return -EINVAL;
 	}
-	len1 = maskptr ? (maskptr - arg) : strlen(arg);
+	len1 = maskptr ? (unsigned int)(maskptr - arg) : strlen(arg);
 	nwords = DIV_ROUND_UP(len1, 8);
 	nbits = 0;
 
diff --git a/netlink/settings.c b/netlink/settings.c
index de35ad173627..99d047a3e497 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -276,10 +276,10 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
 	DECLARE_ATTR_TB_INFO(bitset_tb);
 	const unsigned int before_len = strlen(before);
+	unsigned int prev = UINT_MAX - 1;
 	const struct nlattr *bits;
 	const struct nlattr *bit;
 	bool first = true;
-	int prev = -2;
 	bool nomask;
 	int ret;
 
@@ -333,7 +333,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 			if (first)
 				first = false;
 			/* ugly hack to preserve old output format */
-			if (class == LM_CLASS_REAL && (prev == idx - 1) &&
+			if (class == LM_CLASS_REAL && (idx == prev + 1) &&
 			    prev < link_modes_count &&
 			    link_modes[prev].class == LM_CLASS_REAL &&
 			    link_modes[prev].duplex == DUPLEX_HALF)
@@ -375,7 +375,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 			first = false;
 		} else {
 			/* ugly hack to preserve old output format */
-			if ((class == LM_CLASS_REAL) && (prev == idx - 1) &&
+			if ((class == LM_CLASS_REAL) && (idx == prev + 1) &&
 			    (prev < link_modes_count) &&
 			    (link_modes[prev].class == LM_CLASS_REAL) &&
 			    (link_modes[prev].duplex == DUPLEX_HALF))
-- 
2.28.0

