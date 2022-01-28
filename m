Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B0649F112
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345428AbiA1ChB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345438AbiA1ChA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:37:00 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0016DC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:36:59 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id x193so9854457oix.0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=67NI3FJpjPd6g4zBnVwQJuKuMerl3iNQ8RU4cfvlYuQ=;
        b=AgUACWqk1rqxTmACXxNULSpJ0ANOATm0U1BCyWVuRXU1CRKTfn+SSZmGKmrPk44g80
         T2OmxruNb9jpXD1li4mbG7+tK1tN38429v7snu+ttiHX7NTkiqvs0lbG0/SrUG7gdmj6
         qf6n8tq9pIdnsqOYOG17qdY9kYE/Ng6Z88scfGi2vU6q+igEVXFo51KXi4Og0mwLc97a
         v42e+UlbfqK5c96wQNyOiF1LJhMesvqV9pmQUrGiGWedoWOo0UOIURiTowwsG3IxVkU/
         dyExxjqjHveGG/QJ8neYVKd0e98Vyq6e+2ZFk7HolximqXv1oJHCguZ7Vnz06tGhbMxj
         n0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=67NI3FJpjPd6g4zBnVwQJuKuMerl3iNQ8RU4cfvlYuQ=;
        b=mhpGnQEB5KrMoR30CqsSuGQeEOqVDs4+oaP3bkrvF1vWcEEzI5g1VSqDMebGayam7+
         15Z2r5Xd4bH4Kc0v1e2Jvx0oIW+VlKYJmyyMddYlVC8beeBNGL7tP6Gk+OxHsfU85h7K
         M+huv/x0alZNrzBJYRduCvmDviBsuhyeE58JrYY5ceIhUM3bmvIqh/VLALXhbDmS0Gdc
         IIfSm8VX9qp8xHBsDJxcYmSMPpFKximqgMTuozO3Y3HWzPLgRrqcyosdJ/qk7xNFkq7P
         SIQARC0t0xepMKffb1NUAh0ODN7K3tabHkC7S4lZSlb4oOnH6O7ejppKYznOBcyehxAb
         zezQ==
X-Gm-Message-State: AOAM530AnYpTZCwNdBNoOdQASln1oG3vS5F8Scj3q4taChCeB5J/GM7y
        sMYJyyMQ12y3V6VKEygXiUCduWm1ttqihQ==
X-Google-Smtp-Source: ABdhPJxCeWdkQl9UUdZOUCyKnhTwGDaQS2o6G4qtDwZf42Ue17qfBhAZs5BHKbexC0eZO5MYd6m+xA==
X-Received: by 2002:aca:3cc3:: with SMTP id j186mr4209316oia.78.1643337419144;
        Thu, 27 Jan 2022 18:36:59 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:36:58 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 03/11] net: dsa: realtek: remove direct calls to realtek-smi
Date:   Thu, 27 Jan 2022 23:36:03 -0300
Message-Id: <20220128023611.2424-4-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128023611.2424-1-luizluca@gmail.com>
References: <20220128023611.2424-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the only two direct calls from subdrivers to realtek-smi.
Now they are called from realtek_priv. Subdrivers can now be
linked independently from realtek-smi.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi-core.c | 15 +++++++++------
 drivers/net/dsa/realtek/realtek.h          |  7 ++-----
 drivers/net/dsa/realtek/rtl8365mb.c        | 12 +++++++-----
 drivers/net/dsa/realtek/rtl8366rb.c        | 12 +++++++-----
 4 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
index 7dfd86a99c24..a917801385c9 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi-core.c
@@ -292,12 +292,11 @@ static int realtek_smi_write_reg(struct realtek_priv *priv,
  * is when issueing soft reset. Since the device reset as soon as we write
  * that bit, no ACK will come back for natural reasons.
  */
-int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
-				u32 data)
+static int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
+				       u32 data)
 {
 	return realtek_smi_write_reg(priv, addr, data, false);
 }
-EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
 
 /* Regmap accessors */
 
@@ -342,8 +341,9 @@ static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 	return priv->ops->phy_write(priv, addr, regnum, val);
 }
 
