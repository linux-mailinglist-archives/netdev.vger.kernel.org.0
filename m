Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C805E5A4B0C
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiH2MHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiH2MG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:06:58 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383651EC7F
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 04:52:06 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 40FE57F460;
        Mon, 29 Aug 2022 13:43:45 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B25434064;
        Mon, 29 Aug 2022 13:43:45 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 127763405A;
        Mon, 29 Aug 2022 13:43:45 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Mon, 29 Aug 2022 13:43:45 +0200 (CEST)
Received: from sinope.intranet.prolan.hu (sinope.intranet.prolan.hu [10.254.0.237])
        by fw2.prolan.hu (Postfix) with ESMTPS id D4D9A7F460;
        Mon, 29 Aug 2022 13:43:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661773424; bh=HgJc6cKOZHR3J60wrqb30Ilojn5JWsKk5IumApi12OI=;
        h=From:To:CC:Subject:Date:From;
        b=oW3I8RGAvVqw73N7jiAft0JMNQmvbXnwvDoFPrmYN4SCRTqHR6kczxXdKRndaMNuu
         iuWssYH7gaiXTi73LI8BFRzkNzWRGXTUMUA6uClhf5pdACn4H9WIuIN41l/Cxqghya
         FW8aFw4DP+iSY4kOC3OBVEy7MtjnmoKS6uV60oKQ9FaTBkjBHcFeNsOcEKijbkSVaV
         G3YLhfwPb0r01LerM9MszqHyNXxDpwHYPp2qzuoE+URYCN6hypI4XxLKt6bhpuOoCR
         Y6ljCgxm1bHj6irR9kd3MEEJFtCfaDfM8i9wGE4qgGnxHpF+kZEyfuckT7cXRPLUrf
         5xiLbqfBaeo2g==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 sinope.intranet.prolan.hu (10.254.0.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Mon, 29 Aug 2022 13:43:44 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 29 Aug 2022 13:43:44 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        <kernel@pengutronix.de>, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] net: fec: Use unlocked timecounter reads for saving state
Date:   Mon, 29 Aug 2022 13:40:41 +0200
Message-ID: <20220829114039.56195-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1661773424;VERSION=7934;MC=3694288986;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29A91EF456637064
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`fec_ptp_save_state()` may be called from an atomic context,
which makes `fec_ptp_gettime()` unable to acquire a mutex.
Using the lower-level timecounter ops remedies the problem.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Fixes: f79959220fa5

Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
---
 drivers/net/ethernet/freescale/fec.h     |  4 ++--
 drivers/net/ethernet/freescale/fec_ptp.c | 13 +++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index b656cda75c92..7bc7ab4b5d3a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -597,7 +597,7 @@ struct fec_enet_private {
 	unsigned int next_counter;
 
 	struct {
-		struct timespec64 ts_phc;
+		u64 ns_phc;
 		u64 ns_sys;
 		u32 at_corr;
 		u8 at_inc_corr;
@@ -613,7 +613,7 @@ int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
 void fec_ptp_save_state(struct fec_enet_private *fep);
-int fec_ptp_restore_state(struct fec_enet_private *fep);
+void fec_ptp_restore_state(struct fec_enet_private *fep);
 
 /****************************************************************************/
 #endif /* FEC_H */
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 78fb8818d168..fdd22c6ca909 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -636,7 +636,7 @@ void fec_ptp_save_state(struct fec_enet_private *fep)
 {
 	u32 atime_inc_corr;
 
-	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
+	fep->ptp_saved_state.ns_phc = timecounter_read(&fep->tc);
 	fep->ptp_saved_state.ns_sys = ktime_get_ns();
 
 	fep->ptp_saved_state.at_corr = readl(fep->hwp + FEC_ATIME_CORR);
@@ -644,16 +644,17 @@ void fec_ptp_save_state(struct fec_enet_private *fep)
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
2.25.1

