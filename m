Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E1466D350
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjAPXwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbjAPXwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:49 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870A522A11;
        Mon, 16 Jan 2023 15:52:47 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 1799DD5D;
        Tue, 17 Jan 2023 00:52:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLjDb6Z8ltzyK2BgVssXp9+2hjvKuJoCm2q3gVXDY64=;
        b=XItSZsfnJuwjkmNaFwtcgj+Y7MpJYfyoWA7PaQkMzgeEmESyAyLYKWX9qam1NV2ZXuQuxt
        k1GZsNnjqa0pKwncLNhxKXnQQ8BSKBcE9/n7CLgAbsv5UV4OIVTW3DqJp1XA4iq/fNXcyY
        MVdBjdGSZDN9f1SEF3EcZYfftynKEKUNGq0/06LeEcLY6eszPLLosepdF0q3fSSI/zYzib
        VS8hplpbKetRNCUM7SZbN+WOzuwgmDwi2TwPpmZcz7EcSgCgosWxidTzYe1I4+0qJqkwCp
        OQo5dIiT6ZsvMoZHqGpAR/xWyBA7ChtO655PnnLhyNVbbn4AFIOLK0ZS1Jayow==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:17 +0100
Subject: [PATCH net-next 02/12] net: sxgbe: Separate C22 and C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-2-0c53afa56aad@walle.cc>
References: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
In-Reply-To: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Byungho An <bh74.an@samsung.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
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

The sxgdb MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c | 105 ++++++++++++++++++------
 1 file changed, 81 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
