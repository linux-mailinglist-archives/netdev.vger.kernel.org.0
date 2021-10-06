Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420E04241B0
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhJFPrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239271AbhJFPq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E876E61183;
        Wed,  6 Oct 2021 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535105;
        bh=amm2W81bjMFkcgl3uXAbyPMfb/di6QRiVPROWYOEzUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1ps9sG//AikpjaI5iWskMUL0dNmY+9Kg8iyj4HjVzSyf5K0EUSCZL9ZuSjrC9Xsa
         d9xuSSPpyG3ip7caxZGTTGZN1N5Ady+h7YDoZ3FdWXVDxMbBOQFJTZGoMfhEzMDzxt
         LNFakXzI9W/ulpfeKtq8g6ERntVEKGAR/RBYNRc3piLXwiI3jOuYc9vzYZ1n4Dw9xn
         Dv4fSC72i9f5R87UmZJk1f/awlhsRsgQSQJfXzlnFCQKofu7uXfHX7OG/+QWfvaEzm
         Q5nrxFOO73DTYRTmh6JzC0lk9Wh2gO4ADueR52luWCS5cDsXLDd9IH2LATmv9HUlP0
         EAXVK1nitGr/w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        andrew@lunn.ch, jeremy.linton@arm.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 8/9] ethernet: use device_get_ethdev_address()
Date:   Wed,  6 Oct 2021 08:44:25 -0700
Message-Id: <20211006154426.3222199-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006154426.3222199-1-kuba@kernel.org>
References: <20211006154426.3222199-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new device_get_ethdev_address() helper for the cases
where dev->dev_addr is passed in directly as the destination.

  @@
  expression dev, np;
  @@
  - device_get_mac_address(np, dev->dev_addr, ETH_ALEN)
  + device_get_ethdev_address(np, dev)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/apm/xgene-v2/main.c         | 2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index d1ebd153b7a8..d022b6db9e06 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
 		return -ENOMEM;
 	}
 
-	if (device_get_mac_address(dev, ndev->dev_addr))
+	if (device_get_ethdev_address(dev, ndev))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 4a5bf13ffae2..220dc42af31a 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1731,7 +1731,7 @@ static int xgene_enet_get_resources(struct xgene_enet_pdata *pdata)
 		xgene_get_port_id_acpi(dev, pdata);
 #endif
 
-	if (device_get_mac_address(dev, ndev->dev_addr))
+	if (device_get_ethdev_address(dev, ndev))
 		eth_hw_addr_random(ndev);
 
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e61b687d33ba..83c55e7b099f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4084,7 +4084,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	if (pd && !IS_ERR_OR_NULL(pd->mac_address))
 		eth_hw_addr_set(dev, pd->mac_address);
 	else
-		if (device_get_mac_address(&pdev->dev, dev->dev_addr))
+		if (device_get_ethdev_address(&pdev->dev, dev))
 			if (has_acpi_companion(&pdev->dev))
 				bcmgenet_get_hw_addr(priv, dev->dev_addr);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 1195f64fb161..22a463e15678 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1212,7 +1212,7 @@ static void hns_init_mac_addr(struct net_device *ndev)
 {
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 
-	if (device_get_mac_address(priv->dev, ndev->dev_addr)) {
+	if (device_get_ethdev_address(priv->dev, ndev)) {
 		eth_hw_addr_random(ndev);
 		dev_warn(priv->dev, "No valid mac, use random mac %pM",
 			 ndev->dev_addr);
-- 
2.31.1

