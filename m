Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4A053D957
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 05:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbiFEDOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 23:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiFEDOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 23:14:37 -0400
Received: from m12-12.163.com (m12-12.163.com [220.181.12.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2FB54ECFB;
        Sat,  4 Jun 2022 20:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=TUBfwF53I+2MtjAGYa
        pwu8YmcHWT7Pc/VRs7clOHSnE=; b=ZCqQKZAt5oWK5y3REdGO4gj2itwrzw0hCp
        vjMDwzhzbFIT+CNKCu6HyYEssriY+d9ejF2H3ppC1IHy8KIChiT5uOskW1sxTL7Y
        /TqK7b4EcM+LTy6o4+T4PPcBkXg2Syn8Au7RU4wqpEvEi3rE+VIVEMvK4rRxhqMy
        lMYqZo8zU=
Received: from localhost.localdomain (unknown [171.221.147.121])
        by smtp8 (Coremail) with SMTP id DMCowADHgyE4H5xi7gqqGA--.22831S2;
        Sun, 05 Jun 2022 11:13:01 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     nbd@nbd.name, alexander.duyck@gmail.com
Cc:     john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen Lin <chen45464546@163.com>
Subject: [PATCH v3] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag
Date:   Sun,  5 Jun 2022 11:12:37 +0800
Message-Id: <1654398757-2937-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAKgT0UdR-bdiZXsV_=8yJUS8zjoO6jeBS5bKNWAyxwLCiOP8ZQ@mail.gmail.com>
References: <CAKgT0UdR-bdiZXsV_=8yJUS8zjoO6jeBS5bKNWAyxwLCiOP8ZQ@mail.gmail.com>
X-CM-TRANSID: DMCowADHgyE4H5xi7gqqGA--.22831S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFyfKF4rCw15Jw1UJF1DZFb_yoW8AFWrpr
        4Yya43ZFyxAr4DG395Aa1UZFs8Aw4xKryUKry3Z34fZwn8tFWrKFyktFW5uryakrWvkFyS
        yrs0vr9I9Fn5Kw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi22NAUUUUU=
X-Originating-IP: [171.221.147.121]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbB2A0XnmBHK0PEJgAAsx
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rx_flag == MTK_RX_FLAGS_HWLRO, 
rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
netdev_alloc_frag is for alloction of page fragment only.
Reference to other drivers and Documentation/vm/page_frags.rst

Branch to use __get_free_pages when ring->frag_size > PAGE_SIZE.

Signed-off-by: Chen Lin <chen45464546@163.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b3b3c07..ba9259a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1467,7 +1467,13 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			new_data = napi_alloc_frag(ring->frag_size);
+		else
+			new_data = (void *)__get_free_pages(GFP_ATOMIC |
+			  __GFP_COMP | __GFP_NOWARN,
+			  get_order(mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH)));
+
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1914,7 +1920,13 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = (void *)__get_free_pages(GFP_KERNEL |
+			  __GFP_COMP | __GFP_NOWARN,
+			  get_order(mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH)));
+
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
-- 
1.7.9.5

