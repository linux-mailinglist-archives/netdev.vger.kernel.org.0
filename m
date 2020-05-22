Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8141DE271
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgEVIyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:54:39 -0400
Received: from inva021.nxp.com ([92.121.34.21]:33332 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgEVIyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 04:54:38 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 851DF2004C5;
        Fri, 22 May 2020 10:54:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 78CB12004C1;
        Fri, 22 May 2020 10:54:35 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4B7252048C;
        Fri, 22 May 2020 10:54:35 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, vladimir.oltean@nxp.com
Subject: [PATCH net] felix: Fix initialization of ioremap resources
Date:   Fri, 22 May 2020 11:54:34 +0300
Message-Id: <1590137674-31727-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller of devm_ioremap_resource(), either accidentally
or by wrong assumption, is writing back derived resource data
to global static resource initialization tables that should
have been constant.  Meaning that after it computes the final
physical start address it saves the address for no reason
in the static tables.  This doesn't affect the first driver
probing after reboot, but it breaks consecutive driver reloads
(i.e. driver unbind & bind) because the initialization tables
no longer have the correct initial values.  So the next probe()
will map the device registers to wrong physical addresses,
causing ARM SError async exceptions.
This patch fixes all of the above.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 23 +++++++++++------------
 drivers/net/dsa/ocelot/felix.h         |  6 +++---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 ++++++++++------------
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e2c6bf0..e8aae64 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -388,6 +388,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
 	resource_size_t switch_base;
+	struct resource res;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -422,17 +423,16 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
-		struct resource *res;
 
 		if (!felix->info->target_io_res[i].name)
 			continue;
 
-		res = &felix->info->target_io_res[i];
-		res->flags = IORESOURCE_MEM;
-		res->start += switch_base;
-		res->end += switch_base;
+		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
+		res.flags = IORESOURCE_MEM;
+		res.start += switch_base;
+		res.end += switch_base;
 
-		target = ocelot_regmap_init(ocelot, res);
+		target = ocelot_regmap_init(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -453,7 +453,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		void __iomem *port_regs;
-		struct resource *res;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -465,12 +464,12 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return -ENOMEM;
 		}
 
-		res = &felix->info->port_io_res[port];
-		res->flags = IORESOURCE_MEM;
-		res->start += switch_base;
-		res->end += switch_base;
+		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
+		res.flags = IORESOURCE_MEM;
+		res.start += switch_base;
+		res.end += switch_base;
 
-		port_regs = devm_ioremap_resource(ocelot->dev, res);
+		port_regs = devm_ioremap_resource(ocelot->dev, &res);
 		if (IS_ERR(port_regs)) {
 			dev_err(ocelot->dev,
 				"failed to map registers for port %d\n", port);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9af1065..730a8a9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -8,9 +8,9 @@
 
 /* Platform-specific information */
 struct felix_info {
-	struct resource			*target_io_res;
-	struct resource			*port_io_res;
-	struct resource			*imdio_res;
+	const struct resource		*target_io_res;
+	const struct resource		*port_io_res;
+	const struct resource		*imdio_res;
 	const struct reg_field		*regfields;
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 8bf395f..5211f05 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -333,10 +333,8 @@ static const u32 *vsc9959_regmap[] = {
 	[GCB]	= vsc9959_gcb_regmap,
 };
 
-/* Addresses are relative to the PCI device's base address and
- * will be fixed up at ioremap time.
- */
-static struct resource vsc9959_target_io_res[] = {
+/* Addresses are relative to the PCI device's base address */
+static const struct resource vsc9959_target_io_res[] = {
 	[ANA] = {
 		.start	= 0x0280000,
 		.end	= 0x028ffff,
@@ -379,7 +377,7 @@ static struct resource vsc9959_target_io_res[] = {
 	},
 };
 
-static struct resource vsc9959_port_io_res[] = {
+static const struct resource vsc9959_port_io_res[] = {
 	{
 		.start	= 0x0100000,
 		.end	= 0x010ffff,
@@ -415,7 +413,7 @@ static struct resource vsc9959_port_io_res[] = {
 /* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
  * SGMII/QSGMII MAC PCS can be found.
  */
-static struct resource vsc9959_imdio_res = {
+static const struct resource vsc9959_imdio_res = {
 	.start		= 0x8030,
 	.end		= 0x8040,
 	.name		= "imdio",
@@ -1111,7 +1109,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	struct device *dev = ocelot->dev;
 	resource_size_t imdio_base;
 	void __iomem *imdio_regs;
-	struct resource *res;
+	struct resource res;
 	struct enetc_hw *hw;
 	struct mii_bus *bus;
 	int port;
@@ -1128,12 +1126,12 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	imdio_base = pci_resource_start(felix->pdev,
 					felix->info->imdio_pci_bar);
 
-	res = felix->info->imdio_res;
-	res->flags = IORESOURCE_MEM;
-	res->start += imdio_base;
-	res->end += imdio_base;
+	memcpy(&res, felix->info->imdio_res, sizeof(res));
+	res.flags = IORESOURCE_MEM;
+	res.start += imdio_base;
+	res.end += imdio_base;
 
-	imdio_regs = devm_ioremap_resource(dev, res);
+	imdio_regs = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(imdio_regs)) {
 		dev_err(dev, "failed to map internal MDIO registers\n");
 		return PTR_ERR(imdio_regs);
-- 
2.7.4

