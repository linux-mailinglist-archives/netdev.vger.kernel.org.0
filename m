Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E5C67C094
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 00:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjAYXFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 18:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAYXF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 18:05:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516222D165
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5DB6616D8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F836C433A0;
        Wed, 25 Jan 2023 23:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674687922;
        bh=+6pVMkAGP4E/oERjERduENzIfTWHYKC6J1xU6LXXWf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvY0xuY5bgxpHNMFt0MiKIMuAptqmosMkvPKlQgYWjR0/+QH9pLDp5LyI23/f63oL
         8Ro1glRwi3D9wCQ4CqGUVAcDXn+9ZZ2bu0CSf6/Gp5Sk0ETNcr1lvmBMlBh4DmvY4p
         OM4O4ESeB234RsKh4ZZC7Lb4zvMq2yGG6d2IxoXxNG2NvdRtlT1Go93e0JwZh7zlMA
         jsozF8hVpVDepZLpKftzUymOtn5+MeCBeUFhYh0LjeB2oc71ajmX6WoDdNFnydoj1y
         Wk+mpI+CTxnzfRHUG/NHqAOkjD0vXqhzS8LYEYZsO8zEiLph+vcP/0RjzOYoXLY1Sl
         tNwOY2RKDk2Dg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, piergiorgio.beruto@gmail.com,
        gal@nvidia.com, tariqt@nvidia.com, dnlplm@gmail.com,
        sean.anderson@seco.com, linux@rempel-privat.de, lkp@intel.com,
        bagasdotme@gmail.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com, olteanv@gmail.com
Subject: [PATCH net-next v2 2/2] ethtool: netlink: convert commands to common SET
Date:   Wed, 25 Jan 2023 15:05:19 -0800
Message-Id: <20230125230519.1069676-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230125230519.1069676-1-kuba@kernel.org>
References: <20230125230519.1069676-1-kuba@kernel.org>
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

Convert all SET commands where new common code is applicable.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - return -EOPNOTSUPP before -EINVAL for coalesce
 - convert MM

CC: piergiorgio.beruto@gmail.com
CC: gal@nvidia.com
CC: tariqt@nvidia.com
CC: dnlplm@gmail.com
CC: sean.anderson@seco.com
CC: linux@rempel-privat.de
CC: lkp@intel.com
CC: bagasdotme@gmail.com
CC: wangjie125@huawei.com
CC: huangguangbin2@huawei.com
CC: olteanv@gmail.com
---
 net/ethtool/channels.c  |  92 ++++++++++++++----------------------
 net/ethtool/coalesce.c  |  92 ++++++++++++++++--------------------
 net/ethtool/debug.c     |  71 ++++++++++++----------------
 net/ethtool/eee.c       |  78 ++++++++++++-------------------
 net/ethtool/fec.c       |  83 +++++++++++++--------------------
 net/ethtool/linkinfo.c  |  81 ++++++++++++++------------------
 net/ethtool/linkmodes.c |  91 +++++++++++++++++-------------------
 net/ethtool/mm.c        |  82 ++++++++++++--------------------
 net/ethtool/module.c    |  89 ++++++++++++++---------------------
 net/ethtool/netlink.c   |  42 +++++++++++------
 net/ethtool/netlink.h   |  14 ------
 net/ethtool/plca.c      |  75 +++++++++--------------------
 net/ethtool/privflags.c |  84 ++++++++++++++++-----------------
 net/ethtool/pse-pd.c    |  79 ++++++++++++-------------------
 net/ethtool/rings.c     | 101 +++++++++++++++++-----------------------
 net/ethtool/wol.c       |  79 +++++++++++++------------------
 16 files changed, 508 insertions(+), 725 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index c7e37130647e..61c40e889a4d 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -86,18 +86,6 @@ static int channels_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_channels_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_CHANNELS_GET,
-	.reply_cmd		= ETHTOOL_MSG_CHANNELS_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_CHANNELS_HEADER,
-	.req_info_size		= sizeof(struct channels_req_info),
-	.reply_data_size	= sizeof(struct channels_reply_data),
-
-	.prepare_data		= channels_prepare_data,
-	.reply_size		= channels_reply_size,
-	.fill_reply		= channels_fill_reply,
-};
-
 /* CHANNELS_SET */
 
 const struct nla_policy ethnl_channels_set_policy[] = {
@@ -109,36 +97,28 @@ const struct nla_policy ethnl_channels_set_policy[] = {
 	[ETHTOOL_A_CHANNELS_COMBINED_COUNT]	= { .type = NLA_U32 },
 };
 
-int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_channels_validate(struct ethnl_req_info *req_info,
+			    struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_channels && ops->set_channels ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_channels(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	unsigned int from_channel, old_total, i;
 	bool mod = false, mod_combined = false;
+	struct net_device *dev = req_info->dev;
 	struct ethtool_channels channels = {};
-	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	u32 err_attr, max_rxfh_in_use;
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
 	u64 max_rxnfc_in_use;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_CHANNELS_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
-	if (!ops->get_channels || !ops->set_channels)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-	ops->get_channels(dev, &channels);
+	dev->ethtool_ops->get_channels(dev, &channels);
 	old_total = channels.combined_count +
 		    max(channels.rx_count, channels.tx_count);
 
@@ -151,9 +131,8 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&channels.combined_count,
 			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod_combined);
 	mod |= mod_combined;
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	/* ensure new channel counts are within limits */
 	if (channels.rx_count > channels.max_rx)
@@ -167,10 +146,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	else
 		err_attr = 0;
 	if (err_attr) {
-		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
 				    "requested channel count exceeds maximum");
-		goto out_ops;
+		return -EINVAL;
 	}
 
 	/* ensure there is at least one RX and one TX channel */
@@ -183,10 +161,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	if (err_attr) {
 		if (mod_combined)
 			err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
-		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
 				    "requested channel counts would result in no RX or TX channel being configured");
-		goto out_ops;
+		return -EINVAL;
 	}
 
 	/* ensure the new Rx count fits within the configured Rx flow
@@ -198,14 +175,12 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	    ethtool_get_max_rxfh_channel(dev, &max_rxfh_in_use))
 		max_rxfh_in_use = 0;
 	if (channels.combined_count + channels.rx_count <= max_rxfh_in_use) {
-		ret = -EINVAL;
 		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
-		goto out_ops;
+		return -EINVAL;
 	}
 	if (channels.combined_count + channels.rx_count <= max_rxnfc_in_use) {
-		ret = -EINVAL;
 		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing ntuple filter settings");
-		goto out_ops;
+		return -EINVAL;
 	}
 
 	/* Disabling channels, query zero-copy AF_XDP sockets */
@@ -213,21 +188,26 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 		       min(channels.rx_count, channels.tx_count);
 	for (i = from_channel; i < old_total; i++)
 		if (xsk_get_pool_from_qid(dev, i)) {
-			ret = -EINVAL;
 			GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing zerocopy AF_XDP sockets");
-			goto out_ops;
+			return -EINVAL;
 		}
 
 	ret = dev->ethtool_ops->set_channels(dev, &channels);
