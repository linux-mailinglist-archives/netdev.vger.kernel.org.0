Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD85289A5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245590AbiEPQIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242263AbiEPQIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:08:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29005381A8;
        Mon, 16 May 2022 09:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D524ACE16D3;
        Mon, 16 May 2022 16:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D72C34116;
        Mon, 16 May 2022 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717282;
        bh=/7JibGmqxINAAC2OLNWW7h4NBtLSDt9RP8nVknEhicc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfXRNgO2WskOdTn3GnqwOmDwAZhkdOQoiCrQZqwaN2h9LiIGhhMZ6BqKT0ii2/URU
         tk+NvpBbRlOFdOzQPLYnYxfiWpHa95JIHohZxJCSIW6j368UO5K+fN7G39PZhB386A
         es2tUU3jSnVmX5INwWrS9lGle8J/FH/RTLRB2qq8rZgD9QC2qxbghjoERXxRK2UqOt
         Z4QQsRDMoW6qaRv5jdMx65i4GUBMvk4yejBDztaqSAwMVF3WW/WkeleQRRC/56TwvK
         Q1/JtwGAHl9HwHGwHTCmjmYnEghnvoP+/WArW2wIqRrrd15J6MuAoqUUe4WIqz8Xnv
         pzaK0cD66eglw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 07/15] net: ethernet: mtk_eth_soc: rely on txd_size in txd_to_idx
Date:   Mon, 16 May 2022 18:06:34 +0200
Message-Id: <4e672c71564e1071ff1c94691984173ae9b0b54d.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to add mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5f0082f92cc7..a67b22dbaac7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -852,9 +852,10 @@ static struct mtk_tx_dma *qdma_to_pdma(struct mtk_tx_ring *ring,
 	return ring->dma_pdma - ring->dma + dma;
 }
 
-static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma)
+static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma,
+		      u32 txd_size)
 {
-	return ((void *)dma - (void *)ring->dma) / sizeof(*dma);
+	return ((void *)dma - (void *)ring->dma) / txd_size;
 }
 
 static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
@@ -1070,8 +1071,10 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		    !netdev_xmit_more())
 			mtk_w32(eth, txd->txd2, MTK_QTX_CTX_PTR);
 	} else {
-		int next_idx = NEXT_DESP_IDX(txd_to_idx(ring, txd),
-					     ring->dma_size);
+		int next_idx;
+
+		next_idx = NEXT_DESP_IDX(txd_to_idx(ring, txd, soc->txrx.txd_size),
+					 ring->dma_size);
 		mtk_w32(eth, next_idx, MT7628_TX_CTX_IDX0);
 	}
 
-- 
2.35.3

