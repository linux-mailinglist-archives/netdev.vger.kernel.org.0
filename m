Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAE13685F2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhDVRan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:60041 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238549AbhDVRaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:15 -0400
IronPort-SDR: 0VLtG1hqA9D5XIE00ePXwynPH0kSSnfX7z9x1K5uBaLU5Cba9JiijohZwQFpjmwH4cLecJ4ShI
 HvwqD+hcxEUA==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991486"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991486"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:36 -0700
IronPort-SDR: DJ1FBOmgq56SQDcxWtkEkv0IftsOsPCN5YLahxBEQZfvxxl3ftrPZy8ZyCcIOjyD9Qf5WKK65B
 Qr0uOJSoe/Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286289"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 10/12] iavf: Support for modifying TCP RSS flow hashing
Date:   Thu, 22 Apr 2021 10:31:28 -0700
Message-Id: <20210422173130.1143082-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Provides the ability to enable TCP RSS hashing by ethtool.

It gives users option of generating RSS hash based on the TCP source
and destination ports numbers, IPv4 or IPv6 source and destination
addresses.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/Makefile      |   1 +
 .../net/ethernet/intel/iavf/iavf_adv_rss.c    | 170 ++++++++++++++
 .../net/ethernet/intel/iavf/iavf_adv_rss.h    |  54 +++++
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 214 +++++++++++++++++-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  15 +-
 5 files changed, 450 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adv_rss.c

diff --git a/drivers/net/ethernet/intel/iavf/Makefile b/drivers/net/ethernet/intel/iavf/Makefile
index 121e194ee734..9c3e45c54d01 100644
--- a/drivers/net/ethernet/intel/iavf/Makefile
+++ b/drivers/net/ethernet/intel/iavf/Makefile
@@ -12,4 +12,5 @@ subdir-ccflags-y += -I$(src)
 obj-$(CONFIG_IAVF) += iavf.o
 
 iavf-objs := iavf_main.o iavf_ethtool.o iavf_virtchnl.o iavf_fdir.o \
