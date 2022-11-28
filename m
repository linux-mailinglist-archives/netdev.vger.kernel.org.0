Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC9563B365
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiK1UhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiK1UhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56D62BB12
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667821; x=1701203821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8R/QGVbLGskCZMIEeWlwA0jjlNvyjKrzaZIidih24rM=;
  b=I06hH03vm5YoMg4nAT0YMYZyJProrV2UpI3+OkB9AzZznRFaM3ggNwTy
   gYG3uckHixrwNLUdwfeC/zdGnv5r9z8yeNEKzK3basjev1O+Up7m2+fSO
   PhkX8ptj/mfXHb7UJgkvv5a6nqQ5FlBQTVFUUIQI71fzgJbIncFh2gKix
   KhxMxEt58ws0xc5KoXg1cZsbn9cH1rHv0kSXsLLaeBUvYBftphKTrSqoQ
   +Wt8zerBVnvJ56UoomL5gQk4LNRVJuiAjJg3AEDm4b1NWX2c5Vf6+hMcN
   v+6ZYins5XgI5V48AX9hO76fTKLgnuHAK/VKd09vxwcQZhtrpIMsmZUOz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205387"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205387"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286348"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286348"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 3/9] devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
Date:   Mon, 28 Nov 2022 12:36:41 -0800
Message-Id: <20221128203647.1198669-4-jacob.e.keller@intel.com>
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

The snapshot pointer is obtained inside of the function
devlink_nl_region_read_snapshot_fill. Simplify this function by locating
the snapshot upfront in devlink_nl_cmd_region_read_dumpit instead. This
aligns with how other netlink attributes are handled, and allows us to
exit slightly earlier if an invalid snapshot ID is provided.

It also allows us to pass the snapshot pointer directly to the
devlink_nl_region_read_snapshot_fill, and remove the now unused attrs
parameter.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changes since v2:
* Fixed capitalization of NL_SET_ERR_MSG_ATTR

 net/core/devlink.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8d44ef3c1ea8..b89649919bba 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6463,24 +6463,16 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 
 static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 						struct devlink *devlink,
-						struct devlink_region *region,
-						struct nlattr **attrs,
+						struct devlink_snapshot *snapshot,
 						u64 start_offset,
 						u64 end_offset,
 						u64 *new_offset)
 {
-	struct devlink_snapshot *snapshot;
 	u64 curr_offset = start_offset;
-	u32 snapshot_id;
 	int err = 0;
 
 	*new_offset = start_offset;
 
-	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
-	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
-	if (!snapshot)
-		return -EINVAL;
-
 	while (curr_offset < end_offset) {
 		u32 data_size;
 		u8 *data;
@@ -6506,14 +6498,16 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct nlattr *chunks_attr, *region_attr, *snapshot_attr;
 	u64 ret_offset, start_offset, end_offset = U64_MAX;
-	struct nlattr *chunks_attr, *region_attr;
 	struct nlattr **attrs = info->attrs;
 	struct devlink_port *port = NULL;
+	struct devlink_snapshot *snapshot;
 	struct devlink_region *region;
 	const char *region_name;
 	struct devlink *devlink;
 	unsigned int index;
+	u32 snapshot_id;
 	void *hdr;
 	int err;
 
@@ -6561,6 +6555,15 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	snapshot_attr = attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
+	snapshot_id = nla_get_u32(snapshot_attr);
+	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
+	if (!snapshot) {
+		NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "Requested snapshot does not exist");
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
 	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
 		if (!start_offset)
@@ -6610,7 +6613,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	}
 
 	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
-						   region, attrs,
+						   snapshot,
 						   start_offset,
 						   end_offset, &ret_offset);
 
-- 
2.38.1.420.g319605f8f00e

