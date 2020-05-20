Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDF1DB586
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgETNsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:48:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16706 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgETNsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:48:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDembV003564;
        Wed, 20 May 2020 06:48:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Z9ofeclGfYimghXxAf/b5YiUq7RMjOS189XJRMB8Mlk=;
 b=genNu9YwX3q5YDBep4mRijDW0lPHI/JhfySay0smxz7KjkZEYYSjUvBccxdi7tOP0U7H
 aDKMxWoNX3D+RtTureIh4J6YqsOmkI7PS4/ZGc+RUH8U4RAFdPLBaTZkoK4/Dg6u7MaK
 zhoRn0dJwrs0xRAul5rrcFC1fwY2V0KkQfmvinXARb2eTkrhLGs7ZvBaYIsL2dJi3j/0
 q7g30WgqNQk8Ww2wgA0+Hq9zCGSRIaKar9odMYJQ9ukR5dUdoq78cBJ6Gmwo51OYdXNE
 kwjmBVmFjKX0oArmgswK1WH159O0LigWfvS/dgx13YO2hYWJHAqecnl76JL//J1/DOVW mg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs5aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:48:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:48:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:48:02 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id A37FD3F7045;
        Wed, 20 May 2020 06:48:00 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 11/12] net: atlantic: QoS implementation: min_rate
Date:   Wed, 20 May 2020 16:47:33 +0300
Message-ID: <20200520134734.2014-12-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200520134734.2014-1-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds support for mqprio min_rate limiters.

