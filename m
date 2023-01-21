Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BA267640D
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 06:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjAUFoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 00:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAUFoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 00:44:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8089F6A33F
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 21:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A46601CE
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 05:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCA4C433D2;
        Sat, 21 Jan 2023 05:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674279873;
        bh=1tcIoAKmiLMi/vxjxAwRB/m7dTyBYZBc197JmyqZrXE=;
        h=From:To:Cc:Subject:Date:From;
        b=q93qlc6JxY/y0Vi2DZg+As6wc6ki58uakZUx9SUYL8jTiktxUUrvNU3HV12NOim9Y
         3YkbmZHTEJhdWK0ToZjzGtbBroFaXv5T6tnUPuzNikvJOiAMm4Z/NurQzhFAlGsZSQ
         x32hgNc9x4x8G4b/jFvViCIvQ4wmhFX+hfdZybmxzmntvG8KGNyXE6WMd0zrHbldrn
         aOf0d655qM5MvTrk5VMkYwJ1wbbEZy/MJ/96bBwe8+61ykNKg8SRSrojqOEXOrQVY2
         2H7AFfSluTFvogE3ZS9WUoBvZzJWObit8VzWud46nIVYha+5bOGwPhDMtYzZXnILZr
         /OiIBYFZ8vEWg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, mkubecek@suse.cz
Subject: [PATCH net-next 1/2] ethtool: netlink: handle SET intro/outro in the common code
Date:   Fri, 20 Jan 2023 21:44:29 -0800
Message-Id: <20230121054430.642280-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most ethtool SET callbacks follow the same general structure.

  ethnl_parse_header_dev_get()
  rtnl_lock()
  ethnl_ops_begin()

  ... do stuff ...

  ethtool_notify()
  ethnl_ops_complete()
  rtnl_unlock()
  ethnl_parse_header_dev_put()

This leads to a lot of copy / pasted code an bugs when people
mis-handle the error path.

Add a generic implementation of this pattern with a .set callback
in struct ethnl_request_ops called to "do stuff".

Also add an optional .set_validate which is called before
ethnl_ops_begin() -- a lot of implementations do basic request
capability / sanity checking at that point.

Because we want to avoid generating the notification when
no change happened - adopt a slightly hairy return values:
 - 0 means nothing to do (no notification)
 - 1 means done / continue
 - negative error codes on error

Reuse .hdr_attr from struct ethnl_request_ops, GET and SET
use the same attr spaces in all cases.

Convert pause as an example (and to avoid unused function warnings).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mkubecek@suse.cz
---
 net/ethtool/netlink.c | 49 ++++++++++++++++++++++++++-
 net/ethtool/netlink.h | 22 +++++++++++--
 net/ethtool/pause.c   | 77 +++++++++++++++++--------------------------
 3 files changed, 99 insertions(+), 49 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9f924875bba9..31eaff9eb90b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -279,6 +279,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_CHANNELS_GET]	= &ethnl_channels_request_ops,
 	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
+	[ETHTOOL_MSG_PAUSE_SET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
@@ -590,6 +591,52 @@ static int ethnl_default_done(struct netlink_callback *cb)
 	return 0;
 }
 