-	if (ret < 0)
-		goto out_ops;
-	ethtool_notify(dev, ETHTOOL_MSG_CHANNELS_NTF, NULL);
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
+const struct ethnl_request_ops ethnl_channels_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_CHANNELS_GET,
+	.reply_cmd		= ETHTOOL_MSG_CHANNELS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_CHANNELS_HEADER,
+	.req_info_size		= sizeof(struct channels_req_info),
+	.reply_data_size	= sizeof(struct channels_reply_data),
+
+	.prepare_data		= channels_prepare_data,
+	.reply_size		= channels_reply_size,
+	.fill_reply		= channels_fill_reply,
+
+	.set_validate		= ethnl_set_channels_validate,
+	.set			= ethnl_set_channels,
+	.set_ntf_cmd		= ETHTOOL_MSG_CHANNELS_NTF,
+};
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index e405b47f7eed..443e7e642c96 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -195,18 +195,6 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_coalesce_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_COALESCE_GET,
-	.reply_cmd		= ETHTOOL_MSG_COALESCE_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_COALESCE_HEADER,
-	.req_info_size		= sizeof(struct coalesce_req_info),
-	.reply_data_size	= sizeof(struct coalesce_reply_data),
-
-	.prepare_data		= coalesce_prepare_data,
-	.reply_size		= coalesce_reply_size,
-	.fill_reply		= coalesce_fill_reply,
-};
-
 /* COALESCE_SET */
 
 const struct nla_policy ethnl_coalesce_set_policy[] = {
@@ -241,49 +229,44 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS] = { .type = NLA_U32 },
 };
 
-int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_coalesce_validate(struct ethnl_req_info *req_info,
+			    struct genl_info *info)
 {
-	struct kernel_ethtool_coalesce kernel_coalesce = {};
-	struct ethtool_coalesce coalesce = {};
-	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
 	struct nlattr **tb = info->attrs;
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
 	u32 supported_params;
-	bool mod = false;
-	int ret;
 	u16 a;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_COALESCE_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
 	if (!ops->get_coalesce || !ops->set_coalesce)
-		goto out_dev;
+		return -EOPNOTSUPP;
 
 	/* make sure that only supported parameters are present */
 	supported_params = ops->supported_coalesce_params;
 	for (a = ETHTOOL_A_COALESCE_RX_USECS; a < __ETHTOOL_A_COALESCE_CNT; a++)
 		if (tb[a] && !(supported_params & attr_to_mask(a))) {
-			ret = -EINVAL;
 			NL_SET_ERR_MSG_ATTR(info->extack, tb[a],
 					    "cannot modify an unsupported parameter");
-			goto out_dev;
+			return -EINVAL;
 		}
 
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-	ret = ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
-				info->extack);
+	return 1;
+}
+
+static int
+ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct kernel_ethtool_coalesce kernel_coalesce = {};
+	struct net_device *dev = req_info->dev;
+	struct ethtool_coalesce coalesce = {};
+	struct nlattr **tb = info->attrs;
+	bool mod = false;
+	int ret;
+
+	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
+					     info->extack);
 	if (ret < 0)
-		goto out_ops;
+		return ret;
 
 	ethnl_update_u32(&coalesce.rx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS], &mod);
@@ -339,21 +322,26 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES], &mod);
 	ethnl_update_u32(&kernel_coalesce.tx_aggr_time_usecs,
 			 tb[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS], &mod);
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce, &kernel_coalesce,
 					     info->extack);
-	if (ret < 0)
-		goto out_ops;
-	ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
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
+const struct ethnl_request_ops ethnl_coalesce_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_COALESCE_GET,
+	.reply_cmd		= ETHTOOL_MSG_COALESCE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_COALESCE_HEADER,
+	.req_info_size		= sizeof(struct coalesce_req_info),
+	.reply_data_size	= sizeof(struct coalesce_reply_data),
+
+	.prepare_data		= coalesce_prepare_data,
+	.reply_size		= coalesce_reply_size,
+	.fill_reply		= coalesce_fill_reply,
+
+	.set_validate		= ethnl_set_coalesce_validate,
+	.set			= ethnl_set_coalesce,
+	.set_ntf_cmd		= ETHTOOL_MSG_COALESCE_NTF,
+};
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index d73888c7d19c..e4369769817e 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -63,18 +63,6 @@ static int debug_fill_reply(struct sk_buff *skb,
 				  netif_msg_class_names, compact);
 }
 
