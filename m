Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2C62E7C9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241195AbiKQWJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241068AbiKQWIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2550C84320
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722898; x=1700258898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G8eSWyLkbd/h+QNdLKu4MQsKfcDN4nHLWIyiJsy5iK0=;
  b=Q5VawprZvNYHHCNBIrYyvGDfqjvQTtDiKfkRF+Hx2IPUH4cwVIPzZWco
   t6zqmF4V2VKDRGpEdm/fxh/r9IBqfomndKKrSpyugtMfIJaSIQTfqywyZ
   61vhwrlptDIi0g0jelHcansA4PKp1eHrLQpCgGrkTWXkhSco7tnCLDykt
   B3Baab28o8Iovn7e3dXCzLwrXQfsZDhzkW7CTw5aZnRWAKZLyYv0XcDWy
   lnZcl/JvfdAk4jj871CPQQZg9sN62+jnsgAgIBQ+H+BELYpzeNaVSvcKD
   ltWSAaIu2FFQfHcAYp+5lotx1wqLDX05LDJ/PJXV3CfVafD8q7MsNwXo1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001217"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001217"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975623"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975623"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/8] devlink: report extended error message in region_read_dumpit
Date:   Thu, 17 Nov 2022 14:07:58 -0800
Message-Id: <20221117220803.2773887-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221117220803.2773887-1-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report extended error details in the devlink_nl_cmd_region_read_dumpit
function, by using the extack structure from the netlink_callback.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 932476956d7e..f2ee1da5283c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6453,8 +6453,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	devl_lock(devlink);
 
-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
+		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+		NL_SET_ERR_MSG_MOD(cb->extack, "No snapshot id provided");
 		err = -EINVAL;
 		goto out_unlock;
 	}
@@ -6477,6 +6483,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		region = devlink_region_get_by_name(devlink, region_name);
 
 	if (!region) {
+		NL_SET_ERR_MSG_MOD(cb->extack,
+				   "The requested region does not exist");
 		err = -EINVAL;
 		goto out_unlock;
 	}
@@ -6484,6 +6492,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
 	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
 	if (!snapshot) {
+		NL_SET_ERR_MSG_MOD(cb->extack,
+				   "The requested snapshot id does not exist");
 		err = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.38.1.420.g319605f8f00e

