Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382C7C2D95
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 08:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbfJAGlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 02:41:53 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39737 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfJAGlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 02:41:53 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBr5-0001Sm-4O; Tue, 01 Oct 2019 08:41:51 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFBr3-0006A0-Db; Tue, 01 Oct 2019 08:41:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ag71xx: fix mdio subnode support
Date:   Tue,  1 Oct 2019 08:41:47 +0200
Message-Id: <20191001064147.23633-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is syncing driver with actual devicetree documentation:
Documentation/devicetree/bindings/net/qca,ar71xx.txt
|Optional subnodes:
|- mdio : specifies the mdio bus, used as a container for phy nodes
|  according to phy.txt in the same directory

The driver was working with fixed phy without any noticeable issues. This bug
was uncovered by introducing dsa ar9331-switch driver.
Since no one reported this bug until now, I assume no body is using it
and this patch should not brake existing system.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 6703960c7cf5..d1101eea15c2 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -526,7 +526,7 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
 	struct device *dev = &ag->pdev->dev;
 	struct net_device *ndev = ag->ndev;
 	static struct mii_bus *mii_bus;
-	struct device_node *np;
+	struct device_node *np, *mnp;
 	int err;
 
 	np = dev->of_node;
@@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
 		msleep(200);
 	}
 
-	err = of_mdiobus_register(mii_bus, np);
+	mnp = of_get_child_by_name(np, "mdio");
+	err = of_mdiobus_register(mii_bus, mnp);
+	of_node_put(mnp);
 	if (err)
 		goto mdio_err_put_clk;
 
-- 
2.23.0

