Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA436389E4
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiKYMfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiKYMfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:35:10 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A7B4B77E
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669379708; x=1700915708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l8AGM+eOFQuoCbeuU+14kzHvC5ae65PyRB3HFlZ2VL4=;
  b=d5ER3CbYOLR363IQw2eqvPC35/RdCLgSvslW6mrpqUOJgy3+SelW3LAz
   eV8WzWZnP0iIZg30eyR/imrpEkRunHOsIVAj0FIvgvy94K4mBod2KP2ba
   S0XMj+rHs5W7wEGEKRijg4FLgpVivdRGZ0lWt6oLZ3J8ByVaCjNurWpxp
   sYretjTzGQas4KGkUe981EdNWQcggMLNHT8k4VTevfZMELPBiPVWV1TTJ
   Y3qyNdiXLWqV5jrUJVvAWHXF7appTuFAcZyznpLlvTU3ORP45SxwG7JSD
   WYk5INTGe2UGZaIx6abRK8exf9YJHH/wH/iwHAQtT+XlEfmq5uYGDzpf2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314510214"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314510214"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711264038"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="711264038"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:49 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next 4/5] devlink: Introduce new attribute 'tx_weight' to devlink-rate
Date:   Fri, 25 Nov 2022 13:34:20 +0100
Message-Id: <20221125123421.36297-5-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125123421.36297-1-michal.wilczynski@intel.com>
References: <20221125123421.36297-1-michal.wilczynski@intel.com>
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

To fully utilize hierarchical QoS algorithm new attribute 'tx_weight'
needs to be introduced. Weight attribute allows for usage of Weighted
Fair Queuing arbitration scheme among siblings. This arbitration
scheme can be used simultaneously with the strict priority.

Introduce ability to configure tx_weight from devlink userspace
utility. Make the new attribute optional.

Example commands:
$ devlink port function rate add pci/0000:4b:00.0/node_custom \
  tx_weight 50 parent node_0

$ devlink port function rate set pci/0000:4b:00.0/2 tx_weight 20

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 devlink/devlink.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 21241cb644bb..d420467cfe7d 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -296,6 +296,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_LINECARD_TYPE	BIT(53)
 #define DL_OPT_SELFTESTS	BIT(54)
 #define DL_OPT_PORT_FN_RATE_TX_PRIORITY	BIT(55)
+#define DL_OPT_PORT_FN_RATE_TX_WEIGHT	BIT(56)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -355,6 +356,7 @@ struct dl_opts {
 	uint64_t rate_tx_share;
 	uint64_t rate_tx_max;
 	uint32_t rate_tx_priority;
+	uint32_t rate_tx_weight;
 	char *rate_node_name;
 	const char *rate_parent_node;
 	uint32_t linecard_index;
@@ -2057,6 +2059,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FN_RATE_TX_PRIORITY;
+		} else if (dl_argv_match(dl, "tx_weight") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_WEIGHT)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->rate_tx_weight);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_WEIGHT;
 		} else if (dl_argv_match(dl, "parent") &&
 			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
 			dl_arg_inc(dl);
@@ -2328,6 +2337,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_PRIORITY)
 		mnl_attr_put_u32(nlh, DEVLINK_ATTR_RATE_TX_PRIORITY,
 				 opts->rate_tx_priority);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_WEIGHT)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_RATE_TX_WEIGHT,
+				 opts->rate_tx_weight);
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_MAX)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_MAX,
 				 opts->rate_tx_max);
@@ -4955,6 +4967,13 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			print_uint(PRINT_ANY, "tx_priority",
 				   " tx_priority %u", priority);
 	}
+	if (tb[DEVLINK_ATTR_RATE_TX_WEIGHT]) {
+		uint32_t weight =
+			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_WEIGHT]);
+		if (weight)
+			print_uint(PRINT_ANY, "tx_weight",
+				   " tx_weight %u", weight);
+	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
 		const char *parent =
 			mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]);
@@ -4986,12 +5005,12 @@ static void cmd_port_fn_rate_help(void)
 	pr_err("Usage: devlink port function rate help\n");
 	pr_err("       devlink port function rate show [ DEV/{ PORT_INDEX | NODE_NAME } ]\n");
 	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority N ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority N ][ tx_weight N ][ { parent NODE_NAME | noparent } ]\n");
 	pr_err("       devlink port function rate del DEV/NODE_NAME\n");
 	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority N ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority N ][ tx_weight N ][ { parent NODE_NAME | noparent } ]\n\n");
 	pr_err("       VAL - float or integer value in units of bits or bytes per second (bit|bps)\n");
-	pr_err("       N - integer representing priority of the node among siblings\n");
+	pr_err("       N - integer representing priority/weight of the node among siblings\n");
 	pr_err("       and SI (k-, m-, g-, t-) or IEC (ki-, mi-, gi-, ti-) case-insensitive prefix.\n");
 	pr_err("       Bare number, means bits per second, is possible.\n\n");
 	pr_err("       For details refer to devlink-rate(8) man page.\n");
@@ -5052,6 +5071,7 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
 			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
 			    DL_OPT_PORT_FN_RATE_TX_PRIORITY |
+			    DL_OPT_PORT_FN_RATE_TX_WEIGHT |
 			    DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
@@ -5109,6 +5129,9 @@ static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
 	if (tb[DEVLINK_ATTR_RATE_TX_PRIORITY])
 		opts->rate_tx_priority =
 			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+	if (tb[DEVLINK_ATTR_RATE_TX_WEIGHT])
+		opts->rate_tx_weight =
+			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_WEIGHT]);
 	return MNL_CB_OK;
 }
 
@@ -5123,6 +5146,7 @@ static int cmd_port_fn_rate_set(struct dl *dl)
 				DL_OPT_PORT_FN_RATE_TX_SHARE |
 				DL_OPT_PORT_FN_RATE_TX_MAX |
 				DL_OPT_PORT_FN_RATE_TX_PRIORITY |
+				DL_OPT_PORT_FN_RATE_TX_WEIGHT |
 				DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
-- 
2.37.2

