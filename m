Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D6500EC
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 07:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfFXFP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 01:15:59 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38442 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFXFP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 01:15:59 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5O5FrXK026815;
        Mon, 24 Jun 2019 00:15:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561353353;
        bh=PofutAHSNf3VInOdjB75/tzlJ8kFqqMgjpO4KBqkvfI=;
        h=From:To:CC:Subject:Date;
        b=Q1SlhMNwYdOsVxxJL6lCiw4Ca03MWQfdgzodjAFq/vkUYyJMWdvGlh4dOjap+S8/U
         OAsxF1sKPKD21iXGJ057RCeP5K+W6n3zy59f9aHS2eMfWOp3GARjBfAg6fgU0PnbU9
         QpstzW6vqoIMbgtovir7nETXjrpBLZsXakkRXIpM=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5O5FrbL109350
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Jun 2019 00:15:53 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 24
 Jun 2019 00:15:52 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 24 Jun 2019 00:15:52 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5O5FnOM000902;
        Mon, 24 Jun 2019 00:15:49 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <davem@davemloft.net>, <ivan.khoronzhuk@linaro.org>,
        <andrew@lunn.ch>, <ilias.apalodimas@linaro.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <grygorii.strashko@ti.com>, <nsekhar@ti.com>
Subject: [PATCH V2] net: ethernet: ti: cpsw: Fix suspend/resume break
Date:   Mon, 24 Jun 2019 10:46:19 +0530
Message-ID: <20190624051619.20146-1-j-keerthy@ti.com>
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

Change in v2:

  * Added NULL Checks for cpsw->slaves[i].ndev in suspend/resume functions.

 drivers/net/ethernet/ti/cpsw.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 7bdd287074fc..32b7b3b74a6b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2590,20 +2590,13 @@ static int cpsw_remove(struct platform_device *pdev)
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
+	for (i = 0; i < cpsw->data.slaves; i++)
+		if (cpsw->slaves[i].ndev)
 			if (netif_running(cpsw->slaves[i].ndev))
 				cpsw_ndo_stop(cpsw->slaves[i].ndev);
-		}
-	} else {
-		if (netif_running(ndev))
-			cpsw_ndo_stop(ndev);
-	}
 
 	/* Select sleep pin state */
 	pinctrl_pm_select_sleep_state(dev);
@@ -2613,25 +2606,20 @@ static int cpsw_suspend(struct device *dev)
 
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
+	for (i = 0; i < cpsw->data.slaves; i++)
+		if (cpsw->slaves[i].ndev)
 			if (netif_running(cpsw->slaves[i].ndev))
 				cpsw_ndo_open(cpsw->slaves[i].ndev);
-		}
-	} else {
-		if (netif_running(ndev))
-			cpsw_ndo_open(ndev);
-	}
+
 	rtnl_unlock();
 
 	return 0;
-- 
2.17.1

