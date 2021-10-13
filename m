Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5493142CB49
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhJMUrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229883AbhJMUqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFB306054F;
        Wed, 13 Oct 2021 20:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157886;
        bh=b7Xeducws/UaOpNTMfp/BTLm1lq6kmNWY34fXLn1eQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQ9WVerXeI2PhKbkCQlxAFvBzAo+4SEQFXYUU4sipx6sOhyg4znPIYuevc4/ifUDB
         CNthx1Wa7chLWLqFpxofz5dcKnQbxpM+5kcP3e6SRJfSv8TXWQOHUpI4tf38SRK/As
         UHsVdb+YT83mCVkk0RraQasAw1AFFFgyCJZnHm+tOfeA+BZuEXadbP1ZTBsmUXJRcZ
         T+Y6cgFIiZNevsRgNxZyYvJkW1cx1CrLrg4v7Vc2H8D5urxj92YLe/57HmCRhBj8hJ
         o3/1MWMk21pM0lGHJ4AVlGL4I16XjBi+o1JJERbm6aAJnDVfJYrknOmQ1oLQJwMass
         HBGNjFGGdGQPg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        f.fainelli@gmail.com, petkan@nucleusys.com,
        christophe.jaillet@wanadoo.fr, zhangchangzhong@huawei.com,
        linux-usb@vger.kernel.org
Subject: [PATCH net-next 4/7] ethernet: manually convert memcpy(dev_addr,..., sizeof(addr))
Date:   Wed, 13 Oct 2021 13:44:32 -0700
Message-Id: <20211013204435.322561-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A handful of drivers use sizeof(addr) for the size of
the address, after manually confirming the size is
indeed 6 convert them to eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nicolas.ferre@microchip.com
CC: claudiu.beznea@microchip.com
CC: f.fainelli@gmail.com
CC: petkan@nucleusys.com
CC: christophe.jaillet@wanadoo.fr
CC: zhangchangzhong@huawei.com
CC: linux-usb@vger.kernel.org
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 drivers/net/ethernet/dnet.c              | 2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c | 2 +-
 drivers/net/ethernet/ti/cpmac.c          | 2 +-
 drivers/net/usb/pegasus.c                | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 683f14665c2c..029dea2873e3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -313,7 +313,7 @@ static void macb_get_hwaddr(struct macb *bp)
 		addr[5] = (top >> 8) & 0xff;
 
 		if (is_valid_ether_addr(addr)) {
-			memcpy(bp->dev->dev_addr, addr, sizeof(addr));
+			eth_hw_addr_set(bp->dev, addr);
 			return;
 		}
 	}
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 3ed21ba4eb99..92462ed87bc4 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -93,7 +93,7 @@ static void dnet_get_hwaddr(struct dnet *bp)
 	*((__be16 *)(addr + 4)) = cpu_to_be16(tmp);
 
 	if (is_valid_ether_addr(addr))
-		memcpy(bp->dev->dev_addr, addr, sizeof(addr));
+		eth_hw_addr_set(bp->dev, addr);
 }
 
 static int dnet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 5512e43bafc1..f0ace3a0e85c 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1722,7 +1722,7 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = -ENODEV;
 		goto out;
 	}
-	memcpy(dev->dev_addr, mac->mac_addr, sizeof(mac->mac_addr));
+	eth_hw_addr_set(dev, mac->mac_addr);
 
 	ret = mac_to_intf(mac);
 	if (ret < 0) {
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index 02d4e51f7306..7449436fc87c 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -1112,7 +1112,7 @@ static int cpmac_probe(struct platform_device *pdev)
 	priv->dev = dev;
 	priv->ring_size = 64;
 	priv->msg_enable = netif_msg_init(debug_level, 0xff);
-	memcpy(dev->dev_addr, pdata->dev_addr, sizeof(pdata->dev_addr));
+	eth_hw_addr_set(dev, pdata->dev_addr);
 
 	snprintf(priv->phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT,
 						mdio_bus_id, phy_id);
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 6a92a3fef75e..c4cd40b090fd 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -357,7 +357,7 @@ static void set_ethernet_addr(pegasus_t *pegasus)
 			goto err;
 	}
 
-	memcpy(pegasus->net->dev_addr, node_id, sizeof(node_id));
+	eth_hw_addr_set(pegasus->net, node_id);
 
 	return;
 err:
-- 
2.31.1

