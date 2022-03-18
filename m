Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4E4DE2F2
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240898AbiCRUyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbiCRUyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A0ADF35
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E843060C96
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C7DC340EF;
        Fri, 18 Mar 2022 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636795;
        bh=nYtNf99CA7LgQGDafp7syF0XytkZyX/9FJN8VJu90Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxWcd9x8gBUFO9+3vy7GqThUhFbG4PMWCU6ZpMRrOp7RtWVMPlGLdJfjMzGNyWhuM
         e0/rnoagink6gPattCicftrpDVg5DywtEl+OG7li3w9VI/RpMUgJ5si9aXmnqf1cGx
         jaaRwSr6cqNFk4nAe+k+5v68jBtnkhcn08IX4vFFF+hS+uAztHNk95YC6aHlNkuMQY
         2/XBYFK5kvo+2qO1TPf+NRZx8EfPLOxfRevjgYBG7BKWDWhkB/ERWcw4QsrANU7WrX
         qfj4GpMkaVbcIL73UOAM700VZSmbRXwkYZAHDEaKR3oktkTujBgGTocTDARu0dyAWU
         8RvCN50m0wwJQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Support multi buffer XDP_TX
Date:   Fri, 18 Mar 2022 13:52:44 -0700
Message-Id: <20220318205248.33367-12-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

This commit enables passing multi buffer XDP frames to the TX handlers
on XDP_TX. Fragments are DMA synchronized to the device and queued to
the xdpi_fifo for a subsequent unmapping.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 368e54949614..f35b62ce4c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -59,20 +59,17 @@ static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		    struct page *page, struct xdp_buff *xdp)
 {
+	struct skb_shared_info *sinfo = NULL;
 	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
 	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
+	int i;
 
 	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return false;
 
-	if (unlikely(xdp_frame_has_frags(xdpf))) {
-		xdp_return_frame(xdpf);
-		return false;
-	}
-
 	xdptxd.data = xdpf->data;
 	xdptxd.len  = xdpf->len;
 
@@ -117,19 +114,45 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	 */
 
 	xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
+	xdpi.page.rq = rq;
 
 	dma_addr = page_pool_get_dma_addr(page) + (xdpf->data - (void *)xdpf);
 	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_TO_DEVICE);
 
+	if (unlikely(xdp_frame_has_frags(xdpf))) {
+		sinfo = xdp_get_shared_info_from_frame(xdpf);
+
+		for (i = 0; i < sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &sinfo->frags[i];
+			dma_addr_t addr;
+			u32 len;
+
+			addr = page_pool_get_dma_addr(skb_frag_page(frag)) +
+				skb_frag_off(frag);
+			len = skb_frag_size(frag);
+			dma_sync_single_for_device(sq->pdev, addr, len,
+						   DMA_TO_DEVICE);
+		}
+	}
+
 	xdptxd.dma_addr = dma_addr;
-	xdpi.page.rq = rq;
-	xdpi.page.page = page;
 
 	if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, NULL, 0)))
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, sinfo, 0)))
 		return false;
 
+	xdpi.page.page = page;
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+
+	if (unlikely(xdp_frame_has_frags(xdpf))) {
+		for (i = 0; i < sinfo->nr_frags; i++) {
+			skb_frag_t *frag = &sinfo->frags[i];
+
+			xdpi.page.page = skb_frag_page(frag);
+			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+		}
+	}
+
 	return true;
 }
 
-- 
2.35.1

