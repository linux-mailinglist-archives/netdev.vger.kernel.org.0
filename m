Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94519438090
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhJVXX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhJVXX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B576103E;
        Fri, 22 Oct 2021 23:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944869;
        bh=T6oH2GJ4sf0fe+SV9dhJRJFj/5oCy3Rx/vCk36oy6Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uv/vNA1KI5XTqcUqW8dTAmzJv8Gq5zrFCqINLENGYnqIiDLhQ4PhGDbOcgsxujcbK
         FfJxoFCkkmp177VYXzDvCJKNQOyIxloU//k5Ba/KMo/FNB68P0MzA+4i6X2vW7Ibge
         9J9so7fSugMHNqRvLf7pCFToYD3zA7q7C0KcIu86sVFuy+38Dkdg4aCpJQxwRqzKp0
         o8SHQXvj5mqNyUN38SAbtuRTC7s2qdUNaTl+eUJNuGbBvrWexFYcrs5W3TiYIg1t5U
         oX0fd7BZwwe1l8kpAFDsuYzpp2R+hwKhfJ+22jg9A0ca6b32P06ASaW4leoM9NeDcT
         jwBS8Gg3ELE9A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: [PATCH net-next v2 3/8] net: phy: constify netdev->dev_addr references
Date:   Fri, 22 Oct 2021 16:20:58 -0700
Message-Id: <20211022232103.2715312-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr will become a const soon(ish),
constify the local variables referring to it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: hkallweit1@gmail.com
CC: linux@armlinux.org.uk
---
 drivers/net/phy/dp83867.c | 4 ++--
 drivers/net/phy/dp83869.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 914619f3f0e3..8561f2d4443b 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -182,7 +182,7 @@ static int dp83867_set_wol(struct phy_device *phydev,
 {
 	struct net_device *ndev = phydev->attached_dev;
 	u16 val_rxcfg, val_micr;
-	u8 *mac;
+	const u8 *mac;
 
 	val_rxcfg = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
 	val_micr = phy_read(phydev, MII_DP83867_MICR);
@@ -193,7 +193,7 @@ static int dp83867_set_wol(struct phy_device *phydev,
 		val_micr |= MII_DP83867_MICR_WOL_INT_EN;
 
 		if (wol->wolopts & WAKE_MAGIC) {
-			mac = (u8 *)ndev->dev_addr;
+			mac = (const u8 *)ndev->dev_addr;
 
 			if (!is_valid_ether_addr(mac))
 				return -EINVAL;
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 755220c6451f..7113925606f7 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -246,7 +246,7 @@ static int dp83869_set_wol(struct phy_device *phydev,
 {
 	struct net_device *ndev = phydev->attached_dev;
 	int val_rxcfg, val_micr;
-	u8 *mac;
+	const u8 *mac;
 	int ret;
 
 	val_rxcfg = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
@@ -264,7 +264,7 @@ static int dp83869_set_wol(struct phy_device *phydev,
 
 		if (wol->wolopts & WAKE_MAGIC ||
 		    wol->wolopts & WAKE_MAGICSECURE) {
-			mac = (u8 *)ndev->dev_addr;
+			mac = (const u8 *)ndev->dev_addr;
 
 			if (!is_valid_ether_addr(mac))
 				return -EINVAL;
-- 
2.31.1

