Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBBC454EF1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbhKQVIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240262AbhKQVIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:23 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8520C061570;
        Wed, 17 Nov 2021 13:05:23 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b15so16973740edd.7;
        Wed, 17 Nov 2021 13:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yIJS/1iBvu+w7JezmkxW5wUMLoTaW6Y1Obeh9jb/iF0=;
        b=nOHmen3IKZ5A//I5GuBlOlIBM+ztKF/r/394EsILay5zwwujQ/CXrgC0A28LoJZfJU
         O53OKD08JNXAx/q2cyl5Lo47TeyI0i2pzEuF2a23Dp9QHW0aULMMGM4rM/3K+aCsMChh
         WWiw6c55k1yYfQNySpsAuSipT57K+Zp1uttHwMaZiG1/8Ca74Nk2JLyPgWcqS39gejOF
         ues1AMbPLKyVYrHsdaHJqykEuWIMR+3OkvPPYic63VHetBoKDFUqPGm/Ajpxpbb9zTJ7
         ymPX71v9rzTv75Gp0AufPrNem4iGeTF1lW+mGasLe5cF0hU8IE0NSR3R2puJI1Ya5rxg
         sZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yIJS/1iBvu+w7JezmkxW5wUMLoTaW6Y1Obeh9jb/iF0=;
        b=rDk5/0qzbhZhuD5dttD0w+suD+lSiftH0vdyfd1fDaCAGVtKZF2w2xRkgFgoQIwnnx
         g1jH/1L3KGtEW3ENHgYok7K9mnbOA7L2p7B0u1NjqWjaUajrKM7fSEm8lbZdDLy7slPX
         D1cyPAewHZlRDBMpABuvzu0ArqL9wT6kTwXo30cGou+5UHDwRqCrab2C7l2hVJqSCrIn
         ZOlbppmdYdXsZyoLsRidZEVC3z5Ex6KXd5odCWPNMIPN4ZQXbaPNE2oyCssxWXYsxO2v
         wHF+yQT6A9AtvQXRXd/AqcgfIbq8LLSewRQDX6ZwpUOjvQaeJ7buGflEWIvpBLaN/t7p
         hZ1g==
X-Gm-Message-State: AOAM531pUzPITMBrpLYwQebf7MRPqcfLFQKMF7zHxlI9my9YMaP0/f/r
        491a8qX17EVN5+EimVP5/eo=
X-Google-Smtp-Source: ABdhPJz0sfr+Rk9qlbFUJrfM0L1ZSrTix7XM6NkLFivJU/obhSPRxfurYeJk6GJZFidJbhCsVRwy5A==
X-Received: by 2002:a17:906:794f:: with SMTP id l15mr26864172ejo.324.1637183122405;
        Wed, 17 Nov 2021 13:05:22 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:20 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 05/19] net: dsa: qca8k: move read switch id function in qca8k_setup
Date:   Wed, 17 Nov 2021 22:04:37 +0100
Message-Id: <20211117210451.26415-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move read_switch_id function in qca8k_setup in preparation for regmap
conversion. Sw probe should NOT contain function that depends on reading
from switch regs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 71 ++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 19331edf1fd4..be98d11b17ec 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1073,6 +1073,36 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	const struct qca8k_match_data *data;
+	u32 val;
+	u8 id;
+	int ret;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+	if (!data)
+		return -ENODEV;
+
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	if (ret < 0)
+		return -ENODEV;
+
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
+	if (id != data->id) {
+		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
+		return -ENODEV;
+	}
+
+	priv->switch_id = id;
+
+	/* Save revision to communicate to the internal PHY driver */
+	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
+
+	return 0;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -1080,6 +1110,11 @@ qca8k_setup(struct dsa_switch *ds)
 	int cpu_port, ret, i;
 	u32 mask;
 
+	/* Check the detected switch id */
+	ret = qca8k_read_switch_id(priv);
+	if (ret)
+		return ret;
+
 	cpu_port = qca8k_find_cpu_port(ds);
 	if (cpu_port < 0) {
 		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
@@ -2023,41 +2058,10 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 };
 
-static int qca8k_read_switch_id(struct qca8k_priv *priv)
-{
-	const struct qca8k_match_data *data;
-	u32 val;
-	u8 id;
-	int ret;
-
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
-	if (!data)
-		return -ENODEV;
-
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
-	if (ret < 0)
-		return -ENODEV;
-
-	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != data->id) {
-		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
-		return -ENODEV;
-	}
-
-	priv->switch_id = id;
-
-	/* Save revision to communicate to the internal PHY driver */
-	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
-
-	return 0;
-}
-
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
 	struct qca8k_priv *priv;
-	int ret;
 
 	/* allocate the private data struct so that we can probe the switches
 	 * ID register
@@ -2083,11 +2087,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
-	/* Check the detected switch id */
-	ret = qca8k_read_switch_id(priv);
-	if (ret)
-		return ret;
-
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
-- 
2.32.0

