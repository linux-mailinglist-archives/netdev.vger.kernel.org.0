Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647E314E5D0
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgA3W7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:51510 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbgA3W70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187822"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:24 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 13/15] devlink: support directly reading from region memory
Date:   Thu, 30 Jan 2020 14:59:08 -0800
Message-Id: <20200130225913.1671982-14-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new region operation for directly reading from a region, without
taking a full snapshot.

Extend the DEVLINK_CMD_REGION_READ to allow directly reading from
a region, if supported. Instead of reporting a missing snapshot id as
invalid, check to see if direct reading is implemented for the region.
If so, use the direct read operation to grab the current contents of the
region.

This new behavior of DEVLINK_CMD_REGION_READ should be backwards
compatible. Previously, all kernels rejected such
a DEVLINK_CMD_REGION_READ with -EINVAL, and will now either accept the
call or report -EOPNOTSUPP for regions which do not implement direct
access.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-region.rst     |  8 ++
 include/net/devlink.h                         |  4 +
 net/core/devlink.c                            | 82 +++++++++++++++++--
 3 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 262249e6c3fc..a543f5ee7a9e 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -25,6 +25,10 @@ Regions may optionally support capturing a snapshot on demand via the
 allow requested snapshots must implement the ``.snapshot`` callback for the
 region in its ``devlink_region_ops`` structure.
 
+Regions may optionally allow directly reading from their contents without a
+snapshot. A driver wishing to enable this for a region should implement the
+``.read`` callback in the ``devlink_region_ops`` structure.
+
 example usage
 -------------
 
@@ -60,6 +64,10 @@ example usage
             length 16
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
 
+    # Read from the region without a snapshot
+    $ devlink region read pci/0000:00:05.0/fw-health address 16 length 16
+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
+
 As regions are likely very device or driver specific, no generic regions are
 defined. See the driver-specific documentation files for information on the
 specific regions a driver supports.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1c3540280396..47ce1b5481de 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -508,6 +508,10 @@ struct devlink_region_ops {
 			struct netlink_ext_ack *extack,
 			u8 **data,
 			devlink_snapshot_data_dest_t **destructor);
+	int (*read)(struct devlink *devlink,
+		    u64 curr_offset,
+		    u32 data_size,
+		    u8 *data);
 };
 
 struct devlink_fmsg;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b2b855d12a11..5831b7b78915 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4005,6 +4005,56 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 	return err;
 }
 
+static int devlink_nl_region_read_direct_fill(struct sk_buff *skb,
+					      struct devlink *devlink,
+					      struct devlink_region *region,
+					      struct nlattr **attrs,
+					      u64 start_offset,
+					      u64 end_offset,
+					      bool dump,
+					      u64 *new_offset)
+{
+	u64 curr_offset = start_offset;
+	int err = 0;
+	u8 *data;
+
+	/* Allocate and re-use a single buffer */
+	data = kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	*new_offset = start_offset;
+
+	if (end_offset > region->size || dump)
+		end_offset = region->size;
+
+	while (curr_offset < end_offset) {
+		u32 data_size;
+
+		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
+			data_size = end_offset - curr_offset;
+		else
+			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
+
+		err = region->ops->read(devlink, curr_offset, data_size, data);
+		if (err)
+			break;
+
+		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
+							    data, data_size,
+							    curr_offset);
+		if (err)
+			break;
+
+		curr_offset += data_size;
+	}
+	*new_offset = curr_offset;
+
+	kfree(data);
+
+	return err;
+}
+
 static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
@@ -4016,6 +4066,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	const char *region_name;
 	struct devlink *devlink;
 	bool dump = true;
+	bool direct;
 	void *hdr;
 	int err;
 
@@ -4030,8 +4081,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	mutex_lock(&devlink->lock);
 
-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
 		err = -EINVAL;
 		goto out_unlock;
 	}
@@ -4043,6 +4093,17 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	if (attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID])
+		direct = false;
+	else
+		direct = true;
+
+	/* Region may not support direct read access */
+	if (direct && !region->ops->read) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
 			  DEVLINK_CMD_REGION_READ);
@@ -4076,11 +4137,18 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		dump = false;
 	}
 
-	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
-						   region, attrs,
-						   start_offset,
-						   end_offset, dump,
-						   &ret_offset);
+	if (direct)
+		err = devlink_nl_region_read_direct_fill(skb, devlink,
+							 region, attrs,
+							 start_offset,
+							 end_offset, dump,
+							 &ret_offset);
+	else
+		err = devlink_nl_region_read_snapshot_fill(skb, devlink,
+							   region, attrs,
+							   start_offset,
+							   end_offset, dump,
+							   &ret_offset);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
-- 
2.25.0.rc1

