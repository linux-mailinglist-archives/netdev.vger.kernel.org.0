Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2AD5A7E1C
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiHaM5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiHaM5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:57:53 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04FD95AC8
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:57:49 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id E8BA47F53D;
        Wed, 31 Aug 2022 14:57:45 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D253F34064;
        Wed, 31 Aug 2022 14:57:45 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8BDF3405A;
        Wed, 31 Aug 2022 14:57:45 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 14:57:45 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id 88E237F53D;
        Wed, 31 Aug 2022 14:57:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661950665; bh=EiFq/FOVl3ZfZbtiHLgKAuOk+q58lw8zkZOsal+qGhY=;
        h=From:To:CC:Subject:Date:From;
        b=RCOLmOXGWroR18peI0viYl6+XhF526EZcjL+lvj7vBCbZY64fdDMWwlmmitoZaXly
         tu6+BuNDsGdWthk0IOwT8OVejKP76pGatf0BItJ00CeVBLDSL1MYCHG5Br/IlrqW1Y
         D9ZsOkKM9qxRiQIqE9JBGEeeqoUfJPRMb5fSBroyQzzYbwGow3AzvrT/jRKhn/pGel
         ecK6ZIXah7+0RrfAMMTEW9RsPTjPbI7SeOs0hp9H1BKPtrN9IMiB9o/Wh3DTB63Kqm
         OlMTCWoG8IzVFtBjifKoIKkG4P2EJuL+lfvhhozYuI3l4yBxaHzlxp8a88rrZS71/S
         hL9qYpFpmtGtg==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Wed, 31 Aug 2022 14:57:44 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 31 Aug 2022 14:57:45 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        <kernel@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Subject: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Date:   Wed, 31 Aug 2022 14:56:31 +0200
Message-ID: <20220831125631.173171-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1661950664;VERSION=7934;MC=2243948494;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF456637D61
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
`ptp_clk_mutex` by `ptp_clk_lock` fixes this.

Fixes: 91c0d987a9788dcc5fe26baafd73bf9242b68900
Fixes: 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5
Fixes: f79959220fa5fbda939592bf91c7a9ea90419040

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec.h      |  2 +-
 drivers/net/ethernet/freescale/fec_main.c | 17 ++++++------
 drivers/net/ethernet/freescale/fec_ptp.c  | 32 +++++++++++------------
 3 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0cebe4b63adb..9aac74d14f26 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -557,7 +557,7 @@ struct fec_enet_private {
 	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
-	struct mutex ptp_clk_mutex;
+	spinlock_t ptp_clk_lock;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index b0d60f898249..98d8f8d6034e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2029,6 +2029,7 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	int ret;
+	unsigned long flags;
 
 	if (enable) {
 		ret = clk_prepare_enable(fep->clk_enet_out);
@@ -2036,15 +2037,15 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			return ret;
 
 		if (fep->clk_ptp) {
-			mutex_lock(&fep->ptp_clk_mutex);
+			spin_lock_irqsave(&fep->ptp_clk_lock, flags);
 			ret = clk_prepare_enable(fep->clk_ptp);
 			if (ret) {
-				mutex_unlock(&fep->ptp_clk_mutex);
+				spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
 				goto failed_clk_ptp;
 			} else {
 				fep->ptp_clk_on = true;
 			}
-			mutex_unlock(&fep->ptp_clk_mutex);
+			spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
 		}
 
 		ret = clk_prepare_enable(fep->clk_ref);
@@ -2059,10 +2060,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
-			mutex_lock(&fep->ptp_clk_mutex);
+			spin_lock_irqsave(&fep->ptp_clk_lock, flags);
 			clk_disable_unprepare(fep->clk_ptp);
 			fep->ptp_clk_on = false;
-			mutex_unlock(&fep->ptp_clk_mutex);
+			spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
 		}
 		clk_disable_unprepare(fep->clk_ref);
 		clk_disable_unprepare(fep->clk_2x_txclk);
@@ -2075,10 +2076,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
-		mutex_lock(&fep->ptp_clk_mutex);
+		spin_lock_irqsave(&fep->ptp_clk_lock, flags);
 		clk_disable_unprepare(fep->clk_ptp);
 		fep->ptp_clk_on = false;
-		mutex_unlock(&fep->ptp_clk_mutex);
+		spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
 	}
 failed_clk_ptp:
 	clk_disable_unprepare(fep->clk_enet_out);
@@ -3907,7 +3908,7 @@ fec_probe(struct platform_device *pdev)
 	}
 
 	fep->ptp_clk_on = false;
-	mutex_init(&fep->ptp_clk_mutex);
+	spin_lock_init(&fep->ptp_clk_lock);
 
 	/* clk_ref is optional, depends on board */
 	fep->clk_ref = devm_clk_get_optional(&pdev->dev, "enet_clk_ref");
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index c74d04f4b2fd..dc8564a1f2d2 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -365,21 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
  */
 static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct fec_enet_private *adapter =
+	struct fec_enet_private *fep =
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
 	u64 ns;
-	unsigned long flags;
+	unsigned long flags, flags2;
 
-	mutex_lock(&adapter->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->ptp_clk_lock, flags);
 	/* Check the ptp clock */
-	if (!adapter->ptp_clk_on) {
-		mutex_unlock(&adapter->ptp_clk_mutex);
+	if (!fep->ptp_clk_on) {
+		spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
 		return -EINVAL;
 	}
-	spin_lock_irqsave(&adapter->tmreg_lock, flags);
-	ns = timecounter_read(&adapter->tc);
-	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
-	mutex_unlock(&adapter->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->tmreg_lock, flags2);
+	ns = timecounter_read(&fep->tc);
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags2);
+	spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -401,13 +401,13 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
 
 	u64 ns;
-	unsigned long flags;
+	unsigned long flags, flags2;
 	u32 counter;
 
-	mutex_lock(&fep->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->ptp_clk_lock, flags2);
 	/* Check the ptp clock */
 	if (!fep->ptp_clk_on) {
-		mutex_unlock(&fep->ptp_clk_mutex);
+		spin_unlock_irqrestore(&fep->ptp_clk_lock, flags2);
 		return -EINVAL;
 	}
 
@@ -421,7 +421,7 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	writel(counter, fep->hwp + FEC_ATIME);
 	timecounter_init(&fep->tc, &fep->cc, ns);
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-	mutex_unlock(&fep->ptp_clk_mutex);
+	spin_unlock_irqrestore(&fep->ptp_clk_lock, flags2);
 	return 0;
 }
 
@@ -516,15 +516,15 @@ static void fec_time_keep(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct fec_enet_private *fep = container_of(dwork, struct fec_enet_private, time_keep);
-	unsigned long flags;
+	unsigned long flags, flags2;
 
-	mutex_lock(&fep->ptp_clk_mutex);
+	spin_lock_irqsave(&fep->ptp_clk_lock, flags2);
 	if (fep->ptp_clk_on) {
 		spin_lock_irqsave(&fep->tmreg_lock, flags);
 		timecounter_read(&fep->tc);
 		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 	}
-	mutex_unlock(&fep->ptp_clk_mutex);
+	spin_unlock_irqrestore(&fep->ptp_clk_lock, flags2);
 
 	schedule_delayed_work(&fep->time_keep, HZ);
 }
-- 
2.25.1

