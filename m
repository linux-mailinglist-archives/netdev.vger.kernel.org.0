Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0035112250A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfLQGvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:51:50 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54371 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfLQGvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:51:50 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ih6hw-000809-Bf; Tue, 17 Dec 2019 07:51:48 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ih6hu-0002RK-JU; Tue, 17 Dec 2019 07:51:46 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: ag71xx: fix compile warnings
Date:   Tue, 17 Dec 2019 07:51:45 +0100
Message-Id: <20191217065145.9329-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
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

drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_probe':
drivers/net/ethernet/atheros/ag71xx.c:1776:30: warning: passing argument 2 of
 'of_get_phy_mode' makes pointer from integer without a cast [-Wint-conversion]
In file included from drivers/net/ethernet/atheros/ag71xx.c:33:
./include/linux/of_net.h:15:69: note: expected 'phy_interface_t *'
 {aka 'enum <anonymous> *'} but argument is of type 'int'

Fixes: 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2
- rabase against net

 drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 8f5021091eee..61a334d1b5e6 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -313,7 +313,7 @@ struct ag71xx {
 	struct ag71xx_desc *stop_desc;
 	dma_addr_t stop_desc_dma;
 
-	int phy_if_mode;
+	phy_interface_t phy_if_mode;
 
 	struct delayed_work restart_work;
 	struct timer_list oom_timer;
@@ -1744,7 +1744,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 		eth_random_addr(ndev->dev_addr);
 	}
 
-	err = of_get_phy_mode(np, ag->phy_if_mode);
+	err = of_get_phy_mode(np, &ag->phy_if_mode);
 	if (err) {
 		netif_err(ag, probe, ndev, "missing phy-mode property in DT\n");
 		goto err_free;
-- 
2.24.0

