Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6536A62E7C7
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbiKQWJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240833AbiKQWIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F4C7DEF9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722895; x=1700258895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lemMvwGJE75Yf4G+2HeXvKU0loQtYFFg8CI/9mIqUGA=;
  b=SY6KR2Y3yD7lyc6mPEgikuzZb5T+ulkz1izPmoDnaAiWp9gyAUtN+q5g
   w3nkeJDdkLakxwqsRwIL2Xo1EpvMxmMYZojEtlrwCOCzahNsCSnqdkGfh
   8bK9TTdF+c7pNyYyRhCtjuqwd2p0olQ3510CJZoQNiSNsh2nrM77AAfGn
   yZFufiWmnPhshlBvqupYv7OO4DR14WGR6CWLZQXmpPB1PxmgcrnWwSmSn
   ygjHndnsIhd9zdbIhmVmOEs8EO9eWN11/O1hQolUPPytYoDWMqBGV8RgH
   /4IV9JpZ6BD76d2uPHtziWH8NHhmtgxlRTBsnNfTcJeG5KMyRJyk3PsZ0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001215"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001215"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975617"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975617"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/8] devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
Date:   Thu, 17 Nov 2022 14:07:56 -0800
Message-Id: <20221117220803.2773887-2-jacob.e.keller@intel.com>
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

The snapshot pointer is obtained inside of the function
devlink_nl_region_read_snapshot_fill. Simplify this function by locating
the snapshot upfront in devlink_nl_cmd_region_read_dumpit instead. This
aligns with how other netlink attributes are handled, and allows us to
exit slightly earlier if an invalid snapshot ID is provided.

It also allows us to pass the snapshot pointer directly to the
devlink_nl_region_read_snapshot_fill, and remove the now unused attrs
parameter.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7f789bbcbbd7..96afc7013959 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6399,24 +6399,16 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 
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
@@ -6447,11 +6439,13 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	u64 ret_offset, start_offset, end_offset = U64_MAX;
 	struct nlattr **attrs = info->attrs;
 	struct devlink_port *port = NULL;
+	struct devlink_snapshot *snapshot;
 	struct devlink_region *region;
 	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
 	unsigned int index;
+	u32 snapshot_id;
 	void *hdr;
 	int err;
 
@@ -6491,6 +6485,13 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
+	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
+	if (!snapshot) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
 	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
 		if (!start_offset)
@@ -6540,7 +6541,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	}
 
 	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
-						   region, attrs,
+						   snapshot,
 						   start_offset,
 						   end_offset, &ret_offset);
 
-- 
2.38.1.420.g319605f8f00e

