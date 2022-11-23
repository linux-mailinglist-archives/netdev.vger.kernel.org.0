Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A8E636B55
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiKWUjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240323AbiKWUin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:38:43 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E9B6550
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669235923; x=1700771923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KgOKbiKkJyDAdVUwg7KRj/fVpc1HDOmRpEhBwx7V1kI=;
  b=SbtEpGynH5zXVIbDjZVi2HGLdcrEegbmoEEydBNEpZ/+iOQ+oSU4O/FX
   1vXf3qPV0yjhZUfsvVJo/LtxFYQULh/JOyvqQHcgRco05i89AdTkogk24
   4LlgELdS2U8EFkC8P5UIGnv28QsUPWorlcFBuMTkiLBwQ04nPwDNFyXw3
   zBujOJQGzx0bsfgqaTMFynwC7/kVEZXEOYGFdeFT8ZDyZUjbkqM/2bncc
   MwsI2wVJLcS1HIPiKF9qtwOPYxyNyhYmAAwx5mqduUdBZ7tewrinc6VOO
   /EjoAdAHE9icodeLBu+Ccevi6ABQcLaIaeMzRJUn/LaCbUruBSgrE40tX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315307128"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315307128"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619756046"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619756046"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/9] devlink: report extended error message in region_read_dumpit
Date:   Wed, 23 Nov 2022 12:38:27 -0800
Message-Id: <20221123203834.738606-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221123203834.738606-1-jacob.e.keller@intel.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report extended error details in the devlink_nl_cmd_region_read_dumpit
function, by using the extack structure from the netlink_callback.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v1:
* Moved to 2/9 of the series
* No longer includes change to snapshot, as that is now handled in 3/9
* use local region_attr variable and NL_SET_ERR_MSG_ATTR

 net/core/devlink.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a490b8850179..b5b317661f9a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6507,10 +6507,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	u64 ret_offset, start_offset, end_offset = U64_MAX;
+	struct nlattr *chunks_attr, *region_attr;
 	struct nlattr **attrs = info->attrs;
 	struct devlink_port *port = NULL;
 	struct devlink_region *region;
-	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
 	unsigned int index;
@@ -6525,8 +6525,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	devl_lock(devlink);
 
-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
+		NL_SET_ERR_MSG(cb->extack, "No region name provided");
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+		NL_SET_ERR_MSG(cb->extack, "No snapshot id provided");
 		err = -EINVAL;
 		goto out_unlock;
 	}
@@ -6541,7 +6547,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		}
 	}
 
-	region_name = nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
+	region_attr = attrs[DEVLINK_ATTR_REGION_NAME];
+	region_name = nla_data(region_attr);
 
 	if (port)
 		region = devlink_port_region_get_by_name(port, region_name);
@@ -6549,6 +6556,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		region = devlink_region_get_by_name(devlink, region_name);
 
 	if (!region) {
+		NL_SET_ERR_MSG_ATTR(cb->extack, region_attr, "requested region does not exist");
 		err = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.38.1.420.g319605f8f00e

