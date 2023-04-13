Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1218D6E0528
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 05:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDMD0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 23:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDMD00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 23:26:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B16526C;
        Wed, 12 Apr 2023 20:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681356385; x=1712892385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pL4q42CrpzLZpFIa2Sgvsf2gW8kvjKkSwOWcp1h+M68=;
  b=nZbbSu+//FyuT3oSpxgXqjaU011ls9M6m7nwxBTEx3B4fuVPAKHqejZh
   BUnc0SfB7ILJNLqwJ/DRPbHg8snabVudV3uRmsqqxhquRFG4sHWz8Jj4R
   kZkFtV32MOr9i2njLXS5o6ALrEabfBdo/D/d60P0PYefEBIcMDmhL4zHO
   NrflYTWIMmjDykZXnLwRfc1NFiz4DA2wTH99OuvXMzw41JF/WDwvNG+v0
   L22jd+uHrpt0BIBr7DqCVKQlOLg4R5ftHlpMTUM0yDIaZq9yLJhP9DR5w
   Jb8F6viDGDlA/vGH9uPmsju4syEJpGmak47U1TQR6CyVlVUE5ewsGitOa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="332781640"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="332781640"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 20:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="800597041"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="800597041"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga002.fm.intel.com with ESMTP; 12 Apr 2023 20:26:18 -0700
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
Subject: [PATCH net-next v4 1/3] net: stmmac: introduce wrapper for struct xdp_buff
Date:   Thu, 13 Apr 2023 11:25:39 +0800
Message-Id: <20230413032541.885238-2-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413032541.885238-1-yoong.siang.song@intel.com>
References: <20230413032541.885238-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce struct stmmac_xdp_buff as a preparation to support XDP Rx
metadata via kfuncs.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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
index d7fcab057032..6ffce52ca837 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5188,9 +5188,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
 	enum dma_data_direction dma_dir;
+	struct stmmac_xdp_buff ctx = {};
 	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
-	struct xdp_buff xdp;
 	int xdp_status = 0;
 	int buf_sz;
 
@@ -5311,17 +5311,17 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
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
 
@@ -5331,7 +5331,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 				if (xdp_res & STMMAC_XDP_CONSUMED) {
 					page_pool_put_page(rx_q->page_pool,
-							   virt_to_head_page(xdp.data),
+							   virt_to_head_page(ctx.xdp.data),
 							   sync_len, true);
 					buf->page = NULL;
 					priv->dev->stats.rx_dropped++;
@@ -5359,7 +5359,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		if (!skb) {
 			/* XDP program may expand or reduce tail */
-			buf1_len = xdp.data_end - xdp.data;
+			buf1_len = ctx.xdp.data_end - ctx.xdp.data;
 
 			skb = napi_alloc_skb(&ch->rx_napi, buf1_len);
 			if (!skb) {
@@ -5369,7 +5369,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			}
 
 			/* XDP program may adjust header */
-			skb_copy_to_linear_data(skb, xdp.data, buf1_len);
+			skb_copy_to_linear_data(skb, ctx.xdp.data, buf1_len);
 			skb_put(skb, buf1_len);
 
 			/* Data payload copied into SKB, page ready for recycle */
-- 
2.34.1

