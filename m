Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537E5619A15
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiKDOeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiKDOeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:34:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E58231DDD
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572308; x=1699108308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kqy+hg3/urv6AJD+2NG2Q9vvxeSlcDAAVmV24C+/ZCo=;
  b=PHLYkXYUle5ZpC0MA+e2ew7ftz8YPJK6VyJ+YUwbUqC+0J7sHoil79oN
   M2xmPusxgY8bOQdrWP8NGSx54/gd7I7W/yvLD90eyp1pGKgqaw/xayY9i
   BF43uRtrqY2j/yeegm2b5jn6B6ZNTiRMm3ChBx13VkZY3S6sFegufhnms
   o9TO/A8P6jVN/urm9tilDoUZDNnekzUa4cmlZK+6JAoRxtmf+k3rikTiT
   T/AluR9sLMhrC6s986H+d2q+8XX3tj/R67hfUWNi+FRnfsDPKWWgI7QxX
   Y+bMqpVHjDlR4IAIHewFRqAj4sUAj1AnQccHdOwQxd7Z6ei3O7auHPlIm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="290367504"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="290367504"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:28 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730275"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730275"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:25 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v9 3/9] devlink: Enable creation of the devlink-rate nodes from the driver
Date:   Fri,  4 Nov 2022 15:30:56 +0100
Message-Id: <20221104143102.1120076-4-michal.wilczynski@intel.com>
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

Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
rigid and can't be easily removed. This requires an ability to export
default hierarchy to allow user to modify it. Currently the driver is
only able to create the 'leaf' nodes, which usually represent the vport.
This is not enough for HQoS implemented in Intel hardware.

Introduce new function devl_rate_node_create() that allows for creation
of the devlink-rate nodes from the driver.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 include/net/devlink.h |  3 +++
 net/core/devlink.c    | 45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5076118dc9b6..4562364b8ce1 100644
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
index 91e0b7537459..59adcb58f188 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10377,6 +10377,51 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
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

