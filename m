Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E5853C721
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 10:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbiFCIrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 04:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbiFCIrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 04:47:47 -0400
Received: from m12-15.163.com (m12-15.163.com [220.181.12.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41A0422508;
        Fri,  3 Jun 2022 01:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=W3JiO5UY4+ex2grmCg
        7a8OXWeSx+fkxzA9451eGZd0s=; b=YuhlqzOr9G8xK8pkLg/tE3S9E681hv6NV2
        VXIjYyQi3jN07ADjbnem/+QrB+WVwOUJuMeBzioFUkPJDbGuZ1p1wa6H1zZ7ZEXY
        7+aCwf/70VdFCinfg/t6YUxRFKy3DRtmTzuMA/YCn5663Qw6cGEVPjAnXPNgDefy
        8RLlGw5Tk=
Received: from localhost.localdomain (unknown [218.88.124.148])
        by smtp11 (Coremail) with SMTP id D8CowAB3U9ltypliCzpDFw--.50149S2;
        Fri, 03 Jun 2022 16:46:41 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     nbd@nbd.name, kuba@kernel.org
Cc:     john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, Chen Lin <chen45464546@163.com>
Subject: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag
Date:   Fri,  3 Jun 2022 16:46:08 +0800
Message-Id: <1654245968-8067-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
X-CM-TRANSID: D8CowAB3U9ltypliCzpDFw--.50149S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFyfKF13AFy7trWxWry5twb_yoW8CFyUpF
        WUta4fAFW8Ar4DGws5Aa1UZF45Kw18trWDKr13Z34fZwnxtFWFkryktFWUCFySkrWDCF1f
        trs0vr9I9F98Gw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR4xRDUUUUU=
X-Originating-IP: [218.88.124.148]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbB2BEVnmBHKy0oDwAAsE
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rx_flag == MTK_RX_FLAGS_HWLRO, 
rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
netdev_alloc_frag is for alloction of page fragment only.
Reference to other drivers and Documentation/vm/page_frags.rst

Branch to use alloc_pages when ring->frag_size > PAGE_SIZE.

Signed-off-by: Chen Lin <chen45464546@163.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b3b3c07..772d903 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1467,7 +1467,16 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE) {
+			new_data = napi_alloc_frag(ring->frag_size);
+		} else {
+			struct page *page;
+			unsigned int order = get_order(ring->frag_size);
+
+			page = alloc_pages(GFP_ATOMIC | __GFP_COMP |
+					    __GFP_NOWARN, order);
+			new_data = page ? page_address(page) : NULL;
+		}
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1914,7 +1923,16 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE) {
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		} else {
+			struct page *page;
+			unsigned int order = get_order(ring->frag_size);
+
+			page = alloc_pages(GFP_KERNEL | __GFP_COMP |
+					    __GFP_NOWARN, order);
+			ring->data[i] = page ? page_address(page) : NULL;
+		}
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
-- 
1.7.9.5

