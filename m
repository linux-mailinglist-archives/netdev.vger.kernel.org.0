Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080B5631271
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 04:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiKTDyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 22:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKTDyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 22:54:14 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E324F1A7;
        Sat, 19 Nov 2022 19:54:12 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NFGpS25yJzHvbn;
        Sun, 20 Nov 2022 11:53:36 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 11:54:09 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <nbd@nbd.name>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <Mark-MC.Lee@mediatek.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <matthias.bgg@gmail.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <lorenzo@kernel.org>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()
Date:   Sun, 20 Nov 2022 11:54:05 +0800
Message-ID: <20221120035405.1464341-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fail to dma_map_single() in mtk_rx_alloc(), it returns directly.
But the memory allocated for local variable data is not freed, and
local variabel data has not been attached to ring->data[i] yet, so the
memory allocated for local variable data will not be freed outside
mtk_rx_alloc() too. Thus memory leak would occur in this scenario.

Add skb_free_frag(data) when dma_map_single() failed.

Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 7cd381530aa4..bc47ef1e4dd5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2378,8 +2378,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 				data + NET_SKB_PAD + eth->ip_align,
 				ring->buf_size, DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(eth->dma_dev,
-						       dma_addr)))
+						       dma_addr))) {
+				skb_free_frag(data);
 				return -ENOMEM;
+			}
 		}
 		rxd->rxd1 = (unsigned int)dma_addr;
 		ring->data[i] = data;
-- 
2.25.1

