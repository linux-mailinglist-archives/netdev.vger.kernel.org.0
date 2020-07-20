Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0CA226140
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGTNqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:46:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgGTNqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:46:33 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A420AD8E219CC90B7A2A;
        Mon, 20 Jul 2020 21:46:31 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 21:46:30 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <michael.hennerich@analog.com>, <alex.aring@gmail.com>,
        <stefan@datenfreihafen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <kjlu@umn.edu>, <netdev@vger.kernel.org>
Subject: [PATCH v2 net] ieee802154: fix one possible memleak in adf7242_probe
Date:   Mon, 20 Jul 2020 22:30:01 +0800
Message-ID: <20200720143001.40194-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When probe fail, we should destroy the workqueue.

Fixes: 2795e8c25161 ("net: ieee802154: fix a potential NULL pointer dereference")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v1->v2:
Change targeting from "net-next" to "net"

 drivers/net/ieee802154/adf7242.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index 5a37514e4234..8dbccec6ac86 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1262,7 +1262,7 @@ static int adf7242_probe(struct spi_device *spi)
 					     WQ_MEM_RECLAIM);
 	if (unlikely(!lp->wqueue)) {
 		ret = -ENOMEM;
-		goto err_hw_init;
+		goto err_alloc_wq;
 	}
 
 	ret = adf7242_hw_init(lp);
@@ -1294,6 +1294,8 @@ static int adf7242_probe(struct spi_device *spi)
 	return ret;
 
 err_hw_init:
+	destroy_workqueue(lp->wqueue);
+err_alloc_wq:
 	mutex_destroy(&lp->bmux);
 	ieee802154_free_hw(lp->hw);
 
-- 
2.17.1

