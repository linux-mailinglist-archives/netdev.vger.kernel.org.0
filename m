Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EE061FD14
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiKGSP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiKGSPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:15:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05077E83
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844843; x=1699380843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MyF5GELrMXrTKZfHBWtJcic/wlj8l7IJA/4f+idDNHU=;
  b=ZsZEOgH8seeab/955fgoKE/c+LNX6h83J2DFQMcK1J2OSa8qDFYEKsAu
   Mre2xubloEcLJnhK0Du4KY3/rNe/3N4RWiohtQO7WNRt0VkFvo03a2eb3
   lE6C5D3UgniUx2CEAdpKE23w/2yWMxP8Vg82Mkm/oAB9oZQOvenmiPNxq
   IejanGYi4TVP/FPnxa8SDGZhdaURAXon2EuDlZwHZQN1bSU1x71Cpyrly
   cLVa3yAMI3hOMzmxkw3AXNoMPTHZqPPA2wqD47oT48DSBeRDhfU8INoqQ
   sTiWiPDwy3vt8hpi3Qftg5ZPLfmw+rLt1dFP7m/hnketQaHx1zvAmf2ph
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293851931"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293851931"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962648"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962648"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:00 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v10 03/10] devlink: Enable creation of the devlink-rate nodes from the driver
Date:   Mon,  7 Nov 2022 19:13:19 +0100
Message-Id: <20221107181327.379007-4-michal.wilczynski@intel.com>
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
index 0e763de4cbf5..e5c0e091d692 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1609,6 +1609,9 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
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
index 395fdf3e0299..0266301416c8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10381,6 +10381,51 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
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

