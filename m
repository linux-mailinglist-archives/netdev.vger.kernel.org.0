Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF3358060E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbiGYU5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237213AbiGYU5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:57:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306CE237D3;
        Mon, 25 Jul 2022 13:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782621; x=1690318621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2wfPuB58UVORdxobP+NM5sdKPHrgFABFNUa10KcLh5Y=;
  b=UZt4WQzA+lUVXVuT0aZTxMI7gMdGi6M8aLyx0IU1dpxbLFsYbzG74m8A
   Ilj4Q6iXgoL9rkMcPWVn0oG1B/IqWHc9fZTGNSALmfxzTXD1kEsgRsX8Z
   fPr+nQcqWlyZorEMMRL6mypWaSNCXCDvlO2WkQZSu9+AlB6uGSgCCEoFk
   njW8CzOVRDmIH2qdPHzoUogom4E/tiYWlNFHgZ4XTsDhGilpa9mh/z6Q3
   DNhtmJO5hDxTGJQXAMgT8Ub6jrjIVJbxoo7HcNPsw8skj1lNUq4Mr7WYQ
   40EXq+Tf5a0evotYgaiJHeiRaTfQvkFKTkwTs3BqLOmqQmyQ1urxZuS+v
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="313548924"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="313548924"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="550135514"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:58 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org
Subject: [iproute2-next v3 3/3] devlink: add dry run attribute support to devlink flash
Date:   Mon, 25 Jul 2022 13:56:50 -0700
Message-Id: <20220725205650.4018731-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220725205650.4018731-1-jacob.e.keller@intel.com>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent versions of the kernel support the DEVLINK_ATTR_DRY_RUN attribute
which allows requesting a dry run of a command. A dry run is simply
a request to validate that a command would work, without performing any
destructive changes.

The attribute is supported by the devlink flash update as a way to
validate an update, including potentially the binary image, without
modifying the device.

Add a "dry_run" option to the command line parsing which will enable
this attribute when requested.

To avoid potential issues, only allow the attribute to be added to
commands when the kernel recognizes it. This is important because some
commands do not perform strict validation. If we were to add the
attribute without this check, an old kernel may silently accept the
command and perform an update even when dry_run was requested.

Before adding the attribute, check the maximum attribute from the
CTRL_CMD_GETFAMILY and make sure that the kernel recognizes the
DEVLINK_ATTR_DRY_RUN attribute.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v2
* Remove unnecessary () with return
* Reduce indentation of dl_get_max_attr

 devlink/devlink.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 1e2cfc3d4285..343ad98d9c7f 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -296,6 +296,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
 #define DL_OPT_LINECARD		BIT(52)
 #define DL_OPT_LINECARD_TYPE	BIT(53)
+#define DL_OPT_DRY_RUN			BIT(54)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -372,6 +373,8 @@ struct dl {
 	bool verbose;
 	bool stats;
 	bool hex;
+	bool max_attr_valid;
+	uint32_t max_attr;
 	struct {
 		bool present;
 		char *bus_name;
@@ -701,6 +704,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_STATE] = MNL_TYPE_U8,
 	[DEVLINK_ATTR_LINECARD_TYPE] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_DRY_RUN] = MNL_TYPE_FLAG,
 };
 
 static const enum mnl_attr_data_type
@@ -1522,6 +1526,31 @@ static int dl_args_finding_required_validate(uint64_t o_required,
 	return 0;
 }
 
+static void dl_get_max_attr(struct dl *dl)
+{
+	uint32_t max_attr;
+	int err;
+
+	if (dl->max_attr_valid)
+		return;
+
+	err = mnlg_socket_get_max_attr(&dl->nlg, &max_attr);
+	if (err) {
+		pr_err("Unable to determine maximum supported devlink attribute\n");
+		return;
+	}
+
+	dl->max_attr = max_attr;
+	dl->max_attr_valid = true;
+}
+
+static bool dl_kernel_supports_attr(struct dl *dl, enum devlink_attr attr)
+{
+	dl_get_max_attr(dl);
+
+	return dl->max_attr_valid && dl->max_attr >= attr;
+}
+
 static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			 uint64_t o_optional)
 {
@@ -2037,6 +2066,16 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			dl_arg_inc(dl);
 			opts->linecard_type = "";
 			o_found |= DL_OPT_LINECARD_TYPE;
+		} else if (dl_argv_match(dl, "dry_run") &&
+			   (o_all & DL_OPT_DRY_RUN)) {
+
+			if (!dl_kernel_supports_attr(dl, DEVLINK_ATTR_DRY_RUN)) {
+				pr_err("Kernel does not support dry_run attribute\n");
+				return -EOPNOTSUPP;
+			}
+
+			dl_arg_inc(dl);
+			o_found |= DL_OPT_DRY_RUN;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2115,6 +2154,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
 				  opts->rate_node_name);
 	}
+	if (opts->present & DL_OPT_DRY_RUN)
+		mnl_attr_put(nlh, DEVLINK_ATTR_DRY_RUN, 0, NULL);
 	if (opts->present & DL_OPT_PORT_TYPE)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
 				 opts->port_type);
@@ -2326,7 +2367,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
-	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ] [ dry_run ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3886,7 +3927,8 @@ static int cmd_dev_flash(struct dl *dl)
 			       NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
-				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
+				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE |
+				DL_OPT_DRY_RUN);
 	if (err)
 		return err;
 
-- 
2.35.1.456.ga9c7032d4631