+	     iavf_adv_rss.o \
 	     iavf_txrx.o iavf_common.o iavf_adminq.o iavf_client.o
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
new file mode 100644
index 000000000000..4c5771cdc445
--- /dev/null
+++ b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021, Intel Corporation. */
+
+/* advanced RSS configuration ethtool support for iavf */
+
+#include "iavf.h"
+
+/**
+ * iavf_fill_adv_rss_ip4_hdr - fill the IPv4 RSS protocol header
+ * @hdr: the virtchnl message protocol header data structure
+ * @hash_flds: the RSS configuration protocol hash fields
+ */
+static void
+iavf_fill_adv_rss_ip4_hdr(struct virtchnl_proto_hdr *hdr, u64 hash_flds)
+{
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, IPV4);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_IPV4_SA)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, SRC);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_IPV4_DA)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, DST);
+}
+
+/**
+ * iavf_fill_adv_rss_ip6_hdr - fill the IPv6 RSS protocol header
+ * @hdr: the virtchnl message protocol header data structure
+ * @hash_flds: the RSS configuration protocol hash fields
+ */
+static void
+iavf_fill_adv_rss_ip6_hdr(struct virtchnl_proto_hdr *hdr, u64 hash_flds)
+{
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, IPV6);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_IPV6_SA)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV6, SRC);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_IPV6_DA)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV6, DST);
+}
+
+/**
+ * iavf_fill_adv_rss_tcp_hdr - fill the TCP RSS protocol header
+ * @hdr: the virtchnl message protocol header data structure
+ * @hash_flds: the RSS configuration protocol hash fields
+ */
+static void
+iavf_fill_adv_rss_tcp_hdr(struct virtchnl_proto_hdr *hdr, u64 hash_flds)
+{
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, TCP);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, TCP, SRC_PORT);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, TCP, DST_PORT);
+}
+
+/**
+ * iavf_fill_adv_rss_cfg_msg - fill the RSS configuration into virtchnl message
+ * @rss_cfg: the virtchnl message to be filled with RSS configuration setting
+ * @packet_hdrs: the RSS configuration protocol header types
+ * @hash_flds: the RSS configuration protocol hash fields
+ *
+ * Returns 0 if the RSS configuration virtchnl message is filled successfully
+ */
+int
+iavf_fill_adv_rss_cfg_msg(struct virtchnl_rss_cfg *rss_cfg,
+			  u32 packet_hdrs, u64 hash_flds)
+{
+	struct virtchnl_proto_hdrs *proto_hdrs = &rss_cfg->proto_hdrs;
+	struct virtchnl_proto_hdr *hdr;
+
+	rss_cfg->rss_algorithm = VIRTCHNL_RSS_ALG_TOEPLITZ_ASYMMETRIC;
+
+	proto_hdrs->tunnel_level = 0;	/* always outer layer */
+
+	hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	switch (packet_hdrs & IAVF_ADV_RSS_FLOW_SEG_HDR_L3) {
+	case IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4:
+		iavf_fill_adv_rss_ip4_hdr(hdr, hash_flds);
+		break;
+	case IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6:
+		iavf_fill_adv_rss_ip6_hdr(hdr, hash_flds);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	switch (packet_hdrs & IAVF_ADV_RSS_FLOW_SEG_HDR_L4) {
+	case IAVF_ADV_RSS_FLOW_SEG_HDR_TCP:
+		iavf_fill_adv_rss_tcp_hdr(hdr, hash_flds);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * iavf_find_adv_rss_cfg_by_hdrs - find RSS configuration with header type
+ * @adapter: pointer to the VF adapter structure
+ * @packet_hdrs: protocol header type to find.
+ *
+ * Returns pointer to advance RSS configuration if found or null
+ */
+struct iavf_adv_rss *
+iavf_find_adv_rss_cfg_by_hdrs(struct iavf_adapter *adapter, u32 packet_hdrs)
+{
+	struct iavf_adv_rss *rss;
+
+	list_for_each_entry(rss, &adapter->adv_rss_list_head, list)
+		if (rss->packet_hdrs == packet_hdrs)
+			return rss;
+
+	return NULL;
+}
+
+/**
+ * iavf_print_adv_rss_cfg
+ * @adapter: pointer to the VF adapter structure
+ * @rss: pointer to the advance RSS configuration to print
+ * @action: the string description about how to handle the RSS
+ * @result: the string description about the virtchnl result
+ *
+ * Print the advance RSS configuration
+ **/
+void
+iavf_print_adv_rss_cfg(struct iavf_adapter *adapter, struct iavf_adv_rss *rss,
+		       const char *action, const char *result)
+{
+	u32 packet_hdrs = rss->packet_hdrs;
+	u64 hash_flds = rss->hash_flds;
+	static char hash_opt[300];
+	const char *proto;
+
+	if (packet_hdrs & IAVF_ADV_RSS_FLOW_SEG_HDR_TCP)
+		proto = "TCP";
+	else
+		return;
+
+	memset(hash_opt, 0, sizeof(hash_opt));
+
+	strcat(hash_opt, proto);
+	if (packet_hdrs & IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4)
+		strcat(hash_opt, "v4 ");
+	else
+		strcat(hash_opt, "v6 ");
+
+	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_IPV4_SA |
+			 IAVF_ADV_RSS_HASH_FLD_IPV6_SA))
+		strcat(hash_opt, "IP SA,");
+	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_IPV4_DA |
+			 IAVF_ADV_RSS_HASH_FLD_IPV6_DA))
+		strcat(hash_opt, "IP DA,");
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT)
+		strcat(hash_opt, "src port,");
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT)
+		strcat(hash_opt, "dst port,");
+
+	if (!action)
+		action = "";
+
+	if (!result)
+		result = "";
+
+	dev_info(&adapter->pdev->dev, "%s %s %s\n", action, hash_opt, result);
+}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
index 66262090e697..339ecb42938b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
@@ -15,11 +15,65 @@ enum iavf_adv_rss_state_t {
 	IAVF_ADV_RSS_ACTIVE,		/* RSS configuration is active */
 };
 
