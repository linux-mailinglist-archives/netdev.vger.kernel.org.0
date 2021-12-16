Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F83477228
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhLPMsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhLPMsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:48:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A6AC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IKd5GShwphezaVUjaTKVyfSZx+DRtGx674nuaqCtyuY=; b=2B/gDAo6uIitlweNt3Lswh6Z+B
        BYCzqzkgYQknVGBFwL7Ldd4roSch5FPAaEfl8tjVNt15JMiICIjSz/CQtsOoDVinpJeFvxdzOG/J2
        waY6lKv3hN+kYyTr798kPzJQHPkw6AMRbawW9wT1JwsI2yx+YvMMwMPic6VJBrmlEhWOuaAw2SrHH
        d1HDSMbrfnA/vKmd+YocvVaie9FgmGFks2NF2wKzCHbCs3BAc/4Dp+b8drPnAXdh92H+Ozk/p666p
        UeCoztiOHnH0PrgCVdZRSa1mMuJZBHQpw0uHhzuTzV3qqrGkXsnxJnZDxslyo6XoVhuLTbRWFMIHI
        JpnmnVeg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49830 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqBm-0007pK-Md; Thu, 16 Dec 2021 12:48:50 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxqBm-00GWxu-8y; Thu, 16 Dec 2021 12:48:50 +0000
In-Reply-To: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH CFT net-next 2/2] net: axienet: replace mdiobus_write() with
 mdiodev_write()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxqBm-00GWxu-8y@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 16 Dec 2021 12:48:50 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 197a68ef1837 ("net: mdio: Add helper functions for accessing
MDIO devices") added support for mdiodev accessor operations that
neatly wrap the mdiobus accessor operations. Since we are dealing with
a mdio device here, update the driver to use mdiodev_write().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5edc8ec72317..ac23d1c65ac8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1543,8 +1543,7 @@ static int axienet_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	if (!lp->switch_x_sgmii)
 		return 0;
 
-	ret = mdiobus_write(pcs_phy->bus, pcs_phy->addr,
-			    XLNX_MII_STD_SELECT_REG,
+	ret = mdiodev_write(pcs_phy, XLNX_MII_STD_SELECT_REG,
 			    interface == PHY_INTERFACE_MODE_SGMII ?
 				XLNX_MII_STD_SELECT_SGMII : 0);
 	if (ret < 0) {
-- 
2.30.2

