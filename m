Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687C2629638
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbiKOKtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiKOKs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:48:56 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517FE20367
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668509335; x=1700045335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=93qCGsP/2CVIXCSLnePfT/rbbDYJyw/oujm3uQP89uk=;
  b=giF5gM3F9x1sksj6TdIKJfXrfXYQpBYZX/Kb6ILS9BLCGrtwACRkXGeY
   pzaa44ZhrxegWTD0hd4wvFiC4KBgSl5hb+uRHRCNYCF+Y9isQvqzazCjK
   oL165qWQWR5Gavb0JkCrC7mPXRHk0KjEZSdh6W1XzXkpjP+qR6i4HBRSh
   Tufwl8nPFJT5GAbnUBmMon+Rt85DojsX76YKbTjjtoGNw2ZWeXIj1INgY
   FNpMae33yePybB9aT6EZS1Hi5QwWW9vXdTJT84FxQL5fpOpOZ5yKKGfni
   6lvnuegMSMOsY25g/IXLz4uWd5Yru9REEMpfv2JUFsGBMatTHdxUZhdaE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376489467"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376489467"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633193418"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633193418"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:48:52 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v12 04/11] devlink: Allow for devlink-rate nodes parent reassignment
Date:   Tue, 15 Nov 2022 11:48:18 +0100
Message-Id: <20221115104825.172668-5-michal.wilczynski@intel.com>
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

Currently it's not possible to reassign the parent of the node using one
command. As the previous commit introduced a way to export entire
hierarchy from the driver, being able to modify and reassign parents
become important. This way user might easily change QoS settings without
interrupting traffic.

Example command:
devlink port function rate set pci/0000:4b:00.0/1 parent node_custom_1

This reassigns leaf node parent to node_custom_1.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3dfee7cd9929..61d431578f5f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1887,10 +1887,8 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 	int err = -EOPNOTSUPP;
 
 	parent = devlink_rate->parent;
-	if (parent && len) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
-		return -EBUSY;
-	} else if (parent && !len) {
+
+	if (parent && !len) {
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
 							devlink_rate->priv, NULL,
@@ -1904,7 +1902,7 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 
 		refcount_dec(&parent->refcnt);
 		devlink_rate->parent = NULL;
-	} else if (!parent && len) {
+	} else if (len) {
 		parent = devlink_rate_node_get_by_name(devlink, parent_name);
 		if (IS_ERR(parent))
 			return -ENODEV;
@@ -1931,6 +1929,10 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 		if (err)
 			return err;
 
+		if (devlink_rate->parent)
+			/* we're reassigning to other parent in this case */
+			refcount_dec(&devlink_rate->parent->refcnt);
+
 		refcount_inc(&parent->refcnt);
 		devlink_rate->parent = parent;
 	}
-- 
2.37.2

