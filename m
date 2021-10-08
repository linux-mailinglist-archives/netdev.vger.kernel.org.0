Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6461426FD2
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbhJHSBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238780AbhJHSBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DA3E61039;
        Fri,  8 Oct 2021 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715958;
        bh=36qhFY9yzkCVcN625hLBktsfUut1KvhMP5Dwx60mFR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWZ+98PLQvFfgM0BxNWjxN4JmftcAdywlTynPtBEsX7NWfFc8B2nK22hOept5nSPu
         3sqhEEcOglHd5VOzUIh5AtBqHeMUAje72ITGn09cLI8/er6WSSlqsQkk5gSQhM74JD
         gbIoA+Of3N74PhSOZA3T49wxKeQ3wjRG06U5LrKW85KtDNwMao/b/bVJm5HMpAVr2b
         8z2e55VzS93AeLimNyJE78oPJJVcxAAU1hngBtb/x2Yu3p1UG9+/w3/39xmNd+lQTA
         cRpuJHi+YeLzrfQcEhKFo6vWkXtH6LgDfarnhUZP8QHO9Uhpd67Z5BFnuVpV6grafq
         eOV/rf8t/xTTg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/5] ethernet: tulip: remove direct netdev->dev_addr writes
Date:   Fri,  8 Oct 2021 10:59:11 -0700
Message-Id: <20211008175913.3754184-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008175913.3754184-1-kuba@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consify the casts of netdev->dev_addr.

Convert pointless to eth_hw_addr_set() where possible.

Use local buffers in a number of places.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c    | 15 +++++----
 drivers/net/ethernet/dec/tulip/de4x5.c      | 35 ++++++++++---------
 drivers/net/ethernet/dec/tulip/dmfe.c       |  9 +++--
 drivers/net/ethernet/dec/tulip/tulip_core.c | 37 ++++++++++++---------
 drivers/net/ethernet/dec/tulip/uli526x.c    | 11 +++---
 drivers/net/ethernet/dec/tulip/xircom_cb.c  |  4 ++-
 6 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 117c26fa5909..1e3c90c3c0ed 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -666,8 +666,8 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 	struct de_private *de = netdev_priv(dev);
 	u16 hash_table[32];
 	struct netdev_hw_addr *ha;
+	const u16 *eaddrs;
 	int i;
-	u16 *eaddrs;
 
 	memset(hash_table, 0, sizeof(hash_table));
 	__set_bit_le(255, hash_table);			/* Broadcast entry */
@@ -685,7 +685,7 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 	setup_frm = &de->setup_frame[13*6];
 
 	/* Fill the final entry with our physical address. */
-	eaddrs = (u16 *)dev->dev_addr;
+	eaddrs = (const u16 *)dev->dev_addr;
 	*setup_frm++ = eaddrs[0]; *setup_frm++ = eaddrs[0];
 	*setup_frm++ = eaddrs[1]; *setup_frm++ = eaddrs[1];
 	*setup_frm++ = eaddrs[2]; *setup_frm++ = eaddrs[2];
@@ -695,7 +695,7 @@ static void build_setup_frame_perfect(u16 *setup_frm, struct net_device *dev)
 {
 	struct de_private *de = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
-	u16 *eaddrs;
+	const u16 *eaddrs;
 
 	/* We have <= 14 addresses so we can use the wonderful
 	   16 address perfect filtering of the Tulip. */
@@ -710,7 +710,7 @@ static void build_setup_frame_perfect(u16 *setup_frm, struct net_device *dev)
 	setup_frm = &de->setup_frame[15*6];
 
 	/* Fill the final entry with our physical address. */
-	eaddrs = (u16 *)dev->dev_addr;
+	eaddrs = (const u16 *)dev->dev_addr;
 	*setup_frm++ = eaddrs[0]; *setup_frm++ = eaddrs[0];
 	*setup_frm++ = eaddrs[1]; *setup_frm++ = eaddrs[1];
 	*setup_frm++ = eaddrs[2]; *setup_frm++ = eaddrs[2];
@@ -1713,6 +1713,7 @@ static const struct ethtool_ops de_ethtool_ops = {
 
 static void de21040_get_mac_address(struct de_private *de)
 {
+	u8 addr[ETH_ALEN];
 	unsigned i;
 
 	dw32 (ROMCmd, 0);	/* Reset the pointer with a dummy write. */
@@ -1724,12 +1725,13 @@ static void de21040_get_mac_address(struct de_private *de)
 			value = dr32(ROMCmd);
 			rmb();
 		} while (value < 0 && --boguscnt > 0);
-		de->dev->dev_addr[i] = value;
+		addr[i] = value;
 		udelay(1);
 		if (boguscnt <= 0)
 			pr_warn("timeout reading 21040 MAC address byte %u\n",
 				i);
 	}
+	eth_hw_addr_set(de->dev, addr);
 }
 
 static void de21040_get_media_info(struct de_private *de)
