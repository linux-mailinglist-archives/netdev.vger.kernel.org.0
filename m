Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FCD3B4CA9
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 06:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhFZEn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 00:43:26 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhFZEnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 00:43:22 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBgzP2G3GzXj3R;
        Sat, 26 Jun 2021 12:35:45 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 12:40:59 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 26 Jun
 2021 12:40:59 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>
Subject: [PATCH net-next 2/3] net: sparx5: fix return value check in sparx5_create_targets()
Date:   Sat, 26 Jun 2021 12:44:19 +0800
Message-ID: <20210626044420.390517-3-yangyingliang@huawei.com>
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

In case of error, the function devm_ioremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should
be replaced with NULL test.

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 665e20ccb404..abaa086ce345 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -236,10 +236,10 @@ static int sparx5_create_targets(struct sparx5 *sparx5)
 					  iores[idx]->start,
 					  iores[idx]->end - iores[idx]->start
 					  + 1);
-		if (IS_ERR(iomem[idx])) {
+		if (!iomem[idx]) {
 			dev_err(sparx5->dev, "Unable to get switch registers: %s\n",
 				iores[idx]->name);
-			return PTR_ERR(iomem[idx]);
+			return -ENOMEM;
 		}
 		begin[idx] = iomem[idx] - sparx5_main_iomap[range_id[idx]].offset;
 	}
-- 
2.25.1

