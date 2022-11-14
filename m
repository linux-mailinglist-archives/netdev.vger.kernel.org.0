Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE63B62871E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbiKNRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbiKNRcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:32:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F86A2ED7D
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668447128; x=1699983128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=93qCGsP/2CVIXCSLnePfT/rbbDYJyw/oujm3uQP89uk=;
  b=Pql0yxEdzoP8sPwQBNmyzVOWVUKTEJXMC7jBINfKnN+9wqk4YNKGK2Fl
   MX6lLtspW/87y+ROfQRN4tqokECavmR3ZQABSU+qnHwbDPBZJCMyvdSdp
   MEghWrpJzF1PS2jRb3lJyg4Q6VqNV7v2KRTWgib7h82NGOiTb9/NQX1bq
   0rxSpsyeDwxnUmb/7bkiKZY7WLaNRQew1YdZ2W5cBKaX0kpjA1K2WHUkF
   /3bFuFiT5mfNZXlvx6H1rqyb9rAn7mIBs4hCdBeYbqly5jeckryaMQpgk
   6gBhD84gaa1Of410S++j3O/VEMo6EPgZLjyldXa3izsPPZxi3VJKXECPW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376297663"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="376297663"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 09:32:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="781012068"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="781012068"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 09:32:05 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v11 04/11] devlink: Allow for devlink-rate nodes parent reassignment
Date:   Mon, 14 Nov 2022 18:31:31 +0100
Message-Id: <20221114173138.165319-5-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221114173138.165319-1-michal.wilczynski@intel.com>
References: <20221114173138.165319-1-michal.wilczynski@intel.com>
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