-const struct ethnl_request_ops ethnl_debug_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_DEBUG_GET,
-	.reply_cmd		= ETHTOOL_MSG_DEBUG_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_DEBUG_HEADER,
-	.req_info_size		= sizeof(struct debug_req_info),
-	.reply_data_size	= sizeof(struct debug_reply_data),
-
-	.prepare_data		= debug_prepare_data,
-	.reply_size		= debug_reply_size,
-	.fill_reply		= debug_fill_reply,
-};
-
 /* DEBUG_SET */
 
 const struct nla_policy ethnl_debug_set_policy[] = {
@@ -83,46 +71,47 @@ const struct nla_policy ethnl_debug_set_policy[] = {
 	[ETHTOOL_A_DEBUG_MSGMASK]	= { .type = NLA_NESTED },
 };
 
-int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_debug_validate(struct ethnl_req_info *req_info,
+			 struct genl_info *info)
 {
-	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_msglevel && ops->set_msglevel ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_debug(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
-	struct net_device *dev;
 	bool mod = false;
 	u32 msg_mask;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_DEBUG_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ret = -EOPNOTSUPP;
-	if (!dev->ethtool_ops->get_msglevel || !dev->ethtool_ops->set_msglevel)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-
 	msg_mask = dev->ethtool_ops->get_msglevel(dev);
 	ret = ethnl_update_bitset32(&msg_mask, NETIF_MSG_CLASS_COUNT,
 				    tb[ETHTOOL_A_DEBUG_MSGMASK],
 				    netif_msg_class_names, info->extack, &mod);
 	if (ret < 0 || !mod)
-		goto out_ops;
+		return ret;
 
 	dev->ethtool_ops->set_msglevel(dev, msg_mask);
-	ethtool_notify(dev, ETHTOOL_MSG_DEBUG_NTF, NULL);
-
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-out_dev:
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
+	return 1;
 }
+
+const struct ethnl_request_ops ethnl_debug_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_DEBUG_GET,
+	.reply_cmd		= ETHTOOL_MSG_DEBUG_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_DEBUG_HEADER,
+	.req_info_size		= sizeof(struct debug_req_info),
+	.reply_data_size	= sizeof(struct debug_reply_data),
+
+	.prepare_data		= debug_prepare_data,
+	.reply_size		= debug_reply_size,
+	.fill_reply		= debug_fill_reply,
+
+	.set_validate		= ethnl_set_debug_validate,
+	.set			= ethnl_set_debug,
+	.set_ntf_cmd		= ETHTOOL_MSG_DEBUG_NTF,
+};
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index 45c42b2d5f17..42104bcb0e47 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -108,18 +108,6 @@ static int eee_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_eee_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_EEE_GET,
-	.reply_cmd		= ETHTOOL_MSG_EEE_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_EEE_HEADER,
-	.req_info_size		= sizeof(struct eee_req_info),
-	.reply_data_size	= sizeof(struct eee_reply_data),
-
-	.prepare_data		= eee_prepare_data,
-	.reply_size		= eee_reply_size,
-	.fill_reply		= eee_fill_reply,
-};
-
 /* EEE_SET */
 
 const struct nla_policy ethnl_eee_set_policy[] = {
@@ -131,60 +119,56 @@ const struct nla_policy ethnl_eee_set_policy[] = {
 	[ETHTOOL_A_EEE_TX_LPI_TIMER]	= { .type = NLA_U32 },
 };
 
-int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_eee_validate(struct ethnl_req_info *req_info, struct genl_info *info)
 {
-	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_eee && ops->set_eee ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_eee(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
-	const struct ethtool_ops *ops;
 	struct ethtool_eee eee = {};
-	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_EEE_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
+	ret = dev->ethtool_ops->get_eee(dev, &eee);
 	if (ret < 0)
 		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
-	if (!ops->get_eee || !ops->set_eee)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-	ret = ops->get_eee(dev, &eee);
-	if (ret < 0)
-		goto out_ops;
 
 	ret = ethnl_update_bitset32(&eee.advertised, EEE_MODES_COUNT,
 				    tb[ETHTOOL_A_EEE_MODES_OURS],
 				    link_mode_names, info->extack, &mod);
 	if (ret < 0)
-		goto out_ops;
+		return ret;
 	ethnl_update_bool32(&eee.eee_enabled, tb[ETHTOOL_A_EEE_ENABLED], &mod);
 	ethnl_update_bool32(&eee.tx_lpi_enabled,
 			    tb[ETHTOOL_A_EEE_TX_LPI_ENABLED], &mod);
 	ethnl_update_u32(&eee.tx_lpi_timer, tb[ETHTOOL_A_EEE_TX_LPI_TIMER],
 			 &mod);
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	ret = dev->ethtool_ops->set_eee(dev, &eee);
-	if (ret < 0)
-		goto out_ops;
-	ethtool_notify(dev, ETHTOOL_MSG_EEE_NTF, NULL);
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
+const struct ethnl_request_ops ethnl_eee_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_EEE_GET,
+	.reply_cmd		= ETHTOOL_MSG_EEE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_EEE_HEADER,
+	.req_info_size		= sizeof(struct eee_req_info),
+	.reply_data_size	= sizeof(struct eee_reply_data),
+
+	.prepare_data		= eee_prepare_data,
+	.reply_size		= eee_reply_size,
+	.fill_reply		= eee_fill_reply,
+
+	.set_validate		= ethnl_set_eee_validate,
+	.set			= ethnl_set_eee,
+	.set_ntf_cmd		= ETHTOOL_MSG_EEE_NTF,
+};
diff --git a/net/ethtool/fec.c b/net/ethtool/fec.c
index 9f5a134e2e01..0d9a3d153170 100644
--- a/net/ethtool/fec.c
+++ b/net/ethtool/fec.c
@@ -217,18 +217,6 @@ static int fec_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_fec_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_FEC_GET,
-	.reply_cmd		= ETHTOOL_MSG_FEC_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_FEC_HEADER,
-	.req_info_size		= sizeof(struct fec_req_info),
-	.reply_data_size	= sizeof(struct fec_reply_data),
-
-	.prepare_data		= fec_prepare_data,
-	.reply_size		= fec_reply_size,
-	.fill_reply		= fec_fill_reply,
-};
-
 /* FEC_SET */
 
 const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1] = {
@@ -237,36 +225,28 @@ const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1] = {
 	[ETHTOOL_A_FEC_AUTO]	= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
-int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_fec_validate(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_fecparam && ops->set_fecparam ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_fec(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(fec_link_modes) = {};
-	struct ethnl_req_info req_info = {};
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
 	struct ethtool_fecparam fec = {};
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
 	bool mod = false;
 	u8 fec_auto;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_FEC_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
+	ret = dev->ethtool_ops->get_fecparam(dev, &fec);
 	if (ret < 0)
 		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
-	if (!ops->get_fecparam || !ops->set_fecparam)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-	ret = ops->get_fecparam(dev, &fec);
-	if (ret < 0)
-		goto out_ops;
 
 	ethtool_fec_to_link_modes(fec.fec, fec_link_modes, &fec_auto);
 
@@ -275,36 +255,39 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info)
 				  tb[ETHTOOL_A_FEC_MODES],
 				  link_mode_names, info->extack, &mod);
 	if (ret < 0)
-		goto out_ops;
+		return ret;
 	ethnl_update_u8(&fec_auto, tb[ETHTOOL_A_FEC_AUTO], &mod);
-
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	ret = ethtool_link_modes_to_fecparam(&fec, fec_link_modes, fec_auto);
 	if (ret) {
 		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_FEC_MODES],
 				    "invalid FEC modes requested");
-		goto out_ops;
+		return ret;
 	}
 	if (!fec.fec) {
-		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_FEC_MODES],
 				    "no FEC modes set");
-		goto out_ops;
+		return -EINVAL;
 	}
 
 	ret = dev->ethtool_ops->set_fecparam(dev, &fec);
-	if (ret < 0)
-		goto out_ops;
-	ethtool_notify(dev, ETHTOOL_MSG_FEC_NTF, NULL);
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
+const struct ethnl_request_ops ethnl_fec_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_FEC_GET,
+	.reply_cmd		= ETHTOOL_MSG_FEC_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_FEC_HEADER,
+	.req_info_size		= sizeof(struct fec_req_info),
+	.reply_data_size	= sizeof(struct fec_reply_data),
+
+	.prepare_data		= fec_prepare_data,
+	.reply_size		= fec_reply_size,
+	.fill_reply		= fec_fill_reply,
+
+	.set_validate		= ethnl_set_fec_validate,
+	.set			= ethnl_set_fec,
+	.set_ntf_cmd		= ETHTOOL_MSG_FEC_NTF,
+};
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index efa0f7f48836..310dfe63292a 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -73,18 +73,6 @@ static int linkinfo_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
-	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
-	.req_info_size		= sizeof(struct linkinfo_req_info),
-	.reply_data_size	= sizeof(struct linkinfo_reply_data),
-
-	.prepare_data		= linkinfo_prepare_data,
-	.reply_size		= linkinfo_reply_size,
-	.fill_reply		= linkinfo_fill_reply,
-};
-
 /* LINKINFO_SET */
 
 const struct nla_policy ethnl_linkinfo_set_policy[] = {
@@ -95,37 +83,31 @@ const struct nla_policy ethnl_linkinfo_set_policy[] = {
 	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_U8 },
 };
 
-int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_linkinfo_validate(struct ethnl_req_info *req_info,
+			    struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	if (!ops->get_link_ksettings || !ops->set_link_ksettings)
+		return -EOPNOTSUPP;
+	return 1;
+}
+
+static int
+ethnl_set_linkinfo(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	struct ethtool_link_ksettings ksettings = {};
 	struct ethtool_link_settings *lsettings;
-	struct ethnl_req_info req_info = {};
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
-	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_LINKINFO_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ret = -EOPNOTSUPP;
-	if (!dev->ethtool_ops->get_link_ksettings ||
-	    !dev->ethtool_ops->set_link_ksettings)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-
 	ret = __ethtool_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
-		goto out_ops;
+		return ret;
 	}
 	lsettings = &ksettings.base;
 
@@ -134,21 +116,30 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 			&mod);
 	ethnl_update_u8(&lsettings->eth_tp_mdix_ctrl,
 			tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL], &mod);
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
-	if (ret < 0)
+	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "link settings update failed");
-	else
-		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+		return ret;
+	}
 
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-out_dev:
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
+	return 1;
 }
