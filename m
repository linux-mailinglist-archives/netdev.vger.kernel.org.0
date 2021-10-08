Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C8426820
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbhJHKqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:46:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:43463 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhJHKqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 06:46:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="287363225"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="287363225"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:44:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="713691764"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.138])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:44:07 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iproute2-next] devlink: add dry run attribute support to devlink flash
Date:   Fri,  8 Oct 2021 03:43:22 -0700
Message-Id: <20211008104322.1328193-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
This requires updated kernel headers which have the DEVLINK_ATTR_DRY_RUN.


 devlink/devlink.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 07c4e08ab9d8..54ab5855c466 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
+#define DL_OPT_DRY_RUN			BIT(52)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -692,6 +693,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_DRY_RUN] = MNL_TYPE_FLAG,
 };
 
 static const enum mnl_attr_data_type
@@ -2063,6 +2065,10 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			dl_arg_inc(dl);
 			opts->rate_parent_node = "";
 			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
+		} else if (dl_argv_match(dl, "dry_run") &&
+			   (o_all & DL_OPT_DRY_RUN)) {
+			dl_arg_inc(dl);
+			o_found |= DL_OPT_DRY_RUN;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2141,6 +2147,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
 				  opts->rate_node_name);
 	}
+	if (opts->present & DL_OPT_DRY_RUN)
+		mnl_attr_put(nlh, DEVLINK_ATTR_DRY_RUN, 0, NULL);
 	if (opts->present & DL_OPT_PORT_TYPE)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
 				 opts->port_type);
@@ -3893,7 +3901,8 @@ static int cmd_dev_flash(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
+				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE |
+				DL_OPT_DRY_RUN);
 	if (err)
 		return err;
 

base-commit: b840c620fe818a313f09891cd2ede492e928e8d4
prerequisite-patch-id: 9f39ea2aae6d14f30d67aa30209939e7afb3dc87
-- 
2.31.1

