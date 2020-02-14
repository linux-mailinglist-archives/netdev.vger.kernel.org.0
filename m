Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57B315FA57
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgBNXWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:12666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgBNXWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629317"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:28 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 16/22] devlink: simplify arguments for read_snapshot_fill
Date:   Fri, 14 Feb 2020 15:22:15 -0800
Message-Id: <20200214232223.3442651-17-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the devlink_nl_region_read_snapshot_fill function by looking up
the snapshot pointer ahead of time and passing that instead of the
region pointer.

Check for the snapshot existence within the region_read_dumpit function
and exit early if it does not exist.

This also enables removing additionally the dump parameter and the
netlink attrs parameter.

Simply calculate the proper end_offset ahead of time before calling the
read_snapshot_fill function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 47 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index b5d1b21e5178..e5bc0046f13f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4141,30 +4141,19 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 
 #define DEVLINK_REGION_READ_CHUNK_SIZE 256
 
-static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
-						struct devlink *devlink,
-						struct devlink_region *region,
-						struct nlattr **attrs,
-						u64 start_offset,
-						u64 end_offset,
-						bool dump,
-						u64 *new_offset)
+static int
+devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
+				     struct devlink *devlink,
+				     struct devlink_snapshot *snapshot,
+				     u64 start_offset,
+				     u64 end_offset,
+				     u64 *new_offset)
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
-	if (end_offset > region->size || dump)
-		end_offset = region->size;
-
 	while (curr_offset < end_offset) {
 		u32 data_size;
 		u8 *data;
@@ -4194,11 +4183,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	u64 ret_offset, start_offset, end_offset = 0;
 	struct nlattr **attrs = info->attrs;
+	struct devlink_snapshot *snapshot;
 	struct devlink_region *region;
 	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
-	bool dump = true;
+	u32 snapshot_id;
 	void *hdr;
 	int err;
 
@@ -4232,6 +4222,13 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
+	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
+	if (!snapshot) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
 			  DEVLINK_CMD_REGION_READ);
@@ -4262,13 +4259,15 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
 		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
-		dump = false;
+
+		if (end_offset > region->size)
+			end_offset = region->size;
+	} else {
+		end_offset = region->size;
 	}
 
-	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
-						   region, attrs,
-						   start_offset,
-						   end_offset, dump,
+	err = devlink_nl_region_read_snapshot_fill(skb, devlink, snapshot,
+						   start_offset, end_offset,
 						   &ret_offset);
 
 	if (err && err != -EMSGSIZE)
-- 
2.25.0.368.g28a2d05eebfb

