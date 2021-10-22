Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A811437C4D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhJVR6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhJVR6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D2D6128E;
        Fri, 22 Oct 2021 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925347;
        bh=UDm13/DlYX5kxzkXwKMn/jquT/nzW8+8dZTJOc+eL6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P735MVWXdQ+HgPAkfqSfiyJYGN1HSYQLhItoGOTNCiDjiHFQE3p72kHBWrj7LWXn8
         jYy05/SEqAcU+KSTCwIt3U9Kg/KxUwYgwRglylgZ649fkh02sEeNdfEp++kwNnU3C/
         5s8vja570ea42gAedJWazAkSHYUEUpFeEZgGNwNW2q3nHyS2JLmhYwy+smBq/TGj95
         WOYrAYqh+nStNOXAiX+JMScFNWhuCbAM4E5i8Xqf4vfU8xFgwkY5GA4ZuKrnJbOZhK
         01VDs0WRdbW3v3BDjiX4Az7fS4cd7c6a5oK5Pf6V2aBksp8J+/OGcimu4UPMaBLEEK
         PN7J3acvUEhRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: [PATCH net-next 3/8] net: phy: constify netdev->dev_addr references
Date:   Fri, 22 Oct 2021 10:55:38 -0700
Message-Id: <20211022175543.2518732-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022175543.2518732-1-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr will become a const soon(ish),
constify the local variables referring to it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: andrew@lunn.ch
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

