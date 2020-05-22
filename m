Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAEB1DE1AC
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgEVIUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:20:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728839AbgEVIUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 04:20:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M8FKrf032651;
        Fri, 22 May 2020 01:20:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=UcQKkYRr5jGxf2RjEm8r3w5N/W3QddXa92jvgyZRK1s=;
 b=I+yMFhm94VsBiyNQMMkbXl6PCywNCoZzRWn4gjqDrINmKmKMiIhN6dRvGZawC1Pw+Pfe
 ENC5g3DWFo8QS5UbfWsAqGWXD9OevubMFq8P8fkQaUElyo5QdbbHSyhUaV9YfPqGA4vO
 xw5dHqJTKXV7ok6SgC1Xn5ygUeQw8f3Rq0Ylk+jAW8+so9SP1ckSuEOhT9/kKOYYcFt9
 3l0srOJ++0xXF0SoGEaO/xmCsN85bEeuHu3396eanQ+adXeQRfEDmf7COFgk3/rrG+QE
 Ck/tr7RIjyF3F2WV6hFrZqxSfaul1amPRUPz3MFNazgp6x64Kt6U2xNgKgy+AzMHYoxo Kg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhr29e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 01:20:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 01:20:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 01:20:01 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 68C7C3F7041;
        Fri, 22 May 2020 01:19:59 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 03/12] net: atlantic: changes for multi-TC support
Date:   Fri, 22 May 2020 11:19:39 +0300
Message-ID: <20200522081948.167-4-irusskikh@marvell.com>
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
The 'is_ptp' flag introduced in this patch will be used in to automatically
disable PTP when a conflicting configuration is detected, e.g. when
multiple TCs are enabled.

Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Co-developed-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    | 10 +++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 26 +++++++-----
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 27 ++++++-------
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 25 ++++--------
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 40 ++++++++++++++-----
 6 files changed, 75 insertions(+), 55 deletions(-)

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
index b003f1035701..3eeb652068e2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -89,6 +89,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 	cfg->is_autoneg = AQ_CFG_IS_AUTONEG_DEF;
 
 	cfg->is_lro = AQ_CFG_IS_LRO_DEF;
+	cfg->is_ptp = true;
 
 	/*descriptors */
 	cfg->rxds = min(cfg->aq_hw_caps->rxds_max, AQ_CFG_RXDS_DEF);
@@ -122,6 +123,11 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
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
@@ -409,17 +415,19 @@ int aq_nic_init(struct aq_nic_s *self)
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
index 58e8c641e8b3..599ced261b2a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -945,26 +945,29 @@ void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
 #define PTP_4TC_RING_IDX            16
 #define PTP_HWST_RING_IDX           31
 
+/* Index must be 8 (8 TCs) or 16 (4 TCs).
+ * It depends on Traffic Class mode.
+ */
+static unsigned int ptp_ring_idx(const enum aq_tc_mode tc_mode)
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

