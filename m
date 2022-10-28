Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A370E610F02
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJ1Kw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJ1KwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:52:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F341B95AFE
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666954336; x=1698490336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FjANSRDnQz7joR6HjhOtQDWRW1PSQcdv9vZd/0J3fYU=;
  b=IpmQp5s18ZWFBN3hnbp6HI8UGXVkxBIq1j4z0qns/zzsle+7gS6H2C74
   Qq1LTHteZreye7jBS4WIYHOIcqED4ygaJTVu7mI+X3e5vMYSufHQeJ8I3
   94ETIySiu+X4RA6ihti18q3w5cGTmaN5NCqa/YAbMSIs+9+JW8vlNpsaB
   eHmCPLZb3ilFKke84WQSY/UMLb+e2T1SrkfqlMtXbzRAXQfpepBt3X43y
   wbcGzm2UxQMzPPWpIlc9KJ08vS5oksdno6vLHTJ5WIc4yRx0KOWWoYEFi
   vulUu6icqqgVVzcg/MBGtPL5TkOoGJGcncQpbeScdLZU+u+fU5RwHxpaP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="394777623"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208,223";a="394777623"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:16 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701695345"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208,223";a="701695345"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:14 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v8 6/9] devlink: Allow to change priv in devlink-rate from parent_set callbacks
Date:   Fri, 28 Oct 2022 12:51:40 +0200
Message-Id: <20221028105143.3517280-7-michal.wilczynski@intel.com>
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

From driver perspective it doesn't make any sense to make any changes to
the internal HQoS tree if the created node doesn't have a parent. So a
node created without any parent doesn't have to be initialized in the
driver. Allow for such scenario by allowing to modify priv in parent_set
callbacks.

Change priv parameter to double pointer, to allow for setting priv during
the parent set phase.

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
index 2ccb69606d23..3085b018e635 100644
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
index 140336c09bd5..2d40ed440a33 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1879,11 +1879,11 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
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
@@ -1908,11 +1908,11 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 
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
@@ -10410,10 +10410,10 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 
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

