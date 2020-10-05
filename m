Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A980A283BC8
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgJEP6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgJEP6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 11:58:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AE41207BC;
        Mon,  5 Oct 2020 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601913486;
        bh=M+OghuJdWV4ZfHwjzN+7JspN4oTehj/7fp2r7zd//9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvpkwgAiU68D6j8Y+xsF3vELpkuUUcRvEwTJ8SC+oqABI5NfvEY118rWGSg31zTlQ
         aduC5jDR37ugrfPLdhjSZldzbeihaqk0zKFDKyZWevWSZP6abxv5EzdoZ9lU9rfxQe
         FC89+uc94Pk8s52BYcWS463mX20Zdn/m4TFFS4BU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] ethtool: use the attributes parsed by the core in get commands
Date:   Mon,  5 Oct 2020 08:57:49 -0700
Message-Id: <20201005155753.2333882-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005155753.2333882-1-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that policies are placed in op structs core will do the
attribute parsing for us. Obviously core only record the first
"layer" of parsed attrs so we still need to parse the sub-attrs
of the nested header attribute.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/channels.c  |  1 -
 net/ethtool/coalesce.c  |  1 -
 net/ethtool/debug.c     |  1 -
 net/ethtool/eee.c       |  1 -
 net/ethtool/features.c  |  1 -
 net/ethtool/linkinfo.c  |  1 -
 net/ethtool/linkmodes.c |  1 -
 net/ethtool/linkstate.c |  1 -
 net/ethtool/netlink.c   | 32 ++++++++++----------------------
 net/ethtool/netlink.h   |  2 --
 net/ethtool/pause.c     |  1 -
 net/ethtool/privflags.c |  1 -
 net/ethtool/rings.c     |  1 -
 net/ethtool/strset.c    |  1 -
 net/ethtool/tsinfo.c    |  1 -
 net/ethtool/tunnels.c   | 35 +++++++++++------------------------
 net/ethtool/wol.c       |  1 -
 17 files changed, 21 insertions(+), 62 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index d3ef94c5ee59..76994c8f32a0 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -102,7 +102,6 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 	.max_attr		= ETHTOOL_A_CHANNELS_MAX,
 	.req_info_size		= sizeof(struct channels_req_info),
 	.reply_data_size	= sizeof(struct channels_reply_data),
-	.request_policy		= ethnl_channels_get_policy,
 
 	.prepare_data		= channels_prepare_data,
 	.reply_size		= channels_reply_size,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index e0d8a269a46d..77d83062faa2 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -206,7 +206,6 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 	.max_attr		= ETHTOOL_A_COALESCE_MAX,
 	.req_info_size		= sizeof(struct coalesce_req_info),
 	.reply_data_size	= sizeof(struct coalesce_reply_data),
