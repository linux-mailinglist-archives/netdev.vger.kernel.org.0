Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA87C619A0D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiKDOea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiKDOeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:34:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486C030F40
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572295; x=1699108295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AmXVrJA6uVS/YjiMOTZWysh1PxyGDFQRFPGFbLex9S0=;
  b=SVF3FkDcMEn/GenZSMFbs5/UvBBOierDheWpSLP9i4mqFGkFKunKUQjJ
   FEt5c3lpYyRR7g6FR46bNsekuNK4GbqK89C88VQvBQdnLykKhTdAy12A2
   seDg4fYVqXLS73BK1XSz9EE9QWtq/jXzZiocQMWVRFPkM2CMVCATHuZdx
   293tfiKHPRUp6GVlLjp87iGS0/U7cix04RN8V0o3QJZ+u4TM0DOLU+XYm
   MMrizTjlI323QAD4gQ6zfWk7jZptl80Vn2ym1Ks8dYOzvPPTlNhldjtqt
   ojbKF4QnDvamu5YGDFEe0j41UsixLgNbsmVy0gBprnte96Cp/bU9MQkBF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="308690673"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="308690673"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:25 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730247"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730247"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:22 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v9 2/9] devlink: Introduce new attribute 'tx_weight' to devlink-rate
Date:   Fri,  4 Nov 2022 15:30:55 +0100
Message-Id: <20221104143102.1120076-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221104143102.1120076-1-michal.wilczynski@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 include/net/devlink.h        |  5 +++++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 31 +++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d398769e57a2..5076118dc9b6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -116,6 +116,7 @@ struct devlink_rate {
 	};
 
 	u16 tx_priority;
+	u16 tx_weight;
 };
 
 struct devlink_port {
@@ -1506,12 +1507,16 @@ struct devlink_ops {
 				    u64 tx_max, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
 					 u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				       u64 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
 					 u64 tx_priority, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_weight_set)(struct devlink_rate *devlink_rate, void *priv,
+				       u64 tx_weight, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b3df5bc45ba5..9f3916e02a64 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -608,6 +608,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
 	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ddece8c72bbf..91e0b7537459 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1206,6 +1206,11 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
 			devlink_rate->tx_priority))
 		goto nla_put_failure;
+
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_WEIGHT,
+			devlink_rate->tx_weight))
+		goto nla_put_failure;
+
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
@@ -1940,6 +1945,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
 	u16 priority;
+	u16 weight;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
@@ -1982,6 +1988,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_priority = priority;
 	}
 
+	if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]) {
+		weight = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_WEIGHT]);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_weight_set(devlink_rate, devlink_rate->priv,
+							 weight, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_weight_set(devlink_rate, devlink_rate->priv,
+							weight, info->extack);
+
+		if (err)
+			return err;
+		devlink_rate->tx_weight = weight;
+	}
+
 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
 	if (nla_parent) {
 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
@@ -2018,6 +2038,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 					   "TX priority set isn't supported for the leafs");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_leaf_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX weight set isn't supported for the leafs");
+			return false;
+		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
@@ -2037,6 +2062,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 					   "TX priority set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_WEIGHT] && !ops->rate_node_tx_weight_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX weight set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN(1, "Unknown type of rate object");
 		return false;
@@ -9213,6 +9243,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
 	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.37.2

