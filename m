Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA0942FE03
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbhJOWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238840AbhJOWTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 197A260C4A;
        Fri, 15 Oct 2021 22:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336224;
        bh=ANmU4lDPVXkGRHcZDrvgvrc3V3izRuaZWyjiqcAgJWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvvGKaX57GHVVrcwnL/7I0yASpvN2GoHz49naX5lnybW9O7+whvi50UXm2ys658iZ
         DFH8I1tADozAyXPmqhjBf7z+6gcv6/9QIlE9cP8rT9gNBDyPh5mFnKJSntMc9kQzJR
         IHQmFSrsu2k0wfVwx5qis+RBFYsYl3u9En2UJ9c7pfTgLcgojnsmK/ECvRVFNb9nJA
         V69HZVoeHVOwUjLBJA2DDG4VYglVqPSwNc+dZpZB5p0Nu3L7OJ2QcZxcywe6TnXCBx
         VZbmnf4H9qcRDBRPFdcnUisDjfpS2qqrELIQa5eczG22h+ezp8YKia1yzgYDZN2V2m
         7DS2pY3zWXbbg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 12/12] ethernet: ixgb: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:52 -0700
Message-Id: <20211015221652.827253-13-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set(). ixgb_get_ee_mac_addr() is used with
a non-nevdev->dev_addr pointer so we can't deal with the problem
inside it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 5e1e2f0db82a..99d481904ce6 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -362,6 +362,7 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ixgb_adapter *adapter;
 	static int cards_found = 0;
 	int pci_using_dac;
+	u8 addr[ETH_ALEN];
 	int i;
 	int err;
 
@@ -461,7 +462,8 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_eeprom;
 	}
 
-	ixgb_get_ee_mac_addr(&adapter->hw, netdev->dev_addr);
+	ixgb_get_ee_mac_addr(&adapter->hw, addr);
+	eth_hw_addr_set(netdev, addr);
 
 	if (!is_valid_ether_addr(netdev->dev_addr)) {
 		netif_err(adapter, probe, adapter->netdev, "Invalid MAC Address\n");
@@ -2227,6 +2229,7 @@ static pci_ers_result_t ixgb_io_slot_reset(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
+	u8 addr[ETH_ALEN];
 
 	if (pci_enable_device(pdev)) {
 		netif_err(adapter, probe, adapter->netdev,
@@ -2250,7 +2253,8 @@ static pci_ers_result_t ixgb_io_slot_reset(struct pci_dev *pdev)
 			  "After reset, the EEPROM checksum is not valid\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
-	ixgb_get_ee_mac_addr(&adapter->hw, netdev->dev_addr);
+	ixgb_get_ee_mac_addr(&adapter->hw, addr);
+	eth_hw_addr_set(netdev, addr);
 	memcpy(netdev->perm_addr, netdev->dev_addr, netdev->addr_len);
 
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
-- 
2.31.1

