Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664C51DE1B3
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgEVIU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:20:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729098AbgEVIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 04:20:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M8ExG4032447;
        Fri, 22 May 2020 01:20:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=w13CUyBHKPwciD9mIaTdT6u6yOSjQTQqQMrEwvXM93g=;
 b=FiRDRjXAT4nn9j55NrakuY9YK4umkFSVAY65wcelunnpN1cQLAQ6Ep8/VYSkg/57kLBF
 D+zKWng6tBQDYZ8E+rHJkXvpLZnqhGcQTMYPWQmmPvTrt8xvmYsrF7JIgcZRuIZ8SJvW
 SdvoIryiTdHBDe9lNVbor8wY2pLXtxpY+6zrFSXwJfVJSEu+A6y2GoA/nZt5CaR4Y4Fz
 rfnzRhe1Mt/K8KnSyT4Fg8i6aj+GwnBQZMH+K93/xgANDS8GQW1j4bDwqYLbyxU5UvWV
 eb+VBfLbloyvV/OsNnQPUITwKh1yEER/KgEtPLE3tudftUJq04CFXiaRkUJj567LAAbX pw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhr29ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 01:20:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 01:20:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 01:20:10 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 69A883F7043;
        Fri, 22 May 2020 01:20:08 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 07/12] net: atlantic: QoS implementation: max_rate
Date:   Fri, 22 May 2020 11:19:43 +0300
Message-ID: <20200522081948.167-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200522081948.167-1-irusskikh@marvell.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_04:2020-05-21,2020-05-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds initial support for mqprio rate limiters (max_rate only).

