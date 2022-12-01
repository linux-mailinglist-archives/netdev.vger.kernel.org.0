Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C574A63EDBB
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiLAK2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiLAK2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:28:11 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A355CB6
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890484; x=1701426484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Q84uwQYQDZ8UVWa0FNGN4rCnZZ8GKp3KP4kP8monbU=;
  b=Ywy9w3qPCele2fARzTyTVPUG26NjzoW/gRfVwcNZt05N0js6KCY9FFfK
   CGnLav/xiBP0NyBmA5MDKUWiX5p8WjbjEWlQZmhOT6lCt2hQp1Pl5YACD
   hwXaW1NAAzFwuvfTeAlFXzC4qXFynFItvMqkViGwjZ36KAoB7oKT5gK0Y
   bf8b5IKuEhRTUmUf3NApwdbbHfpFDUtO9FLKyySI3BpyuNTJeCeLK9UVd
   rG6oniMz4sEngzIDbtqdgGyBkfxe/JJAigPTzoWzE+XZi1FSX+6zqqcry
   uB8KSGei96gWpyArDwPRPPRLTIH7V/3LY4gIzlkrZABM0dbOr6xeDAQlP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313278008"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="313278008"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:28:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="769184519"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="769184519"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:28:01 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next v2 2/4] devlink: Introduce new attribute 'tx_priority' to devlink-rate
Date:   Thu,  1 Dec 2022 11:26:24 +0100
Message-Id: <20221201102626.56390-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221201102626.56390-1-michal.wilczynski@intel.com>
References: <20221201102626.56390-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fully utilize hierarchical QoS algorithm new attribute 'tx_priority'
needs to be introduced. Priority attribute allows for usage of strict
priority arbiter among siblings. This arbitration scheme attempts to
schedule nodes based on their priority as long as the nodes remain within
their bandwidth limit.

Introduce ability to configure tx_priority from devlink userspace
utility. Make the new attribute optional.

Example commands:
$ devlink port function rate add pci/0000:4b:00.0/node_custom \
  tx_priority 5 parent node_0
$ devlink port function rate set pci/0000:4b:00.0/2 tx_priority 5

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 devlink/devlink.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8aefa101b2f8..479d153e2a5e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -295,6 +295,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_LINECARD		BIT(52)
 #define DL_OPT_LINECARD_TYPE	BIT(53)
 #define DL_OPT_SELFTESTS	BIT(54)
+#define DL_OPT_PORT_FN_RATE_TX_PRIORITY	BIT(55)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -353,6 +354,7 @@ struct dl_opts {
 	uint16_t rate_type;
 	uint64_t rate_tx_share;
 	uint64_t rate_tx_max;
+	uint32_t rate_tx_priority;
 	char *rate_node_name;
 	const char *rate_parent_node;
 	uint32_t linecard_index;
@@ -2048,6 +2050,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FN_RATE_TX_MAX;
+		} else if (dl_argv_match(dl, "tx_priority") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_PRIORITY)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->rate_tx_priority);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_PRIORITY;
 		} else if (dl_argv_match(dl, "parent") &&
 			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
 			dl_arg_inc(dl);
@@ -2316,6 +2325,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_SHARE)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_SHARE,
 				 opts->rate_tx_share);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_PRIORITY)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_RATE_TX_PRIORITY,
+				 opts->rate_tx_priority);
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_MAX)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_MAX,
 				 opts->rate_tx_max);
@@ -4936,6 +4948,13 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			print_rate(dl->use_iec, PRINT_ANY, "tx_max",
 				   " tx_max %s", rate);
 	}
+	if (tb[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
+		uint32_t priority =
+			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+		if (priority)
+			print_uint(PRINT_ANY, "tx_priority",
+				   " tx_priority %u", priority);
+	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
 		const char *parent =
 			mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]);
@@ -4967,11 +4986,12 @@ static void cmd_port_fn_rate_help(void)
 	pr_err("Usage: devlink port function rate help\n");
 	pr_err("       devlink port function rate show [ DEV/{ PORT_INDEX | NODE_NAME } ]\n");
 	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority N ][ { parent NODE_NAME | noparent } ]\n");
 	pr_err("       devlink port function rate del DEV/NODE_NAME\n");
 	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority N ][ { parent NODE_NAME | noparent } ]\n\n");
 	pr_err("       VAL - float or integer value in units of bits or bytes per second (bit|bps)\n");
+	pr_err("       N - integer representing priority of the node among siblings\n");
 	pr_err("       and SI (k-, m-, g-, t-) or IEC (ki-, mi-, gi-, ti-) case-insensitive prefix.\n");
 	pr_err("       Bare number, means bits per second, is possible.\n\n");
 	pr_err("       For details refer to devlink-rate(8) man page.\n");
@@ -5030,7 +5050,8 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
+			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
+			    DL_OPT_PORT_FN_RATE_TX_PRIORITY);
 	if (err)
 		return err;
 
@@ -5084,6 +5105,9 @@ static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX])
 		opts->rate_tx_max =
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
+	if (tb[DEVLINK_ATTR_RATE_TX_PRIORITY])
+		opts->rate_tx_priority =
+			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_PRIORITY]);
 	return MNL_CB_OK;
 }
 
@@ -5097,6 +5121,7 @@ static int cmd_port_fn_rate_set(struct dl *dl)
 				DL_OPT_PORT_FN_RATE_NODE_NAME,
 				DL_OPT_PORT_FN_RATE_TX_SHARE |
 				DL_OPT_PORT_FN_RATE_TX_MAX |
+				DL_OPT_PORT_FN_RATE_TX_PRIORITY |
 				DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
-- 
2.37.2

