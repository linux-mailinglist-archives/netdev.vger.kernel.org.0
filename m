Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A7F610EFD
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiJ1KwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiJ1KwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:52:02 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB282915FB
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666954321; x=1698490321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O8cq6HJeEBpbxrvIwrZMNJjyH43K2J8lG7FfYBrpwek=;
  b=bidcgB2IhfC7ULAPmxgCWcq+TKDVantW2v6JRfWoIlEjVWxJlPBd6Clw
   KbNDVhKjxnc/bl5kURdikOuVosrwiqlWpae664EThN57yddUZtLRPecvU
   nFJ+txEdiMFdqN7Wh+bEUoRkIOX13tzseiwzb/Z5XTPyMwb+20BZOisPq
   QjU2grg3851w12X3H+UjFRpNBuhgWP5kwrVbajAXvPsAam5JoisXM4foi
   Hheq3EgKrA7PiDOSbhqJd6Qsy9UfZ2BKeKeAD08WqDg1Jy48Drn4QjZvq
   w6J/J+VfSscxHlcA8WJIAz1qXqx0C6ZMR5qXqJDHEQQwR4vFzNJjyMGFp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="394777579"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="394777579"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701695315"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701695315"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:51:59 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v8 1/9] devlink: Introduce new parameter 'tx_priority' to devlink-rate
Date:   Fri, 28 Oct 2022 12:51:35 +0200
Message-Id: <20221028105143.3517280-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221028105143.3517280-1-michal.wilczynski@intel.com>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fully utilize offload capabilities of Intel 100G card QoS capabilities
new parameter 'tx_priority' needs to be introduced. This parameter allows
for usage of strict priority arbiter among siblings. This arbitration
scheme attempts to schedule nodes based on their priority as long as the
nodes remain within their bandwidth limit.

Introduce new parameter in devlink-rate that will allow for
configuration of strict priority.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 include/net/devlink.h        |  6 ++++++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 29 +++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ba6b8b094943..9d2b0c3c4ad3 100644
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
@@ -1493,10 +1495,14 @@ struct devlink_ops {
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
index 89baa7c0938b..2586b1307cb4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1184,6 +1184,9 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
+			devlink_rate->tx_priority))
+		goto nla_put_failure;
 	if (devlink_rate->parent)
 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				   devlink_rate->parent->name))
@@ -1924,6 +1927,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
 {
 	struct nlattr *nla_parent, **attrs = info->attrs;
 	int err = -EOPNOTSUPP;
+	u16 priority;
 	u64 rate;
 
 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
@@ -1952,6 +1956,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
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
@@ -1983,6 +2001,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
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
@@ -1997,6 +2020,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
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
@@ -9172,6 +9200,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.37.2

