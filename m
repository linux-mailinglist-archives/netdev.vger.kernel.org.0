Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B69629289
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiKOHgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiKOHgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:36:17 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BC215FF0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:36:15 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d9so18016275wrm.13
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tofLe7VkhuAP8ykkOBP52ao1zn0HKFI/d0yOPPGhcQo=;
        b=qPiL6puFyXidlZ5GnQU+0u6EL9qAiYmCMt24RnSKcbIMSUr5Kmz8io3EDiisxn2Rvi
         RyK559oeh78DtbEgoT9QrR1UNYamo6xU7Fq66jqy6ADPulLvK6J4+5yy8vARriFEzId9
         KD4AI4UjxSLma6Y2IKCLw4/lTppt0zGiIxCrPMV7tP7NEMQKJPpNYLkDnGDO5JctjEtX
         3SCvPbQHLzTOBl2xrZlcwSjiZfrECeWbnNufsssKhB1JGrWRAUIY0DL5Moo23P97yJjp
         l4l7lw2H/hVJCTBdDE+NeftFAHLnDldHKR3HeLMj+SyMpmeFlNV6vP4qUfeFvhQ0cVNs
         o/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tofLe7VkhuAP8ykkOBP52ao1zn0HKFI/d0yOPPGhcQo=;
        b=vwfD8j4cqMqeAzbis+4nHG+EtigW2pHIY0vBKEb033nm1+ngMZSEtEqyznMtVVsHCY
         1uV0895n8WZ+0Jf/jFFeUx6huAniMuq4+QQAmTxXzkv2v6oQIo7TUzc6taeNgr2mPGb9
         lfBvzfG8ktecXk8Mg8ZEXLb8s+TNKrqLDB8SoiFJQtEk1EVeCg5gQTyCYsQikTvY2onI
         xHtWQSE/IbJJagvFcDvu/kYGdRV4HOlK9823CQphAfnim6cWfDdfPPus+rYrg6ZEpymF
         S6xw/uTi8Ex00zx56oSOWGrAm8yr0wUBvArwkQe60+fJzsRXVSAk29uIr9ReKyG0br2i
         x0/Q==
X-Gm-Message-State: ANoB5pnlfk0QJ4I11uvIXxyWF7DotiQOLhzTJXH7pFWACM7W1Hf0QD2n
        xAu20yzFSnGFozbBfh1KCjatug==
X-Google-Smtp-Source: AA0mqf6scNZd5bDl0DQURWHPl/GZH48W54xzSw4N7Ksf275jrNAU+Yl0xVxHyAB525ge2J8UEGIvTg==
X-Received: by 2002:adf:dc91:0:b0:236:debd:bd65 with SMTP id r17-20020adfdc91000000b00236debdbd65mr9339427wrj.527.1668497773920;
        Mon, 14 Nov 2022 23:36:13 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j13-20020a5d452d000000b0022cbf4cda62sm13836811wra.27.2022.11.14.23.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 23:36:13 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 2/3] phy: handle optional regulator for PHY
Date:   Tue, 15 Nov 2022 07:36:02 +0000
Message-Id: <20221115073603.3425396-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115073603.3425396-1-clabbe@baylibre.com>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling of optional regulators for PHY.
Regulators need to be enabled before PHY scanning, so MDIO bus
initiate this task.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/mdio/fwnode_mdio.c | 31 ++++++++++++++++++++++++++++++-
 drivers/net/phy/phy_device.c   | 10 ++++++++++
 include/linux/phy.h            |  3 +++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 689e728345ce..19a16072d4ca 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -10,6 +10,7 @@
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/regulator/consumer.h>
 #include <linux/pse-pd/pse.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
@@ -116,7 +117,9 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	struct phy_device *phy;
 	bool is_c45 = false;
 	u32 phy_id;
-	int rc;
+	int rc, reg_cnt = 0;
+	struct regulator_bulk_data *consumers = NULL;
+	struct device_node __maybe_unused *nchild = NULL;
 
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
@@ -133,6 +136,26 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (rc >= 0)
 		is_c45 = true;
 
+#ifdef CONFIG_OF
+	for_each_child_of_node(bus->dev.of_node, nchild) {
+		u32 reg;
+
+		of_property_read_u32(nchild, "reg", &reg);
+		if (reg != addr)
+			continue;
+		reg_cnt = of_regulator_bulk_get_all(&bus->dev, nchild, &consumers);
+		if (reg_cnt > 0) {
+			rc = regulator_bulk_enable(reg_cnt, consumers);
+			if (rc)
+				return rc;
+		}
+		if (reg_cnt < 0) {
+			dev_err(&bus->dev, "Fail to regulator_bulk_get_all err=%d\n", reg_cnt);
+			return reg_cnt;
+		}
+	}
+#endif
+
 	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
 		phy = get_phy_device(bus, addr, is_c45);
 	else
@@ -142,6 +165,9 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		goto clean_mii_ts;
 	}
 
+	phy->regulator_cnt = reg_cnt;
+	phy->consumers = consumers;
+
 	if (is_acpi_node(child)) {
 		phy->irq = bus->irq[addr];
 
@@ -180,6 +206,9 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 clean_pse:
 	pse_control_put(psec);
 
+	if (reg_cnt > 0)
+		regulator_bulk_disable(reg_cnt, consumers);
+
 	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57849ac0384e..957e27c75eb2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -28,6 +28,7 @@
 #include <linux/phy_led_triggers.h>
 #include <linux/pse-pd/pse.h>
 #include <linux/property.h>
+#include <linux/regulator/consumer.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -1818,6 +1819,9 @@ int phy_suspend(struct phy_device *phydev)
 	if (!ret)
 		phydev->suspended = true;
 
+	if (phydev->regulator_cnt > 0)
+		regulator_bulk_disable(phydev->regulator_cnt, phydev->consumers);
+
 	return ret;
 }
 EXPORT_SYMBOL(phy_suspend);
@@ -1844,6 +1848,12 @@ int phy_resume(struct phy_device *phydev)
 {
 	int ret;
 
+	if (phydev->regulator_cnt > 0) {
+		ret = regulator_bulk_enable(phydev->regulator_cnt, phydev->consumers);
+		if (ret)
+			return ret;
+	}
+
 	mutex_lock(&phydev->lock);
 	ret = __phy_resume(phydev);
 	mutex_unlock(&phydev->lock);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9a3752c0c444..5d1311b35cc3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -729,6 +729,9 @@ struct phy_device {
 	void (*phy_link_change)(struct phy_device *phydev, bool up);
 	void (*adjust_link)(struct net_device *dev);
 
+	int regulator_cnt;
+	struct regulator_bulk_data *consumers;
+
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec management functions */
 	const struct macsec_ops *macsec_ops;
-- 
2.37.4

