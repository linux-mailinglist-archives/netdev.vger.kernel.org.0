Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B2661FD15
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiKGSPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiKGSPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:15:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08997389C
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844847; x=1699380847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z9DkviUCUFbNCqewJW8/XPDq7nN2SHMrF/DpBnsDwi8=;
  b=RO79l7t0jCsYRTGJHYa/F759lweRTuQz6H6YYvg+T0Okghh+rYck1O43
   fnbbwipTGEGO8MPRvOOBQJ19Kb46TleTKTDv6+fMmh5qx+92Bf+MspJ1X
   tw15tZ7y9qRuzCQDsJDk9c7vmbtTLzzjLix8r+67oikVOovqV9t7Qb2p8
   pI7yCVetxAtVTU6XVJ3t0QCbuoJUDHsZuCNDSZ+ZuqbgvwHQVaFRWlBKf
   pSy6u2hgGmAjtY//2+0GwzNXev1xkm1SzrSKbUCn2vp8MkoCR3Pua5SH+
   gmsNaEpp5L/+WcfcVy8+adHm8WjBmHJkw0RXQacICPiONgBReO6N75Xfg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293851950"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293851950"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962675"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962675"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:03 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v10 04/10] devlink: Allow for devlink-rate nodes parent reassignment
Date:   Mon,  7 Nov 2022 19:13:20 +0100
Message-Id: <20221107181327.379007-5-michal.wilczynski@intel.com>
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
index 0266301416c8..9f00ea85b5f8 100644
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