+
+const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
+	.req_info_size		= sizeof(struct linkinfo_req_info),
+	.reply_data_size	= sizeof(struct linkinfo_reply_data),
+
+	.prepare_data		= linkinfo_prepare_data,
+	.reply_size		= linkinfo_reply_size,
+	.fill_reply		= linkinfo_fill_reply,
+
+	.set_validate		= ethnl_set_linkinfo_validate,
+	.set			= ethnl_set_linkinfo,
+	.set_ntf_cmd		= ETHTOOL_MSG_LINKINFO_NTF,
+};
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 126e06c713a3..fab66c169b9f 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -151,18 +151,6 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_LINKMODES_GET,
-	.reply_cmd		= ETHTOOL_MSG_LINKMODES_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_LINKMODES_HEADER,
-	.req_info_size		= sizeof(struct linkmodes_req_info),
-	.reply_data_size	= sizeof(struct linkmodes_reply_data),
-
-	.prepare_data		= linkmodes_prepare_data,
-	.reply_size		= linkmodes_reply_size,
-	.fill_reply		= linkmodes_fill_reply,
-};
-
 /* LINKMODES_SET */
 
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
@@ -310,59 +298,64 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 	return 0;
 }
 
-int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_linkmodes_validate(struct ethnl_req_info *req_info,
+			     struct genl_info *info)
 {
-	struct ethtool_link_ksettings ksettings = {};
-	struct ethnl_req_info req_info = {};
-	struct nlattr **tb = info->attrs;
-	struct net_device *dev;
-	bool mod = false;
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
 	int ret;
 
-	ret = ethnl_check_linkmodes(info, tb);
+	ret = ethnl_check_linkmodes(info, info->attrs);
 	if (ret < 0)
 		return ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_LINKMODES_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ret = -EOPNOTSUPP;
-	if (!dev->ethtool_ops->get_link_ksettings ||
-	    !dev->ethtool_ops->set_link_ksettings)
-		goto out_dev;
+	if (!ops->get_link_ksettings || !ops->set_link_ksettings)
+		return -EOPNOTSUPP;
+	return 1;
+}
 
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
+static int
+ethnl_set_linkmodes(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct ethtool_link_ksettings ksettings = {};
+	struct net_device *dev = req_info->dev;
+	struct nlattr **tb = info->attrs;
+	bool mod = false;
+	int ret;
 
 	ret = __ethtool_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
-		goto out_ops;
+		return ret;
 	}
 
 	ret = ethnl_update_linkmodes(info, tb, &ksettings, &mod, dev);
 	if (ret < 0)
-		goto out_ops;
+		return ret;
+	if (!mod)
+		return 0;
 
-	if (mod) {
-		ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
-		if (ret < 0)
-			GENL_SET_ERR_MSG(info, "link settings update failed");
-		else
-			ethtool_notify(dev, ETHTOOL_MSG_LINKMODES_NTF, NULL);
+	ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
+	if (ret < 0) {
+		GENL_SET_ERR_MSG(info, "link settings update failed");
+		return ret;
 	}
 
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-out_dev:
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
+	return 1;
 }
+
+const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKMODES_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKMODES_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKMODES_HEADER,
+	.req_info_size		= sizeof(struct linkmodes_req_info),
+	.reply_data_size	= sizeof(struct linkmodes_reply_data),
+
+	.prepare_data		= linkmodes_prepare_data,
+	.reply_size		= linkmodes_reply_size,
+	.fill_reply		= linkmodes_fill_reply,
+
+	.set_validate		= ethnl_set_linkmodes_validate,
+	.set			= ethnl_set_linkmodes,
+	.set_ntf_cmd		= ETHTOOL_MSG_LINKMODES_NTF,
+};
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index 3e8acdb806fd..7e51f7633001 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -146,18 +146,6 @@ static int mm_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_mm_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_MM_GET,
-	.reply_cmd		= ETHTOOL_MSG_MM_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_MM_HEADER,
-	.req_info_size		= sizeof(struct mm_req_info),
-	.reply_data_size	= sizeof(struct mm_reply_data),
-
-	.prepare_data		= mm_prepare_data,
-	.reply_size		= mm_reply_size,
-	.fill_reply		= mm_fill_reply,
-};
-
 const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1] = {
 	[ETHTOOL_A_MM_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_MM_VERIFY_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
@@ -184,40 +172,28 @@ static void mm_state_to_cfg(const struct ethtool_mm_state *state,
 	cfg->tx_min_frag_size = state->tx_min_frag_size;
 }
 
-int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_mm_validate(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_mm && ops->set_mm ? 1 : -EOPNOTSUPP;
+}
+
+static int ethnl_set_mm(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	struct netlink_ext_ack *extack = info->extack;
-	struct ethnl_req_info req_info = {};
+	struct net_device *dev = req_info->dev;
 	struct ethtool_mm_state state = {};
 	struct nlattr **tb = info->attrs;
 	struct ethtool_mm_cfg cfg = {};
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MM_HEADER],
-					 genl_info_net(info), extack, true);
+	ret = dev->ethtool_ops->get_mm(dev, &state);
 	if (ret)
 		return ret;
 
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-
-	if (!ops->get_mm || !ops->set_mm) {
-		ret = -EOPNOTSUPP;
-		goto out_dev_put;
-	}
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl_unlock;
-
-	ret = ops->get_mm(dev, &state);
-	if (ret)
-		goto out_complete;
-
 	mm_state_to_cfg(&state, &cfg);
 
 	ethnl_update_bool(&cfg.verify_enabled, tb[ETHTOOL_A_MM_VERIFY_ENABLED],
@@ -225,34 +201,38 @@ int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&cfg.verify_time, tb[ETHTOOL_A_MM_VERIFY_TIME], &mod);
 	ethnl_update_bool(&cfg.tx_enabled, tb[ETHTOOL_A_MM_TX_ENABLED], &mod);
 	ethnl_update_bool(&cfg.pmac_enabled, tb[ETHTOOL_A_MM_PMAC_ENABLED],
-			    &mod);
+			  &mod);
 	ethnl_update_u32(&cfg.tx_min_frag_size,
 			 tb[ETHTOOL_A_MM_TX_MIN_FRAG_SIZE], &mod);
 
 	if (!mod)
-		goto out_complete;
+		return 0;
 
 	if (cfg.verify_time > state.max_verify_time) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MM_VERIFY_TIME],
 				    "verifyTime exceeds device maximum");
-		ret = -ERANGE;
-		goto out_complete;
+		return -ERANGE;
 	}
 
-	ret = ops->set_mm(dev, &cfg, extack);
-	if (ret)
-		goto out_complete;
+	ret = dev->ethtool_ops->set_mm(dev, &cfg, extack);
+	return ret < 0 ? ret : 1;
+}
+
+const struct ethnl_request_ops ethnl_mm_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MM_GET,
+	.reply_cmd		= ETHTOOL_MSG_MM_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MM_HEADER,
+	.req_info_size		= sizeof(struct mm_req_info),
+	.reply_data_size	= sizeof(struct mm_reply_data),
 
-	ethtool_notify(dev, ETHTOOL_MSG_MM_NTF, NULL);
+	.prepare_data		= mm_prepare_data,
+	.reply_size		= mm_reply_size,
+	.fill_reply		= mm_fill_reply,
 
