Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F55240023
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHIVYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:24:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:57464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgHIVYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 17:24:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB305ABE9
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 21:24:39 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id E785D7F447; Sun,  9 Aug 2020 23:24:19 +0200 (CEST)
Message-Id: <90fd688121efaea8acce2a9547585416433493f3.1597007533.git.mkubecek@suse.cz>
In-Reply-To: <cover.1597007532.git.mkubecek@suse.cz>
References: <cover.1597007532.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/7] netlink: get rid of signed/unsigned comparison
 warnings
To:     netdev@vger.kernel.org
Date:   Sun,  9 Aug 2020 23:24:19 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of compiler warnings about comparison between signed and
unsigned integer values in netlink code.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/features.c | 4 ++--
 netlink/netlink.c  | 4 ++--
 netlink/netlink.h  | 2 +-
 netlink/nlsock.c   | 2 +-
 netlink/parser.c   | 2 +-
 netlink/settings.c | 6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/netlink/features.c b/netlink/features.c
index 8b5b8588ca23..f5862e97a265 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -149,7 +149,7 @@ int dump_features(const struct nlattr *const *tb,
 			continue;
 
 		for (j = 0; j < results.count; j++) {
-			if (feature_flags[j] == i) {
+			if (feature_flags[j] == (int)i) {
 				n_match++;
 				flag_value = flag_value ||
 					feature_on(results.active, j);
@@ -163,7 +163,7 @@ int dump_features(const struct nlattr *const *tb,
 		for (j = 0; j < results.count; j++) {
 			const char *name = get_string(feature_names, j);
 
-			if (feature_flags[j] != i)
+			if (feature_flags[j] != (int)i)
 				continue;
 			if (n_match == 1)
 				dump_feature(&results, NULL, NULL, j,
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