-	.request_policy		= ethnl_coalesce_get_policy,
 
 	.prepare_data		= coalesce_prepare_data,
 	.reply_size		= coalesce_reply_size,
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index a007730320a4..f553ef6a99e4 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -71,7 +71,6 @@ const struct ethnl_request_ops ethnl_debug_request_ops = {
 	.max_attr		= ETHTOOL_A_DEBUG_MAX,
 	.req_info_size		= sizeof(struct debug_req_info),
 	.reply_data_size	= sizeof(struct debug_reply_data),
-	.request_policy		= ethnl_debug_get_policy,
 
 	.prepare_data		= debug_prepare_data,
 	.reply_size		= debug_reply_size,
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index ea9d071b5360..9ee03444fb8f 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -121,7 +121,6 @@ const struct ethnl_request_ops ethnl_eee_request_ops = {
 	.max_attr		= ETHTOOL_A_EEE_MAX,
 	.req_info_size		= sizeof(struct eee_req_info),
 	.reply_data_size	= sizeof(struct eee_reply_data),
-	.request_policy		= ethnl_eee_get_policy,
 
 	.prepare_data		= eee_prepare_data,
 	.reply_size		= eee_reply_size,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index c2979b3890f9..99944190f398 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -123,7 +123,6 @@ const struct ethnl_request_ops ethnl_features_request_ops = {
 	.max_attr		= ETHTOOL_A_FEATURES_MAX,
 	.req_info_size		= sizeof(struct features_req_info),
 	.reply_data_size	= sizeof(struct features_reply_data),
-	.request_policy		= ethnl_features_get_policy,
 
 	.prepare_data		= features_prepare_data,
 	.reply_size		= features_reply_size,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 676aa5a00ac0..b7142d8e2baf 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -86,7 +86,6 @@ const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
 	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
 	.req_info_size		= sizeof(struct linkinfo_req_info),
 	.reply_data_size	= sizeof(struct linkinfo_reply_data),
-	.request_policy		= ethnl_linkinfo_get_policy,
 
 	.prepare_data		= linkinfo_prepare_data,
 	.reply_size		= linkinfo_reply_size,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index f32ab3239d15..e23e600b73cb 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -151,7 +151,6 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
 	.max_attr		= ETHTOOL_A_LINKMODES_MAX,
 	.req_info_size		= sizeof(struct linkmodes_req_info),
 	.reply_data_size	= sizeof(struct linkmodes_reply_data),
-	.request_policy		= ethnl_linkmodes_get_policy,
 
 	.prepare_data		= linkmodes_prepare_data,
 	.reply_size		= linkmodes_reply_size,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index c86ae67e2486..3f0ab6e84fce 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -182,7 +182,6 @@ const struct ethnl_request_ops ethnl_linkstate_request_ops = {
 	.max_attr		= ETHTOOL_A_LINKSTATE_MAX,
 	.req_info_size		= sizeof(struct linkstate_req_info),
 	.reply_data_size	= sizeof(struct linkstate_reply_data),
-	.request_policy		= ethnl_linkstate_get_policy,
 
 	.prepare_data		= linkstate_prepare_data,
 	.reply_size		= linkstate_reply_size,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index dbabac38c191..2f317caa077a 100644
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
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 0100fab5829e..b67c41efaf7e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -269,7 +269,6 @@ static inline void ethnl_ops_complete(struct net_device *dev)
  * @max_attr:         maximum (top level) attribute type
  * @req_info_size:    size of request info
  * @reply_data_size:  size of reply data
- * @request_policy:   netlink policy for message contents
  * @allow_nodev_do:   allow non-dump request with no device identification
  * @parse_request:
  *	Parse request except common header (struct ethnl_req_info). Common
@@ -315,7 +314,6 @@ struct ethnl_request_ops {
 	unsigned int		max_attr;
 	unsigned int		req_info_size;
 	unsigned int		reply_data_size;
-	const struct nla_policy *request_policy;
 	bool			allow_nodev_do;
 
 	int (*parse_request)(struct ethnl_req_info *req_info,
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 40f36f8d6291..32f37240e04d 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -132,7 +132,6 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.max_attr		= ETHTOOL_A_PAUSE_MAX,
 	.req_info_size		= sizeof(struct pause_req_info),
 	.reply_data_size	= sizeof(struct pause_reply_data),
-	.request_policy		= ethnl_pause_get_policy,
 
 	.prepare_data		= pause_prepare_data,
 	.reply_size		= pause_reply_size,
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index 7ebab33f2244..c255c75a7ac0 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -127,7 +127,6 @@ const struct ethnl_request_ops ethnl_privflags_request_ops = {
 	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,
 	.req_info_size		= sizeof(struct privflags_req_info),
 	.reply_data_size	= sizeof(struct privflags_reply_data),
-	.request_policy		= ethnl_privflags_get_policy,
 
 	.prepare_data		= privflags_prepare_data,
 	.reply_size		= privflags_reply_size,
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index eb52639b6ed3..80545845a3c8 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -99,7 +99,6 @@ const struct ethnl_request_ops ethnl_rings_request_ops = {
 	.max_attr		= ETHTOOL_A_RINGS_MAX,
 	.req_info_size		= sizeof(struct rings_req_info),
 	.reply_data_size	= sizeof(struct rings_reply_data),
-	.request_policy		= ethnl_rings_get_policy,
 
 	.prepare_data		= rings_prepare_data,
 	.reply_size		= rings_reply_size,
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 8d30fe0fbe3b..e893f98505d0 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -448,7 +448,6 @@ const struct ethnl_request_ops ethnl_strset_request_ops = {
 	.max_attr		= ETHTOOL_A_STRSET_MAX,
 	.req_info_size		= sizeof(struct strset_req_info),
 	.reply_data_size	= sizeof(struct strset_reply_data),
-	.request_policy		= ethnl_strset_get_policy,
 	.allow_nodev_do		= true,
 
 	.parse_request		= strset_parse_request,
diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index 05d501563dc9..185333d377c9 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -134,7 +134,6 @@ const struct ethnl_request_ops ethnl_tsinfo_request_ops = {
 	.max_attr		= ETHTOOL_A_TSINFO_MAX,
 	.req_info_size		= sizeof(struct tsinfo_req_info),
 	.reply_data_size	= sizeof(struct tsinfo_reply_data),
-	.request_policy		= ethnl_tsinfo_get_policy,
 
 	.prepare_data		= tsinfo_prepare_data,
 	.reply_size		= tsinfo_reply_size,
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index d7d4964ea773..330817adcf62 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
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
-			  ethnl_tunnel_info_get_policy, extack);
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
index d234885fc265..4a88c597890c 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -91,7 +91,6 @@ const struct ethnl_request_ops ethnl_wol_request_ops = {
 	.max_attr		= ETHTOOL_A_WOL_MAX,
 	.req_info_size		= sizeof(struct wol_req_info),
 	.reply_data_size	= sizeof(struct wol_reply_data),
-	.request_policy		= ethnl_wol_get_policy,
 
 	.prepare_data		= wol_prepare_data,
 	.reply_size		= wol_reply_size,
-- 
2.26.2

