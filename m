Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679E15B554E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiILHZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiILHYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:24:21 -0400
Received: from mail.sch.bme.hu (mail.sch.bme.hu [152.66.208.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DBA303C0
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:21:51 -0700 (PDT)
Received: from Exchange2016-1.sch.bme.hu (152.66.208.194) by
 Exchange2016-1.sch.bme.hu (152.66.208.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 09:06:44 +0200
Received: from Cognitio.sch.bme.hu (152.66.211.220) by
 Exchange2016-1.sch.bme.hu (152.66.208.194) with Microsoft SMTP Server id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 09:06:44 +0200
From:   =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>, <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH 1/2] Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
Date:   Mon, 12 Sep 2022 07:31:04 +0000
Message-ID: <20220912073106.2544207-1-bence98@sch.bme.hu>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Csókás Bence <csokas.bence@prolan.hu>

`clk_prepare_enable()` gets called in atomic context (holding a spinlock),
which may sleep, causing a BUG on certain platforms.

This reverts commit b353b241f1eb9b6265358ffbe2632fdcb563354f.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20220907143915.5w65kainpykfobte@pengutronix.de/
Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 17 ++++++++---------
 drivers/net/ethernet/freescale/fec_ptp.c  | 20 ++++++++++++++------
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 99cfe6ab41fc..b7b8c4ddac5b 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -563,6 +563,7 @@ struct fec_enet_private {
 	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
+	struct mutex ptp_clk_mutex;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ad01db156972..f5ba133468f5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2059,7 +2059,6 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	unsigned long flags;
 	int ret;
 
 	if (enable) {
@@ -2068,15 +2067,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			return ret;
 
 		if (fep->clk_ptp) {
-			spin_lock_irqsave(&fep->tmreg_lock, flags);
+			mutex_lock(&fep->ptp_clk_mutex);
 			ret = clk_prepare_enable(fep->clk_ptp);
 			if (ret) {
-				spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+				mutex_unlock(&fep->ptp_clk_mutex);
 				goto failed_clk_ptp;
 			} else {
 				fep->ptp_clk_on = true;
 			}
-			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+			mutex_unlock(&fep->ptp_clk_mutex);
 		}
 
 		ret = clk_prepare_enable(fep->clk_ref);
@@ -2091,10 +2090,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
-			spin_lock_irqsave(&fep->tmreg_lock, flags);
+			mutex_lock(&fep->ptp_clk_mutex);
 			clk_disable_unprepare(fep->clk_ptp);
 			fep->ptp_clk_on = false;
-			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+			mutex_unlock(&fep->ptp_clk_mutex);
 		}
 		clk_disable_unprepare(fep->clk_ref);
 		clk_disable_unprepare(fep->clk_2x_txclk);
@@ -2107,10 +2106,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
-		spin_lock_irqsave(&fep->tmreg_lock, flags);
+		mutex_lock(&fep->ptp_clk_mutex);
 		clk_disable_unprepare(fep->clk_ptp);
 		fep->ptp_clk_on = false;
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		mutex_unlock(&fep->ptp_clk_mutex);
 	}
 failed_clk_ptp:
 	clk_disable_unprepare(fep->clk_enet_out);
@@ -3949,7 +3948,7 @@ fec_probe(struct platform_device *pdev)
 	}
 
 	fep->ptp_clk_on = false;
-	spin_lock_init(&fep->tmreg_lock);
+	mutex_init(&fep->ptp_clk_mutex);
 
 	/* clk_ref is optional, depends on board */
 	fep->clk_ref = devm_clk_get_optional(&pdev->dev, "enet_clk_ref");
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 7be97ab84e50..ae2c786dc130 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -370,14 +370,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u64 ns;
 	unsigned long flags;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	mutex_lock(&fep->ptp_clk_mutex);
 	/* Check the ptp clock */
 	if (!fep->ptp_clk_on) {
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		mutex_unlock(&fep->ptp_clk_mutex);
 		return -EINVAL;
 	}
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	ns = timecounter_read(&fep->tc);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -402,10 +404,10 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	unsigned long flags;
 	u32 counter;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	mutex_lock(&fep->ptp_clk_mutex);
 	/* Check the ptp clock */
 	if (!fep->ptp_clk_on) {
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		mutex_unlock(&fep->ptp_clk_mutex);
 		return -EINVAL;
 	}
 
@@ -415,9 +417,11 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	 */
 	counter = ns & fep->cc.mask;
 
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(counter, fep->hwp + FEC_ATIME);
 	timecounter_init(&fep->tc, &fep->cc, ns);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 	return 0;
 }
 
@@ -514,11 +518,13 @@ static void fec_time_keep(struct work_struct *work)
 	struct fec_enet_private *fep = container_of(dwork, struct fec_enet_private, time_keep);
 	unsigned long flags;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	mutex_lock(&fep->ptp_clk_mutex);
 	if (fep->ptp_clk_on) {
+		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		timecounter_read(&fep->tc);
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
-	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+	mutex_unlock(&fep->ptp_clk_mutex);
 
 	schedule_delayed_work(&fep->time_keep, HZ);
 }
@@ -593,6 +599,8 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
+	spin_lock_init(&fep->tmreg_lock);
+
 	fec_ptp_start_cyclecounter(ndev);
 
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
-- 
2.37.3

