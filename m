Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015194D5522
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiCJXNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiCJXNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:13:22 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F1A19ABCB
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646953940; x=1678489940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+Dnfe18PKKFEvifwsKaU0pWiAPrTOCTnyl9KW2GLQM=;
  b=Fw00xeoMxAGA3a4pM8DvzUpm5tOFatcl+AHG+OIDvCjsNJOsP8D1jTRt
   x6kJruzA+f05pcNN3x1Tid/g8obePI2EWjKPkAvbPo2BjjpAGh9QzF4E9
   V9Jp9v2dk5ykMvMikNwS70SydUE9/dllpdN2iMr7BSNJKM4LXYQFFHuHq
   hrXUvZIQgeSeVT2Nhve8faiC3xD5auCVapDoQHqtbo73qgSp85J1W6m0T
   pQ9BZDfWTczUGRekn04+ThsetQE1afvM1RASQcuTd909gIkioK4elnvBx
   vRHitEXMiFB4YRpgB9D0E1PdXCpkiPe++4qXsQZj7UdzALLi2L7bGouu2
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="255141739"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="255141739"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 15:12:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="644652734"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 10 Mar 2022 15:12:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sudheer.mogilappagari@intel.com, amritha.nambiar@intel.com,
        jiri@nvidia.com, leonro@nvidia.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net-next 1/2] devlink: Allow parameter registration/unregistration during runtime
Date:   Thu, 10 Mar 2022 15:12:34 -0800
Message-Id: <20220310231235.2721368-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sridhar Samudrala <sridhar.samudrala@intel.com>

commit 7a690ad499e7 ("devlink: Clean not-executed param notifications")
added ASSERTs and removed notifications when devlink parameters are
registered by the drivers after the associated devlink instance is
already registered.
The next patch in this series adds a feature in 'ice' driver that is
only enabled when ADQ queue groups are created and introduces a
devlink parameter to configure this feature per queue group.

To allow dynamic parameter registration/unregistration during runtime,
revert the changes added by the above commit.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 net/core/devlink.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index fcd9f6d85cf1..d09f2aa4f48f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4724,7 +4724,6 @@ static void devlink_param_notify(struct devlink *devlink,
 	WARN_ON(cmd != DEVLINK_CMD_PARAM_NEW && cmd != DEVLINK_CMD_PARAM_DEL &&
 		cmd != DEVLINK_CMD_PORT_PARAM_NEW &&
 		cmd != DEVLINK_CMD_PORT_PARAM_DEL);
-	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -10120,8 +10119,6 @@ int devlink_params_register(struct devlink *devlink,
 	const struct devlink_param *param = params;
 	int i, err;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	for (i = 0; i < params_count; i++, param++) {
 		err = devlink_param_register(devlink, param);
 		if (err)
@@ -10152,8 +10149,6 @@ void devlink_params_unregister(struct devlink *devlink,
 	const struct devlink_param *param = params;
 	int i;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	for (i = 0; i < params_count; i++, param++)
 		devlink_param_unregister(devlink, param);
 }
@@ -10173,8 +10168,6 @@ int devlink_param_register(struct devlink *devlink,
 {
 	struct devlink_param_item *param_item;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	WARN_ON(devlink_param_verify(param));
 	WARN_ON(devlink_param_find_by_name(&devlink->param_list, param->name));
 
@@ -10190,6 +10183,7 @@ int devlink_param_register(struct devlink *devlink,
 	param_item->param = param;
 
 	list_add_tail(&param_item->list, &devlink->param_list);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_register);
@@ -10204,11 +10198,10 @@ void devlink_param_unregister(struct devlink *devlink,
 {
 	struct devlink_param_item *param_item;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	param_item =
 		devlink_param_find_by_name(&devlink->param_list, param->name);
 	WARN_ON(!param_item);
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
 	list_del(&param_item->list);
 	kfree(param_item);
 }
@@ -10268,8 +10261,6 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
@@ -10283,6 +10274,7 @@ int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 	else
 		param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
+	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
-- 
2.31.1

