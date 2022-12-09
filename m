Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85EC647E8D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiLIH2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiLIH1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:27:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9097F40454;
        Thu,  8 Dec 2022 23:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670570824; x=1702106824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kVJXGUEL1IK7sv2durqWviWr/jhrNhCEOoQFcMo4sd8=;
  b=zMGGKyDHLuozSUdwYc7i9ahWTw/xU5Efu7hKXshU7aX0DVwflU0pz1Wz
   WzLt4MPz16THpZ0XXbNBwaMOD0353nYV26UYcz7ALn/NaYvLCrbVQqugG
   2js8GUeF8mYD824chs5Ev82SuxHECC7FTvjNXeWl3RxozsB1IIANK+GK3
   spa6XGNAxLEQTRMy/qq4Ynu/7Gjy/adlGGq9EKjCmXDMB+Cuvat3KeS+w
   byUDItCp3OzC3tixR+mWW6PtL7rRb9BlJp4xRChLBkGBI7Cy4zMML+MIO
   +u78Z22a/CT/kaHP3CHFqN9RUk1PKHA5PWtfAmSjlVRckLRHTdyWQaEcL
   A==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="127292958"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 00:27:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 00:27:03 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 00:26:57 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v3 13/13] net: dsa: microchip: ptp: lan937x: Enable periodic output in LED pins
Date:   Fri, 9 Dec 2022 12:54:37 +0530
Message-ID: <20221209072437.18373-14-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221209072437.18373-1-arun.ramadoss@microchip.com>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
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

There is difference in implementation of per_out pins between KSZ9563
and LAN937x. In KSZ9563, Timestamping control register (0x052C) bit 6,
if 1 - timestamp input and 0 - trigger output. But it is opposite for
LAN937x 1 - trigger output and 0 - timestamp input.
As per per_out gpio pins, KSZ9563 has four Led pins and two dedicated
gpio pins. But in LAN937x dedicated gpio pins are removed instead there
are up to 10 LED pins out of which LED_0 and LED_1 can be mapped to PTP
tou 0, 1 or 2. This patch sets the bit 6 in 0x052C register and
configure the LED override and source register for LAN937x series of
switches alone.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_ptp.c     | 26 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  8 ++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index ccb635585721..99aae649c4a7 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -33,6 +33,28 @@
 
 static int _ksz_ptp_gettime(struct ksz_device *dev, struct timespec64 *ts);
 
+static int ksz_ptp_tou_gpio(struct ksz_device *dev)
+{
+	int ret;
+
+	if (!is_lan937x(dev))
+		return 0;
+
+	ret = ksz_rmw32(dev, REG_PTP_CTRL_STAT__4, GPIO_OUT,
+			GPIO_OUT);
+	if (ret)
+		return ret;
+
+	ret = ksz_rmw32(dev, REG_SW_GLOBAL_LED_OVR__4, LED_OVR_1 | LED_OVR_2,
+			LED_OVR_1 | LED_OVR_2);
+	if (ret)
+		return ret;
+
+	return ksz_rmw32(dev, REG_SW_GLOBAL_LED_SRC__4,
+			 LED_SRC_PTP_GPIO_1 | LED_SRC_PTP_GPIO_2,
+			 LED_SRC_PTP_GPIO_1 | LED_SRC_PTP_GPIO_2);
+}
+
 static int ksz_ptp_tou_reset(struct ksz_device *dev, u8 unit)
 {
 	u32 data;
@@ -229,6 +251,10 @@ static int ksz_ptp_enable_perout(struct ksz_device *dev,
 	if (ret)
 		return ret;
 
+	ret = ksz_ptp_tou_gpio(dev);
+	if (ret)
+		return ret;
+
 	ret = ksz_ptp_tou_start(dev, request->index);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
index dbccfedf89e4..6fea39629460 100644
--- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -6,6 +6,14 @@
 #ifndef __KSZ_PTP_REGS_H
 #define __KSZ_PTP_REGS_H
 
+#define REG_SW_GLOBAL_LED_OVR__4	0x0120
+#define LED_OVR_2			BIT(1)
+#define LED_OVR_1			BIT(0)
+
+#define REG_SW_GLOBAL_LED_SRC__4	0x0128
+#define LED_SRC_PTP_GPIO_1		BIT(3)
+#define LED_SRC_PTP_GPIO_2		BIT(2)
+
 /* 5 - PTP Clock */
 #define REG_PTP_CLK_CTRL		0x0500
 
-- 
2.36.1

