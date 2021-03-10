Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8283333BE3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCJMAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhCJMAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:00:07 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307F9C06174A
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:00:07 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id m22so32969279lfg.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ra9bQG0mz9swBpsELh3r+5kZBuKBA23dy5zWQkgmkjc=;
        b=D0+GizvSOcyOOisLz+f7asU1ZFRFPWYZI3uy+VscL9OsW9AQYCeQ1G9PK8c5c0x2YO
         nlRklJS8MB7uas94WxzlICIG8vZ2aMCepCFM+xYgX+N+DF5MU85KiO+GbWX3LcOnPV95
         hyA91vF+MePyEBvsxfMGisRWegoDQIA4F6qwzPBwFDvs+cpAieckxMwLFbDiAGQtiLQU
         C6m1aFMeSD/dydNYjkiqkDyzCO0GPUHPgJy371T8ubEadF+DPeTEBTepc5YmgO7QmuDx
         aTRQqHBsbKUF+1BsV+zWjWeReNREENUrYY6166B1ERkTqlfOamIK2AJZOVajNSBs5AwJ
         2o6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ra9bQG0mz9swBpsELh3r+5kZBuKBA23dy5zWQkgmkjc=;
        b=TDwJ0qFdFJms4mmVKT3eElA8FNDw8FxNYC1zt2YFecCQv3K7mlDsTHBEhSj8omERe+
         wSPNcN57ZbentFLzh7ZEthB5ZivDztx4snnH5JWm/hviA+oDYMwrbE13LmdvnZS12seC
         TboTpavB4sAt+crbVlomdKVk6fF2+bnrsKXKAbRkv8qbgZmhArxk9HbRxAOPIXgwcKrR
         9zpZ507Mgz/X83dQH7+9DlY2cDJI/dnQqQk/sEAvi4L5UdMWgE04l05xOrZ74Rid8yqn
         21WhRsGbd5554jgjzV20bn6CrmUuyZfMSIuqDyvUxrIsft7YD+E1PlXdQha1QQsuk7yU
         uF0A==
X-Gm-Message-State: AOAM5334zkTyX9z/vYOLDn6qdZR9oCPa+CS+2xLwo3mZSCbyfMBcskxy
        VlRuiIvZ9Oqv9Th7v75LJcw=
X-Google-Smtp-Source: ABdhPJxjDBGl9J+/wUHRikHmuLwSIcWUArRJsAynow+E5ZE4r3Ehy06CfaxhqfKUqc9VZed+pr00LQ==
X-Received: by 2002:a19:9105:: with SMTP id t5mr1775315lfd.89.1615377605706;
        Wed, 10 Mar 2021 04:00:05 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id p3sm2824838lfg.14.2021.03.10.04.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:00:04 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: dsa: bcm_sf2: setup BCM4908 internal crossbar
Date:   Wed, 10 Mar 2021 12:59:51 +0100
Message-Id: <20210310115951.14565-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

On some SoCs (e.g. BCM4908, BCM631[345]8) SF2 has an integrated
crossbar. It allows connecting its selected external ports to internal
ports. It's used by vendors to handle custom Ethernet setups.

BCM4908 has following 3x2 crossbar. On Asus GT-AC5300 rgmii is used for
connecting external BCM53134S switch. GPHY4 is usually used for WAN
port. More fancy devices use SerDes for 2.5 Gbps Ethernet.

              ┌──────────┐
SerDes ─── 0 ─┤          │
              │   3x2    ├─ 0 ─── switch port 7
 GPHY4 ─── 1 ─┤          │
              │ crossbar ├─ 1 ─── runner (accelerator)
 rgmii ─── 2 ─┤          │
              └──────────┘

Use setup data based on DT info to configure BCM4908's switch port 7.
Right now only GPHY and rgmii variants are supported. Handling SerDes
can be implemented later.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c      | 41 ++++++++++++++++++++++++++++++++++
 drivers/net/dsa/bcm_sf2.h      |  1 +
 drivers/net/dsa/bcm_sf2_regs.h |  7 ++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 8f50e91d4004..b4b36408f069 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -432,6 +432,40 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
 	return 0;
 }
 
