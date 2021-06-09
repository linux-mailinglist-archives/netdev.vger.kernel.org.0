Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58433A16C5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhFIOPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:15:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3927 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbhFIOPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:15:32 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0TXR3Z3pz6vyG;
        Wed,  9 Jun 2021 22:10:31 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 22:13:35 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 22:13:34 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>
Subject: [PATCH net-next] net: davinci_emac: Use devm_platform_get_and_ioremap_resource()
Date:   Wed, 9 Jun 2021 22:17:44 +0800
Message-ID: <20210609141744.3205628-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index f9417b44cae8..c674e34b6839 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1814,13 +1814,12 @@ static int davinci_emac_probe(struct platform_device *pdev)
 	priv->bus_freq_mhz = (u32)(emac_bus_frequency / 1000000);
 
 	/* Get EMAC platform data */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->emac_base_phys = res->start + pdata->ctrl_reg_offset;
-	priv->remap_addr = devm_ioremap_resource(&pdev->dev, res);
+	priv->remap_addr = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->remap_addr)) {
 		rc = PTR_ERR(priv->remap_addr);
 		goto no_pdata;
 	}
+	priv->emac_base_phys = res->start + pdata->ctrl_reg_offset;
 
 	res_ctrl = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (res_ctrl) {
-- 
2.25.1

