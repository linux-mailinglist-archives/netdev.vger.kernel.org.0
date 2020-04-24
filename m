Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D5D1B6F09
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgDXH21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46444 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgDXH20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7QNXD021199;
        Fri, 24 Apr 2020 00:28:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=lSP4cSsZNXjjTSOqPVAZ2Z+it2GkqAr5hdEQnVBNFBs=;
 b=HwQNJWE/xQExBNi78QXY4mSMOhWkHA3ciEXXjcixfc5n/6w6RWkpmuiyTTRpaNg0alAd
 Y7TA9Fy/uCXmxBWv9dCOE3OpACguLx4z1PdpIrvKKkrxuGbKUUAWrUL/GNR4i9gD7E95
 q1EtusGLGCPWwrWvVuRByUx1tZiqkejl441lW/QuRL9e9EFxDNTMF2zv2QAm/osepv79
 OTmo0xB/NhwBtZxmOES/B07YeEFIw8lq4+7yXfxCRUT397UWJMwnuzCzy+DjJkouyRL5
 hH2atMvbfEGfEtSJ1yOMgckaAcDLsL0h8k/tYMA3rYgkDDL+lXSNOyiVHhhW60bwtfFY Rw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb49j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:21 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id E63423F703F;
        Fri, 24 Apr 2020 00:28:19 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 17/17] net: atlantic: A2 ingress / egress hw configuration
Date:   Fri, 24 Apr 2020 10:27:29 +0300
Message-ID: <20200424072729.953-18-irusskikh@marvell.com>
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

Chip generations are mostly compatible register-wise, but there are still
some differences. Therefore we've made some of first generation (A1) code
non-static to re-use it where possible.

Some pieces are A2 specific, in which case we redefine/extend such APIs.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  54 +++---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  23 +++
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 176 ++++++++++--------
 .../atlantic/hw_atl2/hw_atl2_internal.h       |   3 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |   8 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |   5 +
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   |   8 +
 7 files changed, 172 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index c46199f14ec4..cbb7a00d61b4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -251,9 +251,10 @@ int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
 	return err;
 }
 
