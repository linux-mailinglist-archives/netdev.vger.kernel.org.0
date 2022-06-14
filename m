Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3FB54A5DD
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352806AbiFNCPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354580AbiFNCOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:14:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE4F3C73F;
        Mon, 13 Jun 2022 19:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5042460B6B;
        Tue, 14 Jun 2022 02:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91789C385A2;
        Tue, 14 Jun 2022 02:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172533;
        bh=tva42ZvRCdMx4OFae7uHzPRqZWjW4DKJ7b2pgpypyNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJJXvEHfsyOht2ZLSS0bGn8UABBJFJ0+JMB0htDo2aJU8CwW3BKRJL92bxEaS2Ym7
         GIYY4TCt0Y0YDz9AKw0XZbofPDFjSZduJo3S204/1AYMe22Bwrnqf40GAzRn0TJORz
         SCVADaHuXTPsKLYdGg3Lo7dZe/Z1rfvQp3YDzqjxerqvGur1ZmKXVYjDtk6Z2xwHQu
         y46T1VFc4zoT5FH8IJ2q8QkcGKVAgZMMNV/doDYwiJS0NpfhO9OvDUOWT2t8uzFVRL
         JEqb0b2y3oggMjJdx6xfq6VIs7+Q8wQwFGVWwSNDFDyZei5/nuehzZIuPOamaj3dQh
         1oaKE7Z4s6ULA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen Lin <chen45464546@163.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nbd@openwrt.org,
        blogic@openwrt.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 25/29] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev[napi]_alloc_frag
Date:   Mon, 13 Jun 2022 22:08:11 -0400
Message-Id: <20220614020815.1099999-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020815.1099999-1-sashal@kernel.org>
References: <20220614020815.1099999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Lin <chen45464546@163.com>

[ Upstream commit 2f2c0d2919a14002760f89f4e02960c735a316d2 ]

When rx_flag == MTK_RX_FLAGS_HWLRO,
rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
netdev_alloc_frag is for alloction of page fragment only.
Reference to other drivers and Documentation/vm/page_frags.rst

Branch to use __get_free_pages when ring->frag_size > PAGE_SIZE.

Signed-off-by: Chen Lin <chen45464546@163.com>
Link: https://lore.kernel.org/r/1654692413-2598-1-git-send-email-chen45464546@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 7d7dc0754a3a..627734f7c824 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -806,6 +806,17 @@ static inline void mtk_rx_get_desc(struct mtk_rx_dma *rxd,
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
 }
 
+static void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)
+{
+	unsigned int size = mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH);
+	unsigned long data;
+
+	data = __get_free_pages(gfp_mask | __GFP_COMP | __GFP_NOWARN,
+				get_order(size));
+
+	return (void *)data;
+}
+
 /* the qdma core needs scratch memory to be setup */
 static int mtk_init_fq_dma(struct mtk_eth *eth)
 {
@@ -1303,7 +1314,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 
 		/* alloc new buffer */
-		new_data = napi_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			new_data = napi_alloc_frag(ring->frag_size);
+		else
+			new_data = mtk_max_lro_buf_alloc(GFP_ATOMIC);
 		if (unlikely(!new_data)) {
 			netdev->stats.rx_dropped++;
 			goto release_desc;
@@ -1700,7 +1714,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = mtk_max_lro_buf_alloc(GFP_KERNEL);
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
-- 
2.35.1

