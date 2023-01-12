Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE357667908
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbjALPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbjALPWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:22:53 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C165F90B;
        Thu, 12 Jan 2023 07:15:26 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id AEFE013A8;
        Thu, 12 Jan 2023 16:15:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673536524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X+EXB67jHQWbpiH7doIgNE3IzkUk0cDpvd28eCdXdHc=;
        b=v1SObeTRNLJpjdepJB7CjLj8we54Y2ol5tw/KNMZVQv/PCNAjn3qGES8Opj1EierfvQF2F
        5yXBRSR2/bR4rGjF3f64jjLhK0xiIaoJ2HGEy7J2goNbvFdIH6YX+BXYKYk/9ibd1bZMpe
        ekpCdU+EDimoTFVuAhwLDCCWUR/bzXM5qJJtcCY4dJjI+C2VBipzT70njkYRSA+msRchXp
        IUCtZqNJqkS1JPJpluCwl1g2ZA8fpPd2FY/r6FSyGGZzPIQjH6LTLVu28AexHrJxIEXHOy
        +o64u1du+Gp9RBHKJVQRomZh+G3l8tVm2sz00HHeXQUFjRQwn6uS9wCXJvuCqQ==
From:   Michael Walle <michael@walle.cc>
Date:   Thu, 12 Jan 2023 16:15:07 +0100
Subject: [PATCH net-next 01/10] net: mdio: cavium: Separate C22 and C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-net-next-c45-seperation-part-2-v1-1-5eeaae931526@walle.cc>
References: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
In-Reply-To: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The cavium IP can perform both C22 and C45 transfers.  Create separate
functions for each and register the C45 versions in both the octeon
and thunder bus driver.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/mdio/mdio-cavium.c  | 111 +++++++++++++++++++++++++++++-----------
 drivers/net/mdio/mdio-cavium.h  |   9 +++-
 drivers/net/mdio/mdio-octeon.c  |   6 ++-
 drivers/net/mdio/mdio-thunder.c |   6 ++-
 4 files changed, 95 insertions(+), 37 deletions(-)

