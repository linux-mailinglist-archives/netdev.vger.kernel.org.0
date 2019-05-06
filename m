Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB5F1438B
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfEFCuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7159 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726145AbfEFCuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8D58658394249938E2C4;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: use napi_schedule_irqoff in hard interrupts handlers
Date:   Mon, 6 May 2019 10:48:42 +0800
Message-ID: <1557110932-683-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

napi_schedule_irqoff is introduced to be used from hard interrupts
handlers or when irqs are already masked, see:

https://lists.openwall.net/netdev/2014/10/29/2

So this patch replaces napi_schedule with napi_schedule_irqoff.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 06dda77..ff3c9f1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -74,7 +74,7 @@ static irqreturn_t hns3_irq_handle(int irq, void *vector)
 {
 	struct hns3_enet_tqp_vector *tqp_vector = vector;
 
-	napi_schedule(&tqp_vector->napi);
+	napi_schedule_irqoff(&tqp_vector->napi);
 
 	return IRQ_HANDLED;
 }
-- 
2.7.4

