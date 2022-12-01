Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B121863EDBE
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiLAK21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiLAK2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:28:11 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEED34C266
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890487; x=1701426487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7S/cIJHi5VukoIjgJADGZU8OdAX4F0jMjOiOmCL5dtk=;
  b=Wc0k+KuvgTJ2+ZHq5oCIDy9sMPzY+5E4YEJO44/P6DHkeY44ARK1dc10
   QWhfK5uamdjaivA13UNdNFQvz8rK/LqDo/1J54kBkw18KS48Dg83NYlD3
   6uqdHUuwVIOOG7xI0fG/TZ9H6N6oHMvspmw/HwSfiPVKQFhoR/S4SunPR
   J9FP7g3l1+S40R/KfQwiKEGxpU7QHz1mXDghkkPYiXMytKogK8hNYbuvZ
   5uNx7tXWtDx8ZFl5Vv1KxfukNjPZ5VC9Y6BxLIDMvqmIs78rTJTe/LqAR
   em4ImQrtr9phLZ9krd7s2/kCJU32uA7oHGdQlYDpbzoDq+N+o8Q3ryE/s
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313278014"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="313278014"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:28:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="769184536"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="769184536"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:28:04 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next v2 3/4] devlink: Introduce new attribute 'tx_weight' to devlink-rate
Date:   Thu,  1 Dec 2022 11:26:25 +0100
Message-Id: <20221201102626.56390-4-michal.wilczynski@intel.com>
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
 devlink/devlink.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 479d153e2a5e..536db5c9a009 100644
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
@@ -5051,7 +5070,8 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
 			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
-			    DL_OPT_PORT_FN_RATE_TX_PRIORITY);
+			    DL_OPT_PORT_FN_RATE_TX_PRIORITY |
+			    DL_OPT_PORT_FN_RATE_TX_WEIGHT);
 	if (err)
 		return err;
 
@@ -5108,6 +5128,9 @@ static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
 	if (tb[DEVLINK_ATTR_RATE_TX_PRIORITY])
 		opts->rate_tx_priority =
 			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+	if (tb[DEVLINK_ATTR_RATE_TX_WEIGHT])
+		opts->rate_tx_weight =
+			mnl_attr_get_u32(tb[DEVLINK_ATTR_RATE_TX_WEIGHT]);
 	return MNL_CB_OK;
 }
 
@@ -5122,6 +5145,7 @@ static int cmd_port_fn_rate_set(struct dl *dl)
 				DL_OPT_PORT_FN_RATE_TX_SHARE |
 				DL_OPT_PORT_FN_RATE_TX_MAX |
 				DL_OPT_PORT_FN_RATE_TX_PRIORITY |
+				DL_OPT_PORT_FN_RATE_TX_WEIGHT |
 				DL_OPT_PORT_FN_RATE_PARENT);
 	if (err)
 		return err;
-- 
2.37.2

