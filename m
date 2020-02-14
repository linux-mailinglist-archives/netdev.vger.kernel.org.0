Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09D715FA59
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBNXWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:12667 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgBNXWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629342"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:29 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 1/2] devlink: add support for DEVLINK_CMD_REGION_NEW
Date:   Fri, 14 Feb 2020 15:22:22 -0800
Message-Id: <20200214232223.3442651-24-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to request that a new snapshot be taken immediately for
a devlink region. Optionally allow specifying the snapshot id to use. If
no snapshot id is provided, the kernel will select a suitable id
automatically.

If the region does not support snapshots on demand, the command will
return an error indicating the operation is not supported.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f9e58c1d7394..71c300ba16ed 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6347,10 +6347,27 @@ static int cmd_region_read(struct dl *dl)
 	return err;
 }
 
+static int cmd_region_snapshot_new(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
+			NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION,
+				DL_OPT_REGION_SNAPSHOT_ID);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
 static void cmd_region_help(void)
 {
 	pr_err("Usage: devlink region show [ DEV/REGION ]\n");
 	pr_err("       devlink region del DEV/REGION snapshot SNAPSHOT_ID\n");
+	pr_err("       devlink region new DEV/REGION [snapshot SNAPSHOT_ID]\n");
 	pr_err("       devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]\n");
 	pr_err("       devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ] address ADDRESS length LENGTH\n");
 }
@@ -6374,6 +6391,9 @@ static int cmd_region(struct dl *dl)
 	} else if (dl_argv_match(dl, "read")) {
 		dl_arg_inc(dl);
 		return cmd_region_read(dl);
+	} else if (dl_argv_match(dl, "new")) {
+		dl_arg_inc(dl);
+		return cmd_region_snapshot_new(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.25.0.368.g28a2d05eebfb

