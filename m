Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F7B619A0E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiKDOem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKDOeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:34:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95482E35
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572309; x=1699108309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QxWQSRr6vX8l/LwaRbZNaascat/lPQF6vMDsz7qIn2U=;
  b=R64xUdhPZXH9JlQXai/4dn2jXdfsCjYEldiFS+DpEu9K5zEPRQ6wVmCh
   hQUHgK6RTump1fDJhvhMooIIcBaTJAsF9K1G7JUbt/mQassJUS8qrSAbX
   /egCXsIKkq8MG16We0wpKgTXU1YzCp8ATC4V7dZ9gd1M5jnaiALIUbkxj
   F+OQnuVV7xFRjfijBb1SeoqDj0ZlexrOR+wUrDUy/4gLYGs2C4ym+B6pp
   BOaTY1sUEPTCTGOJNNvQ6jeO/zcBbS8xL9/0GhMf/RekJyrkbhTfIhAVZ
   oiSLnHiSOrCe/+x/ODrbcSKwElVoFzgmoOvfRk+fYJyra9UP8ohZy7OII
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="290367517"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="290367517"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:31 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730304"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730304"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:28 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v9 4/9] devlink: Allow for devlink-rate nodes parent reassignment
Date:   Fri,  4 Nov 2022 15:30:57 +0100
Message-Id: <20221104143102.1120076-5-michal.wilczynski@intel.com>
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
index 59adcb58f188..80233c750f00 100644
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

