Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0845B5508
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiILHH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiILHHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:07:55 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 00:07:50 PDT
Received: from mail.sch.bme.hu (mail.sch.bme.hu [152.66.208.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A640B2B618
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:07:50 -0700 (PDT)
Received: from Exchange2016-1.sch.bme.hu (152.66.208.194) by
 Exchange2016-1.sch.bme.hu (152.66.208.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 09:06:47 +0200
Received: from Cognitio.sch.bme.hu (152.66.211.220) by
 Exchange2016-1.sch.bme.hu (152.66.208.194) with Microsoft SMTP Server id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 09:06:47 +0200
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
Subject: [PATCH 2/2] net: fec: Use unlocked timecounter reads for saving state
Date:   Mon, 12 Sep 2022 07:31:05 +0000
Message-ID: <20220912073106.2544207-2-bence98@sch.bme.hu>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220912073106.2544207-1-bence98@sch.bme.hu>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>
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

`fec_ptp_save_state()` may be called from an atomic context,
which makes `fec_ptp_gettime()` unable to acquire a mutex.
Using the lower-level timecounter ops remedies the problem.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
Fixes: f79959220fa5
Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec.h     |  4 ++--
 drivers/net/ethernet/freescale/fec_ptp.c | 16 ++++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index b7b8c4ddac5b..3797988432e0 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -642,7 +642,7 @@ struct fec_enet_private {
 	unsigned int next_counter;
 
 	struct {
-		struct timespec64 ts_phc;
+		u64 ns_phc;
 		u64 ns_sys;
 		u32 at_corr;
 		u8 at_inc_corr;
@@ -661,7 +661,7 @@ int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
 void fec_ptp_save_state(struct fec_enet_private *fep);
-int fec_ptp_restore_state(struct fec_enet_private *fep);
+void fec_ptp_restore_state(struct fec_enet_private *fep);
 
 /****************************************************************************/
 #endif /* FEC_H */
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index ae2c786dc130..f1a8eb8c888b 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -643,26 +643,30 @@ void fec_ptp_stop(struct platform_device *pdev)
 
 void fec_ptp_save_state(struct fec_enet_private *fep)
 {
+	unsigned long flags;
 	u32 atime_inc_corr;
 
-	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	fep->ptp_saved_state.ns_phc = timecounter_read(&fep->tc);
 	fep->ptp_saved_state.ns_sys = ktime_get_ns();
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
 	fep->ptp_saved_state.at_corr = readl(fep->hwp + FEC_ATIME_CORR);
 	atime_inc_corr = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_CORR_MASK;
 	fep->ptp_saved_state.at_inc_corr = (u8)(atime_inc_corr >> FEC_T_INC_CORR_OFFSET);
 }
 
-int fec_ptp_restore_state(struct fec_enet_private *fep)
+void fec_ptp_restore_state(struct fec_enet_private *fep)
 {
 	u32 atime_inc = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_MASK;
-	u64 ns_sys;
+	u64 ns;
 
 	writel(fep->ptp_saved_state.at_corr, fep->hwp + FEC_ATIME_CORR);
 	atime_inc |= ((u32)fep->ptp_saved_state.at_inc_corr) << FEC_T_INC_CORR_OFFSET;
 	writel(atime_inc, fep->hwp + FEC_ATIME_INC);
 
-	ns_sys = ktime_get_ns() - fep->ptp_saved_state.ns_sys;
-	timespec64_add_ns(&fep->ptp_saved_state.ts_phc, ns_sys);
-	return fec_ptp_settime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
+	ns = ktime_get_ns() - fep->ptp_saved_state.ns_sys + fep->ptp_saved_state.ns_phc;
+
+	writel(ns & fep->cc.mask, fep->hwp + FEC_ATIME);
+	timecounter_init(&fep->tc, &fep->cc, ns);
 }
-- 
2.37.3

