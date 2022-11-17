Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D69962E7CB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiKQWJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241082AbiKQWIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:45 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2595284323
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722898; x=1700258898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UPhha1+oE/o6ijQ1ehWZ9ivZxkoIFU7ohh3SHtAR8Gw=;
  b=mV/rRgEWxWNPsUTLAN19SVLI+4aLC8RS6SceodkXxfeT1Byh+A2PNYrs
   Y/rj2kuU734N4q6qsOLRjCe/18uyMt8kTqBSCVts9Ay1uaXoPnNkiyT4B
   8JBbHJajjFbFS81EVJxYTckGQfsGP1V6MiKQG3XJUhWekyvbCVs781FjK
   xUGcpHzjKQyDInheXzjYTINbdqdBCCmivaxUp5BOLIMwXRq+k7tuFK788
   Bzc116HEejII8qDorrNJX1TgSWAmMDXtTMpaWzDp9Jor8eX5XzAN1rFgt
   H+nfiwmFr4HXEXtkXBnMt09ptBWKOMIYLsLYpwx8wEbQ5wsyCTz28Dv2u
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001219"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001219"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975630"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975630"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/8] devlink: refactor region_read_snapshot_fill to use a callback function
Date:   Thu, 17 Nov 2022 14:08:00 -0800
Message-Id: <20221117220803.2773887-6-jacob.e.keller@intel.com>
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

The devlink_nl_region_read_snapshot_fill is used to copy the contents of
a snapshot into a message for reporting to userspace via the
DEVLINK_CMG_REGION_READ netlink message.

A future change is going to add support for directly reading from
a region. Almost all of the logic for this new capability is identical.

To help reduce code duplication and make this logic more generic,
refactor the function to take a cb and cb_priv pointer for doing the
actual copy.

Add a devlink_region_snapshot_fill implementation that will simply copy
the relevant chunk of the region. This does require allocating some
storage for the chunk as opposed to simply passing the correct address
forward to the devlink_nl_cmg_region_read_chunk_fill function.

A future change to implement support for directly reading from a region
without a snapshot will provide a separate implementation that calls the
newly added devlink region operation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index c28c3f2bb6e4..97e3a7158788 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6396,23 +6396,34 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 
 #define DEVLINK_REGION_READ_CHUNK_SIZE 256
 
-static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
-						struct devlink_snapshot *snapshot,
-						u64 start_offset,
-						u64 end_offset,
-						u64 *new_offset)
+typedef int devlink_chunk_fill_t(void *cb_priv, u8 *chunk, u32 chunk_size,
+				 u64 curr_offset,
+				 struct netlink_ext_ack *extack);
+
+static int
+devlink_nl_region_read_fill(struct sk_buff *skb, devlink_chunk_fill_t *cb,
+			    void *cb_priv, u64 start_offset, u64 end_offset,
+			    u64 *new_offset, struct netlink_ext_ack *extack)
 {
 	u64 curr_offset = start_offset;
 	int err = 0;
+	u8 *data;
+
+	/* Allocate and re-use a single buffer */
+	data = kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
 
 	*new_offset = start_offset;
 
 	while (curr_offset < end_offset) {
 		u32 data_size = min_t(u32, end_offset - curr_offset,
 				      DEVLINK_REGION_READ_CHUNK_SIZE);
-		u8 *data;
 
-		data = &snapshot->data[curr_offset];
+		err = cb(cb_priv, data, data_size, curr_offset, extack);
+		if (err)
+			break;
+
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, data, data_size, curr_offset);
 		if (err)
 			break;
@@ -6421,9 +6432,23 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 	}
 	*new_offset = curr_offset;
 
+	kfree(data);
+
 	return err;
 }
 
+static int
+devlink_region_snapshot_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
+			     u64 curr_offset,
+			     struct __always_unused netlink_ext_ack *extack)
+{
+	struct devlink_snapshot *snapshot = cb_priv;
+
+	memcpy(chunk, &snapshot->data[curr_offset], chunk_size);
+
+	return 0;
+}
+
 static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
@@ -6542,8 +6567,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto nla_put_failure;
 	}
 
-	err = devlink_nl_region_read_snapshot_fill(skb, snapshot, start_offset,
-						   end_offset, &ret_offset);
+	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
+					  snapshot, start_offset, end_offset,
+					  &ret_offset, cb->extack);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
-- 
2.38.1.420.g319605f8f00e

