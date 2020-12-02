Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F912CB9B8
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgLBJxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:53:10 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8919 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLBJxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:53:09 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CmDlP2Y7jz76Vy;
        Wed,  2 Dec 2020 17:52:01 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 2 Dec 2020 17:52:24 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <rajur@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <divy@chelsio.com>, <jgarzik@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] cxgb3: fix error return code in t3_sge_alloc_qset()
Date:   Wed, 2 Dec 2020 17:56:05 +0800
Message-ID: <1606902965-1646-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b1fb1f280d09 ("cxgb3 - Fix dma mapping error path")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index e18e9ce..1cc3c51 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -3175,6 +3175,7 @@ int t3_sge_alloc_qset(struct adapter *adapter, unsigned int id, int nports,
 			  GFP_KERNEL | __GFP_COMP);
 	if (!avail) {
 		CH_ALERT(adapter, "free list queue 0 initialization failed\n");
+		ret = -ENOMEM;
 		goto err;
 	}
 	if (avail < q->fl[0].size)
-- 
2.9.5