+enum iavf_adv_rss_flow_seg_hdr {
+	IAVF_ADV_RSS_FLOW_SEG_HDR_NONE	= 0x00000000,
+	IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4	= 0x00000001,
+	IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6	= 0x00000002,
+	IAVF_ADV_RSS_FLOW_SEG_HDR_TCP	= 0x00000004,
+};
+
+#define IAVF_ADV_RSS_FLOW_SEG_HDR_L3		\
+	(IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4	|	\
+	 IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6)
+
+#define IAVF_ADV_RSS_FLOW_SEG_HDR_L4		\
+	(IAVF_ADV_RSS_FLOW_SEG_HDR_TCP)
+
+enum iavf_adv_rss_flow_field {
+	/* L3 */
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV4_SA,
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV4_DA,
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV6_SA,
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV6_DA,
+	/* L4 */
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_TCP_SRC_PORT,
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_TCP_DST_PORT,
+
+	/* The total number of enums must not exceed 64 */
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_MAX
+};
+
+#define IAVF_ADV_RSS_HASH_INVALID	0
+#define IAVF_ADV_RSS_HASH_FLD_IPV4_SA	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV4_SA)
+#define IAVF_ADV_RSS_HASH_FLD_IPV6_SA	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV6_SA)
+#define IAVF_ADV_RSS_HASH_FLD_IPV4_DA	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV4_DA)
+#define IAVF_ADV_RSS_HASH_FLD_IPV6_DA	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_IPV6_DA)
+#define IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_TCP_SRC_PORT)
+#define IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_TCP_DST_PORT)
+
 /* bookkeeping of advanced RSS configuration */
 struct iavf_adv_rss {
 	enum iavf_adv_rss_state_t state;
 	struct list_head list;
 
+	u32 packet_hdrs;
+	u64 hash_flds;
+
 	struct virtchnl_rss_cfg cfg_msg;
 };
+
+int
+iavf_fill_adv_rss_cfg_msg(struct virtchnl_rss_cfg *rss_cfg,
+			  u32 packet_hdrs, u64 hash_flds);
+struct iavf_adv_rss *
+iavf_find_adv_rss_cfg_by_hdrs(struct iavf_adapter *adapter, u32 packet_hdrs);
+void
+iavf_print_adv_rss_cfg(struct iavf_adapter *adapter, struct iavf_adv_rss *rss,
+		       const char *action, const char *result);
 #endif /* _IAVF_ADV_RSS_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 3ebfef737f5c..d8dca5645c21 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1418,6 +1418,214 @@ static int iavf_del_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	return err;
 }
 
