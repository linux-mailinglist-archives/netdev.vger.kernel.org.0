Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BA929185F
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgJRQgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgJRQgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 12:36:49 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0782820874;
        Sun, 18 Oct 2020 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603039008;
        bh=yEhqFD4tlXrlJq1smYpzCxxQAvOY+tidwn8QFMnBzDo=;
        h=From:To:Cc:Subject:Date:From;
        b=o7Lxf7hAX0wxrbr2DFwJL+OU3FiwakvpXjgcAhk1yRxkkDNj7qYuL3NimqNle3ZeU
         6CWnMbmQEukYz924uDQoX0wBRtwAsGQehQmZ0wuiHYaF988zwmVKgSQEdiRWFspyvT
         C9gksXycpJhYjIIc00aor+XKIfDXs7MCvlsWZVpw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI systems
Date:   Sun, 18 Oct 2020 18:36:25 +0200
Message-Id: <20201018163625.2392-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit bbc4d71d63549bc ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the Realtek PHY driver will override any TX/RX delay
set by hardware straps if the phy-mode device property does not match.

This is causing problems on SynQuacer based platforms (the only SoC
that incorporates the netsec hardware), since many were built with
this Realtek PHY, and shipped with firmware that defines the phy-mode
as 'rgmii', even though the PHY is configured for TX and RX delay using
pull-ups.

From the driver's perspective, we should not make any assumptions in
the general case that the PHY hardware does not require any initial
configuration. However, the situation is slightly different for ACPI
boot, since it implies rich firmware with AML abstractions to handle
hardware details that are not exposed to the OS. So in the ACPI case,
it is reasonable to assume that the PHY comes up in the right mode,
regardless of whether the mode is set by straps, by boot time firmware
or by AML executed by the ACPI interpreter.

So let's ignore the 'phy-mode' device property when probing the netsec
driver in ACPI mode, and hardcode the mode to PHY_INTERFACE_MODE_NA,
which should work with any PHY provided that it is configured by the
time the driver attaches to it. While at it, document that omitting
the mode is permitted for DT probing as well, by setting the phy-mode
DT property to the empty string.

Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Willy Liu <willy.liu@realtek.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Masahisa Kojima <masahisa.kojima@linaro.org>
Cc: Serge Semin <fancer.lancer@gmail.com>
Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Related discussion here:
https://lore.kernel.org/netdev/CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com/

 Documentation/devicetree/bindings/net/socionext-netsec.txt |  4 +++-
 drivers/net/ethernet/socionext/netsec.c                    | 24 ++++++++++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/socionext-netsec.txt b/Documentation/devicetree/bindings/net/socionext-netsec.txt
index 9d6c9feb12ff..a3c1dffaa4bb 100644
--- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
+++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
@@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt file in the same directory)
 - max-frame-size: See ethernet.txt in the same directory.
 
 The MAC address will be determined using the optional properties
-defined in ethernet.txt.
+defined in ethernet.txt. The 'phy-mode' property is required, but may
+be set to the empty string if the PHY configuration is programmed by
+the firmware or set by hardware straps, and needs to be preserved.
 
 Example:
 	eth0: ethernet@522d0000 {
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 806eb651cea3..1503cc9ec6e2 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -6,6 +6,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/acpi.h>
 #include <linux/of_mdio.h>
+#include <linux/of_net.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1833,6 +1834,14 @@ static const struct net_device_ops netsec_netdev_ops = {
 static int netsec_of_probe(struct platform_device *pdev,
 			   struct netsec_priv *priv, u32 *phy_addr)
 {
+	int err;
+
+	err = of_get_phy_mode(pdev->dev.of_node, &priv->phy_interface);
+	if (err) {
+		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
+		return err;
+	}
+
 	priv->phy_np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (!priv->phy_np) {
 		dev_err(&pdev->dev, "missing required property 'phy-handle'\n");
@@ -1859,6 +1868,14 @@ static int netsec_acpi_probe(struct platform_device *pdev,
 	if (!IS_ENABLED(CONFIG_ACPI))
 		return -ENODEV;
 
+	/* ACPI systems are assumed to configure the PHY in firmware, so
+	 * there is really no need to discover the PHY mode from the DSDT.
+	 * Since firmware is known to exist in the field that configures the
+	 * PHY correctly but passes the wrong mode string in the phy-mode
+	 * device property, we have no choice but to ignore it.
+	 */
+	priv->phy_interface = PHY_INTERFACE_MODE_NA;
+
 	ret = device_property_read_u32(&pdev->dev, "phy-channel", phy_addr);
 	if (ret) {
 		dev_err(&pdev->dev,
@@ -1995,13 +2012,6 @@ static int netsec_probe(struct platform_device *pdev)
 	priv->msg_enable = NETIF_MSG_TX_ERR | NETIF_MSG_HW | NETIF_MSG_DRV |
 			   NETIF_MSG_LINK | NETIF_MSG_PROBE;
 
-	priv->phy_interface = device_get_phy_mode(&pdev->dev);
-	if ((int)priv->phy_interface < 0) {
-		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
-		ret = -ENODEV;
-		goto free_ndev;
-	}
-
 	priv->ioaddr = devm_ioremap(&pdev->dev, mmio_res->start,
 				    resource_size(mmio_res));
 	if (!priv->ioaddr) {
-- 
2.17.1

