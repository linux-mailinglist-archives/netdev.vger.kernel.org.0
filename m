Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9C4629639
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiKOKtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbiKOKs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:48:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A9C201A3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668509338; x=1700045338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IvmDljFYeB267fvWDSdhxWcHAExMTqQYeh5I7SnbKK8=;
  b=nAhsrJoroDW9no1Q3Q4IPHZ6D7HjwCvTDqSTkQiQ8SpMavFxiippoV3s
   uSvXMirRdLeh+4b5EI0ak5DwY+rp/jA0l5rsvdnlwwBtjaemCAyyk5YCq
   he28hLMJX5XvdR24GMMiJEqotTDYMYzpkA0YWVj0C5Smv1n5MCKOWHiLv
   pZDItxfLgez8KX4WpyMfYsHdKKVD+XILSwyWgOSpe6fwJWhL46UdqzA0j
   TQX+W9OB97k+lMYBJ6omVMLLLkc4UWeN+AZhmJy29SBNk9PN0exWpdJmF
   /J03wGVmGfe+o9PCq0ZpcNgFXdddDp6wJd1GoP9tlrFtLo39vIBuMvVa2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376489485"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376489485"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633193448"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633193448"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:55 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v12 05/11] devlink: Allow to set up parent in devl_rate_leaf_create()
Date:   Tue, 15 Nov 2022 11:48:19 +0100
Message-Id: <20221115104825.172668-6-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115104825.172668-1-michal.wilczynski@intel.com>
References: <20221115104825.172668-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the driver is able to create leaf nodes for the devlink-rate,
but is unable to set parent for them. This wasn't as issue before the
possibility to export hierarchy from the driver. After adding the export
feature, in order for the driver to supply correct hierarchy, it's
necessary for it to be able to supply a parent name to
devl_rate_leaf_create().

Introduce a new parameter 'parent_name' in devl_rate_leaf_create().

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/devlink_port.c   | 4 ++--
 drivers/net/netdevsim/dev.c                              | 2 +-
 include/net/devlink.h                                    | 4 +++-
 net/core/devlink.c                                       | 9 ++++++++-
 4 files changed, 14 insertions(+), 5 deletions(-)

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
index 387c05953a8b..a5bd6dcca980 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1401,7 +1401,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 
 	if (nsim_dev_port_is_vf(nsim_dev_port)) {
 		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
-					    nsim_dev_port);
+					    nsim_dev_port, NULL);
 		if (err)
 			goto err_nsim_destroy;
 	}
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 339a2ed02d36..074a79b8933f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1617,10 +1617,12 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
-int devl_rate_leaf_create(struct devlink_port *port, void *priv);
 struct devlink_rate *
 devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
 		      struct devlink_rate *parent);
+int
+devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv,
+		      struct devlink_rate *parent);
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 61d431578f5f..d93bc95cd7cb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10435,10 +10435,12 @@ EXPORT_SYMBOL_GPL(devl_rate_node_create);
  * devl_rate_leaf_create - create devlink rate leaf
  * @devlink_port: devlink port object to create rate object on
  * @priv: driver private data
+ * @parent: parent devlink_rate struct
  *
  * Create devlink rate object of type leaf on provided @devlink_port.
  */
-int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv,
+			  struct devlink_rate *parent)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
@@ -10452,6 +10454,11 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
+	if (parent) {
+		devlink_rate->parent = parent;
+		refcount_inc(&devlink_rate->parent->refcnt);
+	}
+
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
 	devlink_rate->devlink_port = devlink_port;
-- 
2.37.2

