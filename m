Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B1C39339
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbfFGRal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:30:41 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:42245 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbfFGRal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:30:41 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id E50563C00DD;
        Fri,  7 Jun 2019 19:30:36 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gB7ra8XJGT9k; Fri,  7 Jun 2019 19:30:28 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 177693C00D1;
        Fri,  7 Jun 2019 19:30:28 +0200 (CEST)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 7 Jun 2019
 19:30:27 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Spyridon Papageorgiou <spapageorgiou@de.adit-jv.com>,
        Joshua Frkuska <joshua_frkuska@mentor.com>,
        "George G . Davis" <george_davis@mentor.com>,
        Andrey Gusakov <andrey.gusakov@cogentembedded.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: [PATCH] wlcore/wl18xx: Add invert-irq OF property for physically inverted IRQ
Date:   Fri, 7 Jun 2019 19:29:58 +0200
Message-ID: <20190607172958.20745-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.93.184]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wl1837mod datasheet [1] says about the WL_IRQ pin:

 ---8<---
SDIO available, interrupt out. Active high. [..]
Set to rising edge (active high) on powerup.
 ---8<---

That's the reason of seeing the interrupt configured as:
 - IRQ_TYPE_EDGE_RISING on HiKey 960/970
 - IRQ_TYPE_LEVEL_HIGH on a number of i.MX6 platforms

We assert that all those platforms have the WL_IRQ pin connected
to the SoC _directly_ (confirmed on HiKey 970 [2]).

That's not the case for R-Car Kingfisher extension target, which carries
a WL1837MODGIMOCT IC. There is an SN74LV1T04DBVR inverter present
between the WLAN_IRQ pin of the WL18* chip and the SoC, effectively
reversing the requirement quoted from [1]. IOW, in Kingfisher DTS
configuration we would need to use IRQ_TYPE_EDGE_FALLING or
IRQ_TYPE_LEVEL_LOW.

Unfortunately, v4.2-rc1 commit bd763482c82ea2 ("wl18xx: wlan_irq:
support platform dependent interrupt types") made a special case out
of these interrupt types. After this commit, it is impossible to provide
an IRQ configuration via DTS which would describe an inverter present
between the WL18* chip and the SoC, generating the need for workarounds
like [3].

Create a boolean OF property, called "invert-irq" to specify that
the WLAN_IRQ pin of WL18* is connected to the SoC via an inverter.

This solution has been successfully tested on R-Car H3ULCB-KF-M06 using
the DTS configuration [4] combined with the "invert-irq" property.

[1] http://www.ti.com/lit/ds/symlink/wl1837mod.pdf
[2] https://www.96boards.org/documentation/consumer/hikey/hikey970/hardware-docs/
[3] https://github.com/CogentEmbedded/meta-rcar/blob/289fbd4f8354/meta-rcar-gen3-adas/recipes-kernel/linux/linux-renesas/0024-wl18xx-do-not-invert-IRQ-on-WLxxxx-side.patch
[4] https://patchwork.kernel.org/patch/10895879/
    ("arm64: dts: ulcb-kf: Add support for TI WL1837")

Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
 drivers/net/wireless/ti/wl18xx/main.c     | 5 +++++
 drivers/net/wireless/ti/wlcore/sdio.c     | 2 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 496b9b63cea1..cea91d1aee98 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -877,6 +877,8 @@ static int wl18xx_pre_boot(struct wl1271 *wl)
 
 static int wl18xx_pre_upload(struct wl1271 *wl)
 {
+	struct platform_device *pdev = wl->pdev;
+	struct wlcore_platdev_data *pdata = dev_get_platdata(&pdev->dev);
 	u32 tmp;
 	int ret;
 	u16 irq_invert;
@@ -932,6 +934,9 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
+	if (pdata->invert_irq)
+		goto out;
+
 	ret = irq_get_trigger_type(wl->irq);
 	if ((ret == IRQ_TYPE_LEVEL_LOW) || (ret == IRQ_TYPE_EDGE_FALLING)) {
 		wl1271_info("using inverted interrupt logic: %d", ret);
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 4d4b07701149..581f56b0b6a2 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -266,6 +266,8 @@ static int wlcore_probe_of(struct device *dev, int *irq, int *wakeirq,
 	of_property_read_u32(np, "tcxo-clock-frequency",
 			     &pdev_data->tcxo_clock_freq);
 
+	pdev_data->invert_irq = of_property_read_bool(np, "invert-irq");
+
 	return 0;
 }
 #else
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 32ec121ccac2..01679f9d7170 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -213,6 +213,10 @@ struct wlcore_platdev_data {
 	u32 ref_clock_freq;	/* in Hertz */
 	u32 tcxo_clock_freq;	/* in Hertz, tcxo is always XTAL */
 	bool pwr_in_suspend;
+	bool invert_irq;	/* specify if there is a physical IRQ inverter
+				 * between WL chip and SoC, like SN74LV1T04DBVR
+				 * in case of R-Car Kingfisher board
+				 */
 };
 
 #define MAX_NUM_KEYS 14
-- 
2.21.0

