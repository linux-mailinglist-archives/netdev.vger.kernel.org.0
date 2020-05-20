Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921751DB585
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgETNsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:48:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60652 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbgETNsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:48:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDeVTH003329;
        Wed, 20 May 2020 06:47:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hGBZqXGkmtMlDVHFmefUNC8JQOGmQ+Yr+jdIs16Nsko=;
 b=dFjyGXrCTW5v3Ai3t7Zg5eqWwWxBrvpcbyAlYaAT440U9mjejKvoL8MfCF970y6KgT8x
 tjjyVf9C7coIGSCWY6B+AXEhYh4KPADiWvaVjAYeuErQbTNM/kHGrFPajCQR9TgUyKus
 m43WfG6z0CRZb+7GQ4Hcgi9hI5aMZzZXkJu40AIqtxvnSQMBw0mVAw7JNMQBu+MDzIPf
 dJ3OM3qEMkB4cahqd1sgxyTqDUy6UBLaxez68PXzV80k0UU3cRwhZ5ESjJJ7vBEH3naJ
 XKXd6T9oLg0YEd5akghfkziwUY9bAyrUFkKVm/Q5eMRo3O4HDPb7Xom10aiM6feLUKvI QA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs5an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:58 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id DBA7E3F703F;
        Wed, 20 May 2020 06:47:56 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 09/12] net: atlantic: always use random TC-queue mapping for TX on A2.
Date:   Wed, 20 May 2020 16:47:31 +0300
Message-ID: <20200520134734.2014-10-irusskikh@marvell.com>
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

This patch changes the TC-queue mapping mechanism used on A2.
Configure the A2 HW in such a way that we can keep queue index mapping
exactly as it was on A1.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 31 ++++++++++-----
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |  9 +++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  4 ++
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 39 ++++++++++++++++++-
 4 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index b42ff81adfeb..a5bffadde6df 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -95,7 +95,10 @@ static int hw_atl2_hw_queue_to_tc_map_set(struct aq_hw_s *self)
 	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
 	unsigned int tcs, q_per_tc;
 	unsigned int tc, q;
-	u32 value = 0;
+	u32 rx_map = 0;
+	u32 tx_map = 0;
+
+	hw_atl2_tpb_tx_tc_q_rand_map_en_set(self, 1U);
 
 	switch (cfg->tc_mode) {
 	case AQ_TC_MODE_8TCS:
@@ -113,14 +116,24 @@ static int hw_atl2_hw_queue_to_tc_map_set(struct aq_hw_s *self)
 	for (tc = 0; tc != tcs; tc++) {
 		unsigned int tc_q_offset = tc * q_per_tc;
 
-		for (q = tc_q_offset; q != tc_q_offset + q_per_tc; q++)
-			value |= tc << HW_ATL2_RX_Q_TC_MAP_SHIFT(q);
+		for (q = tc_q_offset; q != tc_q_offset + q_per_tc; q++) {
+			rx_map |= tc << HW_ATL2_RX_Q_TC_MAP_SHIFT(q);
+			if (HW_ATL2_RX_Q_TC_MAP_ADR(q) !=
+			    HW_ATL2_RX_Q_TC_MAP_ADR(q + 1)) {
+				aq_hw_write_reg(self,
+						HW_ATL2_RX_Q_TC_MAP_ADR(q),
+						rx_map);
+				rx_map = 0;
+			}
 
-		if (HW_ATL2_RX_Q_TC_MAP_ADR(q) !=
-		    HW_ATL2_RX_Q_TC_MAP_ADR(q - 1)) {
-			aq_hw_write_reg(self, HW_ATL2_RX_Q_TC_MAP_ADR(q - 1),
-					value);
-			value = 0;
+			tx_map |= tc << HW_ATL2_TX_Q_TC_MAP_SHIFT(q);
+			if (HW_ATL2_TX_Q_TC_MAP_ADR(q) !=
+			    HW_ATL2_TX_Q_TC_MAP_ADR(q + 1)) {
+				aq_hw_write_reg(self,
+						HW_ATL2_TX_Q_TC_MAP_ADR(q),
+						tx_map);
+				tx_map = 0;
+			}
 		}
 	}
 
@@ -181,7 +194,7 @@ static int hw_atl2_hw_qos_set(struct aq_hw_s *self)
 		hw_atl_rpf_rpb_user_priority_tc_map_set(self, prio,
 							cfg->prio_tc_map[prio]);
 
-	/* ATL2 Apply legacy ring to TC mapping */
+	/* ATL2 Apply ring to TC mapping */
 	hw_atl2_hw_queue_to_tc_map_set(self);
 
 	return aq_hw_err_from_flags(self);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index f096d0a6bda9..6817fa57cc83 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -68,6 +68,15 @@ void hw_atl2_rpf_vlan_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter)
 
 /* TX */
 
+void hw_atl2_tpb_tx_tc_q_rand_map_en_set(struct aq_hw_s *aq_hw,
+					 const u32 tc_q_rand_map_en)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_ADR,
+			    HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_MSK,
+			    HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_SHIFT,
+			    tc_q_rand_map_en);
+}
+
 void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_ADR,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index 5c1ae755ffae..d4b087d1dec1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -38,6 +38,10 @@ void hw_atl2_new_rpf_rss_redir_set(struct aq_hw_s *aq_hw, u32 tc, u32 index,
 /* Set VLAN filter tag */
 void hw_atl2_rpf_vlan_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter);
 
