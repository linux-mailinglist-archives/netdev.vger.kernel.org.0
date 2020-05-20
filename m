Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB111DB57D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgETNrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:47:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59558 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726688AbgETNrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:47:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDfCT6015126;
        Wed, 20 May 2020 06:47:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=GpP/JHZaDLQ76S/n73Zu/e6/AYWhsYjh2ZbHXcatMQg=;
 b=Zuh/bixWGCkBEChKC8mtMpx8doQvan5uQDLc1TSicdRxWjMotBeGTi3uhdGDppNDxINZ
 lLrplEkd0962hqJWyoqNC6jgugRdQRJgyqcSGTd2inKoCDIxMwxMxQJlRHjKCd0+FBIS
 AV4QxOqTRotCMHXrKhrQZjTqmaWd/IPhpksEouR141TWjCa/yr3YoAvALqFPvQBxIr+e
 D0VEs4ioQoFmjTVzmLSXv3GyDiNoeFXBMEboA5B6wegLBPk3WTZnykgX07DACuwZykrB
 Iv1K1pmeCk7a0nEEmL5R26qc8DSIrUO670ooWQR5q3wWNPWN7xRhKmShcXTNy1TVdey2 nQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpp8krk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:43 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id BB6BF3F703F;
        Wed, 20 May 2020 06:47:41 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 02/12] net: atlantic: move PTP TC initialization to a separate function
Date:   Wed, 20 May 2020 16:47:24 +0300
Message-ID: <20200520134734.2014-3-irusskikh@marvell.com>
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

This patch moves the PTP TC initialization into a separate function.

Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
Co-developed-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index bee4fb3c8741..0ff3f6eea022 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -114,6 +114,21 @@ static int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc)
 	return 0;
 }
 
+static int hw_atl_b0_tc_ptp_set(struct aq_hw_s *self)
+{
+	/* Init TC2 for PTP_TX */
+	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_TXBUF_SIZE,
+					       AQ_HW_PTP_TC);
+
+	/* Init TC2 for PTP_RX */
+	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_RXBUF_SIZE,
+					       AQ_HW_PTP_TC);
+	/* No flow control for PTP */
+	hw_atl_rpb_rx_xoff_en_per_tc_set(self, 0U, AQ_HW_PTP_TC);
+
+	return aq_hw_err_from_flags(self);
+}
+
 static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 {
 	u32 tx_buff_size = HW_ATL_B0_TXBUF_MAX;
@@ -121,6 +136,9 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	unsigned int i_priority = 0U;
 	u32 tc = 0U;
 
+	tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
+	rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
+
 	/* TPS Descriptor rate init */
 	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
 	hw_atl_tps_tx_pkt_shed_desc_rate_lim_set(self, 0xA);
@@ -139,8 +157,6 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 	hw_atl_tps_tx_pkt_shed_desc_tc_weight_set(self, 0x1E, tc);
 
 	/* Tx buf size TC0 */
-	tx_buff_size -= HW_ATL_B0_PTP_TXBUF_SIZE;
-
 	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, tx_buff_size, tc);
 	hw_atl_tpb_tx_buff_hi_threshold_per_tc_set(self,
 						   (tx_buff_size *
@@ -150,13 +166,8 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 						   (tx_buff_size *
 						   (1024 / 32U) * 50U) /
 						   100U, tc);
-	/* Init TC2 for PTP_TX */
-	hw_atl_tpb_tx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_TXBUF_SIZE,
-					       AQ_HW_PTP_TC);
 
 	/* QoS Rx buf size per TC */
-	rx_buff_size -= HW_ATL_B0_PTP_RXBUF_SIZE;
-
 	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, rx_buff_size, tc);
 	hw_atl_rpb_rx_buff_hi_threshold_per_tc_set(self,
 						   (rx_buff_size *
@@ -169,11 +180,7 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 
 	hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
 
-	/* Init TC2 for PTP_RX */
-	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, HW_ATL_B0_PTP_RXBUF_SIZE,
-					       AQ_HW_PTP_TC);
-	/* No flow control for PTP */
-	hw_atl_rpb_rx_xoff_en_per_tc_set(self, 0U, AQ_HW_PTP_TC);
+	hw_atl_b0_tc_ptp_set(self);
 
 	/* QoS 802.1p priority -> TC mapping */
 	for (i_priority = 8U; i_priority--;)
-- 
2.25.1

