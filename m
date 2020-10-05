Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB31A284260
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgJEWHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbgJEWHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:07:51 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381B120789;
        Mon,  5 Oct 2020 22:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601935669;
        bh=YK3OaesWLhyAAmwJWLkrouFzkIbIhCAx/gAfM8IZxkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooG3gwGFxaY3gBUuB9fz2Ikm00u79P2LYd70fxjLOdh77kCNvrxpQn/BZh08gP5pQ
         p0sn5OfK1IPYbRA+bZuG7SPB3Qb5AMC+vPjrQawmnSp9JBoE78MbLqlllp5KdQOjRF
         7/b91Md+G6PyIZWm02jQSu030VMsTjAOsv/7pYoo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/7] ethtool: wire up get policies to ops
Date:   Mon,  5 Oct 2020 15:07:33 -0700
Message-Id: <20201005220739.2581920-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005220739.2581920-1-kuba@kernel.org>
References: <20201005220739.2581920-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up policies for get commands in struct nla_policy of the ethtool
family. Make use of genetlink code attr validation and parsing, as well
as allow dumping policies to user space.

For every ETHTOOL_MSG_*_GET:
 - add 'ethnl_' prefix to policy name
 - add extern declaration in net/ethtool/netlink.h
 - wire up the policy & attr in ethtool_genl_ops[].
 - remove .request_policy and .max_attr from ethnl_request_ops.

Obviously core only records the first "layer" of parsed attrs
so we still need to parse the sub-attrs of the nested header
attribute.

v2:
 - merge of patches 1 and 2 from v1
 - remove stray empty lines in ops
 - also remove .max_attr

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/channels.c  |  6 ++--
 net/ethtool/coalesce.c  |  6 ++--
 net/ethtool/debug.c     |  5 +---
 net/ethtool/eee.c       |  5 +---
 net/ethtool/features.c  |  6 ++--
 net/ethtool/linkinfo.c  |  6 ++--
 net/ethtool/linkmodes.c |  6 ++--
 net/ethtool/linkstate.c |  6 ++--
 net/ethtool/netlink.c   | 62 ++++++++++++++++++++++++++---------------
 net/ethtool/netlink.h   | 20 ++++++++++---
 net/ethtool/pause.c     |  5 +---
 net/ethtool/privflags.c |  6 ++--
 net/ethtool/rings.c     |  5 +---
 net/ethtool/strset.c    |  4 +--
 net/ethtool/tsinfo.c    |  5 +---
 net/ethtool/tunnels.c   | 39 +++++++++-----------------
 net/ethtool/wol.c       |  5 +---
 17 files changed, 90 insertions(+), 107 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 9ecda09ecb11..6ffcea099fd3 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -17,8 +17,8 @@ struct channels_reply_data {
 #define CHANNELS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct channels_reply_data, base)
 
-static const struct nla_policy
-channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
+const struct nla_policy
+ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
 	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
@@ -99,10 +99,8 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_CHANNELS_GET,
 	.reply_cmd		= ETHTOOL_MSG_CHANNELS_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_CHANNELS_HEADER,
-	.max_attr		= ETHTOOL_A_CHANNELS_MAX,
 	.req_info_size		= sizeof(struct channels_req_info),
 	.reply_data_size	= sizeof(struct channels_reply_data),
-	.request_policy		= channels_get_policy,
 
 	.prepare_data		= channels_prepare_data,
 	.reply_size		= channels_reply_size,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 6afd99042d67..58a2eb375135 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -51,8 +51,8 @@ __CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
 __CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
 
-static const struct nla_policy
-coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
+const struct nla_policy
+ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
 	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_REJECT },
@@ -203,10 +203,8 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_COALESCE_GET,
 	.reply_cmd		= ETHTOOL_MSG_COALESCE_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_COALESCE_HEADER,
-	.max_attr		= ETHTOOL_A_COALESCE_MAX,
 	.req_info_size		= sizeof(struct coalesce_req_info),
 	.reply_data_size	= sizeof(struct coalesce_reply_data),
