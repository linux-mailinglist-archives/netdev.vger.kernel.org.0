Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32654B8D2F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiBPQDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:03:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiBPQDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:03:46 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05DA2A8D0C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:03:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g7so4706294edb.5
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CgwwwRe7DVOH/1dsBc3Z4xB3KrKc56bjTH+52806yM0=;
        b=LzzwC1b1yXUAENqm/50FckyEAdxE50WQO+Rb56jagPFwh/PDFNvGbXlLS48qdcS8hK
         mOquVl6ZrQlSHIrIaREZr1hdqmcrZ1DhXZQXMt1pgVyPH1VcKYguZ/SRmTCEtvkJAP3b
         5c83Q4v143IVlfHw+7EWjcUUPT6Uv17e/+F7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CgwwwRe7DVOH/1dsBc3Z4xB3KrKc56bjTH+52806yM0=;
        b=4kS173ZSEwenExrJhP/+zPv3aRg6ccQOdz+SllbIECsaYF0zgBd65yYqzWAxMTZz3Z
         2kAs3bCmzokeQj2iUiu2dMP/B11aoD3HF7REiIAZPES8zvhWC+sTiFa/Z1ThUeuzL5zP
         eDqHQL1KgS5yWcnqmdOhO6drh/9BIQu0gbm+ReYVxVRtJSjpSD1EjB+PjHUBNUvDY53W
         mx8h2VNX23LVtxFm+ixSolcTjZn4gpC0FxmXFqh6D3VtYObbRVWh91CdwOn3hWtSxozM
         aTRvxF5KNCZhMBuH0IzwD3xSoWIiUY5z3xVXsHNjCXyO4b4onwuW/6t3nOBoGLGgClfL
         VbZg==
X-Gm-Message-State: AOAM531w5gUsHHrM1toyWitnoYKFS1nkIzE186O4Tav6ZgnrxE9IMBLD
        mHpZ3DbGqToV/nCo2nkrhPBdCw==
X-Google-Smtp-Source: ABdhPJw4owliV0xvwuYMJxIJK2lCHFwl8dDLixoAHNVsFeXtWmFRFqobpt+tY85Zr09HRdRILOcCSw==
X-Received: by 2002:aa7:c983:0:b0:410:d314:6451 with SMTP id c3-20020aa7c983000000b00410d3146451mr3679668edt.56.1645027412302;
        Wed, 16 Feb 2022 08:03:32 -0800 (PST)
Received: from capella.. ([193.89.194.60])
        by smtp.gmail.com with ESMTPSA id j19sm48365ejm.111.2022.02.16.08.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 08:03:31 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: dsa: realtek: allow subdrivers to externally lock regmap
Date:   Wed, 16 Feb 2022 17:04:59 +0100
Message-Id: <20220216160500.2341255-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220216160500.2341255-1-alvin@pqrs.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Currently there is no way for Realtek DSA subdrivers to serialize
consecutive regmap accesses. In preparation for a bugfix relating to
indirect PHY register access - which involves a series of regmap
reads and writes - add a facility for subdrivers to serialize their
regmap access.

Specifically, a mutex is added to the driver private data structure and
the standard regmap is initialized with custom lock/unlock ops which use
this mutex. Then, a "nolock" variant of the regmap is added, which is
functionally equivalent to the existing regmap except that regmap
locking is disabled. Functions that wish to serialize a sequence of
regmap accesses may then lock the newly introduced driver-owned mutex
before using the nolock regmap.

Doing things this way means that subdriver code that doesn't care about
serialized register access - i.e. the vast majority of code - needn't
worry about synchronizing register access with an external lock: it can
just continue to use the original regmap.

Another advantage of this design is that, while regmaps with locking
disabled do not expose a debugfs interface for obvious reasons, there
still exists the original regmap which does expose this interface. This
interface remains safe to use even combined with driver codepaths that
use the nolock regmap, because said codepaths will use the same mutex
to synchronize access.

With respect to disadvantages, it can be argued that having
near-duplicate regmaps is confusing. However, the naming is rather
explicit, and examples will abound.

Finally, while we are at it, rename realtek_smi_mdio_regmap_config to
realtek_smi_regmap_config. This makes it consistent with the naming
realtek_mdio_regmap_config in realtek-mdio.c.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 46 ++++++++++++++++++++++--
 drivers/net/dsa/realtek/realtek-smi.c  | 48 ++++++++++++++++++++++++--
 drivers/net/dsa/realtek/realtek.h      |  2 ++
 3 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 0308be95d00a..31e1f100e48e 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -98,6 +98,20 @@ static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
 	return ret;
 }
 
