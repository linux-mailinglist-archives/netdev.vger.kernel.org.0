Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C942615FA63
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgBNXXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:23:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:12666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgBNXW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629321"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:28 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 17/22] devlink: use min_t to calculate data_size
Date:   Fri, 14 Feb 2020 15:22:16 -0800
Message-Id: <20200214232223.3442651-18-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calculation for the data_size in the devlink_nl_read_snapshot_fill
function uses an if statement that is better expressed using the min_t
macro.

Noticed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5bc0046f13f..60f4d231470e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4155,14 +4155,10 @@ devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 	*new_offset = start_offset;
 
 	while (curr_offset < end_offset) {
-		u32 data_size;
+		u32 data_size = min_t(u32, end_offset - curr_offset,
+				      DEVLINK_REGION_READ_CHUNK_SIZE);
 		u8 *data;
 
-		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
-			data_size = end_offset - curr_offset;
-		else
-			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
-
 		data = &snapshot->data[curr_offset];
 		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
 							    data, data_size,
-- 
2.25.0.368.g28a2d05eebfb

