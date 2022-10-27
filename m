Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFFA60F856
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiJ0NEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiJ0NDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:03:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F95176BBD
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666875831; x=1698411831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DjBWCQ6VLdVh/SHI0kI16xaIESdt+Wvpn4zBmZJUnu4=;
  b=A3U3PtIP1SGj5gNQ6FQs1agw6Ak1IrqP6fW3KeX+kkPMRLFl2TD1XKFo
   yy54lP5cqc/4oAmgKvxm5o8GMnSfee2ZZUkr13VNepFRLXZiOBTKkqY27
   PKCzddj1FzrR4IDn0pv0vfew7I6INCzhRalpzZMq3e43Suybu1u3zzaxQ
   MzyoYJR4ZIKkXaCG9AFRiUQmvIID4seLnXCGlbdrk+/oKBKT3KOlDbqPw
   XwRFKyxDDSWdFYatoaBkEk9ZPUPR58esZNJRoCmuffSlBvLjCKwYACBD1
   5O3eUcVPvV1tCqGmQDy2J7D1Ff8EMOJgqqHem0y54KEUErbaUg2v1t8Lc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="394530516"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208,223";a="394530516"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 06:03:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="583546646"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208,223";a="583546646"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 06:03:48 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v7 6/9] devlink: Allow to change priv in devlink-rate from parent_set callbacks
Date:   Thu, 27 Oct 2022 15:00:46 +0200
Message-Id: <20221027130049.2418531-7-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221027130049.2418531-1-michal.wilczynski@intel.com>
References: <20221027130049.2418531-1-michal.wilczynski@intel.com>
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

From driver perspective it doesn't make any sense to make any changes to
the internal HQoS tree if the created node doesn't have a parent. So a
node created without any parent doesn't have to be initialized in the
driver. Allow for such scenario by allowing to modify priv in parent_set
callbacks.

Change priv_child and priv_parent parameters to double pointers, to
allow for setting priv during the parent set phase.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h |  2 +-
 drivers/net/netdevsim/dev.c                       |  8 ++++----
 include/net/devlink.h                             |  4 ++--
 net/core/devlink.c                                | 12 ++++++------
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 4f8a24d84a86..0b55a1e477f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -940,11 +940,11 @@ int mlx5_esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 
 int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
 				     struct devlink_rate *parent,
-				     void *priv, void *parent_priv,
+				     void **priv, void *parent_priv,
 				     struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_rate_group *group;
-	struct mlx5_vport *vport = priv;
+	struct mlx5_vport *vport = *priv;
 
 	if (!parent)
 		return mlx5_esw_qos_vport_update_group(vport->dev->priv.eswitch,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index 0141e9d52037..d3b3ce26883b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -24,7 +24,7 @@ int mlx5_esw_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
 				   struct netlink_ext_ack *extack);
 int mlx5_esw_devlink_rate_parent_set(struct devlink_rate *devlink_rate,
 				     struct devlink_rate *parent,
-				     void *priv, void *parent_priv,
+				     void **priv, void *parent_priv,
 				     struct netlink_ext_ack *extack);
 #endif
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 10e5c4de6b02..f5ae4aed8679 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1275,10 +1275,10 @@ static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
 
 static int nsim_rate_leaf_parent_set(struct devlink_rate *child,
 				     struct devlink_rate *parent,
-				     void *priv_child, void *priv_parent,
+				     void **priv_child, void *priv_parent,
 				     struct netlink_ext_ack *extack)
 {
-	struct nsim_dev_port *nsim_dev_port = priv_child;
+	struct nsim_dev_port *nsim_dev_port = *priv_child;
 
 	if (parent)
 		nsim_dev_port->parent_name = parent->name;
@@ -1289,10 +1289,10 @@ static int nsim_rate_leaf_parent_set(struct devlink_rate *child,
 
 static int nsim_rate_node_parent_set(struct devlink_rate *child,
 				     struct devlink_rate *parent,
-				     void *priv_child, void *priv_parent,
+				     void **priv_child, void *priv_parent,
 				     struct netlink_ext_ack *extack)
 {
-	struct nsim_rate_node *nsim_node = priv_child;
+	struct nsim_rate_node *nsim_node = *priv_child;
 
 	if (parent)
 		nsim_node->parent_name = parent->name;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2159643d7718..37e73dcf2210 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1516,11 +1516,11 @@ struct devlink_ops {
 			     struct netlink_ext_ack *extack);
 	int (*rate_leaf_parent_set)(struct devlink_rate *child,
 				    struct devlink_rate *parent,
-				    void *priv_child, void *priv_parent,
+				    void **priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
 	int (*rate_node_parent_set)(struct devlink_rate *child,
 				    struct devlink_rate *parent,
-				    void *priv_child, void *priv_parent,
+				    void **priv_child, void *priv_parent,
 				    struct netlink_ext_ack *extack);
 	/**
 	 * selftests_check() - queries if selftest is supported
diff --git a/net/core/devlink.c b/net/core/devlink.c
index d53da9f9b467..3b51e64a25eb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1880,11 +1880,11 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 	if (parent && !len) {
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
-							devlink_rate->priv, NULL,
+							&devlink_rate->priv, NULL,
 							info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_parent_set(devlink_rate, NULL,
-							devlink_rate->priv, NULL,
+							&devlink_rate->priv, NULL,
 							info->extack);
 		if (err)
 			return err;
@@ -1909,11 +1909,11 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, parent,
-							devlink_rate->priv, parent->priv,
+							&devlink_rate->priv, parent->priv,
 							info->extack);
 		else if (devlink_rate_is_node(devlink_rate))
 			err = ops->rate_node_parent_set(devlink_rate, parent,
-							devlink_rate->priv, parent->priv,
+							&devlink_rate->priv, parent->priv,
 							info->extack);
 		if (err)
 			return err;
@@ -10408,10 +10408,10 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 
 		refcount_dec(&devlink_rate->parent->refcnt);
 		if (devlink_rate_is_leaf(devlink_rate))
-			ops->rate_leaf_parent_set(devlink_rate, NULL, devlink_rate->priv,
+			ops->rate_leaf_parent_set(devlink_rate, NULL, &devlink_rate->priv,
 						  NULL, NULL);
 		else if (devlink_rate_is_node(devlink_rate))
-			ops->rate_node_parent_set(devlink_rate, NULL, devlink_rate->priv,
+			ops->rate_node_parent_set(devlink_rate, NULL, &devlink_rate->priv,
 						  NULL, NULL);
 	}
 	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
-- 
2.37.2