index fceb6d637235..0227223c06fa 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
@@ -50,12 +50,12 @@ static void sxgbe_mdio_ctrl_data(struct sxgbe_priv_data *sp, u32 cmd,
 }
 
 static void sxgbe_mdio_c45(struct sxgbe_priv_data *sp, u32 cmd, int phyaddr,
-			   int phyreg, u16 phydata)
+			   int devad, int phyreg, u16 phydata)
 {
 	u32 reg;
 
 	/* set mdio address register */
-	reg = ((phyreg >> 16) & 0x1f) << 21;
+	reg = (devad & 0x1f) << 21;
 	reg |= (phyaddr << 16) | (phyreg & 0xffff);
 	writel(reg, sp->ioaddr + sp->hw->mii.addr);
 
@@ -76,8 +76,8 @@ static void sxgbe_mdio_c22(struct sxgbe_priv_data *sp, u32 cmd, int phyaddr,
 	sxgbe_mdio_ctrl_data(sp, cmd, phydata);
 }
 
-static int sxgbe_mdio_access(struct sxgbe_priv_data *sp, u32 cmd, int phyaddr,
-			     int phyreg, u16 phydata)
+static int sxgbe_mdio_access_c22(struct sxgbe_priv_data *sp, u32 cmd,
+				 int phyaddr, int phyreg, u16 phydata)
 {
 	const struct mii_regs *mii = &sp->hw->mii;
 	int rc;
@@ -86,33 +86,46 @@ static int sxgbe_mdio_access(struct sxgbe_priv_data *sp, u32 cmd, int phyaddr,
 	if (rc < 0)
 		return rc;
 
-	if (phyreg & MII_ADDR_C45) {
-		sxgbe_mdio_c45(sp, cmd, phyaddr, phyreg, phydata);
-	} else {
-		 /* Ports 0-3 only support C22. */
-		if (phyaddr >= 4)
-			return -ENODEV;
+	/* Ports 0-3 only support C22. */
+	if (phyaddr >= 4)
+		return -ENODEV;
 
-		sxgbe_mdio_c22(sp, cmd, phyaddr, phyreg, phydata);
-	}
+	sxgbe_mdio_c22(sp, cmd, phyaddr, phyreg, phydata);
+
+	return sxgbe_mdio_busy_wait(sp->ioaddr, mii->data);
+}
+
+static int sxgbe_mdio_access_c45(struct sxgbe_priv_data *sp, u32 cmd,
+				 int phyaddr, int devad, int phyreg,
+				 u16 phydata)
+{
+	const struct mii_regs *mii = &sp->hw->mii;
+	int rc;
+
+	rc = sxgbe_mdio_busy_wait(sp->ioaddr, mii->data);
+	if (rc < 0)
+		return rc;
+
+	sxgbe_mdio_c45(sp, cmd, phyaddr, devad, phyreg, phydata);
 
 	return sxgbe_mdio_busy_wait(sp->ioaddr, mii->data);
 }
 
 /**
- * sxgbe_mdio_read
+ * sxgbe_mdio_read_c22
  * @bus: points to the mii_bus structure
  * @phyaddr: address of phy port
  * @phyreg: address of register with in phy register
- * Description: this function used for C45 and C22 MDIO Read
+ * Description: this function used for C22 MDIO Read
  */
-static int sxgbe_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
+static int sxgbe_mdio_read_c22(struct mii_bus *bus, int phyaddr, int phyreg)
 {
 	struct net_device *ndev = bus->priv;
 	struct sxgbe_priv_data *priv = netdev_priv(ndev);
 	int rc;
 
-	rc = sxgbe_mdio_access(priv, SXGBE_SMA_READ_CMD, phyaddr, phyreg, 0);
+	rc = sxgbe_mdio_access_c22(priv, SXGBE_SMA_READ_CMD, phyaddr,
+				   phyreg, 0);
 	if (rc < 0)
 		return rc;
 
@@ -120,21 +133,63 @@ static int sxgbe_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 }
 
 /**
- * sxgbe_mdio_write
+ * sxgbe_mdio_read_c45
+ * @bus: points to the mii_bus structure
+ * @phyaddr: address of phy port
+ * @devad: device (MMD) address
+ * @phyreg: address of register with in phy register
+ * Description: this function used for C45 MDIO Read
+ */
+static int sxgbe_mdio_read_c45(struct mii_bus *bus, int phyaddr, int devad,
+			       int phyreg)
+{
+	struct net_device *ndev = bus->priv;
+	struct sxgbe_priv_data *priv = netdev_priv(ndev);
+	int rc;
+
+	rc = sxgbe_mdio_access_c45(priv, SXGBE_SMA_READ_CMD, phyaddr,
+				   devad, phyreg, 0);
+	if (rc < 0)
+		return rc;
+
+	return readl(priv->ioaddr + priv->hw->mii.data) & 0xffff;
+}
+
+/**
+ * sxgbe_mdio_write_c22
+ * @bus: points to the mii_bus structure
+ * @phyaddr: address of phy port
+ * @phyreg: address of phy registers
+ * @phydata: data to be written into phy register
+ * Description: this function is used for C22 MDIO write
+ */
+static int sxgbe_mdio_write_c22(struct mii_bus *bus, int phyaddr, int phyreg,
+				u16 phydata)
+{
+	struct net_device *ndev = bus->priv;
+	struct sxgbe_priv_data *priv = netdev_priv(ndev);
+
+	return sxgbe_mdio_access_c22(priv, SXGBE_SMA_WRITE_CMD, phyaddr, phyreg,
+				     phydata);
+}
+
+/**
+ * sxgbe_mdio_write_c45
  * @bus: points to the mii_bus structure
  * @phyaddr: address of phy port
  * @phyreg: address of phy registers
+ * @devad: device (MMD) address
  * @phydata: data to be written into phy register
- * Description: this function is used for C45 and C22 MDIO write
+ * Description: this function is used for C45 MDIO write
  */
-static int sxgbe_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
-			     u16 phydata)
+static int sxgbe_mdio_write_c45(struct mii_bus *bus, int phyaddr, int devad,
+				int phyreg, u16 phydata)
 {
 	struct net_device *ndev = bus->priv;
 	struct sxgbe_priv_data *priv = netdev_priv(ndev);
 
-	return sxgbe_mdio_access(priv, SXGBE_SMA_WRITE_CMD, phyaddr, phyreg,
-				 phydata);
+	return sxgbe_mdio_access_c45(priv, SXGBE_SMA_WRITE_CMD, phyaddr,
+				     devad, phyreg, phydata);
 }
 
 int sxgbe_mdio_register(struct net_device *ndev)
@@ -161,8 +216,10 @@ int sxgbe_mdio_register(struct net_device *ndev)
 
 	/* assign mii bus fields */
 	mdio_bus->name = "sxgbe";
-	mdio_bus->read = &sxgbe_mdio_read;
-	mdio_bus->write = &sxgbe_mdio_write;
+	mdio_bus->read = sxgbe_mdio_read_c22;
+	mdio_bus->write = sxgbe_mdio_write_c22;
+	mdio_bus->read_c45 = sxgbe_mdio_read_c45;
+	mdio_bus->write_c45 = sxgbe_mdio_write_c45;
 	snprintf(mdio_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 mdio_bus->name, priv->plat->bus_id);
 	mdio_bus->priv = ndev;

-- 
2.30.2
