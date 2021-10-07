Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAAD424B81
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbhJGBJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240167AbhJGBJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92BC36120F;
        Thu,  7 Oct 2021 01:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568836;
        bh=6whqmOCghMi33Od61RRbb0VC02ndVS8L8JxNG3eciNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5qayVfEcf362/IQTNejW9m83WkGungsxcuJ1EwJhlToEQnqRk/mOcQba1cE3BRwk
         CvBVR9E9g1xNQge7WCkM7BSoyZu4VG0JABr7hdIngniIfmE7kw2fJu8OWZmKyO3Qro
         9YtoFdh2AzSHUmKm2ADNHfcRcr5NZfJacoowzCsHm8QfFl194L57u+5Qx6QX6SLCPj
         ROdrP2sLo0D6RAtgjqIxuosXBzBo2EwCNDYgFapYAW1u/pgjm1HfVGvbwAqFzjP278
         yLWICdoZijbq3m/Jo9izFLOVjfZPuLWcUL286NK3awkHchlDWeAbYM9W/5bfezVw64
         FSxkc6+zvGXjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 6/9] eth: fwnode: remove the addr len from mac helpers
Date:   Wed,  6 Oct 2021 18:06:59 -0700
Message-Id: <20211007010702.3438216-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007010702.3438216-1-kuba@kernel.org>
References: <20211007010702.3438216-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers pass in ETH_ALEN and the function itself
will return -EINVAL for any other address length.
Just assume it's ETH_ALEN like all other mac address
helpers (nvm, of, platform).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: new patch
---
 drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
 .../net/ethernet/cavium/thunder/thunder_bgx.c |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/microchip/enc28j60.c     |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 drivers/net/ethernet/smsc/smsc911x.c          |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 drivers/net/wireless/ath/ath10k/core.c        |  2 +-
 include/linux/etherdevice.h                   |  4 ++--
 net/ethernet/eth.c                            | 21 +++++++------------
 14 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index c7253ecc0fa5..d1ebd153b7a8 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
 		return -ENOMEM;
 	}
 
