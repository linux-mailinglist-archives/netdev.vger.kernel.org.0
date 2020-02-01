Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720F914F71B
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 08:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgBAHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 02:46:54 -0500
Received: from foss.arm.com ([217.140.110.172]:41158 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbgBAHqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 02:46:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1183111B3;
        Fri, 31 Jan 2020 23:46:37 -0800 (PST)
Received: from u200856.usa.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 845B23F52E;
        Fri, 31 Jan 2020 23:50:15 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH 4/6] net: bcmgenet: Initial bcmgenet ACPI support
Date:   Sat,  1 Feb 2020 01:46:23 -0600
Message-Id: <20200201074625.8698-5-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201074625.8698-1-jeremy.linton@arm.com>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
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
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 120fa05a39ff..c736700f829e 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
 
+#include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -3476,7 +3477,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	const struct bcmgenet_plat_data *pdata;
 	struct bcmgenet_priv *priv;
 	struct net_device *dev;
-	const void *macaddr;
+	const void *macaddr = NULL;
 	unsigned int i;
 	int err = -EIO;
 	const char *phy_mode_str;
@@ -3510,7 +3511,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	if (dn)
 		macaddr = of_get_mac_address(dn);
-	else
+	else if (pd)
 		macaddr = pd->mac_address;
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
@@ -3555,8 +3556,9 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
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
@@ -3595,7 +3597,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	/* If this is an internal GPHY, power it on now, before UniMAC is
 	 * brought out of reset as absolutely no UniMAC activity is allowed
 	 */
-	if (dn && !of_property_read_string(dn, "phy-mode", &phy_mode_str) &&
+	if (!device_property_read_string(&pdev->dev, "phy-mode", &phy_mode_str) &&
 	    !strcasecmp(phy_mode_str, "internal"))
 		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
 
@@ -3768,6 +3770,12 @@ static int bcmgenet_suspend(struct device *d)
 
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
@@ -3776,6 +3784,7 @@ static struct platform_driver bcmgenet_driver = {
 		.name	= "bcmgenet",
 		.of_match_table = bcmgenet_match,
 		.pm	= &bcmgenet_pm_ops,
+		.acpi_match_table = ACPI_PTR(genet_acpi_match),
 	},
 };
 module_platform_driver(bcmgenet_driver);
-- 
2.24.1