diff --git a/drivers/net/mdio/mdio-cavium.c b/drivers/net/mdio/mdio-cavium.c
index 95ce274c1be1..fd81546a4d3d 100644
--- a/drivers/net/mdio/mdio-cavium.c
+++ b/drivers/net/mdio/mdio-cavium.c
@@ -26,7 +26,7 @@ static void cavium_mdiobus_set_mode(struct cavium_mdiobus *p,
 }
 
 static int cavium_mdiobus_c45_addr(struct cavium_mdiobus *p,
-				   int phy_id, int regnum)
+				   int phy_id, int devad, int regnum)
 {
 	union cvmx_smix_cmd smi_cmd;
 	union cvmx_smix_wr_dat smi_wr;
@@ -38,12 +38,10 @@ static int cavium_mdiobus_c45_addr(struct cavium_mdiobus *p,
 	smi_wr.s.dat = regnum & 0xffff;
 	oct_mdio_writeq(smi_wr.u64, p->register_base + SMI_WR_DAT);
 
-	regnum = (regnum >> 16) & 0x1f;
-
 	smi_cmd.u64 = 0;
 	smi_cmd.s.phy_op = 0; /* MDIO_CLAUSE_45_ADDRESS */
 	smi_cmd.s.phy_adr = phy_id;
-	smi_cmd.s.reg_adr = regnum;
+	smi_cmd.s.reg_adr = devad;
 	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
 
 	do {
@@ -59,28 +57,51 @@ static int cavium_mdiobus_c45_addr(struct cavium_mdiobus *p,
 	return 0;
 }
 
-int cavium_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum)
+int cavium_mdiobus_read_c22(struct mii_bus *bus, int phy_id, int regnum)
 {
 	struct cavium_mdiobus *p = bus->priv;
 	union cvmx_smix_cmd smi_cmd;
 	union cvmx_smix_rd_dat smi_rd;
-	unsigned int op = 1; /* MDIO_CLAUSE_22_READ */
 	int timeout = 1000;
 
-	if (regnum & MII_ADDR_C45) {
-		int r = cavium_mdiobus_c45_addr(p, phy_id, regnum);
+	cavium_mdiobus_set_mode(p, C22);
+
+	smi_cmd.u64 = 0;
+	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_22_READ */;
+	smi_cmd.s.phy_adr = phy_id;
+	smi_cmd.s.reg_adr = regnum;
+	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
+
+	do {
+		/* Wait 1000 clocks so we don't saturate the RSL bus
+		 * doing reads.
+		 */
+		__delay(1000);
+		smi_rd.u64 = oct_mdio_readq(p->register_base + SMI_RD_DAT);
+	} while (smi_rd.s.pending && --timeout);
+
+	if (smi_rd.s.val)
+		return smi_rd.s.dat;
+	else
+		return -EIO;
+}
+EXPORT_SYMBOL(cavium_mdiobus_read_c22);
 
-		if (r < 0)
-			return r;
+int cavium_mdiobus_read_c45(struct mii_bus *bus, int phy_id, int devad,
+			    int regnum)
+{
+	struct cavium_mdiobus *p = bus->priv;
+	union cvmx_smix_cmd smi_cmd;
+	union cvmx_smix_rd_dat smi_rd;
+	int timeout = 1000;
+	int r;
 
-		regnum = (regnum >> 16) & 0x1f;
-		op = 3; /* MDIO_CLAUSE_45_READ */
-	} else {
-		cavium_mdiobus_set_mode(p, C22);
-	}
+	r = cavium_mdiobus_c45_addr(p, phy_id, devad, regnum);
+	if (r < 0)
+		return r;
 
 	smi_cmd.u64 = 0;
-	smi_cmd.s.phy_op = op;
+	smi_cmd.s.phy_op = 3; /* MDIO_CLAUSE_45_READ */
 	smi_cmd.s.phy_adr = phy_id;
 	smi_cmd.s.reg_adr = regnum;
 	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
@@ -98,36 +119,64 @@ int cavium_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum)
 	else
 		return -EIO;
 }
-EXPORT_SYMBOL(cavium_mdiobus_read);
+EXPORT_SYMBOL(cavium_mdiobus_read_c45);
 
-int cavium_mdiobus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
+int cavium_mdiobus_write_c22(struct mii_bus *bus, int phy_id, int regnum,
+			     u16 val)
 {
 	struct cavium_mdiobus *p = bus->priv;
 	union cvmx_smix_cmd smi_cmd;
 	union cvmx_smix_wr_dat smi_wr;
-	unsigned int op = 0; /* MDIO_CLAUSE_22_WRITE */
 	int timeout = 1000;
 
-	if (regnum & MII_ADDR_C45) {
-		int r = cavium_mdiobus_c45_addr(p, phy_id, regnum);
+	cavium_mdiobus_set_mode(p, C22);
 
-		if (r < 0)
-			return r;
+	smi_wr.u64 = 0;
+	smi_wr.s.dat = val;
+	oct_mdio_writeq(smi_wr.u64, p->register_base + SMI_WR_DAT);
 
-		regnum = (regnum >> 16) & 0x1f;
-		op = 1; /* MDIO_CLAUSE_45_WRITE */
-	} else {
-		cavium_mdiobus_set_mode(p, C22);
-	}
+	smi_cmd.u64 = 0;
+	smi_cmd.s.phy_op = 0; /* MDIO_CLAUSE_22_WRITE */;
+	smi_cmd.s.phy_adr = phy_id;
+	smi_cmd.s.reg_adr = regnum;
+	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
+
+	do {
+		/* Wait 1000 clocks so we don't saturate the RSL bus
+		 * doing reads.
+		 */
+		__delay(1000);
+		smi_wr.u64 = oct_mdio_readq(p->register_base + SMI_WR_DAT);
+	} while (smi_wr.s.pending && --timeout);
+
+	if (timeout <= 0)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(cavium_mdiobus_write_c22);
+
+int cavium_mdiobus_write_c45(struct mii_bus *bus, int phy_id, int devad,
+			     int regnum, u16 val)
+{
+	struct cavium_mdiobus *p = bus->priv;
+	union cvmx_smix_cmd smi_cmd;
+	union cvmx_smix_wr_dat smi_wr;
+	int timeout = 1000;
+	int r;
+
+	r = cavium_mdiobus_c45_addr(p, phy_id, devad, regnum);
+	if (r < 0)
+		return r;
 
 	smi_wr.u64 = 0;
 	smi_wr.s.dat = val;
 	oct_mdio_writeq(smi_wr.u64, p->register_base + SMI_WR_DAT);
 
 	smi_cmd.u64 = 0;
-	smi_cmd.s.phy_op = op;
+	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_45_WRITE */
 	smi_cmd.s.phy_adr = phy_id;
-	smi_cmd.s.reg_adr = regnum;
+	smi_cmd.s.reg_adr = devad;
 	oct_mdio_writeq(smi_cmd.u64, p->register_base + SMI_CMD);
 
 	do {
@@ -143,7 +192,7 @@ int cavium_mdiobus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
 
 	return 0;
 }
-EXPORT_SYMBOL(cavium_mdiobus_write);
+EXPORT_SYMBOL(cavium_mdiobus_write_c45);
 
 MODULE_DESCRIPTION("Common code for OCTEON and Thunder MDIO bus drivers");
 MODULE_AUTHOR("David Daney");
diff --git a/drivers/net/mdio/mdio-cavium.h b/drivers/net/mdio/mdio-cavium.h
index a2245d436f5d..71b8e20cd664 100644
--- a/drivers/net/mdio/mdio-cavium.h
+++ b/drivers/net/mdio/mdio-cavium.h
@@ -114,5 +114,10 @@ static inline u64 oct_mdio_readq(void __iomem *addr)
 #define oct_mdio_readq(addr)		readq(addr)
 #endif
 
-int cavium_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum);
-int cavium_mdiobus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val);
+int cavium_mdiobus_read_c22(struct mii_bus *bus, int phy_id, int regnum);
+int cavium_mdiobus_write_c22(struct mii_bus *bus, int phy_id, int regnum,
+			     u16 val);
+int cavium_mdiobus_read_c45(struct mii_bus *bus, int phy_id, int devad,
+			    int regnum);
+int cavium_mdiobus_write_c45(struct mii_bus *bus, int phy_id, int devad,
+			     int regnum, u16 val);
diff --git a/drivers/net/mdio/mdio-octeon.c b/drivers/net/mdio/mdio-octeon.c
index e096e68ac667..7c65c547d377 100644
--- a/drivers/net/mdio/mdio-octeon.c
+++ b/drivers/net/mdio/mdio-octeon.c
@@ -58,8 +58,10 @@ static int octeon_mdiobus_probe(struct platform_device *pdev)
 	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%px", bus->register_base);
 	bus->mii_bus->parent = &pdev->dev;
 
-	bus->mii_bus->read = cavium_mdiobus_read;
-	bus->mii_bus->write = cavium_mdiobus_write;
+	bus->mii_bus->read = cavium_mdiobus_read_c22;
+	bus->mii_bus->write = cavium_mdiobus_write_c22;
+	bus->mii_bus->read_c45 = cavium_mdiobus_read_c45;
+	bus->mii_bus->write_c45 = cavium_mdiobus_write_c45;
 
 	platform_set_drvdata(pdev, bus);
 
diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f35..3847ee92c109 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -93,8 +93,10 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		bus->mii_bus->name = KBUILD_MODNAME;
 		snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%llx", r.start);
 		bus->mii_bus->parent = &pdev->dev;
-		bus->mii_bus->read = cavium_mdiobus_read;
-		bus->mii_bus->write = cavium_mdiobus_write;
+		bus->mii_bus->read = cavium_mdiobus_read_c22;
+		bus->mii_bus->write = cavium_mdiobus_write_c22;
+		bus->mii_bus->read_c45 = cavium_mdiobus_read_c45;
+		bus->mii_bus->write_c45 = cavium_mdiobus_write_c45;
 
 		err = of_mdiobus_register(bus->mii_bus, node);
 		if (err)

-- 
2.30.2
