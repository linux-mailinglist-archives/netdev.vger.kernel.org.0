Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427141606A6
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 22:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgBPVI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 16:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgBPVI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 16:08:28 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F0120726;
        Sun, 16 Feb 2020 21:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887307;
        bh=XpypPE1fCkyxVWBL5gUfiePN0m0gUNYfeusYLpVFucE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYOTskG6vZPAzzwXSzqweSwn06+DlL32wQqVtkN+wk2RFU11EvnglvKFhzVty/LmG
         ko6GRBe1DHVy/l+7LfSJMKooxI056VccDwV6IWcQx2AfybDydikn7JYzbTj4MTcUxQ
         xc+DCvqIFaQl0DmP4xlwUGisbsJUyzyKETp/gi+w=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net-next 5/5] net: mvneta: get rid of xdp_ret in mvneta_swbm_rx_frame
Date:   Sun, 16 Feb 2020 22:07:33 +0100
Message-Id: <7984981598af702a67e5b2560c7616a9665ee808.1581886691.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581886691.git.lorenzo@kernel.org>
References: <cover.1581886691.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get rid of xdp_ret in mvneta_swbm_rx_frame routine since now
we can rely on xdp_stats to flush in case of xdp_redirect

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 30 ++++++++++++---------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e4eb2bd097d4..b7045b6a15c2 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -358,10 +358,10 @@ struct mvneta_statistic {
 #define T_REG_64	64
 #define T_SW		1
 
-#define MVNETA_XDP_PASS		BIT(0)
-#define MVNETA_XDP_DROPPED	BIT(1)
-#define MVNETA_XDP_TX		BIT(2)
-#define MVNETA_XDP_REDIR	BIT(3)
+#define MVNETA_XDP_PASS		0
+#define MVNETA_XDP_DROPPED	BIT(0)
+#define MVNETA_XDP_TX		BIT(1)
+#define MVNETA_XDP_REDIR	BIT(2)
 
 static const struct mvneta_statistic mvneta_statistics[] = {
 	{ 0x3000, T_REG_64, "good_octets_received", },
@@ -2183,13 +2183,14 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 		     struct mvneta_rx_queue *rxq,
 		     struct xdp_buff *xdp,
 		     struct bpf_prog *xdp_prog,
-		     struct page *page, u32 *xdp_ret,
+		     struct page *page,
 		     struct mvneta_stats *stats)
 {
 	unsigned char *data = page_address(page);
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
+	int ret = 0;
 
 	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2213,14 +2214,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	xdp_set_data_meta_invalid(xdp);
 
 	if (xdp_prog) {
-		u32 ret;
-
 		ret = mvneta_run_xdp(pp, rxq, xdp_prog, xdp, stats);
-		if (ret != MVNETA_XDP_PASS) {
-			rx_desc->buf_phys_addr = 0;
-			*xdp_ret |= ret;
-			return ret;
-		}
+		if (ret)
+			goto out;
 	}
 
 	rxq->skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
@@ -2244,9 +2240,11 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
 
 	rxq->left_size = rx_desc->data_size - len;
+
+out:
 	rx_desc->buf_phys_addr = 0;
 
-	return 0;
+	return ret;
 }
 
 static void
@@ -2292,7 +2290,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp_buf;
-	u32 xdp_ret = 0;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -2325,8 +2322,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			}
 
 			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
-						   xdp_prog, page, &xdp_ret,
-						   &ps);
+						   xdp_prog, page, &ps);
 			if (err)
 				continue;
 		} else {
@@ -2364,7 +2360,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	}
 	rcu_read_unlock();
 
-	if (xdp_ret & MVNETA_XDP_REDIR)
+	if (ps.xdp_redirect)
 		xdp_do_flush_map();
 
 	if (ps.rx_packets)
-- 
2.24.1