-out_complete:
-	ethnl_ops_complete(dev);
-out_rtnl_unlock:
-	rtnl_unlock();
-out_dev_put:
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
-}
+	.set_validate		= ethnl_set_mm_validate,
+	.set			= ethnl_set_mm,
+	.set_ntf_cmd		= ETHTOOL_MSG_MM_NTF,
+};
 
 /* Returns whether a given device supports the MAC merge layer
  * (has an eMAC and a pMAC). Must be called under rtnl_lock() and
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 898ed436b9e4..e0d539b21423 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -91,18 +91,6 @@ static int module_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_module_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_MODULE_GET,
-	.reply_cmd		= ETHTOOL_MSG_MODULE_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_MODULE_HEADER,
-	.req_info_size		= sizeof(struct module_req_info),
-	.reply_data_size	= sizeof(struct module_reply_data),
-
-	.prepare_data		= module_prepare_data,
-	.reply_size		= module_reply_size,
-	.fill_reply		= module_fill_reply,
-};
-
 /* MODULE_SET */
 
 const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1] = {
@@ -112,69 +100,62 @@ const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLI
 				 ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO),
 };
 
-static int module_set_power_mode(struct net_device *dev, struct nlattr **tb,
-				 bool *p_mod, struct netlink_ext_ack *extack)
+static int
+ethnl_set_module_validate(struct ethnl_req_info *req_info,
+			  struct genl_info *info)
 {
-	struct ethtool_module_power_mode_params power = {};
-	struct ethtool_module_power_mode_params power_new;
-	const struct ethtool_ops *ops = dev->ethtool_ops;
-	int ret;
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+	struct nlattr **tb = info->attrs;
 
 	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
 		return 0;
 
 	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
-		NL_SET_ERR_MSG_ATTR(extack,
+		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
 				    "Setting power mode policy is not supported by this device");
 		return -EOPNOTSUPP;
 	}
 
-	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
-	ret = ops->get_module_power_mode(dev, &power, extack);
-	if (ret < 0)
-		return ret;
-
-	if (power_new.policy == power.policy)
-		return 0;
-	*p_mod = true;
-
-	return ops->set_module_power_mode(dev, &power_new, extack);
+	return 1;
 }
 
-int ethnl_set_module(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_module(struct ethnl_req_info *req_info, struct genl_info *info)
 {
-	struct ethnl_req_info req_info = {};
+	struct ethtool_module_power_mode_params power = {};
+	struct ethtool_module_power_mode_params power_new;
+	const struct ethtool_ops *ops;
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
-	struct net_device *dev;
-	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MODULE_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
+	ops = dev->ethtool_ops;
+
+	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
+	ret = ops->get_module_power_mode(dev, &power, info->extack);
 	if (ret < 0)
 		return ret;
-	dev = req_info.dev;
 
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
+	if (power_new.policy == power.policy)
+		return 0;
 
-	ret = module_set_power_mode(dev, tb, &mod, info->extack);
-	if (ret < 0)
-		goto out_ops;
+	ret = ops->set_module_power_mode(dev, &power_new, info->extack);
+	return ret < 0 ? ret : 1;
+}
 
-	if (!mod)
-		goto out_ops;
+const struct ethnl_request_ops ethnl_module_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MODULE_GET,
+	.reply_cmd		= ETHTOOL_MSG_MODULE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MODULE_HEADER,
+	.req_info_size		= sizeof(struct module_req_info),
+	.reply_data_size	= sizeof(struct module_reply_data),
 
-	ethtool_notify(dev, ETHTOOL_MSG_MODULE_NTF, NULL);
+	.prepare_data		= module_prepare_data,
+	.reply_size		= module_reply_size,
+	.fill_reply		= module_fill_reply,
 
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
-}
+	.set_validate		= ethnl_set_module_validate,
+	.set			= ethnl_set_module,
+	.set_ntf_cmd		= ETHTOOL_MSG_MODULE_NTF,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index e90ac1f0a1d7..08120095cc68 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -269,29 +269,43 @@ static const struct ethnl_request_ops *
 ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &ethnl_strset_request_ops,
 	[ETHTOOL_MSG_LINKINFO_GET]	= &ethnl_linkinfo_request_ops,
+	[ETHTOOL_MSG_LINKINFO_SET]	= &ethnl_linkinfo_request_ops,
 	[ETHTOOL_MSG_LINKMODES_GET]	= &ethnl_linkmodes_request_ops,
+	[ETHTOOL_MSG_LINKMODES_SET]	= &ethnl_linkmodes_request_ops,
 	[ETHTOOL_MSG_LINKSTATE_GET]	= &ethnl_linkstate_request_ops,
 	[ETHTOOL_MSG_DEBUG_GET]		= &ethnl_debug_request_ops,
+	[ETHTOOL_MSG_DEBUG_SET]		= &ethnl_debug_request_ops,
 	[ETHTOOL_MSG_WOL_GET]		= &ethnl_wol_request_ops,
+	[ETHTOOL_MSG_WOL_SET]		= &ethnl_wol_request_ops,
 	[ETHTOOL_MSG_FEATURES_GET]	= &ethnl_features_request_ops,
 	[ETHTOOL_MSG_PRIVFLAGS_GET]	= &ethnl_privflags_request_ops,
+	[ETHTOOL_MSG_PRIVFLAGS_SET]	= &ethnl_privflags_request_ops,
 	[ETHTOOL_MSG_RINGS_GET]		= &ethnl_rings_request_ops,
+	[ETHTOOL_MSG_RINGS_SET]		= &ethnl_rings_request_ops,
 	[ETHTOOL_MSG_CHANNELS_GET]	= &ethnl_channels_request_ops,
+	[ETHTOOL_MSG_CHANNELS_SET]	= &ethnl_channels_request_ops,
 	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
+	[ETHTOOL_MSG_COALESCE_SET]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_PAUSE_SET]		= &ethnl_pause_request_ops,
 	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
+	[ETHTOOL_MSG_EEE_SET]		= &ethnl_eee_request_ops,
 	[ETHTOOL_MSG_FEC_GET]		= &ethnl_fec_request_ops,
+	[ETHTOOL_MSG_FEC_SET]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_TSINFO_GET]	= &ethnl_tsinfo_request_ops,
 	[ETHTOOL_MSG_MODULE_EEPROM_GET]	= &ethnl_module_eeprom_request_ops,
 	[ETHTOOL_MSG_STATS_GET]		= &ethnl_stats_request_ops,
 	[ETHTOOL_MSG_PHC_VCLOCKS_GET]	= &ethnl_phc_vclocks_request_ops,
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
+	[ETHTOOL_MSG_MODULE_SET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
+	[ETHTOOL_MSG_PSE_SET]		= &ethnl_pse_request_ops,
 	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_CFG]	= &ethnl_plca_cfg_request_ops,
+	[ETHTOOL_MSG_PLCA_SET_CFG]	= &ethnl_plca_cfg_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
 	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
+	[ETHTOOL_MSG_MM_SET]		= &ethnl_mm_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -814,7 +828,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_linkinfo,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_linkinfo_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_linkinfo_set_policy) - 1,
 	},
@@ -830,7 +844,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_LINKMODES_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_linkmodes,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_linkmodes_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_linkmodes_set_policy) - 1,
 	},
