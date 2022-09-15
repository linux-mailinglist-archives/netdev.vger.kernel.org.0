Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1095B9C5C
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiIONwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIONwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:52:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D99597515
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249920; x=1694785920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4ZLBAzdsLzz85eVjRDuYDpS+34nMAetmp6qrRSL5Mgo=;
  b=h36xq0N9FbiLdyPbXjlJsaXLAkM4iaDXmFoCMlLtGyus4wouvc33HE6S
   c3Qp8pm/2Y5t3t5XwIb4HPKcrasTsnnCQe6ihqwoHD0mo8i/KTXX++2h2
   zmYLLEKugOEKwTHbFXKhJhS5aT5i54agZ0o3RjgYkF0YVyyYts5newz8B
   gYyajP4ag7ii0ZzKAAPdM5XlIGYh5j69S2P/6WBl11Sz1xD6vhnhgKDrA
   8fAUQn2+aTpnbn/nI67jBgf830cgnLecywI4whtITaJK59J+ZNky6NeCV
   1l68gfUeLukPeqwk1Ge+DG2nFloiKPlV2qUH/AkZ3n8AHOHNPl7Ml2FTR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="278444806"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="278444806"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:52:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="759642815"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:51:58 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH iproute2-next] iproute2: Support for queues and new parameters
Date:   Thu, 15 Sep 2022 15:51:50 +0200
Message-Id: <20220915135150.1935656-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New object type 'queue' is being added in the kernel, and new parameters
are being added: 'tx_weight' and 'tx_priority'.

Add support for configuration of these new elements.
Correspoding kernel changes:
https://lore.kernel.org/netdev/20220915134239.1935604-1-michal.wilczynski@intel.com/

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 devlink/devlink.c            | 137 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/devlink.h |   8 +-
 2 files changed, 127 insertions(+), 18 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4f77e42f..abd9b823 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -297,6 +297,9 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_LINECARD		BIT(52)
 #define DL_OPT_LINECARD_TYPE	BIT(53)
 #define DL_OPT_SELFTESTS	BIT(54)
+#define DL_OPT_PORT_FN_RATE_QUEUE	BIT(55)
+#define DL_OPT_PORT_FN_RATE_TX_PRIORITY	BIT(56)
+#define DL_OPT_PORT_FN_RATE_TX_WEIGHT	BIT(57)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -353,8 +356,11 @@ struct dl_opts {
 	uint16_t port_pfnumber;
 	uint8_t port_fn_state;
 	uint16_t rate_type;
+	uint16_t rate_queue;
 	uint64_t rate_tx_share;
 	uint64_t rate_tx_max;
+	uint16_t rate_tx_priority;
+	uint16_t rate_tx_weight;
 	char *rate_node_name;
 	const char *rate_parent_node;
 	uint32_t linecard_index;
@@ -1043,6 +1049,23 @@ static int dl_argv_handle_both(struct dl *dl, char **p_bus_name,
 	return 0;
 }
 