-	if (device_get_mac_address(dev, ndev->dev_addr, ETH_ALEN))
+	if (device_get_mac_address(dev, ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 268e099aa5e1..4a5bf13ffae2 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1731,7 +1731,7 @@ static int xgene_enet_get_resources(struct xgene_enet_pdata *pdata)
 		xgene_get_port_id_acpi(dev, pdata);
 #endif
 
-	if (device_get_mac_address(dev, ndev->dev_addr, ETH_ALEN))
+	if (device_get_mac_address(dev, ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 30c5dcaea802..e61b687d33ba 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4084,7 +4084,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (pd && !IS_ERR_OR_NULL(pd->mac_address))
 		eth_hw_addr_set(dev, pd->mac_address);
 	else
-		if (device_get_mac_address(&pdev->dev, dev->dev_addr, ETH_ALEN))
+		if (device_get_mac_address(&pdev->dev, dev->dev_addr))
 			if (has_acpi_companion(&pdev->dev))
 				bcmgenet_get_hw_addr(priv, dev->dev_addr);
 
diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 77ce81633cdc..574a32f23f96 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1389,7 +1389,7 @@ static int acpi_get_mac_address(struct device *dev, struct acpi_device *adev,
 	u8 mac[ETH_ALEN];
 	int ret;
 
-	ret = fwnode_get_mac_address(acpi_fwnode_handle(adev), mac, ETH_ALEN);
+	ret = fwnode_get_mac_address(acpi_fwnode_handle(adev), mac);
 	if (ret) {
 		dev_err(dev, "MAC address invalid: %pM\n", mac);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 8de9c99a18fb..86c2986395de 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -183,7 +183,7 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
 	unsigned int m;
 	unsigned int l;
 
-	if (!device_get_mac_address(priv->dev, mac, ETH_ALEN)) {
+	if (!device_get_mac_address(priv->dev, mac)) {
 		eth_hw_addr_set(priv->netdev, mac);
 		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
 			 mac);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 12b916399ba7..1195f64fb161 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1212,7 +1212,7 @@ static void hns_init_mac_addr(struct net_device *ndev)
 {
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 
-	if (device_get_mac_address(priv->dev, ndev->dev_addr, ETH_ALEN)) {
+	if (device_get_mac_address(priv->dev, ndev->dev_addr)) {
 		eth_hw_addr_random(ndev);
 		dev_warn(priv->dev, "No valid mac, use random mac %pM",
 			 ndev->dev_addr);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b84f8b6fe9f4..ad3be55cce68 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6081,7 +6081,7 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 	char hw_mac_addr[ETH_ALEN] = {0};
 	char fw_mac_addr[ETH_ALEN];
 
-	if (!fwnode_get_mac_address(fwnode, fw_mac_addr, ETH_ALEN)) {
+	if (!fwnode_get_mac_address(fwnode, fw_mac_addr)) {
 		*mac_from = "firmware node";
 		eth_hw_addr_set(dev, fw_mac_addr);
 		return;
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethernet/microchip/enc28j60.c
index fa62311d326a..cca8aa70cfc9 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -1572,7 +1572,7 @@ static int enc28j60_probe(struct spi_device *spi)
 		goto error_irq;
 	}
 
-	if (!device_get_mac_address(&spi->dev, macaddr, sizeof(macaddr)))
+	if (!device_get_mac_address(&spi->dev, macaddr))
 		eth_hw_addr_set(dev, macaddr);
 	else
 		eth_hw_addr_random(dev);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 2e913508fbeb..b1b324f45fe7 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -549,7 +549,7 @@ static int emac_probe_resources(struct platform_device *pdev,
 	int ret = 0;
 
 	/* get mac address */
-	if (!device_get_mac_address(&pdev->dev, maddr, ETH_ALEN))
+	if (!device_get_mac_address(&pdev->dev, maddr))
 		eth_hw_addr_set(netdev, maddr);
 	else
 		eth_hw_addr_random(netdev);
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index d47308ace075..fa387510c189 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2375,7 +2375,7 @@ static int smsc911x_probe_config(struct smsc911x_platform_config *config,
 		phy_interface = PHY_INTERFACE_MODE_NA;
 	config->phy_interface = phy_interface;
 
-	device_get_mac_address(dev, config->mac, ETH_ALEN);
+	device_get_mac_address(dev, config->mac);
 
 	err = device_property_read_u32(dev, "reg-io-width", &width);
 	if (err == -ENXIO)
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f8dd7fa5f632..7e3dd07ac94e 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2034,7 +2034,7 @@ static int netsec_probe(struct platform_device *pdev)
 		goto free_ndev;
 	}
 
-	ret = device_get_mac_address(&pdev->dev, macbuf, sizeof(macbuf));
+	ret = device_get_mac_address(&pdev->dev, macbuf);
 	if (!ret)
 		eth_hw_addr_set(ndev, macbuf);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2f9be182fbfb..c21e05549f61 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3224,7 +3224,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		ath10k_debug_print_board_info(ar);
 	}
 
-	device_get_mac_address(ar->dev, ar->mac_addr, sizeof(ar->mac_addr));
+	device_get_mac_address(ar->dev, ar->mac_addr);
 
 	ret = ath10k_core_init_firmware_features(ar);
 	if (ret) {
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 70f03f48ff06..32c30d0f7a73 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -31,8 +31,8 @@ struct fwnode_handle;
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
 unsigned char *arch_get_platform_mac_address(void);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf);
-int device_get_mac_address(struct device *dev, char *addr, int alen);
-int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen);
+int device_get_mac_address(struct device *dev, char *addr);
+int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr);
 
 u32 eth_get_headlen(const struct net_device *dev, const void *data, u32 len);
 __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 70692f5b514c..29447a61d3ec 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -561,14 +561,11 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 EXPORT_SYMBOL(nvmem_get_mac_address);
 
 static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
-			       const char *name, char *addr, int alen)
+			       const char *name, char *addr)
 {
 	int ret;
 
-	if (alen != ETH_ALEN)
-		return -EINVAL;
-
-	ret = fwnode_property_read_u8_array(fwnode, name, addr, alen);
+	ret = fwnode_property_read_u8_array(fwnode, name, addr, ETH_ALEN);
 	if (ret)
 		return ret;
 
@@ -581,7 +578,6 @@ static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
  * fwnode_get_mac_address - Get the MAC from the firmware node
  * @fwnode:	Pointer to the firmware node
  * @addr:	Address of buffer to store the MAC in
- * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
  *
  * Search the firmware node for the best MAC address to use.  'mac-address' is
  * checked first, because that is supposed to contain to "most recent" MAC
@@ -600,11 +596,11 @@ static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
  * In this case, the real MAC is in 'local-mac-address', and 'mac-address'
  * exists but is all zeros.
  */
-int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int alen)
+int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr)
 {
-	if (!fwnode_get_mac_addr(fwnode, "mac-address", addr, alen) ||
-	    !fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen) ||
-	    !fwnode_get_mac_addr(fwnode, "address", addr, alen))
+	if (!fwnode_get_mac_addr(fwnode, "mac-address", addr) ||
+	    !fwnode_get_mac_addr(fwnode, "local-mac-address", addr) ||
+	    !fwnode_get_mac_addr(fwnode, "address", addr))
 		return 0;
 
 	return -ENOENT;
@@ -615,10 +611,9 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
  * device_get_mac_address - Get the MAC for a given device
  * @dev:	Pointer to the device
  * @addr:	Address of buffer to store the MAC in
- * @alen:	Length of the buffer pointed to by addr, should be ETH_ALEN
  */
-int device_get_mac_address(struct device *dev, char *addr, int alen)
+int device_get_mac_address(struct device *dev, char *addr)
 {
-	return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
+	return fwnode_get_mac_address(dev_fwnode(dev), addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
-- 
2.31.1

