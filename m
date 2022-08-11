Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3556A58FA26
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbiHKJgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiHKJgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:36:49 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C5D90802
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 02:36:48 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 3D76E7F4F5;
        Thu, 11 Aug 2022 11:36:47 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29BB634064;
        Thu, 11 Aug 2022 11:36:47 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1215A3405A;
        Thu, 11 Aug 2022 11:36:47 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu, 11 Aug 2022 11:36:47 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id D640F7F4F5;
        Thu, 11 Aug 2022 11:36:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660210606; bh=Bn8bnpNPEC59sfJ6GrU3Jl0xJ31mOvpr3jMgMoAI90M=;
        h=From:To:CC:Subject:Date:From;
        b=UGk/sQsir+E6OPHbPVyusL9iY3sxFNMCU+ZPs/k7ItPbpjTJvfRbrq6AOvawH03eF
         q/YvDfBArcO+g5qqkdarRzOCNNQfLspix9jYhefP0pAwdkxGwLSg12rT5L9dV90EzJ
         WbIHRjiLGkkNgu0LV90k6/yNpvG6VcnOQoRfwD45j0yYMV1q9+PFvYAb6MjFMh+SQF
         vlX2Dbqc4xvUfQVVn5pdU23XVLpTNdJ1W7uQ2KN95rtsqIuzU0slpOmtxFStq3MEy/
         KbCsEqm4I2FDXCc6t7fU8T+s095Fxo5b9HNP0pwUq6HuRuMExnSX4u7F5J2rlaZEEC
         d/n3yjjQ8yWJQ==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.9; Thu, 11 Aug 2022 11:36:46 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Thu, 11 Aug 2022 11:36:45 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH v2] fec: Restart PPS after link state change
Date:   Thu, 11 Aug 2022 11:34:53 +0200
Message-ID: <20220811093452.5453-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1660210606;VERSION=7933;MC=42982662;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF456617362
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On link state change, the controller gets reset,
causing PPS to drop out. So we restart it if needed.

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++--
 drivers/net/ethernet/freescale/fec_ptp.c  |  3 +++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 366c52b62d4b..546a152df4f4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -257,6 +257,9 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_MMFR_TA		(2 << 16)
 #define FEC_MMFR_DATA(v)	(v & 0xffff)
 /* FEC ECR bits definition */
+#define FEC_ECR_RESET   	(1 << 0)
+#define FEC_ECR_ETHEREN 	(1 << 1)
+#define FEC_ECR_EN1588  	(1 << 4)
 #define FEC_ECR_MAGICEN		(1 << 2)
 #define FEC_ECR_SLEEP		(1 << 3)
 
@@ -955,6 +958,7 @@ fec_restart(struct net_device *ndev)
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = 0x2; /* ETHEREN */
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1106,7 +1110,7 @@ fec_restart(struct net_device *ndev)
 	}
 
 	if (fep->bufdesc_ex)
-		ecntl |= (1 << 4);
+		ecntl |= FEC_ECR_EN1588;
 
 #ifndef CONFIG_M5272
 	/* Enable the MIB statistic event counters */
@@ -1120,6 +1124,13 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		fec_ptp_start_cyclecounter(ndev);
 
+	/* Restart PPS if needed */
+	if (fep->pps_enable) {
+		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
+		fep->pps_enable = 0;
+		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
+	}
+
 	/* Enable interrupts we wish to service */
 	if (fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
@@ -1155,6 +1166,8 @@ fec_stop(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+	u32 ecntl = 0;
 
 	/* We cannot expect a graceful transmit stop without link !!! */
 	if (fep->link) {
@@ -1185,12 +1198,27 @@ fec_stop(struct net_device *ndev)
 	}
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
+	if (fep->bufdesc_ex)
+		ecntl |= FEC_ECR_EN1588;
+
 	/* We have to keep ENET enabled to have MII interrupt stay working */
 	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
 		!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		writel(2, fep->hwp + FEC_ECNTRL);
+		ecntl |= FEC_ECR_ETHEREN;
 		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
 	}
+
+	writel(ecntl, fep->hwp + FEC_ECNTRL);
+
+	if (fep->bufdesc_ex)
+		fec_ptp_start_cyclecounter(ndev);
+
+	/* Restart PPS if needed */
+	if (fep->pps_enable) {
+		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
+		fep->pps_enable = 0;
+		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
+	}
 }
 
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index a5077eff305b..869d149efc53 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -628,6 +628,9 @@ void fec_ptp_stop(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	if (fep->pps_enable)
+		fec_ptp_enable_pps(fep, 0);
+
 	cancel_delayed_work_sync(&fep->time_keep);
 	if (fep->ptp_clock)
 		ptp_clock_unregister(fep->ptp_clock);
-- 
2.25.1

