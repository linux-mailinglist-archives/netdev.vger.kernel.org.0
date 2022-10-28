Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F3E610795
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiJ1CBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiJ1CBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:01:35 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2D2B14E4;
        Thu, 27 Oct 2022 19:01:31 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o7so258872pjj.1;
        Thu, 27 Oct 2022 19:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XH/Bsc+ps62oZnMk7LYtROZBsze0wCa4nGYaW1qqRJw=;
        b=kihFLUU44zYXjYRB6ucW/RTKD9F3kj4ffqVA8nlq2RvnRCyNmo5MqLtX55u+mHVbPH
         L4q1BSKny0ZMMGTfkOf0Ks4cmbHDDRgwZZhEEiv6ec/PLMLrn72QLKZyqf+KpPRja4Dn
         5kfH+Gy35RiX8W6MdYABYZIi8fAPEoDEyB4IICJzPJeg5RSWHv8yEK8Ny8XTH1oLk79W
         2NQlMWF61ln4XCoWnmTuFGlh6R5r63mD+HY+7sJITrlgYNfVB6uCpOZUIGzMzcJrhyyi
         tx+sJJ+hon3JjBzge2pFIQpclRQzfYIC3XCxgBEe9+TCvgoofZsN7J+9OURHTY591UAb
         z9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XH/Bsc+ps62oZnMk7LYtROZBsze0wCa4nGYaW1qqRJw=;
        b=0XufZXI6zANi3qxe9ES3Prk+70hwfE3U26IcGYA27l7XBLylAPzexQrB8iXLUbUVg6
         4L1aH+oTy/ADeVAz7jN9N7hB3/960nhRH2q/SA4KR1gnuIgN0Urvz32NgJWWUvy5tHJw
         esikjo4cVHIfiBg2L8hOUUxnaOXi/xYpOcXkQkNK3CHHd34bWdab8tRvJ1Kn49R0Wkso
         QTdQwLhgqQ6SgdrWUPvxrDEuiX/T7EKCru7UtSHsnGbfEdYxxX9JXwADPLhy2rK5Xqcp
         KViG33QnGY3cFQdKWjVuIlSykSBhtaU3UFR9lhUf4U1lGBYIjOUxSkIP1t1kovpKYjbv
         2bbA==
X-Gm-Message-State: ACrzQf3xny8Eaix12ax/hMruINTnnzvFUx2B2GEPtBj3Qsw2Oolhyxav
        7IJYOHbcSEpNCmBI4vLWXF/0ONFQU6bGZ7xFQM10lA==
X-Google-Smtp-Source: AMsMyM4s6wTgy/B8Cm2RGZVZu4ZGWc+CsFUseqc62yungFGyPitni1blSu/IopH96p8P6fOktq9Jnw==
X-Received: by 2002:a17:903:2284:b0:178:349b:d21b with SMTP id b4-20020a170903228400b00178349bd21bmr52568990plh.49.1666922491413;
        Thu, 27 Oct 2022 19:01:31 -0700 (PDT)
Received: from y.home.yangfl.dn42 ([104.28.213.203])
        by smtp.gmail.com with ESMTPSA id z10-20020a6553ca000000b0041c0c9c0072sm1629380pgr.64.2022.10.27.19.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 19:01:30 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
Date:   Fri, 28 Oct 2022 10:01:01 +0800
Message-Id: <20221028020104.347329-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004073619.49fd84be@kernel.org>
References: <20221004073619.49fd84be@kernel.org>
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
  repost after merge window
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

