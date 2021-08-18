Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98843EF8A2
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbhHRDeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:34:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8872 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbhHRDeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:34:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GqD0h54PCz8sZR;
        Wed, 18 Aug 2021 11:29:40 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:29 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 11:33:29 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
Subject: [PATCH RFC 6/7] net: hns3: support tx recycling in the hns3 driver
Date:   Wed, 18 Aug 2021 11:32:22 +0800
Message-ID: <1629257542-36145-7-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_recyclable_napi_add() to register page pool to
the NAPI instance, and avoid doing the DMA mapping/unmapping
when the page is from page pool.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 32 +++++++++++++++----------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fcbeb1f..ab86566 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1689,12 +1689,18 @@ static int hns3_map_and_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		return 0;
 	} else {
 		skb_frag_t *frag = (skb_frag_t *)priv;
+		struct page *page = skb_frag_page(frag);
 
 		size = skb_frag_size(frag);
 		if (!size)
 			return 0;
 
-		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
+		if (skb_frag_is_pp(frag) && page->pp->p.dev == dev) {
+			dma = page_pool_get_dma_addr(page) + skb_frag_off(frag);
+			type = DESC_TYPE_PP_FRAG;
+		} else {
+			dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
+		}
 	}
 
 	if (unlikely(dma_mapping_error(dev, dma))) {
@@ -4525,7 +4531,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		ret = hns3_get_vector_ring_chain(tqp_vector,
 						 &vector_ring_chain);
 		if (ret)
-			goto map_ring_fail;
+			return ret;
 
 		ret = h->ae_algo->ops->map_ring_to_vector(h,
 			tqp_vector->vector_irq, &vector_ring_chain);
@@ -4533,19 +4539,10 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
 
 		if (ret)
-			goto map_ring_fail;
-
-		netif_napi_add(priv->netdev, &tqp_vector->napi,
-			       hns3_nic_common_poll, NAPI_POLL_WEIGHT);
+			return ret;
 	}
 
 	return 0;
-
-map_ring_fail:
-	while (i--)
-		netif_napi_del(&priv->tqp_vector[i].napi);
-
-	return ret;
 }
 
 static void hns3_nic_init_coal_cfg(struct hns3_nic_priv *priv)
@@ -4754,7 +4751,7 @@ static void hns3_alloc_page_pool(struct hns3_enet_ring *ring)
 				(PAGE_SIZE << hns3_page_order(ring)),
 		.nid = dev_to_node(ring_to_dev(ring)),
 		.dev = ring_to_dev(ring),
-		.dma_dir = DMA_FROM_DEVICE,
+		.dma_dir = DMA_BIDIRECTIONAL,
 		.offset = 0,
 		.max_len = PAGE_SIZE << hns3_page_order(ring),
 	};
@@ -4923,6 +4920,15 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 		u64_stats_init(&priv->ring[i].syncp);
 	}
 
+	for (i = 0; i < priv->vector_num; i++) {
+		struct hns3_enet_tqp_vector *tqp_vector;
+
+		tqp_vector = &priv->tqp_vector[i];
+		netif_recyclable_napi_add(priv->netdev, &tqp_vector->napi,
+					  hns3_nic_common_poll, NAPI_POLL_WEIGHT,
+					  tqp_vector->rx_group.ring->page_pool);
+	}
+
 	return 0;
 
 out_when_alloc_ring_memory:
-- 
2.7.4

