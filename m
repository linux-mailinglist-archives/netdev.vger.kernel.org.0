Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A373863E315
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiK3WIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiK3WIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218FA54346
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=232s0hcEdsLQ/y1Kk8Yj7ntJwtD3lvyB86OlxbT/3Qk=; b=jFJOcsOFUZpRAPlwzC0tgzjzX6
        tcYyjq0ix/8JY3blCrvpbonmwCqm5eDaCzuZzcgswzh0HmL3NxMaK67T5ZXd5T4GjkTE6B64Eo2lc
        VLItc01IyTRNrCYlQnHOKnxH0VIuTNSHVmicFG3pHN7FX3tyj79w0SuwkFouGetym/msUbbnjY5Fu
        qagNUTOoeJhIWaz86lfELzxtsDZgiFLlFepVxUij2nO7kNnxCHHNfHEIJr6ZjTwAbgcADYz3r5SrF
        1mhVqNusPeOUCt01aehAdHdJauZawKzFobbVun2qMxDcgVB5NUuSR/Ui1FA1zS/H9qabe7Dc1QSC8
        roSC99vg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFO-00FLWo-VB; Wed, 30 Nov 2022 22:08:07 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 22/24] page_pool: Pass a netmem to init_callback()
Date:   Wed, 30 Nov 2022 22:08:01 +0000
Message-Id: <20221130220803.3657490-23-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
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
index e13e3a8e83d3..4878fe30f52c 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -164,7 +164,7 @@ struct page_pool_params {
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
-	void (*init_callback)(struct page *page, void *arg);
+	void (*init_callback)(struct netmem *nmem, void *arg);
 	void *init_arg;
 };
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6094ef7cffcd..921b085802af 100644
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
index 5be78ec93af8..bed40515e74c 100644
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

