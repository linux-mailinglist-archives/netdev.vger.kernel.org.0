Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC94E130033
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgADCtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8672 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727321AbgADCtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:41 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9AACFE375103C6703C0E;
        Sat,  4 Jan 2020 10:49:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 Jan 2020 10:49:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/8] net: hns3: modify the IRQ name of TQP vector
Date:   Sat, 4 Jan 2020 10:49:26 +0800
Message-ID: <1578106171-17238-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
References: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

When rename the net devices, the IRQ number can not be
fetched by the net device name, because the driver request
the IRQ resources only when the vector resource changed, and
the rename operation did not change the vector resources,
so the IRQ name keeps the previous net device name.
So this patch modifies the name of the TQP IRQ as
"pci driver name"-"pci name"-"TxRx"-"index".

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 01bad67..e240d99f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -133,18 +133,21 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
 			continue;
 
 		if (tqp_vectors->tx_group.ring && tqp_vectors->rx_group.ring) {
-			snprintf(tqp_vectors->name, HNAE3_INT_NAME_LEN - 1,
-				 "%s-%s-%d", priv->netdev->name, "TxRx",
-				 txrx_int_idx++);
+			snprintf(tqp_vectors->name, HNAE3_INT_NAME_LEN,
+				 "%s-%s-%s-%d", hns3_driver_name,
+				 pci_name(priv->ae_handle->pdev),
+				 "TxRx", txrx_int_idx++);
 			txrx_int_idx++;
 		} else if (tqp_vectors->rx_group.ring) {
-			snprintf(tqp_vectors->name, HNAE3_INT_NAME_LEN - 1,
-				 "%s-%s-%d", priv->netdev->name, "Rx",
-				 rx_int_idx++);
+			snprintf(tqp_vectors->name, HNAE3_INT_NAME_LEN,
+				 "%s-%s-%s-%d", hns3_driver_name,
+				 pci_name(priv->ae_handle->pdev),
+				 "Rx", rx_int_idx++);
 		} else if (tqp_vectors->tx_group.ring) {
-			snprintf(tqp_vectors->name, HNAE3_INT_NAME_LEN - 1,
-				 "%s-%s-%d", priv->netdev->name, "Tx",
-				 tx_int_idx++);
+			snprintf(tqp_vectors->name, HNAE3_INT_NAME_LEN,
+				 "%s-%s-%s-%d", hns3_driver_name,
+				 pci_name(priv->ae_handle->pdev),
+				 "Tx", tx_int_idx++);
 		} else {
 			/* Skip this unused q_vector */
 			continue;
-- 
2.7.4

