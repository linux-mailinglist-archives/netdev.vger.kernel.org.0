Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5DC20D472
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgF2TIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730517AbgF2TCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:42 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AB3C02A554;
        Mon, 29 Jun 2020 06:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WyEJJJCgRVGRkU8WN9UhcfcVIsZ/sAYcYt3L52514pY=; b=qk1Cj7ldG0VpKJ1L7Ep/8xe7Pp
        9k8cZZkYCa9IL95hgfUKHEHwW5s0KAblbjeuqZsBnnI19CuvowPCfw1dTLPgKS3FkUrR2h/n+PY06
        97TcUIzDwgjb3IoJlyscKkAb+5yQbGTCnnbpdeI4EHtPTtcKUIydPZpk1bl3qU3VujBRKSjd6eZOE
        xa8Uy4g5ks9sala8WPuPI2bA+n2Uemvv63DHiSiJB2j0isoWOYVRwxxV9ATckd3YJ84tCER+b87zL
        98iF0nzBOOdoXt6wfFrzLO8gp5Is05eIxrkinodskxZv/6i5kYtNMdYJ5hn9S2090WmBMKAHWHzL+
        w/V6IeJQ==;
Received: from [2001:4bb8:184:76e3:c71:f334:376b:cf5f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jptS8-0004XF-Gg; Mon, 29 Jun 2020 13:04:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] xsk: replace the cheap_dma flag with a dma_need_sync flag
Date:   Mon, 29 Jun 2020 15:03:57 +0200
Message-Id: <20200629130359.2690853-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629130359.2690853-1-hch@lst.de>
References: <20200629130359.2690853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Invert the polarity and better name the flag so that the use case is
properly documented.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/xsk_buff_pool.h | 6 +++---
 net/xdp/xsk_buff_pool.c     | 5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a4ff226505c99c..6842990e2712bd 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -40,7 +40,7 @@ struct xsk_buff_pool {
 	u32 headroom;
 	u32 chunk_size;
 	u32 frame_len;
-	bool cheap_dma;
+	bool dma_need_sync;
 	bool unaligned;
 	void *addrs;
 	struct device *dev;
@@ -80,7 +80,7 @@ static inline dma_addr_t xp_get_frame_dma(struct xdp_buff_xsk *xskb)
 void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
 static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
 {
-	if (xskb->pool->cheap_dma)
+	if (!xskb->pool->dma_need_sync)
 		return;
 
 	xp_dma_sync_for_cpu_slow(xskb);
@@ -91,7 +91,7 @@ void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
 static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
 					  dma_addr_t dma, size_t size)
 {
-	if (pool->cheap_dma)
+	if (!pool->dma_need_sync)
 		return;
 
 	xp_dma_sync_for_device_slow(pool, dma, size);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 540ed75e44821c..9fe84c797a7060 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -55,7 +55,6 @@ struct xsk_buff_pool *xp_create(struct page **pages, u32 nr_pages, u32 chunks,
 	pool->free_heads_cnt = chunks;
 	pool->headroom = headroom;
 	pool->chunk_size = chunk_size;
-	pool->cheap_dma = true;
 	pool->unaligned = unaligned;
 	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
 	INIT_LIST_HEAD(&pool->free_list);
@@ -195,7 +194,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 		xp_check_dma_contiguity(pool);
 
 	pool->dev = dev;
-	pool->cheap_dma = xp_check_cheap_dma(pool);
+	pool->dma_need_sync = !xp_check_cheap_dma(pool);
 	return 0;
 }
 EXPORT_SYMBOL(xp_dma_map);
@@ -280,7 +279,7 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
 	xskb->xdp.data = xskb->xdp.data_hard_start + XDP_PACKET_HEADROOM;
 	xskb->xdp.data_meta = xskb->xdp.data;
 
-	if (!pool->cheap_dma) {
+	if (pool->dma_need_sync) {
 		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
 						 pool->frame_len,
 						 DMA_BIDIRECTIONAL);
-- 
2.26.2

