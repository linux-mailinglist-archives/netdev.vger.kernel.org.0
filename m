Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E5615FA61
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgBNXW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:12666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgBNXWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629325"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:28 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 18/22] devlink: report extended error message in region_read_dumpit
Date:   Fri, 14 Feb 2020 15:22:17 -0800
Message-Id: <20200214232223.3442651-19-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report extended error details in the devlink_nl_cmd_region_read_dumpit
function, by using the extack structure from the netlink_callback.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 60f4d231470e..e81b56f83128 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4199,8 +4199,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	mutex_lock(&devlink->lock);
 
-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
+		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
+		NL_SET_ERR_MSG_MOD(cb->extack, "No snapshot id provided");
 		err = -EINVAL;
 		goto out_unlock;
 	}
@@ -4208,6 +4214,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	region_name = nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
 	region = devlink_region_get_by_name(devlink, region_name);
 	if (!region) {
+		NL_SET_ERR_MSG_MOD(cb->extack,
+				   "The requested region does not exist");
 		err = -EINVAL;
 		goto out_unlock;
 	}
@@ -4221,6 +4229,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
 	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
 	if (!snapshot) {
+		NL_SET_ERR_MSG_MOD(cb->extack,
+				   "The requested snapshot id does not exist");
 		err = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.25.0.368.g28a2d05eebfb

