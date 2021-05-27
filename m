Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7BE39313A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhE0OqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbhE0OqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:46:07 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C974C061574;
        Thu, 27 May 2021 07:44:33 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lmHFM-0002jz-4W; Thu, 27 May 2021 17:44:28 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v4 1/4] atl1c: detect NIC type early
Date:   Thu, 27 May 2021 17:44:20 +0300
Message-Id: <20210527144423.3395719-2-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527144423.3395719-1-gatis@mikrotik.com>
References: <20210527144423.3395719-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support NICs that allow for more than one tx queue it is
required to detect NIC type early during probe. This is moves
NIC type detection before netdev_alloc to prepare for that.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 56 +++++++++----------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 77da1c54c49f..e3a77d81fecb 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -646,33 +646,26 @@ static int atl1c_alloc_queues(struct atl1c_adapter *adapter)
 	return 0;
 }
 
-static void atl1c_set_mac_type(struct atl1c_hw *hw)
+static enum atl1c_nic_type atl1c_get_mac_type(struct pci_dev *pdev,
+					      u8 __iomem *hw_addr)
 {
-	u32 magic;
-	switch (hw->device_id) {
+	switch (pdev->device) {
 	case PCI_DEVICE_ID_ATTANSIC_L2C:
-		hw->nic_type = athr_l2c;
-		break;
+		return athr_l2c;
 	case PCI_DEVICE_ID_ATTANSIC_L1C:
-		hw->nic_type = athr_l1c;
-		break;
+		return athr_l1c;
 	case PCI_DEVICE_ID_ATHEROS_L2C_B:
-		hw->nic_type = athr_l2c_b;
-		break;
+		return athr_l2c_b;
 	case PCI_DEVICE_ID_ATHEROS_L2C_B2:
-		hw->nic_type = athr_l2c_b2;
-		break;
+		return athr_l2c_b2;
 	case PCI_DEVICE_ID_ATHEROS_L1D:
-		hw->nic_type = athr_l1d;
-		break;
+		return athr_l1d;
 	case PCI_DEVICE_ID_ATHEROS_L1D_2_0:
-		hw->nic_type = athr_l1d_2;
-		AT_READ_REG(hw, REG_MT_MAGIC, &magic);
-		if (magic == MT_MAGIC)
-			hw->nic_type = athr_mt;
-		break;
+		if (readl(hw_addr + REG_MT_MAGIC) == MT_MAGIC)
+			return athr_mt;
+		return athr_l1d_2;
 	default:
-		break;
+		return athr_l1c;
 	}
 }
 
@@ -680,7 +673,6 @@ static int atl1c_setup_mac_funcs(struct atl1c_hw *hw)
 {
 	u32 link_ctrl_data;
 
-	atl1c_set_mac_type(hw);
 	AT_READ_REG(hw, REG_LINK_CTRL, &link_ctrl_data);
 
 	hw->ctrl_flags = ATL1C_INTR_MODRT_ENABLE  |
@@ -2568,7 +2560,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev;
 	struct atl1c_adapter *adapter;
 	static int cards_found;
-
+	u8 __iomem *hw_addr;
+	enum atl1c_nic_type nic_type;
 	int err = 0;
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
@@ -2602,6 +2595,15 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
+	hw_addr = pci_ioremap_bar(pdev, 0);
+	if (!hw_addr) {
+		err = -EIO;
+		dev_err(&pdev->dev, "cannot map device registers\n");
+		goto err_ioremap;
+	}
+
+	nic_type = atl1c_get_mac_type(pdev, hw_addr);
+
 	netdev = alloc_etherdev(sizeof(struct atl1c_adapter));
 	if (netdev == NULL) {
 		err = -ENOMEM;
@@ -2618,13 +2620,9 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
 	adapter->hw.adapter = adapter;
+	adapter->hw.nic_type = nic_type;
 	adapter->msg_enable = netif_msg_init(-1, atl1c_default_msg);
-	adapter->hw.hw_addr = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
-	if (!adapter->hw.hw_addr) {
-		err = -EIO;
-		dev_err(&pdev->dev, "cannot map device registers\n");
-		goto err_ioremap;
-	}
+	adapter->hw.hw_addr = hw_addr;
 
 	/* init mii data */
 	adapter->mii.dev = netdev;
@@ -2687,11 +2685,11 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_reset:
 err_register:
 err_sw_init:
-	iounmap(adapter->hw.hw_addr);
 err_init_netdev:
-err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
+	iounmap(hw_addr);
+err_ioremap:
 	pci_release_regions(pdev);
 err_pci_reg:
 err_dma:
-- 
2.31.1

