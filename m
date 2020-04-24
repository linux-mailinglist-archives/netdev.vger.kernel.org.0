Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC191B6F06
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgDXH2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26496 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgDXH2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7PoCP021067;
        Fri, 24 Apr 2020 00:28:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7J69JTbhlKZvYCoK3TDoon5JSHGT+d5iX1Dh51gcJ6o=;
 b=cFZebA0kpKp3G5Z2dajJ6fPradZ7dvwT8uffhXlo4RNxinlQUrm+dOXmQY8oJJDJESac
 poFUzUVU3Wp9yS97Q7wquoygmtFW2syfDq/Fxjg4eSiTiNpEYrG0nLGZbYyigWVod/vN
 sajk8kx3h1/tKCEUeZS7aEPV9IQCNpXVRnuF7HJfa6pjuubAh5+e77tOX6qc+9ZJtTHl
 WS2BxZwrSo7XnFBwwaQY5WI996ErpK+mcWtk3ICEQ2ncBj4SWpqNlcMFlDR+reN/leGw
 SxPTS0G0L139TR14UFgXEweGchGgtY3ubhuChs59Fw8N5CmlqMeYUPZPUkVfgtfAnqGn vQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb48s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:11 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id AC5AA3F703F;
        Fri, 24 Apr 2020 00:28:09 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>
Subject: [PATCH net-next 13/17] net: atlantic: add A2 RPF hw_ops
Date:   Fri, 24 Apr 2020 10:27:25 +0300
Message-ID: <20200424072729.953-14-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds RPF-related hw_ops, which are needed for basic
functionality.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Co-developed-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 208 ++++++++++++++++++
 .../atlantic/hw_atl2/hw_atl2_internal.h       |  49 +++++
 3 files changed, 259 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 5513254642b3..5db57ea9a5bd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -360,6 +360,8 @@ struct aq_rx_filter_vlan {
 	u8 queue;
 };
 
+#define HW_ATL_VLAN_MAX_FILTERS         16U
+
 struct aq_rx_filter_l2 {
 	s8 queue;
 	u8 location;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 58c74a73b6cf..7dd5f9a1c505 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -4,9 +4,17 @@
  */
 
 #include "aq_hw.h"
+#include "aq_hw_utils.h"
+#include "aq_nic.h"
+#include "hw_atl/hw_atl_utils.h"
+#include "hw_atl/hw_atl_llh.h"
 #include "hw_atl2_utils.h"
+#include "hw_atl2_llh.h"
 #include "hw_atl2_internal.h"
 
+static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
+				       u32 tag, u32 mask, u32 action);
+
 #define DEFAULT_BOARD_BASIC_CAPABILITIES \
 	.is_64_dma = true,		  \
 	.msix_irqs = 8U,		  \
@@ -55,6 +63,11 @@ const struct aq_hw_caps_s hw_atl2_caps_aqc113 = {
 			  AQ_NIC_RATE_10M,
 };
 
+static u32 hw_atl2_sem_act_rslvr_get(struct aq_hw_s *self)
+{
+	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL2_FW_SM_ACT_RSLVR);
+}
+
 static int hw_atl2_hw_reset(struct aq_hw_s *self)
 {
 	return -EOPNOTSUPP;
@@ -78,6 +91,60 @@ static int hw_atl2_hw_offload_set(struct aq_hw_s *self,
 	return -EOPNOTSUPP;
 }
 
+static void hw_atl2_hw_new_rx_filter_vlan_promisc(struct aq_hw_s *self,
+						  bool promisc)
+{
+	u16 off_action = (!promisc &&
+			  !hw_atl_rpfl2promiscuous_mode_en_get(self)) ?
+				HW_ATL2_ACTION_DROP : HW_ATL2_ACTION_DISABLE;
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	u8 index;
+
+	index = priv->art_base_index + HW_ATL2_RPF_VLAN_PROMISC_OFF_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, 0,
+				    HW_ATL2_RPF_TAG_VLAN_MASK |
+				    HW_ATL2_RPF_TAG_UNTAG_MASK, off_action);
+}
+
+static void hw_atl2_hw_new_rx_filter_promisc(struct aq_hw_s *self, bool promisc)
+{
+	u16 off_action = promisc ? HW_ATL2_ACTION_DISABLE : HW_ATL2_ACTION_DROP;
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	bool vlan_promisc_enable;
+	u8 index;
+
+	index = priv->art_base_index + HW_ATL2_RPF_L2_PROMISC_OFF_INDEX;
+	hw_atl2_act_rslvr_table_set(self, index, 0,
+				    HW_ATL2_RPF_TAG_UC_MASK |
+				    HW_ATL2_RPF_TAG_ALLMC_MASK,
+				    off_action);
+
+	/* turn VLAN promisc mode too */
+	vlan_promisc_enable = hw_atl_rpf_vlan_prom_mode_en_get(self);
+	hw_atl2_hw_new_rx_filter_vlan_promisc(self, promisc |
+					      vlan_promisc_enable);
+}
+
+static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
+				       u32 tag, u32 mask, u32 action)
+{
+	u32 val;
+	int err;
+
+	err = readx_poll_timeout_atomic(hw_atl2_sem_act_rslvr_get,
+					self, val, val == 1,
+					1, 10000U);
+	if (err)
+		return err;
+
+	hw_atl2_rpf_act_rslvr_record_set(self, location, tag, mask,
+					 action);
+
+	hw_atl_reg_glb_cpu_sem_set(self, 1, HW_ATL2_FW_SM_ACT_RSLVR);
+
+	return err;
+}
+
 static int hw_atl2_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 {
 	return -EOPNOTSUPP;
@@ -170,6 +237,88 @@ static int hw_atl2_hw_irq_read(struct aq_hw_s *self, u64 *mask)
 	return -EOPNOTSUPP;
 }
 
