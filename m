Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5BE20A242
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406014AbgFYPpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:45:06 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:39449 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405972AbgFYPpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:45:01 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 2DC8B100003;
        Thu, 25 Jun 2020 15:44:58 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 8/8] net: phy: mscc: improve vsc8514/8584_config_init consistency
Date:   Thu, 25 Jun 2020 17:42:11 +0200
Message-Id: <20200625154211.606591-9-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All PHY read and write return values are checked for errors in
vsc8514_config_init and vsc8584_config_init, except for one. Fix this.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 04e1ef791cec..a4fbf3a4fa97 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1375,8 +1375,10 @@ static int vsc8584_config_init(struct phy_device *phydev)
 			goto err;
 	}
 
-	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
-		       MSCC_PHY_PAGE_EXTENDED_GPIO);
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_EXTENDED_GPIO);
+	if (ret)
+		goto err;
 
 	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
 	val &= ~MAC_CFG_MASK;
@@ -1774,8 +1776,10 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	if (phy_package_init_once(phydev))
 		vsc8514_config_pre_init(phydev);
 
-	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
-		       MSCC_PHY_PAGE_EXTENDED_GPIO);
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_EXTENDED_GPIO);
+	if (ret)
+		goto err;
 
 	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
 
-- 
2.26.2

