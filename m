Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0EC6E5991
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjDRGpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDRGpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:45:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F371FFD
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 23:45:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [7.185.36.106])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q0vSx2sDhzSstH;
        Tue, 18 Apr 2023 14:41:05 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 18 Apr
 2023 14:45:09 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <jiawenwu@trustnetic.com>,
        <mengyuanlou@net-swift.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <yang.lee@linux.alibaba.com>, <shaozhengchao@huawei.com>,
        <error27@gmail.com>
Subject: [PATCH net-next] net: libwx: fix memory leak in wx_setup_rx_resources
Date:   Tue, 18 Apr 2023 14:54:50 +0800
Message-ID: <20230418065450.2268522-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When wx_alloc_page_pool() failed in wx_setup_rx_resources(), it doesn't
release DMA buffer. Add dma_free_coherent() in the error path to release
the DMA buffer.

Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index eb89a274083e..1e8d8b7b0c62 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1798,10 +1798,13 @@ static int wx_setup_rx_resources(struct wx_ring *rx_ring)
 	ret = wx_alloc_page_pool(rx_ring);
 	if (ret < 0) {
 		dev_err(rx_ring->dev, "Page pool creation failed: %d\n", ret);
-		goto err;
+		goto err_desc;
 	}
 
 	return 0;
+
+err_desc:
+	dma_free_coherent(dev, rx_ring->size, rx_ring->desc, rx_ring->dma);
 err:
 	kvfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
-- 
2.34.1

