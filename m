Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117721BC67E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgD1RVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:21:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:37818 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgD1RVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:21:20 -0400
IronPort-SDR: 87K6qj+zmhT23KFc+KTQh1j3F5oTwby8Q5PsIyZU/5RnbL+/t9SgzuH/9SmhHub4VxLswCTxU5
 SkNbvVufdMFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 10:21:20 -0700
IronPort-SDR: +xYf/hRBO92/33R15K5jZ6vcB5VbXnHXPr1cj1nXcJ0A+EbyjtLS2EDX3gz4bQ76/o3D08vpW3
 JT5fKpBVMU4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="292922728"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga002.fm.intel.com with ESMTP; 28 Apr 2020 10:21:19 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2 v2] devlink: add support for DEVLINK_CMD_REGION_NEW
Date:   Tue, 28 Apr 2020 10:20:57 -0700
Message-Id: <20200428172057.1109672-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to request that a new snapshot be taken immediately for
a devlink region. To avoid confusion, the desired snapshot id must be
provided.

Note that if a region does not support snapshots on demand, the kernel
will reject the request with -EOPNOTSUP.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 67e6e64181f9..dbde79f52791 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6362,10 +6362,27 @@ static int cmd_region_read(struct dl *dl)
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
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION |
+				DL_OPT_REGION_SNAPSHOT_ID, 0);
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
+	pr_err("       devlink region new DEV/REGION snapshot SNAPSHOT_ID\n");
 	pr_err("       devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]\n");
 	pr_err("       devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ] address ADDRESS length LENGTH\n");
 }
@@ -6389,6 +6406,9 @@ static int cmd_region(struct dl *dl)
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
2.25.2

