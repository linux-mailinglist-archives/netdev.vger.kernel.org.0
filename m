Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594A342CB4D
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhJMUrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhJMUqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D5D4610FE;
        Wed, 13 Oct 2021 20:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157887;
        bh=+IduxJOzFaTmMeTGzfb/DE32ruYuyih3R4qGTMO/QQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTSKulELtFdi8qYM4BZjVNWGkVCFFz9CgTcZgv9Gz0YM59uo7TkwX4QeYEnDlupFh
         T53wx83CjBxwSouDjBupmymr9yJlnZKCrWYQ/5X8G+zCPTasW+yox+sSYKN193VrJC
         xhyYzTuSnv0tMyjDu/km2kAOAzYL01trSGLYNGcpWGBwMpeZeTRZIONrytEb4zh4jQ
         G3JTTLoeXUC1skVNUZjaUIRlGihXhrmKMKVJz3djsL0nBUl+5obYfE7kgYNze4J0ne
         OApgZTGbBJeOxZSkPlwVLTLr7xDMpVXkNh1fcxqBZSxk7TjAHQs0YXOW4JfKDJfE7b
         8VnZibBk8Pm/w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        klassert@kernel.org, kda@linux-powerpc.org,
        GR-Linux-NIC-Dev@marvell.com, f.fainelli@gmail.com,
        romieu@fr.zoreil.com, venza@brownhat.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH net-next 7/7] ethernet: replace netdev->dev_addr 16bit writes
Date:   Wed, 13 Oct 2021 13:44:35 -0700
Message-Id: <20211013204435.322561-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

