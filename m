Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277CE48030B
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhL0Rvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 12:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhL0Rvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 12:51:53 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E631C06173E;
        Mon, 27 Dec 2021 09:51:53 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n1uA3-00009b-PP; Mon, 27 Dec 2021 18:51:51 +0100
Date:   Mon, 27 Dec 2021 17:51:46 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 1/2] net: mtk_eth_soc: fix return value of MDIO operations
Message-ID: <Ycn9Ml7VCgUI3eha@makrotopia.org>
References: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcnlMtninjjjPhjI@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
 <YcnlMtninjjjPhjI@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of returning -1 (-EPERM) when MDIO bus is stuck busy
while writing or 0xffff if it happens while reading, return the
appropriate -EBUSY. Also fix return type to int instead of u32.

Fixes: 656e705243fd0 ("net-next: mediatek: add support for MT7623 ethernet")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: clean-up return values and types, split into two commits
v3: return -1 instead of 0xffff on error in _mtk_mdio_write
v2: use MII_DEVADDR_C45_SHIFT and MII_REGADDR_C45_MASK to extract
    device id and register address. Unify read and write functions to
    have identical types and parameter names where possible as we are
    anyway already replacing both function bodies.

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bcb91b01e69f5..0bf8d0a3b1781 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -94,11 +94,11 @@ static int mtk_mdio_busy_wait(struct mtk_eth *eth)
 	return -1;
 }
 
-static u32 _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr,
-			   u32 phy_register, u32 write_data)
+static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
+			   u32 write_data)
 {
 	if (mtk_mdio_busy_wait(eth))
-		return -1;
+		return -EBUSY;
 
 	write_data &= 0xffff;
 
@@ -108,17 +108,17 @@ static u32 _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr,
 		MTK_PHY_IAC);
 
 	if (mtk_mdio_busy_wait(eth))
-		return -1;
+		return -EBUSY;
 
 	return 0;
 }
 
-static u32 _mtk_mdio_read(struct mtk_eth *eth, int phy_addr, int phy_reg)
+static int _mtk_mdio_read(struct mtk_eth *eth, int phy_addr, int phy_reg)
 {
 	u32 d;
 
 	if (mtk_mdio_busy_wait(eth))
-		return 0xffff;
+		return -EBUSY;
 
 	mtk_w32(eth, PHY_IAC_ACCESS | PHY_IAC_START | PHY_IAC_READ |
 		(phy_reg << PHY_IAC_REG_SHIFT) |
@@ -126,7 +126,7 @@ static u32 _mtk_mdio_read(struct mtk_eth *eth, int phy_addr, int phy_reg)
 		MTK_PHY_IAC);
 
 	if (mtk_mdio_busy_wait(eth))
-		return 0xffff;
+		return -EBUSY;
 
 	d = mtk_r32(eth, MTK_PHY_IAC) & 0xffff;
 
-- 
2.34.1

