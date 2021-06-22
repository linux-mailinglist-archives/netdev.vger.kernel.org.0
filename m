Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D283B0797
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhFVOlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:41:31 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57896 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhFVOl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:41:29 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15MEd9bv115361;
        Tue, 22 Jun 2021 09:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1624372749;
        bh=pX524DLJ3gUOuQ9Oo40V4tqELYtuI9IJaaiV3BjmlWA=;
        h=From:To:CC:Subject:Date;
        b=cpopWtcYhWsJ6klDFnV41gTb/U4bvJNsu1ofSZ+FrVGhyZcEabNskaypO4KdkOcBk
         s8NqqTqGUc8+cbRaV0KEQEc9lBj/+dS9Bcg4lBZlmwyOvdib45E64pIGQs6c9dIb+O
         Ac9YE/mhZ0tTmKwiXb1y8XVXuuIK7To1pJwyL2Pc=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15MEd91P044007
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Jun 2021 09:39:09 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 22
 Jun 2021 09:39:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 22 Jun 2021 09:39:09 -0500
Received: from ula0132425.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15MEd6e5004168;
        Tue, 22 Jun 2021 09:39:07 -0500
From:   Vignesh Raghavendra <vigneshr@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues
Date:   Tue, 22 Jun 2021 20:08:57 +0530
Message-ID: <20210622143857.21682-1-vigneshr@ti.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When changing number of TX queues using ethtool:

	# ethtool -L eth0 tx 1
	[  135.301047] Unable to handle kernel paging request at virtual address 00000000af5d0000
	[...]
	[  135.525128] Call trace:
	[  135.525142]  dma_release_from_dev_coherent+0x2c/0xb0
	[  135.525148]  dma_free_attrs+0x54/0xe0
	[  135.525156]  k3_cppi_desc_pool_destroy+0x50/0xa0
	[  135.525164]  am65_cpsw_nuss_remove_tx_chns+0x88/0xdc
	[  135.525171]  am65_cpsw_set_channels+0x3c/0x70
	[...]

This is because k3_cppi_desc_pool_destroy() which is called after
k3_udma_glue_release_tx_chn() in am65_cpsw_nuss_remove_tx_chns()
references struct device that is unregistered at the end of
k3_udma_glue_release_tx_chn()

Therefore the right order is to call k3_cppi_desc_pool_destroy() and
destroy desc pool before calling k3_udma_glue_release_tx_chn().
Fix this throughout the driver.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6a67b026df0b..718539cdd2f2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1506,12 +1506,12 @@ static void am65_cpsw_nuss_free_tx_chns(void *data)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
-			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
-
 		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
 			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
 
+		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
 		memset(tx_chn, 0, sizeof(*tx_chn));
 	}
 }
@@ -1531,12 +1531,12 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 
 		netif_napi_del(&tx_chn->napi_tx);
 
-		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
-			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
-
 		if (!IS_ERR_OR_NULL(tx_chn->desc_pool))
 			k3_cppi_desc_pool_destroy(tx_chn->desc_pool);
 
+		if (!IS_ERR_OR_NULL(tx_chn->tx_chn))
+			k3_udma_glue_release_tx_chn(tx_chn->tx_chn);
+
 		memset(tx_chn, 0, sizeof(*tx_chn));
 	}
 }
@@ -1624,11 +1624,11 @@ static void am65_cpsw_nuss_free_rx_chns(void *data)
 
 	rx_chn = &common->rx_chns;
 
-	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
-		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
-
 	if (!IS_ERR_OR_NULL(rx_chn->desc_pool))
 		k3_cppi_desc_pool_destroy(rx_chn->desc_pool);
+
+	if (!IS_ERR_OR_NULL(rx_chn->rx_chn))
+		k3_udma_glue_release_rx_chn(rx_chn->rx_chn);
 }
 
 static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
-- 
2.32.0