+static int ethnl_default_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	const struct ethnl_request_ops *ops;
+	struct ethnl_req_info req_info = {};
+	const u8 cmd = info->genlhdr->cmd;
+	int ret;
+
+	ops = ethnl_default_requests[cmd];
+	if (WARN_ONCE(!ops, "cmd %u has no ethnl_request_ops\n", cmd))
+		return -EOPNOTSUPP;
+	if (GENL_REQ_ATTR_CHECK(info, ops->hdr_attr))
+		return -EINVAL;
+
+	ret = ethnl_parse_header_dev_get(&req_info, info->attrs[ops->hdr_attr],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	if (ops->set_validate) {
+		ret = ops->set_validate(&req_info, info);
+		/* 0 means nothing to do */
+		if (ret <= 0)
+			goto out_dev;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(req_info.dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = ops->set(&req_info, info);
+	if (ret <= 0)
+		goto out_ops;
+	ethtool_notify(req_info.dev, ops->set_ntf_cmd, NULL);
+
+	ret = 0;
+out_ops:
+	ethnl_ops_complete(req_info.dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
+
 static const struct ethnl_request_ops *
 ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= &ethnl_linkinfo_request_ops,
@@ -918,7 +965,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_PAUSE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_pause,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_pause_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_pause_set_policy) - 1,
 	},
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f271266f6e28..e6cd1e5b141e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -258,13 +258,14 @@ int ethnl_ops_begin(struct net_device *dev);
 void ethnl_ops_complete(struct net_device *dev);
 
 /**
- * struct ethnl_request_ops - unified handling of GET requests
+ * struct ethnl_request_ops - unified handling of GET and SET requests
  * @request_cmd:      command id for request (GET)
  * @reply_cmd:        command id for reply (GET_REPLY)
  * @hdr_attr:         attribute type for request header
  * @req_info_size:    size of request info
  * @reply_data_size:  size of reply data
  * @allow_nodev_do:   allow non-dump request with no device identification
+ * @set_ntf_cmd:      notification to generate on changes (SET)
  * @parse_request:
  *	Parse request except common header (struct ethnl_req_info). Common
  *	header is already filled on entry, the rest up to @repdata_offset
@@ -293,6 +294,18 @@ void ethnl_ops_complete(struct net_device *dev);
  *	used e.g. to free any additional data structures outside the main
  *	structure which were allocated by ->prepare_data(). When processing
  *	dump requests, ->cleanup() is called for each message.
+ * @set_validate:
+ *	Check if set operation is supported for a given device, and perform
+ *	extra input checks. Expected return values:
+ *	 - 0 if the operation is a noop for the device (rare)
+ *	 - 1 if operation should proceed to calling @set
+ *	 - negative errno on errors
+ *	Called without any locks, just a reference on the netdev.
+ * @set:
+ *	Execute the set operation. The implementation should return
+ *	 - 0 if no configuration has changed
+ *	 - 1 if configuration changed and notification should be generated
+ *	 - negative errno on errors
  *
  * Description of variable parts of GET request handling when using the
  * unified infrastructure. When used, a pointer to an instance of this
@@ -309,6 +322,7 @@ struct ethnl_request_ops {
 	unsigned int		req_info_size;
 	unsigned int		reply_data_size;
 	bool			allow_nodev_do;
+	u8			set_ntf_cmd;
 
 	int (*parse_request)(struct ethnl_req_info *req_info,
 			     struct nlattr **tb,
@@ -322,6 +336,11 @@ struct ethnl_request_ops {
 			  const struct ethnl_req_info *req_info,
 			  const struct ethnl_reply_data *reply_data);
 	void (*cleanup_data)(struct ethnl_reply_data *reply_data);
+
+	int (*set_validate)(struct ethnl_req_info *req_info,
+			    struct genl_info *info);
+	int (*set)(struct ethnl_req_info *req_info,
+		   struct genl_info *info);
 };
 
 /* request handlers */
@@ -403,7 +422,6 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index a8c113d244db..8e9aced3eeec 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -114,18 +114,6 @@ static int pause_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_pause_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_PAUSE_GET,
-	.reply_cmd		= ETHTOOL_MSG_PAUSE_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_PAUSE_HEADER,
-	.req_info_size		= sizeof(struct pause_req_info),
-	.reply_data_size	= sizeof(struct pause_reply_data),
-
-	.prepare_data		= pause_prepare_data,
-	.reply_size		= pause_reply_size,
-	.fill_reply		= pause_fill_reply,
-};
-
 /* PAUSE_SET */
 
 const struct nla_policy ethnl_pause_set_policy[] = {
@@ -136,51 +124,48 @@ const struct nla_policy ethnl_pause_set_policy[] = {
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_U8 },
 };
 
-int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_pause_validate(struct ethnl_req_info *req_info,
+			 struct genl_info *info)
 {
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_pauseparam && ops->set_pauseparam ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_pause(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct net_device *dev = req_info->dev;
 	struct ethtool_pauseparam params = {};
-	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_PAUSE_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
-	if (!ops->get_pauseparam || !ops->set_pauseparam)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-	ops->get_pauseparam(dev, &params);
+	dev->ethtool_ops->get_pauseparam(dev, &params);
 
 	ethnl_update_bool32(&params.autoneg, tb[ETHTOOL_A_PAUSE_AUTONEG], &mod);
 	ethnl_update_bool32(&params.rx_pause, tb[ETHTOOL_A_PAUSE_RX], &mod);
 	ethnl_update_bool32(&params.tx_pause, tb[ETHTOOL_A_PAUSE_TX], &mod);
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	ret = dev->ethtool_ops->set_pauseparam(dev, &params);
-	if (ret < 0)
-		goto out_ops;
-	ethtool_notify(dev, ETHTOOL_MSG_PAUSE_NTF, NULL);
-
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-out_dev:
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
+	return ret < 0 ? ret : 1;
 }
+
+const struct ethnl_request_ops ethnl_pause_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PAUSE_GET,
+	.reply_cmd		= ETHTOOL_MSG_PAUSE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PAUSE_HEADER,
+	.req_info_size		= sizeof(struct pause_req_info),
+	.reply_data_size	= sizeof(struct pause_reply_data),
+
+	.prepare_data		= pause_prepare_data,
+	.reply_size		= pause_reply_size,
+	.fill_reply		= pause_fill_reply,
+
+	.set_validate		= ethnl_set_pause_validate,
+	.set			= ethnl_set_pause,
+	.set_ntf_cmd		= ETHTOOL_MSG_PAUSE_NTF,
+};
-- 
2.39.0

