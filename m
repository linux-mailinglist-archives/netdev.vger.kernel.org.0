Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154E429C0C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390662AbfEXQUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:20:54 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37607 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390308AbfEXQUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:20:54 -0400
Received: by mail-lf1-f67.google.com with SMTP id m15so6970932lfh.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBARK8vNqygviud0La4Tdob+SuFOP0uNrEGVX2JRO4E=;
        b=dIOuYxlzCPlrdhjwthLVuivPss5LuD4xVyueVHQ91FoB2wY0iWoO6xPgzPQOtyI8Xt
         ACv1EF/Yemp22Kjx9EN6iPAUh3k7+xqshCjkyOpsPoP7bG6LfBym6BgDlrpxfeo7ZhPa
         HJuwj++zt2nhZKLx1wPoDTnf2+Q8aqDlSkDRSpWjmzuthDv8EybGKbVdZ3v9hTZymwb/
         CKiEu6unhmeqPl5sQcpbr96g9YBnRNg2LwPwsVbqzc402k5Ovjz0jdAYEhjUZaLckz/T
         lJn3cM9s0bLkHcunk4z6AqOxGkYdqCumfc9UJuC4FZhLAx4D8jZXBMelPewhgeyGWBZd
         WQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBARK8vNqygviud0La4Tdob+SuFOP0uNrEGVX2JRO4E=;
        b=n9oJOu0Znkfc5qLHmCiXhjKp17YbT2b4WDNzLeRQvDUT6/IVuK5S0ZVqAaXSs97TGZ
         lW8dwHASEcYRQRpIbQzEbfDX2993iwlpPxCQdDaOQBJ+K6J8O/2uTmplBpM6Zj87hegZ
         deIdg4jNSayuPwe5DQql9FRvltpxPiC6NB8XPebYABFavcCITg0PD71VvaT6opiTno6B
         gKc/X8U2jH4brqixmV8KNdG272VsEtohZusXdHO3L67bfcmLIRDzfNog7czc8A6yOxPd
         idkwe0M5TOm9FwlvQUeIXwq0gp5KE43OKRBeel4WF9ro9Tl2TXqOAGS32M6yVAFWGT93
         BYkw==
X-Gm-Message-State: APjAAAVWV6PVtq59TLhd1kkzTe647p1jFozAIcVY8Ea+I6SCgqmuAR/k
        qKGebbJg96PTEbAsoLFIpbvATPwrWz0=
X-Google-Smtp-Source: APXvYqwcDI+/YHs4L/agtMWq45gAVG3L6wSyhOzpYhRfr31JMeUdGmbHIHaxjC0pageYG+wp5KLx2g==
X-Received: by 2002:ac2:59c7:: with SMTP id x7mr13887342lfn.75.1558714848845;
        Fri, 24 May 2019 09:20:48 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.20.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:20:48 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/8] ARM/net: ixp4xx: Pass ethernet physical base as resource
Date:   Fri, 24 May 2019 18:20:19 +0200
Message-Id: <20190524162023.9115-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to probe this ethernet interface from the device tree
all physical MMIO regions must be passed as resources. Begin
this rewrite by first passing the port base address as a
resource for all platforms using this driver, remap it in
the driver and avoid using any reference of the statically
mapped virtual address in the driver.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ixp4xx/fsg-setup.c         | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/goramo_mlr.c        | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/ixdp425-setup.c     | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/nas100d-setup.c     | 10 ++++++++++
 arch/arm/mach-ixp4xx/nslu2-setup.c       | 10 ++++++++++
 arch/arm/mach-ixp4xx/omixp-setup.c       | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/vulcan-setup.c      | 20 ++++++++++++++++++++
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 20 +++++++++++---------
 8 files changed, 131 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
