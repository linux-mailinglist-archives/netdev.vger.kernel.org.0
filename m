Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC5463A63A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiK1Kf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiK1Kff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:35:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5C11ADA5;
        Mon, 28 Nov 2022 02:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669631682; x=1701167682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDmZQEsgcRyI7TsiycO+2Jxh12HbRA1PQvHyL4JSUWE=;
  b=vx0BZgsbfEbUPfW+Yofw2VrPX+dwn8zHqAInmr7lHQPLOvCZ8VWWZgj3
   RvVhvkhnAlJ8tnbgu4OC6AVHbJH6htDhI2GYr2pfxJoA29jmYzWuPTQ/B
   zBL6Hjzr19r9/24+1049hPs6DA5U2R901QMB3hM8SwDE1szBFuQtNOpB5
   YLtPriFNXw2qCY/spsQatxey5QNZIut4rMN0aBq3S3YJ9AK/CD13TUqrS
   mPduBAOhyVLoE3VuQbjFaNQMN8zaLb9dYGeB8t7oMyvbBiZqk24WthrcC
   9hXl131YjjnIRCZ9cZs+TuURHjZ2H5AlmtDF+F5bH0iTUaDFKoFfRuFwJ
   A==;
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="185454052"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 03:34:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 03:34:39 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 28 Nov 2022 03:34:33 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v1 12/12] net: dsa: microchip: ptp: add support for perout programmable pins
Date:   Mon, 28 Nov 2022 16:02:27 +0530
Message-ID: <20221128103227.23171-13-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221128103227.23171-1-arun.ramadoss@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two programmable pins available for Trigger output unit to
generate periodic pulses. This patch add verify_pin for the available 2
pins and configure it with respect to GPIO index for the TOU unit.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
Patch v1
- patch is new
---
 drivers/net/dsa/microchip/ksz_ptp.c | 41 +++++++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_ptp.h |  3 +++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 15b863c85cb1..445d220f1a1b 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -30,12 +30,14 @@ static int ksz_ptp_tou_gpio(struct ksz_device *dev)
 {
 	int ret;
 
-	ret = ksz_rmw32(dev, REG_SW_GLOBAL_LED_OVR__4, LED_OVR_1, LED_OVR_1);
+	ret = ksz_rmw32(dev, REG_SW_GLOBAL_LED_OVR__4, LED_OVR_1 | LED_OVR_2,
+			LED_OVR_1 | LED_OVR_2);
 	if (ret)
 		return ret;
 
 	return ksz_rmw32(dev, REG_SW_GLOBAL_LED_SRC__4,
-			 LED_SRC_PTP_GPIO_1, LED_SRC_PTP_GPIO_1);
+			 LED_SRC_PTP_GPIO_1 | LED_SRC_PTP_GPIO_2,
+			 LED_SRC_PTP_GPIO_1 | LED_SRC_PTP_GPIO_2);
 }
 
 static int ksz_ptp_tou_reset(struct ksz_device *dev, u8 unit)
@@ -181,6 +183,10 @@ static int ksz_ptp_enable_perout(struct ksz_device *dev,
 	    ptp_data->tou_mode != KSZ_PTP_TOU_IDLE)
 		return -EBUSY;
 
+	pin = ptp_find_pin(ptp_data->clock, PTP_PF_PEROUT, request->index);
+	if (pin < 0)
+		return -EINVAL;
+
 	data32 = FIELD_PREP(PTP_GPIO_INDEX, pin) |
 		 FIELD_PREP(PTP_TOU_INDEX, request->index);
 	ret = ksz_rmw32(dev, REG_PTP_UNIT_INDEX__4,
@@ -708,6 +714,23 @@ static int ksz_ptp_enable(struct ptp_clock_info *ptp,
 	return ret;
 }
 
+static int ksz_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+			      enum ptp_pin_function func, unsigned int chan)
+{
+	int ret = 0;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
 /*  Function is pointer to the do_aux_work in the ptp_clock capability */
 static long ksz_ptp_do_aux_work(struct ptp_clock_info *ptp)
 {
@@ -824,6 +847,8 @@ static const struct ptp_clock_info ksz_ptp_caps = {
 	.adjtime	= ksz_ptp_adjtime,
 	.do_aux_work	= ksz_ptp_do_aux_work,
 	.enable		= ksz_ptp_enable,
+	.verify		= ksz_ptp_verify_pin,
+	.n_pins		= KSZ_PTP_N_GPIO,
 	.n_per_out	= 3,
 };
 
@@ -832,6 +857,7 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	struct ksz_ptp_data *ptp_data;
 	int ret;
+	u8 i;
 
 	ptp_data = &dev->ptp_data;
 	mutex_init(&ptp_data->lock);
@@ -843,6 +869,17 @@ int ksz_ptp_clock_register(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	for (i = 0; i < KSZ_PTP_N_GPIO; i++) {
+		struct ptp_pin_desc *ptp_pin = &ptp_data->pin_config[i];
+
+		snprintf(ptp_pin->name,
+			 sizeof(ptp_pin->name), "ksz_ptp_pin_%02d", i);
+		ptp_pin->index = i;
+		ptp_pin->func = PTP_PF_NONE;
+	}
+
+	ptp_data->caps.pin_config = ptp_data->pin_config;
+
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, dev->dev);
 	if (IS_ERR_OR_NULL(ptp_data->clock))
 		return PTR_ERR(ptp_data->clock);
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 94ffd8bc0603..390364a177ea 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -10,6 +10,8 @@
 
 #include <linux/ptp_clock_kernel.h>
 
+#define KSZ_PTP_N_GPIO		2
+
 enum ksz_ptp_tou_mode {
 	KSZ_PTP_TOU_IDLE,
 	KSZ_PTP_TOU_PEROUT,
@@ -18,6 +20,7 @@ enum ksz_ptp_tou_mode {
 struct ksz_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
+	struct ptp_pin_desc pin_config[KSZ_PTP_N_GPIO];
 	/* Serializes all operations on the PTP hardware clock */
 	struct mutex lock;
 	/* lock for accessing the clock_time */
-- 
2.36.1