@@ -1821,8 +1823,7 @@ static void de21041_get_srom_info(struct de_private *de)
 #endif
 
 	/* store MAC address */
-	for (i = 0; i < 6; i ++)
-		de->dev->dev_addr[i] = ee_data[i + sa_offset];
+	eth_hw_addr_set(de->dev, &ee_data[i + sa_offset]);
 
 	/* get offset of controller 0 info leaf.  ignore 2nd byte. */
 	ofs = ee_data[SROMC0InfoLeaf];
diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 36ab4cbf2ad0..13121c4dcfe6 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -4031,6 +4031,7 @@ get_hw_addr(struct net_device *dev)
     int broken, i, k, tmp, status = 0;
     u_short j,chksum;
     struct de4x5_private *lp = netdev_priv(dev);
+    u8 addr[ETH_ALEN];
 
     broken = de4x5_bad_srom(lp);
 
@@ -4042,28 +4043,30 @@ get_hw_addr(struct net_device *dev)
 	    if (lp->chipset == DC21040) {
 		while ((tmp = inl(DE4X5_APROM)) < 0);
 		k += (u_char) tmp;
-		dev->dev_addr[i++] = (u_char) tmp;
+		addr[i++] = (u_char) tmp;
 		while ((tmp = inl(DE4X5_APROM)) < 0);
 		k += (u_short) (tmp << 8);
-		dev->dev_addr[i++] = (u_char) tmp;
+		addr[i++] = (u_char) tmp;
 	    } else if (!broken) {
-		dev->dev_addr[i] = (u_char) lp->srom.ieee_addr[i]; i++;
-		dev->dev_addr[i] = (u_char) lp->srom.ieee_addr[i]; i++;
+		addr[i] = (u_char) lp->srom.ieee_addr[i]; i++;
+		addr[i] = (u_char) lp->srom.ieee_addr[i]; i++;
 	    } else if ((broken == SMC) || (broken == ACCTON)) {
-		dev->dev_addr[i] = *((u_char *)&lp->srom + i); i++;
-		dev->dev_addr[i] = *((u_char *)&lp->srom + i); i++;
+		addr[i] = *((u_char *)&lp->srom + i); i++;
+		addr[i] = *((u_char *)&lp->srom + i); i++;
 	    }
 	} else {
 	    k += (u_char) (tmp = inb(EISA_APROM));
-	    dev->dev_addr[i++] = (u_char) tmp;
+	    addr[i++] = (u_char) tmp;
 	    k += (u_short) ((tmp = inb(EISA_APROM)) << 8);
-	    dev->dev_addr[i++] = (u_char) tmp;
+	    addr[i++] = (u_char) tmp;
 	}
 
 	if (k > 0xffff) k-=0xffff;
     }
     if (k == 0xffff) k=0;
 
+    eth_hw_addr_set(dev, addr);
+
     if (lp->bus == PCI) {
 	if (lp->chipset == DC21040) {
 	    while ((tmp = inl(DE4X5_APROM)) < 0);
@@ -4095,8 +4098,9 @@ get_hw_addr(struct net_device *dev)
 		    int x = dev->dev_addr[i];
 		    x = ((x & 0xf) << 4) + ((x & 0xf0) >> 4);
 		    x = ((x & 0x33) << 2) + ((x & 0xcc) >> 2);
-		    dev->dev_addr[i] = ((x & 0x55) << 1) + ((x & 0xaa) >> 1);
+		    addr[i] = ((x & 0x55) << 1) + ((x & 0xaa) >> 1);
 	    }
+	    eth_hw_addr_set(dev, addr);
     }
 #endif /* CONFIG_PPC_PMAC */
 