A2 HW supports Weighted Strict Priority (WSP) arbitration for Tx Descriptor
Queue scheduling among TCs, which can be used for min_rate shaping.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   2 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  21 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  28 ++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   4 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  77 +++++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |   2 -
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 127 ++++++++++++++++--
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |   9 ++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |   3 +
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   |  62 ++++++---
 10 files changed, 281 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index d31e576f8b86..ed5b465bc664 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -280,6 +280,8 @@ struct aq_hw_ops {
 	int (*hw_rss_hash_set)(struct aq_hw_s *self,
 			       struct aq_rss_parameters *rss_params);
 
+	int (*hw_tc_rate_limit_set)(struct aq_hw_s *self);
+
 	int (*hw_get_regs)(struct aq_hw_s *self,
 			   const struct aq_hw_caps_s *aq_hw_caps,
 			   u32 *regs_buff);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 00a0032a5abc..8a1da044e908 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -340,7 +340,6 @@ static int aq_validate_mqprio_opt(struct aq_nic_s *self,
 	struct aq_nic_cfg_s *aq_nic_cfg = aq_nic_get_cfg(self);
 	const unsigned int tcs_max = min_t(u8, aq_nic_cfg->aq_hw_caps->tcs_max,
 					   AQ_CFG_TCS_MAX);
-	int i;
 
 	if (num_tc > tcs_max) {
 		netdev_err(self->ndev, "Too many TCs requested\n");
@@ -352,12 +351,9 @@ static int aq_validate_mqprio_opt(struct aq_nic_s *self,
 		return -EOPNOTSUPP;
 	}
 
-	for (i = 0; i < num_tc; i++) {
-		if (has_min_rate && mqprio->min_rate[i]) {
-			netdev_err(self->ndev,
-				   "Min tx rate is not supported\n");
-			return -EOPNOTSUPP;
-		}
+	if (has_min_rate && !ATL_HW_IS_CHIP_FEATURE(self->aq_hw, ANTIGUA)) {
+		netdev_err(self->ndev, "Min tx rate is not supported\n");
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -383,13 +379,20 @@ static int aq_ndo_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	if (err)
 		return err;
 
-	if (mqprio->flags & TC_MQPRIO_F_MAX_RATE) {
-		for (i = 0; i < mqprio->qopt.num_tc; i++) {
+	for (i = 0; i < mqprio->qopt.num_tc; i++) {
+		if (has_max_rate) {
 			u64 max_rate = mqprio->max_rate[i];
 
 			do_div(max_rate, AQ_MBPS_DIVISOR);
 			aq_nic_setup_tc_max_rate(aq_nic, i, (u32)max_rate);
 		}
+
+		if (has_min_rate) {
+			u64 min_rate = mqprio->min_rate[i];
+
+			do_div(min_rate, AQ_MBPS_DIVISOR);
+			aq_nic_setup_tc_min_rate(aq_nic, i, (u32)min_rate);
+		}
 	}
 
 	return aq_nic_setup_tc_mqprio(aq_nic, mqprio->qopt.num_tc,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index f5b57420e1b7..39a1a7b6e1c2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -200,6 +200,9 @@ static int aq_nic_update_link_status(struct aq_nic_s *self)
 #if IS_ENABLED(CONFIG_MACSEC)
 		aq_macsec_enable(self);
 #endif
+		if (self->aq_hw_ops->hw_tc_rate_limit_set)
+			self->aq_hw_ops->hw_tc_rate_limit_set(self->aq_hw);
+
 		netif_tx_wake_all_queues(self->ndev);
 	}
 	if (netif_carrier_ok(self->ndev) && !self->link_status.mbps) {
@@ -1375,3 +1378,28 @@ int aq_nic_setup_tc_max_rate(struct aq_nic_s *self, const unsigned int tc,
 
 	return 0;
 }
+
+int aq_nic_setup_tc_min_rate(struct aq_nic_s *self, const unsigned int tc,
+			     const u32 min_rate)
+{
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+
+	if (tc >= AQ_CFG_TCS_MAX)
+		return -EINVAL;
+
+	if (min_rate)
+		set_bit(tc, &cfg->tc_min_rate_msk);
+	else
+		clear_bit(tc, &cfg->tc_min_rate_msk);
+
+	if (min_rate && min_rate < 20) {
+		netdev_warn(self->ndev,
+			"Setting %s to the minimum usable value of %dMbps.\n",
+			"min rate", 20);
+		cfg->tc_min_rate[tc] = 20;
+	} else {
+		cfg->tc_min_rate[tc] = min_rate;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 7a1d799b1e0d..2ab003065e62 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -66,6 +66,8 @@ struct aq_nic_cfg_s {
 	u8  tcs;
 	u8 prio_tc_map[8];
 	u32 tc_max_rate[AQ_CFG_TCS_MAX];
+	unsigned long tc_min_rate_msk;
+	u32 tc_min_rate[AQ_CFG_TCS_MAX];
 	struct aq_rss_parameters aq_rss;
 	u32 eee_speeds;
 };
@@ -198,4 +200,6 @@ void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map);
 int aq_nic_setup_tc_max_rate(struct aq_nic_s *self, const unsigned int tc,
 			     const u32 max_rate);
+int aq_nic_setup_tc_min_rate(struct aq_nic_s *self, const unsigned int tc,
+			     const u32 min_rate);
 #endif /* AQ_NIC_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 2448a09ef7b9..320f3669305d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -138,8 +138,6 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	unsigned int prio = 0U;
 	u32 tc = 0U;
 
-	hw_atl_b0_hw_init_tx_tc_rate_limit(self);
-
 	if (cfg->is_ptp) {
 		tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
 		rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
@@ -152,18 +150,11 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	/* TPS VM init */
 	hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(self, 0U);
 
-	/* TPS TC credits init */
-	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
-
 	tx_buff_size /= cfg->tcs;
 	rx_buff_size /= cfg->tcs;
 	for (tc = 0; tc < cfg->tcs; tc++) {
 		u32 threshold = 0U;
 
-		/* TX Packet Scheduler Data TC0 */
-		hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, tc, 0xFFF);
-		hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, tc, 0x64);
-
 		/* Tx buf size TC0 */
 		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
 
@@ -319,24 +310,87 @@ int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
-int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self)
+static int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self)
 {
+	static const u32 max_weight = BIT(HW_ATL_TPS_DATA_TCTWEIGHT_WIDTH) - 1;
 	/* Scale factor is based on the number of bits in fractional portion */
 	static const u32 scale = BIT(HW_ATL_TPS_DESC_RATE_Y_WIDTH);
 	static const u32 frac_msk = HW_ATL_TPS_DESC_RATE_Y_MSK >>
 				    HW_ATL_TPS_DESC_RATE_Y_SHIFT;
+	const u32 link_speed = self->aq_link_status.mbps;
 	struct aq_nic_cfg_s *nic_cfg = self->aq_nic_cfg;
+	unsigned long num_min_rated_tcs = 0;
+	u32 tc_weight[AQ_CFG_TCS_MAX];
+	u32 fixed_max_credit;
+	u8 min_rate_msk = 0;
+	u32 sum_weight = 0;
 	int tc;
 
+	/* By default max_credit is based upon MTU (in unit of 64b) */
+	fixed_max_credit = nic_cfg->aq_hw_caps->mtu / 64;
+
+	if (link_speed) {
+		min_rate_msk = nic_cfg->tc_min_rate_msk &
+			       (BIT(nic_cfg->tcs) - 1);
+		num_min_rated_tcs = hweight8(min_rate_msk);
+	}
+
+	/* First, calculate weights where min_rate is specified */
+	if (num_min_rated_tcs) {
+		for (tc = 0; tc != nic_cfg->tcs; tc++) {
+			if (!nic_cfg->tc_min_rate[tc]) {
+				tc_weight[tc] = 0;
+				continue;
+			}
+
+			tc_weight[tc] = (-1L + link_speed +
+					 nic_cfg->tc_min_rate[tc] *
+					 max_weight) /
+					link_speed;
+			tc_weight[tc] = min(tc_weight[tc], max_weight);
+			sum_weight += tc_weight[tc];
+		}
+	}
+
+	/* WSP, if min_rate is set for at least one TC.
+	 * RR otherwise.
+	 */
+	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, min_rate_msk ? 1U : 0U);
+	/* Data TC Arbiter takes precedence over Descriptor TC Arbiter,
+	 * leave Descriptor TC Arbiter as RR.
+	 */
 	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
+
 	hw_atl_tps_tx_desc_rate_mode_set(self, nic_cfg->is_qos ? 1U : 0U);
+
 	for (tc = 0; tc != nic_cfg->tcs; tc++) {
 		const u32 en = (nic_cfg->tc_max_rate[tc] != 0) ? 1U : 0U;
 		const u32 desc = AQ_NIC_CFG_TCVEC2RING(nic_cfg, tc, 0);
+		u32 weight, max_credit;
 
-		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, tc, 0x50);
+		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, tc,
+							      fixed_max_credit);
 		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, tc, 0x1E);
 
+		if (num_min_rated_tcs) {
+			weight = tc_weight[tc];
+
+			if (!weight && sum_weight < max_weight)
+				weight = (max_weight - sum_weight) /
+					 (nic_cfg->tcs - num_min_rated_tcs);
+			else if (!weight)
+				weight = 0x64;
+
+			max_credit = max(8 * weight, fixed_max_credit);
+		} else {
+			weight = 0x64;
+			max_credit = 0xFFF;
+		}
+
+		hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, tc, weight);
+		hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, tc,
+							      max_credit);
+
 		hw_atl_tps_tx_desc_rate_en_set(self, desc, en);
 
 		if (en) {
@@ -1550,6 +1604,7 @@ const struct aq_hw_ops hw_atl_ops_b0 = {
 	.hw_interrupt_moderation_set = hw_atl_b0_hw_interrupt_moderation_set,
 	.hw_rss_set                  = hw_atl_b0_hw_rss_set,
 	.hw_rss_hash_set             = hw_atl_b0_hw_rss_hash_set,
+	.hw_tc_rate_limit_set        = hw_atl_b0_hw_init_tx_tc_rate_limit,
 	.hw_get_regs                 = hw_atl_utils_hw_get_regs,
 	.hw_get_hw_stats             = hw_atl_utils_get_hw_stats,
 	.hw_get_fw_version           = hw_atl_utils_get_fw_version,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index 992ee4ed37cc..b855459272ca 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -62,8 +62,6 @@ int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
 
 int hw_atl_b0_hw_start(struct aq_hw_s *self);
 
-int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self);
-
 int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask);
 int hw_atl_b0_hw_irq_disable(struct aq_hw_s *self, u64 mask);
 int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index a5bffadde6df..f941773b3e20 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -10,6 +10,7 @@
 #include "hw_atl/hw_atl_b0.h"
 #include "hw_atl/hw_atl_utils.h"
 #include "hw_atl/hw_atl_llh.h"
+#include "hw_atl/hw_atl_llh_internal.h"
 #include "hw_atl2_utils.h"
 #include "hw_atl2_llh.h"
 #include "hw_atl2_internal.h"
@@ -148,8 +149,6 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	unsigned int prio = 0U;
 	u32 tc = 0U;
 
-	hw_atl_b0_hw_init_tx_tc_rate_limit(self);
-
 	/* TPS Descriptor rate init */
 	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
 	hw_atl_tps_tx_pkt_shed_desc_rate_lim_set(self, 0xA);
@@ -157,19 +156,11 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	/* TPS VM init */
 	hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(self, 0U);
 
-	/* TPS TC credits init */
-	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
-
 	tx_buff_size /= cfg->tcs;
 	rx_buff_size /= cfg->tcs;
 	for (tc = 0; tc < cfg->tcs; tc++) {
 		u32 threshold = 0U;
 
-		/* TX Packet Scheduler Data TC0 */
-		hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF0,
-							       tc);
-		hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, 0x640, tc);
-
 		/* Tx buf size TC0 */
 		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
 
@@ -225,6 +216,121 @@ static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
+static int hw_atl2_hw_init_tx_tc_rate_limit(struct aq_hw_s *self)
+{
+	static const u32 max_weight = BIT(HW_ATL2_TPS_DATA_TCTWEIGHT_WIDTH) - 1;
+	/* Scale factor is based on the number of bits in fractional portion */
+	static const u32 scale = BIT(HW_ATL_TPS_DESC_RATE_Y_WIDTH);
+	static const u32 frac_msk = HW_ATL_TPS_DESC_RATE_Y_MSK >>
+				    HW_ATL_TPS_DESC_RATE_Y_SHIFT;
+	const u32 link_speed = self->aq_link_status.mbps;
+	struct aq_nic_cfg_s *nic_cfg = self->aq_nic_cfg;
+	unsigned long num_min_rated_tcs = 0;
+	u32 tc_weight[AQ_CFG_TCS_MAX];
+	u32 fixed_max_credit_4b;
+	u32 fixed_max_credit;
+	u8 min_rate_msk = 0;
+	u32 sum_weight = 0;
+	int tc;
+
+	/* By default max_credit is based upon MTU (in unit of 64b) */
+	fixed_max_credit = nic_cfg->aq_hw_caps->mtu / 64;
+	/* in unit of 4b */
+	fixed_max_credit_4b = nic_cfg->aq_hw_caps->mtu / 4;
+
+	if (link_speed) {
+		min_rate_msk = nic_cfg->tc_min_rate_msk &
+			       (BIT(nic_cfg->tcs) - 1);
+		num_min_rated_tcs = hweight8(min_rate_msk);
+	}
+
+	/* First, calculate weights where min_rate is specified */
+	if (num_min_rated_tcs) {
+		for (tc = 0; tc != nic_cfg->tcs; tc++) {
+			if (!nic_cfg->tc_min_rate[tc]) {
+				tc_weight[tc] = 0;
+				continue;
+			}
+
+			tc_weight[tc] = (-1L + link_speed +
+					 nic_cfg->tc_min_rate[tc] *
+					 max_weight) /
+					link_speed;
+			tc_weight[tc] = min(tc_weight[tc], max_weight);
+			sum_weight += tc_weight[tc];
+		}
+	}
+
+	/* WSP, if min_rate is set for at least one TC.
+	 * RR otherwise.
+	 */
+	hw_atl2_tps_tx_pkt_shed_data_arb_mode_set(self, min_rate_msk ? 1U : 0U);
+	/* Data TC Arbiter takes precedence over Descriptor TC Arbiter,
+	 * leave Descriptor TC Arbiter as RR.
+	 */
+	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
+
+	hw_atl_tps_tx_desc_rate_mode_set(self, nic_cfg->is_qos ? 1U : 0U);
+
+	for (tc = 0; tc != nic_cfg->tcs; tc++) {
+		const u32 en = (nic_cfg->tc_max_rate[tc] != 0) ? 1U : 0U;
+		const u32 desc = AQ_NIC_CFG_TCVEC2RING(nic_cfg, tc, 0);
+		u32 weight, max_credit;
+
+		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, tc,
+							      fixed_max_credit);
+		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, tc, 0x1E);
+
+		if (num_min_rated_tcs) {
+			weight = tc_weight[tc];
+
+			if (!weight && sum_weight < max_weight)
+				weight = (max_weight - sum_weight) /
+					 (nic_cfg->tcs - num_min_rated_tcs);
+			else if (!weight)
+				weight = 0x640;
+
+			max_credit = max(2 * weight, fixed_max_credit_4b);
+		} else {
+			weight = 0x640;
+			max_credit = 0xFFF0;
+		}
+
+		hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, tc, weight);
+		hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, tc,
+							       max_credit);
+
+		hw_atl_tps_tx_desc_rate_en_set(self, desc, en);
+
+		if (en) {
+			/* Nominal rate is always 10G */
+			const u32 rate = 10000U * scale /
+					 nic_cfg->tc_max_rate[tc];
+			const u32 rate_int = rate >>
+					     HW_ATL_TPS_DESC_RATE_Y_WIDTH;
+			const u32 rate_frac = rate & frac_msk;
+
+			hw_atl_tps_tx_desc_rate_x_set(self, desc, rate_int);
+			hw_atl_tps_tx_desc_rate_y_set(self, desc, rate_frac);
+		} else {
+			/* A value of 1 indicates the queue is not
+			 * rate controlled.
+			 */
+			hw_atl_tps_tx_desc_rate_x_set(self, desc, 1U);
+			hw_atl_tps_tx_desc_rate_y_set(self, desc, 0U);
+		}
+	}
+	for (tc = nic_cfg->tcs; tc != AQ_CFG_TCS_MAX; tc++) {
+		const u32 desc = AQ_NIC_CFG_TCVEC2RING(nic_cfg, tc, 0);
+
+		hw_atl_tps_tx_desc_rate_en_set(self, desc, 0U);
+		hw_atl_tps_tx_desc_rate_x_set(self, desc, 1U);
+		hw_atl_tps_tx_desc_rate_y_set(self, desc, 0U);
+	}
+
+	return aq_hw_err_from_flags(self);
+}
+
 static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
 {
 	struct aq_nic_cfg_s *nic_cfg = self->aq_nic_cfg;
@@ -730,6 +836,7 @@ const struct aq_hw_ops hw_atl2_ops = {
 	.hw_interrupt_moderation_set = hw_atl2_hw_interrupt_moderation_set,
 	.hw_rss_set                  = hw_atl2_hw_rss_set,
 	.hw_rss_hash_set             = hw_atl_b0_hw_rss_hash_set,
+	.hw_tc_rate_limit_set        = hw_atl2_hw_init_tx_tc_rate_limit,
 	.hw_get_hw_stats             = hw_atl2_utils_get_hw_stats,
 	.hw_get_fw_version           = hw_atl2_utils_get_fw_version,
 	.hw_set_offload              = hw_atl_b0_hw_offload_set,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index c6a6ba66eb05..cd954b11d24a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -93,6 +93,15 @@ void hw_atl2_reg_tx_intr_moder_ctrl_set(struct aq_hw_s *aq_hw,
 			tx_intr_moderation_ctl);
 }
 
+void hw_atl2_tps_tx_pkt_shed_data_arb_mode_set(struct aq_hw_s *aq_hw,
+					       const u32 data_arb_mode)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPS_DATA_TC_ARB_MODE_ADR,
+			    HW_ATL2_TPS_DATA_TC_ARB_MODE_MSK,
+			    HW_ATL2_TPS_DATA_TC_ARB_MODE_SHIFT,
+			    data_arb_mode);
+}
+
 void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
 						    const u32 tc,
 						    const u32 max_credit)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index 883fa009bc0e..98c7a4621297 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -45,6 +45,9 @@ void hw_atl2_tpb_tx_tc_q_rand_map_en_set(struct aq_hw_s *aq_hw,
 /* set tx buffer clock gate enable */
 void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en);
 