+static void realtek_mdio_lock(void *ctx)
+{
+	struct realtek_priv *priv = ctx;
+
+	mutex_lock(&priv->map_lock);
+}
+
+static void realtek_mdio_unlock(void *ctx)
+{
+	struct realtek_priv *priv = ctx;
+
+	mutex_unlock(&priv->map_lock);
+}
+
 static const struct regmap_config realtek_mdio_regmap_config = {
 	.reg_bits = 10, /* A4..A0 R4..R0 */
 	.val_bits = 16,
@@ -108,6 +122,21 @@ static const struct regmap_config realtek_mdio_regmap_config = {
 	.reg_read = realtek_mdio_read,
 	.reg_write = realtek_mdio_write,
 	.cache_type = REGCACHE_NONE,
+	.lock = realtek_mdio_lock,
+	.unlock = realtek_mdio_unlock,
+};
+
+static const struct regmap_config realtek_mdio_nolock_regmap_config = {
+	.reg_bits = 10, /* A4..A0 R4..R0 */
+	.val_bits = 16,
+	.reg_stride = 1,
+	/* PHY regs are at 0x8000 */
+	.max_register = 0xffff,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.reg_read = realtek_mdio_read,
+	.reg_write = realtek_mdio_write,
+	.cache_type = REGCACHE_NONE,
+	.disable_locking = true,
 };
 
 static int realtek_mdio_probe(struct mdio_device *mdiodev)
@@ -115,8 +144,9 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	struct realtek_priv *priv;
 	struct device *dev = &mdiodev->dev;
 	const struct realtek_variant *var;
-	int ret;
+	struct regmap_config rc;
 	struct device_node *np;
+	int ret;
 
 	var = of_device_get_match_data(dev);
 	if (!var)
@@ -126,13 +156,25 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->map = devm_regmap_init(dev, NULL, priv, &realtek_mdio_regmap_config);
+	mutex_init(&priv->map_lock);
+
+	rc = realtek_mdio_regmap_config;
+	rc.lock_arg = priv;
+	priv->map = devm_regmap_init(dev, NULL, priv, &rc);
 	if (IS_ERR(priv->map)) {
 		ret = PTR_ERR(priv->map);
 		dev_err(dev, "regmap init failed: %d\n", ret);
 		return ret;
 	}
 
+	rc = realtek_mdio_nolock_regmap_config;
+	priv->map_nolock = devm_regmap_init(dev, NULL, priv, &rc);
+	if (IS_ERR(priv->map_nolock)) {
+		ret = PTR_ERR(priv->map_nolock);
+		dev_err(dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
 	priv->mdio_addr = mdiodev->addr;
 	priv->bus = mdiodev->bus;
 	priv->dev = &mdiodev->dev;
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 8806b74bd7a8..2243d3da55b2 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -311,7 +311,21 @@ static int realtek_smi_read(void *ctx, u32 reg, u32 *val)
 	return realtek_smi_read_reg(priv, reg, val);
 }
 
-static const struct regmap_config realtek_smi_mdio_regmap_config = {
+static void realtek_smi_lock(void *ctx)
+{
+	struct realtek_priv *priv = ctx;
+
+	mutex_lock(&priv->map_lock);
+}
+
+static void realtek_smi_unlock(void *ctx)
+{
+	struct realtek_priv *priv = ctx;
+
+	mutex_unlock(&priv->map_lock);
+}
+
+static const struct regmap_config realtek_smi_regmap_config = {
 	.reg_bits = 10, /* A4..A0 R4..R0 */
 	.val_bits = 16,
 	.reg_stride = 1,
@@ -321,6 +335,21 @@ static const struct regmap_config realtek_smi_mdio_regmap_config = {
 	.reg_read = realtek_smi_read,
 	.reg_write = realtek_smi_write,
 	.cache_type = REGCACHE_NONE,
+	.lock = realtek_smi_lock,
+	.unlock = realtek_smi_unlock,
+};
+
+static const struct regmap_config realtek_smi_nolock_regmap_config = {
+	.reg_bits = 10, /* A4..A0 R4..R0 */
+	.val_bits = 16,
+	.reg_stride = 1,
+	/* PHY regs are at 0x8000 */
+	.max_register = 0xffff,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.reg_read = realtek_smi_read,
+	.reg_write = realtek_smi_write,
+	.cache_type = REGCACHE_NONE,
+	.disable_locking = true,
 };
 
 static int realtek_smi_mdio_read(struct mii_bus *bus, int addr, int regnum)
@@ -385,6 +414,7 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	const struct realtek_variant *var;
 	struct device *dev = &pdev->dev;
 	struct realtek_priv *priv;
+	struct regmap_config rc;
 	struct device_node *np;
 	int ret;
 
@@ -395,14 +425,26 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 	priv->chip_data = (void *)priv + sizeof(*priv);
-	priv->map = devm_regmap_init(dev, NULL, priv,
-				     &realtek_smi_mdio_regmap_config);
+
+	mutex_init(&priv->map_lock);
+
+	rc = realtek_smi_regmap_config;
+	rc.lock_arg = priv;
+	priv->map = devm_regmap_init(dev, NULL, priv, &rc);
 	if (IS_ERR(priv->map)) {
 		ret = PTR_ERR(priv->map);
 		dev_err(dev, "regmap init failed: %d\n", ret);
 		return ret;
 	}
 
+	rc = realtek_smi_nolock_regmap_config;
+	priv->map_nolock = devm_regmap_init(dev, NULL, priv, &rc);
+	if (IS_ERR(priv->map_nolock)) {
+		ret = PTR_ERR(priv->map_nolock);
+		dev_err(dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
 	/* Link forward and backward */
 	priv->dev = dev;
 	priv->clk_delay = var->clk_delay;
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index e7d3e1bcf8b8..4fa7c6ba874a 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -52,6 +52,8 @@ struct realtek_priv {
 	struct gpio_desc	*mdc;
 	struct gpio_desc	*mdio;
 	struct regmap		*map;
+	struct regmap		*map_nolock;
+	struct mutex		map_lock;
 	struct mii_bus		*slave_mii_bus;
 	struct mii_bus		*bus;
 	int			mdio_addr;
-- 
2.35.0

