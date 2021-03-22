Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563323450E0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhCVUco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:5513 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhCVUbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:32 -0400
IronPort-SDR: PThSG6GiALnBfSyrRTj3rqKOMc/ouDFp0uESq8q5zlXgDjqBpzTEiJfrBwiT3s/wzF1SrIvjko
 aSA++Wmj3QLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438227"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438227"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:19 -0700
IronPort-SDR: +n/qw4pkisu+W9BtotlqBu+/V4Tke15LE1xaepFY4ZfeHL+56zw2ire7p0HeiLVd9ZJ2j7Gnty
 HxFSWxTxVyWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810634"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        qi.z.zhang@intel.com, Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 18/18] iavf: Enable flex-bytes support
Date:   Mon, 22 Mar 2021 13:32:44 -0700
Message-Id: <20210322203244.2525310-19-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Flex-bytes allows for packet matching based on an offset and value. This
is supported via the ethtool user-def option.

The user-def 0xAAAABBBBCCCCDDDD: BBBB is the 2 byte pattern while AAAA
corresponds to its offset in the packet. Similarly DDDD is the 2 byte
pattern with CCCC being the corresponding offset. The offset ranges from
0x0 to 0x1F7 (up to 504 bytes into the packet). The offset starts from
the beginning of the packet.

This feature can be used to allow customers to set flow director rules
for protocols headers that are beyond standard ones supported by ethtool
(e.g. PFCP or GTP-U).

Like for matching GTP-U's TEID value 0x10203040:
ethtool -N ens787f0v0 flow-type udp4 dst-port 2152 \
user-def 0x002e102000303040 action 13

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  93 ++++++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.c   | 217 +++++++++++++++++-
 drivers/net/ethernet/intel/iavf/iavf_fdir.h   |  19 ++
 3 files changed, 327 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 24ee6ddb8dcb..3ebfef737f5c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -909,6 +909,85 @@ static enum iavf_fdir_flow_type iavf_ethtool_flow_to_fltr(int eth)
 	}
 }
 
