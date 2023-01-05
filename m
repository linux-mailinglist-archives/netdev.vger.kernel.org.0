Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A89F65F61D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbjAEVrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbjAEVqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:46:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136C4676C7
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pXeNES8pyHVZBMwH4642v/IjLs/jyC0INFstQa9QZBQ=; b=eOJKLnG8Rr92sywy/+UEfUME49
        VQiOPrQaj2vRFtRTufsxm632f3qKW6xizMlKfNJHA/L4I5RG57xbOjW+yoOlXZM9PWRF4UVWIFXSU
        y9zMNId29AsEMqJ00is1Dh7fuOuF4H4EDdANupo8Ry9RNr40DGRqZvrSF7teb1z5eN5arTyatyBqS
        L0XQq+WicyY8SiVom780FshL0lUQyKqKWj8vopqV3kXJPJrIHXEg7Me+JLH0wfQPhd3b19+DKLP91
        ZNMTsBXw9gJbRC7uRCROpn+q+xCas0M906m1tWeiHe4xIV2PAdkESeMMu1o/1K8zIMhtfIqllRx93
        Pv9LQarA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4J-00GWob-G5; Thu, 05 Jan 2023 21:46:35 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 21/24] page_pool: Pass a netmem to init_callback()
Date:   Thu,  5 Jan 2023 21:46:28 +0000
Message-Id: <20230105214631.3939268-22-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the only user of init_callback.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 2 +-
 net/bpf/test_run.c      | 4 ++--
 net/core/page_pool.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index c607d67c96dc..d2f98b9dce13 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -181,7 +181,7 @@ struct page_pool_params {
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
-	void (*init_callback)(struct page *page, void *arg);
+	void (*init_callback)(struct netmem *nmem, void *arg);
 	void *init_arg;
 };
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2723623429ac..bd3c64e69f6e 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -116,9 +116,9 @@ struct xdp_test_data {
 #define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
 #define TEST_XDP_MAX_BATCH 256
 
-static void xdp_test_run_init_page(struct page *page, void *arg)
+static void xdp_test_run_init_page(struct netmem *nmem, void *arg)
 {
-	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
+	struct xdp_page_head *head = netmem_to_virt(nmem);
 	struct xdp_buff *new_ctx, *orig_ctx;
 	u32 headroom = XDP_PACKET_HEADROOM;
 	struct xdp_test_data *xdp = arg;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5624cdae1f4e..a1e404a7397f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -334,7 +334,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 	nmem->pp = pool;
 	nmem->pp_magic |= PP_SIGNATURE;
 	if (pool->p.init_callback)
-		pool->p.init_callback(netmem_page(nmem), pool->p.init_arg);
+		pool->p.init_callback(nmem, pool->p.init_arg);
 }
 
 static void page_pool_clear_pp_info(struct netmem *nmem)
-- 
2.35.1

