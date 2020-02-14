Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E95815FA5E
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgBNXWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:12666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629335"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:29 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 21/22] devlink: support directly reading from region memory
Date:   Fri, 14 Feb 2020 15:22:20 -0800
Message-Id: <20200214232223.3442651-22-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
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
 .../networking/devlink/devlink-region.rst     |  8 +++
 include/net/devlink.h                         |  6 ++
 net/core/devlink.c                            | 59 +++++++++++++------
 3 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index a24faf2b6b7a..aeb4e6a5051b 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -25,6 +25,10 @@ Regions may optionally support capturing a snapshot on demand via the
 requested snapshots must implement the ``.snapshot`` callback for the region
 in its ``devlink_region_ops`` structure.
 
+Regions may optionally allow directly reading from their contents without a
+snapshot. A driver wishing to enable this for a region should implement the
+``.read`` callback in the ``devlink_region_ops`` structure.
+
 example usage
 -------------
 
@@ -63,6 +67,10 @@ example usage
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
index 3cd0ff2040b2..3f00e0890d92 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -502,12 +502,18 @@ struct devlink_info_req;
  *            the data variable must be updated to point to the snapshot data.
  *            The function will be called while the devlink instance lock is
  *            held.
+ * @read: callback to directly read a portion of the region. On success,
+ *            the data pointer will be updated with the contents of the
+ *            requested portion of the region. The function will be called
+ *            while the devlink instance lock is held.
  */
 struct devlink_region_ops {
 	const char *name;
 	void (*destructor)(const void *data);
 	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
 			u8 **data);
+	int (*read)(struct devlink *devlink, struct netlink_ext_ack *extack,
+		    u64 curr_offset, u32 data_size, u8 *data);
 };
 
 struct devlink_fmsg;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c200701e1839..86fa9d53157e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4195,18 +4195,30 @@ devlink_region_snapshot_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
 	return 0;
 }
 
+static int
+devlink_region_direct_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
+			   u64 curr_offset, struct netlink_ext_ack *extack)
+{
+	struct devlink_region *region = cb_priv;
+	struct devlink *devlink = region->devlink;
+
+	return region->ops->read(devlink, extack, curr_offset, chunk_size,
+				 chunk);
+}
+
 static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	u64 ret_offset, start_offset, end_offset = 0;
 	struct nlattr **attrs = info->attrs;
-	struct devlink_snapshot *snapshot;
+	devlink_chunk_fill_t *region_cb;
 	struct devlink_region *region;
 	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
-	u32 snapshot_id;
+	void *region_cb_priv;
+	bool direct;
 	void *hdr;
 	int err;
 
@@ -4227,12 +4239,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
-	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
-		NL_SET_ERR_MSG_MOD(cb->extack, "No snapshot id provided");
-		err = -EINVAL;
-		goto out_unlock;
-	}
-
 	region_name = nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
 	region = devlink_region_get_by_name(devlink, region_name);
 	if (!region) {
@@ -4248,13 +4254,30 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
-	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
-	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
-	if (!snapshot) {
-		NL_SET_ERR_MSG_MOD(cb->extack,
-				   "The requested snapshot id does not exist");
-		err = -EINVAL;
-		goto out_unlock;
+	direct = !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
+
+	if (direct) {
+		if (!region->ops->read) {
+			NL_SET_ERR_MSG_MOD(cb->extack,
+					   "The requested region does not support direct read");
+			err = -EOPNOTSUPP;
+			goto out_unlock;
+		}
+		region_cb = &devlink_region_direct_fill;
+		region_cb_priv = region;
+	} else {
+		u32 snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
+		struct devlink_snapshot *snapshot;
+
+		snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
+		if (!snapshot) {
+			NL_SET_ERR_MSG_MOD(cb->extack,
+					   "The requested snapshot id does not exist");
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		region_cb = &devlink_region_snapshot_fill;
+		region_cb_priv = snapshot;
 	}
 
 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
@@ -4294,9 +4317,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		end_offset = region->size;
 	}
 
-	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
-					  snapshot, start_offset, end_offset,
-					  &ret_offset, cb->extack);
+	err = devlink_nl_region_read_fill(skb, region_cb, region_cb_priv,
+					  start_offset, end_offset, &ret_offset,
+					  cb->extack);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
-- 
2.25.0.368.g28a2d05eebfb

