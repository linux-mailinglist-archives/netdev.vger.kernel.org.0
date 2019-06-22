Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538E04F541
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 12:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVKb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 06:31:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53146 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVKb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 06:31:29 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5MAVNZu115713;
        Sat, 22 Jun 2019 05:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561199483;
        bh=uDe+FR8Zd9ngSnZKWDhm7Os0jR27zlCvta/tILCC0cI=;
        h=From:To:CC:Subject:Date;
        b=BbwQbNdTl8cAaduEfRY8AVllzO0xenEQcQ5vY5Jb+HwOC4gdX72uep46z2FvLh1No
         1OypWwLm+Uv7KttKTwyUdLZWDjjA7dSuLirE/dRpGP5hUD3goEieXuXluT2htaPPAt
         GV5KTpoDmQUBPOLh7Tvc6HVY4H0NWb8bIx8WcTRQ=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5MAVN7c056948
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 22 Jun 2019 05:31:23 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 22
 Jun 2019 05:31:22 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Sat, 22 Jun 2019 05:31:22 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5MAVI6x092958;
        Sat, 22 Jun 2019 05:31:19 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <davem@davemloft.net>, <ivan.khoronzhuk@linaro.org>,
        <andrew@lunn.ch>, <ilias.apalodimas@linaro.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <grygorii.strashko@ti.com>, <nsekhar@ti.com>
Subject: [PATCH] net: ethernet: ti: cpsw: Fix suspend/resume break
Date:   Sat, 22 Jun 2019 16:01:40 +0530
Message-ID: <20190622103140.22902-1-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bfe59032bd6127ee190edb30be9381a01765b958 ("net: ethernet:
ti: cpsw: use cpsw as drv data")changes
the driver data to struct cpsw_common *cpsw. This is done
only in probe/remove but the suspend/resume functions are
still left with struct net_device *ndev. Hence fix both
suspend & resume also to fetch the updated driver data.

Fixes: bfe59032bd6127ee1 ("net: ethernet: ti: cpsw: use cpsw as drv data")
Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c | 36 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 7bdd287074fc..2aeaad15e20e 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2590,20 +2590,12 @@ static int cpsw_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int cpsw_suspend(struct device *dev)
 {
-	struct net_device	*ndev = dev_get_drvdata(dev);
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
-
-	if (cpsw->data.dual_emac) {
-		int i;
+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
+	int i;
 
-		for (i = 0; i < cpsw->data.slaves; i++) {
-			if (netif_running(cpsw->slaves[i].ndev))
-				cpsw_ndo_stop(cpsw->slaves[i].ndev);
-		}
-	} else {
-		if (netif_running(ndev))
-			cpsw_ndo_stop(ndev);
-	}
+	for (i = 0; i < cpsw->data.slaves; i++)
+		if (netif_running(cpsw->slaves[i].ndev))
+			cpsw_ndo_stop(cpsw->slaves[i].ndev);
 
 	/* Select sleep pin state */
 	pinctrl_pm_select_sleep_state(dev);
@@ -2613,25 +2605,19 @@ static int cpsw_suspend(struct device *dev)
 
 static int cpsw_resume(struct device *dev)
 {
-	struct net_device	*ndev = dev_get_drvdata(dev);
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
+	struct cpsw_common *cpsw = dev_get_drvdata(dev);
+	int i;
 
 	/* Select default pin state */
 	pinctrl_pm_select_default_state(dev);
 
 	/* shut up ASSERT_RTNL() warning in netif_set_real_num_tx/rx_queues */
 	rtnl_lock();
-	if (cpsw->data.dual_emac) {
-		int i;
 
-		for (i = 0; i < cpsw->data.slaves; i++) {
-			if (netif_running(cpsw->slaves[i].ndev))
-				cpsw_ndo_open(cpsw->slaves[i].ndev);
-		}
-	} else {
-		if (netif_running(ndev))
-			cpsw_ndo_open(ndev);
-	}
+	for (i = 0; i < cpsw->data.slaves; i++)
+		if (netif_running(cpsw->slaves[i].ndev))
+			cpsw_ndo_open(cpsw->slaves[i].ndev);
+
 	rtnl_unlock();
 
 	return 0;
-- 
2.17.1

