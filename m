Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC435F1AEC
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 10:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiJAInS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 04:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJAInQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 04:43:16 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDA614012;
        Sat,  1 Oct 2022 01:43:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u21so512777pfc.13;
        Sat, 01 Oct 2022 01:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=wGNlYMUBeU8Mn1otXNUtgOng0qnJ4zHVgKpmist2yYg=;
        b=i2Dr0ZdflAGfVZDDMa/n3ffMSBTzH3/SSKAVA5UOn0a2WVlut0297Wd1uOJu8lEWyb
         NkIWaYejuhOQQXlRgLkTJhipsIavvs4Iome4jWD7bUExHr75d301cKl2BgyS77YkuM9B
         qQNE1+/3IEstKfEupE4RXiWoB6s7xIm+/bkrhKsxKwgm14BMVvHS5dmZ6jbldKEij6fc
         WJynMJ1D+xVmDgFlHrnRt5ca3tTnXXgH3IbBO8yp2fAInwc/yJhM68GSOCywqQLOMCGe
         k5htuUM98t1z9oB16/5grHxDfg1f6z3j7pPignbJwRZhY0OUylfYICQMZebfH4vSmGr1
         cCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=wGNlYMUBeU8Mn1otXNUtgOng0qnJ4zHVgKpmist2yYg=;
        b=HhlpYkc7RjKzxpXfPFTXukOboYVKIR0YqlozdAPUtVwVXfxn0PtAMTp4TEnAdhkWQm
         HaD2HGcmcXMyig8QvUHdIWa+oeE49qfYZxfvOI9DZnfxmVRE3FbNy1VO+2yuLs4TjaO0
         j4ZK4BD3LGCyXveWk0DayIuAVL4WmiDsXU26lTKVEjFnmmjVyiEAlYAPVJ1Pml12vD1t
         iIZ8U11QK4mKLEN8go7MpgSedndEaVmDFg60LZl5KGSCq3gf3By62NuDh02jrDBGQGiA
         lscfigo4GxMFDqtFa/zGE+VldjEpEJi/C/cEwWDRq8hz1ZqsEITID/PNRfMdDM1lLegw
         /x5g==
X-Gm-Message-State: ACrzQf1V0ihJhVG/8BAYOJdwbyW3hnj64pBsJm1ql0rurGElAdD9a8aa
        vyxrSiMtuXaIklEaHdpqUfQ=
X-Google-Smtp-Source: AMsMyM44hy9B4AiaTAAdzEWsUC/YEYDKvfz7zmJwLL2MI7jvVdSVeltry2bXCRIWQtEI7twnOwvRNg==
X-Received: by 2002:a62:798e:0:b0:560:690:8c63 with SMTP id u136-20020a62798e000000b0056006908c63mr567108pfc.35.1664613794738;
        Sat, 01 Oct 2022 01:43:14 -0700 (PDT)
Received: from y.dmz.cipunited.com ([104.28.245.203])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b00178b77b7e71sm3354995plg.188.2022.10.01.01.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 01:43:14 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
Date:   Sat,  1 Oct 2022 16:42:55 +0800
Message-Id: <20221001084257.1157607-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930175942.76db1900@kernel.org>
References: <20220930175942.76db1900@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support mode switch properly, which is not available before.

If SoC has two Ethernet controllers, by setting both of them into MII
mode, the first controller enters GMII mode, while the second
controller is effectively disabled. This requires configuring (and
maybe enabling) the second controller in the device tree, even though
it cannot be used.

Signed-off-by: David Yang <mmyangfl@gmail.com>
---
v2: clarify modes work on controllers, read default value from PSC1
v3: Kirkwood only
v4: cleanup
v5: test on 88f6282
 drivers/net/ethernet/marvell/mv643xx_eth.c | 49 ++++++++++++++++++----
 include/linux/mv643xx_eth.h                |  1 +
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a..ed674c512 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -108,6 +108,7 @@ static char mv643xx_eth_driver_version[] = "1.4";
 #define TXQ_COMMAND			0x0048
 #define TXQ_FIX_PRIO_CONF		0x004c
 #define PORT_SERIAL_CONTROL1		0x004c
+#define  RGMII_EN			0x00000008
 #define  CLK125_BYPASS_EN		0x00000010
 #define TX_BW_RATE			0x0050
 #define TX_BW_MTU			0x0058
@@ -2761,6 +2762,8 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	mv643xx_eth_property(pnp, "rx-sram-addr", ppd.rx_sram_addr);
 	mv643xx_eth_property(pnp, "rx-sram-size", ppd.rx_sram_size);
 
+	of_get_phy_mode(pnp, &ppd.interface);
+
 	ppd.phy_node = of_parse_phandle(pnp, "phy-handle", 0);
 	if (!ppd.phy_node) {
 		ppd.phy_addr = MV643XX_ETH_PHY_NONE;
@@ -3092,6 +3095,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	struct mv643xx_eth_private *mp;
 	struct net_device *dev;
 	struct phy_device *phydev = NULL;
+	u32 psc1r;
 	int err, irq;
 
 	pd = dev_get_platdata(&pdev->dev);
@@ -3119,14 +3123,45 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 
 	mp->dev = dev;
 
-	/* Kirkwood resets some registers on gated clocks. Especially
-	 * CLK125_BYPASS_EN must be cleared but is not available on
-	 * all other SoCs/System Controllers using this driver.
-	 */
 	if (of_device_is_compatible(pdev->dev.of_node,
-				    "marvell,kirkwood-eth-port"))
-		wrlp(mp, PORT_SERIAL_CONTROL1,
-		     rdlp(mp, PORT_SERIAL_CONTROL1) & ~CLK125_BYPASS_EN);
+				    "marvell,kirkwood-eth-port")) {
+		psc1r = rdlp(mp, PORT_SERIAL_CONTROL1);
+
+		/* Kirkwood resets some registers on gated clocks. Especially
+		 * CLK125_BYPASS_EN must be cleared but is not available on
+		 * all other SoCs/System Controllers using this driver.
+		 */
+		psc1r &= ~CLK125_BYPASS_EN;
+
+		/* On Kirkwood with two Ethernet controllers, if both of them
+		 * have RGMII_EN disabled, the first controller will be in GMII
+		 * mode and the second one is effectively disabled, instead of
+		 * two MII interfaces.
+		 *
+		 * To enable GMII in the first controller, the second one must
+		 * also be configured (and may be enabled) with RGMII_EN
+		 * disabled too, even though it cannot be used at all.
+		 */
+		switch (pd->interface) {
+		/* Use internal to denote second controller being disabled */
+		case PHY_INTERFACE_MODE_INTERNAL:
+		case PHY_INTERFACE_MODE_MII:
+		case PHY_INTERFACE_MODE_GMII:
+			psc1r &= ~RGMII_EN;
+			break;
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+			psc1r |= RGMII_EN;
+			break;
+		default:
+			/* Unknown; don't touch */
+			break;
+		}
+
+		wrlp(mp, PORT_SERIAL_CONTROL1, psc1r);
+	}
 
 	/*
 	 * Start with a default rate, and if there is a clock, allow
diff --git a/include/linux/mv643xx_eth.h b/include/linux/mv643xx_eth.h
index 3682ae75c..14dc448f0 100644
--- a/include/linux/mv643xx_eth.h
+++ b/include/linux/mv643xx_eth.h
@@ -59,6 +59,7 @@ struct mv643xx_eth_platform_data {
 	 */
 	int			speed;
 	int			duplex;
+	phy_interface_t		interface;
 
 	/*
 	 * How many RX/TX queues to use.
-- 
2.35.1