@@ -855,7 +869,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_DEBUG_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_debug,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_debug_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_debug_set_policy) - 1,
 	},
@@ -872,7 +886,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_WOL_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_wol,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_wol_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_wol_set_policy) - 1,
 	},
@@ -904,7 +918,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_PRIVFLAGS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_privflags,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_privflags_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_privflags_set_policy) - 1,
 	},
@@ -920,7 +934,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_RINGS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_rings,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_rings_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_rings_set_policy) - 1,
 	},
@@ -936,7 +950,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_channels,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_channels_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_channels_set_policy) - 1,
 	},
@@ -952,7 +966,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_COALESCE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_coalesce,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_coalesce_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_coalesce_set_policy) - 1,
 	},
@@ -984,7 +998,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_EEE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_eee,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_eee_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_eee_set_policy) - 1,
 	},
@@ -1031,7 +1045,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_FEC_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_fec,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_fec_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_fec_set_policy) - 1,
 	},
@@ -1075,7 +1089,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_MODULE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_module,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_module_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_module_set_policy) - 1,
 	},
@@ -1091,7 +1105,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_PSE_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_pse,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_pse_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_pse_set_policy) - 1,
 	},
@@ -1113,7 +1127,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_PLCA_SET_CFG,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_plca_cfg,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_plca_set_cfg_policy,
 		.maxattr = ARRAY_SIZE(ethnl_plca_set_cfg_policy) - 1,
 	},
@@ -1138,7 +1152,7 @@ static const struct genl_ops ethtool_genl_ops[] = {
 	{
 		.cmd	= ETHTOOL_MSG_MM_SET,
 		.flags	= GENL_UNS_ADMIN_PERM,
-		.doit	= ethnl_set_mm,
+		.doit	= ethnl_default_set_doit,
 		.policy = ethnl_mm_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
 	},
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index aca4bdb637a6..ae0732460e88 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -442,26 +442,12 @@ extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADE
 extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
 extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
 
-int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info);
 int ethnl_tunnel_info_start(struct netlink_callback *cb);
 int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
-int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info);
-int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index be7404dc9ef2..5a8cab4df0c9 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -112,18 +112,6 @@ static int plca_get_cfg_fill_reply(struct sk_buff *skb,
 	return 0;
 };
 
-const struct ethnl_request_ops ethnl_plca_cfg_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_PLCA_GET_CFG,
-	.reply_cmd		= ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
-	.hdr_attr		= ETHTOOL_A_PLCA_HEADER,
-	.req_info_size		= sizeof(struct plca_req_info),
-	.reply_data_size	= sizeof(struct plca_reply_data),
-
-	.prepare_data		= plca_get_cfg_prepare_data,
-	.reply_size		= plca_get_cfg_reply_size,
-	.fill_reply		= plca_get_cfg_fill_reply,
-};
-
 // PLCA set configuration message ------------------------------------------- //
 
 const struct nla_policy ethnl_plca_set_cfg_policy[] = {
@@ -137,42 +125,23 @@ const struct nla_policy ethnl_plca_set_cfg_policy[] = {
 	[ETHTOOL_A_PLCA_BURST_TMR]	= NLA_POLICY_MAX(NLA_U32, 255),
 };
 
-int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_plca(struct ethnl_req_info *req_info, struct genl_info *info)
 {
-	struct ethnl_req_info req_info = {};
-	struct nlattr **tb = info->attrs;
+	struct net_device *dev = req_info->dev;
 	const struct ethtool_phy_ops *ops;
+	struct nlattr **tb = info->attrs;
 	struct phy_plca_cfg plca_cfg;
-	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_PLCA_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-
-	dev = req_info.dev;
-
-	rtnl_lock();
-
 	// check that the PHY device is available and connected
-	if (!dev->phydev) {
-		ret = -EOPNOTSUPP;
-		goto out_rtnl;
-	}
+	if (!dev->phydev)
+		return -EOPNOTSUPP;
 
 	ops = ethtool_phy_ops;
-	if (!ops || !ops->set_plca_cfg) {
-		ret = -EOPNOTSUPP;
-		goto out_rtnl;
-	}
-
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
+	if (!ops || !ops->set_plca_cfg)
+		return -EOPNOTSUPP;
 
 	memset(&plca_cfg, 0xff, sizeof(plca_cfg));
 	plca_update_sint(&plca_cfg.enabled, tb[ETHTOOL_A_PLCA_ENABLED], &mod);
@@ -183,25 +152,27 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 			 &mod);
 	plca_update_sint(&plca_cfg.burst_tmr, tb[ETHTOOL_A_PLCA_BURST_TMR],
 			 &mod);
-
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	ret = ops->set_plca_cfg(dev->phydev, &plca_cfg, info->extack);
-	if (ret < 0)
-		goto out_ops;
+	return ret < 0 ? ret : 1;
+}
 
-	ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
+const struct ethnl_request_ops ethnl_plca_cfg_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PLCA_GET_CFG,
+	.reply_cmd		= ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
+	.hdr_attr		= ETHTOOL_A_PLCA_HEADER,
+	.req_info_size		= sizeof(struct plca_req_info),
+	.reply_data_size	= sizeof(struct plca_reply_data),
 
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-	ethnl_parse_header_dev_put(&req_info);
+	.prepare_data		= plca_get_cfg_prepare_data,
+	.reply_size		= plca_get_cfg_reply_size,
+	.fill_reply		= plca_get_cfg_fill_reply,
 
-	return ret;
-}
+	.set			= ethnl_set_plca,
+	.set_ntf_cmd		= ETHTOOL_MSG_PLCA_NTF,
+};
 
 // PLCA get status message -------------------------------------------------- //
 
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index 4c7bfa81e4ab..23264a1ebf12 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -118,19 +118,6 @@ static void privflags_cleanup_data(struct ethnl_reply_data *reply_data)
 	kfree(data->priv_flag_names);
 }
 
-const struct ethnl_request_ops ethnl_privflags_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET,
-	.reply_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_PRIVFLAGS_HEADER,
-	.req_info_size		= sizeof(struct privflags_req_info),
-	.reply_data_size	= sizeof(struct privflags_reply_data),
-
-	.prepare_data		= privflags_prepare_data,
-	.reply_size		= privflags_reply_size,
-	.fill_reply		= privflags_fill_reply,
-	.cleanup_data		= privflags_cleanup_data,
-};
-
 /* PRIVFLAGS_SET */
 
 const struct nla_policy ethnl_privflags_set_policy[] = {
@@ -139,63 +126,70 @@ const struct nla_policy ethnl_privflags_set_policy[] = {
 	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_NESTED },
 };
 
