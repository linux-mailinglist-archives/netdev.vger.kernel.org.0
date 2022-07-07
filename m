Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A170356A81E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiGGQbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiGGQbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:31:01 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202742A260;
        Thu,  7 Jul 2022 09:31:01 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267A5vUj008113;
        Thu, 7 Jul 2022 09:30:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=MUJjQH1xdx9P6LYZOnnQzblD2ccmaLeiXo/c2Rlin3E=;
 b=AX31hYoB+V+bqwcJwkCxpaN8gYyPqgkUiLCiO1fwPHvDoPUknOz4g4P1eDb3JQq6t0Ex
 k/QBusUaf6jmJ/PFbjApljqzcWwu+e+SXHHIu+7UmgCWcDwoKJ7LFmKp8dJ4o6+d4XzJ
 xdusbhUeHe+mHEsoihU4Hxr2T0rmcLlSvxblKL36fivUAHpvLxxHj6nWNsHLH844PeSU
 FdAj4W5j09LDvZNS4Thu9FCowu0UG/wJWguh/n4OpzeGwREVTIQ02AOTR1eFu87erzDU
 cslllHMnf/o0MU5ygJP2KHRkYMl27K9FHEWvAEvngO1gsIt2oqepTInd0EbsM3XBTZJa 2w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h5kwj3he2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 09:30:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 09:30:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 7 Jul 2022 09:30:53 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E35305B6928;
        Thu,  7 Jul 2022 09:30:49 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH V2] octeontx2-af: Don't reset previous pfc config
Date:   Thu, 7 Jul 2022 22:00:48 +0530
Message-ID: <20220707163048.7709-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: W9WNG3sLdi92WFYSAXymVWKUvv2XwG9Q
X-Proofpoint-GUID: W9WNG3sLdi92WFYSAXymVWKUvv2XwG9Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_13,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation is such that driver first resets the
existing PFC config before applying new pfc configuration.
This creates a problem like once PF or VFs requests PFC config
previous pfc config by other PFVfs is getting reset.

This patch fixes the problem by removing unnecessary resetting
of PFC config. Also configure Pause quanta value to smaller as
current value is too high.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
V2 * resending patch as earlier patch has 'missing maintainers" warning

 .../net/ethernet/marvell/octeontx2/af/cgx.c    | 15 +++++++++++----
 .../net/ethernet/marvell/octeontx2/af/rpm.c    | 18 +++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rpm.h    |  3 +--
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 25491edc35ce..931a1a7ebf76 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -847,6 +847,11 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 	cfg |= CGX_CMR_RX_OVR_BP_EN(lmac_id);
 	cfg &= ~CGX_CMR_RX_OVR_BP_BP(lmac_id);
 	cgx_write(cgx, 0, CGXX_CMR_RX_OVR_BP, cfg);
+
+	/* Disable all PFC classes by default */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_CBFC_CTL);
+	cfg = FIELD_SET(CGX_PFC_CLASS_MASK, 0, cfg);
+	cgx_write(cgx, lmac_id, CGXX_SMUX_CBFC_CTL, cfg);
 }

 int verify_lmac_fc_cfg(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
@@ -899,6 +904,7 @@ int cgx_lmac_pfc_config(void *cgxd, int lmac_id, u8 tx_pause,
 		return 0;

 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_CBFC_CTL);
+	pfc_en |= FIELD_GET(CGX_PFC_CLASS_MASK, cfg);

 	if (rx_pause) {
 		cfg |= (CGXX_SMUX_CBFC_CTL_RX_EN |
@@ -910,12 +916,13 @@ int cgx_lmac_pfc_config(void *cgxd, int lmac_id, u8 tx_pause,
 			CGXX_SMUX_CBFC_CTL_DRP_EN);
 	}

-	if (tx_pause)
+	if (tx_pause) {
 		cfg |= CGXX_SMUX_CBFC_CTL_TX_EN;
-	else
+		cfg = FIELD_SET(CGX_PFC_CLASS_MASK, pfc_en, cfg);
+	} else {
 		cfg &= ~CGXX_SMUX_CBFC_CTL_TX_EN;
-
-	cfg = FIELD_SET(CGX_PFC_CLASS_MASK, pfc_en, cfg);
+		cfg = FIELD_SET(CGX_PFC_CLASS_MASK, 0, cfg);
+	}

 	cgx_write(cgx, lmac_id, CGXX_SMUX_CBFC_CTL, cfg);

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 47e83d7a5804..05666922a45b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -276,6 +276,11 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
 	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
 	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
+	/* Disable all PFC classes */
+	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
+	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, 0, cfg);
+	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
 }

 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
@@ -387,15 +392,14 @@ void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable)
 int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 pfc_en)
 {
 	rpm_t *rpm = rpmd;
-	u64 cfg;
+	u64 cfg, class_en;

 	if (!is_lmac_valid(rpm, lmac_id))
 		return -ENODEV;

-	/* reset PFC class quanta and threshold */
-	rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xffff, false);
-
 	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	class_en = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
+	pfc_en |= FIELD_GET(RPM_PFC_CLASS_MASK, class_en);

 	if (rx_pause) {
 		cfg &= ~(RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE |
@@ -410,9 +414,11 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 p
 	if (tx_pause) {
 		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, pfc_en, true);
 		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+		class_en = FIELD_SET(RPM_PFC_CLASS_MASK, pfc_en, class_en);
 	} else {
 		rpm_cfg_pfc_quanta_thresh(rpm, lmac_id, 0xfff, false);
 		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+		class_en = FIELD_SET(RPM_PFC_CLASS_MASK, 0, class_en);
 	}

 	if (!rx_pause && !tx_pause)
@@ -422,9 +428,7 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 p

 	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);

-	cfg = rpm_read(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL);
-	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, pfc_en, cfg);
-	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
+	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, class_en);

 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 9ab8d49dd180..8205f2626f61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -48,7 +48,6 @@
 #define RPMX_MTI_MAC100X_CL1011_QUANTA_THRESH		0x8130
 #define RPMX_MTI_MAC100X_CL1213_QUANTA_THRESH		0x8138
 #define RPMX_MTI_MAC100X_CL1415_QUANTA_THRESH		0x8140
-#define RPM_DEFAULT_PAUSE_TIME			0xFFFF
 #define RPMX_CMR_RX_OVR_BP		0x4120
 #define RPMX_CMR_RX_OVR_BP_EN(x)	BIT_ULL((x) + 8)
 #define RPMX_CMR_RX_OVR_BP_BP(x)	BIT_ULL((x) + 4)
@@ -70,7 +69,7 @@
 #define RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD              BIT_ULL(7)
 #define RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA              0x80A8
 #define RPMX_MTI_MAC100X_CL89_PAUSE_QUANTA		0x8108
-#define RPM_DEFAULT_PAUSE_TIME                          0xFFFF
+#define RPM_DEFAULT_PAUSE_TIME                          0x7FF

 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
--
2.17.1
