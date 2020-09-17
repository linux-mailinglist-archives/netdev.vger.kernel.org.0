Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B988326DB96
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgIQMbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 08:31:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41022 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbgIQMbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 08:31:36 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 61DAD6FD8536E7EA2B93;
        Thu, 17 Sep 2020 20:30:41 +0800 (CST)
Received: from euler.huawei.com (10.175.124.27) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:30:29 +0800
From:   Wei Li <liwei391@huawei.com>
To:     Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huawei.libin@huawei.com>, <guohanjun@huawei.com>
Subject: [PATCH net v2] hinic: fix potential resource leak
Date:   Thu, 17 Sep 2020 20:29:50 +0800
Message-ID: <20200917122950.36878-1-liwei391@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rx_request_irq(), it will just return what irq_set_affinity_hint()
returns. If it is failed, the napi and irq requested are not freed
properly. So add exits for failures to handle these.

Signed-off-by: Wei Li <liwei391@huawei.com>
---
v1 -> v2:
 - Free irq as well when irq_set_affinity_hint() fails.
---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c | 21 +++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 5bee951fe9d4..cc1d425d070c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -543,18 +543,25 @@ static int rx_request_irq(struct hinic_rxq *rxq)
 	if (err) {
 		netif_err(nic_dev, drv, rxq->netdev,
 			  "Failed to set RX interrupt coalescing attribute\n");
-		rx_del_napi(rxq);
-		return err;
+		goto err_req_irq;
 	}
 
 	err = request_irq(rq->irq, rx_irq, 0, rxq->irq_name, rxq);
-	if (err) {
-		rx_del_napi(rxq);
-		return err;
-	}
+	if (err)
+		goto err_req_irq;
 
 	cpumask_set_cpu(qp->q_id % num_online_cpus(), &rq->affinity_mask);
-	return irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
+	err = irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
+	if (err)
+		goto err_irq_affinity;
+
+	return 0;
+
+err_irq_affinity:
+	free_irq(rq->irq, rxq);
+err_req_irq:
+	rx_del_napi(rxq);
+	return err;
 }
 
 static void rx_free_irq(struct hinic_rxq *rxq)
-- 
2.17.1

