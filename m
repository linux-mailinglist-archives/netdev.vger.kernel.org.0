Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53075619A09
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiKDOd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiKDOdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:33:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F107C4AF39
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572283; x=1699108283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YT8XsyOxP8ZaALnkuQggCq1HJFdSf51HORk3kkIcoq8=;
  b=cDbai9XU4d4rHd2O3PT4W8hslBYsINKiXXfCPYIj1F3pWThdbQMJxhUo
   70z/i+QdzrJBQTmUb2IpcqnJsDRoQ4fIU5qsaH+dImsBeW2Y/INNdFVM2
   pDtdxZc014jDqyRePVMzO1YIdHgN4Js+L5qwXwcqwq7Q7oosZ1MzRu6Ea
   /AcMZaF5rO6cmOqFDvCUPDj49i71yapDL8U5PblTdtlS0r4pfghJgnD7d
   XvAl0IPjWPnSBzA81FyGnTYuGMxv//9YUIM+eYksCiueP4nL/IwFgsNnt
   OilIZlmJspBj/VmhE4reFlFuM2vKcuCIZK6GPJYKOl4/S0B7k90R2M7qX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="311719207"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="311719207"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730217"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730217"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:19 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v9 1/9] devlink: Introduce new attribute 'tx_priority' to devlink-rate
Date:   Fri,  4 Nov 2022 15:30:54 +0100
Message-Id: <20221104143102.1120076-2-michal.wilczynski@intel.com>
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
new attribute 'tx_priority' needs to be introduced. This attribute allows
for usage of strict priority arbiter among siblings. This arbitration
scheme attempts to schedule nodes based on their priority as long as the
nodes remain within their bandwidth limit.

Introduce new attribute in devlink-rate that will allow for configuration
of strict priority. New attribute is optional.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 include/net/devlink.h        |  6 ++++++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 29 +++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index fa6e936af1a5..d398769e57a2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -114,6 +114,8 @@ struct devlink_rate {
 			refcount_t refcnt;
 		};
 	};
+
+	u16 tx_priority;
 };
 
 struct devlink_port {
@@ -1502,10 +1504,14 @@ struct devlink_ops {
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+					 u64 tx_priority, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
 				      u64 tx_share, struct netlink_ext_ack *extack);
 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
 				    u64 tx_max, struct netlink_ext_ack *extack);
+	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
+					 u64 tx_priority, struct netlink_ext_ack *extack);
 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
 			     struct netlink_ext_ack *extack);
 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..b3df5bc45ba5 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -607,6 +607,7 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2dcf2bcc3527..ddece8c72bbf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1203,6 +1203,9 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
+			devlink_rate->tx_priority))
+		goto nla_put_failure;
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
@@ -1936,6 +1939,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 {
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
+	u16 priority;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
@@ -1964,6 +1968,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 		devlink_rate->tx_max = rate;
 	}
 
+	if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
+		priority = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+		if (devlink_rate_is_leaf(devlink_rate))
+			err = ops->rate_leaf_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+		else if (devlink_rate_is_node(devlink_rate))
+			err = ops->rate_node_tx_priority_set(devlink_rate, devlink_rate->priv,
+							priority, info->extack);
+
+		if (err)
+			return err;
+		devlink_rate->tx_priority = priority;
+	}
+
 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
 	if (nla_parent) {
 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
@@ -1995,6 +2013,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX priority set isn't supported for the leafs");
+			return false;
+		}
 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
@@ -2009,6 +2032,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
 			return false;
 		}
+		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "TX priority set isn't supported for the nodes");
+			return false;
+		}
 	} else {
 		WARN(1, "Unknown type of rate object");
 		return false;
@@ -9184,6 +9212,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.37.2

