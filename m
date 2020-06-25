Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6234920A24E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405975AbgFYPpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:45:01 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:32969 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405958AbgFYPo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:44:59 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 9C4354000C;
        Thu, 25 Jun 2020 15:44:56 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 6/8] net: phy: mscc: restore the base page in vsc8514/8584_config_init
Date:   Thu, 25 Jun 2020 17:42:09 +0200
Message-Id: <20200625154211.606591-7-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the vsc8584_config_init and vsc8514_config_init, the base page is set
to 'GPIO', configuration is done, and the page is never explicitly
restored to the standard page. No bug was triggered as it turns out
helpers called in those config_init functions do modify the base page,
and set it back to standard. But that is dangerous and any modification
to those functions would introduce bugs. This patch fixes this, to
improve maintenance, by restoring the base page to 'standard' once
'GPIO' accesses are completed.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 03680933f530..f625109df00a 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1395,6 +1395,11 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err;
 
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
+	if (ret)
+		goto err;
+
 	if (!phy_interface_is_rgmii(phydev)) {
 		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
 			PROC_CMD_READ_MOD_WRITE_PORT;
@@ -1779,7 +1784,11 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	val &= ~MAC_CFG_MASK;
 	val |= MAC_CFG_QSGMII;
 	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
+	if (ret)
+		goto err;
 
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
 	if (ret)
 		goto err;
 
-- 
2.26.2

