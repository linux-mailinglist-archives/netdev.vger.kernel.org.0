Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E00B223539
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGQHLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:11:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38524 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgGQHLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 03:11:50 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5821147154E520CDB9DD;
        Fri, 17 Jul 2020 15:11:48 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 15:11:37 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sameo@linux.intel.com>,
        <cuissard@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghai38@huawei.com>
Subject: [PATCH v2] nfc: nci: add missed destroy_workqueue in nci_register_device
Date:   Fri, 17 Jul 2020 15:10:16 +0800
Message-ID: <20200717071016.33319-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nfc_register_device fails in nci_register_device,
destroy_workqueue() shouled be called to destroy ndev->tx_wq.

Fixes: 3c1c0f5dc80b ("NFC: NCI: Fix nci_register_device init sequence")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v1->v2:
 Change the module from "net: cxgb3:" to "nfc: nci:"
 net/nfc/nci/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 7cd524884304..78ea8c94dcba 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1228,10 +1228,13 @@ int nci_register_device(struct nci_dev *ndev)
 
 	rc = nfc_register_device(ndev->nfc_dev);
 	if (rc)
-		goto destroy_rx_wq_exit;
+		goto destroy_tx_wq_exit;
 
 	goto exit;
 
+destroy_tx_wq_exit:
+	destroy_workqueue(ndev->tx_wq);
+
 destroy_rx_wq_exit:
 	destroy_workqueue(ndev->rx_wq);
 
-- 
2.17.1

