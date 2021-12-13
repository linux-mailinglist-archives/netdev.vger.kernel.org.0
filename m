Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36265472AD3
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 12:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhLMLFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 06:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhLMLFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 06:05:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8B6C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 03:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gYnr8xI9dS+Md6MclwatJo3HcS+j4NQAGL+9xOFx3oM=; b=CUP/6kq2YBP4iGsHWm6WTg6ufv
        E3FDuZqY826Z0ooLZxjYKpj0BwuMeDPg55V10PxxfsprfaB6ALIrni2XQ84S0vd7O7P5Wdxuv67Ud
        wYbyuFCZYCzOxagZAjTsWDhxJjEojfxET1v9IxEERGjZf9K4ftw5kLtqltc/7TKIcVvwZG+swzfsG
        5ru0U+Dr3kaPBeg7kmoFU0HU8gZfNH8uHE9ayG7JIZtgXLgBwn90S/LNpTV+09klnQK/EUC5DWMpj
        /VizQcsrLr/u/UJQ6hr79K80PRgQVfIIOaCClLj0s+CBm+Q05ZlsrHpLYBLjRwdGuLbE9NUjHx09p
        Xf0yPc+A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48604 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mwj8s-0003Uh-0Z; Mon, 13 Dec 2021 11:05:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mwj8r-00FjNH-Ix; Mon, 13 Dec 2021 11:05:13 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: phy: add a note about refcounting
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mwj8r-00FjNH-Ix@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Dec 2021 11:05:13 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, a patch has been submitted to "fix" the refcounting for a DT
node in of_mdiobus_link_mdiodev(). This is not a leaked refcount. The
refcount is passed to the new device.

Sadly, coccicheck identifies this location as a leaked refcount, which
means we're likely to keep getting patches to "fix" this. However,
fixing this will cause breakage. Add a comment to state that the lack
of of_node_put() here is intentional.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c204067f1890..c198722e4871 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -460,6 +460,9 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
 
 		if (addr == mdiodev->addr) {
 			device_set_node(dev, of_fwnode_handle(child));
+			/* The refcount on "child" is passed to the mdio
+			 * device. Do _not_ use of_node_put(child) here.
+			 */
 			return;
 		}
 	}
-- 
2.30.2

