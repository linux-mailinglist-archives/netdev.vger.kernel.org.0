Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D05C49F340
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbiA1GF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346277AbiA1GFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:05:53 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5360C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:51 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id e81so10517072oia.6
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vyyxB0+ch1xc8B+whWuvHPnt6XB+yAJoW63k3HdIq2w=;
        b=RtKC6q4HUad23i+e3hDxGx+Qi8M84hJ3wNiXfIlLfSUmfmoXj/qvJ7AAqfgkVvPyFn
         iD++YdfvUYIe1pltHSv556bFQYhS5xGUn4E9GCIO7hruNEzLTcPpZtkZ82/iNjFkKMl9
         3rCemW4tdU4WG3h96shtyYS3S5lpzo0OtBoXIaKO0GZKVb8jJFknHNDpzsV5WV/OnxVl
         HVgeRV3k/qdUfuBcIsnkQrKOJoLLftajeNH1zcLedOSd90SNagoMYY3LGmpxiHDecENO
         YiBtB1NH83ZQy5CO1pPohDGbm6q2bzsWg1axt/1pS+81mICXMnTV2m7Pr4Th545EboAh
         eKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vyyxB0+ch1xc8B+whWuvHPnt6XB+yAJoW63k3HdIq2w=;
        b=2kETJiPSaQvqDuHPaNKltUjP2cqHd2ZC0V5z13Z83TElK7tmktvIcjilCODV3QPaVG
         XN4SbFriDJHJET7EibmeGXTrjEz9rmdvxXsYnmZ2BA0TnVUuILLAIMYrmfoWCGdPU7I0
         a9kSt1LwUu9GnLco5m4VrSNw5VsgMjgJTkKIfDrmMHEDJMbJfuFIMgzUSjQ/qMbHNUqT
         lfjjjMwFSNsccE6t50vYWNi6RgxHOsxHnr0ayHWr3fm7Y8T0aXRxEOafj0mQkvE4XzPY
         FQJS2Jiemh8PfIREQ2G4h0cvlodRRM3qIXNctcyZtC/diLeYqF9u76kcgwz+sBP716nb
         k8tA==
X-Gm-Message-State: AOAM531RoyuzFQjc5G5bl/DFYMsPNjsctZs3+3rOwj/gVFzDDqEAScCn
        GA2cPCJe8cB6LmDKkcASN2V6etU/2fEnNA==
X-Google-Smtp-Source: ABdhPJw4Wni5LiA5YOJwe2G8lYqaZyIA0Ylb3TAPoM5Qd2bCbetIBZBv4jyTHnmrWaVc24jQQ+qCoQ==
X-Received: by 2002:aca:3744:: with SMTP id e65mr4597803oia.323.1643349950805;
        Thu, 27 Jan 2022 22:05:50 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:05:50 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 04/13] net: dsa: realtek: remove direct calls to realtek-smi
Date:   Fri, 28 Jan 2022 03:05:00 -0300
Message-Id: <20220128060509.13800-5-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the only two direct calls from subdrivers to realtek-smi.
Now they are called from realtek_priv. Subdrivers can now be
linked independently from realtek-smi.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi-core.c | 16 +++++++++-------
 drivers/net/dsa/realtek/realtek.h          |  7 ++-----
 drivers/net/dsa/realtek/rtl8365mb.c        | 15 ++++++++-------
 drivers/net/dsa/realtek/rtl8366rb.c        | 14 ++++++++------
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
index 7dfd86a99c24..5fb86ae2339c 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi-core.c
@@ -292,12 +292,10 @@ static int realtek_smi_write_reg(struct realtek_priv *priv,
  * is when issueing soft reset. Since the device reset as soon as we write
  * that bit, no ACK will come back for natural reasons.
  */
-int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
-				u32 data)
+static int realtek_smi_write_reg_noack(void *ctx, u32 reg, u32 val)
 {
-	return realtek_smi_write_reg(priv, addr, data, false);
+	return realtek_smi_write_reg(ctx, reg, val, false);
 }
-EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
 
 /* Regmap accessors */
 
@@ -342,8 +340,9 @@ static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 	return priv->ops->phy_write(priv, addr, regnum, val);
 }
 
-int realtek_smi_setup_mdio(struct realtek_priv *priv)
+static int realtek_smi_setup_mdio(struct dsa_switch *ds)
 {
+	struct realtek_priv *priv =  ds->priv;
 	struct device_node *mdio_np;
 	int ret;
 
@@ -363,10 +362,10 @@ int realtek_smi_setup_mdio(struct realtek_priv *priv)
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
@@ -413,6 +412,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->cmd_write = var->cmd_write;
 	priv->ops = var->ops;
 
+	priv->setup_interface = realtek_smi_setup_mdio;
+	priv->write_reg_noack = realtek_smi_write_reg_noack;
+
 	dev_set_drvdata(dev, priv);
 	spin_lock_init(&priv->lock);
 
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 6e8d385d628c..4152eba851be 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -66,6 +66,8 @@ struct realtek_priv {
 	struct rtl8366_mib_counter *mib_counters;
 
 	const struct realtek_ops *ops;
+	int			(*setup_interface)(struct dsa_switch *ds);
+	int			(*write_reg_noack)(void *ctx, u32 addr, u32 data);
 
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
index 6b8797ba80c6..a50cae28b7ae 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1767,9 +1767,8 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 {
 	u32 val;
 
-	realtek_smi_write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
-				    FIELD_PREP(RTL8365MB_CHIP_RESET_HW_MASK,
-					       1));
+	priv->write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
+			      FIELD_PREP(RTL8365MB_CHIP_RESET_HW_MASK, 1));
 
 	/* Realtek documentation says the chip needs 1 second to reset. Sleep
 	 * for 100 ms before accessing any registers to prevent ACK timeouts.
@@ -1849,10 +1848,12 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
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
index fa222a6dac87..b301408028ef 100644
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
@@ -1707,8 +1709,8 @@ static int rtl8366rb_reset_chip(struct realtek_priv *priv)
 	u32 val;
 	int ret;
 
-	realtek_smi_write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
-				    RTL8366RB_CHIP_CTRL_RESET_HW);
+	priv->write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
+			      RTL8366RB_CHIP_CTRL_RESET_HW);
 	do {
 		usleep_range(20000, 25000);
 		ret = regmap_read(priv->map, RTL8366RB_RESET_CTRL_REG, &val);
-- 
2.34.1

