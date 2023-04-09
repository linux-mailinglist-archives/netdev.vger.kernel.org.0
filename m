Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FC56DC07E
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 17:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjDIPCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 11:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDIPCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 11:02:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD1735B0
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 08:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=dO5Niz6f6nVK8qWtJeqaCSLZeFBhXWBcIjpUedKvUJw=; b=EJvVucNwT1+WPABDf+KfXhHDI0
        3VjXGjOvo6Fz0UkNMrQX6/vSbhhWPr74NrG8mZcZKWVtKlIwzSxas5t700XX4PYpJi7mI0gnLEqlH
        VZGOCd4pAONl3piPRig5hhcKsZNTq9zKdPzdEys2kqtDdXpr9WsZTpPWJPCy3+Bl2N+c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plWYV-009qMc-SI; Sun, 09 Apr 2023 17:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
Date:   Sun,  9 Apr 2023 17:02:04 +0200
Message-Id: <20230409150204.2346231-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
depends or selects, depending on if there are circular dependencies or
not. This avoids linker errors, especially for randconfig builds.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/Kconfig       | 1 +
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 drivers/net/ethernet/marvell/Kconfig         | 1 +
 drivers/net/ethernet/qualcomm/Kconfig        | 1 +
 drivers/net/mdio/Kconfig                     | 3 +++
 5 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index f1e80d6996ef..1c78f66a89da 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -71,6 +71,7 @@ config FSL_XGMAC_MDIO
 	tristate "Freescale XGMAC MDIO"
 	select PHYLIB
 	depends on OF
+	select MDIO_DEVRES
 	select OF_MDIO
 	help
 	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and
diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 9bc099cf3cb1..4d75e6807e92 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -10,6 +10,7 @@ config FSL_ENETC_CORE
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI_MSI
+	select MDIO_DEVRES
 	select FSL_ENETC_CORE
 	select FSL_ENETC_IERB
 	select FSL_ENETC_MDIO
diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index f58a1c0144ba..884d64114bff 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -34,6 +34,7 @@ config MV643XX_ETH
 config MVMDIO
 	tristate "Marvell MDIO interface support"
 	depends on HAS_IOMEM
+	select MDIO_DEVRES
 	select PHYLIB
 	help
 	  This driver supports the MDIO interface found in the network
diff --git a/drivers/net/ethernet/qualcomm/Kconfig b/drivers/net/ethernet/qualcomm/Kconfig
index a4434eb38950..9210ff360fdc 100644
--- a/drivers/net/ethernet/qualcomm/Kconfig
+++ b/drivers/net/ethernet/qualcomm/Kconfig
@@ -52,6 +52,7 @@ config QCOM_EMAC
 	depends on HAS_DMA && HAS_IOMEM
 	select CRC32
 	select PHYLIB
+	select MDIO_DEVRES
 	help
 	  This driver supports the Qualcomm Technologies, Inc. Gigabit
 	  Ethernet Media Access Controller (EMAC). The controller
diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 90309980686e..9ff2e6f22f3f 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -65,6 +65,7 @@ config MDIO_ASPEED
 	tristate "ASPEED MDIO bus controller"
 	depends on ARCH_ASPEED || COMPILE_TEST
 	depends on OF_MDIO && HAS_IOMEM
+	depends on MDIO_DEVRES
 	help
 	  This module provides a driver for the independent MDIO bus
 	  controllers found in the ASPEED AST2600 SoC. This is a driver for the
@@ -170,6 +171,7 @@ config MDIO_IPQ4019
 	tristate "Qualcomm IPQ4019 MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
 	depends on COMMON_CLK
+	depends on MDIO_DEVRES
 	help
 	  This driver supports the MDIO interface found in Qualcomm
 	  IPQ40xx, IPQ60xx, IPQ807x and IPQ50xx series Soc-s.
@@ -178,6 +180,7 @@ config MDIO_IPQ8064
 	tristate "Qualcomm IPQ8064 MDIO interface support"
 	depends on HAS_IOMEM && OF_MDIO
 	depends on MFD_SYSCON
+	depends on MDIO_DEVRES
 	help
 	  This driver supports the MDIO interface found in the network
 	  interface units of the IPQ8064 SoC
-- 
2.40.0