+void hw_atl2_tps_tx_pkt_shed_data_arb_mode_set(struct aq_hw_s *aq_hw,
+					       const u32 data_arb_mode);
+
 /* set tx packet scheduler tc data max credit */
 void hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(struct aq_hw_s *aq_hw,
 						    const u32 tc,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
index bf0198ca4e85..e34c5cda061e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -185,42 +185,60 @@
 /* default value of bitfield tx_q_tc_map{q} */
 #define HW_ATL2_TX_Q_TC_MAP_DEFAULT 0x0
 
+/* tx data_tc_arb_mode bitfield definitions
+ * preprocessor definitions for the bitfield "data_tc_arb_mode".
+ * port="pif_tps_data_tc_arb_mode_i"
+ */
+
+/* register address for bitfield data_tc_arb_mode */
+#define HW_ATL2_TPS_DATA_TC_ARB_MODE_ADR 0x00007100
+/* bitmask for bitfield data_tc_arb_mode */
+#define HW_ATL2_TPS_DATA_TC_ARB_MODE_MSK 0x00000003
+/* inverted bitmask for bitfield data_tc_arb_mode */
+#define HW_ATL2_TPS_DATA_TC_ARB_MODE_MSKN 0xfffffffc
+/* lower bit position of bitfield data_tc_arb_mode */
+#define HW_ATL2_TPS_DATA_TC_ARB_MODE_SHIFT 0
+/* width of bitfield data_tc_arb_mode */
+#define HW_ATL2_TPS_DATA_TC_ARB_MODE_WIDTH 2
+/* default value of bitfield data_tc_arb_mode */
+#define HW_ATL2_TPS_DATA_TC_ARB_MODE_DEFAULT 0x0
+
 /* tx data_tc{t}_credit_max[f:0] bitfield definitions
  * preprocessor definitions for the bitfield "data_tc{t}_credit_max[f:0]".
  * parameter: tc {t} | stride size 0x4 | range [0, 7]
- * port="pif_tps_data_tc0_credit_max_i[11:0]"
+ * port="pif_tps_data_tc0_credit_max_i[15:0]"
  */
 
-/* register address for bitfield data_tc{t}_credit_max[b:0] */
+/* register address for bitfield data_tc{t}_credit_max[f:0] */
 #define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_ADR(tc) (0x00007110 + (tc) * 0x4)
-/* bitmask for bitfield data_tc{t}_credit_max[b:0] */
-#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSK 0x0fff0000
-/* inverted bitmask for bitfield data_tc{t}_credit_max[b:0] */
-#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSKN 0xf000ffff
-/* lower bit position of bitfield data_tc{t}_credit_max[b:0] */
+/* bitmask for bitfield data_tc{t}_credit_max[f:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSK 0xffff0000
+/* inverted bitmask for bitfield data_tc{t}_credit_max[f:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_MSKN 0x0000ffff
+/* lower bit position of bitfield data_tc{t}_credit_max[f:0] */
 #define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_SHIFT 16
-/* width of bitfield data_tc{t}_credit_max[b:0] */
-#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_WIDTH 12
-/* default value of bitfield data_tc{t}_credit_max[b:0] */
+/* width of bitfield data_tc{t}_credit_max[f:0] */
+#define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_WIDTH 16
+/* default value of bitfield data_tc{t}_credit_max[f:0] */
 #define HW_ATL2_TPS_DATA_TCTCREDIT_MAX_DEFAULT 0x0
 
-/* tx data_tc{t}_weight[8:0] bitfield definitions
- * preprocessor definitions for the bitfield "data_tc{t}_weight[8:0]".
+/* tx data_tc{t}_weight[e:0] bitfield definitions
+ * preprocessor definitions for the bitfield "data_tc{t}_weight[e:0]".
  * parameter: tc {t} | stride size 0x4 | range [0, 7]
- * port="pif_tps_data_tc0_weight_i[8:0]"
+ * port="pif_tps_data_tc0_weight_i[14:0]"
  */
 
-/* register address for bitfield data_tc{t}_weight[8:0] */
+/* register address for bitfield data_tc{t}_weight[e:0] */
 #define HW_ATL2_TPS_DATA_TCTWEIGHT_ADR(tc) (0x00007110 + (tc) * 0x4)
-/* bitmask for bitfield data_tc{t}_weight[8:0] */
-#define HW_ATL2_TPS_DATA_TCTWEIGHT_MSK 0x000001ff
-/* inverted bitmask for bitfield data_tc{t}_weight[8:0] */
-#define HW_ATL2_TPS_DATA_TCTWEIGHT_MSKN 0xfffffe00
-/* lower bit position of bitfield data_tc{t}_weight[8:0] */
+/* bitmask for bitfield data_tc{t}_weight[e:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_MSK 0x00007fff
+/* inverted bitmask for bitfield data_tc{t}_weight[e:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_MSKN 0xffff8000
+/* lower bit position of bitfield data_tc{t}_weight[e:0] */
 #define HW_ATL2_TPS_DATA_TCTWEIGHT_SHIFT 0
-/* width of bitfield data_tc{t}_weight[8:0] */
-#define HW_ATL2_TPS_DATA_TCTWEIGHT_WIDTH 9
-/* default value of bitfield data_tc{t}_weight[8:0] */
+/* width of bitfield data_tc{t}_weight[e:0] */
+#define HW_ATL2_TPS_DATA_TCTWEIGHT_WIDTH 15
+/* default value of bitfield data_tc{t}_weight[e:0] */
 #define HW_ATL2_TPS_DATA_TCTWEIGHT_DEFAULT 0x0
 
 /* tx interrupt moderation control register definitions
-- 
2.25.1

