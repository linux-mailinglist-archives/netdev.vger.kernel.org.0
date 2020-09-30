Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEBF27F3E2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgI3VGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:06:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:51847 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3VGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:06:45 -0400
IronPort-SDR: LzWaHgPldz8fIo3hv9DjUTOF/gPxZAHTMG96oIevejd4cOr6nZyTE1FSnF+GPhV0JCkDCcm6Up
 vdV9fILfBf/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="161782250"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="161782250"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:06:41 -0700
IronPort-SDR: PZeUuHSfYU7aKjdxeTDW/dBETTlFqm0lzjzJNgkfb3+2blMdXMioD+hl8ZFlEnOmi9th0avnX3
 7G/gVYlobGcg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="294156081"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:06:40 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v2] devlink: support setting the overwrite mask attribute
Date:   Wed, 30 Sep 2020 14:05:47 -0700
Message-Id: <20200930210547.3598309-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recently added DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK allows
userspace to indicate how a device should handle subsections of a flash
component when updating. For example, a flash component might contain
vital data such as PCIe serial number or configuration fields such as
settings that control device bootup.

The overwrite mask allows specifying whether the device should overwrite
these subsections when updating from the provided image. If nothing is
specified, then the update is expected to preserve all vital fields and
configuration.

Add support for specifying the overwrite mask using the new "overwrite"
option to the flash command line.

By specifying "overwrite identifiers", the user request that the flash
update should overwrite any settings in the updated flash component with
settings from the provided flash image

  $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite identifiers

By specifying "overwrite settings" the user requests that the flash update
should overwrite any settings in the updated flash component with setting
values from the provided flash image.

  $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings

These options may be combined, in which case both subsections will be sent
in the overwrite mask, resulting in a request to overwrite all settings and
identifiers stored in the updated flash components.

  $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings overwrite identifiers

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 48 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0374175eda3d..5cf2cd194788 100644
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
@@ -1285,6 +1287,19 @@ eswitch_encap_mode_get(const char *typestr,
 	return 0;
 }
 
+static int flash_overwrite_section_get(const char *sectionstr, uint32_t *mask)
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
@@ -1627,6 +1642,21 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
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
+			err = flash_overwrite_section_get(sectionstr,
+							  &opts->overwrite_mask);
+			if (err)
+				return err;
+			o_found |= DL_OPT_FLASH_OVERWRITE;
+
 		} else if (dl_argv_match(dl, "reporter") &&
 			   (o_all & DL_OPT_HEALTH_REPORTER_NAME)) {
 			dl_arg_inc(dl);
@@ -1767,6 +1797,18 @@ dl_function_attr_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 	mnl_attr_nest_end(nlh, nest);
 }
 
+static void
+dl_flash_update_overwrite_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
+{
+	struct nla_bitfield32 overwrite_mask;
+
+	overwrite_mask.selector = DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS;
+	overwrite_mask.value = opts->overwrite_mask;
+
+	mnl_attr_put(nlh, DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,
+		     sizeof(overwrite_mask), &overwrite_mask);
+}
+
 static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -1854,6 +1896,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_FLASH_COMPONENT)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
 				  opts->flash_component);
+	if (opts->present & DL_OPT_FLASH_OVERWRITE)
+		dl_flash_update_overwrite_put(nlh, opts);
 	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
 				  opts->reporter_name);
@@ -1954,7 +1998,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
-	pr_err("       devlink dev flash DEV file PATH [ component NAME ]\n");
+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3219,7 +3263,7 @@ static int cmd_dev_flash(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-				DL_OPT_FLASH_COMPONENT);
+				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
 	if (err)
 		return err;
 

base-commit: d2be31d9b671ec0b3e32f56f9c913e249ed048bd
-- 
2.28.0.497.g54e85e7af1ac

