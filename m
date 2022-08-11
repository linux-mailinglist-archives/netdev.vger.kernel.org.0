Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADF59021D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiHKQDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiHKQDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93EBBC9;
        Thu, 11 Aug 2022 08:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2FF860DD7;
        Thu, 11 Aug 2022 15:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA82C433D7;
        Thu, 11 Aug 2022 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232990;
        bh=bhhV4Nhie3v1Rww2WwGnEWmY1+nfvJttYCbx1pBQg5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDCWw/8j/PcWQPsZZObdy/nt/JL0RE7ii5xuZBEPlXheHOoA3+3Xhs/RSFwuX4aEJ
         Xc2PpsDV8arM6l/bBEMlfe8rtF9sDHxCxBUfAwwIw7XZO18IIICMg4382ANh08kfSv
         JE9Eb1wZtZmhzanwo0VtpFxvJuVaVz6ONdG4q81jxfSX4xGhDsVzhDoR/AciLu7AuR
         IWofRMRoYetK72dShMtkhZIfmNkJXMxBOup8C7vNkQ0IJKARvTjBdrUOAhgDKt3rm+
         lrnpvVkmB4xr9OCGlu1fD1oa/woK427Y+Kd03C1FU6BL8X4e2RPQVQzd8ib8z8n1C8
         /Zg+K6udYUZPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 59/93] octeontx2-af: Don't reset previous pfc config
Date:   Thu, 11 Aug 2022 11:41:53 -0400
Message-Id: <20220811154237.1531313-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 8e1514579246ddc36ba0b860fc8bdd03be085aee ]

Current implementation is such that driver first resets the
existing PFC config before applying new pfc configuration.
This creates a problem like once PF or VFs requests PFC config
previous pfc config by other PFVfs is getting reset.

This patch fixes the problem by removing unnecessary resetting
of PFC config. Also configure Pause quanta value to smaller as
current value is too high.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
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
2.35.1

