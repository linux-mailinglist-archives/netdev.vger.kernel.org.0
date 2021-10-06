Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2184235C8
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 04:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbhJFC1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 22:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhJFC1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 22:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E403611C6;
        Wed,  6 Oct 2021 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633487117;
        bh=p0xWVNlWA8hiph2LZgN6wU18/CUZI60lNS1HK9UES/w=;
        h=From:To:Cc:Subject:Date:From;
        b=IGgdtCvkN8qwbCscPbosntSzVV9I6lFQoSYiI33c0qQR+I/XjxRx7lznnmDm7Yv3H
         TR62RB9Xu9H5PCL7kQBZvvww9V7LUTh5NlS6JCxMkoPLJTo3jOYB1sGR2aI2h+rPHA
         8DcKAGIb6WgE8n2yYseyZSAxeIVzd4uCHIGAv0oZ3IumLwaA89a7Ab4lFBbOL+lalF
         umYRHWx48389lHrEBOnYa1JQ3Wu/H8gbf4PRsU6bvXgEb3OGErgC2Wuf1zIIxqFy9L
         VFAeVWxg+lv0BRa69ouUD5ni0xuAmDNbVttzutkgeQqJVOLiAgrANeZH7Ubo/4OjRN
         8smsSZHEAOF5Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org,
        saravanak@google.com, mw@semihalf.com, andrew@lunn.ch,
        jeremy.linton@arm.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC] fwnode: change the return type of mac address helpers
Date:   Tue,  5 Oct 2021 19:24:44 -0700
Message-Id: <20211006022444.3155482-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fwnode_get_mac_address() and device_get_mac_address()
return a pointer to the buffer that was passed to them
on success or NULL on failure. None of the callers
care about the actual value, only if it's NULL or not.

These semantics differ from of_get_mac_address() which
returns an int so to avoid confusion make the device
helpers return an errno.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
Full disclosure this resolves an obvious issue with
device_get_ethdev_addr() returning a stack pointer.
Which works, since no caller derefs the pointer but
is obviously hard to condone.
---
 drivers/base/property.c                       | 45 ++++++++++---------
 drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 .../net/ethernet/cavium/thunder/thunder_bgx.c |  6 +--
 drivers/net/ethernet/faraday/ftgmac100.c      |  4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/microchip/enc28j60.c     |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  8 ++--
 include/linux/property.h                      |  7 ++-
 12 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 1c8d4676addc..20c5d3a4ee6b 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -935,15 +935,21 @@ int device_get_phy_mode(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_get_phy_mode);
 
-static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
-				 const char *name, char *addr,
-				 int alen)
+static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
+			       const char *name, char *addr, int alen)
 {
-	int ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
+	int ret;
 
-	if (ret == 0 && alen == ETH_ALEN && is_valid_ether_addr(addr))
-		return addr;
-	return NULL;
+	if (alen != ETH_ALEN)
+		return -EINVAL;
+
+	ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
+	if (ret)
+		return ret;
+
+	if (!is_valid_ether_addr(addr))
+		return -EINVAL;
+	return 0;
 }
 
 /**
@@ -969,19 +975,14 @@ static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
  * In this case, the real MAC is in 'local-mac-address', and 'mac-address'
  * exists but is all zeros.
 */
-void *fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
+int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
 {
-	char *res;
-
-	res = fwnode_get_mac_addr(fwnode, "mac-address", addr, alen);
-	if (res)
-		return res;
-
-	res = fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen);
-	if (res)
-		return res;
+	if (!fwnode_get_mac_addr(fwnode, "mac-address", addr, alen) ||
+	    !fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen) ||
+	    !fwnode_get_mac_addr(fwnode, "address", addr, alen))
+		return 0;
 
-	return fwnode_get_mac_addr(fwnode, "address", addr, alen);
+	return -ENOENT;
 }
 EXPORT_SYMBOL(fwnode_get_mac_address);
 
@@ -991,7 +992,7 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
  * @addr:	Address of buffer to store the MAC in
  * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
  */
-void *device_get_mac_address(struct device *dev, char *addr, int alen)
+int device_get_mac_address(struct device *dev, char *addr, int alen)
 {
 	return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
 }
@@ -1005,13 +1006,13 @@ EXPORT_SYMBOL(device_get_mac_address);
  * Wrapper around device_get_mac_address() which writes the address
  * directly to netdev->dev_addr.
  */
-void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev)
+int device_get_ethdev_addr(struct device *dev, struct net_device *netdev)
 {
 	u8 addr[ETH_ALEN];
-	void *ret;
+	int ret;
 
 	ret = device_get_mac_address(dev, addr, ETH_ALEN);
-	if (ret)
+	if (!ret)
 		eth_hw_addr_set(netdev, addr);
 	return ret;
 }
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 119e488979f9..060265892401 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
 		return -ENOMEM;
 	}
 
-	if (!device_get_ethdev_addr(dev, ndev))
+	if (device_get_ethdev_addr(dev, ndev))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 111cd88984c9..f69cc8c5c9b7 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1731,7 +1731,7 @@ static int xgene_enet_get_resources(struct xgene_enet_pdata *pdata)
 		xgene_get_port_id_acpi(dev, pdata);
 #endif
 
-	if (!device_get_ethdev_addr(dev, ndev))
+	if (device_get_ethdev_addr(dev, ndev))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 541763968201..c6fa5c773b3b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4084,7 +4084,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (pd && !IS_ERR_OR_NULL(pd->mac_address))
 		eth_hw_addr_set(dev, pd->mac_address);
 	else
