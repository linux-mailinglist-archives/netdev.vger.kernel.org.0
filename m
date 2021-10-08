Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA2426FD3
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbhJHSBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhJHSBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7921F61040;
        Fri,  8 Oct 2021 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715958;
        bh=ooMWkSrNWPbgbX8gAdDNJlI/p1MWwcZtEEwPPbOAF4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHk+BsHgidciOqFr0WQpGvDOWN3oimEiK8T+RfxYHsUZ9wcnCkDMg2L2jBpJZuYA4
         iWvG5paTvbFXwKdLiE8L1BMrQ0r00//7AkvqQBu7wqt2hmFpotksTSW3mWr6LlNZqy
         EZ0I1C3OdEb6RxfB8J4k3AVrVdcj0TN4TArZgcZHyXGZzUftZHafMZKRwpplZ/Fcow
         J3MusBmZIvftYH7qnT/vByQDl6tPU+GCOx4Yv4P6+Hs3Ywdcvao5mlRa6XMFq8yt9t
         Iqo/sx92zY5BDe1zZcqkjboX47HQobrJDAHwuyK7A0mNZnklM2SvW9yVY507h+RU0f
         /XVDT/Wns155Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/5] ethernet: sun: remove direct netdev->dev_addr writes
Date:   Fri,  8 Oct 2021 10:59:12 -0700
Message-Id: <20211008175913.3754184-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008175913.3754184-1-kuba@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consify temporary variables pointing to netdev->dev_addr.

