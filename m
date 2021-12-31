Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6F94821F7
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242680AbhLaEek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242678AbhLaEek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:34:40 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFA5C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:39 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id kk22so23903591qvb.0
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYs7nuT9QSLNG4slxKJ3aTbaAnxdwPsTPdy6q7fHCV4=;
        b=OI/3nKV5p6XJryb8RGSuSiuv6miVacqtA6gFQklvLf9yHPW8D49NA7/yA6fph5ubAy
         BNq7v9PSB4YU8mDJBG/5d0uWiw9aDK05hG0KUPwr2vd2eoJimHe8m/oq/yJ8OXHfPYga
         tpU5EPC6TQLiA2Q8m1rsNpiLm2nRIZJqxJp+IkTeSZWma6YHAX5IR+b+vy9IDWjujn7Y
         ZX0htOHXsxNALnFM9Mfe8/Ee+QlKIiGtVrSSi0tKgz48bImZRcVBmtC/ZpHVPFWHNe7f
         3VnH1qx29vr0P6Z5VWE+oz2upi9SnpZXmJtMQ7J0f9muCQV0G9pVXvXJp0/iL4a7OSgQ
         IonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYs7nuT9QSLNG4slxKJ3aTbaAnxdwPsTPdy6q7fHCV4=;
        b=BIAraAO7zr7x5qkSQr0OBK008xWdqtY7/Edz/yDiBYtbkr7q/Z6w+p32MjxLKEO3A+
         OzbmLi0ly+5zexhaifsHS5qBGpNtV4ztWQaibmyqcnjovSqCkSiYZLGEsewpgi9O1v28
         gTjEpEXM+pFYovail1WU+B+AWCP+OX1QrMi3MnyjwSFwW0VoLsCeoaTYtytCzTBAGG1E
         7/A1oiazMPR1oHilhe3MQFknWj2Bc+LQDf/FmrN6OuN9m5eOs1dRlzPR4vTFTmxeOOzN
         nla5RhuVbc5lLRrQ2hBjxUE3ZLPhatrR7G0klAETF+hWyvEyygtiTxNe7qqTZD2dhgwo
         m3zw==
X-Gm-Message-State: AOAM5334BevJJpFJTlqNdil/6TnN6FVeJi0jdHRJt/l1Z8QMpSXrrLhg
        Mn+xkPr2ylkh7J6KldHsK6CqYvhn0qWOOAoE
X-Google-Smtp-Source: ABdhPJx9lgWqK+sExS8NuCJCRr92trVR6c+p6jR6U5fQ/V0dQkPemTQlbgJjn84SLY5ohA2eOG/Mrw==
X-Received: by 2002:a05:6214:20a4:: with SMTP id 4mr14461892qvd.115.1640925278685;
        Thu, 30 Dec 2021 20:34:38 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:38 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 03/11] net: dsa: realtek: remove direct calls to realtek-smi
Date:   Fri, 31 Dec 2021 01:32:58 -0300
Message-Id: <20211231043306.12322-4-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
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
2.34.0

