Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F18225583
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgGTBht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:37:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8325 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTBht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 21:37:49 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CAFA99C4923E98903DEA
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:37:45 +0800 (CST)
Received: from huawei.com (10.175.104.82) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 09:37:42 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <netdev@vger.kernel.org>
Subject: [PATCH] net: ag71xx: add missed clk_disable_unprepare in error path of probe
Date:   Sun, 19 Jul 2020 21:46:14 -0400
Message-ID: <20200720014614.11951-1-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ag71xx_mdio_probe() forgets to call clk_disable_unprepare() when
of_reset_control_get_exclusive() failed. Add the missed call to fix it.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 112edbd30823..38cce66ef212 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -556,7 +556,8 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
 	ag->mdio_reset = of_reset_control_get_exclusive(np, "mdio");
 	if (IS_ERR(ag->mdio_reset)) {
 		netif_err(ag, probe, ndev, "Failed to get reset mdio.\n");
-		return PTR_ERR(ag->mdio_reset);
+		err = PTR_ERR(ag->mdio_reset);
+		goto mdio_err_put_clk;
 	}
 
 	mii_bus->name = "ag71xx_mdio";
-- 
2.17.1