A few places need local storage but pretty simple conversion
over all. Note that macaddr[] is an array of ints, so we need
to keep the loops.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/sun/cassini.c |  7 ++---
 drivers/net/ethernet/sun/ldmvsw.c  |  7 ++---
 drivers/net/ethernet/sun/niu.c     | 42 +++++++++++++++++-------------
 drivers/net/ethernet/sun/sungem.c  | 11 +++++---
 drivers/net/ethernet/sun/sunhme.c  | 15 ++++++++---
 5 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 287ae4c538aa..d2d4f47c7e28 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -3027,7 +3027,7 @@ static void cas_mac_reset(struct cas *cp)
 /* Must be invoked under cp->lock. */
 static void cas_init_mac(struct cas *cp)
 {
-	unsigned char *e = &cp->dev->dev_addr[0];
+	const unsigned char *e = &cp->dev->dev_addr[0];
 	int i;
 	cas_mac_reset(cp);
 
@@ -3379,6 +3379,7 @@ static void cas_check_pci_invariants(struct cas *cp)
 static int cas_check_invariants(struct cas *cp)
 {
 	struct pci_dev *pdev = cp->pdev;
+	u8 addr[ETH_ALEN];
 	u32 cfg;
 	int i;
 
@@ -3407,8 +3408,8 @@ static int cas_check_invariants(struct cas *cp)
 	/* finish phy determination. MDIO1 takes precedence over MDIO0 if
 	 * they're both connected.
 	 */
-	cp->phy_type = cas_get_vpd_info(cp, cp->dev->dev_addr,
-					PCI_SLOT(pdev->devfn));
+	cp->phy_type = cas_get_vpd_info(cp, addr, PCI_SLOT(pdev->devfn));
+	eth_hw_addr_set(cp->dev, addr);
 	if (cp->phy_type & CAS_PHY_SERDES) {
 		cp->cas_flags |= CAS_FLAG_1000MB_CAP;
 		return 0; /* no more checking needed */
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 50bd4e3b0af9..074c5407c86b 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -230,7 +230,6 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 {
 	struct net_device *dev;
 	struct vnet_port *port;
-	int i;
 
 	dev = alloc_etherdev_mqs(sizeof(*port), VNET_MAX_TXQS, 1);
 	if (!dev)
@@ -238,10 +237,8 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 	dev->needed_headroom = VNET_PACKET_SKIP + 8;
 	dev->needed_tailroom = 8;
 
-	for (i = 0; i < ETH_ALEN; i++) {
-		dev->dev_addr[i] = hwaddr[i];
-		dev->perm_addr[i] = dev->dev_addr[i];
-	}
+	eth_hw_addr_set(dev, hwaddr);
+	ether_addr_copy(dev->perm_addr, dev->dev_addr)
 
 	sprintf(dev->name, "vif%d.%d", (int)handle, (int)port_id);
 
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 1a73a9401347..ba8ad76313a9 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -2603,7 +2603,7 @@ static int niu_init_link(struct niu *np)
 	return 0;
 }
 
-static void niu_set_primary_mac(struct niu *np, unsigned char *addr)
+static void niu_set_primary_mac(struct niu *np, const unsigned char *addr)
 {
 	u16 reg0 = addr[4] << 8 | addr[5];
 	u16 reg1 = addr[2] << 8 | addr[3];
@@ -8312,6 +8312,7 @@ static void niu_pci_vpd_validate(struct niu *np)
 {
 	struct net_device *dev = np->dev;
 	struct niu_vpd *vpd = &np->vpd;
+	u8 addr[ETH_ALEN];
 	u8 val8;
 
 	if (!is_valid_ether_addr(&vpd->local_mac[0])) {
@@ -8344,17 +8345,20 @@ static void niu_pci_vpd_validate(struct niu *np)
 		return;
 	}
 
-	eth_hw_addr_set(dev, vpd->local_mac);
+	ether_addr_copy(addr, vpd->local_mac);
 
-	val8 = dev->dev_addr[5];
-	dev->dev_addr[5] += np->port;
-	if (dev->dev_addr[5] < val8)
-		dev->dev_addr[4]++;
+	val8 = addr[5];
+	addr[5] += np->port;
+	if (addr[5] < val8)
+		addr[4]++;
+
+	eth_hw_addr_set(dev, addr);
 }
 
 static int niu_pci_probe_sprom(struct niu *np)
 {
 	struct net_device *dev = np->dev;
+	u8 addr[ETH_ALEN];
 	int len, i;
 	u64 val, sum;
 	u8 val8;
@@ -8446,27 +8450,29 @@ static int niu_pci_probe_sprom(struct niu *np)
 	val = nr64(ESPC_MAC_ADDR0);
 	netif_printk(np, probe, KERN_DEBUG, np->dev,
 		     "SPROM: MAC_ADDR0[%08llx]\n", (unsigned long long)val);
-	dev->dev_addr[0] = (val >>  0) & 0xff;
-	dev->dev_addr[1] = (val >>  8) & 0xff;
-	dev->dev_addr[2] = (val >> 16) & 0xff;
-	dev->dev_addr[3] = (val >> 24) & 0xff;
+	addr[0] = (val >>  0) & 0xff;
+	addr[1] = (val >>  8) & 0xff;
+	addr[2] = (val >> 16) & 0xff;
+	addr[3] = (val >> 24) & 0xff;
 
 	val = nr64(ESPC_MAC_ADDR1);
 	netif_printk(np, probe, KERN_DEBUG, np->dev,
 		     "SPROM: MAC_ADDR1[%08llx]\n", (unsigned long long)val);
-	dev->dev_addr[4] = (val >>  0) & 0xff;
-	dev->dev_addr[5] = (val >>  8) & 0xff;
+	addr[4] = (val >>  0) & 0xff;
+	addr[5] = (val >>  8) & 0xff;
 
-	if (!is_valid_ether_addr(&dev->dev_addr[0])) {
+	if (!is_valid_ether_addr(addr)) {
 		dev_err(np->device, "SPROM MAC address invalid [ %pM ]\n",
-			dev->dev_addr);
+			addr);
 		return -EINVAL;
 	}
 
-	val8 = dev->dev_addr[5];
-	dev->dev_addr[5] += np->port;
-	if (dev->dev_addr[5] < val8)
-		dev->dev_addr[4]++;
+	val8 = addr[5];
+	addr[5] += np->port;
+	if (addr[5] < val8)
+		addr[4]++;
+
+	eth_hw_addr_set(dev, addr);
 
 	val = nr64(ESPC_MOD_STR_LEN);
 	netif_printk(np, probe, KERN_DEBUG, np->dev,
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 5f786d6fa150..036856102c50 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1810,7 +1810,7 @@ static u32 gem_setup_multicast(struct gem *gp)
 
 static void gem_init_mac(struct gem *gp)
 {
-	unsigned char *e = &gp->dev->dev_addr[0];
+	const unsigned char *e = &gp->dev->dev_addr[0];
 
 	writel(0x1bf0, gp->regs + MAC_SNDPAUSE);
 
@@ -2087,7 +2087,7 @@ static void gem_stop_phy(struct gem *gp, int wol)
 	writel(mifcfg, gp->regs + MIF_CFG);
 
 	if (wol && gp->has_wol) {
-		unsigned char *e = &gp->dev->dev_addr[0];
+		const unsigned char *e = &gp->dev->dev_addr[0];
 		u32 csr;
 
 		/* Setup wake-on-lan for MAGIC packet */
@@ -2431,8 +2431,8 @@ static struct net_device_stats *gem_get_stats(struct net_device *dev)
 static int gem_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *macaddr = (struct sockaddr *) addr;
+	const unsigned char *e = &dev->dev_addr[0];
 	struct gem *gp = netdev_priv(dev);
-	unsigned char *e = &dev->dev_addr[0];
 
 	if (!is_valid_ether_addr(macaddr->sa_data))
 		return -EADDRNOTAVAIL;
@@ -2799,7 +2799,10 @@ static int gem_get_device_address(struct gem *gp)
 	}
 	eth_hw_addr_set(dev, addr);
 #else
-	get_gem_mac_nonobp(gp->pdev, gp->dev->dev_addr);
+	u8 addr[ETH_ALEN];
+
+	get_gem_mac_nonobp(gp->pdev, addr);
+	eth_hw_addr_set(gp->dev, addr);
 #endif
 	return 0;
 }
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index fe5482b1872f..ad9029ae6848 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -1395,13 +1395,13 @@ happy_meal_begin_auto_negotiation(struct happy_meal *hp,
 /* hp->happy_lock must be held */
 static int happy_meal_init(struct happy_meal *hp)
 {
+	const unsigned char *e = &hp->dev->dev_addr[0];
 	void __iomem *gregs        = hp->gregs;
 	void __iomem *etxregs      = hp->etxregs;
 	void __iomem *erxregs      = hp->erxregs;
 	void __iomem *bregs        = hp->bigmacregs;
 	void __iomem *tregs        = hp->tcvregs;
 	u32 regtmp, rxcfg;
-	unsigned char *e = &hp->dev->dev_addr[0];
 
 	/* If auto-negotiation timer is running, kill it. */
 	del_timer(&hp->happy_timer);
@@ -2661,6 +2661,7 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	struct happy_meal *hp;
 	struct net_device *dev;
 	int i, qfe_slot = -1;
+	u8 addr[ETH_ALEN];
 	int err = -ENODEV;
 
 	sbus_dp = op->dev.parent->of_node;
@@ -2698,7 +2699,8 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	}
 	if (i < 6) { /* a mac address was given */
 		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = macaddr[i];
+			addr[i] = macaddr[i];
+		eth_hw_addr_set(dev, addr);
 		macaddr[5]++;
 	} else {
 		const unsigned char *addr;
@@ -2969,6 +2971,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	unsigned long hpreg_res;
 	int i, qfe_slot = -1;
 	char prom_name[64];
+	u8 addr[ETH_ALEN];
 	int err;
 
 	/* Now make sure pci_dev cookie is there. */
@@ -3044,7 +3047,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	}
 	if (i < 6) { /* a mac address was given */
 		for (i = 0; i < 6; i++)
-			dev->dev_addr[i] = macaddr[i];
+			addr[i] = macaddr[i];
+		eth_hw_addr_set(dev, addr);
 		macaddr[5]++;
 	} else {
 #ifdef CONFIG_SPARC
@@ -3060,7 +3064,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			eth_hw_addr_set(dev, idprom->id_ethaddr);
 		}
 #else
-		get_hme_mac_nonsparc(pdev, &dev->dev_addr[0]);
+		u8 addr[ETH_ALEN];
+
+		get_hme_mac_nonsparc(pdev, addr);
+		eth_hw_addr_set(dev, addr);
 #endif
 	}
 
-- 
2.31.1