+static int __dl_argv_handle_queue_name(char *str, char **p_bus_name,
+				       char **p_dev_name, char **p_name)
+{
+	char *handlestr, *after, *before;
+	int err;
+
+	err = str_split_by_char(str, &handlestr, p_name, '/');
+	if (err)
+		return err;
+
+	err = str_split_by_char(handlestr, &before, &after, '/');
+	if (err)
+		return err;
+
+	return str_split_by_char(handlestr, p_bus_name, p_dev_name, '/');
+}
+
 static int __dl_argv_handle_name(char *str, char **p_bus_name,
 				 char **p_dev_name, char **p_name)
 {
@@ -1103,13 +1126,33 @@ static int dl_argv_handle_rate_node(struct dl *dl, char **p_bus_name,
 
 static int dl_argv_handle_rate(struct dl *dl, char **p_bus_name,
 			       char **p_dev_name, uint32_t *p_port_index,
-			       char **p_node_name, uint64_t *p_handle_bit)
+			       uint16_t *queue_id, char **p_node_name,
+			       uint64_t *p_handle_bit)
 {
 	char *str = dl_argv_next(dl);
 	char *identifier;
 	int err;
 
+	if (strstr(str, "queue")) {
+		err = __dl_argv_handle_queue_name(str, p_bus_name, p_dev_name, &identifier);
+		if (err) {
+			pr_err("Identification \"%s\" is invalid\n"
+			       "Expected \"bus_name/dev_name/queue/queue_id identification.",
+			       str);
+			return err;
+		}
+
+		if (!*identifier) {
+			pr_err("Identifier cannot be empty");
+			return -EINVAL;
+		}
+		err = get_u16(queue_id, identifier, 10);
+		*p_handle_bit = DL_OPT_PORT_FN_RATE_QUEUE;
+		return err;
+	}
+
 	err = ident_str_validate(str, 2);
+
 	if (err) {
 		pr_err("Expected \"bus_name/dev_name/node\" or "
 		       "\"bus_name/dev_name/port_index\" identification.\n");
@@ -1464,10 +1507,12 @@ static int port_fn_state_parse(const char *statestr, uint8_t *state)
 
 static int port_fn_rate_type_get(const char *typestr, uint16_t *type)
 {
-	if (!strcmp(typestr, "leaf"))
-		*type = DEVLINK_RATE_TYPE_LEAF;
+	if (!strcmp(typestr, "vport"))
+		*type = DEVLINK_RATE_TYPE_VPORT;
 	else if (!strcmp(typestr, "node"))
 		*type = DEVLINK_RATE_TYPE_NODE;
+	else if (!strcmp(typestr, "queue"))
+		*type = DEVLINK_RATE_TYPE_QUEUE;
 	else
 		return -EINVAL;
 	return 0;
@@ -1572,7 +1617,7 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 		uint64_t handle_bit;
 
 		err = dl_argv_handle_rate(dl, &opts->bus_name, &opts->dev_name,
-					  &opts->port_index,
+					  &opts->port_index, &opts->rate_queue,
 					  &opts->rate_node_name,
 					  &handle_bit);
 		if (err)
@@ -2049,13 +2094,33 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FN_RATE_TX_MAX;
-		} else if (dl_argv_match(dl, "parent") &&
-			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
+		} else if (dl_argv_match(dl, "tx_priority") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_PRIORITY)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint16_t(dl, &opts->rate_tx_priority);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_PRIORITY;
+		} else if (dl_argv_match(dl, "tx_weight") &&
+			   (o_all & DL_OPT_PORT_FN_RATE_TX_WEIGHT)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint16_t(dl, &opts->rate_tx_weight);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_TX_WEIGHT;
+		} else if (dl_argv_match(dl, "parent")
+			 /*  (o_all & DL_OPT_PORT_FN_RATE_PARENT)*/) {
 			dl_arg_inc(dl);
 			err = dl_argv_str(dl, &opts->rate_parent_node);
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
+		} else if (dl_argv_match(dl, "queue")) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint16_t(dl, &opts->rate_queue);
+			if (err)
+				return err;
+			o_found |= DL_OPT_PORT_FN_RATE_QUEUE;
 		} else if (dl_argv_match(dl, "noparent") &&
 			   (o_all & DL_OPT_PORT_FN_RATE_PARENT)) {
 			dl_arg_inc(dl);
@@ -2185,6 +2250,10 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, opts->dev_name);
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
 				  opts->rate_node_name);
+	} else if (opts->present & DL_OPT_PORT_FN_RATE_QUEUE) {
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_BUS_NAME, opts->bus_name);
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, opts->dev_name);
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_QUEUE, opts->rate_queue);
 	}
 	if (opts->present & DL_OPT_PORT_TYPE)
 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
@@ -2317,12 +2386,21 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_SHARE)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_SHARE,
 				 opts->rate_tx_share);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_PRIORITY)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_TX_PRIORITY,
+				 opts->rate_tx_priority);
+	if (opts->present & DL_OPT_PORT_FN_RATE_TX_WEIGHT)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_TX_WEIGHT,
+				 opts->rate_tx_weight);
 	if (opts->present & DL_OPT_PORT_FN_RATE_TX_MAX)
 		mnl_attr_put_u64(nlh, DEVLINK_ATTR_RATE_TX_MAX,
 				 opts->rate_tx_max);
 	if (opts->present & DL_OPT_PORT_FN_RATE_PARENT)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				  opts->rate_parent_node);
+	if (opts->present & DL_OPT_PORT_FN_RATE_QUEUE)
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_RATE_QUEUE,
+				 opts->rate_queue);
 	if (opts->present & DL_OPT_LINECARD)
 		mnl_attr_put_u32(nlh, DEVLINK_ATTR_LINECARD_INDEX,
 				 opts->linecard_index);
@@ -4881,12 +4959,19 @@ pr_out_port_rate_handle_start(struct dl *dl, struct nlattr **tb, bool try_nice)
 	const char *bus_name;
 	const char *dev_name;
 	const char *node_name;
-	static char buf[64];
+	static char buf[128];
+	uint32_t queue_id;
 
 	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
 	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
-	node_name = mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_NODE_NAME]);
-	sprintf(buf, "%s/%s/%s", bus_name, dev_name, node_name);
+
+	if (tb[DEVLINK_ATTR_RATE_QUEUE]) {
+		queue_id = mnl_attr_get_u16(tb[DEVLINK_ATTR_RATE_QUEUE]);
+		sprintf(buf, "%s/%s/queue/%u", bus_name, dev_name, queue_id);
+	} else if (tb[DEVLINK_ATTR_RATE_NODE_NAME]) {
+		node_name = mnl_attr_get_str(tb[DEVLINK_ATTR_RATE_NODE_NAME]);
+		sprintf(buf, "%s/%s/%s", bus_name, dev_name, node_name);
+	}
 	if (dl->json_output)
 		open_json_object(buf);
 	else
