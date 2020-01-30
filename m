Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D58814E5D4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgA3W7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:51510 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbgA3W7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187769"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:20 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 03/15] devlink: add operation to take an immediate snapshot
Date:   Thu, 30 Jan 2020 14:58:58 -0800
Message-Id: <20200130225913.1671982-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
command is intended to enable userspace to request an immediate snapshot
of a region.

Regions can enable support for requestable snapshots by implementing the
snapshot callback function in the region's devlink_region_ops structure.

Implementations of this function callback should capture an immediate
copy of the data and return it and its destructor in the function
parameters. The core devlink code will generate a snapshot ID and create
the new snapshot while holding the devlink instance lock.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-region.rst     |  9 +++-
 include/net/devlink.h                         |  7 +++
 include/uapi/linux/devlink.h                  |  2 +
 net/core/devlink.c                            | 46 +++++++++++++++++++
 4 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 1a7683e7acb2..262249e6c3fc 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
 Regions may also be used to provide an additional way to debug complex error
 states, but see also :doc:`devlink-health`
 
+Regions may optionally support capturing a snapshot on demand via the
+``DEVLINK_CMD_REGION_TAKE_SNAPSHOT`` netlink message. A driver wishing to
+allow requested snapshots must implement the ``.snapshot`` callback for the
+region in its ``devlink_region_ops`` structure.
+
 example usage
 -------------
 
@@ -40,8 +45,8 @@ example usage
     # Delete a snapshot using:
     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
 
-    # Trigger (request) a snapshot be taken:
-    $ devlink region trigger pci/0000:00:05.0/cr-space
+    # Request an immediate snapshot, if supported by the region
+    $ devlink region snapshot pci/0000:00:05.0/cr-space
 
     # Dump a snapshot:
     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4a0baa6903cb..63e954241404 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -498,9 +498,16 @@ typedef void devlink_snapshot_data_dest_t(const void *data);
 /**
  * struct devlink_region_ops - Region operations
  * @name: region name
+ * @snapshot: callback to request an immediate snapshot. On success,
+ *            the data and destructor variables must be updated. The function
+ *            will be called while the devlink instance lock is held.
  */
 struct devlink_region_ops {
 	const char *name;
+	int (*snapshot)(struct devlink *devlink,
+			struct netlink_ext_ack *extack,
+			u8 **data,
+			devlink_snapshot_data_dest_t **destructor);
 };
 
 struct devlink_fmsg;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ae37fd4d194a..46643c4320b9 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -117,6 +117,8 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_GROUP_NEW,
 	DEVLINK_CMD_TRAP_GROUP_DEL,
 
+	DEVLINK_CMD_REGION_TAKE_SNAPSHOT,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index faf4f4c5c539..574008c536fa 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4109,6 +4109,45 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
+static int devlink_nl_cmd_region_take_snapshot(struct sk_buff *skb,
+					       struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	devlink_snapshot_data_dest_t *destructor;
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
+	err = region->ops->snapshot(devlink, info->extack, &data, &destructor);
+	if (err)
+		return err;
+
+	snapshot_id = devlink_region_snapshot_id_get_locked(devlink);
+	return devlink_region_snapshot_create_locked(region, data, snapshot_id,
+						     destructor);
+}
+
 struct devlink_info_req {
 	struct sk_buff *msg;
 };
@@ -6249,6 +6288,13 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
+	{
+		.cmd = DEVLINK_CMD_REGION_TAKE_SNAPSHOT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_region_take_snapshot,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+	},
 	{
 		.cmd = DEVLINK_CMD_INFO_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.25.0.rc1

