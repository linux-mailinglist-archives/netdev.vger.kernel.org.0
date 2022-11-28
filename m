Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C51C63B35E
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiK1UhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbiK1UhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:02 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63722B25F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667821; x=1701203821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UhEXNlIrvqzBYkm4r7ZRN+O/M8wfpnjBTVMBXstJzSk=;
  b=VbHIH3jEkpRIYBbZ50m8yIf90VBVH8yf4vDSsVCtZGgkF7/vy+ATeqgf
   nd665ytPwA/tFOo0jbVrVwLBm1Bz2FG4bVJ8cRGcbZ4Yb+c/SheZokJMx
   KqVJvaaLtFBbGspY3ZK3+wTqnfHFb3Wzztd1jB6XK6QbWgRVBdKwBm3Xe
   GN1eRrFDBsUNHFzqELnlI2QP3CZ6Z8vR+Gpt2i3QeaPlxrI7ctGIiAgwB
   bP/g0wcd208FM+/ThVbtGkwbNVyqIYUT2aR6e/waODyFuPZbmunlPqziB
   ROOhhYC+aYPfviICG2Vq4MpRydznND1Ci8RpKscy5SokoO7yO5bPfy+6u
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205380"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205380"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286345"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286345"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/9] devlink: report extended error message in region_read_dumpit()
Date:   Mon, 28 Nov 2022 12:36:40 -0800
Message-Id: <20221128203647.1198669-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
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

Report extended error details in the devlink_nl_cmd_region_read_dumpit()
function, by using the extack structure from the netlink_callback.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changes since v2:
* Fixed capitalization of NL_SET_ERR_MSG_ATTR

 net/core/devlink.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ff802788ee05..8d44ef3c1ea8 100644
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
+		NL_SET_ERR_MSG_ATTR(cb->extack, region_attr, "Requested region does not exist");
 		err = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.38.1.420.g319605f8f00e

