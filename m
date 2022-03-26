Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB974E8038
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 10:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiCZJ6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 05:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiCZJ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 05:58:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BBF1EAD7;
        Sat, 26 Mar 2022 02:56:37 -0700 (PDT)
Received: from kwepemi100012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KQZ7l66fSzfZVs;
        Sat, 26 Mar 2022 17:54:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100012.china.huawei.com (7.221.188.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 1/6] net: hns3: fix ethtool tx copybreak buf size indicating not aligned issue
Date:   Sat, 26 Mar 2022 17:51:00 +0800
Message-ID: <20220326095105.54075-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220326095105.54075-1-huangguangbin2@huawei.com>
References: <20220326095105.54075-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

When use ethtoool set tx copybreak buf size to a large value
which causes order exceeding 10 or memory is not enough,
it causes allocating tx copybreak buffer failed and print
"the active tx spare buf is 0, not enabled tx spare buffer",
however, use --get-tunable parameter query tx copybreak buf
size and it indicates setting value not 0.

So, it's necessary to change the print value from setting
value to 0.

Set kinfo.tx_spare_buf_size to 0 when set tx copybreak buf size failed.

Fixes: e445f08af2b1 ("net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 20 +++++++++++--------
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  3 ++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0b8a73c40b12..16137238ddbf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1028,13 +1028,12 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 
 static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 {
+	u32 alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	struct hns3_tx_spare *tx_spare;
 	struct page *page;
-	u32 alloc_size;
 	dma_addr_t dma;
 	int order;
 
-	alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	if (!alloc_size)
 		return;
 
@@ -1044,30 +1043,35 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	if (!tx_spare) {
 		/* The driver still work without the tx spare buffer */
 		dev_warn(ring_to_dev(ring), "failed to allocate hns3_tx_spare\n");
-		return;
+		goto devm_kzalloc_error;
 	}
 
 	page = alloc_pages_node(dev_to_node(ring_to_dev(ring)),
 				GFP_KERNEL, order);
 	if (!page) {
 		dev_warn(ring_to_dev(ring), "failed to allocate tx spare pages\n");
-		devm_kfree(ring_to_dev(ring), tx_spare);
-		return;
+		goto alloc_pages_error;
 	}
 
 	dma = dma_map_page(ring_to_dev(ring), page, 0,
 			   PAGE_SIZE << order, DMA_TO_DEVICE);
 	if (dma_mapping_error(ring_to_dev(ring), dma)) {
 		dev_warn(ring_to_dev(ring), "failed to map pages for tx spare\n");
-		put_page(page);
-		devm_kfree(ring_to_dev(ring), tx_spare);
-		return;
+		goto dma_mapping_error;
 	}
 
 	tx_spare->dma = dma;
 	tx_spare->buf = page_address(page);
 	tx_spare->len = PAGE_SIZE << order;
 	ring->tx_spare = tx_spare;
+	return;
+
+dma_mapping_error:
+	put_page(page);
+alloc_pages_error:
+	devm_kfree(ring_to_dev(ring), tx_spare);
+devm_kzalloc_error:
+	ring->tqp->handle->kinfo.tx_spare_buf_size = 0;
 }
 
 /* Use hns3_tx_spare_space() to make sure there is enough buffer
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6469238ae090..ae30dbe7ef52 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1818,7 +1818,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
 		new_tx_spare_buf_size = *(u32 *)data;
 		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
-		if (ret) {
+		if (ret ||
+		    (!priv->ring->tx_spare && new_tx_spare_buf_size != 0)) {
 			int ret1;
 
 			netdev_warn(netdev,
-- 
2.33.0

