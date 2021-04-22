Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699D43685F3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbhDVRar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:60043 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238574AbhDVRaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:15 -0400
IronPort-SDR: DnVlVlrJIfzXCOdSp2xlzuP1hHSf18eYmQaGv+msXoEf5i8s3+RcJn91xE9MuoHHKF2XzDk9Tw
 s7Y7VUnA4Bhw==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991488"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991488"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:36 -0700
IronPort-SDR: TYWWHzu1m91WWFmrOZmOC4BzFCBYXizaWvX9SM/A51AzBBat0WGSjW/iXW3vM9k31B8Ipe4TzK
 ZlCefjgVpiUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286294"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 12/12] iavf: Support for modifying SCTP RSS flow hashing
Date:   Thu, 22 Apr 2021 10:31:30 -0700
Message-Id: <20210422173130.1143082-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Provide the ability to enable SCTP RSS hashing by ethtool.

It gives users option of generating RSS hash based on the SCTP source
and destination ports numbers, IPv4 or IPv6 source and destination
addresses.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_adv_rss.c    | 28 +++++++++++++++++--
 .../net/ethernet/intel/iavf/iavf_adv_rss.h    | 10 ++++++-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 23 +++++++++++++--
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
index a8e03aaccc6b..6edbf134b73f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
@@ -73,6 +73,23 @@ iavf_fill_adv_rss_udp_hdr(struct virtchnl_proto_hdr *hdr, u64 hash_flds)
 		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, UDP, DST_PORT);
 }
 
+/**
+ * iavf_fill_adv_rss_sctp_hdr - fill the SCTP RSS protocol header
+ * @hdr: the virtchnl message protocol header data structure
+ * @hash_flds: the RSS configuration protocol hash fields
+ */
+static void
+iavf_fill_adv_rss_sctp_hdr(struct virtchnl_proto_hdr *hdr, u64 hash_flds)
+{
+	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, SCTP);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_SCTP_SRC_PORT)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, SCTP, SRC_PORT);
+
+	if (hash_flds & IAVF_ADV_RSS_HASH_FLD_SCTP_DST_PORT)
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, SCTP, DST_PORT);
+}
+
 /**
  * iavf_fill_adv_rss_cfg_msg - fill the RSS configuration into virtchnl message
  * @rss_cfg: the virtchnl message to be filled with RSS configuration setting
@@ -112,6 +129,9 @@ iavf_fill_adv_rss_cfg_msg(struct virtchnl_rss_cfg *rss_cfg,
 	case IAVF_ADV_RSS_FLOW_SEG_HDR_UDP:
 		iavf_fill_adv_rss_udp_hdr(hdr, hash_flds);
 		break;
+	case IAVF_ADV_RSS_FLOW_SEG_HDR_SCTP:
+		iavf_fill_adv_rss_sctp_hdr(hdr, hash_flds);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -160,6 +180,8 @@ iavf_print_adv_rss_cfg(struct iavf_adapter *adapter, struct iavf_adv_rss *rss,
 		proto = "TCP";
 	else if (packet_hdrs & IAVF_ADV_RSS_FLOW_SEG_HDR_UDP)
 		proto = "UDP";
+	else if (packet_hdrs & IAVF_ADV_RSS_FLOW_SEG_HDR_SCTP)
+		proto = "SCTP";
 	else
 		return;
 
@@ -178,10 +200,12 @@ iavf_print_adv_rss_cfg(struct iavf_adapter *adapter, struct iavf_adv_rss *rss,
 			 IAVF_ADV_RSS_HASH_FLD_IPV6_DA))
 		strcat(hash_opt, "IP DA,");
 	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT |
-			 IAVF_ADV_RSS_HASH_FLD_UDP_SRC_PORT))
+			 IAVF_ADV_RSS_HASH_FLD_UDP_SRC_PORT |
+			 IAVF_ADV_RSS_HASH_FLD_SCTP_SRC_PORT))
 		strcat(hash_opt, "src port,");
 	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT |
-			 IAVF_ADV_RSS_HASH_FLD_UDP_DST_PORT))
+			 IAVF_ADV_RSS_HASH_FLD_UDP_DST_PORT |
+			 IAVF_ADV_RSS_HASH_FLD_SCTP_DST_PORT))
 		strcat(hash_opt, "dst port,");
 
 	if (!action)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
index 4681f5e8321d..4d3be11af7aa 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
@@ -21,6 +21,7 @@ enum iavf_adv_rss_flow_seg_hdr {
 	IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6	= 0x00000002,
 	IAVF_ADV_RSS_FLOW_SEG_HDR_TCP	= 0x00000004,
 	IAVF_ADV_RSS_FLOW_SEG_HDR_UDP	= 0x00000008,
+	IAVF_ADV_RSS_FLOW_SEG_HDR_SCTP	= 0x00000010,
 };
 
 #define IAVF_ADV_RSS_FLOW_SEG_HDR_L3		\
@@ -29,7 +30,8 @@ enum iavf_adv_rss_flow_seg_hdr {
 
 #define IAVF_ADV_RSS_FLOW_SEG_HDR_L4		\
 	(IAVF_ADV_RSS_FLOW_SEG_HDR_TCP |	\
-	 IAVF_ADV_RSS_FLOW_SEG_HDR_UDP)
+	 IAVF_ADV_RSS_FLOW_SEG_HDR_UDP |	\
+	 IAVF_ADV_RSS_FLOW_SEG_HDR_SCTP)
 
 enum iavf_adv_rss_flow_field {
 	/* L3 */
