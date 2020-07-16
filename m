Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62279222F20
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgGPXf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726337AbgGPXfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:35:17 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10322085B;
        Thu, 16 Jul 2020 22:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594937829;
        bh=YxVF/rz7N6Vl7/RW2/fvVoSAIMf7NnV+qlVFE0IH2D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TppmXgjY/0jLyA6tKGNS0cZaL6rq33r2REfVqgTVgm/b7WWOsibZHqZh0PiqPZkWi
         MqzYN/V1gXDlKKNpKYQs+xSuXhQXhDPVSDkR2SjHhivOdWY9U+mjjOQRLSIE6TKiTb
         LyXMhRHnbn+999P5gxB9dQ5dAo/hsgoY4v1Nh+iE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH v2 net-next 3/6] net: mvneta: move mvneta_run_xdp after descriptors processing
Date:   Fri, 17 Jul 2020 00:16:31 +0200
Message-Id: <3bb5b9970e31093c5975ffbe964e54b9b90ce64e.1594936660.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594936660.git.lorenzo@kernel.org>
References: <cover.1594936660.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move mvneta_run_xdp routine after all descriptor processing. This is a
preliminary patch to enable multi-buffers and JUMBO frames support for
XDP

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e9b3fb778d76..021419428ff8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2230,12 +2230,11 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	return ret;
 }
 
-static int
+static void
 mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_desc *rx_desc,
 		     struct mvneta_rx_queue *rxq,
 		     struct xdp_buff *xdp,
-		     struct bpf_prog *xdp_prog,
 		     struct page *page,
 		     struct mvneta_stats *stats)
 {
@@ -2244,7 +2243,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
 	struct skb_shared_info *sinfo;
-	int ret = 0;
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2270,13 +2268,8 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	sinfo = xdp_get_shared_info_from_buff(xdp);
 	sinfo->nr_frags = 0;
 
-	if (xdp_prog)
-		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp, stats);
-
 	rxq->left_size = rx_desc->data_size - len;
 	rx_desc->buf_phys_addr = 0;
-
-	return ret;
 }
 
 static void
@@ -2385,20 +2378,15 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		rxq->refill_num++;
 
 		if (rx_status & MVNETA_RXD_FIRST_DESC) {
-			int err;
-
 			/* Check errors only for FIRST descriptor */
 			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
 				mvneta_rx_error(pp, rx_desc);
 				goto next;
 			}
 
-			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
-						   xdp_prog, page, &ps);
-			if (err)
-				continue;
-
 			desc_status = rx_desc->status;
+			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf, page,
+					     &ps);
 		} else {
 			if (unlikely(!xdp_buf.data_hard_start))
 				continue;
@@ -2417,6 +2405,10 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			goto next;
 		}
 
+		if (xdp_prog &&
+		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, &ps))
+			goto next;
+
 		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-- 
2.26.2

