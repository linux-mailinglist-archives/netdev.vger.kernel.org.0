Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B02A5A69BF
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiH3RWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiH3RWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DF3AB06D;
        Tue, 30 Aug 2022 10:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A4F61799;
        Tue, 30 Aug 2022 17:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447B6C433C1;
        Tue, 30 Aug 2022 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880033;
        bh=5iiar+J6TCsmXD3hNSgz2r5MFxDu8jF9ygS0YzWuqv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4EtRBinJ+H41M1dVJHfM6j/ByvA9I1l3M9ZXt1laYcTSX52TefS/0UeThLKJoTzp
         kFeG/9NhmBVIvadN6yxuwfla1I/t9hAP+oysTjXKr4bWYH+6dmV+p+rMeV6EZwxlXp
         M9FBWsC3BPR/Jv5RgvZlqK2pem1lK6n7HHnFl+EVIgEQKJaAPH6eaARgPjAxZTJy+P
         g9W3k1YJvF1TOnZcXX6SqTNObUGlrVFiZ340sIUkvlWPjwmuYnu7yHwtlvXmh9Sj/u
         MyBVKpEryavqk2gQ3lYQ3N7amAX+tebDHpd2vygmeIuqoI4e5YeWwu5tfnOTHVi3jh
         rtsEAblYyWh1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, qiangqing.zhang@nxp.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 24/33] fec: Restart PPS after link state change
Date:   Tue, 30 Aug 2022 13:18:15 -0400
Message-Id: <20220830171825.580603-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Csókás Bence <csokas.bence@prolan.hu>

[ Upstream commit f79959220fa5fbda939592bf91c7a9ea90419040 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h      | 10 ++++++
 drivers/net/ethernet/freescale/fec_main.c | 42 ++++++++++++++++++++---
 drivers/net/ethernet/freescale/fec_ptp.c  | 29 ++++++++++++++++
 3 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index ed7301b691694..0cebe4b63adb7 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -634,6 +634,13 @@ struct fec_enet_private {
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
 
@@ -644,5 +651,8 @@ void fec_ptp_disable_hwts(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
+void fec_ptp_save_state(struct fec_enet_private *fep);
+int fec_ptp_restore_state(struct fec_enet_private *fep);
+
 /****************************************************************************/
 #endif /* FEC_H */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a90275143d873..436815fef197f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -285,8 +285,11 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
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
 
@@ -982,6 +985,9 @@ fec_restart(struct net_device *ndev)
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = 0x2; /* ETHEREN */
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+
+	fec_ptp_save_state(fep);
 
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
@@ -1135,7 +1141,7 @@ fec_restart(struct net_device *ndev)
 	}
 
 	if (fep->bufdesc_ex)
-		ecntl |= (1 << 4);
+		ecntl |= FEC_ECR_EN1588;
 
 	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
 	    fep->rgmii_txc_dly)
@@ -1156,6 +1162,14 @@ fec_restart(struct net_device *ndev)
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
@@ -1206,6 +1220,8 @@ fec_stop(struct net_device *ndev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
+	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
+	u32 ecntl = 0;
 
 	/* We cannot expect a graceful transmit stop without link !!! */
 	if (fep->link) {
@@ -1215,6 +1231,8 @@ fec_stop(struct net_device *ndev)
 			netdev_err(ndev, "Graceful transmit stop did not complete!\n");
 	}
 
+	fec_ptp_save_state(fep);
+
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
@@ -1234,12 +1252,28 @@ fec_stop(struct net_device *ndev)
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 
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
index 3dc3c0b626c21..c74d04f4b2fd2 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -633,7 +633,36 @@ void fec_ptp_stop(struct platform_device *pdev)
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
2.35.1

