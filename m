Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91315FA60
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgBNXWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:12666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629328"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:28 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 19/22] devlink: remove unnecessary parameter from chunk_fill function
Date:   Fri, 14 Feb 2020 15:22:18 -0800
Message-Id: <20200214232223.3442651-20-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink parameter of the devlink_nl_cmd_region_read_chunk_fill
function is not used. Remove it, to simplify the function signature.

Once removed, it is also obvious that the devlink parameter is not
necessary for the devlink_nl_region_read_snapshot_fill either.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e81b56f83128..a722272f42b4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4111,7 +4111,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 }
 
 static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
-						 struct devlink *devlink,
 						 u8 *chunk, u32 chunk_size,
 						 u64 addr)
 {
@@ -4143,7 +4142,6 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 
 static int
 devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
-				     struct devlink *devlink,
 				     struct devlink_snapshot *snapshot,
 				     u64 start_offset,
 				     u64 end_offset,
@@ -4160,8 +4158,8 @@ devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 		u8 *data;
 
 		data = &snapshot->data[curr_offset];
-		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
-							    data, data_size,
+		err = devlink_nl_cmd_region_read_chunk_fill(skb, data,
+							    data_size,
 							    curr_offset);
 		if (err)
 			break;
@@ -4272,9 +4270,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		end_offset = region->size;
 	}
 
-	err = devlink_nl_region_read_snapshot_fill(skb, devlink, snapshot,
-						   start_offset, end_offset,
-						   &ret_offset);
+	err = devlink_nl_region_read_snapshot_fill(skb, snapshot, start_offset,
+						   end_offset, &ret_offset);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
-- 
2.25.0.368.g28a2d05eebfb

