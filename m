Return-Path: <netdev+bounces-10324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9498C72DE1C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E4A92811E0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F6C294D9;
	Tue, 13 Jun 2023 09:45:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E46C2915
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:45:43 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2694BC7;
	Tue, 13 Jun 2023 02:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686649542; x=1718185542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qJQeseeqfzRkx2UamfjiFAmR9bAcSJQnuMvDwJdRk8U=;
  b=ZI0q2/iRSnAxaNQPQUW4dvOGxyRq35y+xskIDcHFwt9GYTCr+/0G1Bhc
   RwULrhC5lqDl2+pXMG3LRp1vYXInvly5XrNB96VgXqe4mBD3GQNUxpfjw
   QMmNtN9qlUPWJlpJwJ82nBjE7zy/B0s6WyRwp98ibMWlyKd1HtmVck2qv
   RYWYljj8Dj9xnonovJhs+v7cI3wwabfV6wuBPGnmA7/bbW6/bWelPX5tE
   OA0+mE6nfVHk/dOkrLUDMaQYi93vFrb7UddR1FuYjjOR8xlQfisU1PLXU
   3lIQYaSqVgKoUU9Kbk2uND9a8T8SsnDo1jrWKIZOogk3YxUIvmJriU3Z5
   w==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="218210686"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2023 02:45:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 13 Jun 2023 02:45:41 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 13 Jun 2023 02:45:39 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/2] net: micrel: Schedule work to read seconds for lan8841
Date: Tue, 13 Jun 2023 11:45:26 +0200
Message-ID: <20230613094526.69532-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230613094526.69532-1-horatiu.vultur@microchip.com>
References: <20230613094526.69532-1-horatiu.vultur@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Instead of reading the seconds part of the received frame for each of
the frames, schedule a workqueue to read the seconds part every 500ms
and then for each of the received frames use this information instead of
reading again the seconds part. Because if for example running with 512
frames per second, there is no point to read 512 times the second part.
Of course care needs to be taken in case of the less two significant
bits are 0 or 3, to make sure there are no seconds wraparound.
This will improve the CPU usage by ~20% and also it is possible to receive
1024 Sync frames per second.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 49 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 28365006b2067..9832eea404377 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -33,6 +33,7 @@
 #include <linux/ptp_classify.h>
 #include <linux/net_tstamp.h>
 #include <linux/gpio/consumer.h>
+#include <linux/workqueue.h>
 
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
@@ -254,6 +255,9 @@
 #define PS_TO_REG				200
 #define FIFO_SIZE				8
 
+/* Delay used to get the second part from the LTC */
+#define LAN8841_GET_SEC_LTC_DELAY		(500 * NSEC_PER_MSEC)
+
 struct kszphy_hw_stat {
 	const char *string;
 	u8 reg;
@@ -321,6 +325,9 @@ struct kszphy_ptp_priv {
 	/* Lock for ptp_clock */
 	struct mutex ptp_lock;
 	struct ptp_pin_desc *pin_config;
+
+	s64 seconds;
+	struct delayed_work seconds_work;
 };
 
 struct kszphy_priv {
@@ -3840,6 +3847,12 @@ static void lan8841_ptp_enable_processing(struct kszphy_ptp_priv *ptp_priv,
 			       LAN8841_PTP_INSERT_TS_32BIT,
 			       LAN8841_PTP_INSERT_TS_EN |
 			       LAN8841_PTP_INSERT_TS_32BIT);
+
+		/* Schedule the work to read the seconds, which will be used in
+		 * the received timestamp
+		 */
+		schedule_delayed_work(&ptp_priv->seconds_work,
+				      nsecs_to_jiffies(LAN8841_GET_SEC_LTC_DELAY));
 	} else {
 		/* Disable interrupts on the TX side */
 		phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
@@ -3853,6 +3866,11 @@ static void lan8841_ptp_enable_processing(struct kszphy_ptp_priv *ptp_priv,
 			       LAN8841_PTP_INSERT_TS_32BIT, 0);
 
 		ptp_cancel_worker_sync(ptp_priv->ptp_clock);
+
+		/* Stop the work, as there is no reason to continue to read the
+		 * seconds if there is no timestamping enabled
+		 */
+		cancel_delayed_work_sync(&ptp_priv->seconds_work);
 	}
 }
 
