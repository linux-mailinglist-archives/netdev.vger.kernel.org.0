Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F22591067
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiHLLzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiHLLzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:55:21 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B46EE38
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:55:19 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id A8AAA7F4EC;
        Fri, 12 Aug 2022 13:55:15 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9368534064;
        Fri, 12 Aug 2022 13:55:15 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AEE53405A;
        Fri, 12 Aug 2022 13:55:15 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Fri, 12 Aug 2022 13:55:15 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id 4AD077F4EC;
        Fri, 12 Aug 2022 13:55:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660305315; bh=SMktBeQjU9NuyEHoQoX/5CPiqNTsTVyeLeDB5RP43A8=;
        h=From:To:CC:Subject:Date:From;
        b=UBNmN3MzUTboUACEi1T829uWBPeDhhPIRxpAA2C4PEDIb0buakbLnI9s4HZss0/Ys
         QHEEa03CajzccLno7F4tbZlrpQI1c5BNpLgFMK+bNOW4AU+T5GwXmGe/4jN1La8vxW
         tgoMIyTC+QknIlD5ZLcg1U3CN1WjMyq08B0RPrx6VyS7n9s7Y7OuzHXLDfe9SsBHq+
         Fpt3ELMFT8h/wJAl44N91PUzZP323yy8FfRrrB83AoSrxpH361/mf9ECT62HD0antS
         qprXwyljcOBLWL+kD0qOrATL/tA142N6LsLcLL3frU6iN+vEUTWEqAnm50TGw238aK
         u7+TFF9+hgFCA==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.9; Fri, 12 Aug 2022 13:55:14 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Fri, 12 Aug 2022 13:55:14 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <qiangqing.zhang@nxp.com>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH] net: fec: Restart PPS after link state change
Date:   Fri, 12 Aug 2022 13:54:09 +0200
Message-ID: <20220812115408.12985-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1660305315;VERSION=7933;MC=3217631273;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF456617266
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
causing PPS to drop out and the PHC to lose its
time and calibration. So we restart it if needed,
restoring calibration and time registers.

Changes since v2:
* Add `fec_ptp_save_state()`/`fec_ptp_restore_state()`
* Use `ktime_get_real_ns()`
* Use `BIT()` macro
Changes since v1:
* More ECR #define's
* Stop PPS in `fec_ptp_stop()`

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec.h      | 10 ++++++
 drivers/net/ethernet/freescale/fec_main.c | 42 ++++++++++++++++++++---
 drivers/net/ethernet/freescale/fec_ptp.c  | 31 ++++++++++++++++-
 3 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0a343e68a87d..b656cda75c92 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -596,6 +596,13 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+	struct {
+		struct timespec64 ts_phc;
+		u64 ns_sys;
+		u32 at_corr;
+		u8 at_inc_corr;
+	} ptp_saved_state;
+
 	u64 ethtool_stats[];
 };
 
@@ -605,5 +612,8 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
+void fec_ptp_save_state(struct fec_enet_private *fep);
+int fec_ptp_restore_state(struct fec_enet_private *fep);
+
 /****************************************************************************/
 #endif /* FEC_H */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 366c52b62d4b..b414574d7501 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -257,8 +257,11 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_MMFR_TA		(2 << 16)
 #define FEC_MMFR_DATA(v)	(v & 0xffff)
 /* FEC ECR bits definition */
-#define FEC_ECR_MAGICEN		(1 << 2)
-#define FEC_ECR_SLEEP		(1 << 3)
+#define FEC_ECR_RESET   BIT(0)
+#define FEC_ECR_ETHEREN BIT(1)
+#define FEC_ECR_MAGICEN BIT(2)
+#define FEC_ECR_SLEEP   BIT(3)
+#define FEC_ECR_EN1588  BIT(4)
 
 #define FEC_MII_TIMEOUT		30000 /* us */
 
@@ -955,6 +958,9 @@ fec_restart(struct net_device *ndev)
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = 0x2; /* ETHEREN */
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+
+	fec_ptp_save_state(fep);
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1106,7 +1112,7 @@ fec_restart(struct net_device *ndev)
 	}
 
 	if (fep->bufdesc_ex)
-		ecntl |= (1 << 4);
+		ecntl |= FEC_ECR_EN1588;
 
 #ifndef CONFIG_M5272
 	/* Enable the MIB statistic event counters */
@@ -1120,6 +1126,14 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		fec_ptp_start_cyclecounter(ndev);
 
+	/* Restart PPS if needed */
+	if (fep->pps_enable) {
+		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
+		fep->pps_enable = 0;
+		fec_ptp_restore_state(fep);
+		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
+	}
+
 	/* Enable interrupts we wish to service */
 	if (fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
@@ -1155,6 +1169,8 @@ fec_stop(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+	u32 ecntl = 0;
 
 	/* We cannot expect a graceful transmit stop without link !!! */
 	if (fep->link) {
@@ -1164,6 +1180,8 @@ fec_stop(struct net_device *ndev)
 			netdev_err(ndev, "Graceful transmit stop did not complete!\n");
 	}
 
+	fec_ptp_save_state(fep);
+
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
@@ -1185,12 +1203,28 @@ fec_stop(struct net_device *ndev)
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
+		fec_ptp_restore_state(fep);
+		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
+	}
 }
 
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index a5077eff305b..60b3195a4ab4 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -269,7 +269,7 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
 	fep->cc.mult = FEC_CC_MULT;
 
 	/* reset the ns time counter */
-	timecounter_init(&fep->tc, &fep->cc, ktime_to_ns(ktime_get_real()));
+	timecounter_init(&fep->tc, &fep->cc, ktime_get_real_ns());
 
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 }
@@ -628,7 +628,36 @@ void fec_ptp_stop(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	if (fep->pps_enable)
+		fec_ptp_enable_pps(fep, 0);
+
 	cancel_delayed_work_sync(&fep->time_keep);
 	if (fep->ptp_clock)
 		ptp_clock_unregister(fep->ptp_clock);
 }
+
+void fec_ptp_save_state(struct fec_enet_private *fep)
+{
+	u32 atime_inc_corr;
+
+	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
+	fep->ptp_saved_state.ns_sys = ktime_get_ns();
+
+	fep->ptp_saved_state.at_corr = readl(fep->hwp + FEC_ATIME_CORR);
+	atime_inc_corr = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_CORR_MASK;
+	fep->ptp_saved_state.at_inc_corr = (u8)(atime_inc_corr >> FEC_T_INC_CORR_OFFSET);
+}
+
+int fec_ptp_restore_state(struct fec_enet_private *fep)
+{
+	u32 atime_inc = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_MASK;
+	u64 ns_sys;
+
+	writel(fep->ptp_saved_state.at_corr, fep->hwp + FEC_ATIME_CORR);
+	atime_inc |= ((u32)fep->ptp_saved_state.at_inc_corr) << FEC_T_INC_CORR_OFFSET;
+	writel(atime_inc, fep->hwp + FEC_ATIME_INC);
+
+	ns_sys = ktime_get_ns() - fep->ptp_saved_state.ns_sys;
+	timespec64_add_ns(&fep->ptp_saved_state.ts_phc, ns_sys);
+	return fec_ptp_settime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
+}
-- 
2.25.1

