Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E06C5A99B0
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiIAOEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiIAOEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:04:38 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3E2DF46
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 07:04:34 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 1F1557F4A1;
        Thu,  1 Sep 2022 16:04:30 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CE5F34064;
        Thu,  1 Sep 2022 16:04:30 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6B173405A;
        Thu,  1 Sep 2022 16:04:29 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Thu,  1 Sep 2022 16:04:29 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id B6E5C7F4A1;
        Thu,  1 Sep 2022 16:04:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662041069; bh=Y/o3VWjvh4ajyNIkUbFqB3ryRfo4OFmDY24BZGLwftU=;
        h=From:To:CC:Subject:Date:From;
        b=Il3Y5ejfNjcbowNnRb6SCQiQjGlEASZAnBPSpYj93uFB0PSq5wfjNc9N6zbzNyvkM
         To2oTtOJn4RD12vFg2pf4vMwvDkTDHgNthgR+VaPH4HzyrDdIOd/03qh3SwCqQHbZs
         cYZm7yEGbXDu8VSjjq1zJo0vRwdTfebzyRihK/HLyVOD9B8MsQEwS8g4YzxWafHUv1
         pNN9Olu7mElcgDN6HatheIxR4xltB5MwotjqbFW3GOdUEmSyfVnUHovsS1GSypSWJ/
         Y7Chil78MToHrvHJygfEulqAhDViiUCzysykJQnC4yZDVfKwmCZ/Vx+8pbNuWZHLhu
         jP4ZE7DXl0Tdg==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Thu, 1 Sep 2022 16:04:29 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 1 Sep 2022 16:04:29 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, <kernel@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Date:   Thu, 1 Sep 2022 16:04:03 +0200
Message-ID: <20220901140402.64804-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1662041069;VERSION=7934;MC=1308055912;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF456637C67
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mutexes cannot be taken in a non-preemptible context,
causing a panic in `fec_ptp_save_state()`. Replacing
`ptp_clk_mutex` by `tmreg_lock` fixes this.

Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec.h      |  1 -
 drivers/net/ethernet/freescale/fec_main.c | 17 +++++++-------
 drivers/net/ethernet/freescale/fec_ptp.c  | 28 ++++++++---------------
 3 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0cebe4b63adb..38f095260e1f 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -557,7 +557,6 @@ struct fec_enet_private {
 	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
-	struct mutex ptp_clk_mutex;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index b0d60f898249..ab1ee9508f76 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2028,6 +2028,7 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	unsigned long flags;
 	int ret;
 
 	if (enable) {
@@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			return ret;
 
 		if (fep->clk_ptp) {
-			mutex_lock(&fep->ptp_clk_mutex);
+			spin_lock_irqsave(&fep->tmreg_lock, flags);
 			ret = clk_prepare_enable(fep->clk_ptp);
 			if (ret) {
-				mutex_unlock(&fep->ptp_clk_mutex);
+				spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 				goto failed_clk_ptp;
 			} else {
 				fep->ptp_clk_on = true;
 			}
-			mutex_unlock(&fep->ptp_clk_mutex);
+			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		}
 
 		ret = clk_prepare_enable(fep->clk_ref);
@@ -2059,10 +2060,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
-			mutex_lock(&fep->ptp_clk_mutex);
+			spin_lock_irqsave(&fep->tmreg_lock, flags);
 			clk_disable_unprepare(fep->clk_ptp);
 			fep->ptp_clk_on = false;
-			mutex_unlock(&fep->ptp_clk_mutex);
+			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		}
 		clk_disable_unprepare(fep->clk_ref);
 		clk_disable_unprepare(fep->clk_2x_txclk);
@@ -2075,10 +2076,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
-		mutex_lock(&fep->ptp_clk_mutex);
+		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		clk_disable_unprepare(fep->clk_ptp);
 		fep->ptp_clk_on = false;
-		mutex_unlock(&fep->ptp_clk_mutex);
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
 failed_clk_ptp:
 	clk_disable_unprepare(fep->clk_enet_out);
@@ -3907,7 +3908,7 @@ fec_probe(struct platform_device *pdev)
 	}
 
 	fep->ptp_clk_on = false;
-	mutex_init(&fep->ptp_clk_mutex);
+	spin_lock_init(&fep->tmreg_lock);
 
 	/* clk_ref is optional, depends on board */
 	fep->clk_ref = devm_clk_get_optional(&pdev->dev, "enet_clk_ref");
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index c74d04f4b2fd..8dd5a2615a89 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -365,21 +365,19 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
  */
 static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct fec_enet_private *adapter =
+	struct fec_enet_private *fep =
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
 	u64 ns;
 	unsigned long flags;
 
-	mutex_lock(&adapter->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	/* Check the ptp clock */
-	if (!adapter->ptp_clk_on) {
-		mutex_unlock(&adapter->ptp_clk_mutex);
+	if (!fep->ptp_clk_on) {
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		return -EINVAL;
 	}
-	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	ns = timecounter_read(&adapter->tc);
-	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
-	mutex_unlock(&adapter->ptp_clk_mutex);
+	ns = timecounter_read(&fep->tc);
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -404,10 +402,10 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	unsigned long flags;
 	u32 counter;
 
-	mutex_lock(&fep->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	/* Check the ptp clock */
 	if (!fep->ptp_clk_on) {
-		mutex_unlock(&fep->ptp_clk_mutex);
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 		return -EINVAL;
 	}
 
@@ -417,11 +415,9 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	 */
 	counter = ns & fep->cc.mask;
 
-	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(counter, fep->hwp + FEC_ATIME);
 	timecounter_init(&fep->tc, &fep->cc, ns);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-	mutex_unlock(&fep->ptp_clk_mutex);
 	return 0;
 }
 
@@ -518,13 +514,11 @@ static void fec_time_keep(struct work_struct *work)
 	struct fec_enet_private *fep = container_of(dwork, struct fec_enet_private, time_keep);
 	unsigned long flags;
 
-	mutex_lock(&fep->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	if (fep->ptp_clk_on) {
-		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		timecounter_read(&fep->tc);
-		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
-	mutex_unlock(&fep->ptp_clk_mutex);
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
 	schedule_delayed_work(&fep->time_keep, HZ);
 }
@@ -599,8 +593,6 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	}
 	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
 
-	spin_lock_init(&fep->tmreg_lock);
-
 	fec_ptp_start_cyclecounter(ndev);
 
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
-- 
2.25.1