-		if (!device_get_ethdev_addr(&pdev->dev, dev))
+		if (device_get_ethdev_addr(&pdev->dev, dev))
 			if (has_acpi_companion(&pdev->dev))
 				bcmgenet_get_hw_addr(priv, dev->dev_addr);
 
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index db66d4beb28a..77ce81633cdc 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1387,10 +1387,10 @@ static int acpi_get_mac_address(struct device *dev, struct acpi_device *adev,
 				u8 *dst)
 {
 	u8 mac[ETH_ALEN];
-	u8 *addr;
+	int ret;
 
-	addr = fwnode_get_mac_address(acpi_fwnode_handle(adev), mac, ETH_ALEN);
-	if (!addr) {
+	ret = fwnode_get_mac_address(acpi_fwnode_handle(adev), mac, ETH_ALEN);
+	if (ret) {
 		dev_err(dev, "MAC address invalid: %pM\n", mac);
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ab9267225573..8de9c99a18fb 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -182,10 +182,8 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 	u8 mac[ETH_ALEN];
 	unsigned int m;
 	unsigned int l;
-	void *addr;
 
-	addr = device_get_mac_address(priv->dev, mac, ETH_ALEN);
-	if (addr) {
+	if (!device_get_mac_address(priv->dev, mac, ETH_ALEN)) {
 		eth_hw_addr_set(priv->netdev, mac);
 		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
 			 mac);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index f4ed877e16e9..c5e7475b0a60 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1212,7 +1212,7 @@ static void hns_init_mac_addr(struct net_device *ndev)
 {
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 
-	if (!device_get_ethdev_addr(priv->dev, ndev)) {
+	if (device_get_ethdev_addr(priv->dev, ndev)) {
 		eth_hw_addr_random(ndev);
 		dev_warn(priv->dev, "No valid mac, use random mac %pM",
 			 ndev->dev_addr);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3197526455d9..b84f8b6fe9f4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6081,7 +6081,7 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 	char hw_mac_addr[ETH_ALEN] = {0};
 	char fw_mac_addr[ETH_ALEN];
 
-	if (fwnode_get_mac_address(fwnode, fw_mac_addr, ETH_ALEN)) {
+	if (!fwnode_get_mac_address(fwnode, fw_mac_addr, ETH_ALEN)) {
 		*mac_from = "firmware node";
 		eth_hw_addr_set(dev, fw_mac_addr);
 		return;
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index bf77e8adffbf..fa62311d326a 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -1572,7 +1572,7 @@ static int enc28j60_probe(struct spi_device *spi)
 		goto error_irq;
 	}
 
-	if (device_get_mac_address(&spi->dev, macaddr, sizeof(macaddr)))
+	if (!device_get_mac_address(&spi->dev, macaddr, sizeof(macaddr)))
 		eth_hw_addr_set(dev, macaddr);
 	else
 		eth_hw_addr_random(dev);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index fbfabfc5cc51..2e913508fbeb 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -549,7 +549,7 @@ static int emac_probe_resources(struct platform_device *pdev,
 	int ret = 0;
 
 	/* get mac address */
-	if (device_get_mac_address(&pdev->dev, maddr, ETH_ALEN))
+	if (!device_get_mac_address(&pdev->dev, maddr, ETH_ALEN))
 		eth_hw_addr_set(netdev, maddr);
 	else
 		eth_hw_addr_random(netdev);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index c7e56dc0a494..c4b92bfd00a7 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1978,10 +1978,10 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 static int netsec_probe(struct platform_device *pdev)
 {
 	struct resource *mmio_res, *eeprom_res, *irq_res;
-	u8 *mac, macbuf[ETH_ALEN];
 	struct netsec_priv *priv;
 	u32 hw_ver, phy_addr = 0;
 	struct net_device *ndev;
+	u8 macbuf[ETH_ALEN];
 	int ret;
 
 	mmio_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -2034,12 +2034,12 @@ static int netsec_probe(struct platform_device *pdev)
 		goto free_ndev;
 	}
 
-	mac = device_get_mac_address(&pdev->dev, macbuf, sizeof(macbuf));
-	if (mac)
+	ret = device_get_mac_address(&pdev->dev, macbuf, sizeof(macbuf));
+	if (!ret)
 		eth_hw_addr_set(ndev, mac);
 
 	if (priv->eeprom_base &&
-	    (!mac || !is_valid_ether_addr(ndev->dev_addr))) {
+	    (ret || !is_valid_ether_addr(ndev->dev_addr))) {
 		void __iomem *macp = priv->eeprom_base +
 					NETSEC_EEPROM_MAC_ADDRESS;
 
diff --git a/include/linux/property.h b/include/linux/property.h
index 24dc4d2b9dbd..260594280e09 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -390,12 +390,11 @@ const void *device_get_match_data(struct device *dev);
 
 int device_get_phy_mode(struct device *dev);
 
-void *device_get_mac_address(struct device *dev, char *addr, int alen);
-void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev);
+int device_get_mac_address(struct device *dev, char *addr, int alen);
+int device_get_ethdev_addr(struct device *dev, struct net_device *netdev);
 
 int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
-void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
-			     char *addr, int alen);
+int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen);
 struct fwnode_handle *fwnode_graph_get_next_endpoint(
 	const struct fwnode_handle *fwnode, struct fwnode_handle *prev);
 struct fwnode_handle *
-- 
2.31.1