-static int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
-				    struct aq_nic_cfg_s *aq_nic_cfg)
+int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
+			     struct aq_nic_cfg_s *aq_nic_cfg)
 {
+	u64 rxcsum = !!(aq_nic_cfg->features & NETIF_F_RXCSUM);
 	unsigned int i;
 
 	/* TX checksums offloads*/
@@ -261,10 +262,8 @@ static int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 	hw_atl_tpo_tcp_udp_crc_offload_en_set(self, 1);
 
 	/* RX checksums offloads*/
-	hw_atl_rpo_ipv4header_crc_offload_en_set(self, !!(aq_nic_cfg->features &
-						 NETIF_F_RXCSUM));
-	hw_atl_rpo_tcp_udp_crc_offload_en_set(self, !!(aq_nic_cfg->features &
-					      NETIF_F_RXCSUM));
+	hw_atl_rpo_ipv4header_crc_offload_en_set(self, rxcsum);
+	hw_atl_rpo_tcp_udp_crc_offload_en_set(self, rxcsum);
 
 	/* LSO offloads*/
 	hw_atl_tdm_large_send_offload_en_set(self, 0xFFFFFFFFU);
@@ -272,7 +271,7 @@ static int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 	/* Outer VLAN tag offload */
 	hw_atl_rpo_outer_vlan_tag_mode_set(self, 1U);
 
-/* LRO offloads */
+	/* LRO offloads */
 	{
 		unsigned int val = (8U < HW_ATL_B0_LRO_RXD_MAX) ? 0x3U :
 			((4U < HW_ATL_B0_LRO_RXD_MAX) ? 0x2U :
@@ -384,7 +383,7 @@ static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
+int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 {
 	unsigned int h = 0U;
 	unsigned int l = 0U;
@@ -479,16 +478,14 @@ static int hw_atl_b0_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 	return err;
 }
 
-static int hw_atl_b0_hw_ring_tx_start(struct aq_hw_s *self,
-				      struct aq_ring_s *ring)
+int hw_atl_b0_hw_ring_tx_start(struct aq_hw_s *self, struct aq_ring_s *ring)
 {
 	hw_atl_tdm_tx_desc_en_set(self, 1, ring->idx);
 
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_ring_rx_start(struct aq_hw_s *self,
-				      struct aq_ring_s *ring)
+int hw_atl_b0_hw_ring_rx_start(struct aq_hw_s *self, struct aq_ring_s *ring)
 {
 	hw_atl_rdm_rx_desc_en_set(self, 1, ring->idx);
 
@@ -511,9 +508,8 @@ static int hw_atl_b0_hw_tx_ring_tail_update(struct aq_hw_s *self,
 	return 0;
 }
 
-static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *self,
-				     struct aq_ring_s *ring,
-				     unsigned int frags)
+int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *self, struct aq_ring_s *ring,
+			      unsigned int frags)
 {
 	struct aq_ring_buff_s *buff = NULL;
 	struct hw_atl_txd_s *txd = NULL;
@@ -600,9 +596,8 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_ring_rx_init(struct aq_hw_s *self,
-				     struct aq_ring_s *aq_ring,
-				     struct aq_ring_param_s *aq_ring_param)
+int hw_atl_b0_hw_ring_rx_init(struct aq_hw_s *self, struct aq_ring_s *aq_ring,
+			      struct aq_ring_param_s *aq_ring_param)
 {
 	u32 dma_desc_addr_msw = (u32)(((u64)aq_ring->dx_ring_pa) >> 32);
 	u32 vlan_rx_stripping = self->aq_nic_cfg->is_vlan_rx_strip;
@@ -643,9 +638,8 @@ static int hw_atl_b0_hw_ring_rx_init(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_ring_tx_init(struct aq_hw_s *self,
-				     struct aq_ring_s *aq_ring,
-				     struct aq_ring_param_s *aq_ring_param)
+int hw_atl_b0_hw_ring_tx_init(struct aq_hw_s *self, struct aq_ring_s *aq_ring,
+			      struct aq_ring_param_s *aq_ring_param)
 {
 	u32 dma_desc_msw_addr = (u32)(((u64)aq_ring->dx_ring_pa) >> 32);
 	u32 dma_desc_lsw_addr = (u32)aq_ring->dx_ring_pa;
@@ -673,9 +667,8 @@ static int hw_atl_b0_hw_ring_tx_init(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_ring_rx_fill(struct aq_hw_s *self,
-				     struct aq_ring_s *ring,
-				     unsigned int sw_tail_old)
+int hw_atl_b0_hw_ring_rx_fill(struct aq_hw_s *self, struct aq_ring_s *ring,
+			      unsigned int sw_tail_old)
 {
 	for (; sw_tail_old != ring->sw_tail;
 		sw_tail_old = aq_ring_next_dx(ring, sw_tail_old)) {
@@ -734,8 +727,8 @@ static int hw_atl_b0_hw_ring_hwts_rx_receive(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
-					    struct aq_ring_s *ring)
+int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
+				     struct aq_ring_s *ring)
 {
 	unsigned int hw_head_;
 	int err = 0;
@@ -753,8 +746,7 @@ static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 	return err;
 }
 
-static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self,
-					struct aq_ring_s *ring)
+int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self, struct aq_ring_s *ring)
 {
 	for (; ring->hw_head != ring->sw_tail;
 		ring->hw_head = aq_ring_next_dx(ring, ring->hw_head)) {
@@ -1071,16 +1063,14 @@ static int hw_atl_b0_hw_stop(struct aq_hw_s *self)
 	return err;
 }
 
-static int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self,
-				     struct aq_ring_s *ring)
+int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
 {
 	hw_atl_tdm_tx_desc_en_set(self, 0U, ring->idx);
 
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self,
-				     struct aq_ring_s *ring)
+int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
 {
 	hw_atl_rdm_rx_desc_en_set(self, 0U, ring->idx);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index ea7136b06b32..f5091d79ab43 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -37,6 +37,29 @@ int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *self,
 			      struct aq_rss_parameters *rss_params);
 int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
 			 struct aq_rss_parameters *rss_params);
+int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
+			     struct aq_nic_cfg_s *aq_nic_cfg);
+
+int hw_atl_b0_hw_ring_tx_start(struct aq_hw_s *self, struct aq_ring_s *ring);
+int hw_atl_b0_hw_ring_rx_start(struct aq_hw_s *self, struct aq_ring_s *ring);
+
+int hw_atl_b0_hw_ring_rx_init(struct aq_hw_s *self, struct aq_ring_s *aq_ring,
+			      struct aq_ring_param_s *aq_ring_param);
+int hw_atl_b0_hw_ring_rx_fill(struct aq_hw_s *self, struct aq_ring_s *ring,
+			      unsigned int sw_tail_old);
+int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s *self, struct aq_ring_s *ring);
+
+int hw_atl_b0_hw_ring_tx_init(struct aq_hw_s *self, struct aq_ring_s *aq_ring,
+			      struct aq_ring_param_s *aq_ring_param);
+int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *self, struct aq_ring_s *ring,
+			      unsigned int frags);
+int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
+				     struct aq_ring_s *ring);
+
+int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring);
+int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring);
+
+int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
 
 int hw_atl_b0_hw_start(struct aq_hw_s *self);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index de21d41c8c35..1e32ddc624dc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -5,6 +5,7 @@
 
 #include "aq_hw.h"
 #include "aq_hw_utils.h"
