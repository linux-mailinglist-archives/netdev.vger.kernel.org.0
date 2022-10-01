Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FFB5F1E77
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 19:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJARp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 13:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiJARpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 13:45:55 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4522F67D;
        Sat,  1 Oct 2022 10:45:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s206so6604972pgs.3;
        Sat, 01 Oct 2022 10:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8/i4bGuJ/ciW50UGw2OhB8rbniqSjRCGyANdt3SIuRE=;
        b=dz3K9iLhrl6T69P93/fdxZ7SJflCZzL9grO7s2km6SVukSPghpFWMw0+nKuhVZ3qGw
         XAvwYdWkeR/ZnEokjGku3iUZi5K4bkswwrsU/GbKWvZwq92tXuU0jJkF5jIQTuz/BmzM
         YlP2g1Z/aQyW7h7rCd9j8ZInwN7ZfqpbtdtM3FZ9DWfrWO2mh3/KGjL3GdT0fsg8Be1q
         2fjCQZ7T9G5mcCyVRGU35wJLaaU+ohoMyXB52+vINJk6K1bpUeWvkQUtXa7cLCucMb7k
         4IvXPcoEj07Iy8cDhNyD+UCucPiljrRtxij7KiOryfDU4tYe4pkxy7btzKzBgfnJX6g/
         vm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8/i4bGuJ/ciW50UGw2OhB8rbniqSjRCGyANdt3SIuRE=;
        b=nCBK8Pm8PvRyw5l2VvG4xX5arRH0vs9cXOyt0lWjLDhd+ZavOVYGTuytJE6naiXFQh
         2t4vv9Uu9SohHD7q28MwyJhWUtnNMTvPJrR/5635gbpEW0R9vBnPHrL3cUty+J/nPYtt
         hnhaotE/fqC4fZaelS46iKr7H7BgDZqinbOiWcyEVA2i9/1HZToHgyyOoernb6ASbxyj
         Dep3tLe1GI7jk+EznW66icRJ9R5L8a45BYZIXWDuEagyI5S3LGWcXZ9LB5T+Tqj47qjm
         9jtX7diEMYYdJrT8Z/PT40ai/T4ga+M0MmnUmqGnt0DFWH8nrQjfH66Rr36BK6F5alDH
         aPqg==
X-Gm-Message-State: ACrzQf3WutqygSUjLAY7alngwXdkLTYE2JbdeEIzZz2kE6hZ1ASyA3hf
        1tt+PNpA+ZJ2iJYUaaZlbBU=
X-Google-Smtp-Source: AMsMyM4lqXpt+8fceP9korRGPY/m5MpSSqB3q42JbfLjGFZnmjR7AqjTusKao3QiIjivopd7xVP0zQ==
X-Received: by 2002:a63:85c3:0:b0:43a:e034:9e39 with SMTP id u186-20020a6385c3000000b0043ae0349e39mr12403662pgd.219.1664646353951;
        Sat, 01 Oct 2022 10:45:53 -0700 (PDT)
Received: from y.dmz.cipunited.com ([104.28.245.203])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f70d00b001750792f20asm4102762plo.238.2022.10.01.10.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 10:45:53 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
Date:   Sun,  2 Oct 2022 01:45:23 +0800
Message-Id: <20221001174524.2007912-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <202210020108.UlXaYP3c-lkp@intel.com>
References: <202210020108.UlXaYP3c-lkp@intel.com>
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
v6: fix missing header reported by kernel test robot
 drivers/net/ethernet/marvell/mv643xx_eth.c | 49 ++++++++++++++++++----
 include/linux/mv643xx_eth.h                |  2 +
 2 files changed, 44 insertions(+), 7 deletions(-)

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
index 3682ae75c..145169be2 100644
--- a/include/linux/mv643xx_eth.h
+++ b/include/linux/mv643xx_eth.h
@@ -8,6 +8,7 @@
 
 #include <linux/mbus.h>
 #include <linux/if_ether.h>
+#include <linux/phy.h>
 
 #define MV643XX_ETH_SHARED_NAME		"mv643xx_eth"
 #define MV643XX_ETH_NAME		"mv643xx_eth_port"
@@ -59,6 +60,7 @@ struct mv643xx_eth_platform_data {
 	 */
 	int			speed;
 	int			duplex;
+	phy_interface_t		interface;
 
 	/*
 	 * How many RX/TX queues to use.
-- 
2.35.1

