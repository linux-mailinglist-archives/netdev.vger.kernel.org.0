Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A271960F853
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiJ0NDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiJ0NDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:03:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369111757B1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666875822; x=1698411822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XRq2kybRZbougzVdrDUnqPY0pplqNh8suUPOC6YXNVU=;
  b=ibir73S9Ih8/EvRVqzm5cqfqAwDpHqBnjIZp0r6Opv+7+dE7eWX7Fy4t
   TAlzLhkrtGHD6/jpxdOwT2cfHg+ifPinvyjCs1QRP7/5KfKgNEP8/qQVi
   6kMraAkZxsLShD8aKA/rcfF2Ah7HRB37OvVS5Lpfd93QrtI/qwuL3ArzK
   0ZT91vqj7WqHf4RusNjcQsYceeCSwQhBgBqW3w45gOTB7apsXZVuaDaMN
   Ktp1X5zvH+eFReIiKM8TA6RJZGMnGLPf+xyy48Hx6b4Ga1paViMKQw7dn
   9jvF+4YVDx3WEdd6kPpcvlQBgDUY38yd8nmV2Xq1Q/6ilVs2fjj5s/y2b
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="394530487"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="394530487"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 06:03:42 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="583546629"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="583546629"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 06:03:39 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v7 4/9] devlink: Allow for devlink-rate nodes parent reassignment
Date:   Thu, 27 Oct 2022 15:00:44 +0200
Message-Id: <20221027130049.2418531-5-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221027130049.2418531-1-michal.wilczynski@intel.com>
References: <20221027130049.2418531-1-michal.wilczynski@intel.com>
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

Currently it's not possible to reassign the parent of the node using one
command. As the previous commit introduced a way to export entire
hierarchy from the driver, being able to modify and reassign parents
become important. This way user might easily change QoS settings without
interrupting traffic.

Example command:
devlink port function rate set pci/0000:4b:00.0/1 parent node_custom_1

This reassigns leaf node parent to node_custom_1.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 net/core/devlink.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 864fa0967b7a..1e0c1b0376bf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1875,10 +1875,9 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 	int err = -EOPNOTSUPP;
 
 	parent = devlink_rate->parent;
-	if (parent && len) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
-		return -EBUSY;
-	} else if (parent && !len) {
+
+	/* if a parent is already set, just reassign the parent */
+	if (parent && !len) {
 		if (devlink_rate_is_leaf(devlink_rate))
 			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
 							devlink_rate->priv, NULL,
@@ -1892,7 +1891,7 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
 
 		refcount_dec(&parent->refcnt);
 		devlink_rate->parent = NULL;
-	} else if (!parent && len) {
+	} else if (len) {
 		parent = devlink_rate_node_get_by_name(devlink, parent_name);
 		if (IS_ERR(parent))
 			return -ENODEV;
@@ -1919,6 +1918,10 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
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