+/**
+ * iavf_adv_rss_parse_hdrs - parses headers from RSS hash input
+ * @cmd: ethtool rxnfc command
+ *
+ * This function parses the rxnfc command and returns intended
+ * header types for RSS configuration
+ */
+static u32 iavf_adv_rss_parse_hdrs(struct ethtool_rxnfc *cmd)
+{
+	u32 hdrs = IAVF_ADV_RSS_FLOW_SEG_HDR_NONE;
+
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_TCP |
+			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4;
+		break;
+	case TCP_V6_FLOW:
+		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_TCP |
+			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6;
+		break;
+	default:
+		break;
+	}
+
+	return hdrs;
+}
+
+/**
+ * iavf_adv_rss_parse_hash_flds - parses hash fields from RSS hash input
+ * @cmd: ethtool rxnfc command
+ *
+ * This function parses the rxnfc command and returns intended hash fields for
+ * RSS configuration
+ */
+static u64 iavf_adv_rss_parse_hash_flds(struct ethtool_rxnfc *cmd)
+{
+	u64 hfld = IAVF_ADV_RSS_HASH_INVALID;
+
+	if (cmd->data & RXH_IP_SRC || cmd->data & RXH_IP_DST) {
+		switch (cmd->flow_type) {
+		case TCP_V4_FLOW:
+			if (cmd->data & RXH_IP_SRC)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_IPV4_SA;
+			if (cmd->data & RXH_IP_DST)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_IPV4_DA;
+			break;
+		case TCP_V6_FLOW:
+			if (cmd->data & RXH_IP_SRC)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_IPV6_SA;
+			if (cmd->data & RXH_IP_DST)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_IPV6_DA;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (cmd->data & RXH_L4_B_0_1 || cmd->data & RXH_L4_B_2_3) {
+		switch (cmd->flow_type) {
+		case TCP_V4_FLOW:
+		case TCP_V6_FLOW:
+			if (cmd->data & RXH_L4_B_0_1)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT;
+			if (cmd->data & RXH_L4_B_2_3)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return hfld;
+}
+
+/**
+ * iavf_set_adv_rss_hash_opt - Enable/Disable flow types for RSS hash
+ * @adapter: pointer to the VF adapter structure
+ * @cmd: ethtool rxnfc command
+ *
+ * Returns Success if the flow input set is supported.
+ */
+static int
+iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
+			  struct ethtool_rxnfc *cmd)
+{
+	struct iavf_adv_rss *rss_old, *rss_new;
+	bool rss_new_add = false;
+	int count = 50, err = 0;
+	u64 hash_flds;
+	u32 hdrs;
+
+	if (!ADV_RSS_SUPPORT(adapter))
+		return -EOPNOTSUPP;
+
+	hdrs = iavf_adv_rss_parse_hdrs(cmd);
+	if (hdrs == IAVF_ADV_RSS_FLOW_SEG_HDR_NONE)
+		return -EINVAL;
+
+	hash_flds = iavf_adv_rss_parse_hash_flds(cmd);
+	if (hash_flds == IAVF_ADV_RSS_HASH_INVALID)
+		return -EINVAL;
+
+	rss_new = kzalloc(sizeof(*rss_new), GFP_KERNEL);
+	if (!rss_new)
+		return -ENOMEM;
+
+	if (iavf_fill_adv_rss_cfg_msg(&rss_new->cfg_msg, hdrs, hash_flds)) {
+		kfree(rss_new);
+		return -EINVAL;
+	}
+
+	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
+				&adapter->crit_section)) {
+		if (--count == 0) {
+			kfree(rss_new);
+			return -EINVAL;
+		}
+
+		udelay(1);
+	}
+
+	spin_lock_bh(&adapter->adv_rss_lock);
+	rss_old = iavf_find_adv_rss_cfg_by_hdrs(adapter, hdrs);
+	if (rss_old) {
+		if (rss_old->state != IAVF_ADV_RSS_ACTIVE) {
+			err = -EBUSY;
+		} else if (rss_old->hash_flds != hash_flds) {
+			rss_old->state = IAVF_ADV_RSS_ADD_REQUEST;
+			rss_old->hash_flds = hash_flds;
+			memcpy(&rss_old->cfg_msg, &rss_new->cfg_msg,
+			       sizeof(rss_new->cfg_msg));
+			adapter->aq_required |= IAVF_FLAG_AQ_ADD_ADV_RSS_CFG;
+		} else {
+			err = -EEXIST;
+		}
+	} else {
+		rss_new_add = true;
+		rss_new->state = IAVF_ADV_RSS_ADD_REQUEST;
+		rss_new->packet_hdrs = hdrs;
+		rss_new->hash_flds = hash_flds;
+		list_add_tail(&rss_new->list, &adapter->adv_rss_list_head);
+		adapter->aq_required |= IAVF_FLAG_AQ_ADD_ADV_RSS_CFG;
+	}
+	spin_unlock_bh(&adapter->adv_rss_lock);
+
+	if (!err)
+		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+
+	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+
+	if (!rss_new_add)
+		kfree(rss_new);
+
+	return err;
+}
+
+/**
+ * iavf_get_adv_rss_hash_opt - Retrieve hash fields for a given flow-type
+ * @adapter: pointer to the VF adapter structure
+ * @cmd: ethtool rxnfc command
+ *
+ * Returns Success if the flow input set is supported.
+ */
+static int
+iavf_get_adv_rss_hash_opt(struct iavf_adapter *adapter,
+			  struct ethtool_rxnfc *cmd)
+{
+	struct iavf_adv_rss *rss;
+	u64 hash_flds;
+	u32 hdrs;
+
+	if (!ADV_RSS_SUPPORT(adapter))
+		return -EOPNOTSUPP;
+
+	cmd->data = 0;
+
+	hdrs = iavf_adv_rss_parse_hdrs(cmd);
+	if (hdrs == IAVF_ADV_RSS_FLOW_SEG_HDR_NONE)
+		return -EINVAL;
+
+	spin_lock_bh(&adapter->adv_rss_lock);
+	rss = iavf_find_adv_rss_cfg_by_hdrs(adapter, hdrs);
+	if (rss)
+		hash_flds = rss->hash_flds;
+	else
+		hash_flds = IAVF_ADV_RSS_HASH_INVALID;
+	spin_unlock_bh(&adapter->adv_rss_lock);
+
+	if (hash_flds == IAVF_ADV_RSS_HASH_INVALID)
+		return -EINVAL;
+
+	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_IPV4_SA |
+			 IAVF_ADV_RSS_HASH_FLD_IPV6_SA))
+		cmd->data |= (u64)RXH_IP_SRC;
+
+	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_IPV4_DA |
+			 IAVF_ADV_RSS_HASH_FLD_IPV6_DA))
+		cmd->data |= (u64)RXH_IP_DST;
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT)
+		cmd->data |= (u64)RXH_L4_B_0_1;
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT)
+		cmd->data |= (u64)RXH_L4_B_2_3;
+
+	return 0;
+}
+
 /**
  * iavf_set_rxnfc - command to set Rx flow rules.
  * @netdev: network interface device structure
@@ -1437,6 +1645,9 @@ static int iavf_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 	case ETHTOOL_SRXCLSRLDEL:
 		ret = iavf_del_fdir_ethtool(adapter, cmd);
 		break;
+	case ETHTOOL_SRXFH:
+		ret = iavf_set_adv_rss_hash_opt(adapter, cmd);
+		break;
 	default:
 		break;
 	}
@@ -1477,8 +1688,7 @@ static int iavf_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		ret = iavf_get_fdir_fltr_ids(adapter, cmd, (u32 *)rule_locs);
 		break;
 	case ETHTOOL_GRXFH:
-		netdev_info(netdev,
-			    "RSS hash info is not available to vf, use pf.\n");
+		ret = iavf_get_adv_rss_hash_opt(adapter, cmd);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 54d2efe1732d..0eab3c43bdc5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1327,6 +1327,9 @@ void iavf_add_adv_rss_cfg(struct iavf_adapter *adapter)
 			process_rss = true;
 			rss->state = IAVF_ADV_RSS_ADD_PENDING;
 			memcpy(rss_cfg, &rss->cfg_msg, len);
+			iavf_print_adv_rss_cfg(adapter, rss,
+					       "Input set change for",
+					       "is pending");
 			break;
 		}
 	}
@@ -1599,6 +1602,9 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 						 &adapter->adv_rss_list_head,
 						 list) {
 				if (rss->state == IAVF_ADV_RSS_ADD_PENDING) {
+					iavf_print_adv_rss_cfg(adapter, rss,
+							       "Failed to change the input set for",
+							       NULL);
 					list_del(&rss->list);
 					kfree(rss);
 				}
@@ -1815,9 +1821,14 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		struct iavf_adv_rss *rss;
 
 		spin_lock_bh(&adapter->adv_rss_lock);
-		list_for_each_entry(rss, &adapter->adv_rss_list_head, list)
-			if (rss->state == IAVF_ADV_RSS_ADD_PENDING)
+		list_for_each_entry(rss, &adapter->adv_rss_list_head, list) {
+			if (rss->state == IAVF_ADV_RSS_ADD_PENDING) {
+				iavf_print_adv_rss_cfg(adapter, rss,
+						       "Input set change for",
+						       "successful");
 				rss->state = IAVF_ADV_RSS_ACTIVE;
+			}
+		}
 		spin_unlock_bh(&adapter->adv_rss_lock);
 		}
 		break;
-- 
2.26.2

