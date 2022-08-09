Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1137158D8D7
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 14:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbiHIMlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 08:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbiHIMlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 08:41:37 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C971B18E00
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 05:41:33 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 3525C7F46C;
        Tue,  9 Aug 2022 14:41:30 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F9A634064;
        Tue,  9 Aug 2022 14:41:29 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46FD93405A;
        Tue,  9 Aug 2022 14:41:29 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Tue,  9 Aug 2022 14:41:29 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id CE2FA7F46C;
        Tue,  9 Aug 2022 14:41:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1660048889; bh=BNnVjwIjLqAVMaMj7s9CekZJLoj03OFBcFyY+gVYHD0=;
        h=From:To:CC:Subject:Date:From;
        b=KmS3rI3fj+BlAGta3uZdlLVkqUyA0IYL8V6OnOHH5x+ssNiJUhGeY2xR2bzu5QVq6
         98ZK2GXD195VOEVSJDCKGZvo99IuObJaIKqd4hAqvwe+dQvkpk9I2/HHkO16BTBd9Q
         sY3qoTSi5tpenLwIWQCqquUd159CTh8g+q8DcqPBdDjQ0A8QmHFLvDapv6EKBDEI42
         Ow2bFXtH6PLF1FTDakKNf3KoE+KYM+CRXiC+z53vZ/ftteQXRrq/bapvAl9e1G7ZhI
         LndnfuwTYNLxlXq/iNadGpGGS4mXeK8ergyYRR6YoD+xM6sr0jpiOQwi0NLK0qoV8C
         cECte5Pzzh60A==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.9; Tue, 9 Aug 2022 14:41:29 +0200
Received: from P-01011.intranet.prolan.hu (10.254.7.28) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Tue, 9 Aug 2022 14:41:29 +0200
From:   =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
To:     <netdev@vger.kernel.org>
CC:     =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH] fec: Restart PPS after link state change
Date:   Tue, 9 Aug 2022 14:41:19 +0200
Message-ID: <20220809124119.29922-1-csokas.bence@prolan.hu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ESET-AS: R=OK;S=0;OP=CALC;TIME=1660048889;VERSION=7932;MC=51325858;TRN=0;CRV=0;IPC=;SP=0;SIPS=0;PI=3;F=0
X-ESET-Antispam: OK
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF45661766A
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
 drivers/net/ethernet/freescale/fec_main.c | 27 ++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ca5d49361fdf..c264b1dd5286 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -954,6 +954,7 @@ fec_restart(struct net_device *ndev)
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = 0x2; /* ETHEREN */
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1119,6 +1120,13 @@ fec_restart(struct net_device *ndev)
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
@@ -1154,6 +1162,8 @@ fec_stop(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+	u32 ecntl = 0;
 
 	/* We cannot expect a graceful transmit stop without link !!! */
 	if (fep->link) {
@@ -1184,12 +1194,27 @@ fec_stop(struct net_device *ndev)
 	}
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
+	if (fep->bufdesc_ex)
+		ecntl |= (1 << 4);
+
 	/* We have to keep ENET enabled to have MII interrupt stay working */
 	if (fep->quirks & FEC_QUIRK_ENET_MAC &&
 		!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		writel(2, fep->hwp + FEC_ECNTRL);
+		ecntl |= 0x2;
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
 
 
-- 
2.25.1

