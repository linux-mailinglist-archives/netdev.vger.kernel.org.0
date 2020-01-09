Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7811E13611F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgAITdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:33:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:37095 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730488AbgAITdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:33:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223970934"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 11:33:14 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 1/1] devlink: add support for DEVLINK_CMD_REGION_TRIGGER
Date:   Thu,  9 Jan 2020 11:33:09 -0800
Message-Id: <20200109193311.1352330-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the devlink command to trigger a snapshot if the region
supports it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c            | 20 ++++++++++++++++++++
 include/uapi/linux/devlink.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 95f05a0b..3a473531 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -4200,6 +4200,7 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_REGION_SET:
 	case DEVLINK_CMD_REGION_NEW:
 	case DEVLINK_CMD_REGION_DEL:
+	case DEVLINK_CMD_REGION_TRIGGER:
 		return "region";
 	case DEVLINK_CMD_FLASH_UPDATE:
 	case DEVLINK_CMD_FLASH_UPDATE_END:
@@ -6362,12 +6363,28 @@ static int cmd_region_read(struct dl *dl)
 	return err;
 }
 
+static int cmd_region_trigger(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_TRIGGER,
+			NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE_REGION, 0);
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
 	pr_err("       devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]\n");
 	pr_err("       devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ] address ADDRESS length LENGTH\n");
+	pr_err("       devlink region trigger DEV/REGION\n");
 }
 
 static int cmd_region(struct dl *dl)
@@ -6389,6 +6406,9 @@ static int cmd_region(struct dl *dl)
 	} else if (dl_argv_match(dl, "read")) {
 		dl_arg_inc(dl);
 		return cmd_region_read(dl);
+	} else if (dl_argv_match(dl, "trigger")) {
+		dl_arg_inc(dl);
+		return cmd_region_trigger(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3f82dedd..37348f84 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -117,6 +117,8 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_GROUP_NEW,
 	DEVLINK_CMD_TRAP_GROUP_DEL,
 
+	DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
-- 
2.21.0

