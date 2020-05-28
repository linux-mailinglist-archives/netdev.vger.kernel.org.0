Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825061E5ED9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 13:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388782AbgE1L4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388756AbgE1L4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB84C212CC;
        Thu, 28 May 2020 11:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666992;
        bh=RLNlhemzW4ribfLkBUD1RSYLmBY+YrB9hbsoBuZ4UJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNfJl69e34LvZV6rI6Lz2PgrfDqPRztuu9Q35SHFu6oUAR1gFEBBxV24tvLc8fjjj
         t6lK5/Iin30qCjbHubstPQQRDDLc2SPZ5zonY7Z8rtQN+emPkZj3LZLYLlbD/b6I3u
         95zZEm8JwZcvtV6UDB5R32YwlAz4OyDaj+iOEdn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 28/47] felix: Fix initialization of ioremap resources
Date:   Thu, 28 May 2020 07:55:41 -0400
Message-Id: <20200528115600.1405808-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit b4024c9e5c57902155d3b5e7de482e245f492bff ]

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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c         | 23 +++++++++++------------
 drivers/net/dsa/ocelot/felix.h         |  6 +++---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 ++++++++++------------
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a7780c06fa65..b74580e87be8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -385,6 +385,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
 	resource_size_t switch_base;
+	struct resource res;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -416,17 +417,16 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
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
@@ -447,7 +447,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (port = 0; port < num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port;
 		void __iomem *port_regs;
-		struct resource *res;
 
 		ocelot_port = devm_kzalloc(ocelot->dev,
 					   sizeof(struct ocelot_port),
@@ -459,12 +458,12 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
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
index 8771d40324f1..2c024cc901d4 100644
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
index edc1a67c002b..50074da3a1a0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -328,10 +328,8 @@ static const u32 *vsc9959_regmap[] = {
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
@@ -374,7 +372,7 @@ static struct resource vsc9959_target_io_res[] = {
 	},
 };
 
-static struct resource vsc9959_port_io_res[] = {
+static const struct resource vsc9959_port_io_res[] = {
 	{
 		.start	= 0x0100000,
 		.end	= 0x010ffff,
@@ -410,7 +408,7 @@ static struct resource vsc9959_port_io_res[] = {
 /* Port MAC 0 Internal MDIO bus through which the SerDes acting as an
  * SGMII/QSGMII MAC PCS can be found.
  */
-static struct resource vsc9959_imdio_res = {
+static const struct resource vsc9959_imdio_res = {
 	.start		= 0x8030,
 	.end		= 0x8040,
 	.name		= "imdio",
@@ -984,7 +982,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	struct device *dev = ocelot->dev;
 	resource_size_t imdio_base;
 	void __iomem *imdio_regs;
-	struct resource *res;
+	struct resource res;
 	struct enetc_hw *hw;
 	struct mii_bus *bus;
 	int port;
@@ -1001,12 +999,12 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
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
2.25.1

