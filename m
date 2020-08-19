Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E592491D1
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHSA25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:28:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:48102 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgHSA2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:28:55 -0400
IronPort-SDR: jAUTr/8eRJ4VWkrBZplyD+CorPMIYkSV4wpamSMxxf0MSlZvdzoRX8EtwmLiWpLoJqYWeTgVzQ
 gR8pBVIBTbsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239856135"
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="239856135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 17:28:39 -0700
IronPort-SDR: 4ALApbepyX5CnbBTJA0wvxRbkgsw/Yr8VqovZ8TNdULkeD4hiLKO9ZP79/gRGKfnhx79p7zyXr
 iiD9xfx657ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,329,1592895600"; 
   d="scan'208";a="320283592"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2020 17:28:39 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v3 2/2] devlink: support setting the overwrite mask
Date:   Tue, 18 Aug 2020 17:28:21 -0700
Message-Id: <20200819002821.2657515-8-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
In-Reply-To: <20200819002821.2657515-1-jacob.e.keller@intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
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
 devlink/devlink.c | 48 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8ec96c01fbcf..1dc9096781f7 100644
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
 
-- 
2.28.0.218.ge27853923b9d.dirty