-int realtek_smi_setup_mdio(struct realtek_priv *priv)
+static int realtek_smi_setup_mdio(struct dsa_switch *ds)
 {
+	struct realtek_priv *priv =  ds->priv;
 	struct device_node *mdio_np;
 	int ret;
 
@@ -363,10 +363,10 @@ int realtek_smi_setup_mdio(struct realtek_priv *priv)
 	priv->slave_mii_bus->read = realtek_smi_mdio_read;
 	priv->slave_mii_bus->write = realtek_smi_mdio_write;
 	snprintf(priv->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
-		 priv->ds->index);
+		 ds->index);
 	priv->slave_mii_bus->dev.of_node = mdio_np;
 	priv->slave_mii_bus->parent = priv->dev;
-	priv->ds->slave_mii_bus = priv->slave_mii_bus;
+	ds->slave_mii_bus = priv->slave_mii_bus;
 
 	ret = devm_of_mdiobus_register(priv->dev, priv->slave_mii_bus, mdio_np);
 	if (ret) {
@@ -413,6 +413,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->cmd_write = var->cmd_write;
 	priv->ops = var->ops;
 
+	priv->setup_interface = realtek_smi_setup_mdio;
+	priv->write_reg_noack = realtek_smi_write_reg_noack;
+
 	dev_set_drvdata(dev, priv);
 	spin_lock_init(&priv->lock);
 
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 177fff90b8a6..58814de563a2 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -66,6 +66,8 @@ struct realtek_priv {
 	struct rtl8366_mib_counter *mib_counters;
 
 	const struct realtek_ops *ops;
+	int			(*setup_interface)(struct dsa_switch *ds);
+	int			(*write_reg_noack)(struct realtek_priv *priv, u32 addr, u32 data);
 
 	int			vlan_enabled;
 	int			vlan4k_enabled;
@@ -115,11 +117,6 @@ struct realtek_variant {
 	size_t chip_data_sz;
 };
 
-/* SMI core calls */
-int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
-				u32 data);
-int realtek_smi_setup_mdio(struct realtek_priv *priv);
-
 /* RTL8366 library helpers */
 int rtl8366_mc_is_used(struct realtek_priv *priv, int mc_index, int *used);
 int rtl8366_set_vlan(struct realtek_priv *priv, int vid, u32 member,
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 6b8797ba80c6..5fb453b5f650 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1767,7 +1767,7 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 {
 	u32 val;
 
-	realtek_smi_write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
+	priv->write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
 				    FIELD_PREP(RTL8365MB_CHIP_RESET_HW_MASK,
 					       1));
 
@@ -1849,10 +1849,12 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 	if (ret)
 		goto out_teardown_irq;
 
-	ret = realtek_smi_setup_mdio(priv);
-	if (ret) {
-		dev_err(priv->dev, "could not set up MDIO bus\n");
-		goto out_teardown_irq;
+	if (priv->setup_interface) {
+		ret = priv->setup_interface(ds);
+		if (ret) {
+			dev_err(priv->dev, "could not set up MDIO bus\n");
+			goto out_teardown_irq;
+		}
 	}
 
 	/* Start statistics counter polling */
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 241e6b6ebea5..34e371084d6d 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1030,10 +1030,12 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		dev_info(priv->dev, "no interrupt support\n");
 
-	ret = realtek_smi_setup_mdio(priv);
-	if (ret) {
-		dev_info(priv->dev, "could not set up MDIO bus\n");
-		return -ENODEV;
+	if (priv->setup_interface) {
+		ret = priv->setup_interface(ds);
+		if (ret) {
+			dev_err(priv->dev, "could not set up MDIO bus\n");
+			return -ENODEV;
+		}
 	}
 
 	return 0;
@@ -1705,7 +1707,7 @@ static int rtl8366rb_reset_chip(struct realtek_priv *priv)
 	u32 val;
 	int ret;
 
-	realtek_smi_write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
+	priv->write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
 				    RTL8366RB_CHIP_CTRL_RESET_HW);
 	do {
 		usleep_range(20000, 25000);
-- 
2.34.1

