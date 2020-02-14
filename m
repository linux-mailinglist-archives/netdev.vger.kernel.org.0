Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC7E15FA62
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgBNXXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:23:02 -0500
Received: from mga12.intel.com ([192.55.52.136]:61914 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgBNXW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629310"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:27 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Date:   Fri, 14 Feb 2020 15:22:13 -0800
Message-Id: <20200214232223.3442651-15-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for the DEVLINK_CMD_REGION_NEW command for creating
snapshots. This new command parallels the existing
DEVLINK_CMD_REGION_DEL.

In order for DEVLINK_CMD_REGION_NEW to work for a region, the new
".snapshot" operation must be implemented in the region's ops structure.

The desired snapshot id may be provided. If the requested id is already
in use, an error will be reported. If no id is provided one will be
selected in the same way as a triggered snapshot.

In either case, the reference count for that id will be incremented
in the snapshot IDR.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-region.rst     | 12 +++-
 include/net/devlink.h                         |  6 ++
 net/core/devlink.c                            | 72 +++++++++++++++++++
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 1a7683e7acb2..a24faf2b6b7a 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
 Regions may also be used to provide an additional way to debug complex error
 states, but see also :doc:`devlink-health`
 
+Regions may optionally support capturing a snapshot on demand via the
+``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
+requested snapshots must implement the ``.snapshot`` callback for the region
+in its ``devlink_region_ops`` structure.
+
 example usage
 -------------
 
@@ -40,8 +45,11 @@ example usage
     # Delete a snapshot using:
     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
 
-    # Trigger (request) a snapshot be taken:
-    $ devlink region trigger pci/0000:00:05.0/cr-space
+    # Request an immediate snapshot, if supported by the region
+    $ devlink region new pci/0000:00:05.0/cr-space
+
+    # Request an immediate snapshot with a specific id
+    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
 
     # Dump a snapshot:
     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3a5ff6bea143..3cd0ff2040b2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -498,10 +498,16 @@ struct devlink_info_req;
  * struct devlink_region_ops - Region operations
  * @name: region name
  * @destructor: callback used to free snapshot memory when deleting
+ * @snapshot: callback to request an immediate snapshot. On success,
+ *            the data variable must be updated to point to the snapshot data.
+ *            The function will be called while the devlink instance lock is
+ *            held.
  */
 struct devlink_region_ops {
 	const char *name;
 	void (*destructor)(const void *data);
+	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
+			u8 **data);
 };
 
 struct devlink_fmsg;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9571063846cc..b5d1b21e5178 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4045,6 +4045,71 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	return 0;
 }
 
+static int
+devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_region *region;
+	const char *region_name;
+	u32 snapshot_id;
+	u8 *data;
+	int err;
+
+	if (!info->attrs[DEVLINK_ATTR_REGION_NAME]) {
+		NL_SET_ERR_MSG_MOD(info->extack, "No region name provided");
+		return -EINVAL;
+	}
+
+	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
+	region = devlink_region_get_by_name(devlink, region_name);
+	if (!region) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "The requested region does not exist");
+		return -EINVAL;
+	}
+
+	if (!region->ops->snapshot) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "The requested region does not support taking an immediate snapshot");
+		return -EOPNOTSUPP;
+	}
+
+	if (region->cur_snapshots == region->max_snapshots) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "The region has reached the maximum number of stored snapshots");
+		return -ENOMEM;
+	}
+
+	if (info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+		/* __devlink_region_snapshot_create will take care of
+		 * inserting the snapshot id into the IDR if necessary.
+		 */
+		snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
+
+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "The requested snapshot id is already in use");
+			return -EEXIST;
+		}
+	} else {
+		snapshot_id = __devlink_region_snapshot_id_get(devlink);
+	}
+
+	err = region->ops->snapshot(devlink, info->extack, &data);
+	if (err)
+		return err;
+
+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
+	if (err)
+		goto err_free_snapshot_data;
+
+	return 0;
+
+err_free_snapshot_data:
+	region->ops->destructor(data);
+	return err;
+}
+
 static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 						 struct devlink *devlink,
 						 u8 *chunk, u32 chunk_size,
@@ -6358,6 +6423,13 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
+	{
+		.cmd = DEVLINK_CMD_REGION_NEW,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_region_new,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+	},
 	{
 		.cmd = DEVLINK_CMD_REGION_DEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.25.0.368.g28a2d05eebfb

