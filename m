Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427E5610F01
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiJ1Kw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiJ1KwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:52:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E0495270
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666954334; x=1698490334;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m9HdpsKjcsZQ0Ok7nVYDdgjr/SqrizbJ11dDwRq124w=;
  b=JccnGX7yreqxb0juDmoLKAUCb+14pPhczmhzSvl8IS5HAhf7dVMCbw7X
   zuEfLO8F68aq1Z5mX+R6/UvzH2+h8mgtfLa+5R1u8WT1fuTpMGG+xri9p
   sCMrocf8xI4MruLkmSFdfOwYeWe3ubOJBV5WQPwTVeyJJKZN9f39BtFtw
   fQurTs2/wqGsd0VjE23esKQKc12NIGVoud+7PWWNQ/Cf/H1f1cdL6BSFK
   VEnZ34LegpJJp+5NT1AgulVksidqz+PGKllNQBdI6TFMYE2O18FJAm8S1
   uY0GD+gBgQuTy8+0OGY82mxUzCtCswtJ3Lb6t/tw45KnncGPljU9nAEtI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="394777615"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="394777615"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:13 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701695340"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701695340"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:11 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v8 5/9] devlink: Allow to set up parent in devl_rate_leaf_create()
Date:   Fri, 28 Oct 2022 12:51:39 +0200
Message-Id: <20221028105143.3517280-6-michal.wilczynski@intel.com>
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

Currently the driver is able to create leaf nodes for the devlink-rate,
but is unable to set parent for them. This wasn't as issue, before the
possibility to export hierarchy from the driver. After adding the export
feature, in order for the driver to supply correct hierarchy, it's
necessary for it to be able to supply a parent name to
devl_rate_leaf_create().

Introduce a new parameter 'parent_name' in devl_rate_leaf_create().

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  4 ++--
 drivers/net/netdevsim/dev.c                        |  2 +-
 include/net/devlink.h                              |  2 +-
 net/core/devlink.c                                 | 14 +++++++++++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 9bc7be95db54..084a910bb4e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -91,7 +91,7 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	if (err)
 		goto reg_err;
 
-	err = devl_rate_leaf_create(dl_port, vport);
+	err = devl_rate_leaf_create(dl_port, vport, NULL);
 	if (err)
 		goto rate_err;
 
@@ -160,7 +160,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	if (err)
 		return err;
 
-	err = devl_rate_leaf_create(dl_port, vport);
+	err = devl_rate_leaf_create(dl_port, vport, NULL);
 	if (err)
 		goto rate_err;
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 794fc0cc73b8..10e5c4de6b02 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1392,7 +1392,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
 		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
-					    nsim_dev_port);
+					    nsim_dev_port, NULL);
 		if (err)
 			goto err_nsim_destroy;
 	}
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9d0a424712fd..2ccb69606d23 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1602,7 +1602,7 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
+int devl_rate_leaf_create(struct devlink_port *port, void *priv, char *parent_name);
 int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
 			  char *parent_name);
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9bdbc158c36a..140336c09bd5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10325,13 +10325,15 @@ EXPORT_SYMBOL_GPL(devl_rate_node_create);
  * devl_rate_leaf_create - create devlink rate leaf
  * @devlink_port: devlink port object to create rate object on
  * @priv: driver private data
+ * @parent_name: name of the parent node
  *
  * Create devlink rate object of type leaf on provided @devlink_port.
  */
-int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv, char *parent_name)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
+	struct devlink_rate *parent;
 
 	devl_assert_locked(devlink_port->devlink);
 
@@ -10342,6 +10344,16 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
+	if (parent_name) {
+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+		if (IS_ERR(parent)) {
+			kfree(devlink_rate);
+			return -ENODEV;
+		}
+		devlink_rate->parent = parent;
+		refcount_inc(&devlink_rate->parent->refcnt);
+	}
+
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
 	devlink_rate->devlink_port = devlink_port;
-- 
2.37.2