+static void bcm_sf2_crossbar_setup(struct bcm_sf2_priv *priv)
+{
+	struct device *dev = priv->dev->ds->dev;
+	int shift;
+	u32 mask;
+	u32 reg;
+	int i;
+
+	reg = 0;
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+		shift = CROSSBAR_BCM4908_INT_P7 * priv->num_crossbar_int_ports;
+		if (priv->int_phy_mask & BIT(7))
+			reg |= CROSSBAR_BCM4908_EXT_GPHY4 << shift;
+		else if (0) /* FIXME */
+			reg |= CROSSBAR_BCM4908_EXT_SERDES << shift;
+		else
+			reg |= CROSSBAR_BCM4908_EXT_RGMII << shift;
+		break;
+	default:
+		return;
+	}
+	reg_writel(priv, reg, REG_CROSSBAR);
+
+	reg = reg_readl(priv, REG_CROSSBAR);
+	mask = BIT(priv->num_crossbar_int_ports) - 1;
+	for (i = 0; i < priv->num_crossbar_int_ports; i++) {
+		shift = i * priv->num_crossbar_int_ports;
+
+		dev_dbg(dev, "crossbar in port #%d - out port #%d\n", i,
+			(reg >> shift) & mask);
+	}
+}
+
 static void bcm_sf2_intr_disable(struct bcm_sf2_priv *priv)
 {
 	intrl2_0_mask_set(priv, 0xffffffff);
@@ -856,6 +890,8 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 		return ret;
 	}
 
+	bcm_sf2_crossbar_setup(priv);
+
 	ret = bcm_sf2_cfp_resume(ds);
 	if (ret)
 		return ret;
@@ -1128,6 +1164,7 @@ struct bcm_sf2_of_data {
 	const u16 *reg_offsets;
 	unsigned int core_reg_align;
 	unsigned int num_cfp_rules;
+	unsigned int num_crossbar_int_ports;
 };
 
 static const u16 bcm_sf2_4908_reg_offsets[] = {
@@ -1152,6 +1189,7 @@ static const struct bcm_sf2_of_data bcm_sf2_4908_data = {
 	.core_reg_align	= 0,
 	.reg_offsets	= bcm_sf2_4908_reg_offsets,
 	.num_cfp_rules	= 0, /* FIXME */
+	.num_crossbar_int_ports = 2,
 };
 
 /* Register offsets for the SWITCH_REG_* block */
@@ -1262,6 +1300,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	priv->reg_offsets = data->reg_offsets;
 	priv->core_reg_align = data->core_reg_align;
 	priv->num_cfp_rules = data->num_cfp_rules;
+	priv->num_crossbar_int_ports = data->num_crossbar_int_ports;
 
 	priv->rcdev = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								"switch");
@@ -1335,6 +1374,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		goto out_clk_mdiv;
 	}
 
+	bcm_sf2_crossbar_setup(priv);
+
 	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
 
 	ret = bcm_sf2_mdio_register(ds);
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index 1ed901a68536..bf0b56313bc1 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -73,6 +73,7 @@ struct bcm_sf2_priv {
 	const u16			*reg_offsets;
 	unsigned int			core_reg_align;
 	unsigned int			num_cfp_rules;
+	unsigned int			num_crossbar_int_ports;
 
 	/* spinlock protecting access to the indirect registers */
 	spinlock_t			indir_lock;
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 1d2d55c9f8aa..e297b09411f3 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -48,6 +48,13 @@ enum bcm_sf2_reg_offs {
 #define  PHY_PHYAD_SHIFT		8
 #define  PHY_PHYAD_MASK			0x1F
 
+/* Relative to REG_CROSSBAR */
+#define CROSSBAR_BCM4908_INT_P7		0
+#define CROSSBAR_BCM4908_INT_RUNNER	1
+#define CROSSBAR_BCM4908_EXT_SERDES	0
+#define CROSSBAR_BCM4908_EXT_GPHY4	1
+#define CROSSBAR_BCM4908_EXT_RGMII	2
+
 #define REG_RGMII_CNTRL_P(x)		(REG_RGMII_0_CNTRL + (x))
 
 /* Relative to REG_RGMII_CNTRL */
-- 
2.26.2

