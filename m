Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C55424B82
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhJGBJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240177AbhJGBJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1D226121F;
        Thu,  7 Oct 2021 01:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568837;
        bh=amm2W81bjMFkcgl3uXAbyPMfb/di6QRiVPROWYOEzUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNa+woDb9eCNq4GV4GHWs//CvTYbZy862OyRdY5Boply8Z0LKIu0XEKx/vpHmmxHp
         IgZs1EE08MJDdzl3F7x1xRZXv46O62MO+TGvOEp19SR+RI5tKUq1TJZTrO4UJhfADl
         WgWXmVKw2NeBU6Naz90vnuo+QWmPE8XS2UDunLVCoVM8e9+vMvWzZCCBe2CdhWEpg/
         hVRsklZ/qXb5xbHUrIX95G1IIK47X/6GAGBssvpzDduYWXhpe00weMrYXDnRN3gH2F
         W5xBhfpeCs/fblDaEbmXZKLuIxUPoRu024nXyLcSx/PkXAysIEhYkp3vMoe9A0StKT
         zBFUE+A7MNHFQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 8/9] ethernet: use device_get_ethdev_address()
Date:   Wed,  6 Oct 2021 18:07:01 -0700
Message-Id: <20211007010702.3438216-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007010702.3438216-1-kuba@kernel.org>
References: <20211007010702.3438216-1-kuba@kernel.org>
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

