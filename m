Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E054C16B49E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgBXWy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:54:28 -0500
Received: from foss.arm.com ([217.140.110.172]:43906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBXWyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:54:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B48DB106F;
        Mon, 24 Feb 2020 14:54:12 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A3C843F534;
        Mon, 24 Feb 2020 14:54:12 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH v2 4/6] net: bcmgenet: Initial bcmgenet ACPI support
Date:   Mon, 24 Feb 2020 16:54:01 -0600
Message-Id: <20200224225403.1650656-5-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224225403.1650656-1-jeremy.linton@arm.com>
References: <20200224225403.1650656-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rpi4 is capable of booting in ACPI mode with the latest
edk2-platform commits. As such it would be helpful if the genet
platform device were usable.

To achieve this we add a new MODULE_DEVICE_TABLE, and convert
a few dt specific methods to their generic device_ calls. Until
the next patch, ACPI based machines will fallback on random
mac addresses.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e50a15397e11..179855171918 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
 
+#include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -3466,10 +3467,9 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	const struct bcmgenet_plat_data *pdata;
 	struct bcmgenet_priv *priv;
 	struct net_device *dev;
-	const void *macaddr;
+	const void *macaddr = NULL;
 	unsigned int i;
 	int err = -EIO;
-	const char *phy_mode_str;
 
 	/* Up to GENET_MAX_MQ_CNT + 1 TX queues and RX queues */
 	dev = alloc_etherdev_mqs(sizeof(*priv), GENET_MAX_MQ_CNT + 1,
@@ -3500,7 +3500,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	if (dn)
 		macaddr = of_get_mac_address(dn);
-	else
+	else if (pd)
 		macaddr = pd->mac_address;
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
@@ -3547,8 +3547,9 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	priv->dev = dev;
 	priv->pdev = pdev;
-	if (of_id) {
-		pdata = of_id->data;
+
+	pdata = device_get_match_data(&pdev->dev);
+	if (pdata) {
 		priv->version = pdata->version;
 		priv->dma_max_burst_length = pdata->dma_max_burst_length;
 	} else {
@@ -3595,8 +3596,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	/* If this is an internal GPHY, power it on now, before UniMAC is
 	 * brought out of reset as absolutely no UniMAC activity is allowed
 	 */
-	if (dn && !of_property_read_string(dn, "phy-mode", &phy_mode_str) &&
-	    !strcasecmp(phy_mode_str, "internal"))
+	if (device_get_phy_mode(&pdev->dev) == PHY_INTERFACE_MODE_INTERNAL)
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
 	reset_umac(priv);
@@ -3771,6 +3771,12 @@ static int bcmgenet_suspend(struct device *d)
 
 static SIMPLE_DEV_PM_OPS(bcmgenet_pm_ops, bcmgenet_suspend, bcmgenet_resume);
 
+static const struct acpi_device_id genet_acpi_match[] = {
+	{ "BCM6E4E", (kernel_ulong_t)&bcm2711_plat_data },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, genet_acpi_match);
+
 static struct platform_driver bcmgenet_driver = {
 	.probe	= bcmgenet_probe,
 	.remove	= bcmgenet_remove,
@@ -3779,6 +3785,7 @@ static struct platform_driver bcmgenet_driver = {
 		.name	= "bcmgenet",
 		.of_match_table = bcmgenet_match,
 		.pm	= &bcmgenet_pm_ops,
+		.acpi_match_table = ACPI_PTR(genet_acpi_match),
 	},
 };
 module_platform_driver(bcmgenet_driver);
-- 
2.24.1

