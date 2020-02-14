Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1499615FA5F
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgBNXWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:12667 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629331"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:28 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 20/22] devlink: refactor region_read_snapshot_fill to use a callback function
Date:   Fri, 14 Feb 2020 15:22:19 -0800
Message-Id: <20200214232223.3442651-21-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
 net/core/devlink.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a722272f42b4..c200701e1839 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4140,24 +4140,34 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 
 #define DEVLINK_REGION_READ_CHUNK_SIZE 256
 
+typedef int devlink_chunk_fill_t(void *cb_priv, u8 *chunk, u32 chunk_size,
+				 u64 curr_offset,
+				 struct netlink_ext_ack *extack);
+
 static int
-devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
-				     struct devlink_snapshot *snapshot,
-				     u64 start_offset,
-				     u64 end_offset,
-				     u64 *new_offset)
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
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, data,
 							    data_size,
 							    curr_offset);
@@ -4168,9 +4178,23 @@ devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
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
@@ -4270,8 +4294,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		end_offset = region->size;
 	}
 
-	err = devlink_nl_region_read_snapshot_fill(skb, snapshot, start_offset,
-						   end_offset, &ret_offset);
+	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
+					  snapshot, start_offset, end_offset,
+					  &ret_offset, cb->extack);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
-- 
2.25.0.368.g28a2d05eebfb

