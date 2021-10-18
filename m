Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B110431FAE
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhJROcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232080AbhJROb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937BF6103B;
        Mon, 18 Oct 2021 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567388;
        bh=mftmT6zjjMxwq3LsXzlOv3GCneYNhz/eTFRFv3Ac++Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n76E39Iut0W5T24PKWytXWpS26Ty31QhL04/KGE1jSoH/8WPjVrMgZSkDQhBY0UFB
         Um5Eiwqzq9U4a6+HjAtSD34RB6M7wRZvIUghZng2DO6XTTbz9pdsEloNr6TkeJZ5+e
         au9lzQA6vOqdrdDX/jo37fepAZo7JaLYE61uYdFyNUAXDAdSv9BXFjuo15COTJP2sD
         Us5/C/cfB8S+sTotrRwxBjc5dtWqPmMXD84+2FiZZAl9PQl4eiLfXo5RHW80BvbAeO
         3sESdqiQMHq8hZZtdVW8ZVze/uJ6ePrMbYVEVl2Ws2XYR4t+5yYcGMwOeBnn0aIRDK
         8RyXbreGJcJRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mlindner@marvell.com, stephen@networkplumber.org
Subject: [PATCH net-next 02/12] ethernet: sky2/skge: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:22 -0700
Message-Id: <20211018142932.1000613-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
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
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mlindner@marvell.com
CC: stephen@networkplumber.org
---
 drivers/net/ethernet/marvell/skge.c | 4 +++-
 drivers/net/ethernet/marvell/sky2.c | 9 ++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index ac48dcca268c..0c864e5bf0a6 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3810,6 +3810,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 {
 	struct skge_port *skge;
 	struct net_device *dev = alloc_etherdev(sizeof(*skge));
+	u8 addr[ETH_ALEN];
 
 	if (!dev)
 		return NULL;
@@ -3862,7 +3863,8 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	}
 
 	/* read the mac address */
-	memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port*8, ETH_ALEN);
+	memcpy_fromio(addr, hw->regs + B2_MAC_1 + port*8, ETH_ALEN);
+	eth_hw_addr_set(dev, addr);
 
 	return dev;
 }
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 0da18b3f1c01..5abb55191e8e 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4721,9 +4721,12 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	 * 2) from internal registers set by bootloader
 	 */
 	ret = of_get_ethdev_address(hw->pdev->dev.of_node, dev);
-	if (ret)
-		memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port * 8,
-			      ETH_ALEN);
+	if (ret) {
+		u8 addr[ETH_ALEN];
+
+		memcpy_fromio(addr, hw->regs + B2_MAC_1 + port * 8, ETH_ALEN);
+		eth_hw_addr_set(dev, addr);
+	}
 
 	/* if the address is invalid, use a random value */
 	if (!is_valid_ether_addr(dev->dev_addr)) {
-- 
2.31.1