@@ -4158,12 +4162,9 @@ test_bad_enet(struct net_device *dev, int status)
     if ((tmp == 0) || (tmp == 0x5fa)) {
 	if ((lp->chipset == last.chipset) &&
 	    (lp->bus_num == last.bus) && (lp->bus_num > 0)) {
-	    for (i=0; i<ETH_ALEN; i++) dev->dev_addr[i] = last.addr[i];
-	    for (i=ETH_ALEN-1; i>2; --i) {
-		dev->dev_addr[i] += 1;
-		if (dev->dev_addr[i] != 0) break;
-	    }
-	    for (i=0; i<ETH_ALEN; i++) last.addr[i] = dev->dev_addr[i];
+	    eth_addr_inc(last.addr);
+	    eth_hw_addr_set(dev, last.addr);
+
 	    if (!an_exception(lp)) {
 		dev->irq = last.irq;
 	    }
@@ -5391,9 +5392,7 @@ de4x5_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data
 	if (netif_queue_stopped(dev))
 		return -EBUSY;
 	netif_stop_queue(dev);
-	for (i=0; i<ETH_ALEN; i++) {
-	    dev->dev_addr[i] = tmp.addr[i];
-	}
+	eth_hw_addr_set(dev, tmp.addr);
 	build_setup_frame(dev, PHYS_ADDR_ONLY);
 	/* Set up the descriptor and give ownership to the card */
 	load_packet(dev, lp->setup_frame, TD_IC | PERFECT_F | TD_SET |
diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index c763b692e164..6e64ff20a378 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -476,8 +476,7 @@ static int dmfe_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Set Node address */
-	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = db->srom[20 + i];
+	eth_hw_addr_set(dev, &db->srom[20 + i]);
 
 	err = register_netdev (dev);
 	if (err)
@@ -1436,9 +1435,9 @@ static void update_cr6(u32 cr6_data, void __iomem *ioaddr)
 
 static void dm9132_id_table(struct net_device *dev)
 {
+	const u16 *addrptr = (const u16 *)dev->dev_addr;
 	struct dmfe_board_info *db = netdev_priv(dev);
 	void __iomem *ioaddr = db->ioaddr + 0xc0;
-	u16 *addrptr = (u16 *)dev->dev_addr;
 	struct netdev_hw_addr *ha;
 	u16 i, hash_table[4];
 
@@ -1477,7 +1476,7 @@ static void send_filter_frame(struct net_device *dev)
 	struct dmfe_board_info *db = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
 	struct tx_desc *txptr;
-	u16 * addrptr;
+	const u16 * addrptr;
 	u32 * suptr;
 	int i;
 
@@ -1487,7 +1486,7 @@ static void send_filter_frame(struct net_device *dev)
 	suptr = (u32 *) txptr->tx_buf_ptr;
 
 	/* Node address */
-	addrptr = (u16 *) dev->dev_addr;
+	addrptr = (const u16 *) dev->dev_addr;
 	*suptr++ = addrptr[0];
 	*suptr++ = addrptr[1];
 	*suptr++ = addrptr[2];
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 1ba6452c0683..ec0ce8f1beea 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -339,7 +339,7 @@ static void tulip_up(struct net_device *dev)
 		}
 	} else {
 		/* This is set_rx_mode(), but without starting the transmitter. */
-		u16 *eaddrs = (u16 *)dev->dev_addr;
+		const u16 *eaddrs = (const u16 *)dev->dev_addr;
 		u16 *setup_frm = &tp->setup_frame[15*6];
 		dma_addr_t mapping;
 
@@ -1001,8 +1001,8 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 	struct tulip_private *tp = netdev_priv(dev);
 	u16 hash_table[32];
 	struct netdev_hw_addr *ha;
+	const u16 *eaddrs;
 	int i;
-	u16 *eaddrs;
 
 	memset(hash_table, 0, sizeof(hash_table));
 	__set_bit_le(255, hash_table);			/* Broadcast entry */
@@ -1019,7 +1019,7 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 	setup_frm = &tp->setup_frame[13*6];
 
 	/* Fill the final entry with our physical address. */
-	eaddrs = (u16 *)dev->dev_addr;
+	eaddrs = (const u16 *)dev->dev_addr;
 	*setup_frm++ = eaddrs[0]; *setup_frm++ = eaddrs[0];
 	*setup_frm++ = eaddrs[1]; *setup_frm++ = eaddrs[1];
 	*setup_frm++ = eaddrs[2]; *setup_frm++ = eaddrs[2];
@@ -1029,7 +1029,7 @@ static void build_setup_frame_perfect(u16 *setup_frm, struct net_device *dev)
 {
 	struct tulip_private *tp = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
-	u16 *eaddrs;
+	const u16 *eaddrs;
 
 	/* We have <= 14 addresses so we can use the wonderful
 	   16 address perfect filtering of the Tulip. */
@@ -1044,7 +1044,7 @@ static void build_setup_frame_perfect(u16 *setup_frm, struct net_device *dev)
 	setup_frm = &tp->setup_frame[15*6];
 
 	/* Fill the final entry with our physical address. */
-	eaddrs = (u16 *)dev->dev_addr;
+	eaddrs = (const u16 *)dev->dev_addr;
 	*setup_frm++ = eaddrs[0]; *setup_frm++ = eaddrs[0];
 	*setup_frm++ = eaddrs[1]; *setup_frm++ = eaddrs[1];
 	*setup_frm++ = eaddrs[2]; *setup_frm++ = eaddrs[2];
@@ -1305,6 +1305,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chip_idx = ent->driver_data;
 	const char *chip_name = tulip_tbl[chip_idx].chip_name;
 	unsigned int eeprom_missing = 0;
+	u8 addr[ETH_ALEN] __aligned(2);
 	unsigned int force_csr0 = 0;
 
 	board_idx++;
@@ -1506,13 +1507,15 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			do {
 				value = ioread32(ioaddr + CSR9);
 			} while (value < 0  && --boguscnt > 0);
-			put_unaligned_le16(value, ((__le16 *)dev->dev_addr) + i);
+			put_unaligned_le16(value, ((__le16 *)addr) + i);
 			sum += value & 0xffff;
 		}
+		eth_hw_addr_set(dev, addr);
 	} else if (chip_idx == COMET) {
 		/* No need to read the EEPROM. */
-		put_unaligned_le32(ioread32(ioaddr + 0xA4), dev->dev_addr);
-		put_unaligned_le16(ioread32(ioaddr + 0xA8), dev->dev_addr + 4);
+		put_unaligned_le32(ioread32(ioaddr + 0xA4), addr);
+		put_unaligned_le16(ioread32(ioaddr + 0xA8), addr + 4);
+		eth_hw_addr_set(dev, addr);
 		for (i = 0; i < 6; i ++)
 			sum += dev->dev_addr[i];
 	} else {
@@ -1575,20 +1578,23 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 		for (i = 0; i < 6; i ++) {
-			dev->dev_addr[i] = ee_data[i + sa_offset];
+			addr[i] = ee_data[i + sa_offset];
 			sum += ee_data[i + sa_offset];
 		}
+		eth_hw_addr_set(dev, addr);
 	}
 	/* Lite-On boards have the address byte-swapped. */
 	if ((dev->dev_addr[0] == 0xA0 ||
 	     dev->dev_addr[0] == 0xC0 ||
 	     dev->dev_addr[0] == 0x02) &&
-	    dev->dev_addr[1] == 0x00)
+	    dev->dev_addr[1] == 0x00) {
 		for (i = 0; i < 6; i+=2) {
-			char tmp = dev->dev_addr[i];
-			dev->dev_addr[i] = dev->dev_addr[i+1];
-			dev->dev_addr[i+1] = tmp;
+			addr[i] = dev->dev_addr[i+1];
+			addr[i+1] = dev->dev_addr[i];
 		}
+		eth_hw_addr_set(dev, addr);
+	}
+
 	/* On the Zynx 315 Etherarray and other multiport boards only the
 	   first Tulip has an EEPROM.
 	   On Sparc systems the mac address is held in the OBP property
@@ -1604,8 +1610,9 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 		eeprom_missing = 1;
 		for (i = 0; i < 5; i++)
-			dev->dev_addr[i] = last_phys_addr[i];
-		dev->dev_addr[i] = last_phys_addr[i] + 1;
+			addr[i] = last_phys_addr[i];
+		addr[i] = last_phys_addr[i] + 1;
+		eth_hw_addr_set(dev, addr);
 #if defined(CONFIG_SPARC)
 		addr = of_get_property(dp, "local-mac-address", &len);
 		if (addr && len == ETH_ALEN)
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index d67ef7d02d6b..77d9058431e3 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -272,6 +272,7 @@ static int uli526x_init_one(struct pci_dev *pdev,
 	struct uli526x_board_info *db;	/* board information structure */
 	struct net_device *dev;
 	void __iomem *ioaddr;
+	u8 addr[ETH_ALEN];
 	int i, err;
 
 	ULI526X_DBUG(0, "uli526x_init_one()", 0);
@@ -379,7 +380,7 @@ static int uli526x_init_one(struct pci_dev *pdev,
 		uw32(DCR13, 0x1b0);	//Select ID Table access port
 		//Read MAC address from CR14
 		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = ur32(DCR14);
+			addr[i] = ur32(DCR14);
 		//Read end
 		uw32(DCR13, 0);		//Clear CR13
 		uw32(DCR0, 0);		//Clear CR0
@@ -388,8 +389,10 @@ static int uli526x_init_one(struct pci_dev *pdev,
 	else		/*Exist SROM*/
 	{
 		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = db->srom[20 + i];
+			addr[i] = db->srom[20 + i];
 	}
+	eth_hw_addr_set(dev, addr);
+
 	err = register_netdev (dev);
 	if (err)
 		goto err_out_unmap;
@@ -1343,7 +1346,7 @@ static void send_filter_frame(struct net_device *dev, int mc_cnt)
 	void __iomem *ioaddr = db->ioaddr;
 	struct netdev_hw_addr *ha;
 	struct tx_desc *txptr;
-	u16 * addrptr;
+	const u16 * addrptr;
 	u32 * suptr;
 	int i;
 
@@ -1353,7 +1356,7 @@ static void send_filter_frame(struct net_device *dev, int mc_cnt)
 	suptr = (u32 *) txptr->tx_buf_ptr;
 
 	/* Node address */
-	addrptr = (u16 *) dev->dev_addr;
+	addrptr = (const u16 *) dev->dev_addr;
 	*suptr++ = addrptr[0] << FLT_SHIFT;
 	*suptr++ = addrptr[1] << FLT_SHIFT;
 	*suptr++ = addrptr[2] << FLT_SHIFT;
diff --git a/drivers/net/ethernet/dec/tulip/xircom_cb.c b/drivers/net/ethernet/dec/tulip/xircom_cb.c
index a8de79355578..8759f9f76b62 100644
--- a/drivers/net/ethernet/dec/tulip/xircom_cb.c
+++ b/drivers/net/ethernet/dec/tulip/xircom_cb.c
@@ -1015,12 +1015,14 @@ static void read_mac_address(struct xircom_private *card)
 		xw32(CSR10, i + 3);
 		data_count = xr32(CSR9);
 		if ((tuple == 0x22) && (data_id == 0x04) && (data_count == 0x06)) {
+			u8 addr[ETH_ALEN];
 			int j;
 
 			for (j = 0; j < 6; j++) {
 				xw32(CSR10, i + j + 4);
-				card->dev->dev_addr[j] = xr32(CSR9) & 0xff;
+				addr[j] = xr32(CSR9) & 0xff;
 			}
+			eth_hw_addr_set(card->dev, addr);
 			break;
 		} else if (link == 0) {
 			break;
-- 
2.31.1