@@ -4896,10 +4981,12 @@ pr_out_port_rate_handle_start(struct dl *dl, struct nlattr **tb, bool try_nice)
 static char *port_rate_type_name(uint16_t type)
 {
 	switch (type) {
-	case DEVLINK_RATE_TYPE_LEAF:
-		return "leaf";
+	case DEVLINK_RATE_TYPE_VPORT:
+		return "vport";
 	case DEVLINK_RATE_TYPE_NODE:
 		return "node";
+	case DEVLINK_RATE_TYPE_QUEUE:
+		return "queue";
 	default:
 		return "<unknown type>";
 	}
@@ -4908,7 +4995,7 @@ static char *port_rate_type_name(uint16_t type)
 static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 {
 
-	if (!tb[DEVLINK_ATTR_RATE_NODE_NAME])
+	if (!tb[DEVLINK_ATTR_RATE_NODE_NAME] && !tb[DEVLINK_ATTR_RATE_QUEUE])
 		pr_out_port_handle_start(dl, tb, false);
 	else
 		pr_out_port_rate_handle_start(dl, tb, false);
@@ -4956,7 +5043,8 @@ static int cmd_port_fn_rate_show_cb(const struct nlmsghdr *nlh, void *data)
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
 	if ((!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
 	     !tb[DEVLINK_ATTR_PORT_INDEX]) &&
-	    !tb[DEVLINK_ATTR_RATE_NODE_NAME]) {
+	     !tb[DEVLINK_ATTR_RATE_NODE_NAME] &&
+	     !tb[DEVLINK_ATTR_RATE_QUEUE]) {
 		return MNL_CB_ERROR;
 	}
 	pr_out_port_fn_rate(dl, tb);
@@ -4968,10 +5056,12 @@ static void cmd_port_fn_rate_help(void)
 	pr_err("Usage: devlink port function rate help\n");
 	pr_err("       devlink port function rate show [ DEV/{ PORT_INDEX | NODE_NAME } ]\n");
 	pr_err("       devlink port function rate add DEV/NODE_NAME\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority ][ { parent NODE_NAME | noparent } ]\n");
 	pr_err("       devlink port function rate del DEV/NODE_NAME\n");
 	pr_err("       devlink port function rate set DEV/{ PORT_INDEX | NODE_NAME }\n");
-	pr_err("               [ tx_share VAL ][ tx_max VAL ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority ][ { parent NODE_NAME | noparent } ]\n\n");
+	pr_err("       devlink port function rate set DEV/queue/QUEUE_ID\n");
+	pr_err("               [ tx_share VAL ][ tx_max VAL ][ tx_priority ][ { parent NODE_NAME | noparent } ]\n\n");
 	pr_err("       VAL - float or integer value in units of bits or bytes per second (bit|bps)\n");
 	pr_err("       and SI (k-, m-, g-, t-) or IEC (ki-, mi-, gi-, ti-) case-insensitive prefix.\n");
 	pr_err("       Bare number, means bits per second, is possible.\n\n");
@@ -5031,7 +5121,11 @@ static int cmd_port_fn_rate_add(struct dl *dl)
 	int err;
 
 	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
-			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
+			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
+			    DL_OPT_PORT_FN_RATE_TX_PRIORITY |
+			    DL_OPT_PORT_FN_RATE_TX_WEIGHT |
+			    DL_OPT_PORT_FN_RATE_PARENT);
+
 	if (err)
 		return err;
 
@@ -5085,6 +5179,12 @@ static int port_fn_get_rates_cb(const struct nlmsghdr *nlh, void *data)
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX])
 		opts->rate_tx_max =
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
+	if (tb[DEVLINK_ATTR_RATE_TX_PRIORITY])
+		opts->rate_tx_priority =
+			mnl_attr_get_u16(tb[DEVLINK_ATTR_RATE_TX_PRIORITY]);
+	if (tb[DEVLINK_ATTR_RATE_TX_WEIGHT])
+		opts->rate_tx_weight =
+			mnl_attr_get_u16(tb[DEVLINK_ATTR_RATE_TX_WEIGHT]);
 	return MNL_CB_OK;
 }
 
@@ -5098,7 +5198,10 @@ static int cmd_port_fn_rate_set(struct dl *dl)
 				DL_OPT_PORT_FN_RATE_NODE_NAME,
 				DL_OPT_PORT_FN_RATE_TX_SHARE |
 				DL_OPT_PORT_FN_RATE_TX_MAX |
-				DL_OPT_PORT_FN_RATE_PARENT);
+				DL_OPT_PORT_FN_RATE_TX_PRIORITY |
+				DL_OPT_PORT_FN_RATE_TX_WEIGHT |
+				DL_OPT_PORT_FN_RATE_PARENT |
+				DL_OPT_PORT_FN_RATE_QUEUE);
 	if (err)
 		return err;
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 0224b8bd..7b6576f5 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -220,8 +220,10 @@ enum devlink_port_flavour {
 };
 
 enum devlink_rate_type {
-	DEVLINK_RATE_TYPE_LEAF,
+	DEVLINK_RATE_TYPE_LEAF, /* deprecated, leaving this for backward compatibility */
 	DEVLINK_RATE_TYPE_NODE,
+	DEVLINK_RATE_TYPE_QUEUE,
+	DEVLINK_RATE_TYPE_VPORT,
 };
 
 enum devlink_param_cmode {
@@ -607,6 +609,10 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_RATE_QUEUE,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.27.0

