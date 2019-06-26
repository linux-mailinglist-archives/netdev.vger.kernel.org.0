Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBF156C23
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFZOgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:23 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59953 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728137AbfFZOgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:21 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:17 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGYA027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 12/16] net/mlx5e: XDP_TX from UMEM support
Date:   Wed, 26 Jun 2019 17:35:34 +0300
Message-Id: <1561559738-4213-13-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

When an XDP program returns XDP_TX, and the RQ is XSK-enabled, it
requires careful handling, because convert_to_xdp_frame creates a new
page and copies the data there, while our driver expects the xdp_frame
to point to the same memory as the xdp_buff. Handle this case
separately: map the page, and in the end unmap it and call
xdp_return_frame.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 50 ++++++++++++++++++++----
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index b3e118fc4521..1364bdff702c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -69,14 +69,48 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params)
 	xdptxd.data = xdpf->data;
 	xdptxd.len  = xdpf->len;
 
-	xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
+	if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY) {
+		/* The xdp_buff was in the UMEM and was copied into a newly
+		 * allocated page. The UMEM page was returned via the ZCA, and
+		 * this new page has to be mapped at this point and has to be
+		 * unmapped and returned via xdp_return_frame on completion.
+		 */
+
+		/* Prevent double recycling of the UMEM page. Even in case this
+		 * function returns false, the xdp_buff shouldn't be recycled,
+		 * as it was already done in xdp_convert_zc_to_xdp_frame.
+		 */
+		__set_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags); /* non-atomic */
+
+		xdpi.mode = MLX5E_XDP_XMIT_MODE_FRAME;
 
-	dma_addr = di->addr + (xdpf->data - (void *)xdpf);
-	dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len, DMA_TO_DEVICE);
+		dma_addr = dma_map_single(sq->pdev, xdptxd.data, xdptxd.len,
+					  DMA_TO_DEVICE);
+		if (dma_mapping_error(sq->pdev, dma_addr)) {
+			xdp_return_frame(xdpf);
+			return false;
+		}
 
-	xdptxd.dma_addr = dma_addr;
-	xdpi.page.rq = rq;
-	xdpi.page.di = *di;
+		xdptxd.dma_addr     = dma_addr;
+		xdpi.frame.xdpf     = xdpf;
+		xdpi.frame.dma_addr = dma_addr;
+	} else {
+		/* Driver assumes that convert_to_xdp_frame returns an xdp_frame
+		 * that points to the same memory region as the original
+		 * xdp_buff. It allows to map the memory only once and to use
+		 * the DMA_BIDIRECTIONAL mode.
+		 */
+
+		xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
+
+		dma_addr = di->addr + (xdpf->data - (void *)xdpf);
+		dma_sync_single_for_device(sq->pdev, dma_addr, xdptxd.len,
+					   DMA_TO_DEVICE);
+
+		xdptxd.dma_addr = dma_addr;
+		xdpi.page.rq    = rq;
+		xdpi.page.di    = *di;
+	}
 
 	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi);
 }
@@ -298,13 +332,13 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 
 		switch (xdpi.mode) {
 		case MLX5E_XDP_XMIT_MODE_FRAME:
-			/* XDP_REDIRECT */
+			/* XDP_TX from the XSK RQ and XDP_REDIRECT */
 			dma_unmap_single(sq->pdev, xdpi.frame.dma_addr,
 					 xdpi.frame.xdpf->len, DMA_TO_DEVICE);
 			xdp_return_frame(xdpi.frame.xdpf);
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
-			/* XDP_TX */
+			/* XDP_TX from the regular RQ */
 			mlx5e_page_release(xdpi.page.rq, &xdpi.page.di, recycle);
 			break;
 		default:
-- 
1.8.3.1

