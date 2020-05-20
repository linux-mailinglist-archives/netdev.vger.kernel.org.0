Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7BD1DB57E
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETNrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:47:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5086 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726821AbgETNrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:47:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDf26c003644;
        Wed, 20 May 2020 06:47:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=g9fj8XTiqiturtlguKfh5vz+PH5wVMYNmvO+9TEpw0U=;
 b=ZhZC3s3sGxR/bRZdO0FUa6OTd9j3EulqM3WLRNoSJvNqT/buYTK05WWfulpyUWIJdP98
 YaWAqR0HAnfNmnELytHOFiB/ki61rzpnSP65AqFw9ICWsy1/O2MqjXxQ2ITEQxE1NUtS
 +oIDaWoPkTtio1AtQOCAEAur8lad8b2JQQUfsE+WKKQ4dNyWQI65Wf8w5iLsTYesN/xx
 diAjZHaSs+NqBkBXxrPVBUCQGdBwjXLOPpxe5kZFC1PGW4P7NF6MUXf+4y0XIXzFbF7G
 QfUI+oEPVvS+JJaU/LBuJXdusG9m4ifJDlF9hM3VUmqQjozywoPlHkmIZ+dTEQrTdwLD 3Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs59t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:46 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 29E983F7040;
        Wed, 20 May 2020 06:47:43 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 03/12] net: atlantic: changes for multi-TC support
Date:   Wed, 20 May 2020 16:47:25 +0300
Message-ID: <20200520134734.2014-4-irusskikh@marvell.com>
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

From: Dmitry Bezrukov <dbezrukov@marvell.com>

This patch contains the following changes:
* add cfg->is_ptp (used for PTP enable/disable switch, which
  is described in more details below);
* add cfg->tc_mode (A1 supports 2 HW modes only);
* setup queue to TC mapping based on TC mode on A2;
* remove hw_tx_tc_mode_get / hw_rx_tc_mode_get hw_ops.

In the first generation of our hardware (A1), a whole traffic class is
consumed for PTP handling in FW (FW uses it to send the ptp data and to
send back timestamps).
Since this conflicts with QoS (user is unable to use the reserved TC2),
we suggest using module param to give the user a choice: disabling PTP
allows using all available TCs.

Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Co-developed-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |  3 ++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    | 10 +++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 30 +++++++++-----
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 27 ++++++-------
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 25 ++++--------
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 40 ++++++++++++++-----
 7 files changed, 82 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index 52b9833fda99..b6c5661950c7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -44,6 +44,9 @@
 /* LRO */
 #define AQ_CFG_IS_LRO_DEF           1U
 
+/* PTP */
+#define AQ_CFG_PTP_DEF              1U
+
 /* RSS */
 #define AQ_CFG_RSS_INDIRECTION_TABLE_MAX  64U
 #define AQ_CFG_RSS_HASHKEY_SIZE           40U
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 703ef8d064a2..c3df9da6088c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -18,6 +18,12 @@
 #define AQ_HW_MAC_COUNTER_HZ   312500000ll
 #define AQ_HW_PHY_COUNTER_HZ   160000000ll
 
+enum aq_tc_mode {
+	AQ_TC_MODE_INVALID = -1,
+	AQ_TC_MODE_8TCS,
+	AQ_TC_MODE_4TCS,
+};
+
 #define AQ_RX_FIRST_LOC_FVLANID     0U
 #define AQ_RX_LAST_LOC_FVLANID	   15U
 #define AQ_RX_FIRST_LOC_FETHERT    16U