+/**
+ * iavf_is_mask_valid - check mask field set
+ * @mask: full mask to check
+ * @field: field for which mask should be valid
+ *
+ * If the mask is fully set return true. If it is not valid for field return
+ * false.
+ */
+static bool iavf_is_mask_valid(u64 mask, u64 field)
+{
+	return (mask & field) == field;
+}
+
+/**
+ * iavf_parse_rx_flow_user_data - deconstruct user-defined data
+ * @fsp: pointer to ethtool Rx flow specification
+ * @fltr: pointer to Flow Director filter for userdef data storage
+ *
+ * Returns 0 on success, negative error value on failure
+ */
+static int
+iavf_parse_rx_flow_user_data(struct ethtool_rx_flow_spec *fsp,
+			     struct iavf_fdir_fltr *fltr)
+{
+	struct iavf_flex_word *flex;
+	int i, cnt = 0;
+
+	if (!(fsp->flow_type & FLOW_EXT))
+		return 0;
+
+	for (i = 0; i < 2; i++) {
+#define IAVF_USERDEF_FLEX_WORD_M	GENMASK(15, 0)
+#define IAVF_USERDEF_FLEX_OFFS_S	16
+#define IAVF_USERDEF_FLEX_OFFS_M	GENMASK(31, IAVF_USERDEF_FLEX_OFFS_S)
+#define IAVF_USERDEF_FLEX_FLTR_M	GENMASK(31, 0)
+		u32 value = be32_to_cpu(fsp->h_ext.data[i]);
+		u32 mask = be32_to_cpu(fsp->m_ext.data[i]);
+
+		if (!value || !mask)
+			continue;
+
+		if (!iavf_is_mask_valid(mask, IAVF_USERDEF_FLEX_FLTR_M))
+			return -EINVAL;
+
+		/* 504 is the maximum value for offsets, and offset is measured
+		 * from the start of the MAC address.
+		 */
+#define IAVF_USERDEF_FLEX_MAX_OFFS_VAL 504
+		flex = &fltr->flex_words[cnt++];
+		flex->word = value & IAVF_USERDEF_FLEX_WORD_M;
+		flex->offset = (value & IAVF_USERDEF_FLEX_OFFS_M) >>
+			     IAVF_USERDEF_FLEX_OFFS_S;
+		if (flex->offset > IAVF_USERDEF_FLEX_MAX_OFFS_VAL)
+			return -EINVAL;
+	}
+
+	fltr->flex_cnt = cnt;
+
+	return 0;
+}
+
+/**
+ * iavf_fill_rx_flow_ext_data - fill the additional data
+ * @fsp: pointer to ethtool Rx flow specification
+ * @fltr: pointer to Flow Director filter to get additional data
+ */
+static void
+iavf_fill_rx_flow_ext_data(struct ethtool_rx_flow_spec *fsp,
+			   struct iavf_fdir_fltr *fltr)
+{
+	if (!fltr->ext_mask.usr_def[0] && !fltr->ext_mask.usr_def[1])
+		return;
+
+	fsp->flow_type |= FLOW_EXT;
+
+	memcpy(fsp->h_ext.data, fltr->ext_data.usr_def, sizeof(fsp->h_ext.data));
+	memcpy(fsp->m_ext.data, fltr->ext_mask.usr_def, sizeof(fsp->m_ext.data));
+}
+
 /**
  * iavf_get_ethtool_fdir_entry - fill ethtool structure with Flow Director filter data
  * @adapter: the VF adapter structure that contains filter list
@@ -1038,6 +1117,8 @@ iavf_get_ethtool_fdir_entry(struct iavf_adapter *adapter,
 		break;
 	}
 
+	iavf_fill_rx_flow_ext_data(fsp, rule);
+
 	if (rule->action == VIRTCHNL_ACTION_DROP)
 		fsp->ring_cookie = RX_CLS_FLOW_DISC;
 	else
@@ -1100,6 +1181,7 @@ iavf_add_fdir_fltr_info(struct iavf_adapter *adapter, struct ethtool_rx_flow_spe
 {
 	u32 flow_type, q_index = 0;
 	enum virtchnl_action act;
+	int err;
 
 	if (fsp->ring_cookie == RX_CLS_FLOW_DISC) {
 		act = VIRTCHNL_ACTION_DROP;
@@ -1115,6 +1197,13 @@ iavf_add_fdir_fltr_info(struct iavf_adapter *adapter, struct ethtool_rx_flow_spe
 	fltr->loc = fsp->location;
 	fltr->q_index = q_index;
 
+	if (fsp->flow_type & FLOW_EXT) {
+		memcpy(fltr->ext_data.usr_def, fsp->h_ext.data,
+		       sizeof(fltr->ext_data.usr_def));
+		memcpy(fltr->ext_mask.usr_def, fsp->m_ext.data,
+		       sizeof(fltr->ext_mask.usr_def));
+	}
+
 	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
 	fltr->flow_type = iavf_ethtool_flow_to_fltr(flow_type);
 
@@ -1217,6 +1306,10 @@ iavf_add_fdir_fltr_info(struct iavf_adapter *adapter, struct ethtool_rx_flow_spe
 	if (iavf_fdir_is_dup_fltr(adapter, fltr))
 		return -EEXIST;
 
+	err = iavf_parse_rx_flow_user_data(fsp, fltr);
+	if (err)
+		return err;
+
 	return iavf_fill_fdir_add_msg(adapter, fltr);
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.c b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
index e1e1af136765..3e687189d737 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
@@ -5,6 +5,10 @@
 
 #include "iavf.h"
 
+#define GTPU_PORT	2152
+#define NAT_T_ESP_PORT	4500
+#define PFCP_PORT	8805
+
 static const struct in6_addr ipv6_addr_full_mask = {
 	.in6_u = {
 		.u6_addr8 = {
@@ -14,6 +18,206 @@ static const struct in6_addr ipv6_addr_full_mask = {
 	}
 };
 
+/**
+ * iavf_pkt_udp_no_pay_len - the length of UDP packet without payload
+ * @fltr: Flow Director filter data structure
+ */
+static u16 iavf_pkt_udp_no_pay_len(struct iavf_fdir_fltr *fltr)
+{
+	return sizeof(struct ethhdr) +
+	       (fltr->ip_ver == 4 ? sizeof(struct iphdr) : sizeof(struct ipv6hdr)) +
+	       sizeof(struct udphdr);
+}
+
+/**
+ * iavf_fill_fdir_gtpu_hdr - fill the GTP-U protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the GTP-U protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_gtpu_hdr(struct iavf_fdir_fltr *fltr,
+			struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *uhdr = &proto_hdrs->proto_hdr[proto_hdrs->count - 1];
+	struct virtchnl_proto_hdr *ghdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct virtchnl_proto_hdr *ehdr = NULL; /* Extension Header if it exists */
+	u16 adj_offs, hdr_offs;
+	int i;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(ghdr, GTPU_IP);
+
+	adj_offs = iavf_pkt_udp_no_pay_len(fltr);
+
+	for (i = 0; i < fltr->flex_cnt; i++) {
+#define IAVF_GTPU_HDR_TEID_OFFS0	4
+#define IAVF_GTPU_HDR_TEID_OFFS1	6
+#define IAVF_GTPU_HDR_N_PDU_AND_NEXT_EXTHDR_OFFS	10
+#define IAVF_GTPU_HDR_PSC_PDU_TYPE_AND_QFI_OFFS		13
+#define IAVF_GTPU_PSC_EXTHDR_TYPE	0x85 /* PDU Session Container Extension Header */
+		if (fltr->flex_words[i].offset < adj_offs)
+			return -EINVAL;
+
+		hdr_offs = fltr->flex_words[i].offset - adj_offs;
+
+		switch (hdr_offs) {
+		case IAVF_GTPU_HDR_TEID_OFFS0:
+		case IAVF_GTPU_HDR_TEID_OFFS1: {
+			__be16 *pay_word = (__be16 *)ghdr->buffer;
+
+			pay_word[hdr_offs >> 1] = htons(fltr->flex_words[i].word);
+			VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(ghdr, GTPU_IP, TEID);
+			}
+			break;
+		case IAVF_GTPU_HDR_N_PDU_AND_NEXT_EXTHDR_OFFS:
+			if ((fltr->flex_words[i].word & 0xff) != IAVF_GTPU_PSC_EXTHDR_TYPE)
+				return -EOPNOTSUPP;
+			if (!ehdr)
+				ehdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+			VIRTCHNL_SET_PROTO_HDR_TYPE(ehdr, GTPU_EH);
+			break;
+		case IAVF_GTPU_HDR_PSC_PDU_TYPE_AND_QFI_OFFS:
+			if (!ehdr)
+				return -EINVAL;
+			ehdr->buffer[1] = fltr->flex_words[i].word & 0x3F;
+			VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(ehdr, GTPU_EH, QFI);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	uhdr->field_selector = 0; /* The PF ignores the UDP header fields */
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_pfcp_hdr - fill the PFCP protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the PFCP protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_pfcp_hdr(struct iavf_fdir_fltr *fltr,
+			struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *uhdr = &proto_hdrs->proto_hdr[proto_hdrs->count - 1];
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	u16 adj_offs, hdr_offs;
+	int i;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, PFCP);
+
+	adj_offs = iavf_pkt_udp_no_pay_len(fltr);
+
+	for (i = 0; i < fltr->flex_cnt; i++) {
+#define IAVF_PFCP_HDR_SFIELD_AND_MSG_TYPE_OFFS	0
+		if (fltr->flex_words[i].offset < adj_offs)
+			return -EINVAL;
+
+		hdr_offs = fltr->flex_words[i].offset - adj_offs;
+
+		switch (hdr_offs) {
+		case IAVF_PFCP_HDR_SFIELD_AND_MSG_TYPE_OFFS:
+			hdr->buffer[0] = (fltr->flex_words[i].word >> 8) & 0xff;
+			VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, PFCP, S_FIELD);
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	uhdr->field_selector = 0; /* The PF ignores the UDP header fields */
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_nat_t_esp_hdr - fill the NAT-T-ESP protocol header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the NAT-T-ESP protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_nat_t_esp_hdr(struct iavf_fdir_fltr *fltr,
+			     struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	struct virtchnl_proto_hdr *uhdr = &proto_hdrs->proto_hdr[proto_hdrs->count - 1];
+	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	u16 adj_offs, hdr_offs;
+	u32 spi = 0;
+	int i;
+
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, ESP);
+
+	adj_offs = iavf_pkt_udp_no_pay_len(fltr);
+
+	for (i = 0; i < fltr->flex_cnt; i++) {
+#define IAVF_NAT_T_ESP_SPI_OFFS0	0
+#define IAVF_NAT_T_ESP_SPI_OFFS1	2
+		if (fltr->flex_words[i].offset < adj_offs)
+			return -EINVAL;
+
+		hdr_offs = fltr->flex_words[i].offset - adj_offs;
+
+		switch (hdr_offs) {
+		case IAVF_NAT_T_ESP_SPI_OFFS0:
+			spi |= fltr->flex_words[i].word << 16;
+			break;
+		case IAVF_NAT_T_ESP_SPI_OFFS1:
+			spi |= fltr->flex_words[i].word;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (!spi)
+		return -EOPNOTSUPP; /* Not support IKE Header Format with SPI 0 */
+
+	*(__be32 *)hdr->buffer = htonl(spi);
+	VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, ESP, SPI);
+
+	uhdr->field_selector = 0; /* The PF ignores the UDP header fields */
+
+	return 0;
+}
+
+/**
+ * iavf_fill_fdir_udp_flex_pay_hdr - fill the UDP payload header
+ * @fltr: Flow Director filter data structure
+ * @proto_hdrs: Flow Director protocol headers data structure
+ *
+ * Returns 0 if the UDP payload defined protocol header is set successfully
+ */
+static int
+iavf_fill_fdir_udp_flex_pay_hdr(struct iavf_fdir_fltr *fltr,
+				struct virtchnl_proto_hdrs *proto_hdrs)
+{
+	int err;
+
+	switch (ntohs(fltr->ip_data.dst_port)) {
+	case GTPU_PORT:
+		err = iavf_fill_fdir_gtpu_hdr(fltr, proto_hdrs);
+		break;
+	case NAT_T_ESP_PORT:
+		err = iavf_fill_fdir_nat_t_esp_hdr(fltr, proto_hdrs);
+		break;
+	case PFCP_PORT:
+		err = iavf_fill_fdir_pfcp_hdr(fltr, proto_hdrs);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
 /**
  * iavf_fill_fdir_ip4_hdr - fill the IPv4 protocol header
  * @fltr: Flow Director filter data structure
@@ -50,6 +254,8 @@ iavf_fill_fdir_ip4_hdr(struct iavf_fdir_fltr *fltr,
 		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV4, DST);
 	}
 
+	fltr->ip_ver = 4;
+
 	return 0;
 }
 
@@ -94,6 +300,8 @@ iavf_fill_fdir_ip6_hdr(struct iavf_fdir_fltr *fltr,
 		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, IPV6, DST);
 	}
 
+	fltr->ip_ver = 6;
+
 	return 0;
 }
 
@@ -152,7 +360,10 @@ iavf_fill_fdir_udp_hdr(struct iavf_fdir_fltr *fltr,
 		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, UDP, DST_PORT);
 	}
 
-	return 0;
+	if (!fltr->flex_cnt)
+		return 0;
+
+	return iavf_fill_fdir_udp_flex_pay_hdr(fltr, proto_hdrs);
 }
 
 /**
@@ -511,7 +722,9 @@ bool iavf_fdir_is_dup_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *
 		if (!memcmp(&tmp->eth_data, &fltr->eth_data,
 			    sizeof(fltr->eth_data)) &&
 		    !memcmp(&tmp->ip_data, &fltr->ip_data,
-			    sizeof(fltr->ip_data))) {
+			    sizeof(fltr->ip_data)) &&
+		    !memcmp(&tmp->ext_data, &fltr->ext_data,
+			    sizeof(fltr->ext_data))) {
 			ret = true;
 			break;
 		}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.h b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
index ad75b89cb207..2439c970b657 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
@@ -35,6 +35,11 @@ enum iavf_fdir_flow_type {
 	IAVF_FDIR_FLOW_PTYPE_MAX,
 };
 
+struct iavf_flex_word {
+	u16 offset;
+	u16 word;
+};
+
 struct iavf_ipv4_addrs {
 	__be32 src_ip;
 	__be32 dst_ip;
@@ -64,6 +69,11 @@ struct iavf_fdir_ip {
 	};
 	u8 proto;
 };
+
+struct iavf_fdir_extra {
+	u32 usr_def[2];
+};
+
 /* bookkeeping of Flow Director filters */
 struct iavf_fdir_fltr {
 	enum iavf_fdir_fltr_state_t state;
@@ -77,7 +87,16 @@ struct iavf_fdir_fltr {
 	struct iavf_fdir_ip ip_data;
 	struct iavf_fdir_ip ip_mask;
 
+	struct iavf_fdir_extra ext_data;
+	struct iavf_fdir_extra ext_mask;
+
 	enum virtchnl_action action;
+
+	/* flex byte filter data */
+	u8 ip_ver; /* used to adjust the flex offset, 4 : IPv4, 6 : IPv6 */
+	u8 flex_cnt;
+	struct iavf_flex_word flex_words[2];
+
 	u32 flow_id;
 
 	u32 loc;	/* Rule location inside the flow table */
-- 
2.26.2