-	.request_policy		= coalesce_get_policy,
 
 	.prepare_data		= coalesce_prepare_data,
 	.reply_size		= coalesce_reply_size,
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index 1bd026a29f3f..67623ae94d41 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -16,8 +16,7 @@ struct debug_reply_data {
 #define DEBUG_REPDATA(__reply_base) \
 	container_of(__reply_base, struct debug_reply_data, base)
 
-static const struct nla_policy
-debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
+const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1] = {
 	[ETHTOOL_A_DEBUG_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_DEBUG_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_REJECT },
@@ -69,10 +68,8 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_DEBUG_GET,
 	.reply_cmd		= ETHTOOL_MSG_DEBUG_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_DEBUG_HEADER,
-	.max_attr		= ETHTOOL_A_DEBUG_MAX,
 	.req_info_size		= sizeof(struct debug_req_info),
 	.reply_data_size	= sizeof(struct debug_reply_data),
-	.request_policy		= debug_get_policy,
 
 	.prepare_data		= debug_prepare_data,
 	.reply_size		= debug_reply_size,
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 94aa19cff22f..860e482533ba 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -19,8 +19,7 @@ struct eee_reply_data {
 #define EEE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eee_reply_data, base)
 
-static const struct nla_policy
-eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
+const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
 	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_REJECT },
@@ -119,10 +118,8 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_EEE_GET,
 	.reply_cmd		= ETHTOOL_MSG_EEE_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_EEE_HEADER,
-	.max_attr		= ETHTOOL_A_EEE_MAX,
 	.req_info_size		= sizeof(struct eee_req_info),
 	.reply_data_size	= sizeof(struct eee_reply_data),
-	.request_policy		= eee_get_policy,
 
 	.prepare_data		= eee_prepare_data,
 	.reply_size		= eee_reply_size,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 495635f152ba..bc1b1c74b1f5 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -20,8 +20,8 @@ struct features_reply_data {
 #define FEATURES_REPDATA(__reply_base) \
 	container_of(__reply_base, struct features_reply_data, base)
 
-static const struct nla_policy
-features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
+const struct nla_policy
+ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1] = {
 	[ETHTOOL_A_FEATURES_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_FEATURES_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_FEATURES_HW]		= { .type = NLA_REJECT },
@@ -120,10 +120,8 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_FEATURES_GET,
 	.reply_cmd		= ETHTOOL_MSG_FEATURES_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_FEATURES_HEADER,
-	.max_attr		= ETHTOOL_A_FEATURES_MAX,
 	.req_info_size		= sizeof(struct features_req_info),
 	.reply_data_size	= sizeof(struct features_reply_data),
-	.request_policy		= features_get_policy,
 
 	.prepare_data		= features_prepare_data,
 	.reply_size		= features_reply_size,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 5eaf173eaaca..eea75524e983 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -16,8 +16,8 @@ struct linkinfo_reply_data {
 #define LINKINFO_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkinfo_reply_data, base)
 
-static const struct nla_policy
-linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
+const struct nla_policy
+ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
 	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_REJECT },
@@ -83,10 +83,8 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
 	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
-	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
 	.req_info_size		= sizeof(struct linkinfo_req_info),
 	.reply_data_size	= sizeof(struct linkinfo_reply_data),
-	.request_policy		= linkinfo_get_policy,
 
 	.prepare_data		= linkinfo_prepare_data,
 	.reply_size		= linkinfo_reply_size,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 29dcd675b65a..8e0b4a12f875 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -18,8 +18,8 @@ struct linkmodes_reply_data {
 #define LINKMODES_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkmodes_reply_data, base)
 
-static const struct nla_policy
-linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
+const struct nla_policy
+ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
 	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_REJECT },
@@ -148,10 +148,8 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_LINKMODES_GET,
 	.reply_cmd		= ETHTOOL_MSG_LINKMODES_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_LINKMODES_HEADER,
-	.max_attr		= ETHTOOL_A_LINKMODES_MAX,
 	.req_info_size		= sizeof(struct linkmodes_req_info),
 	.reply_data_size	= sizeof(struct linkmodes_reply_data),
-	.request_policy		= linkmodes_get_policy,
 
 	.prepare_data		= linkmodes_prepare_data,
 	.reply_size		= linkmodes_reply_size,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 4834091ec24c..ebd6dcff1dad 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -20,8 +20,8 @@ struct linkstate_reply_data {
 #define LINKSTATE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct linkstate_reply_data, base)
 
-static const struct nla_policy
-linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
+const struct nla_policy
+ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
@@ -179,10 +179,8 @@ const struct ethnl_request_ops ethnl_linkstate_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_LINKSTATE_GET,
 	.reply_cmd		= ETHTOOL_MSG_LINKSTATE_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_LINKSTATE_HEADER,
-	.max_attr		= ETHTOOL_A_LINKSTATE_MAX,
 	.req_info_size		= sizeof(struct linkstate_req_info),
 	.reply_data_size	= sizeof(struct linkstate_reply_data),
-	.request_policy		= linkstate_get_policy,
 
 	.prepare_data		= linkstate_prepare_data,
 	.reply_size		= linkstate_reply_size,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5c2072765be7..98031bdd8e8e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -247,7 +247,7 @@ static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
 /**
  * ethnl_default_parse() - Parse request message
  * @req_info:    pointer to structure to put data into
- * @nlhdr:       pointer to request message header
+ * @tb:		 parsed attributes
  * @net:         request netns
  * @request_ops: struct request_ops for request type
  * @extack:      netlink extack for error reporting
@@ -259,37 +259,24 @@ static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
  * Return: 0 on success or negative error code
  */
 static int ethnl_default_parse(struct ethnl_req_info *req_info,
-			       const struct nlmsghdr *nlhdr, struct net *net,
+			       struct nlattr **tb, struct net *net,
 			       const struct ethnl_request_ops *request_ops,
 			       struct netlink_ext_ack *extack, bool require_dev)
 {
-	struct nlattr **tb;
 	int ret;
 
-	tb = kmalloc_array(request_ops->max_attr + 1, sizeof(tb[0]),
-			   GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
-
-	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, request_ops->max_attr,
-			  request_ops->request_policy, extack);
-	if (ret < 0)
-		goto out;
 	ret = ethnl_parse_header_dev_get(req_info, tb[request_ops->hdr_attr],
 					 net, extack, require_dev);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (request_ops->parse_request) {
 		ret = request_ops->parse_request(req_info, tb, extack);
 		if (ret < 0)
-			goto out;
+			return ret;
 	}
 
-	ret = 0;
-out:
-	kfree(tb);
-	return ret;
+	return 0;
 }
 
 /**
@@ -334,8 +321,8 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 	}
 
-	ret = ethnl_default_parse(req_info, info->nlhdr, genl_info_net(info), ops,
-				  info->extack, !ops->allow_nodev_do);
+	ret = ethnl_default_parse(req_info, info->attrs, genl_info_net(info),
+				  ops, info->extack, !ops->allow_nodev_do);
 	if (ret < 0)
 		goto err_dev;
 	ethnl_init_reply_data(reply_data, ops, req_info->dev);
@@ -480,6 +467,7 @@ static int ethnl_default_dumpit(struct sk_buff *skb,
 /* generic ->start() handler for GET requests */
 static int ethnl_default_start(struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct ethnl_dump_ctx *ctx = ethnl_dump_context(cb);
 	struct ethnl_reply_data *reply_data;
 	const struct ethnl_request_ops *ops;
@@ -502,8 +490,8 @@ static int ethnl_default_start(struct netlink_callback *cb)
 		goto free_req_info;
 	}
 
-	ret = ethnl_default_parse(req_info, cb->nlh, sock_net(cb->skb->sk), ops,
-				  cb->extack, false);
+	ret = ethnl_default_parse(req_info, info->attrs, sock_net(cb->skb->sk),
+				  ops, cb->extack, false);
 	if (req_info->dev) {
 		/* We ignore device specification in dump requests but as the
 		 * same parser as for non-dump (doit) requests is used, it
@@ -696,6 +684,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_strset_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_strset_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKINFO_GET,
@@ -703,6 +693,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_linkinfo_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkinfo_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
@@ -715,6 +707,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_linkmodes_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkmodes_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_LINKMODES_SET,
@@ -727,6 +721,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_linkstate_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_linkstate_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_DEBUG_GET,
@@ -734,6 +730,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_debug_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_debug_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_DEBUG_SET,
@@ -747,6 +745,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_wol_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_wol_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_WOL_SET,
@@ -759,6 +759,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_features_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_features_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_FEATURES_SET,
@@ -771,6 +773,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_privflags_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_privflags_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_PRIVFLAGS_SET,
@@ -783,6 +787,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_rings_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_rings_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_RINGS_SET,
@@ -795,6 +801,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_channels_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_channels_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
@@ -807,6 +815,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_coalesce_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_coalesce_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_COALESCE_SET,
@@ -819,6 +829,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_pause_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_pause_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_PAUSE_SET,
@@ -831,6 +843,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_eee_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_eee_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_EEE_SET,
@@ -843,6 +857,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.start	= ethnl_default_start,
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
+		.policy = ethnl_tsinfo_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_tsinfo_get_policy) - 1,
 	},
 	{
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_ACT,
@@ -859,6 +875,8 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.doit	= ethnl_tunnel_info_doit,
 		.start	= ethnl_tunnel_info_start,
 		.dumpit	= ethnl_tunnel_info_dumpit,
+		.policy = ethnl_tunnel_info_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_tunnel_info_get_policy) - 1,
 	},
 };
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index e2085005caac..d150f5f5e92b 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -266,10 +266,8 @@ static inline void ethnl_ops_complete(struct net_device *dev)
  * @request_cmd:      command id for request (GET)
  * @reply_cmd:        command id for reply (GET_REPLY)
  * @hdr_attr:         attribute type for request header
- * @max_attr:         maximum (top level) attribute type
  * @req_info_size:    size of request info
  * @reply_data_size:  size of reply data
- * @request_policy:   netlink policy for message contents
  * @allow_nodev_do:   allow non-dump request with no device identification
  * @parse_request:
  *	Parse request except common header (struct ethnl_req_info). Common
@@ -312,10 +310,8 @@ struct ethnl_request_ops {
 	u8			request_cmd;
 	u8			reply_cmd;
 	u16			hdr_attr;
-	unsigned int		max_attr;
 	unsigned int		req_info_size;
 	unsigned int		reply_data_size;
-	const struct nla_policy *request_policy;
 	bool			allow_nodev_do;
 
 	int (*parse_request)(struct ethnl_req_info *req_info,
@@ -349,6 +345,22 @@ extern const struct ethnl_request_ops ethnl_pause_request_ops;
 extern const struct ethnl_request_ops ethnl_eee_request_ops;
 extern const struct ethnl_request_ops ethnl_tsinfo_request_ops;
 
+extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1];
+extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1];
+extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1];
+extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1];
+extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_MAX + 1];
+extern const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1];
+extern const struct nla_policy ethnl_features_get_policy[ETHTOOL_A_FEATURES_MAX + 1];
+extern const struct nla_policy ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1];
+extern const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1];
+extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1];
+extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1];
+extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1];
+extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_MAX + 1];
+extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1];
+extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1];
+
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 1980aa7eb2b6..f753094fc52a 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -16,8 +16,7 @@ struct pause_reply_data {
 #define PAUSE_REPDATA(__reply_base) \
 	container_of(__reply_base, struct pause_reply_data, base)
 
-static const struct nla_policy
-pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
+const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
@@ -130,10 +129,8 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_PAUSE_GET,
 	.reply_cmd		= ETHTOOL_MSG_PAUSE_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_PAUSE_HEADER,
-	.max_attr		= ETHTOOL_A_PAUSE_MAX,
 	.req_info_size		= sizeof(struct pause_req_info),
 	.reply_data_size	= sizeof(struct pause_reply_data),
-	.request_policy		= pause_get_policy,
 
 	.prepare_data		= pause_prepare_data,
 	.reply_size		= pause_reply_size,
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index 77447dceb109..9dfdd9b3a19c 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -18,8 +18,8 @@ struct privflags_reply_data {
 #define PRIVFLAGS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct privflags_reply_data, base)
 
-static const struct nla_policy
-privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
+const struct nla_policy
+ethnl_privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
 	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_REJECT },
@@ -124,10 +124,8 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET,
 	.reply_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_PRIVFLAGS_HEADER,
-	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,
 	.req_info_size		= sizeof(struct privflags_req_info),
 	.reply_data_size	= sizeof(struct privflags_reply_data),
-	.request_policy		= privflags_get_policy,
 
 	.prepare_data		= privflags_prepare_data,
 	.reply_size		= privflags_reply_size,
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 5422526f4eef..006b70f54dd7 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -15,8 +15,7 @@ struct rings_reply_data {
 #define RINGS_REPDATA(__reply_base) \
 	container_of(__reply_base, struct rings_reply_data, base)
 
-static const struct nla_policy
-rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
+const struct nla_policy ethnl_rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
 	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
@@ -97,10 +96,8 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_RINGS_GET,
 	.reply_cmd		= ETHTOOL_MSG_RINGS_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_RINGS_HEADER,
-	.max_attr		= ETHTOOL_A_RINGS_MAX,
 	.req_info_size		= sizeof(struct rings_req_info),
 	.reply_data_size	= sizeof(struct rings_reply_data),
-	.request_policy		= rings_get_policy,
 
 	.prepare_data		= rings_prepare_data,
 	.reply_size		= rings_reply_size,
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 82707b662fe4..9adff4668004 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -99,7 +99,7 @@ struct strset_reply_data {
 #define STRSET_REPDATA(__reply_base) \
 	container_of(__reply_base, struct strset_reply_data, base)
 
-static const struct nla_policy strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
+const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_MAX + 1] = {
 	[ETHTOOL_A_STRSET_UNSPEC]	= { .type = NLA_REJECT },
 	[ETHTOOL_A_STRSET_HEADER]	= { .type = NLA_NESTED },
 	[ETHTOOL_A_STRSET_STRINGSETS]	= { .type = NLA_NESTED },
@@ -445,10 +445,8 @@ const struct ethnl_request_ops ethnl_strset_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_STRSET_GET,
 	.reply_cmd		= ETHTOOL_MSG_STRSET_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_STRSET_HEADER,
-	.max_attr		= ETHTOOL_A_STRSET_MAX,
 	.req_info_size		= sizeof(struct strset_req_info),
 	.reply_data_size	= sizeof(struct strset_reply_data),
-	.request_policy		= strset_get_policy,
 	.allow_nodev_do		= true,
 
 	.parse_request		= strset_parse_request,
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 7cb5b512b77c..21f0dc08cead 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -18,8 +18,7 @@ struct tsinfo_reply_data {
 #define TSINFO_REPDATA(__reply_base) \
 	container_of(__reply_base, struct tsinfo_reply_data, base)
 
-static const struct nla_policy
-tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
+const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_MAX + 1] = {
 	[ETHTOOL_A_TSINFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_TSINFO_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_TSINFO_TIMESTAMPING]		= { .type = NLA_REJECT },
@@ -132,10 +131,8 @@ const struct ethnl_request_ops ethnl_tsinfo_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_TSINFO_GET,
 	.reply_cmd		= ETHTOOL_MSG_TSINFO_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_TSINFO_HEADER,
-	.max_attr		= ETHTOOL_A_TSINFO_MAX,
 	.req_info_size		= sizeof(struct tsinfo_req_info),
 	.reply_data_size	= sizeof(struct tsinfo_reply_data),
-	.request_policy		= tsinfo_get_policy,
 
 	.prepare_data		= tsinfo_prepare_data,
 	.reply_size		= tsinfo_reply_size,
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index d93bf2da0f34..330817adcf62 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -8,8 +8,8 @@
 #include "common.h"
 #include "netlink.h"
 
-static const struct nla_policy
-ethtool_tunnel_info_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
+const struct nla_policy
+ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_MAX + 1] = {
 	[ETHTOOL_A_TUNNEL_INFO_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_TUNNEL_INFO_HEADER]		= { .type = NLA_NESTED },
 };
@@ -161,35 +161,19 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 	return -EMSGSIZE;
 }
 
-static int
-ethnl_tunnel_info_req_parse(struct ethnl_req_info *req_info,
-			    const struct nlmsghdr *nlhdr, struct net *net,
-			    struct netlink_ext_ack *extack, bool require_dev)
-{
-	struct nlattr *tb[ETHTOOL_A_TUNNEL_INFO_MAX + 1];
-	int ret;
-
-	ret = nlmsg_parse(nlhdr, GENL_HDRLEN, tb, ETHTOOL_A_TUNNEL_INFO_MAX,
-			  ethtool_tunnel_info_policy, extack);
-	if (ret < 0)
-		return ret;
-
-	return ethnl_parse_header_dev_get(req_info,
-					  tb[ETHTOOL_A_TUNNEL_INFO_HEADER],
-					  net, extack, require_dev);
-}
-
 int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
 	struct sk_buff *rskb;
 	void *reply_payload;
 	int reply_len;
 	int ret;
 
-	ret = ethnl_tunnel_info_req_parse(&req_info, info->nlhdr,
-					  genl_info_net(info), info->extack,
-					  true);
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_TUNNEL_INFO_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
 	if (ret < 0)
 		return ret;
 
@@ -233,16 +217,19 @@ struct ethnl_tunnel_info_dump_ctx {
 
 int ethnl_tunnel_info_start(struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct ethnl_tunnel_info_dump_ctx *ctx = (void *)cb->ctx;
+	struct nlattr **tb = info->attrs;
 	int ret;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
 	memset(ctx, 0, sizeof(*ctx));
 
-	ret = ethnl_tunnel_info_req_parse(&ctx->req_info, cb->nlh,
-					  sock_net(cb->skb->sk), cb->extack,
-					  false);
+	ret = ethnl_parse_header_dev_get(&ctx->req_info,
+					 tb[ETHTOOL_A_TUNNEL_INFO_HEADER],
+					 sock_net(cb->skb->sk), cb->extack,
+					 false);
 	if (ctx->req_info.dev) {
 		dev_put(ctx->req_info.dev);
 		ctx->req_info.dev = NULL;
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 1798421e9f1c..5bc38e2f5f61 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -17,8 +17,7 @@ struct wol_reply_data {
 #define WOL_REPDATA(__reply_base) \
 	container_of(__reply_base, struct wol_reply_data, base)
 
-static const struct nla_policy
-wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
+const struct nla_policy ethnl_wol_get_policy[ETHTOOL_A_WOL_MAX + 1] = {
 	[ETHTOOL_A_WOL_UNSPEC]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_WOL_HEADER]		= { .type = NLA_NESTED },
 	[ETHTOOL_A_WOL_MODES]		= { .type = NLA_REJECT },
@@ -89,10 +88,8 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_WOL_GET,
 	.reply_cmd		= ETHTOOL_MSG_WOL_GET_REPLY,
 	.hdr_attr		= ETHTOOL_A_WOL_HEADER,
-	.max_attr		= ETHTOOL_A_WOL_MAX,
 	.req_info_size		= sizeof(struct wol_req_info),
 	.reply_data_size	= sizeof(struct wol_reply_data),
-	.request_policy		= wol_get_policy,
 
 	.prepare_data		= wol_prepare_data,
 	.reply_size		= wol_reply_size,
-- 
2.26.2

