Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C7241F6FF
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355746AbhJAVee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355615AbhJAVeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D14261AEE;
        Fri,  1 Oct 2021 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123955;
        bh=FgsmVDo4X3bYtM744l+x3OyC2u79YD4svywxx3G5IJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKUpbqICgkhkykXXs7z3WEmXiBXl66boOMa0SDuFrd+YB+/RIBfB+2ETAF8msTrrf
         4woS/PpRxLFmGPIn94UDz4HzO5SGPTct04vBnboKa8sFg7wEp2CLGhnF733O4GHE//
         VRbL1vK7s2w19InstVJliI4rjNa0ev7W2j4zIwcj56ERXVAwMCMB8HIHqUrQjTjvOm
         a5i/NMGUg8FPuCUNaaSBSF/K6fwB+Olj7PknWiGoqu4wmz6pGdPZSFw31fFxf7FH1H
         HijpOS5Ue3cZYFDntDdM0chCCFkYxzyODTLtOumq6GeC9Gb2Bacbj7dqJ5NM/kpn2g
         KescVwwFkINrw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH net-next 07/11] net: usb: use eth_hw_addr_set() instead of ether_addr_copy()
Date:   Fri,  1 Oct 2021 14:32:24 -0700
Message-Id: <20211001213228.1735079-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Convert net/usb from ether_addr_copy() to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - ether_addr_copy(dev->dev_addr, np)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/aqc111.c     | 2 +-
 drivers/net/usb/lan78xx.c    | 4 ++--
 drivers/net/usb/r8152.c      | 2 +-
 drivers/net/usb/rndis_host.c | 2 +-
 drivers/net/usb/rtl8150.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 73b97f4cc1ec..981ac1c33780 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -714,7 +714,7 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (ret)
 		goto out;
 
-	ether_addr_copy(dev->net->dev_addr, dev->net->perm_addr);
+	eth_hw_addr_set(dev->net, dev->net->perm_addr);
 
 	/* Set Rx urb size */
 	dev->rx_urb_size = URB_SIZE;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 793f8fbe0069..03319fdb5235 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1817,7 +1817,7 @@ static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
 	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
-	ether_addr_copy(dev->net->dev_addr, addr);
+	eth_hw_addr_set(dev->net, addr);
 }
 
 /* MDIO read and write wrappers for phylib */
@@ -2416,7 +2416,7 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ether_addr_copy(netdev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(netdev, addr->sa_data);
 
 	addr_lo = netdev->dev_addr[0] |
 		  netdev->dev_addr[1] << 8 |
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 60ba9b734055..d762462d34f2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1718,7 +1718,7 @@ static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 		return ret;
 
 	if (tp->version == RTL_VER_01)
-		ether_addr_copy(dev->dev_addr, sa.sa_data);
+		eth_hw_addr_set(dev, sa.sa_data);
 	else
 		ret = __rtl8152_set_mac_address(dev, &sa, in_resume);
 
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 85a8b96e39a6..4a84f90e377c 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -421,7 +421,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 	if (bp[0] & 0x02)
 		eth_hw_addr_random(net);
 	else
-		ether_addr_copy(net->dev_addr, bp);
+		eth_hw_addr_set(net, bp);
 
 	/* set a nonzero filter to enable data transfers */
 	memset(u.set, 0, sizeof *u.set);
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 4a1b0e0fc3a3..a8ae395fa26d 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -262,7 +262,7 @@ static void set_ethernet_addr(rtl8150_t *dev)
 	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
 	if (!ret) {
-		ether_addr_copy(dev->netdev->dev_addr, node_id);
+		eth_hw_addr_set(dev->netdev, node_id);
 	} else {
 		eth_hw_addr_random(dev->netdev);
 		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
-- 
2.31.1

