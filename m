Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DE14E5C8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgA3W7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:34 -0500
Received: from mga12.intel.com ([192.55.52.136]:51510 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727672AbgA3W70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187843"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:25 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH 3/3] devlink: stop requiring snapshot for regions
Date:   Thu, 30 Jan 2020 14:59:13 -0800
Message-Id: <20200130225913.1671982-19-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
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
index ac1ad8aa0769..9f9e8ea09bf5 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6311,8 +6311,8 @@ static int cmd_region_dump(struct dl *dl)
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_READ,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
+				DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
@@ -6333,8 +6333,8 @@ static int cmd_region_read(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
-				DL_OPT_REGION_ADDRESS | DL_OPT_REGION_LENGTH |
-				DL_OPT_REGION_SNAPSHOT_ID, 0);
+				DL_OPT_REGION_ADDRESS | DL_OPT_REGION_LENGTH,
+				DL_OPT_REGION_SNAPSHOT_ID);
 	if (err)
 		return err;
 
-- 
2.25.0.rc1

