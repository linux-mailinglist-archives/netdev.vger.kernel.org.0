Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B42915FA58
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgBNXWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:12666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629347"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:29 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 2/2] devlink: stop requiring snapshot for regions
Date:   Fri, 14 Feb 2020 15:22:23 -0800
Message-Id: <20200214232223.3442651-25-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The region dump and region read commands currently require the snapshot
to work. Recent changes to the kernel have enabled optionally
supporting direct read of a region's contents without a snapshot id.

Enable this by allowing the read and dump commands to execute without
a snapshot id. On older kernels, this will return -EINVAL as the kernel
will reject such a command. On newer kernels, this will directly read
the region contents without taking a snapshot. If a region does not
support direct read, it will return -EOPNOTSUPP.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 71c300ba16ed..f98f2dc034ea 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6312,8 +6312,8 @@ static int cmd_region_dump(struct dl *dl)
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
+				DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
@@ -6334,8 +6334,8 @@ static int cmd_region_read(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_ADDRESS | DL_OPT_REGION_LENGTH |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
+				DL_OPT_REGION_ADDRESS | DL_OPT_REGION_LENGTH,
+				DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
-- 
2.25.0.368.g28a2d05eebfb

