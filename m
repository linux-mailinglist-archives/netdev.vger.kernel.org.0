Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D39561284
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiF3Gdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiF3Gdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:33:43 -0400
X-Greylist: delayed 524 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 23:33:41 PDT
Received: from mail-m118103.qiye.163.com (mail-m118103.qiye.163.com [115.236.118.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCDC2BB3F;
        Wed, 29 Jun 2022 23:33:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [58.22.7.114])
        by mail-m118103.qiye.163.com (Hmail) with ESMTPA id A404350014F;
        Thu, 30 Jun 2022 14:24:55 +0800 (CST)
From:   David Wu <david.wu@rock-chips.com>
To:     joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>
Subject: [PATCH RFC net-next] net: stmmac: Reduce the memory copy for rx data
Date:   Thu, 30 Jun 2022 14:24:53 +0800
Message-Id: <20220630062453.2530477-1-david.wu@rock-chips.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJSktLSjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHx9JVh5LTh1NH0lNQ0gYT1UTARMWGhIXJB
        QOD1lXWRgSC1lBWU5DVUlJVUxVSkpPWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PyI6Lzo4CT01DjQuGCg5HhUp
        DBUaCw9VSlVKTU5NTkxLSUJNSUpIVTMWGhIXVR8aDRIfVQwOOwkUGBBWGBMSCwhVGBQWRVlXWRIL
        WUFZTkNVSUlVTFVKSk9ZV1kIAVlBSU1KTjcG
X-HM-Tid: 0a81b348b61b2ebdkusna404350014f
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_add_rx_frag() to reduce the memory copy for rx data, only copy
ethernet header.

Signed-off-by: David Wu <david.wu@rock-chips.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1a7cf4567bc..ac8d92ec35c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5226,7 +5226,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			/* XDP program may expand or reduce tail */
 			buf1_len = xdp.data_end - xdp.data;
 
-			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
+			skb = napi_alloc_skb(&ch->rx_napi, ETH_HLEN);
 			if (!skb) {
 				priv->dev->stats.rx_dropped++;
 				count++;
@@ -5234,11 +5234,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			}
 
 			/* XDP program may adjust header */
-			skb_copy_to_linear_data(skb, xdp.data, buf1_len);
-			skb_put(skb, buf1_len);
+			memcpy(skb->data, xdp.data, ETH_HLEN);
+			skb_put(skb, ETH_HLEN);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					buf->page, buf->page_offset + ETH_HLEN,
+					buf1_len - ETH_HLEN,
+					priv->dma_buf_sz);
 
-			/* Data payload copied into SKB, page ready for recycle */
-			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			/* Data payload appended into SKB */
+			page_pool_release_page(rx_q->page_pool, buf->page);
 			buf->page = NULL;
 		} else if (buf1_len) {
 			dma_sync_single_for_cpu(priv->device, buf->addr,
-- 
2.25.1