+/* set tx random TC-queue mapping enable bit */
+void hw_atl2_tpb_tx_tc_q_rand_map_en_set(struct aq_hw_s *aq_hw,
+					 const u32 tc_q_rand_map_en);
+
 /* set tx buffer clock gate enable */
 void hw_atl2_tpb_tx_buf_clk_gate_en_set(struct aq_hw_s *aq_hw, u32 clk_gate_en);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
index b0ac8cd581d7..bf0198ca4e85 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -132,6 +132,24 @@
 /* Default value of bitfield rx_q{Q}_tc_map[2:0] */
 #define HW_ATL2_RX_Q_TC_MAP_DEFAULT 0x0
 
+/* tx tx_tc_q_rand_map_en bitfield definitions
+ * preprocessor definitions for the bitfield "tx_tc_q_rand_map_en".
+ * port="pif_tpb_tx_tc_q_rand_map_en_i"
+ */
+
+/* register address for bitfield tx_tc_q_rand_map_en */
+#define HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_ADR 0x00007900
+/* bitmask for bitfield tx_tc_q_rand_map_en */
+#define HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_MSK 0x00000200
+/* inverted bitmask for bitfield tx_tc_q_rand_map_en */
+#define HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_MSKN 0xFFFFFDFF
+/* lower bit position of bitfield tx_tc_q_rand_map_en */
+#define HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_SHIFT 9
+/* width of bitfield tx_tc_q_rand_map_en */
+#define HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_WIDTH 1
+/* default value of bitfield tx_tc_q_rand_map_en */
+#define HW_ATL2_TPB_TX_TC_Q_RAND_MAP_EN_DEFAULT 0x0
+
 /* tx tx_buffer_clk_gate_en bitfield definitions
  * preprocessor definitions for the bitfield "tx_buffer_clk_gate_en".
  * port="pif_tpb_tx_buffer_clk_gate_en_i"
@@ -150,8 +168,25 @@
 /* default value of bitfield tx_buffer_clk_gate_en */
 #define HW_ATL2_TPB_TX_BUF_CLK_GATE_EN_DEFAULT 0x0
 
-/* tx data_tc{t}_credit_max[b:0] bitfield definitions
- * preprocessor definitions for the bitfield "data_tc{t}_credit_max[b:0]".
+/* tx tx_q_tc_map{q} bitfield definitions
+ * preprocessor definitions for the bitfield "tx_q_tc_map{q}".
+ * parameter: queue {q} | bit-level stride | range [0, 31]
+ * port="pif_tpb_tx_q_tc_map0_i[2:0]"
+ */
+
+/* register address for bitfield tx_q_tc_map{q} */
+#define HW_ATL2_TX_Q_TC_MAP_ADR(queue) \
+	(((queue) < 32) ? 0x0000799C + ((queue) / 4) * 4 : 0)
+/* lower bit position of bitfield tx_q_tc_map{q} */
+#define HW_ATL2_TX_Q_TC_MAP_SHIFT(queue) \
+	(((queue) < 32) ? ((queue) * 8) % 32 : 0)
+/* width of bitfield tx_q_tc_map{q} */
+#define HW_ATL2_TX_Q_TC_MAP_WIDTH 3
+/* default value of bitfield tx_q_tc_map{q} */
+#define HW_ATL2_TX_Q_TC_MAP_DEFAULT 0x0
+
+/* tx data_tc{t}_credit_max[f:0] bitfield definitions
+ * preprocessor definitions for the bitfield "data_tc{t}_credit_max[f:0]".
  * parameter: tc {t} | stride size 0x4 | range [0, 7]
  * port="pif_tps_data_tc0_credit_max_i[11:0]"
  */
-- 
2.25.1