@@ -4062,6 +4080,8 @@ static int lan8841_ptp_settime64(struct ptp_clock_info *ptp,
 	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_NS_LO, lower_16_bits(ts->tv_nsec));
 	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_NS_HI, upper_16_bits(ts->tv_nsec) & 0x3fff);
 
+	ptp_priv->seconds = ts->tv_sec;
+
 	/* Set the command to load the LTC */
 	phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
 		      LAN8841_PTP_CMD_CTL_PTP_LTC_LOAD);
@@ -4116,7 +4136,6 @@ static void lan8841_ptp_getseconds(struct ptp_clock_info *ptp,
 	struct phy_device *phydev = ptp_priv->phydev;
 	time64_t s;
 
-	mutex_lock(&ptp_priv->ptp_lock);
 	/* Issue the command to read the LTC */
 	phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
 		      LAN8841_PTP_CMD_CTL_PTP_LTC_READ);
@@ -4127,7 +4146,6 @@ static void lan8841_ptp_getseconds(struct ptp_clock_info *ptp,
 	s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_MID);
 	s <<= 16;
 	s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_LO);
-	mutex_unlock(&ptp_priv->ptp_lock);
 
 	set_normalized_timespec64(ts, s, 0);
 }
@@ -4644,15 +4662,20 @@ static long lan8841_ptp_do_aux_work(struct ptp_clock_info *ptp)
 	u32 ts_header;
 
 	while ((skb = skb_dequeue(&ptp_priv->rx_queue)) != NULL) {
-		lan8841_ptp_getseconds(ptp, &ts);
+		mutex_lock(&ptp_priv->ptp_lock);
+		ts.tv_sec = ptp_priv->seconds;
+		mutex_unlock(&ptp_priv->ptp_lock);
+
 		ts_header = __be32_to_cpu(LAN8841_SKB_CB(skb)->header->reserved2);
 
 		shhwtstamps = skb_hwtstamps(skb);
 		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
 
 		/* Check for any wrap arounds for the second part */
-		if ((ts.tv_sec & GENMASK(1, 0)) < ts_header >> 30)
+		if ((ts.tv_sec & GENMASK(1, 0)) == 0 && (ts_header >> 30) == 3)
 			ts.tv_sec -= GENMASK(1, 0) + 1;
+		else if ((ts.tv_sec & GENMASK(1, 0)) == 3 && (ts_header >> 30) == 0)
+			ts.tv_sec += 1;
 
 		shhwtstamps->hwtstamp =
 			ktime_set((ts.tv_sec & ~(GENMASK(1, 0))) | ts_header >> 30,
@@ -4665,6 +4688,21 @@ static long lan8841_ptp_do_aux_work(struct ptp_clock_info *ptp)
 	return -1;
 }
 
+static void lan8841_ptp_seconds_work(struct work_struct *seconds_work)
+{
+	struct kszphy_ptp_priv *ptp_priv =
+		container_of(seconds_work, struct kszphy_ptp_priv, seconds_work.work);
+	struct timespec64 ts;
+
+	mutex_lock(&ptp_priv->ptp_lock);
+	lan8841_ptp_getseconds(&ptp_priv->ptp_clock_info, &ts);
+	ptp_priv->seconds = ts.tv_sec;
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	schedule_delayed_work(&ptp_priv->seconds_work,
+			      nsecs_to_jiffies(LAN8841_GET_SEC_LTC_DELAY));
+}
+
 static struct ptp_clock_info lan8841_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "lan8841 ptp",
@@ -4749,6 +4787,8 @@ static int lan8841_probe(struct phy_device *phydev)
 
 	phydev->mii_ts = &ptp_priv->mii_ts;
 
+	INIT_DELAYED_WORK(&ptp_priv->seconds_work, lan8841_ptp_seconds_work);
+
 	return 0;
 }
 
@@ -4758,6 +4798,7 @@ static int lan8841_suspend(struct phy_device *phydev)
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
 
 	ptp_cancel_worker_sync(ptp_priv->ptp_clock);
+	cancel_delayed_work_sync(&ptp_priv->seconds_work);
 
 	return genphy_suspend(phydev);
 }
-- 
2.38.0


