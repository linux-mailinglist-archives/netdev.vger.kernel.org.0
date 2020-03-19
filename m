Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE318B3BC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 13:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCSMuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 08:50:06 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:58459 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCSMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 08:50:06 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 457001BF210;
        Thu, 19 Mar 2020 12:50:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: mscc: add missing check on a phy_write return value
Date:   Thu, 19 Mar 2020 13:48:19 +0100
Message-Id: <20200319124819.369431-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
introduced a call to 'phy_write' storing its return value to a variable
called 'ret'. But 'ret' never was checked for a possible error being
returned, and hence was not used at all. Fix this by checking the return
value and exiting the function if an error was returned.

As this does not fix a known bug, this commit is mostly cosmetic and not
sent as a fix.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 2f6229a70ec1..bc6beec8aff0 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1411,6 +1411,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	val |= (MEDIA_OP_MODE_COPPER << MEDIA_OP_MODE_POS) |
 	       (VSC8584_MAC_IF_SELECTION_SGMII << VSC8584_MAC_IF_SELECTION_POS);
 	ret = phy_write(phydev, MSCC_PHY_EXT_PHY_CNTL_1, val);
+	if (ret)
+		return ret;
 
 	ret = genphy_soft_reset(phydev);
 	if (ret)
-- 
2.25.1

