Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AF0234EE8
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgHAAWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:22:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:49844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgHAAWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 20:22:16 -0400
IronPort-SDR: EUfrgPndMlNMMS1Q40PcXMhMHkWOszRuwJmJTlk2EUUDEi6QLLCSs8wfAG1mKk4fwuSwkwSf4d
 yUXoRe6KeU+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="153106659"
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="153106659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 17:22:14 -0700
IronPort-SDR: NMp9qbO0P1XN/LrfffaXOeT+RUIayuPI8UUVOOH58EXlO8LmPM+dPhe6iLctXE6qhW5hTY1oc3
 jF3FEY3SqPRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="435594775"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2020 17:22:14 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v2 5/5] devlink: support setting the overwrite mask
Date:   Fri, 31 Jul 2020 17:21:59 -0700
Message-Id: <20200801002159.3300425-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b60
In-Reply-To: <20200801002159.3300425-1-jacob.e.keller@intel.com>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for specifying the overwrite sections to allow in the flash
update command. This is done by adding a new "overwrite" option which
can take either "settings" or "identifiers" passing the overwrite mode
multiple times will combine the fields using bitwise-OR.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 7dbe9c7e07a8..a3360a09898b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -302,6 +302,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_POLICER_BURST	BIT(36)
 #define DL_OPT_HEALTH_REPORTER_AUTO_DUMP     BIT(37)
 #define DL_OPT_PORT_FUNCTION_HW_ADDR BIT(38)
+#define DL_OPT_FLASH_OVERWRITE		BIT(39)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -349,6 +350,7 @@ struct dl_opts {
 	uint64_t trap_policer_burst;
 	char port_function_hw_addr[MAX_ADDR_LEN];
 	uint32_t port_function_hw_addr_len;
+	uint32_t overwrite_mask;
 };
 
 struct dl {
@@ -1282,6 +1284,19 @@ eswitch_encap_mode_get(const char *typestr,
 	return 0;
 }
 
+static int flash_overwrite_mask_get(const char *sectionstr, uint32_t *mask)
+{
+	if (strcmp(sectionstr, "settings") == 0) {
+		*mask |= DEVLINK_FLASH_OVERWRITE_SETTINGS;
+	} else if (strcmp(sectionstr, "identifiers") == 0) {
+		*mask |= DEVLINK_FLASH_OVERWRITE_IDENTIFIERS;
+	} else {
+		pr_err("Unknown overwrite section \"%s\"\n", sectionstr);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int param_cmode_get(const char *cmodestr,
 			   enum devlink_param_cmode *cmode)
 {
@@ -1624,6 +1639,21 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_FLASH_COMPONENT;
+
+		} else if (dl_argv_match(dl, "overwrite") &&
+				(o_all & DL_OPT_FLASH_OVERWRITE)) {
+			const char *sectionstr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &sectionstr);
+			if(err)
+				return err;
+			err = flash_overwrite_mask_get(sectionstr,
+							&opts->overwrite_mask);
+			if (err)
+				return err;
+			o_found |= DL_OPT_FLASH_OVERWRITE;
+
 		} else if (dl_argv_match(dl, "reporter") &&
 			   (o_all & DL_OPT_HEALTH_REPORTER_NAME)) {
 			dl_arg_inc(dl);
@@ -1851,6 +1881,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_FLASH_COMPONENT)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
 				  opts->flash_component);
+	if (opts->present & DL_OPT_FLASH_OVERWRITE)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,
+				 opts->overwrite_mask);
 	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
 				  opts->reporter_name);
@@ -1951,7 +1984,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
-	pr_err("       devlink dev flash DEV file PATH [ component NAME ]\n");
+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3205,7 +3238,7 @@ static int cmd_dev_flash(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-				DL_OPT_FLASH_COMPONENT);
+				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
 	if (err)
 		return err;
 
-- 
2.28.0.163.g6104cc2f0b60