index 648932d8d7a8..507ee3878769 100644
--- a/arch/arm/mach-ixp4xx/fsg-setup.c
+++ b/arch/arm/mach-ixp4xx/fsg-setup.c
@@ -132,6 +132,22 @@ static struct platform_device fsg_leds = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource fsg_eth_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource fsg_eth_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info fsg_plat_eth[] = {
 	{
 		.phy		= 5,
@@ -151,12 +167,16 @@ static struct platform_device fsg_eth[] = {
 		.dev = {
 			.platform_data	= fsg_plat_eth,
 		},
+		.num_resources	= ARRAY_SIZE(fsg_eth_npeb_resources),
+		.resource	= fsg_eth_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev = {
 			.platform_data	= fsg_plat_eth + 1,
 		},
+		.num_resources	= ARRAY_SIZE(fsg_eth_npec_resources),
+		.resource	= fsg_eth_npec_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index 4d805080020e..7db396cc4353 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -270,6 +270,22 @@ static struct platform_device device_uarts = {
 
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource eth_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource eth_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info eth_plat[] = {
 	{
 		.phy		= 0,
@@ -287,10 +303,14 @@ static struct platform_device device_eth_tab[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= eth_plat,
+		.num_resources		= ARRAY_SIZE(eth_npeb_resources),
+		.resource		= eth_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= eth_plat + 1,
+		.num_resources		= ARRAY_SIZE(eth_npec_resources),
+		.resource		= eth_npec_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c b/arch/arm/mach-ixp4xx/ixdp425-setup.c
index 6f0f7ed18ea8..45d5b720ded6 100644
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -187,6 +187,22 @@ static struct platform_device ixdp425_uart = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource ixp425_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource ixp425_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info ixdp425_plat_eth[] = {
 	{
 		.phy		= 0,
@@ -204,10 +220,14 @@ static struct platform_device ixdp425_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= ixdp425_plat_eth,
+		.num_resources		= ARRAY_SIZE(ixp425_npeb_resources),
+		.resource		= ixp425_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= ixdp425_plat_eth + 1,
+		.num_resources		= ARRAY_SIZE(ixp425_npec_resources),
+		.resource		= ixp425_npec_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/nas100d-setup.c b/arch/arm/mach-ixp4xx/nas100d-setup.c
index c142cfa8c5d6..6959ad2e3aec 100644
--- a/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ b/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -165,6 +165,14 @@ static struct platform_device nas100d_uart = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource nas100d_eth_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info nas100d_plat_eth[] = {
 	{
 		.phy		= 0,
@@ -178,6 +186,8 @@ static struct platform_device nas100d_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= nas100d_plat_eth,
+		.num_resources		= ARRAY_SIZE(nas100d_eth_resources),
+		.resource		= nas100d_eth_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/nslu2-setup.c b/arch/arm/mach-ixp4xx/nslu2-setup.c
index ee1877fcfafe..a428bb918703 100644
--- a/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ b/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -185,6 +185,14 @@ static struct platform_device nslu2_uart = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource nslu2_eth_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info nslu2_plat_eth[] = {
 	{
 		.phy		= 1,
@@ -198,6 +206,8 @@ static struct platform_device nslu2_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= nslu2_plat_eth,
+		.num_resources		= ARRAY_SIZE(nslu2_eth_resources),
+		.resource		= nslu2_eth_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/omixp-setup.c b/arch/arm/mach-ixp4xx/omixp-setup.c
index 2d494b454376..6f86c27b725e 100644
--- a/arch/arm/mach-ixp4xx/omixp-setup.c
+++ b/arch/arm/mach-ixp4xx/omixp-setup.c
@@ -171,6 +171,22 @@ static struct platform_device mic256_leds = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource ixp425_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource ixp425_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info ixdp425_plat_eth[] = {
 	{
 		.phy		= 0,
@@ -188,10 +204,14 @@ static struct platform_device ixdp425_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= ixdp425_plat_eth,
+		.num_resources		= ARRAY_SIZE(ixp425_npeb_resources),
+		.resource		= ixp425_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= ixdp425_plat_eth + 1,
+		.num_resources		= ARRAY_SIZE(ixp425_npec_resources),
+		.resource		= ixp425_npec_resources,
 	},
 };
 
diff --git a/arch/arm/mach-ixp4xx/vulcan-setup.c b/arch/arm/mach-ixp4xx/vulcan-setup.c
index 2c03d2f6b647..783c291f8f4c 100644
--- a/arch/arm/mach-ixp4xx/vulcan-setup.c
+++ b/arch/arm/mach-ixp4xx/vulcan-setup.c
@@ -122,6 +122,22 @@ static struct platform_device vulcan_uart = {
 	.num_resources		= ARRAY_SIZE(vulcan_uart_resources),
 };
 
+static struct resource vulcan_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource vulcan_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info vulcan_plat_eth[] = {
 	[0] = {
 		.phy		= 0,
@@ -142,6 +158,8 @@ static struct platform_device vulcan_eth[] = {
 		.dev = {
 			.platform_data	= &vulcan_plat_eth[0],
 		},
+		.num_resources		= ARRAY_SIZE(vulcan_npeb_resources),
+		.resource		= vulcan_npeb_resources,
 	},
 	[1] = {
 		.name			= "ixp4xx_eth",
@@ -149,6 +167,8 @@ static struct platform_device vulcan_eth[] = {
 		.dev = {
 			.platform_data	= &vulcan_plat_eth[1],
 		},
+		.num_resources		= ARRAY_SIZE(vulcan_npec_resources),
+		.resource		= vulcan_npec_resources,
 	},
 };
 
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 064ff0886cc3..17d3291d79b4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1373,9 +1373,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	struct phy_device *phydev = NULL;
 	struct device *dev = &pdev->dev;
 	struct eth_plat_info *plat;
+	resource_size_t regs_phys;
 	struct net_device *ndev;
+	struct resource *res;
 	struct port *port;
-	u32 regs_phys;
 	int err;
 
 	plat = dev_get_platdata(dev);
@@ -1388,13 +1389,18 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	port->netdev = ndev;
 	port->id = pdev->id;
 
+	/* Get the port resource and remap */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	regs_phys = res->start;
+	port->regs = devm_ioremap_resource(dev, res);
+
 	switch (port->id) {
 	case IXP4XX_ETH_NPEA:
 		/* If the MDIO bus is not up yet, defer probe */
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
-		port->regs = (struct eth_regs __iomem *)IXP4XX_EthA_BASE_VIRT;
-		regs_phys  = IXP4XX_EthA_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEB:
 		/*
@@ -1407,13 +1413,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 			      IXP4XX_FEATURE_NPEB_ETH0))
 				return -ENODEV;
 			/* Else register the MDIO bus on NPE-B */
-			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+			if ((err = ixp4xx_mdio_register(port->regs)))
 				return err;
 		}
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
-		port->regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
-		regs_phys  = IXP4XX_EthB_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEC:
 		/*
@@ -1425,13 +1429,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 			      IXP4XX_FEATURE_NPEC_ETH))
 				return -ENODEV;
 			/* Else register the MDIO bus on NPE-C */
-			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+			if ((err = ixp4xx_mdio_register(port->regs)))
 				return err;
 		}
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
-		port->regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
-		regs_phys  = IXP4XX_EthC_BASE_PHYS;
 		break;
 	default:
 		return -ENODEV;
-- 
2.20.1

