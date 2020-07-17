Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D785422338D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGQGWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:22:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36444 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgGQGWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 02:22:55 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 328F1C9F7C738406320B;
        Fri, 17 Jul 2020 14:22:49 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 14:22:39 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <vishal@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jeff@garzik.org>, <divy@chelsio.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghai38@huawei.com>
Subject: [PATCH] net: cxgb3: add missed destroy_workqueue in cxgb3 probe failure
Date:   Fri, 17 Jul 2020 14:21:17 +0800
Message-ID: <20200717062117.8941-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver forgets to call destroy_workqueue when cxgb3 probe fails.
Add the missed calls to fix it.

Fixes: 4d22de3e6cc4 ("Add support for the latest 1G/10G Chelsio adapter, T3.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 42c6e9379882..060d42803240 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3407,6 +3407,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_disable_device:
 	pci_disable_device(pdev);
 out:
+	destroy_workqueue(cxgb3_wq);
 	return err;
 }
 
-- 
2.17.1