+#include "aq_ring.h"
 #include "aq_nic.h"
 #include "hw_atl/hw_atl_b0.h"
 #include "hw_atl/hw_atl_utils.h"
@@ -174,12 +175,6 @@ static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 	return hw_atl_b0_hw_rss_set(self, rss_params);
 }
 
-static int hw_atl2_hw_offload_set(struct aq_hw_s *self,
-				  struct aq_nic_cfg_s *aq_nic_cfg)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
 {
 	/* Tx TC/RSS number config */
@@ -358,11 +353,6 @@ static int hw_atl2_hw_init_rx_path(struct aq_hw_s *self)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl2_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 {
 	static u32 aq_hw_atl2_igcr_table_[4][2] = {
@@ -389,7 +379,7 @@ static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 	hw_atl2_hw_init_tx_path(self);
 	hw_atl2_hw_init_rx_path(self);
 
-	hw_atl2_hw_mac_addr_set(self, mac_addr);
+	hw_atl_b0_hw_mac_addr_set(self, mac_addr);
 
 	self->aq_fw_ops->set_link_speed(self, aq_nic_cfg->link_speed_msk);
 	self->aq_fw_ops->set_state(self, MPI_INIT);
@@ -423,61 +413,24 @@ static int hw_atl2_hw_init(struct aq_hw_s *self, u8 *mac_addr)
 				   ((HW_ATL2_ERR_INT << 0x10) |
 				    (1U << 0x17)), 0U);
 
-	hw_atl2_hw_offload_set(self, aq_nic_cfg);
+	hw_atl_b0_hw_offload_set(self, aq_nic_cfg);
 
 err_exit:
 	return err;
 }
 
-static int hw_atl2_hw_ring_tx_start(struct aq_hw_s *self,
-				    struct aq_ring_s *ring)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_ring_rx_start(struct aq_hw_s *self,
-				    struct aq_ring_s *ring)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_ring_tx_xmit(struct aq_hw_s *self,
-				   struct aq_ring_s *ring,
-				   unsigned int frags)
-{
-	return -EOPNOTSUPP;
-}
-
 static int hw_atl2_hw_ring_rx_init(struct aq_hw_s *self,
 				   struct aq_ring_s *aq_ring,
 				   struct aq_ring_param_s *aq_ring_param)
 {
-	return -EOPNOTSUPP;
+	return hw_atl_b0_hw_ring_rx_init(self, aq_ring, aq_ring_param);
 }
 
 static int hw_atl2_hw_ring_tx_init(struct aq_hw_s *self,
 				   struct aq_ring_s *aq_ring,
 				   struct aq_ring_param_s *aq_ring_param)
 {
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_ring_rx_fill(struct aq_hw_s *self, struct aq_ring_s *ring,
-				   unsigned int sw_tail_old)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_ring_tx_head_update(struct aq_hw_s *self,
-					  struct aq_ring_s *ring)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_ring_rx_receive(struct aq_hw_s *self,
-				      struct aq_ring_s *ring)
-{
-	return -EOPNOTSUPP;
+	return hw_atl_b0_hw_ring_tx_init(self, aq_ring, aq_ring_param);
 }
 
 #define IS_FILTER_ENABLED(_F_) ((packet_filter & (_F_)) ? 1U : 0U)
@@ -535,7 +488,94 @@ static int hw_atl2_hw_multicast_list_set(struct aq_hw_s *self,
 
 static int hw_atl2_hw_interrupt_moderation_set(struct aq_hw_s *self)
 {
-	return -EOPNOTSUPP;
+	unsigned int i = 0U;
+	u32 itr_tx = 2U;
+	u32 itr_rx = 2U;
+
+	switch (self->aq_nic_cfg->itr) {
+	case  AQ_CFG_INTERRUPT_MODERATION_ON:
+	case  AQ_CFG_INTERRUPT_MODERATION_AUTO:
+		hw_atl_tdm_tx_desc_wr_wb_irq_en_set(self, 0U);
+		hw_atl_tdm_tdm_intr_moder_en_set(self, 1U);
+		hw_atl_rdm_rx_desc_wr_wb_irq_en_set(self, 0U);
+		hw_atl_rdm_rdm_intr_moder_en_set(self, 1U);
+
+		if (self->aq_nic_cfg->itr == AQ_CFG_INTERRUPT_MODERATION_ON) {
+			/* HW timers are in 2us units */
+			int tx_max_timer = self->aq_nic_cfg->tx_itr / 2;
+			int tx_min_timer = tx_max_timer / 2;
+
+			int rx_max_timer = self->aq_nic_cfg->rx_itr / 2;
+			int rx_min_timer = rx_max_timer / 2;
+
+			tx_max_timer = min(HW_ATL2_INTR_MODER_MAX,
+					   tx_max_timer);
+			tx_min_timer = min(HW_ATL2_INTR_MODER_MIN,
+					   tx_min_timer);
+			rx_max_timer = min(HW_ATL2_INTR_MODER_MAX,
+					   rx_max_timer);
+			rx_min_timer = min(HW_ATL2_INTR_MODER_MIN,
+					   rx_min_timer);
+
+			itr_tx |= tx_min_timer << 0x8U;
+			itr_tx |= tx_max_timer << 0x10U;
+			itr_rx |= rx_min_timer << 0x8U;
+			itr_rx |= rx_max_timer << 0x10U;
+		} else {
+			static unsigned int hw_atl2_timers_table_tx_[][2] = {
+				{0xfU, 0xffU}, /* 10Gbit */
+				{0xfU, 0x1ffU}, /* 5Gbit */
+				{0xfU, 0x1ffU}, /* 5Gbit 5GS */
+				{0xfU, 0x1ffU}, /* 2.5Gbit */
+				{0xfU, 0x1ffU}, /* 1Gbit */
+				{0xfU, 0x1ffU}, /* 100Mbit */
+			};
+			static unsigned int hw_atl2_timers_table_rx_[][2] = {
+				{0x6U, 0x38U},/* 10Gbit */
+				{0xCU, 0x70U},/* 5Gbit */
+				{0xCU, 0x70U},/* 5Gbit 5GS */
+				{0x18U, 0xE0U},/* 2.5Gbit */
+				{0x30U, 0x80U},/* 1Gbit */
+				{0x4U, 0x50U},/* 100Mbit */
+			};
+			unsigned int mbps = self->aq_link_status.mbps;
+			unsigned int speed_index;
+
+			speed_index = hw_atl_utils_mbps_2_speed_index(mbps);
+
+			/* Update user visible ITR settings */
+			self->aq_nic_cfg->tx_itr = hw_atl2_timers_table_tx_
+							[speed_index][1] * 2;
+			self->aq_nic_cfg->rx_itr = hw_atl2_timers_table_rx_
+							[speed_index][1] * 2;
+
+			itr_tx |= hw_atl2_timers_table_tx_
+						[speed_index][0] << 0x8U;
+			itr_tx |= hw_atl2_timers_table_tx_
+						[speed_index][1] << 0x10U;
+
+			itr_rx |= hw_atl2_timers_table_rx_
+						[speed_index][0] << 0x8U;
+			itr_rx |= hw_atl2_timers_table_rx_
+						[speed_index][1] << 0x10U;
+		}
+		break;
+	case AQ_CFG_INTERRUPT_MODERATION_OFF:
+		hw_atl_tdm_tx_desc_wr_wb_irq_en_set(self, 1U);
+		hw_atl_tdm_tdm_intr_moder_en_set(self, 0U);
+		hw_atl_rdm_rx_desc_wr_wb_irq_en_set(self, 1U);
+		hw_atl_rdm_rdm_intr_moder_en_set(self, 0U);
+		itr_tx = 0U;
+		itr_rx = 0U;
+		break;
+	}
+
+	for (i = HW_ATL2_RINGS_MAX; i--;) {
+		hw_atl2_reg_tx_intr_moder_ctrl_set(self, itr_tx, i);
+		hw_atl_reg_rx_intr_moder_ctrl_set(self, itr_rx, i);
+	}
+
+	return aq_hw_err_from_flags(self);
 }
 
 static int hw_atl2_hw_stop(struct aq_hw_s *self)
@@ -545,16 +585,6 @@ static int hw_atl2_hw_stop(struct aq_hw_s *self)
 	return 0;
 }
 
-static int hw_atl2_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
-{
-	return -EOPNOTSUPP;
-}
-
-static int hw_atl2_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
-{
-	return -EOPNOTSUPP;
-}
-
 static struct aq_stats_s *hw_atl2_utils_get_hw_stats(struct aq_hw_s *self)
 {
 	return &self->curr_stats;
@@ -618,21 +648,21 @@ static int hw_atl2_hw_vlan_ctrl(struct aq_hw_s *self, bool enable)
 const struct aq_hw_ops hw_atl2_ops = {
 	.hw_soft_reset        = hw_atl2_utils_soft_reset,
 	.hw_prepare           = hw_atl2_utils_initfw,
-	.hw_set_mac_address   = hw_atl2_hw_mac_addr_set,
+	.hw_set_mac_address   = hw_atl_b0_hw_mac_addr_set,
 	.hw_init              = hw_atl2_hw_init,
 	.hw_reset             = hw_atl2_hw_reset,
 	.hw_start             = hw_atl_b0_hw_start,
-	.hw_ring_tx_start     = hw_atl2_hw_ring_tx_start,
-	.hw_ring_tx_stop      = hw_atl2_hw_ring_tx_stop,
-	.hw_ring_rx_start     = hw_atl2_hw_ring_rx_start,
-	.hw_ring_rx_stop      = hw_atl2_hw_ring_rx_stop,
+	.hw_ring_tx_start     = hw_atl_b0_hw_ring_tx_start,
+	.hw_ring_tx_stop      = hw_atl_b0_hw_ring_tx_stop,
+	.hw_ring_rx_start     = hw_atl_b0_hw_ring_rx_start,
+	.hw_ring_rx_stop      = hw_atl_b0_hw_ring_rx_stop,
 	.hw_stop              = hw_atl2_hw_stop,
 
-	.hw_ring_tx_xmit         = hw_atl2_hw_ring_tx_xmit,
-	.hw_ring_tx_head_update  = hw_atl2_hw_ring_tx_head_update,
+	.hw_ring_tx_xmit         = hw_atl_b0_hw_ring_tx_xmit,
+	.hw_ring_tx_head_update  = hw_atl_b0_hw_ring_tx_head_update,
 
-	.hw_ring_rx_receive      = hw_atl2_hw_ring_rx_receive,
-	.hw_ring_rx_fill         = hw_atl2_hw_ring_rx_fill,
+	.hw_ring_rx_receive      = hw_atl_b0_hw_ring_rx_receive,
+	.hw_ring_rx_fill         = hw_atl_b0_hw_ring_rx_fill,
 
 	.hw_irq_enable           = hw_atl_b0_hw_irq_enable,
 	.hw_irq_disable          = hw_atl_b0_hw_irq_disable,
@@ -649,5 +679,5 @@ const struct aq_hw_ops hw_atl2_ops = {
 	.hw_rss_hash_set             = hw_atl_b0_hw_rss_hash_set,
 	.hw_get_hw_stats             = hw_atl2_utils_get_hw_stats,
 	.hw_get_fw_version           = hw_atl2_utils_get_fw_version,
-	.hw_set_offload              = hw_atl2_hw_offload_set,
+	.hw_set_offload              = hw_atl_b0_hw_offload_set,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
index bc9aa67a5cdc..3c54c0aaae26 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -34,6 +34,9 @@
 #define HW_ATL2_TC_MAX 1U
 #define HW_ATL2_RSS_MAX 8U
 
+#define HW_ATL2_INTR_MODER_MAX  0x1FF
+#define HW_ATL2_INTR_MODER_MIN  0xFF
+
 #define HW_ATL2_MIN_RXD \
 	(ALIGN(AQ_CFG_SKB_FRAGS_MAX + 1U, AQ_HW_RXD_MULTIPLE))
 #define HW_ATL2_MIN_TXD \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index af176e1e5a18..e779d70fde66 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -68,6 +68,14 @@ void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en)
 			    clk_gate_en);
 }
 
+void hw_atl2_reg_tx_intr_moder_ctrl_set(struct aq_hw_s *aq_hw,
+					u32 tx_intr_moderation_ctl,
+					u32 queue)
+{
+	aq_hw_write_reg(aq_hw, HW_ATL2_TX_INTR_MODERATION_CTL_ADR(queue),
+			tx_intr_moderation_ctl);
+}
+
 void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
 						    u32 max_credit,
 						    u32 tc)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index 4acbbceb623f..8c6d78a64d42 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -10,6 +10,11 @@
 
 struct aq_hw_s;
 
+/* Set TX Interrupt Moderation Control Register */
+void hw_atl2_reg_tx_intr_moder_ctrl_set(struct aq_hw_s *aq_hw,
+					u32 tx_intr_moderation_ctl,
+					u32 queue);
+
 /** Set RSS HASH type */
 void hw_atl2_rpf_rss_hash_type_set(struct aq_hw_s *aq_hw, u32 rss_hash_type);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
index 14b78e090950..cde9e9d2836d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -178,6 +178,14 @@
 /* default value of bitfield data_tc{t}_weight[8:0] */
 #define HW_ATL2_TPS_DATA_TCTWEIGHT_DEFAULT 0x0
 
+/* tx interrupt moderation control register definitions
+ * Preprocessor definitions for TX Interrupt Moderation Control Register
+ * Base Address: 0x00007c28
+ * Parameter: queue {Q} | stride size 0x4 | range [0, 31]
+ */
+
+#define HW_ATL2_TX_INTR_MODERATION_CTL_ADR(queue) (0x00007c28u + (queue) * 0x40)
+
 /* Launch time control register */
 #define HW_ATL2_LT_CTRL_ADR 0x00007a1c
 
-- 
2.17.1

