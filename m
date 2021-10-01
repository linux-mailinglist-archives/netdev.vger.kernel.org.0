Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F77741F701
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJAVfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355644AbhJAVeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D66B761AEF;
        Fri,  1 Oct 2021 21:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123957;
        bh=TNZ8v/nBTRRIRecWoC2urnx5yUEvPN15ocxz2Wo9Uc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsMC6chKSwWUoDSqb47fULB2Cvx5Jp/itNC6Mt9TUnn/Y0Dp1SbV8tUtsZpn0YgSL
         py1Vh2HzBYwnhUTloVUTdgHznb2JG7lV5JCwzESLNiD7BKon8sZTrvfY+uT/THuJHI
         LtG5ZtfpkDdNBGFeSO2PzyVzviQRagfCC2FS+DIFaW0LFD2rE+7RsnPXUQg+QNfpku
         kuCDpD1gJc0+NLGEC8J1PCvPUcvH7b6dq8sDYnrA+cZKS+81JUvSry9YzSltQQN6hp
         mL/YnzFU3fkomukgyN0+ikzKiN6rQt1LA1Anv5XNGkcyBsH5t0OzJHFmHZ21su5k7Q
         yk1n6YrRGIvnw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/11] ethernet: use eth_hw_addr_set() - casts
Date:   Fri,  1 Oct 2021 14:32:28 -0700
Message-Id: <20211001213228.1735079-12-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eth_hw_addr_set() takes a u8 pointer, like other
etherdevice helpers. Convert the few drivers which
require casts because they memcpy from "endian marked"
types.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/3com/3c509.c     | 2 +-
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 drivers/net/ethernet/intel/e100.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 87c906e744fb..846fa3af4504 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -270,7 +270,7 @@ static void el3_dev_fill(struct net_device *dev, __be16 *phys_addr, int ioaddr,
 {
 	struct el3_private *lp = netdev_priv(dev);
 
-	memcpy(dev->dev_addr, phys_addr, ETH_ALEN);
+	eth_hw_addr_set(dev, (u8 *)phys_addr);
 	dev->base_addr = ioaddr;
 	dev->irq = irq;
 	dev->if_port = if_port;
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index bcbe73374666..82d32caf1374 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2467,7 +2467,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 		       DEFAULT_NAPI_WEIGHT);
 
 	if (is_valid_ether_addr((void *)port->mac_addr)) {
-		memcpy(netdev->dev_addr, port->mac_addr, ETH_ALEN);
+		eth_hw_addr_set(netdev, (u8 *)port->mac_addr);
 	} else {
 		dev_dbg(dev, "ethernet address 0x%08x%08x%08x invalid\n",
 			port->mac_addr[0], port->mac_addr[1],
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 09ae1939e6db..b620fdfb15b9 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2921,7 +2921,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	e100_phy_init(nic);
 
-	memcpy(netdev->dev_addr, nic->eeprom, ETH_ALEN);
+	eth_hw_addr_set(netdev, (u8 *)nic->eeprom);
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		if (!eeprom_bad_csum_allow) {
 			netif_err(nic, probe, nic->netdev, "Invalid MAC address from EEPROM, aborting\n");
-- 
2.31.1

