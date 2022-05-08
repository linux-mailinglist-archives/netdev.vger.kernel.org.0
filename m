Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCD951F1F8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 00:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiEHWxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 18:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiEHWxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 18:53:30 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36175DEB7
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 15:49:38 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4KxKHf5JzYz9sQG;
        Mon,  9 May 2022 00:49:34 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1652050172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vk2eisPI/VyxABU4xjO9Q/GhOq1Ba18tj/qKipBo7/M=;
        b=fVgwp7dOGycFxxXfg/ctj1G1kIe7sELJLSWb0UcrdPXsxyfD1g+PcPV819oZBKyX8dLvFH
        WaAq3WjFDc6Y4uLPAEERRb60LRxZOKcxYKpjhXeXrM4ooCXTzOivHJiZUk9VokM8jrDvXY
        C1mLku370BGAQUPHhDR02F96dJk/9raAZTyb5D29yVsrextusm3E9B8vrrrMCWpXKveLlU
        FNebelK5YtYoF2sSGBV1+Xmg2Ut5poL2HjTBb20oAiDjRw9KfJp36OqWAMcpiYizZWq/Ib
        3EPFKiWyNfNioZlC6sOXDai7UGalN2JAvj0hwZXrzkxQuXe1whb4sepEwk2CiQ==
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] net: dsa: realtek: rtl8365mb: Get chip option
Date:   Mon,  9 May 2022 00:48:46 +0200
Message-Id: <20220508224848.2384723-3-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-1-hauke@hauke-m.de>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the option register in addition to the other registers to identify
the chip. The SGMII initialization is different for the different chip
options.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 43 +++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2cb722a9e096..be64cfdeccc7 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -127,6 +127,9 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
 
 #define RTL8365MB_CHIP_VER_REG		0x1301
 
+#define RTL8365MB_CHIP_OPTION_REG	0x13C1
+
+#define RTL8365MB_MAGIC_OPT_REG		0x13C0
 #define RTL8365MB_MAGIC_REG		0x13C2
 #define   RTL8365MB_MAGIC_VALUE		0x0249
 
@@ -579,6 +582,7 @@ struct rtl8365mb {
 	int irq;
 	u32 chip_id;
 	u32 chip_ver;
+	u32 chip_option;
 	u32 port_mask;
 	u32 learn_limit_max;
 	struct rtl8365mb_cpu cpu;
@@ -1959,7 +1963,7 @@ static void rtl8365mb_teardown(struct dsa_switch *ds)
 	rtl8365mb_irq_teardown(priv);
 }
 
-static int rtl8365mb_get_chip_id_and_ver(struct regmap *map, u32 *id, u32 *ver)
+static int rtl8365mb_get_chip_id_and_ver(struct regmap *map, u32 *id, u32 *ver, u32 *option)
 {
 	int ret;
 
@@ -1983,6 +1987,19 @@ static int rtl8365mb_get_chip_id_and_ver(struct regmap *map, u32 *id, u32 *ver)
 	if (ret)
 		return ret;
 
+	ret = regmap_write(map, RTL8365MB_MAGIC_OPT_REG, RTL8365MB_MAGIC_VALUE);
+	if (ret)
+		return ret;
+
+	ret = regmap_read(map, RTL8365MB_CHIP_OPTION_REG, option);
+	if (ret)
+		return ret;
+
+	/* Reset magic register */
+	ret = regmap_write(map, RTL8365MB_MAGIC_OPT_REG, 0);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -1991,9 +2008,10 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 	struct rtl8365mb *mb = priv->chip_data;
 	u32 chip_id;
 	u32 chip_ver;
+	u32 chip_option;
 	int ret;
 
-	ret = rtl8365mb_get_chip_id_and_ver(priv->map, &chip_id, &chip_ver);
+	ret = rtl8365mb_get_chip_id_and_ver(priv->map, &chip_id, &chip_ver, &chip_option);
 	if (ret) {
 		dev_err(priv->dev, "failed to read chip id and version: %d\n",
 			ret);
@@ -2005,22 +2023,22 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		switch (chip_ver) {
 		case RTL8365MB_CHIP_VER_8365MB_VC:
 			dev_info(priv->dev,
-				 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
-				 chip_ver);
+				 "found an RTL8365MB-VC switch (ver=0x%04x, opt=0x%04x)\n",
+				 chip_ver, chip_option);
 			break;
 		case RTL8365MB_CHIP_VER_8367RB:
 			dev_info(priv->dev,
-				 "found an RTL8367RB-VB switch (ver=0x%04x)\n",
-				 chip_ver);
+				 "found an RTL8367RB-VB switch (ver=0x%04x, opt=0x%04x)\n",
+				 chip_ver, chip_option);
 			break;
 		case RTL8365MB_CHIP_VER_8367S:
 			dev_info(priv->dev,
-				 "found an RTL8367S switch (ver=0x%04x)\n",
-				 chip_ver);
+				 "found an RTL8367S switch (ver=0x%04x, opt=0x%04x)\n",
+				 chip_ver, chip_option);
 			break;
 		default:
-			dev_err(priv->dev, "unrecognized switch version (ver=0x%04x)",
-				chip_ver);
+			dev_err(priv->dev, "unrecognized switch version (ver=0x%04x, opt=0x%04x)",
+				chip_ver, chip_option);
 			return -ENODEV;
 		}
 
@@ -2029,6 +2047,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
+		mb->chip_option = chip_option;
 		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
@@ -2043,8 +2062,8 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		break;
 	default:
 		dev_err(priv->dev,
-			"found an unknown Realtek switch (id=0x%04x, ver=0x%04x)\n",
-			chip_id, chip_ver);
+			"found an unknown Realtek switch (id=0x%04x, ver=0x%04x, opt=0x%04x)\n",
+			chip_id, chip_ver, chip_option);
 		return -ENODEV;
 	}
 
-- 
2.30.2