+#define IS_FILTER_ENABLED(_F_) ((packet_filter & (_F_)) ? 1U : 0U)
+
+static int hw_atl2_hw_packet_filter_set(struct aq_hw_s *self,
+					unsigned int packet_filter)
+{
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+	u32 vlan_promisc;
+	u32 l2_promisc;
+	unsigned int i;
+
+	l2_promisc = IS_FILTER_ENABLED(IFF_PROMISC) ||
+		     !!(cfg->priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET));
+	vlan_promisc = l2_promisc || cfg->is_vlan_force_promisc;
+
+	hw_atl_rpfl2promiscuous_mode_en_set(self, l2_promisc);
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self, vlan_promisc);
+
+	hw_atl2_hw_new_rx_filter_promisc(self, IS_FILTER_ENABLED(IFF_PROMISC));
+
+	hw_atl_rpfl2multicast_flr_en_set(self,
+					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
+
+	hw_atl_rpfl2_accept_all_mc_packets_set(self,
+					      IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					      IS_FILTER_ENABLED(IFF_MULTICAST));
+
+	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
+
+	for (i = HW_ATL2_MAC_MIN; i < HW_ATL2_MAC_MAX; ++i)
+		hw_atl_rpfl2_uc_flr_en_set(self,
+					   (cfg->is_mc_list_enabled &&
+					    (i <= cfg->mc_list_count)) ?
+				    1U : 0U, i);
+
+	return aq_hw_err_from_flags(self);
+}
+
+#undef IS_FILTER_ENABLED
+
+static int hw_atl2_hw_multicast_list_set(struct aq_hw_s *self,
+					 u8 ar_mac
+					 [AQ_HW_MULTICAST_ADDRESS_MAX]
+					 [ETH_ALEN],
+					 u32 count)
+{
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+	int err = 0;
+
+	if (count > (HW_ATL2_MAC_MAX - HW_ATL2_MAC_MIN)) {
+		err = -EBADRQC;
+		goto err_exit;
+	}
+	for (cfg->mc_list_count = 0U;
+			cfg->mc_list_count < count;
+			++cfg->mc_list_count) {
+		u32 i = cfg->mc_list_count;
+		u32 h = (ar_mac[i][0] << 8) | (ar_mac[i][1]);
+		u32 l = (ar_mac[i][2] << 24) | (ar_mac[i][3] << 16) |
+					(ar_mac[i][4] << 8) | ar_mac[i][5];
+
+		hw_atl_rpfl2_uc_flr_en_set(self, 0U, HW_ATL2_MAC_MIN + i);
+
+		hw_atl_rpfl2unicast_dest_addresslsw_set(self, l,
+							HW_ATL2_MAC_MIN + i);
+
+		hw_atl_rpfl2unicast_dest_addressmsw_set(self, h,
+							HW_ATL2_MAC_MIN + i);
+
+		hw_atl2_rpfl2_uc_flr_tag_set(self, 1, HW_ATL2_MAC_MIN + i);
+
+		hw_atl_rpfl2_uc_flr_en_set(self, (cfg->is_mc_list_enabled),
+					   HW_ATL2_MAC_MIN + i);
+	}
+
+	err = aq_hw_err_from_flags(self);
+
+err_exit:
+	return err;
+}
+
 static int hw_atl2_hw_interrupt_moderation_set(struct aq_hw_s *self)
 {
 	return -EOPNOTSUPP;
@@ -195,6 +344,61 @@ static struct aq_stats_s *hw_atl2_utils_get_hw_stats(struct aq_hw_s *self)
 	return &self->curr_stats;
 }
 
