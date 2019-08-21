Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B55297B37
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfHUNq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:46:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4750 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728616AbfHUNq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:46:29 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D85065D313CC127B580F;
        Wed, 21 Aug 2019 21:46:24 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:46:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <opendmb@gmail.com>, <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: systemport: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 21:46:13 +0800
Message-ID: <20190821134613.23276-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 9483553..cae66ba 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2420,12 +2420,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	struct device_node *dn;
 	struct net_device *dev;
 	const void *macaddr;
-	struct resource *r;
 	u32 txq, rxq;
 	int ret;
 
 	dn = pdev->dev.of_node;
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	of_id = of_match_node(bcm_sysport_of_match, dn);
 	if (!of_id || !of_id->data)
 		return -EINVAL;
@@ -2473,7 +2471,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		goto err_free_netdev;
 	}
 
-	priv->base = devm_ioremap_resource(&pdev->dev, r);
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
 		goto err_free_netdev;
-- 
2.7.4


