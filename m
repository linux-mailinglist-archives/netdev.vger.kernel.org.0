Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D6C136120
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgAITdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:33:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:37095 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgAITdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:33:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223970938"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 11:33:14 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 2/3] devlink: introduce command to trigger region snapshot
Date:   Thu,  9 Jan 2020 11:33:10 -0800
Message-Id: <20200109193311.1352330-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink regions exist as a mechanism for drivers to export addressable
regions of data to userspace. An astute reviewer might notice that the
devlink-health interface is similar and could be used for such
a purpose. However, the health API is intended for reporting and
recovering from error conditions.

If a driver wants to export a set of data that is not an error
condition, it does not make much sense to use the health APIs. For
example, a driver might expose some portion of the flash memory contents
of the device as a region that could then be dumped. In this case, the
only time it makes sense to capture the region is upon request.

The health API makes more sense for cases where the driver detects error
conditions and triggers dumping and recovery mechanisms automatically.

Add a new command, DEVLINK_CMD_REGION_TRIGGER, which enables userspace
to request a snapshot of a region. A future commit will modify the
netdevsim driver as an example of how this is implemented.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ae37fd4d194a..a5f54953e7b2 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -117,6 +117,8 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_GROUP_NEW,
 	DEVLINK_CMD_TRAP_GROUP_DEL,
 
+	DEVLINK_CMD_REGION_TRIGGER,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e54600afdaf0..3b5151a9b7db 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4053,6 +4053,32 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
+static int devlink_nl_cmd_region_trigger_snapshot(struct sk_buff *skb,
+						  struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_region *region;
+	const char *region_name;
+	struct sk_buff *msg;
+	u32 snapshot_id;
+	int err;
+
+	if (!info->attrs[DEVLINK_ATTR_REGION_NAME])
+		return -EINVAL;
+
+	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
+	region = devlink_region_get_by_name(devlink, region_name);
+	if (!region)
+		return -EINVAL;
+
+	if (!region->trigger_snapshot) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Triggering snapshots for the requested region is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	return region->trigger_snapshot(devlink, region, info->extack);
+}
+
 struct devlink_info_req {
 	struct sk_buff *msg;
 };
@@ -6159,6 +6185,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
+	{
+		.cmd = DEVLINK_CMD_REGION_TRIGGER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_region_trigger_snapshot,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+				  DEVLINK_NL_FLAG_NO_LOCK,
+	},
 	{
 		.cmd = DEVLINK_CMD_INFO_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.25.0.rc1