-int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_privflags_validate(struct ethnl_req_info *req_info,
+			     struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	if (!info->attrs[ETHTOOL_A_PRIVFLAGS_FLAGS])
+		return -EINVAL;
+
+	if (!ops->get_priv_flags || !ops->set_priv_flags ||
+	    !ops->get_sset_count || !ops->get_strings)
+		return -EOPNOTSUPP;
+	return 1;
+}
+
+static int
+ethnl_set_privflags(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	const char (*names)[ETH_GSTRING_LEN] = NULL;
-	struct ethnl_req_info req_info = {};
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
 	unsigned int nflags;
 	bool mod = false;
 	bool compact;
 	u32 flags;
 	int ret;
 
-	if (!tb[ETHTOOL_A_PRIVFLAGS_FLAGS])
-		return -EINVAL;
 	ret = ethnl_bitset_is_compact(tb[ETHTOOL_A_PRIVFLAGS_FLAGS], &compact);
 	if (ret < 0)
 		return ret;
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_PRIVFLAGS_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
-	if (!ops->get_priv_flags || !ops->set_priv_flags ||
-	    !ops->get_sset_count || !ops->get_strings)
-		goto out_dev;
 
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
 	ret = ethnl_get_priv_flags_info(dev, &nflags, compact ? NULL : &names);
 	if (ret < 0)
-		goto out_ops;
-	flags = ops->get_priv_flags(dev);
+		return ret;
+	flags = dev->ethtool_ops->get_priv_flags(dev);
 
 	ret = ethnl_update_bitset32(&flags, nflags,
 				    tb[ETHTOOL_A_PRIVFLAGS_FLAGS], names,
 				    info->extack, &mod);
 	if (ret < 0 || !mod)
 		goto out_free;
-	ret = ops->set_priv_flags(dev, flags);
+	ret = dev->ethtool_ops->set_priv_flags(dev, flags);
 	if (ret < 0)
 		goto out_free;
-	ethtool_notify(dev, ETHTOOL_MSG_PRIVFLAGS_NTF, NULL);
+	ret = 1;
 
 out_free:
 	kfree(names);
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-out_dev:
-	ethnl_parse_header_dev_put(&req_info);
 	return ret;
 }
+
+const struct ethnl_request_ops ethnl_privflags_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET,
+	.reply_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PRIVFLAGS_HEADER,
+	.req_info_size		= sizeof(struct privflags_req_info),
+	.reply_data_size	= sizeof(struct privflags_reply_data),
+
+	.prepare_data		= privflags_prepare_data,
+	.reply_size		= privflags_reply_size,
+	.fill_reply		= privflags_fill_reply,
+	.cleanup_data		= privflags_cleanup_data,
+
+	.set_validate		= ethnl_set_privflags_validate,
+	.set			= ethnl_set_privflags,
+	.set_ntf_cmd		= ETHTOOL_MSG_PRIVFLAGS_NTF,
+};
diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index e8683e485dc9..a5b607b0a652 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -106,18 +106,6 @@ static int pse_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_pse_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_PSE_GET,
-	.reply_cmd		= ETHTOOL_MSG_PSE_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_PSE_HEADER,
-	.req_info_size		= sizeof(struct pse_req_info),
-	.reply_data_size	= sizeof(struct pse_reply_data),
-
-	.prepare_data		= pse_prepare_data,
-	.reply_size		= pse_reply_size,
-	.fill_reply		= pse_fill_reply,
-};
-
 /* PSE_SET */
 
 const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1] = {
@@ -127,59 +115,50 @@ const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1] = {
 				 ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED),
 };
 
-static int pse_set_pse_config(struct net_device *dev,
-			      struct netlink_ext_ack *extack,
-			      struct nlattr **tb)
+static int
+ethnl_set_pse_validate(struct ethnl_req_info *req_info, struct genl_info *info)
 {
-	struct phy_device *phydev = dev->phydev;
-	struct pse_control_config config = {};
+	return !!info->attrs[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL];
+}
 
-	/* Optional attribute. Do not return error if not set. */
-	if (!tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL])
-		return 0;
+static int
+ethnl_set_pse(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct net_device *dev = req_info->dev;
+	struct pse_control_config config = {};
+	struct nlattr **tb = info->attrs;
+	struct phy_device *phydev;
 
 	/* this values are already validated by the ethnl_pse_set_policy */
 	config.admin_cotrol = nla_get_u32(tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL]);
 
+	phydev = dev->phydev;
 	if (!phydev) {
-		NL_SET_ERR_MSG(extack, "No PHY is attached");
+		NL_SET_ERR_MSG(info->extack, "No PHY is attached");
 		return -EOPNOTSUPP;
 	}
 
 	if (!phydev->psec) {
-		NL_SET_ERR_MSG(extack, "No PSE is attached");
+		NL_SET_ERR_MSG(info->extack, "No PSE is attached");
 		return -EOPNOTSUPP;
 	}
 
-	return pse_ethtool_set_config(phydev->psec, extack, &config);
+	/* Return errno directly - PSE has no notification */
+	return pse_ethtool_set_config(phydev->psec, info->extack, &config);
 }
 
-int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info)
-{
-	struct ethnl_req_info req_info = {};
-	struct nlattr **tb = info->attrs;
-	struct net_device *dev;
-	int ret;
-
-	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_PSE_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-
-	dev = req_info.dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-
-	ret = pse_set_pse_config(dev, info->extack, tb);
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
+const struct ethnl_request_ops ethnl_pse_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PSE_GET,
+	.reply_cmd		= ETHTOOL_MSG_PSE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PSE_HEADER,
+	.req_info_size		= sizeof(struct pse_req_info),
+	.reply_data_size	= sizeof(struct pse_reply_data),
 
-	ethnl_parse_header_dev_put(&req_info);
+	.prepare_data		= pse_prepare_data,
+	.reply_size		= pse_reply_size,
+	.fill_reply		= pse_fill_reply,
 
-	return ret;
-}
+	.set_validate		= ethnl_set_pse_validate,
+	.set			= ethnl_set_pse,
+	/* PSE has no notification */
+};
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index fa3ec8d438f7..2a2d3539630c 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -102,18 +102,6 @@ static int rings_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_rings_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_RINGS_GET,
-	.reply_cmd		= ETHTOOL_MSG_RINGS_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_RINGS_HEADER,
-	.req_info_size		= sizeof(struct rings_req_info),
-	.reply_data_size	= sizeof(struct rings_reply_data),
-
-	.prepare_data		= rings_prepare_data,
-	.reply_size		= rings_reply_size,
-	.fill_reply		= rings_fill_reply,
-};
-
 /* RINGS_SET */
 
 const struct nla_policy ethnl_rings_set_policy[] = {
@@ -128,62 +116,53 @@ const struct nla_policy ethnl_rings_set_policy[] = {
 	[ETHTOOL_A_RINGS_TX_PUSH]		= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
-int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_rings_validate(struct ethnl_req_info *req_info,
+			 struct genl_info *info)
 {
-	struct kernel_ethtool_ringparam kernel_ringparam = {};
-	struct ethtool_ringparam ringparam = {};
-	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
 	struct nlattr **tb = info->attrs;
-	const struct nlattr *err_attr;
-	const struct ethtool_ops *ops;
-	struct net_device *dev;
-	bool mod = false;
-	int ret;
-
-	ret = ethnl_parse_header_dev_get(&req_info,
-					 tb[ETHTOOL_A_RINGS_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ops = dev->ethtool_ops;
-	ret = -EOPNOTSUPP;
-	if (!ops->get_ringparam || !ops->set_ringparam)
-		goto out_dev;
 
 	if (tb[ETHTOOL_A_RINGS_RX_BUF_LEN] &&
 	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
-		ret = -EOPNOTSUPP;
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
 				    "setting rx buf len not supported");
-		goto out_dev;
+		return -EOPNOTSUPP;
 	}
 
 	if (tb[ETHTOOL_A_RINGS_CQE_SIZE] &&
 	    !(ops->supported_ring_params & ETHTOOL_RING_USE_CQE_SIZE)) {
-		ret = -EOPNOTSUPP;
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[ETHTOOL_A_RINGS_CQE_SIZE],
 				    "setting cqe size not supported");
-		goto out_dev;
+		return -EOPNOTSUPP;
 	}
 
 	if (tb[ETHTOOL_A_RINGS_TX_PUSH] &&
 	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
-		ret = -EOPNOTSUPP;
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[ETHTOOL_A_RINGS_TX_PUSH],
 				    "setting tx push not supported");
-		goto out_dev;
+		return -EOPNOTSUPP;
 	}
 
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-	ops->get_ringparam(dev, &ringparam, &kernel_ringparam, info->extack);
+	return ops->get_ringparam && ops->set_ringparam ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	struct kernel_ethtool_ringparam kernel_ringparam = {};
+	struct ethtool_ringparam ringparam = {};
+	struct net_device *dev = req_info->dev;
+	struct nlattr **tb = info->attrs;
+	const struct nlattr *err_attr;
+	bool mod = false;
+	int ret;
+
+	dev->ethtool_ops->get_ringparam(dev, &ringparam,
+					&kernel_ringparam, info->extack);
 
 	ethnl_update_u32(&ringparam.rx_pending, tb[ETHTOOL_A_RINGS_RX], &mod);
 	ethnl_update_u32(&ringparam.rx_mini_pending,
@@ -197,9 +176,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_RINGS_CQE_SIZE], &mod);
 	ethnl_update_u8(&kernel_ringparam.tx_push,
 			tb[ETHTOOL_A_RINGS_TX_PUSH], &mod);
-	ret = 0;
 	if (!mod)
-		goto out_ops;
+		return 0;
 
 	/* ensure new ring parameters are within limits */
 	if (ringparam.rx_pending > ringparam.rx_max_pending)
@@ -213,23 +191,28 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	else
 		err_attr = NULL;
 	if (err_attr) {
-		ret = -EINVAL;
 		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
 				    "requested ring size exceeds maximum");
-		goto out_ops;
+		return -EINVAL;
 	}
 
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
 					      &kernel_ringparam, info->extack);
