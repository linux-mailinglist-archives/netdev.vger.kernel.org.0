Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B5461FD12
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiKGSPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiKGSPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:15:00 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C32120997
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844839; x=1699380839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DMsNK5HKUbz2fcx6z3UfR8ad3eD36OZ/8usuFE7ABBU=;
  b=nHrLOdAAHZFqDH3pnFzLSLE6C7It+1A3vabHcuXqf7y1CtgGz+1AJwFx
   J1XCcS4d/5d6AufShi/f+7/Y43ESTREItV7yQCMeCPkAg0cUqNlj5I/Zh
   yGTbnPpvRjrB4N6fkXMaQ3Yv5pTdUxb2xSu4XjMEAavs0yhDUSUtOnxf1
   3sppxw/mU0b73pLCv5LXNCr2aaaj2rUwib77Jib3t+4lVsU091bvW9Z3S
   2G3WnBiPUw98q0u7tOPjRR9HyC3KYX/xep4Ji4FyD4pJ/xvGd+xt9MTIs
   bIgbs/l1dw1absUmUvP72nW7xFLvRZw7ot/2NcmqxKF/z7CaPeh2O571e
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293851909"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293851909"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:13:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962614"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962614"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:13:56 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v10 02/10] devlink: Introduce new attribute 'tx_weight' to devlink-rate
Date:   Mon,  7 Nov 2022 19:13:18 +0100
Message-Id: <20221107181327.379007-3-michal.wilczynski@intel.com>
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
new attribute 'tx_weight' needs to be introduced. This attribute allows
for usage of Weighted Fair Queuing arbitration scheme among siblings.
This arbitration scheme can be used simultaneously with the strict
priority.

Introduce new attribute in devlink-rate that will allow for configuration
of Weighted Fair Queueing. New attribute is optional.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h        |  5 +++++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 849c87832f55..0e763de4cbf5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -116,6 +116,7 @@ struct devlink_rate {
 	};
 
 	u32 tx_priority;
+	u32 tx_weight;
 };
 
 struct devlink_port {
@@ -1506,12 +1507,16 @@ struct devlink_ops {
 				    u64 tx_max, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
 					 u32 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				       u32 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
 					 u32 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				       u32 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 1a9214d35ef5..498d0d5d0957 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -608,6 +608,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
 	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u32 */
+	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d8310dd7e429..395fdf3e0299 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1206,6 +1206,11 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 	if (nla_put_u32(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
 			devlink_rate->tx_priority))
 		goto nla_put_failure;
+
+	if (nla_put_u32(msg, DEVLINK_ATTR_RATE_TX_WEIGHT,
+			devlink_rate->tx_weight))
+		goto nla_put_failure;
+
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
@@ -1940,6 +1945,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
 	u32 priority;
+	u32 weight;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
@@ -1982,6 +1988,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_priority = priority;
 	}
 
+	if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]) {
+		weight = nla_get_u32(attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_weight_set(devlink_rate, devlink_rate->priv,
+							   weight, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_weight_set(devlink_rate, devlink_rate->priv,
+							   weight, info->extack);
+
+		if (err)
+			return err;
+		devlink_rate->tx_weight = weight;
+	}
+
 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
 	if (nla_parent) {
 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
@@ -2019,6 +2039,12 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 					    "TX priority set isn't supported for the leafs");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_leaf_tx_weight_set) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[DEVLINK_ATTR_RATE_TX_WEIGHT],
+					    "TX weight set isn't supported for the leafs");
+			return false;
+		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
@@ -2039,6 +2065,12 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 					    "TX priority set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_node_tx_weight_set) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[DEVLINK_ATTR_RATE_TX_WEIGHT],
+					    "TX weight set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN(1, "Unknown type of rate object");
 		return false;
@@ -9215,6 +9247,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
 	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U32 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.37.2

