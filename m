Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3913E629637
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiKOKtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiKOKsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:48:54 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258AD201A3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668509332; x=1700045332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9EsYgq8JmCeaQMMRcN9CbiT7dTa/3lSo+2Nnta9r30A=;
  b=LUkgpRwnz7AfstZTQcGWYlS1Iy+Sealm2HuNpneu/qZkjKs+QfBQmDF3
   JUASnE3J6Wd6gP4Rzv1qI2R3OifBLVR7hfgMWz0MDUcmx3EgZwXMx0N01
   X7N2QUuRpBvKHNjlYlSTPQHY/isj7X5nPq9hiDc6vWrEmpPXbr0pOWIDS
   eTcGc8E8AjYn4rS4pduMnj624Ux7DTXSvi1Y085AnTjz9DbAIoKPpXBkt
   +aRLb/H7yODV3s1WN4TAGfOjTjnZZw/5cx+chf1IVWkC/xype0cQBtwbP
   c5lZ9Ts8Nbp7ZxHnwhtcWAYi/nCKkr7z0mFH9jGwEZNX/Kb+uhTExnsSf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376489450"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376489450"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633193402"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633193402"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:49 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v12 03/11] devlink: Enable creation of the devlink-rate nodes from the driver
Date:   Tue, 15 Nov 2022 11:48:17 +0100
Message-Id: <20221115104825.172668-4-michal.wilczynski@intel.com>
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

Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
rigid and can't be easily removed. This requires an ability to export
default hierarchy to allow user to modify it. Currently the driver is
only able to create the 'leaf' nodes, which usually represent the vport.
This is not enough for HQoS implemented in Intel hardware.

Introduce new function devl_rate_node_create() that allows for creation
of the devlink-rate nodes from the driver.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  3 +++
 net/core/devlink.c    | 45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 366b23d3f973..339a2ed02d36 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1618,6 +1618,9 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
 int devl_rate_leaf_create(struct devlink_port *port, void *priv);
+struct devlink_rate *
+devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
+		      struct devlink_rate *parent);
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 525bdf426163..3dfee7cd9929 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10384,6 +10384,51 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
+/**
+ * devl_rate_node_create - create devlink rate node
+ * @devlink: devlink instance
+ * @priv: driver private data
+ * @node_name: name of the resulting node
+ * @parent: parent devlink_rate struct
+ *
+ * Create devlink rate object of type node
+ */
+struct devlink_rate *
+devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
+		      struct devlink_rate *parent)
+{
+	struct devlink_rate *rate_node;
+
+	rate_node = devlink_rate_node_get_by_name(devlink, node_name);
+	if (!IS_ERR(rate_node))
+		return ERR_PTR(-EEXIST);
+
+	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
+	if (!rate_node)
+		return ERR_PTR(-ENOMEM);
+
+	if (parent) {
+		rate_node->parent = parent;
+		refcount_inc(&rate_node->parent->refcnt);
+	}
+
+	rate_node->type = DEVLINK_RATE_TYPE_NODE;
+	rate_node->devlink = devlink;
+	rate_node->priv = priv;
+
+	rate_node->name = kstrdup(node_name, GFP_KERNEL);
+	if (!rate_node->name) {
+		kfree(rate_node);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	refcount_set(&rate_node->refcnt, 1);
+	list_add(&rate_node->list, &devlink->rate_list);
+	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+	return rate_node;
+}
+EXPORT_SYMBOL_GPL(devl_rate_node_create);
+
 /**
  * devl_rate_leaf_create - create devlink rate leaf
  * @devlink_port: devlink port object to create rate object on
-- 
2.37.2

