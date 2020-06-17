Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0386B1FD94D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgFQW7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:59:21 -0400
Received: from lists.gateworks.com ([108.161.130.12]:43580 "EHLO
        lists.gateworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgFQW7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:59:21 -0400
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by lists.gateworks.com with esmtp (Exim 4.82)
        (envelope-from <tharvey@gateworks.com>)
        id 1jlh4l-0006j8-6D; Wed, 17 Jun 2020 23:02:35 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH] lan743x: allow mac address to come from dt
Date:   Wed, 17 Jun 2020 15:59:10 -0700
Message-Id: <1592434750-8940-1-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a valid mac address is present in dt, use that before using
CSR's or a random mac address.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 41 ++++++++++++++++-----------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 7ef22bf..50ad56b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -12,6 +12,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/iopoll.h>
 #include <linux/crc16.h>
+#include <linux/of_net.h>
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
 
@@ -804,26 +805,29 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 	data |= MAC_CR_CNTR_RST_;
 	lan743x_csr_write(adapter, MAC_CR, data);
 
-	mac_addr_hi = lan743x_csr_read(adapter, MAC_RX_ADDRH);
-	mac_addr_lo = lan743x_csr_read(adapter, MAC_RX_ADDRL);
-	adapter->mac_address[0] = mac_addr_lo & 0xFF;
-	adapter->mac_address[1] = (mac_addr_lo >> 8) & 0xFF;
-	adapter->mac_address[2] = (mac_addr_lo >> 16) & 0xFF;
-	adapter->mac_address[3] = (mac_addr_lo >> 24) & 0xFF;
-	adapter->mac_address[4] = mac_addr_hi & 0xFF;
-	adapter->mac_address[5] = (mac_addr_hi >> 8) & 0xFF;
+	if (!is_valid_ether_addr(adapter->mac_address)) {
+		mac_addr_hi = lan743x_csr_read(adapter, MAC_RX_ADDRH);
+		mac_addr_lo = lan743x_csr_read(adapter, MAC_RX_ADDRL);
+		adapter->mac_address[0] = mac_addr_lo & 0xFF;
+		adapter->mac_address[1] = (mac_addr_lo >> 8) & 0xFF;
+		adapter->mac_address[2] = (mac_addr_lo >> 16) & 0xFF;
+		adapter->mac_address[3] = (mac_addr_lo >> 24) & 0xFF;
+		adapter->mac_address[4] = mac_addr_hi & 0xFF;
+		adapter->mac_address[5] = (mac_addr_hi >> 8) & 0xFF;
+
+		if (((mac_addr_hi & 0x0000FFFF) == 0x0000FFFF) &&
+		    mac_addr_lo == 0xFFFFFFFF) {
+			mac_address_valid = false;
+		} else if (!is_valid_ether_addr(adapter->mac_address)) {
+			mac_address_valid = false;
+		}
 
-	if (((mac_addr_hi & 0x0000FFFF) == 0x0000FFFF) &&
-	    mac_addr_lo == 0xFFFFFFFF) {
-		mac_address_valid = false;
-	} else if (!is_valid_ether_addr(adapter->mac_address)) {
-		mac_address_valid = false;
+		if (!mac_address_valid)
+			eth_random_addr(adapter->mac_address);
 	}
-
-	if (!mac_address_valid)
-		eth_random_addr(adapter->mac_address);
 	lan743x_mac_set_address(adapter, adapter->mac_address);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_address);
+
 	return 0;
 }
 
@@ -2756,6 +2760,7 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 {
 	struct lan743x_adapter *adapter = NULL;
 	struct net_device *netdev = NULL;
+	const void *mac_addr;
 	int ret = -ENODEV;
 
 	netdev = devm_alloc_etherdev(&pdev->dev,
@@ -2772,6 +2777,10 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
 	netdev->max_mtu = LAN743X_MAX_FRAME_SIZE;
 
+	mac_addr = of_get_mac_address(pdev->dev.of_node);
+	if (!IS_ERR(mac_addr))
+		ether_addr_copy(adapter->mac_address, mac_addr);
+
 	ret = lan743x_pci_init(adapter, pdev);
 	if (ret)
 		goto return_error;
-- 
2.7.4