@@ -281,10 +287,6 @@ struct aq_hw_ops {
 	int (*hw_set_offload)(struct aq_hw_s *self,
 			      struct aq_nic_cfg_s *aq_nic_cfg);
 
-	int (*hw_tx_tc_mode_get)(struct aq_hw_s *self, u32 *tc_mode);
-
-	int (*hw_rx_tc_mode_get)(struct aq_hw_s *self, u32 *tc_mode);
-
 	int (*hw_ring_hwts_rx_fill)(struct aq_hw_s *self,
 				    struct aq_ring_s *aq_ring);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index b003f1035701..caa971233f07 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -39,6 +39,10 @@ static unsigned int aq_itr_rx;
 module_param_named(aq_itr_rx, aq_itr_rx, uint, 0644);
 MODULE_PARM_DESC(aq_itr_rx, "RX interrupt throttle rate");
 
+static bool aq_enable_ptp = AQ_CFG_PTP_DEF;
+module_param(aq_enable_ptp, bool, 0644);
+MODULE_PARM_DESC(aq_enable_ptp, "Enable PTP");
+
 static void aq_nic_update_ndev_stats(struct aq_nic_s *self);
 
 static void aq_nic_rss_init(struct aq_nic_s *self, unsigned int num_rss_queues)
@@ -89,6 +93,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 	cfg->is_autoneg = AQ_CFG_IS_AUTONEG_DEF;
 
 	cfg->is_lro = AQ_CFG_IS_LRO_DEF;
+	cfg->is_ptp = aq_enable_ptp;
 
 	/*descriptors */
 	cfg->rxds = min(cfg->aq_hw_caps->rxds_max, AQ_CFG_RXDS_DEF);
@@ -122,6 +127,11 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 		cfg->vecs = 1U;
 	}
 
+	if (cfg->vecs <= 4)
+		cfg->tc_mode = AQ_TC_MODE_8TCS;
+	else
+		cfg->tc_mode = AQ_TC_MODE_4TCS;
+
 	/* Check if we have enough vectors allocated for
 	 * link status IRQ. If no - we'll know link state from
 	 * slower service task.
@@ -409,17 +419,19 @@ int aq_nic_init(struct aq_nic_s *self)
 		aq_vec_init(aq_vec, self->aq_hw_ops, self->aq_hw);
 	}
 
-	err = aq_ptp_init(self, self->irqvecs - 1);
-	if (err < 0)
-		goto err_exit;
+	if (aq_nic_get_cfg(self)->is_ptp) {
+		err = aq_ptp_init(self, self->irqvecs - 1);
+		if (err < 0)
+			goto err_exit;
 
-	err = aq_ptp_ring_alloc(self);
-	if (err < 0)
-		goto err_exit;
+		err = aq_ptp_ring_alloc(self);
+		if (err < 0)
+			goto err_exit;
 
-	err = aq_ptp_ring_init(self);
-	if (err < 0)
-		goto err_exit;
+		err = aq_ptp_ring_init(self);
+		if (err < 0)
+			goto err_exit;
+	}
 
 	netif_carrier_off(self->ndev);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 0663b8d0220d..3434f8206823 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -59,6 +59,8 @@ struct aq_nic_cfg_s {
 	bool is_polling;
 	bool is_rss;
 	bool is_lro;
+	bool is_ptp;
+	enum aq_tc_mode tc_mode;
 	u32 priv_flags;
 	u8  tcs;
 	struct aq_rss_parameters aq_rss;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 58e8c641e8b3..9aee49c50f1f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -945,26 +945,29 @@ void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
 #define PTP_4TC_RING_IDX            16
 #define PTP_HWST_RING_IDX           31
 
+/* Index must be 8 (8 TCs) or 16 (4 TCs).
+ * It depends on Traffic Class mode.
+ */
+unsigned int ptp_ring_idx(const enum aq_tc_mode tc_mode)
+{
+	if (tc_mode == AQ_TC_MODE_8TCS)
+		return PTP_8TC_RING_IDX;
+
+	return PTP_4TC_RING_IDX;
+}
+
 int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
 	unsigned int tx_ring_idx, rx_ring_idx;
 	struct aq_ring_s *hwts;
-	u32 tx_tc_mode, rx_tc_mode;
 	struct aq_ring_s *ring;
 	int err;
 
 	if (!aq_ptp)
 		return 0;
 
-	/* Index must to be 8 (8 TCs) or 16 (4 TCs).
-	 * It depends from Traffic Class mode.
-	 */
-	aq_nic->aq_hw_ops->hw_tx_tc_mode_get(aq_nic->aq_hw, &tx_tc_mode);
-	if (tx_tc_mode == 0)
-		tx_ring_idx = PTP_8TC_RING_IDX;
-	else
-		tx_ring_idx = PTP_4TC_RING_IDX;
+	tx_ring_idx = ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
 	ring = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
 				tx_ring_idx, &aq_nic->aq_nic_cfg);
@@ -973,11 +976,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 		goto err_exit;
 	}
 
