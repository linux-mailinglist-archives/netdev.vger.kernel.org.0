Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB52330128
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 14:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCGNSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 08:18:24 -0500
Received: from aposti.net ([89.234.176.197]:44272 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231289AbhCGNSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 08:18:20 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     od@zcrc.me, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 2/3] net: davicom: Fix regulator not turned off on driver removal
Date:   Sun,  7 Mar 2021 13:17:48 +0000
Message-Id: <20210307131749.14960-2-paul@crapouillou.net>
In-Reply-To: <20210307131749.14960-1-paul@crapouillou.net>
References: <20210307131749.14960-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We must disable the regulator that was enabled in the probe function.

Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/net/ethernet/davicom/dm9000.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index ae744826bb9e..a95e95ce9438 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -133,6 +133,8 @@ struct board_info {
 	u32		wake_state;
 
 	int		ip_summed;
+
+	struct regulator *power_supply;
 };
 
 /* debug code */
@@ -1481,6 +1483,8 @@ dm9000_probe(struct platform_device *pdev)
 
 	db->dev = &pdev->dev;
 	db->ndev = ndev;
+	if (!IS_ERR(power))
+		db->power_supply = power;
 
 	spin_lock_init(&db->lock);
 	mutex_init(&db->addr_lock);
@@ -1766,10 +1770,13 @@ static int
 dm9000_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct board_info *dm = to_dm9000_board(ndev);
 
 	unregister_netdev(ndev);
-	dm9000_release_board(pdev, netdev_priv(ndev));
+	dm9000_release_board(pdev, dm);
 	free_netdev(ndev);		/* free device structure */
+	if (dm->power_supply)
+		regulator_disable(dm->power_supply);
 
 	dev_dbg(&pdev->dev, "released and freed device\n");
 	return 0;
-- 
2.30.1