@@ -42,6 +44,8 @@ enum iavf_adv_rss_flow_field {
 	IAVF_ADV_RSS_FLOW_FIELD_IDX_TCP_DST_PORT,
 	IAVF_ADV_RSS_FLOW_FIELD_IDX_UDP_SRC_PORT,
 	IAVF_ADV_RSS_FLOW_FIELD_IDX_UDP_DST_PORT,
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_SCTP_SRC_PORT,
+	IAVF_ADV_RSS_FLOW_FIELD_IDX_SCTP_DST_PORT,
 
 	/* The total number of enums must not exceed 64 */
 	IAVF_ADV_RSS_FLOW_FIELD_IDX_MAX
@@ -64,6 +68,10 @@ enum iavf_adv_rss_flow_field {
 	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_UDP_SRC_PORT)
 #define IAVF_ADV_RSS_HASH_FLD_UDP_DST_PORT	\
 	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_UDP_DST_PORT)
+#define IAVF_ADV_RSS_HASH_FLD_SCTP_SRC_PORT	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_SCTP_SRC_PORT)
+#define IAVF_ADV_RSS_HASH_FLD_SCTP_DST_PORT	\
+	BIT_ULL(IAVF_ADV_RSS_FLOW_FIELD_IDX_SCTP_DST_PORT)
 
 /* bookkeeping of advanced RSS configuration */
 struct iavf_adv_rss {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index e6169a336694..3d904bc6ee76 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1438,6 +1438,10 @@ static u32 iavf_adv_rss_parse_hdrs(struct ethtool_rxnfc *cmd)
 		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_UDP |
 			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4;
 		break;
+	case SCTP_V4_FLOW:
+		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_SCTP |
+			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV4;
+		break;
 	case TCP_V6_FLOW:
 		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_TCP |
 			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6;
@@ -1446,6 +1450,10 @@ static u32 iavf_adv_rss_parse_hdrs(struct ethtool_rxnfc *cmd)
 		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_UDP |
 			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6;
 		break;
+	case SCTP_V6_FLOW:
+		hdrs |= IAVF_ADV_RSS_FLOW_SEG_HDR_SCTP |
+			IAVF_ADV_RSS_FLOW_SEG_HDR_IPV6;
+		break;
 	default:
 		break;
 	}
@@ -1468,6 +1476,7 @@ static u64 iavf_adv_rss_parse_hash_flds(struct ethtool_rxnfc *cmd)
 		switch (cmd->flow_type) {
 		case TCP_V4_FLOW:
 		case UDP_V4_FLOW:
+		case SCTP_V4_FLOW:
 			if (cmd->data & RXH_IP_SRC)
 				hfld |= IAVF_ADV_RSS_HASH_FLD_IPV4_SA;
 			if (cmd->data & RXH_IP_DST)
@@ -1475,6 +1484,7 @@ static u64 iavf_adv_rss_parse_hash_flds(struct ethtool_rxnfc *cmd)
 			break;
 		case TCP_V6_FLOW:
 		case UDP_V6_FLOW:
+		case SCTP_V6_FLOW:
 			if (cmd->data & RXH_IP_SRC)
 				hfld |= IAVF_ADV_RSS_HASH_FLD_IPV6_SA;
 			if (cmd->data & RXH_IP_DST)
@@ -1501,6 +1511,13 @@ static u64 iavf_adv_rss_parse_hash_flds(struct ethtool_rxnfc *cmd)
 			if (cmd->data & RXH_L4_B_2_3)
 				hfld |= IAVF_ADV_RSS_HASH_FLD_UDP_DST_PORT;
 			break;
+		case SCTP_V4_FLOW:
+		case SCTP_V6_FLOW:
+			if (cmd->data & RXH_L4_B_0_1)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_SCTP_SRC_PORT;
+			if (cmd->data & RXH_L4_B_2_3)
+				hfld |= IAVF_ADV_RSS_HASH_FLD_SCTP_DST_PORT;
+			break;
 		default:
 			break;
 		}
@@ -1635,11 +1652,13 @@ iavf_get_adv_rss_hash_opt(struct iavf_adapter *adapter,
 		cmd->data |= (u64)RXH_IP_DST;
 
 	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_TCP_SRC_PORT |
-			 IAVF_ADV_RSS_HASH_FLD_UDP_SRC_PORT))
+			 IAVF_ADV_RSS_HASH_FLD_UDP_SRC_PORT |
+			 IAVF_ADV_RSS_HASH_FLD_SCTP_SRC_PORT))
 		cmd->data |= (u64)RXH_L4_B_0_1;
 
 	if (hash_flds & (IAVF_ADV_RSS_HASH_FLD_TCP_DST_PORT |
-			 IAVF_ADV_RSS_HASH_FLD_UDP_DST_PORT))
+			 IAVF_ADV_RSS_HASH_FLD_UDP_DST_PORT |
+			 IAVF_ADV_RSS_HASH_FLD_SCTP_DST_PORT))
 		cmd->data |= (u64)RXH_L4_B_2_3;
 
 	return 0;
-- 
2.26.2

