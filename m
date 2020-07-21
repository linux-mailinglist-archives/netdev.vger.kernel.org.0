Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC56227E24
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgGULHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:07:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7809 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbgGULHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:07:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3007F170C34E495B9ABC;
        Tue, 21 Jul 2020 19:07:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 19:06:55 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/4] net: hns3: fix for not calculating TX BD send size correctly
Date:   Tue, 21 Jul 2020 19:03:52 +0800
Message-ID: <1595329434-46766-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
References: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

With GRO and fraglist support, the SKB can be aggregated to
a total size of 65535, and when that SKB is forwarded through
a bridge, the size of the SKB may be pushed to exceed the size
of 65535 when br_dev_queue_push_xmit() is called.

The max send size of BD supported by the HW is 65535, when a SKB
with a headlen of over 65535 is sent to the driver, the driver
needs to use multi BD to send the linear data, and the send size
of the last BD is calculated incorrectly by the driver who is
using '&' operation, which causes a TX error.

Use '%' operation to fix this problem.

Fixes: 3fe13ed95dd3 ("net: hns3: avoid mult + div op in critical data path")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 18f7623..a814d99 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1135,7 +1135,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	}
 
 	frag_buf_num = hns3_tx_bd_count(size);
-	sizeoflast = size & HNS3_TX_LAST_SIZE_M;
+	sizeoflast = size % HNS3_MAX_BD_SIZE;
 	sizeoflast = sizeoflast ? sizeoflast : HNS3_MAX_BD_SIZE;
 
 	/* When frag size is bigger than hardware limit, split this frag */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 9f64077..9922c5f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -165,8 +165,6 @@ enum hns3_nic_state {
 #define HNS3_TXD_MSS_S				0
 #define HNS3_TXD_MSS_M				(0x3fff << HNS3_TXD_MSS_S)
 
-#define HNS3_TX_LAST_SIZE_M			0xffff
-
 #define HNS3_VECTOR_TX_IRQ			BIT_ULL(0)
 #define HNS3_VECTOR_RX_IRQ			BIT_ULL(1)
 
-- 
2.7.4

