Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BA1C87B1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEGLKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:10:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51088 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgEGLKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:10:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BCF82289A44B87682C4F;
        Thu,  7 May 2020 19:09:53 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 19:09:44 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <davem@davemloft.net>, <yanaijie@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: encx24j600: make encx24j600_hw_init() return void
Date:   Thu, 7 May 2020 19:09:05 +0800
Message-ID: <20200507110905.38211-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function always return 0 now, we can make it return void to
simplify the code. This fixes the following coccicheck warning:

drivers/net/ethernet/microchip/encx24j600.c:609:5-8: Unneeded variable:
"ret". Return "0" on line 653

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/microchip/encx24j600.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 39925e4bf2ec..fccc4805247f 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -604,9 +604,8 @@ static void encx24j600_set_rxfilter_mode(struct encx24j600_priv *priv)
 	}
 }
 
-static int encx24j600_hw_init(struct encx24j600_priv *priv)
+static void encx24j600_hw_init(struct encx24j600_priv *priv)
 {
-	int ret = 0;
 	u16 macon2;
 
 	priv->hw_enabled = false;
@@ -649,8 +648,6 @@ static int encx24j600_hw_init(struct encx24j600_priv *priv)
 
 	if (netif_msg_hw(priv))
 		encx24j600_dump_config(priv, "Hw is initialized");
-
-	return ret;
 }
 
 static void encx24j600_hw_enable(struct encx24j600_priv *priv)
@@ -1042,12 +1039,7 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 	}
 
 	/* Initialize the device HW to the consistent state */
-	if (encx24j600_hw_init(priv)) {
-		netif_err(priv, probe, ndev,
-			  DRV_NAME ": HW initialization error\n");
-		ret = -EIO;
-		goto out_free;
-	}
+	encx24j600_hw_init(priv);
 
 	kthread_init_worker(&priv->kworker);
 	kthread_init_work(&priv->tx_work, encx24j600_tx_proc);
-- 
2.21.1

