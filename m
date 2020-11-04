Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DC82A6175
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgKDKYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbgKDKXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 05:23:22 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1DC7223FD;
        Wed,  4 Nov 2020 10:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604485401;
        bh=2T02Rnj9JSqlSyqTOWwETG3CNvYOciUI7owaOFmtoLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4jCE5nxQDLJja4wZk3QNIuw0/25+ovfmzCmcywd2yMdlivmCgwo0sV12hjzcIP/V
         WGqdRL6r5osVl3+SxB0avN0a2xfZ/ZZE3qCOv1SM5IL/cQp9awj6UWd6i+zgcheO7P
         9SNtSBb5mNM3R5uwlMqpS9GCwhjhVH/1tMQng2uw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v3 net-next 5/5] net: mlx5: add xdp tx return bulking support
Date:   Wed,  4 Nov 2020 11:22:58 +0100
Message-Id: <b89c75506e8bf37654d279ee2cc630e34061edb8.1604484917.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604484917.git.lorenzo@kernel.org>
References: <cover.1604484917.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mlx5 driver to xdp_return_frame_bulk APIs.

XDP_REDIRECT (upstream codepath): 8.5Mpps
XDP_REDIRECT (upstream codepath + bulking APIs): 10.1Mpps

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index ae90d533a350..5fdfbf390d5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -369,8 +369,10 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				  bool recycle)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
+	struct xdp_frame_bulk bq;
 	u16 i;
 
+	bq.xa = NULL;
 	for (i = 0; i < wi->num_pkts; i++) {
 		struct mlx5e_xdp_info xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 
@@ -379,7 +381,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			/* XDP_TX from the XSK RQ and XDP_REDIRECT */
 			dma_unmap_single(sq->pdev, xdpi.frame.dma_addr,
 					 xdpi.frame.xdpf->len, DMA_TO_DEVICE);
-			xdp_return_frame(xdpi.frame.xdpf);
+			xdp_return_frame_bulk(xdpi.frame.xdpf, &bq);
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
@@ -393,6 +395,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			WARN_ON_ONCE(true);
 		}
 	}
+	xdp_flush_frame_bulk(&bq);
 }
 
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
-- 
2.26.2

