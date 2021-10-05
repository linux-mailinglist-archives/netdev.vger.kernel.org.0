Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F82422D0E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhJEPz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236285AbhJEPzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A376152B;
        Tue,  5 Oct 2021 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633449210;
        bh=bKxMQsBjb9seTBeb1QmNAyPS4QTm0tBaaNCJlH7kbvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMmc1NwBOYqok5HGm/XHRZXq0FH4HqIRkk+m2xh3uHZZcUAmN1rePeTFBi20Dxfuc
         pLt197Py7W+kRkWd7zrkYJSEkTTC5vNRYyoUz4LOK135aU+R8vIEjvwmFVrZKLrtCg
         a3tVn5DtIBkSX6LY+TajV/zSPteY95zrJEe8HmW2Ow8sPrg+ocaSUJF/KglvF3h21b
         ZgAeIiASuxtPMX9lvFWTwJ3z3tJVIinrv0L+mS+9WsReozvGBLLEettNW7aml+ICYH
         dKYCBJQix4gxu4RQ/Mpemjd1+ulx3vPvyne9YMt6SGZN98c4D5FEaK2WEgZo8Fu4t6
         aFBikZpDPfVhw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] ethernet: use device_get_ethdev_addr()
Date:   Tue,  5 Oct 2021 08:53:21 -0700
Message-Id: <20211005155321.2966828-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005155321.2966828-1-kuba@kernel.org>
References: <20211005155321.2966828-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new device_get_ethdev_addr() helper for the cases
where dev->dev_addr is passed in directly as the destination.

  @@
  expression dev, np;
  @@
  - device_get_mac_address(np, dev->dev_addr, ETH_ALEN)
  + device_get_ethdev_addr(np, dev)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/apm/xgene-v2/main.c         | 2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 80399c8980bd..119e488979f9 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
 		return -ENOMEM;
 	}
 
-	if (!device_get_mac_address(dev, ndev->dev_addr, ETH_ALEN))
+	if (!device_get_ethdev_addr(dev, ndev))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582d74..111cd88984c9 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1731,7 +1731,7 @@ static int xgene_enet_get_resources(struct xgene_enet_pdata *pdata)
 		xgene_get_port_id_acpi(dev, pdata);
 #endif
 
-	if (!device_get_mac_address(dev, ndev->dev_addr, ETH_ALEN))
+	if (!device_get_ethdev_addr(dev, ndev))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 02fe98cbabb0..541763968201 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4084,7 +4084,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (pd && !IS_ERR_OR_NULL(pd->mac_address))
 		eth_hw_addr_set(dev, pd->mac_address);
 	else
-		if (!device_get_mac_address(&pdev->dev, dev->dev_addr, ETH_ALEN))
+		if (!device_get_ethdev_addr(&pdev->dev, dev))
 			if (has_acpi_companion(&pdev->dev))
 				bcmgenet_get_hw_addr(priv, dev->dev_addr);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 2c4801e49aa1..f4ed877e16e9 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1212,7 +1212,7 @@ static void hns_init_mac_addr(struct net_device *ndev)
 {
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 
-	if (!device_get_mac_address(priv->dev, ndev->dev_addr, ETH_ALEN)) {
+	if (!device_get_ethdev_addr(priv->dev, ndev)) {
 		eth_hw_addr_random(ndev);
 		dev_warn(priv->dev, "No valid mac, use random mac %pM",
 			 ndev->dev_addr);
-- 
2.31.1

