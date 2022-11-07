Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF461FD10
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiKGSPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiKGSOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:14:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCCB28E0F
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844835; x=1699380835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1M2AvKUZK0K5Sx4EdpD/aj+chFXPtI+mPWuPZnSgDVE=;
  b=RLyVoxyLbZnOhXdh2JyMeIsIKNBgKBHpjyJyIZBcenW8iTsPC6uDFVh9
   hT0hp2YQknby5rqk/dkS8xQ4u/xJjtKBTo/oHHWVXjtuX4ymle4RjCtG2
   097OV9QJbK8mXdEEhCRqvoNbyAUa9BhmZ0jYvfzyuLnRVyatASDekk8ST
   84/DMJvOpHvUw/VKgohuBZQnDdrhox7aoKWz7Hgcl1ER30JXBqLsaLv5F
   +7ULPMAZWUZ694Mx06iMnSs6c1DZQnRC+JM2C8o+nTjt/1N4B64uLIGHc
   PVUc9untdVMOSk6rhiOJSxPE25RbCqya5XmyC8JrhwhAtHghKFzaYCzzp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293851895"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293851895"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:13:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962581"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962581"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:13:52 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v10 01/10] devlink: Introduce new attribute 'tx_priority' to devlink-rate
Date:   Mon,  7 Nov 2022 19:13:17 +0100
Message-Id: <20221107181327.379007-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221107181327.379007-1-michal.wilczynski@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fully utilize offload capabilities of Intel 100G card QoS capabilities
new attribute 'tx_priority' needs to be introduced. This attribute allows
for usage of strict priority arbiter among siblings. This arbitration
scheme attempts to schedule nodes based on their priority as long as the
nodes remain within their bandwidth limit.

Introduce new attribute in devlink-rate that will allow for configuration
of strict priority. New attribute is optional.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        |  6 ++++++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 31 +++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index fa6e936af1a5..849c87832f55 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -114,6 +114,8 @@ struct devlink_rate {
 			refcount_t refcnt;
 		};
 	};
+
+	u32 tx_priority;
 };
 
 struct devlink_port {
@@ -1502,10 +1504,14 @@ struct devlink_ops {
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+					 u32 tx_priority, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+					 u32 tx_priority, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..1a9214d35ef5 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -607,6 +607,7 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 40fcdded57e6..d8310dd7e429 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1203,6 +1203,9 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
+			devlink_rate->tx_priority))
+		goto nla_put_failure;
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
@@ -1936,6 +1939,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 {
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
+	u32 priority;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
@@ -1964,6 +1968,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_max = rate;
 	}
 
+	if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
+		priority = nla_get_u32(attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_priority_set(devlink_rate, devlink_rate->priv,
+							     priority, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_priority_set(devlink_rate, devlink_rate->priv,
+							     priority, info->extack);
+
+		if (err)
+			return err;
+		devlink_rate->tx_priority = priority;
+	}
+
 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
 	if (nla_parent) {
 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
@@ -1995,6 +2013,12 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[DEVLINK_ATTR_RATE_TX_PRIORITY],
+					    "TX priority set isn't supported for the leafs");
+			return false;
+		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
@@ -2009,6 +2033,12 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[DEVLINK_ATTR_RATE_TX_PRIORITY],
+					    "TX priority set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN(1, "Unknown type of rate object");
 		return false;
@@ -9184,6 +9214,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U32 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.37.2