-	aq_nic->aq_hw_ops->hw_rx_tc_mode_get(aq_nic->aq_hw, &rx_tc_mode);
-	if (rx_tc_mode == 0)
-		rx_ring_idx = PTP_8TC_RING_IDX;
-	else
-		rx_ring_idx = PTP_4TC_RING_IDX;
+	rx_ring_idx = ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
 	ring = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
 				rx_ring_idx, &aq_nic->aq_nic_cfg);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 0ff3f6eea022..7caf586ea56c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -131,13 +131,16 @@ static int hw_atl_b0_tc_ptp_set(struct aq_hw_s *self)
 
 static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 {
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	u32 tx_buff_size = HW_ATL_B0_TXBUF_MAX;
 	u32 rx_buff_size = HW_ATL_B0_RXBUF_MAX;
 	unsigned int i_priority = 0U;
 	u32 tc = 0U;
 
-	tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
-	rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
+	if (cfg->is_ptp) {
+		tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
+		rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
+	}
 
 	/* TPS Descriptor rate init */
 	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
@@ -180,7 +183,8 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 
 	hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
 
-	hw_atl_b0_tc_ptp_set(self);
+	if (cfg->is_ptp)
+		hw_atl_b0_tc_ptp_set(self);
 
 	/* QoS 802.1p priority -> TC mapping */
 	for (i_priority = 8U; i_priority--;)
@@ -1079,18 +1083,6 @@ int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
 	return aq_hw_err_from_flags(self);
 }
 
-static int hw_atl_b0_tx_tc_mode_get(struct aq_hw_s *self, u32 *tc_mode)
-{
-	*tc_mode = hw_atl_tpb_tps_tx_tc_mode_get(self);
-	return aq_hw_err_from_flags(self);
-}
-
-static int hw_atl_b0_rx_tc_mode_get(struct aq_hw_s *self, u32 *tc_mode)
-{
-	*tc_mode = hw_atl_rpb_rpf_rx_traf_class_mode_get(self);
-	return aq_hw_err_from_flags(self);
-}
-
 #define get_ptp_ts_val_u64(self, indx) \
 	((u64)(hw_atl_pcs_ptp_clock_get(self, indx) & 0xffff))
 
@@ -1508,9 +1500,6 @@ const struct aq_hw_ops hw_atl_ops_b0 = {
 	.hw_get_hw_stats             = hw_atl_utils_get_hw_stats,
 	.hw_get_fw_version           = hw_atl_utils_get_fw_version,
 
-	.hw_tx_tc_mode_get       = hw_atl_b0_tx_tc_mode_get,
-	.hw_rx_tc_mode_get       = hw_atl_b0_rx_tc_mode_get,
-
 	.hw_ring_hwts_rx_fill        = hw_atl_b0_hw_ring_hwts_rx_fill,
 	.hw_ring_hwts_rx_receive     = hw_atl_b0_hw_ring_hwts_rx_receive,
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index ccdb74562270..a14118550882 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -91,16 +91,36 @@ static int hw_atl2_hw_reset(struct aq_hw_s *self)
 
 static int hw_atl2_hw_queue_to_tc_map_set(struct aq_hw_s *self)
 {
-	if (!hw_atl_rpb_rpf_rx_traf_class_mode_get(self)) {
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(0), 0x11110000);
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(8), 0x33332222);
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(16), 0x55554444);
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(24), 0x77776666);
-	} else {
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(0), 0x00000000);
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(8), 0x11111111);
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(16), 0x22222222);
-		aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(24), 0x33333333);
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+	unsigned int tcs, q_per_tc;
+	unsigned int tc, q;
+	u32 value = 0;
+
+	switch (cfg->tc_mode) {
+	case AQ_TC_MODE_8TCS:
+		tcs = 8;
+		q_per_tc = 4;
+		break;
+	case AQ_TC_MODE_4TCS:
+		tcs = 4;
+		q_per_tc = 8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (tc = 0; tc != tcs; tc++) {
+		unsigned int tc_q_offset = tc * q_per_tc;
+
+		for (q = tc_q_offset; q != tc_q_offset + q_per_tc; q++)
+			value |= tc << HW_ATL2_RX_Q_TC_MAP_SHIFT(q);
+
+		if (HW_ATL2_RX_Q_TC_MAP_ADR(q) !=
+		    HW_ATL2_RX_Q_TC_MAP_ADR(q - 1)) {
+			aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(q - 1),
+					value);
+			value = 0;
+		}
 	}
 
 	return aq_hw_err_from_flags(self);
-- 
2.25.1

