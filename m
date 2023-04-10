Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF31A6DC8DF
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjDJP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjDJP6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:58:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF163AA1;
        Mon, 10 Apr 2023 08:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681142294; x=1712678294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cpc+vWCiVUmsOySpGlMg+6/vKyP6bVmouafrvWfaSpU=;
  b=kzOdlsJiBNzy+PcCnU3m4pdrnyaoIBRidtJm6jq5EZSa+cBF50QUFW3h
   gqGNECwQMUPS+0SyE/IQTTIJKcJ0qphNNuxP2dr9qlF7vUP5LH3RAw4Da
   RJzka/+ekx/LIYhqqQONsGEKNtRGbuvel0A4EOR52BSOB+n3SDjzSCMrV
   RPN598xjxKi/cQ32vP4Emjs3EFWvcZDH01gYAwTnbYFwu3gFyvBasC5bO
   ZzqNlJI64bnDpRzHkY36zYy2QxNPHyFHkjMKR7isqP/NjO1sl0UjZslDm
   DKk6asNDFk8oEaxhzv75JjGpaR9K4q+oTm2Af8fZWBdUHh8pcPdAycgZT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="343391727"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="343391727"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="777601736"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="777601736"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2023 08:58:04 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next v2 2/4] net: stmmac: introduce wrapper for struct xdp_buff
Date:   Mon, 10 Apr 2023 23:57:20 +0800
Message-Id: <20230410155722.335908-3-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410155722.335908-1-yoong.siang.song@intel.com>
References: <20230410155722.335908-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce struct stmmac_xdp_buff as a preparation to support XDP Rx
metadata via kfuncs.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h   |  4 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 +++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 3d15e1e92e18..ac8ccf851708 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -92,6 +92,10 @@ struct stmmac_rx_buffer {
 	dma_addr_t sec_addr;
 };
 
+struct stmmac_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 struct stmmac_rx_queue {
 	u32 rx_count_frames;
 	u32 queue_index;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2cc6237a9c28..f7bbdf04d20c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5189,9 +5189,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
 	enum dma_data_direction dma_dir;
+	struct stmmac_xdp_buff ctx = {};
 	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
-	struct xdp_buff xdp;
 	int xdp_status = 0;
 	int buf_sz;
 
@@ -5313,17 +5313,17 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			dma_sync_single_for_cpu(priv->device, buf->addr,
 						buf1_len, dma_dir);
 
-			xdp_init_buff(&xdp, buf_sz, &rx_q->xdp_rxq);
-			xdp_prepare_buff(&xdp, page_address(buf->page),
+			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
+			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
 					 buf->page_offset, buf1_len, false);
 
-			pre_len = xdp.data_end - xdp.data_hard_start -
+			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
 				  buf->page_offset;
-			skb = stmmac_xdp_run_prog(priv, &xdp);
+			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
 			/* Due xdp_adjust_tail: DMA sync for_device
 			 * cover max len CPU touch
 			 */
-			sync_len = xdp.data_end - xdp.data_hard_start -
+			sync_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
 				   buf->page_offset;
 			sync_len = max(sync_len, pre_len);
 
@@ -5333,7 +5333,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 				if (xdp_res & STMMAC_XDP_CONSUMED) {
 					page_pool_put_page(rx_q->page_pool,
-							   virt_to_head_page(xdp.data),
+							   virt_to_head_page(ctx.xdp.data),
 							   sync_len, true);
 					buf->page = NULL;
 					priv->dev->stats.rx_dropped++;
@@ -5361,7 +5361,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		if (!skb) {
 			/* XDP program may expand or reduce tail */
-			buf1_len = xdp.data_end - xdp.data;
+			buf1_len = ctx.xdp.data_end - ctx.xdp.data;
 
 			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
 			if (!skb) {
@@ -5371,7 +5371,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			}
 
 			/* XDP program may adjust header */
-			skb_copy_to_linear_data(skb, xdp.data, buf1_len);
+			skb_copy_to_linear_data(skb, ctx.xdp.data, buf1_len);
 			skb_put(skb, buf1_len);
 
 			/* Data payload copied into SKB, page ready for recycle */
-- 
2.34.1