+static int hw_atl2_hw_vlan_set(struct aq_hw_s *self,
+			       struct aq_rx_filter_vlan *aq_vlans)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	u32 queue;
+	u8 index;
+	int i;
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self, 1U);
+
+	for (i = 0; i < HW_ATL_VLAN_MAX_FILTERS; i++) {
+		queue = HW_ATL2_ACTION_ASSIGN_QUEUE(aq_vlans[i].queue);
+
+		hw_atl_rpf_vlan_flr_en_set(self, 0U, i);
+		hw_atl_rpf_vlan_rxq_en_flr_set(self, 0U, i);
+		index = priv->art_base_index + HW_ATL2_RPF_VLAN_USER_INDEX + i;
+		hw_atl2_act_rslvr_table_set(self, index, 0, 0,
+					    HW_ATL2_ACTION_DISABLE);
+		if (aq_vlans[i].enable) {
+			hw_atl_rpf_vlan_id_flr_set(self,
+						   aq_vlans[i].vlan_id, i);
+			hw_atl_rpf_vlan_flr_act_set(self, 1U, i);
+			hw_atl_rpf_vlan_flr_en_set(self, 1U, i);
+
+			if (aq_vlans[i].queue != 0xFF) {
+				hw_atl_rpf_vlan_rxq_flr_set(self,
+							    aq_vlans[i].queue,
+							    i);
+				hw_atl_rpf_vlan_rxq_en_flr_set(self, 1U, i);
+
+				hw_atl2_rpf_vlan_flr_tag_set(self, i + 2, i);
+
+				index = priv->art_base_index +
+					HW_ATL2_RPF_VLAN_USER_INDEX + i;
+				hw_atl2_act_rslvr_table_set(self, index,
+					(i + 2) << HW_ATL2_RPF_TAG_VLAN_OFFSET,
+					HW_ATL2_RPF_TAG_VLAN_MASK, queue);
+			} else {
+				hw_atl2_rpf_vlan_flr_tag_set(self, 1, i);
+			}
+		}
+	}
+
+	return aq_hw_err_from_flags(self);
+}
+
+static int hw_atl2_hw_vlan_ctrl(struct aq_hw_s *self, bool enable)
+{
+	/* set promisc in case of disabing the vlan filter */
+	hw_atl_rpf_vlan_prom_mode_en_set(self, !enable);
+	hw_atl2_hw_new_rx_filter_vlan_promisc(self, !enable);
+
+	return aq_hw_err_from_flags(self);
+}
+
 const struct aq_hw_ops hw_atl2_ops = {
 	.hw_set_mac_address   = hw_atl2_hw_mac_addr_set,
 	.hw_init              = hw_atl2_hw_init,
@@ -218,6 +422,10 @@ const struct aq_hw_ops hw_atl2_ops = {
 
 	.hw_ring_rx_init             = hw_atl2_hw_ring_rx_init,
 	.hw_ring_tx_init             = hw_atl2_hw_ring_tx_init,
+	.hw_packet_filter_set        = hw_atl2_hw_packet_filter_set,
+	.hw_filter_vlan_set          = hw_atl2_hw_vlan_set,
+	.hw_filter_vlan_ctrl         = hw_atl2_hw_vlan_ctrl,
+	.hw_multicast_list_set       = hw_atl2_hw_multicast_list_set,
 	.hw_interrupt_moderation_set = hw_atl2_hw_interrupt_moderation_set,
 	.hw_rss_set                  = hw_atl2_hw_rss_set,
 	.hw_rss_hash_set             = hw_atl2_hw_rss_hash_set,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index f82058484332..dccc89df2223 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -18,6 +18,10 @@
 #define HW_ATL2_TXD_SIZE       (16U)
 #define HW_ATL2_RXD_SIZE       (16U)
 
+#define HW_ATL2_MAC_UC   0U
+#define HW_ATL2_MAC_MIN  1U
+#define HW_ATL2_MAC_MAX  38U
+
 #define HW_ATL2_TC_MAX 1U
 #define HW_ATL2_RSS_MAX 8U
 
@@ -29,6 +33,51 @@
 #define HW_ATL2_MAX_RXD 8184U
 #define HW_ATL2_MAX_TXD 8184U
 
+#define HW_ATL2_FW_SM_ACT_RSLVR  0x3U
+
+#define HW_ATL2_RPF_TAG_UC_OFFSET      0x0
+#define HW_ATL2_RPF_TAG_ALLMC_OFFSET   0x6
+#define HW_ATL2_RPF_TAG_ET_OFFSET      0x7
+#define HW_ATL2_RPF_TAG_VLAN_OFFSET    0xA
+#define HW_ATL2_RPF_TAG_UNTAG_OFFSET   0xE
+#define HW_ATL2_RPF_TAG_L3_V4_OFFSET   0xF
+#define HW_ATL2_RPF_TAG_L3_V6_OFFSET   0x12
+#define HW_ATL2_RPF_TAG_L4_OFFSET      0x15
+#define HW_ATL2_RPF_TAG_L4_FLEX_OFFSET 0x18
+#define HW_ATL2_RPF_TAG_FLEX_OFFSET    0x1B
+#define HW_ATL2_RPF_TAG_PCP_OFFSET     0x1D
+
+#define HW_ATL2_RPF_TAG_UC_MASK    (0x0000003F << HW_ATL2_RPF_TAG_UC_OFFSET)
+#define HW_ATL2_RPF_TAG_ALLMC_MASK (0x00000001 << HW_ATL2_RPF_TAG_ALLMC_OFFSET)
+#define HW_ATL2_RPF_TAG_UNTAG_MASK (0x00000001 << HW_ATL2_RPF_TAG_UNTAG_OFFSET)
+#define HW_ATL2_RPF_TAG_VLAN_MASK  (0x0000000F << HW_ATL2_RPF_TAG_VLAN_OFFSET)
+#define HW_ATL2_RPF_TAG_ET_MASK    (0x00000007 << HW_ATL2_RPF_TAG_ET_OFFSET)
+#define HW_ATL2_RPF_TAG_L3_V4_MASK (0x00000007 << HW_ATL2_RPF_TAG_L3_V4_OFFSET)
+#define HW_ATL2_RPF_TAG_L3_V6_MASK (0x00000007 << HW_ATL2_RPF_TAG_L3_V6_OFFSET)
+#define HW_ATL2_RPF_TAG_L4_MASK    (0x00000007 << HW_ATL2_RPF_TAG_L4_OFFSET)
+#define HW_ATL2_RPF_TAG_PCP_MASK   (0x00000007 << HW_ATL2_RPF_TAG_PCP_OFFSET)
+
+enum HW_ATL2_RPF_ART_INDEX {
+	HW_ATL2_RPF_L2_PROMISC_OFF_INDEX,
+	HW_ATL2_RPF_VLAN_PROMISC_OFF_INDEX,
+	HW_ATL2_RPF_L3L4_USER_INDEX	= 8,
+	HW_ATL2_RPF_ET_PCP_USER_INDEX	= HW_ATL2_RPF_L3L4_USER_INDEX + 16,
+	HW_ATL2_RPF_VLAN_USER_INDEX	= HW_ATL2_RPF_ET_PCP_USER_INDEX + 16,
+	HW_ATL2_RPF_PCP_TO_TC_INDEX	= HW_ATL2_RPF_VLAN_USER_INDEX +
+					  HW_ATL_VLAN_MAX_FILTERS,
+};
+
+#define HW_ATL2_ACTION(ACTION, RSS, INDEX, VALID) \
+	((((ACTION) & 0x3U) << 8) | \
+	(((RSS) & 0x1U) << 7) | \
+	(((INDEX) & 0x3FU) << 2) | \
+	(((VALID) & 0x1U) << 0))
+
+#define HW_ATL2_ACTION_DROP HW_ATL2_ACTION(0, 0, 0, 1)
+#define HW_ATL2_ACTION_DISABLE HW_ATL2_ACTION(0, 0, 0, 0)
+#define HW_ATL2_ACTION_ASSIGN_QUEUE(QUEUE) HW_ATL2_ACTION(1, 0, (QUEUE), 1)
+#define HW_ATL2_ACTION_ASSIGN_TC(TC) HW_ATL2_ACTION(1, 1, (TC), 1)
+
 struct hw_atl2_priv {
 	struct statistics_s last_stats;
 	unsigned int art_base_index;
-- 
2.17.1

