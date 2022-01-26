Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F749C73C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbiAZKO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbiAZKOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:14:54 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38865C061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:54 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id z19so25380593lfq.13
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=qqxkmTuDL0v9WH77bm0OjP2Xt3xkG3hMYP9qpSlEMQo=;
        b=kWB3pDyb6GK7cB9NC0EGJqCO++IYq7Ux9l7gTi9HBrbqNcOXW374l/CfIfwBhdGMyO
         R7gb2yLbmQ/7/7TsX3Nvg5M0hStCx24nC3lUBoNhxi7hqAb7PxTX8y10YhDaXMlq6okp
         49EATEyHJPhRJl9LrA2pCABm4pXyTyC8GCHnZ6W1WjCfE9qsXSAG8/629WB8wxEDMD4q
         c5UEHofas4N4Qic/PFWspRZITQljlIbh7kgyJACe2+9WSeud2hOCpNDqM6clctZK0HqE
         B3zr14qW2/HoqCfoxbKloJhuwDGkM55BT98n6TYMrH7WKdBS227SFKpR6yaZ7Hgo3S4H
         B9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=qqxkmTuDL0v9WH77bm0OjP2Xt3xkG3hMYP9qpSlEMQo=;
        b=YtvwB4m1kAhrFA3BMc29NWuXMH/iMGLRuR/OK2ESsZPY5dEjwRZWBGInAtewOrh7BG
         Uv3DkwinGa+sO0HwzM7BaAEiEl4hbB9pIVXF2raaGa23uhYaSybrTl1O+zXen/OxdTOX
         vdPqXFHu6hLrVuj7eV9KGJcMZSfv0v0NbZNg1w3CK1rv8M+tDl8t/4MZu7zoC1E18uuQ
         S7bL4u+UuxXWAzk0VDX8oK+ZgM+QQhuSl2SrU0q0jlwxpDRzP4EyuqjGL3h1NCaYAR04
         Q/lUeP+khM48UkHefhwOAHjOufWaeKiYBlB4Zl4+ogUePtAC8nOPeD9kuQdp76un+lyv
         SHBQ==
X-Gm-Message-State: AOAM530d1W+sXNvFz53B8sJeaqmiLjSuHuN3p3yFmTXplki7+TZ/vibq
        9bMS0oU/KjisHgCS1b3XkChf0g==
X-Google-Smtp-Source: ABdhPJw1Sm+RU38Ee1daea/JwTDtshnGfEbZdRpC2dQ6WKLjwdjbEONVXnXgFxZI3rHD0jS0MNhz8A==
X-Received: by 2002:a05:6512:1519:: with SMTP id bq25mr10006379lfb.326.1643192092592;
        Wed, 26 Jan 2022 02:14:52 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id h13sm1351906lfv.100.2022.01.26.02.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 02:14:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Markus Koch <markus@notsyncing.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net/fsl: xgmac_mdio: Support preamble suppression
Date:   Wed, 26 Jan 2022 11:14:30 +0100
Message-Id: <20220126101432.822818-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126101432.822818-1-tobias@waldekranz.com>
References: <20220126101432.822818-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the standard "suppress-preamble" attribute to disable preamble
generation.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 40442d64a247..18bf2370d45a 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -39,6 +39,7 @@ struct tgec_mdio_controller {
 #define MDIO_STAT_CLKDIV(x)	(((x>>1) & 0xff) << 8)
 #define MDIO_STAT_BSY		BIT(0)
 #define MDIO_STAT_RD_ER		BIT(1)
+#define MDIO_STAT_PRE_DIS	BIT(5)
 #define MDIO_CTL_DEV_ADDR(x) 	(x & 0x1f)
 #define MDIO_CTL_PORT_ADDR(x)	((x & 0x1f) << 5)
 #define MDIO_CTL_PRE_DIS	BIT(10)
@@ -254,6 +255,21 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	return ret;
 }
 
+static void xgmac_mdio_set_suppress_preamble(struct mii_bus *bus)
+{
+	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	struct device *dev = bus->parent;
+	u32 mdio_stat;
+
+	if (!device_property_read_bool(dev, "suppress-preamble"))
+		return;
+
+	mdio_stat = xgmac_read32(&regs->mdio_stat, priv->is_little_endian);
+	mdio_stat |= MDIO_STAT_PRE_DIS;
+	xgmac_write32(mdio_stat, &regs->mdio_stat, priv->is_little_endian);
+}
+
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
 	struct fwnode_handle *fwnode;
@@ -301,6 +317,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
+	xgmac_mdio_set_suppress_preamble(bus);
+
 	fwnode = pdev->dev.fwnode;
 	if (is_of_node(fwnode))
 		ret = of_mdiobus_register(bus, to_of_node(fwnode));
-- 
2.25.1

