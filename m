Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239CE610EFF
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiJ1KwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiJ1KwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:52:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149798F264
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666954328; x=1698490328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sM4ExVW3JVww49GcG3XE1ml4o96oQx3TouQ+llSGVsc=;
  b=SXw6yD1lZYBmX+psrVNEldb/Tlf203GtmxivTaTJ4vrkMlZ07V4MSUoT
   zhxZQSIp5lDqRfGHJNgXAP4QNcTzelUz3FB46DChgw12+tFCgOZtxQRV2
   sH/G1o7zuRn/Brjhy0oNBAC+Mtt8zycLx2lXuekvHUmdhcEGcxNNM0pIe
   u6VbLtBMgSnb9J2Y+Cq8EL4vji7Wvhskve6EDxCgMhz2IBF7WsIhYteN+
   ceB9Vq4Ekyzmhs3qa738HwRC+H2ov2X2n0/PH5aqV3h0DZu+uQKsafbXA
   U7x54Mih51MkHlirAtBIjKSKoxqdhIza4xdr9FoaTxSaD2/GIqhGz0EHI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="394777600"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="394777600"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701695327"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701695327"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 03:52:05 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v8 3/9] devlink: Enable creation of the devlink-rate nodes from the driver
Date:   Fri, 28 Oct 2022 12:51:37 +0200
Message-Id: <20221028105143.3517280-4-michal.wilczynski@intel.com>
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

Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
rigid and can't be easily removed. This requires an ability to export
default hierarchy to allow user to modify it. Currently the driver is
only able to create the 'leaf' nodes, which usually represent the vport.
This is not enough for HQoS implemented in Intel hardware.

Introduce new function devl_rate_node_create() that allows for creation
of the devlink-rate nodes from the driver.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 include/net/devlink.h |  4 ++++
 net/core/devlink.c    | 49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 929cb72ef412..9d0a424712fd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -98,6 +98,8 @@ struct devlink_port_attrs {
 	};
 };
 
+#define DEVLINK_RATE_NAME_MAX_LEN 30
+
 struct devlink_rate {
 	struct list_head list;
 	enum devlink_rate_type type;
@@ -1601,6 +1603,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
 int devl_rate_leaf_create(struct devlink_port *port, void *priv);
+int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
+			  char *parent_name);
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devl_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b97c077cf66e..08f1bbd54c43 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10270,6 +10270,55 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
+/**
+ * devl_rate_node_create - create devlink rate node
+ * @devlink: devlink instance
+ * @priv: driver private data
+ * @node_name: name of the resulting node
+ * @parent_name: name of the parent node
+ *
+ * Create devlink rate object of type node
+ */
+int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name, char *parent_name)
+{
+	struct devlink_rate *rate_node;
+	struct devlink_rate *parent;
+
+	rate_node = devlink_rate_node_get_by_name(devlink, node_name);
+	if (!IS_ERR(rate_node))
+		return -EEXIST;
+
+	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
+	if (!rate_node)
+		return -ENOMEM;
+
+	if (parent_name) {
+		parent = devlink_rate_node_get_by_name(devlink, parent_name);
+		if (IS_ERR(parent)) {
+			kfree(rate_node);
+			return -ENODEV;
+		}
+		rate_node->parent = parent;
+		refcount_inc(&rate_node->parent->refcnt);
+	}
+
+	rate_node->type = DEVLINK_RATE_TYPE_NODE;
+	rate_node->devlink = devlink;
+	rate_node->priv = priv;
+
+	rate_node->name = kstrndup(node_name, DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
+	if (!rate_node->name) {
+		kfree(rate_node);
+		return -ENOMEM;
+	}
+
+	refcount_set(&rate_node->refcnt, 1);
+	list_add(&rate_node->list, &devlink->rate_list);
+	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_rate_node_create);
+
 /**
  * devl_rate_leaf_create - create devlink rate leaf
  * @devlink_port: devlink port object to create rate object on
-- 
2.37.2

