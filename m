Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E794919372E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCZDwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:29079 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbgCZDwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:16 -0400
IronPort-SDR: IQNahPEcruiR8lZiUBq8wA0W1C5yA2Waoa5pTtOBOQh49cNj0nzSIVyTbQqTDqFuVbEvMQeKN3
 lsOjIAyzJzFg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:15 -0700
IronPort-SDR: qFuB22mdnHe+sW0ggBFJMJlPfoGXFY9I4e77jdL6ICXqjfjqY/nfeDhQfLrd2Al/MBisvChdhh
 MflhBvIR3YEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028122"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:14 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v2 09/11] devlink: implement DEVLINK_CMD_REGION_NEW
Date:   Wed, 25 Mar 2020 20:51:55 -0700
Message-Id: <20200326035157.2211090-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
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

The desired snapshot id must be provided. This helps avoid confusion on
the purpose of DEVLINK_CMD_REGION_NEW, and keeps the API simpler.

The requested id will be inserted into the xarray tracking the number of
snapshots using each id. If this id is already used by another snapshot
on any region, an error will be returned.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-region.rst     |   8 ++
 include/net/devlink.h                         |   6 ++
 net/core/devlink.c                            | 100 ++++++++++++++++++
 3 files changed, 114 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 8b46e8591fe0..9d2d4c95a5c4 100644
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
 
@@ -40,6 +45,9 @@ example usage
     # Delete a snapshot using:
     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
 
+    # Request an immediate snapshot, if supported by the region
+    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
+
     # Dump a snapshot:
     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
diff --git a/include/net/devlink.h b/include/net/devlink.h
index fb9154060e6e..a1a02cd5890b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -501,10 +501,16 @@ struct devlink_info_req;
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
index d89eaac0a101..a0960ba139ec 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3845,6 +3845,33 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	}
 }
 
+/**
+ *	__devlink_snapshot_id_insert - Insert a specific snapshot ID
+ *	@devlink: devlink instance
+ *	@id: the snapshot id
+ *
+ *	Mark the given snapshot id as used by inserting a zero value into the
+ *	snapshot xarray.
+ *
+ *	This must be called while holding the devlink instance lock. Unlike
+ *	devlink_snapshot_id_get, the initial reference count is zero, not one.
+ *	It is expected that the id will immediately be used before
+ *	releasing the devlink instance lock.
+ *
+ *	Returns zero on success, or an error code if the snapshot id could not
+ *	be inserted.
+ */
+static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	if (WARN_ON(xa_load(&devlink->snapshot_ids, id)))
+		return -EEXIST;
+
+	return xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
+			       GFP_KERNEL));
+}
+
 /**
  *	__devlink_region_snapshot_id_get - get snapshot ID
  *	@devlink: devlink instance
@@ -4038,6 +4065,72 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
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
+	if (!info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+		NL_SET_ERR_MSG_MOD(info->extack, "No snapshot id provided");
+		return -EINVAL;
+	}
+
+	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
+	region = devlink_region_get_by_name(devlink, region_name);
+	if (!region) {
+		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not exist");
+		return -EINVAL;
+	}
+
+	if (!region->ops->snapshot) {
+		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not support taking an immediate snapshot");
+		return -EOPNOTSUPP;
+	}
+
+	if (region->cur_snapshots == region->max_snapshots) {
+		NL_SET_ERR_MSG_MOD(info->extack, "The region has reached the maximum number of stored snapshots");
+		return -ENOSPC;
+	}
+
+	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
+
+	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
+		return -EEXIST;
+	}
+
+	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
+	if (err) {
+		return err;
+	}
+
+	err = region->ops->snapshot(devlink, info->extack, &data);
+	if (err)
+		goto snapshot_capture_failure;
+
+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
+	if (err)
+		goto snapshot_create_failure;
+
+	return 0;
+
+snapshot_create_failure:
+	region->ops->destructor(data);
+snapshot_capture_failure:
+	__devlink_snapshot_id_decrement(devlink, snapshot_id);
+	return err;
+}
+
 static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 						 struct devlink *devlink,
 						 u8 *chunk, u32 chunk_size,
@@ -6445,6 +6538,13 @@ static const struct genl_ops devlink_nl_ops[] = {
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
2.24.1