-	if (ret < 0)
-		goto out_ops;
-	ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
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
+const struct ethnl_request_ops ethnl_rings_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_RINGS_GET,
+	.reply_cmd		= ETHTOOL_MSG_RINGS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_RINGS_HEADER,
+	.req_info_size		= sizeof(struct rings_req_info),
+	.reply_data_size	= sizeof(struct rings_reply_data),
+
+	.prepare_data		= rings_prepare_data,
+	.reply_size		= rings_reply_size,
+	.fill_reply		= rings_fill_reply,
+
+	.set_validate		= ethnl_set_rings_validate,
+	.set			= ethnl_set_rings,
+	.set_ntf_cmd		= ETHTOOL_MSG_RINGS_NTF,
+};
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index 88f435e76481..a4a43d9e6e9d 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -82,18 +82,6 @@ static int wol_fill_reply(struct sk_buff *skb,
 	return 0;
 }
 
-const struct ethnl_request_ops ethnl_wol_request_ops = {
-	.request_cmd		= ETHTOOL_MSG_WOL_GET,
-	.reply_cmd		= ETHTOOL_MSG_WOL_GET_REPLY,
-	.hdr_attr		= ETHTOOL_A_WOL_HEADER,
-	.req_info_size		= sizeof(struct wol_req_info),
-	.reply_data_size	= sizeof(struct wol_reply_data),
-
-	.prepare_data		= wol_prepare_data,
-	.reply_size		= wol_reply_size,
-	.fill_reply		= wol_fill_reply,
-};
-
 /* WOL_SET */
 
 const struct nla_policy ethnl_wol_set_policy[] = {
@@ -104,67 +92,66 @@ const struct nla_policy ethnl_wol_set_policy[] = {
 					    .len = SOPASS_MAX },
 };
 
-int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
+static int
+ethnl_set_wol_validate(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	const struct ethtool_ops *ops = req_info->dev->ethtool_ops;
+
+	return ops->get_wol && ops->set_wol ? 1 : -EOPNOTSUPP;
+}
+
+static int
+ethnl_set_wol(struct ethnl_req_info *req_info, struct genl_info *info)
 {
 	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
-	struct ethnl_req_info req_info = {};
+	struct net_device *dev = req_info->dev;
 	struct nlattr **tb = info->attrs;
-	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
-	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_WOL_HEADER],
-					 genl_info_net(info), info->extack,
-					 true);
-	if (ret < 0)
-		return ret;
-	dev = req_info.dev;
-	ret = -EOPNOTSUPP;
-	if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
-		goto out_dev;
-
-	rtnl_lock();
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		goto out_rtnl;
-
 	dev->ethtool_ops->get_wol(dev, &wol);
 	ret = ethnl_update_bitset32(&wol.wolopts, WOL_MODE_COUNT,
 				    tb[ETHTOOL_A_WOL_MODES], wol_mode_names,
 				    info->extack, &mod);
 	if (ret < 0)
-		goto out_ops;
+		return ret;
 	if (wol.wolopts & ~wol.supported) {
 		NL_SET_ERR_MSG_ATTR(info->extack, tb[ETHTOOL_A_WOL_MODES],
 				    "cannot enable unsupported WoL mode");
-		ret = -EINVAL;
-		goto out_ops;
+		return -EINVAL;
 	}
 	if (tb[ETHTOOL_A_WOL_SOPASS]) {
 		if (!(wol.supported & WAKE_MAGICSECURE)) {
 			NL_SET_ERR_MSG_ATTR(info->extack,
 					    tb[ETHTOOL_A_WOL_SOPASS],
 					    "magicsecure not supported, cannot set password");
-			ret = -EINVAL;
-			goto out_ops;
+			return -EINVAL;
 		}
 		ethnl_update_binary(wol.sopass, sizeof(wol.sopass),
 				    tb[ETHTOOL_A_WOL_SOPASS], &mod);
 	}
 
 	if (!mod)
-		goto out_ops;
+		return 0;
 	ret = dev->ethtool_ops->set_wol(dev, &wol);
 	if (ret)
-		goto out_ops;
+		return ret;
 	dev->wol_enabled = !!wol.wolopts;
-	ethtool_notify(dev, ETHTOOL_MSG_WOL_NTF, NULL);
-
-out_ops:
-	ethnl_ops_complete(dev);
-out_rtnl:
-	rtnl_unlock();
-out_dev:
-	ethnl_parse_header_dev_put(&req_info);
-	return ret;
+	return 1;
 }
+
+const struct ethnl_request_ops ethnl_wol_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_WOL_GET,
+	.reply_cmd		= ETHTOOL_MSG_WOL_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_WOL_HEADER,
+	.req_info_size		= sizeof(struct wol_req_info),
+	.reply_data_size	= sizeof(struct wol_reply_data),
+
+	.prepare_data		= wol_prepare_data,
+	.reply_size		= wol_reply_size,
+	.fill_reply		= wol_fill_reply,
+
+	.set_validate		= ethnl_set_wol_validate,
+	.set			= ethnl_set_wol,
+	.set_ntf_cmd		= ETHTOOL_MSG_WOL_NTF,
+};
-- 
2.39.1