This patch takes care of drivers which cast netdev->dev_addr to
a 16bit type, often with an explicit byte order.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: klassert@kernel.org
CC: kda@linux-powerpc.org
CC: GR-Linux-NIC-Dev@marvell.com
CC: f.fainelli@gmail.com
CC: romieu@fr.zoreil.com
CC: venza@brownhat.org
CC: linux-parisc@vger.kernel.org
---
 drivers/net/ethernet/3com/3c515.c            |  5 +++--
 drivers/net/ethernet/3com/3c574_cs.c         | 11 +++++------
 drivers/net/ethernet/3com/3c589_cs.c         | 10 +++++-----
 drivers/net/ethernet/3com/3c59x.c            |  4 +++-
 drivers/net/ethernet/dec/tulip/winbond-840.c |  4 +++-
 drivers/net/ethernet/dlink/sundance.c        |  4 +++-
 drivers/net/ethernet/qlogic/qla3xxx.c        | 10 ++++++----
 drivers/net/ethernet/rdc/r6040.c             | 12 ++++++------
 drivers/net/ethernet/realtek/8139cp.c        |  5 +++--
 drivers/net/ethernet/realtek/8139too.c       |  5 +++--
 drivers/net/ethernet/realtek/atp.c           |  4 +++-
 drivers/net/ethernet/sis/sis190.c            |  4 +++-
 drivers/net/ethernet/sis/sis900.c            | 13 +++++++++----
 drivers/net/ethernet/smsc/epic100.c          |  4 +++-
 14 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 6f0ea2facea9..1d124b0f65e7 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -567,6 +567,7 @@ static int corkscrew_setup(struct net_device *dev, int ioaddr,
 {
 	struct corkscrew_private *vp = netdev_priv(dev);
 	unsigned int eeprom[0x40], checksum = 0;	/* EEPROM contents */
+	__be16 addr[ETH_ALEN / 2];
 	int i;
 	int irq;
 
@@ -619,7 +620,6 @@ static int corkscrew_setup(struct net_device *dev, int ioaddr,
 	/* Read the station address from the EEPROM. */
 	EL3WINDOW(0);
 	for (i = 0; i < 0x18; i++) {
-		__be16 *phys_addr = (__be16 *) dev->dev_addr;
 		int timer;
 		outw(EEPROM_Read + i, ioaddr + Wn0EepromCmd);
 		/* Pause for at least 162 us. for the read to take place. */
@@ -631,8 +631,9 @@ static int corkscrew_setup(struct net_device *dev, int ioaddr,
 		eeprom[i] = inw(ioaddr + Wn0EepromData);
 		checksum ^= eeprom[i];
 		if (i < 3)
-			phys_addr[i] = htons(eeprom[i]);
+			addr[i] = htons(eeprom[i]);
 	}
+	eth_hw_addr_set(dev, (u8 *)addr);
 	checksum = (checksum ^ (checksum >> 8)) & 0xff;
 	if (checksum != 0x00)
 		pr_cont(" ***INVALID CHECKSUM %4.4x*** ", checksum);
diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3com/3c574_cs.c
index dd4d3c48b98d..dc3b7c960611 100644
--- a/drivers/net/ethernet/3com/3c574_cs.c
+++ b/drivers/net/ethernet/3com/3c574_cs.c
@@ -305,15 +305,13 @@ static int tc574_config(struct pcmcia_device *link)
 	struct net_device *dev = link->priv;
 	struct el3_private *lp = netdev_priv(dev);
 	int ret, i, j;
+	__be16 addr[ETH_ALEN / 2];
 	unsigned int ioaddr;
-	__be16 *phys_addr;
 	char *cardname;
 	__u32 config;
 	u8 *buf;
 	size_t len;
 
-	phys_addr = (__be16 *)dev->dev_addr;
-
 	dev_dbg(&link->dev, "3c574_config()\n");
 
 	link->io_lines = 16;
@@ -347,19 +345,20 @@ static int tc574_config(struct pcmcia_device *link)
 	len = pcmcia_get_tuple(link, 0x88, &buf);
 	if (buf && len >= 6) {
 		for (i = 0; i < 3; i++)
-			phys_addr[i] = htons(le16_to_cpu(buf[i * 2]));
+			addr[i] = htons(le16_to_cpu(buf[i * 2]));
 		kfree(buf);
 	} else {
 		kfree(buf); /* 0 < len < 6 */
 		EL3WINDOW(0);
 		for (i = 0; i < 3; i++)
-			phys_addr[i] = htons(read_eeprom(ioaddr, i + 10));
-		if (phys_addr[0] == htons(0x6060)) {
+			addr[i] = htons(read_eeprom(ioaddr, i + 10));
+		if (addr[0] == htons(0x6060)) {
 			pr_notice("IO port conflict at 0x%03lx-0x%03lx\n",
 				  dev->base_addr, dev->base_addr+15);
 			goto failed;
 		}
 	}
+	eth_hw_addr_set(dev, (u8 *)addr);
 	if (link->prod_id[1])
 		cardname = link->prod_id[1];
 	else
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index 09816e84314d..4673bc1604e7 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -237,8 +237,8 @@ static void tc589_detach(struct pcmcia_device *link)
 static int tc589_config(struct pcmcia_device *link)
 {
 	struct net_device *dev = link->priv;
-	__be16 *phys_addr;
 	int ret, i, j, multi = 0, fifo;
+	__be16 addr[ETH_ALEN / 2];
 	unsigned int ioaddr;
 	static const char * const ram_split[] = {"5:3", "3:1", "1:1", "3:5"};
 	u8 *buf;
@@ -246,7 +246,6 @@ static int tc589_config(struct pcmcia_device *link)
 
 	dev_dbg(&link->dev, "3c589_config\n");
 
-	phys_addr = (__be16 *)dev->dev_addr;
 	/* Is this a 3c562? */
 	if (link->manf_id != MANFID_3COM)
 		dev_info(&link->dev, "hmmm, is this really a 3Com card??\n");
@@ -285,18 +284,19 @@ static int tc589_config(struct pcmcia_device *link)
 	len = pcmcia_get_tuple(link, 0x88, &buf);
 	if (buf && len >= 6) {
 		for (i = 0; i < 3; i++)
-			phys_addr[i] = htons(le16_to_cpu(buf[i*2]));
+			addr[i] = htons(le16_to_cpu(buf[i*2]));
 		kfree(buf);
 	} else {
 		kfree(buf); /* 0 < len < 6 */
 		for (i = 0; i < 3; i++)
-			phys_addr[i] = htons(read_eeprom(ioaddr, i));
-		if (phys_addr[0] == htons(0x6060)) {
+			addr[i] = htons(read_eeprom(ioaddr, i));
+		if (addr[0] == htons(0x6060)) {
 			dev_err(&link->dev, "IO port conflict at 0x%03lx-0x%03lx\n",
 					dev->base_addr, dev->base_addr+15);
 			goto failed;
 		}
 	}
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	/* The address and resource configuration register aren't loaded from
 	 * the EEPROM and *must* be set to 0 and IRQ3 for the PCMCIA version.
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 7b0ae9efc004..ccf07667aa5e 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1091,6 +1091,7 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 	struct vortex_private *vp;
 	int option;
 	unsigned int eeprom[0x40], checksum = 0;		/* EEPROM contents */
+	__be16 addr[ETH_ALEN / 2];
 	int i, step;
 	struct net_device *dev;
 	static int printed_version;
@@ -1284,7 +1285,8 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 	if ((checksum != 0x00) && !(vci->drv_flags & IS_TORNADO))
 		pr_cont(" ***INVALID CHECKSUM %4.4x*** ", checksum);
 	for (i = 0; i < 3; i++)
-		((__be16 *)dev->dev_addr)[i] = htons(eeprom[i + 10]);
+		addr[i] = htons(eeprom[i + 10]);
+	eth_hw_addr_set(dev, (u8 *)addr);
 	if (print_info)
 		pr_cont(" %pM", dev->dev_addr);
 	/* Unfortunately an all zero eeprom passes the checksum and this
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 85b99099c6b9..c4217ca5d709 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -355,6 +355,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chip_idx = ent->driver_data;
 	int irq;
 	int i, option = find_cnt < MAX_UNITS ? options[find_cnt] : 0;
+	__le16 addr[ETH_ALEN / 2];
 	void __iomem *ioaddr;
 
 	i = pcim_enable_device(pdev);
@@ -382,7 +383,8 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_netdev;
 
 	for (i = 0; i < 3; i++)
-		((__le16 *)dev->dev_addr)[i] = cpu_to_le16(eeprom_read(ioaddr, i));
+		addr[i] = cpu_to_le16(eeprom_read(ioaddr, i));
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	/* Reset the chip to erase previous misconfiguration.
 	   No hold time required! */
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index 194b0812f7f6..c710dc17be90 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -508,6 +508,7 @@ static int sundance_probe1(struct pci_dev *pdev,
 	int bar = 1;
 #endif
 	int phy, phy_end, phy_idx = 0;
+	__le16 addr[ETH_ALEN / 2];
 
 	if (pci_enable_device(pdev))
 		return -EIO;
@@ -528,8 +529,9 @@ static int sundance_probe1(struct pci_dev *pdev,
 		goto err_out_res;
 
 	for (i = 0; i < 3; i++)
-		((__le16 *)dev->dev_addr)[i] =
+		addr[i] =
 			cpu_to_le16(eeprom_read(ioaddr, i + EEPROM_SA_OFFSET));
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	np = netdev_priv(dev);
 	np->ndev = dev;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 395f054e9e0c..1e6d72adfe43 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -508,10 +508,12 @@ static void eeprom_readword(struct ql3_adapter *qdev,
 
 static void ql_set_mac_addr(struct net_device *ndev, u16 *addr)
 {
-	__le16 *p = (__le16 *)ndev->dev_addr;
-	p[0] = cpu_to_le16(addr[0]);
-	p[1] = cpu_to_le16(addr[1]);
-	p[2] = cpu_to_le16(addr[2]);
+	__le16 buf[ETH_ALEN / 2];
+
+	buf[0] = cpu_to_le16(addr[0]);
+	buf[1] = cpu_to_le16(addr[1]);
+	buf[2] = cpu_to_le16(addr[2]);
+	eth_hw_addr_set(ndev, (u8 *)buf);
 }
 
 static int ql_get_nvram_params(struct ql3_adapter *qdev)
diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index a8f282c43a78..a6bf7d505178 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1031,8 +1031,8 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	void __iomem *ioaddr;
 	int err, io_size = R6040_IO_SIZE;
 	static int card_idx = -1;
+	u16 addr[ETH_ALEN / 2];
 	int bar = 0;
-	u16 *adrp;
 
 	pr_info("%s\n", version);
 
@@ -1102,14 +1102,14 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Set MAC address */
 	card_idx++;
 
-	adrp = (u16 *)dev->dev_addr;
-	adrp[0] = ioread16(ioaddr + MID_0L);
-	adrp[1] = ioread16(ioaddr + MID_0M);
-	adrp[2] = ioread16(ioaddr + MID_0H);
+	addr[0] = ioread16(ioaddr + MID_0L);
+	addr[1] = ioread16(ioaddr + MID_0M);
+	addr[2] = ioread16(ioaddr + MID_0H);
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	/* Some bootloader/BIOSes do not initialize
 	 * MAC address, warn about that */
-	if (!(adrp[0] || adrp[1] || adrp[2])) {
+	if (!(addr[0] || addr[1] || addr[2])) {
 		netdev_warn(dev, "MAC address not initialized, "
 					"generating random\n");
 		eth_hw_addr_random(dev);
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 614aac780b6b..4f39f843bb3a 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1889,6 +1889,7 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	void __iomem *regs;
 	resource_size_t pciaddr;
 	unsigned int addr_len, i, pci_using_dac;
+	__le16 addr[ETH_ALEN / 2];
 
 	pr_info_once("%s", version);
 
@@ -1979,8 +1980,8 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* read MAC address from EEPROM */
 	addr_len = read_eeprom (regs, 0, 8) == 0x8129 ? 8 : 6;
 	for (i = 0; i < 3; i++)
-		((__le16 *) (dev->dev_addr))[i] =
-		    cpu_to_le16(read_eeprom (regs, i + 7, addr_len));
+		addr[i] = cpu_to_le16(read_eeprom (regs, i + 7, addr_len));
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	dev->netdev_ops = &cp_netdev_ops;
 	netif_napi_add(dev, &cp->napi, cp_rx_poll, 16);
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 75b5ac91132b..15b40fd93cd2 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -945,6 +945,7 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 {
 	struct net_device *dev = NULL;
 	struct rtl8139_private *tp;
+	__le16 addr[ETH_ALEN / 2];
 	int i, addr_len, option;
 	void __iomem *ioaddr;
 	static int board_idx = -1;
@@ -994,8 +995,8 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 
 	addr_len = read_eeprom (ioaddr, 0, 8) == 0x8129 ? 8 : 6;
 	for (i = 0; i < 3; i++)
-		((__le16 *) (dev->dev_addr))[i] =
-		    cpu_to_le16(read_eeprom (ioaddr, i + 7, addr_len));
+		addr[i] = cpu_to_le16(read_eeprom (ioaddr, i + 7, addr_len));
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	/* The Rtl8139-specific entries in the device structure. */
 	dev->netdev_ops = &rtl8139_netdev_ops;
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index b6c849b258a0..6cbcb3164367 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -368,6 +368,7 @@ static int __init atp_probe1(long ioaddr)
 static void __init get_node_ID(struct net_device *dev)
 {
 	long ioaddr = dev->base_addr;
+	__be16 addr[ETH_ALEN / 2];
 	int sa_offset = 0;
 	int i;
 
@@ -379,8 +380,9 @@ static void __init get_node_ID(struct net_device *dev)
 		sa_offset = 15;
 
 	for (i = 0; i < 3; i++)
-		((__be16 *)dev->dev_addr)[i] =
+		addr[i] =
 			cpu_to_be16(eeprom_op(ioaddr, EE_READ(sa_offset + i)));
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	write_reg(ioaddr, CMR2, CMR2_NULL);
 }
diff --git a/drivers/net/ethernet/sis/sis190.c b/drivers/net/ethernet/sis/sis190.c
index be4d772e68cf..5e66e3f3aafc 100644
--- a/drivers/net/ethernet/sis/sis190.c
+++ b/drivers/net/ethernet/sis/sis190.c
@@ -1586,6 +1586,7 @@ static int sis190_get_mac_addr_from_eeprom(struct pci_dev *pdev,
 {
 	struct sis190_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->mmio_addr;
+	__le16 addr[ETH_ALEN / 2];
 	u16 sig;
 	int i;
 
@@ -1606,8 +1607,9 @@ static int sis190_get_mac_addr_from_eeprom(struct pci_dev *pdev,
 	for (i = 0; i < ETH_ALEN / 2; i++) {
 		u16 w = sis190_read_eeprom(ioaddr, EEPROMMACAddr + i);
 
-		((__le16 *)dev->dev_addr)[i] = cpu_to_le16(w);
+		addr[i] = cpu_to_le16(w);
 	}
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	sis190_set_rgmii(tp, sis190_read_eeprom(ioaddr, EEPROMInfo));
 
diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index d105779ba3b2..3f5717a1874f 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -258,6 +258,7 @@ static int sis900_get_mac_addr(struct pci_dev *pci_dev,
 {
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 	void __iomem *ioaddr = sis_priv->ioaddr;
+	u16 addr[ETH_ALEN / 2];
 	u16 signature;
 	int i;
 
@@ -271,7 +272,8 @@ static int sis900_get_mac_addr(struct pci_dev *pci_dev,
 
 	/* get MAC address from EEPROM */
 	for (i = 0; i < 3; i++)
-	        ((u16 *)(net_dev->dev_addr))[i] = read_eeprom(ioaddr, i+EEPROMMACAddr);
+	        addr[i] = read_eeprom(ioaddr, i+EEPROMMACAddr);
+	eth_hw_addr_set(net_dev, (u8 *)addr);
 
 	return 1;
 }
@@ -331,6 +333,7 @@ static int sis635_get_mac_addr(struct pci_dev *pci_dev,
 {
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 	void __iomem *ioaddr = sis_priv->ioaddr;
+	u16 addr[ETH_ALEN / 2];
 	u32 rfcrSave;
 	u32 i;
 
@@ -345,8 +348,9 @@ static int sis635_get_mac_addr(struct pci_dev *pci_dev,
 	/* load MAC addr to filter data register */
 	for (i = 0 ; i < 3 ; i++) {
 		sw32(rfcr, (i << RFADDR_shift));
-		*( ((u16 *)net_dev->dev_addr) + i) = sr16(rfdr);
+		addr[i] = sr16(rfdr);
 	}
+	eth_hw_addr_set(net_dev, (u8 *)addr);
 
 	/* enable packet filtering */
 	sw32(rfcr, rfcrSave | RFEN);
@@ -375,17 +379,18 @@ static int sis96x_get_mac_addr(struct pci_dev *pci_dev,
 {
 	struct sis900_private *sis_priv = netdev_priv(net_dev);
 	void __iomem *ioaddr = sis_priv->ioaddr;
+	u16 addr[ETH_ALEN / 2];
 	int wait, rc = 0;
 
 	sw32(mear, EEREQ);
 	for (wait = 0; wait < 2000; wait++) {
 		if (sr32(mear) & EEGNT) {
-			u16 *mac = (u16 *)net_dev->dev_addr;
 			int i;
 
 			/* get MAC address from EEPROM */
 			for (i = 0; i < 3; i++)
-			        mac[i] = read_eeprom(ioaddr, i + EEPROMMACAddr);
+			        addr[i] = read_eeprom(ioaddr, i + EEPROMMACAddr);
+			 eth_hw_addr_set(net_dev, (u8 *)addr);
 
 			rc = 1;
 			break;
diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 44daf79a8f97..a0654e88444c 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -325,6 +325,7 @@ static int epic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *dev;
 	struct epic_private *ep;
 	int i, ret, option = 0, duplex = 0;
+	__le16 addr[ETH_ALEN / 2];
 	void *ring_space;
 	dma_addr_t ring_dma;
 
@@ -416,7 +417,8 @@ static int epic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Note: the '175 does not have a serial EEPROM. */
 	for (i = 0; i < 3; i++)
-		((__le16 *)dev->dev_addr)[i] = cpu_to_le16(er16(LAN0 + i*4));
+		addr[i] = cpu_to_le16(er16(LAN0 + i*4));
+	eth_hw_addr_set(dev, (u8 *)addr);
 
 	if (debug > 2) {
 		dev_dbg(&pdev->dev, "EEPROM contents:\n");
-- 
2.31.1

