Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88CA3B4CAB
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 06:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhFZEna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 00:43:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5429 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhFZEnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 00:43:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GBh1d0gCrz732K;
        Sat, 26 Jun 2021 12:37:41 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 12:40:59 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 26 Jun
 2021 12:40:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>
Subject: [PATCH net-next 1/3] net: sparx5: check return value after calling platform_get_resource()
Date:   Sat, 26 Jun 2021 12:44:18 +0800
Message-ID: <20210626044420.390517-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210626044420.390517-1-yangyingliang@huawei.com>
References: <20210626044420.390517-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index a325f7c05a07..665e20ccb404 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -228,6 +228,10 @@ static int sparx5_create_targets(struct sparx5 *sparx5)
 	for (idx = 0; idx < IO_RANGES; idx++) {
 		iores[idx] = platform_get_resource(sparx5->pdev, IORESOURCE_MEM,
 						   idx);
+		if (!iores[idx]) {
+			dev_err(sparx5->dev, "Invalid resource\n");
+			return -EINVAL;
+		}
 		iomem[idx] = devm_ioremap(sparx5->dev,
 					  iores[idx]->start,
 					  iores[idx]->end - iores[idx]->start
-- 
2.25.1