Atlantic HW supports Rate-Shaping for time-sensitive traffic at per
Traffic Class (TC) granularity.
Target rate is defined by:
* nominal link rate (always 10G);
* rate factor (ratio between nominal rate and max allowed).

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  3 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 30 ++++++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 20 ++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  3 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 58 +++++++++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |  2 +
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 36 ++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     | 16 +++++
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 70 +++++++++++++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  9 +--
 10 files changed, 235 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 1dccaaee04b3..d31e576f8b86 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -35,6 +35,9 @@ enum aq_tc_mode {
 			(AQ_RX_LAST_LOC_FVLANID - AQ_RX_FIRST_LOC_FVLANID + 1U)
 #define AQ_RX_QUEUE_NOT_ASSIGNED   0xFFU
 
+/* Used for rate to Mbps conversion */
+#define AQ_MBPS_DIVISOR         125000 /* 1000000 / 8 */
+
 /* NIC H/W capabilities */
 struct aq_hw_caps_s {
 	u64 hw_features;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index ef9e969fbf7a..d8817047f4ef 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -333,8 +333,12 @@ static int aq_ndo_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto,
 }
 
 static int aq_validate_mqprio_opt(struct aq_nic_s *self,
+				  struct tc_mqprio_qopt_offload *mqprio,
 				  const unsigned int num_tc)
 {
+	const bool has_min_rate = !!(mqprio->flags & TC_MQPRIO_F_MIN_RATE);
+	int i;
+
 	if (num_tc > aq_hw_num_tcs(self->aq_hw)) {
 		netdev_err(self->ndev, "Too many TCs requested\n");
 		return -EOPNOTSUPP;
@@ -345,25 +349,43 @@ static int aq_validate_mqprio_opt(struct aq_nic_s *self,
 		return -EOPNOTSUPP;
 	}
 
+	for (i = 0; i < num_tc; i++) {
+		if (has_min_rate && mqprio->min_rate[i]) {
+			netdev_err(self->ndev,
+				   "Min tx rate is not supported\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	return 0;
 }
 
 static int aq_ndo_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			   void *type_data)
 {
+	struct tc_mqprio_qopt_offload *mqprio = type_data;
 	struct aq_nic_s *aq_nic = netdev_priv(dev);
-	struct tc_mqprio_qopt *mqprio = type_data;
 	int err;
+	int i;
 
 	if (type != TC_SETUP_QDISC_MQPRIO)
 		return -EOPNOTSUPP;
 
-	err = aq_validate_mqprio_opt(aq_nic, mqprio->num_tc);
+	err = aq_validate_mqprio_opt(aq_nic, mqprio, mqprio->qopt.num_tc);
 	if (err)
 		return err;
 
-	return aq_nic_setup_tc_mqprio(aq_nic, mqprio->num_tc,
-				      mqprio->prio_tc_map);
+	if (mqprio->flags & TC_MQPRIO_F_MAX_RATE) {
+		for (i = 0; i < mqprio->qopt.num_tc; i++) {
+			u64 max_rate = mqprio->max_rate[i];
+
+			do_div(max_rate, AQ_MBPS_DIVISOR);
+			aq_nic_setup_tc_max_rate(aq_nic, i, (u32)max_rate);
+		}
+	}
+
+	return aq_nic_setup_tc_mqprio(aq_nic, mqprio->qopt.num_tc,
+				      mqprio->qopt.prio_tc_map);
 }
 
 static const struct net_device_ops aq_ndev_ops = {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index b2ef0115c293..2e0e7d34fda0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1324,3 +1324,23 @@ int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map)
 
 	return err;
 }
+
+int aq_nic_setup_tc_max_rate(struct aq_nic_s *self, const unsigned int tc,
+			     const u32 max_rate)
+{
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+
+	if (tc >= AQ_CFG_TCS_MAX)
+		return -EINVAL;
+
+	if (max_rate && max_rate < 10) {
+		netdev_warn(self->ndev,
+			"Setting %s to the minimum usable value of %dMbps.\n",
+			"max rate", 10);
+		cfg->tc_max_rate[tc] = 10;
+	} else {
+		cfg->tc_max_rate[tc] = max_rate;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 6cc2ebfe6a44..351c4e68f40d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -65,6 +65,7 @@ struct aq_nic_cfg_s {
 	u32 priv_flags;
 	u8  tcs;
 	u8 prio_tc_map[8];
+	u32 tc_max_rate[AQ_CFG_TCS_MAX];
 	struct aq_rss_parameters aq_rss;
 	u32 eee_speeds;
 };
@@ -194,4 +195,6 @@ u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type type);
 void aq_nic_release_filter(struct aq_nic_s *self, enum aq_rx_filter_type type,
 			   u32 location);
 int aq_nic_setup_tc_mqprio(struct aq_nic_s *self, u32 tcs, u8 *prio_tc_map);
+int aq_nic_setup_tc_max_rate(struct aq_nic_s *self, const unsigned int tc,
+			     const u32 max_rate);
 #endif /* AQ_NIC_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 775382440b47..abc86eb4f525 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -138,6 +138,8 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	unsigned int prio = 0U;
 	u32 tc = 0U;
 
+	hw_atl_b0_hw_init_tx_tc_rate_limit(self);
+
 	if (cfg->is_ptp) {
 		tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
 		rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
@@ -151,7 +153,6 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(self, 0U);
 
 	/* TPS TC credits init */
-	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
 	tx_buff_size /= cfg->tcs;
@@ -162,8 +163,6 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 		/* TX Packet Scheduler Data TC0 */
 		hw_atl_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF, tc);
 		hw_atl_tps_tx_pkt_shed_tc_data_weight_set(self, 0x64, tc);
-		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
-		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
 
 		/* Tx buf size TC0 */
 		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
@@ -320,10 +319,61 @@ int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 	return aq_hw_err_from_flags(self);
 }
 
+int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self)
+{
+	/* Scale factor is based on the number of bits in fractional portion */
+	static const u32 scale = BIT(HW_ATL_TPS_DESC_RATE_Y_WIDTH);
+	static const u32 frac_msk = HW_ATL_TPS_DESC_RATE_Y_MSK >>
+				    HW_ATL_TPS_DESC_RATE_Y_SHIFT;
+	struct aq_nic_cfg_s *nic_cfg = self->aq_nic_cfg;
+	int tc;
+
+	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
+	hw_atl_tps_tx_desc_rate_mode_set(self, nic_cfg->is_qos ? 1U : 0U);
+	for (tc = 0; tc != nic_cfg->tcs; tc++) {
+		const u32 en = (nic_cfg->tc_max_rate[tc] != 0) ? 1U : 0U;
+		const u32 desc = AQ_NIC_CFG_TCVEC2RING(nic_cfg, tc, 0);
+
+		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
+		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
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
 static int hw_atl_b0_hw_init_tx_path(struct aq_hw_s *self)
 {
+	struct aq_nic_cfg_s *nic_cfg = self->aq_nic_cfg;
+
 	/* Tx TC/Queue number config */
-	hw_atl_tpb_tps_tx_tc_mode_set(self, self->aq_nic_cfg->tc_mode);
+	hw_atl_tpb_tps_tx_tc_mode_set(self, nic_cfg->tc_mode);
 
 	hw_atl_thm_lso_tcp_flag_of_first_pkt_set(self, 0x0FF6U);
 	hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(self, 0x0FF6U);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index b855459272ca..992ee4ed37cc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -62,6 +62,8 @@ int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr);
 
 int hw_atl_b0_hw_start(struct aq_hw_s *self);
 
+int hw_atl_b0_hw_init_tx_tc_rate_limit(struct aq_hw_s *self);
+
 int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask);
 int hw_atl_b0_hw_irq_disable(struct aq_hw_s *self, u64 mask);
 int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 8cb6765a1398..0ea791a9c100 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -1511,6 +1511,42 @@ void hw_atl_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
 			    tx_pkt_shed_tc_data_weight);
 }
 
+void hw_atl_tps_tx_desc_rate_mode_set(struct aq_hw_s *aq_hw,
+				      const u32 rate_mode)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_TX_DESC_RATE_MODE_ADR,
+			    HW_ATL_TPS_TX_DESC_RATE_MODE_MSK,
+			    HW_ATL_TPS_TX_DESC_RATE_MODE_SHIFT,
+			    rate_mode);
+}
+
+void hw_atl_tps_tx_desc_rate_en_set(struct aq_hw_s *aq_hw, const u32 desc,
+				    const u32 enable)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DESC_RATE_EN_ADR(desc),
+			    HW_ATL_TPS_DESC_RATE_EN_MSK,
+			    HW_ATL_TPS_DESC_RATE_EN_SHIFT,
+			    enable);
+}
+
+void hw_atl_tps_tx_desc_rate_x_set(struct aq_hw_s *aq_hw, const u32 desc,
+				   const u32 rate_int)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DESC_RATE_X_ADR(desc),
+			    HW_ATL_TPS_DESC_RATE_X_MSK,
+			    HW_ATL_TPS_DESC_RATE_X_SHIFT,
+			    rate_int);
+}
+
+void hw_atl_tps_tx_desc_rate_y_set(struct aq_hw_s *aq_hw, const u32 desc,
+				   const u32 rate_frac)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPS_DESC_RATE_Y_ADR(desc),
+			    HW_ATL_TPS_DESC_RATE_Y_MSK,
+			    HW_ATL_TPS_DESC_RATE_Y_SHIFT,
+			    rate_frac);
+}
+
 /* tx */
 void hw_atl_tx_tx_reg_res_dis_set(struct aq_hw_s *aq_hw, u32 tx_reg_res_dis)
 {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index b88cb84805d5..c56cc4e8e13c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -710,6 +710,22 @@ void hw_atl_tps_tx_pkt_shed_tc_data_weight_set(struct aq_hw_s *aq_hw,
 					       u32 tx_pkt_shed_tc_data_weight,
 					u32 tc);
 
+/* set tx descriptor rate mode */
+void hw_atl_tps_tx_desc_rate_mode_set(struct aq_hw_s *aq_hw,
+				      const u32 rate_mode);
+
+/* set tx packet scheduler descriptor rate enable */
+void hw_atl_tps_tx_desc_rate_en_set(struct aq_hw_s *aq_hw, const u32 desc,
+				    const u32 enable);
+
+/* set tx packet scheduler descriptor rate integral value */
+void hw_atl_tps_tx_desc_rate_x_set(struct aq_hw_s *aq_hw, const u32 desc,
+				   const u32 rate_int);
+
+/* set tx packet scheduler descriptor rate fractional value */
+void hw_atl_tps_tx_desc_rate_y_set(struct aq_hw_s *aq_hw, const u32 desc,
+				   const u32 rate_frac);
+
 /* tx */
 
 /* set tx register reset disable */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index 5d86ffab4ece..06220792daf1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -2056,6 +2056,24 @@
 /* default value of bitfield tx_tc_mode */
 #define HW_ATL_TPB_TX_TC_MODE_DEFAULT 0x0
 
+/* tx tx_desc_rate_mode bitfield definitions
+ * preprocessor definitions for the bitfield "tx_desc_rate_mode".
+ * port="pif_tps_desc_rate_mode_i"
+ */
+
+/* register address for bitfield tx_desc_rate_mode */
+#define HW_ATL_TPS_TX_DESC_RATE_MODE_ADR 0x00007900
+/* bitmask for bitfield tx_desc_rate_mode */
+#define HW_ATL_TPS_TX_DESC_RATE_MODE_MSK 0x00000080
+/* inverted bitmask for bitfield tx_desc_rate_mode */
+#define HW_ATL_TPS_TX_DESC_RATE_MODE_MSKN 0xFFFFFF7F
+/* lower bit position of bitfield tx_desc_rate_mode */
+#define HW_ATL_TPS_TX_DESC_RATE_MODE_SHIFT 7
+/* width of bitfield tx_desc_rate_mode */
+#define HW_ATL_TPS_TX_DESC_RATE_MODE_WIDTH 1
+/* default value of bitfield tx_desc_rate_mode */
+#define HW_ATL_TPS_TX_DESC_RATE_MODE_DEFAULT 0x0
+
 /* tx tx_buf_en bitfield definitions
  * preprocessor definitions for the bitfield "tx_buf_en".
  * port="pif_tpb_tx_buf_en_i"
@@ -2275,6 +2293,58 @@
 /* default value of bitfield data_tc_arb_mode */
 #define HW_ATL_TPS_DATA_TC_ARB_MODE_DEFAULT 0x0
 
+/* tx desc{r}_rate_en bitfield definitions
+ * preprocessor definitions for the bitfield "desc{r}_rate_en".
+ * port="pif_tps_desc_rate_en_i[0]"
+ */
+
+/* register address for bitfield desc{r}_rate_en */
+#define HW_ATL_TPS_DESC_RATE_EN_ADR(desc) (0x00007408 + (desc) * 0x10)
+/* bitmask for bitfield desc{r}_rate_en */
+#define HW_ATL_TPS_DESC_RATE_EN_MSK 0x80000000
+/* inverted bitmask for bitfield desc{r}_rate_en */
+#define HW_ATL_TPS_DESC_RATE_EN_MSKN 0x7FFFFFFF
+/* lower bit position of bitfield desc{r}_rate_en */
+#define HW_ATL_TPS_DESC_RATE_EN_SHIFT 31
+/* width of bitfield desc{r}_rate_en */
+#define HW_ATL_TPS_DESC_RATE_EN_WIDTH 1
+/* default value of bitfield desc{r}_rate_en */
+#define HW_ATL_TPS_DESC_RATE_EN_DEFAULT 0x0
+
+/* tx desc{r}_rate_x bitfield definitions
+ * preprocessor definitions for the bitfield "desc{r}_rate_x".
+ * port="pif_tps_desc0_rate_x"
+ */
+/* register address for bitfield desc{r}_rate_x */
+#define HW_ATL_TPS_DESC_RATE_X_ADR(desc) (0x00007408 + (desc) * 0x10)
+/* bitmask for bitfield desc{r}_rate_x */
+#define HW_ATL_TPS_DESC_RATE_X_MSK 0x03FF0000
+/* inverted bitmask for bitfield desc{r}_rate_x */
+#define HW_ATL_TPS_DESC_RATE_X_MSKN 0xFC00FFFF
+/* lower bit position of bitfield desc{r}_rate_x */
+#define HW_ATL_TPS_DESC_RATE_X_SHIFT 16
+/* width of bitfield desc{r}_rate_x */
+#define HW_ATL_TPS_DESC_RATE_X_WIDTH 10
+/* default value of bitfield desc{r}_rate_x */
+#define HW_ATL_TPS_DESC_RATE_X_DEFAULT 0x0
+
+/* tx desc{r}_rate_y bitfield definitions
+ * preprocessor definitions for the bitfield "desc{r}_rate_y".
+ * port="pif_tps_desc0_rate_y"
+ */
+/* register address for bitfield desc{r}_rate_y */
+#define HW_ATL_TPS_DESC_RATE_Y_ADR(desc) (0x00007408 + (desc) * 0x10)
+/* bitmask for bitfield desc{r}_rate_y */
+#define HW_ATL_TPS_DESC_RATE_Y_MSK 0x00003FFF
+/* inverted bitmask for bitfield desc{r}_rate_y */
+#define HW_ATL_TPS_DESC_RATE_Y_MSKN 0xFFFFC000
+/* lower bit position of bitfield desc{r}_rate_y */
+#define HW_ATL_TPS_DESC_RATE_Y_SHIFT 0
+/* width of bitfield desc{r}_rate_y */
+#define HW_ATL_TPS_DESC_RATE_Y_WIDTH 14
+/* default value of bitfield desc{r}_rate_y */
+#define HW_ATL_TPS_DESC_RATE_Y_DEFAULT 0x0
+
 /* tx desc_rate_ta_rst bitfield definitions
  * preprocessor definitions for the bitfield "desc_rate_ta_rst".
  * port="pif_tps_desc_rate_ta_rst_i"
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 05c049661b2e..b42ff81adfeb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -135,6 +135,8 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	unsigned int prio = 0U;
 	u32 tc = 0U;
 
+	hw_atl_b0_hw_init_tx_tc_rate_limit(self);
+
 	/* TPS Descriptor rate init */
 	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
 	hw_atl_tps_tx_pkt_shed_desc_rate_lim_set(self, 0xA);
@@ -143,7 +145,6 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_vm_arb_mode_set(self, 0U);
 
 	/* TPS TC credits init */
-	hw_atl_tps_tx_pkt_shed_desc_tc_arb_mode_set(self, 0U);
 	hw_atl_tps_tx_pkt_shed_data_arb_mode_set(self, 0U);
 
 	tx_buff_size /= cfg->tcs;
@@ -155,8 +156,6 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 		hw_atl2_tps_tx_pkt_shed_tc_data_max_credit_set(self, 0xFFF0,
 							       tc);
 		hw_atl2_tps_tx_pkt_shed_tc_data_weight_set(self, 0x640, tc);
-		hw_atl_tps_tx_pkt_shed_desc_tc_max_credit_set(self, 0x50, tc);
-		hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
 
 		/* Tx buf size TC0 */
 		hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
@@ -215,8 +214,10 @@ static int hw_atl2_hw_rss_set(struct aq_hw_s *self,
 
 static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
 {
+	struct aq_nic_cfg_s *nic_cfg = self->aq_nic_cfg;
+
 	/* Tx TC/RSS number config */
-	hw_atl_tpb_tps_tx_tc_mode_set(self, self->aq_nic_cfg->tc_mode);
+	hw_atl_tpb_tps_tx_tc_mode_set(self, nic_cfg->tc_mode);
 
 	hw_atl_thm_lso_tcp_flag_of_first_pkt_set(self, 0x0FF6U);
 	hw_atl_thm_lso_tcp_flag_of_middle_pkt_set(self, 0x0FF6U);
-- 
2.25.1

