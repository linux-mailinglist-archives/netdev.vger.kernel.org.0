Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BD454D9A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfFYL16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5675 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729579AbfFYL16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 07:27:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF1AF85550;
        Tue, 25 Jun 2019 11:27:57 +0000 (UTC)
Received: from carbon (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E3135C234;
        Tue, 25 Jun 2019 11:27:52 +0000 (UTC)
Date:   Tue, 25 Jun 2019 13:27:50 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, mcroce@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net-next v2 08/12] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190625132750.06939133@carbon>
In-Reply-To: <20190625105013.GA6485@khorivan>
References: <156086304827.27760.11339786046465638081.stgit@firesoul>
        <156086314789.27760.6549333469314693352.stgit@firesoul>
        <20190625105013.GA6485@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 25 Jun 2019 11:27:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 13:50:14 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Hi Jesper,
> 
> Could you please clarify one question.
> 
> On Tue, Jun 18, 2019 at 03:05:47PM +0200, Jesper Dangaard Brouer wrote:
> >This patch is needed before we can allow drivers to use page_pool for
> >DMA-mappings. Today with page_pool and XDP return API, it is possible to
> >remove the page_pool object (from rhashtable), while there are still
> >in-flight packet-pages. This is safely handled via RCU and failed lookups in
> >__xdp_return() fallback to call put_page(), when page_pool object is gone.
> >In-case page is still DMA mapped, this will result in page note getting
> >correctly DMA unmapped.
> >
> >To solve this, the page_pool is extended with tracking in-flight pages. And
> >XDP disconnect system queries page_pool and waits, via workqueue, for all
> >in-flight pages to be returned.
> >
> >To avoid killing performance when tracking in-flight pages, the implement
> >use two (unsigned) counters, that in placed on different cache-lines, and
> >can be used to deduct in-flight packets. This is done by mapping the
> >unsigned "sequence" counters onto signed Two's complement arithmetic
> >operations. This is e.g. used by kernel's time_after macros, described in
> >kernel commit 1ba3aab3033b and 5a581b367b5, and also explained in RFC1982.
> >
> >The trick is these two incrementing counters only need to be read and
> >compared, when checking if it's safe to free the page_pool structure. Which
> >will only happen when driver have disconnected RX/alloc side. Thus, on a
> >non-fast-path.
> >
> >It is chosen that page_pool tracking is also enabled for the non-DMA
> >use-case, as this can be used for statistics later.
> >
> >After this patch, using page_pool requires more strict resource "release",
> >e.g. via page_pool_release_page() that was introduced in this patchset, and
> >previous patches implement/fix this more strict requirement.
> >
> >Drivers no-longer call page_pool_destroy(). Drivers already call
> >xdp_rxq_info_unreg() which call xdp_rxq_info_unreg_mem_model(), which will
> >attempt to disconnect the mem id, and if attempt fails schedule the
> >disconnect for later via delayed workqueue.
> >
> >Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> >---
> > drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
> > include/net/page_pool.h                           |   41 ++++++++++---
> > net/core/page_pool.c                              |   62 +++++++++++++++-----
> > net/core/xdp.c                                    |   65 +++++++++++++++++++--
> > 4 files changed, 136 insertions(+), 35 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >index 2f647be292b6..6c9d4d7defbc 100644
> >--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >@@ -643,9 +643,6 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
> > 	}
> >
> > 	xdp_rxq_info_unreg(&rq->xdp_rxq);
> >-	if (rq->page_pool)
> >-		page_pool_destroy(rq->page_pool);
> >-
> > 	mlx5_wq_destroy(&rq->wq_ctrl);
> > }
> >
> >diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> >index 754d980700df..f09b3f1994e6 100644
> >--- a/include/net/page_pool.h
> >+++ b/include/net/page_pool.h
> >@@ -16,14 +16,16 @@
> >  * page_pool_alloc_pages() call.  Drivers should likely use
> >  * page_pool_dev_alloc_pages() replacing dev_alloc_pages().
> >  *
> >- * If page_pool handles DMA mapping (use page->private), then API user
> >- * is responsible for invoking page_pool_put_page() once.  In-case of
> >- * elevated refcnt, the DMA state is released, assuming other users of
> >- * the page will eventually call put_page().
> >+ * API keeps track of in-flight pages, in-order to let API user know
> >+ * when it is safe to dealloactor page_pool object.  Thus, API users
> >+ * must make sure to call page_pool_release_page() when a page is
> >+ * "leaving" the page_pool.  Or call page_pool_put_page() where
> >+ * appropiate.  For maintaining correct accounting.
> >  *
> >- * If no DMA mapping is done, then it can act as shim-layer that
> >- * fall-through to alloc_page.  As no state is kept on the page, the
> >- * regular put_page() call is sufficient.
> >+ * API user must only call page_pool_put_page() once on a page, as it
> >+ * will either recycle the page, or in case of elevated refcnt, it
> >+ * will release the DMA mapping and in-flight state accounting.  We
> >+ * hope to lift this requirement in the future.
> >  */
> > #ifndef _NET_PAGE_POOL_H
> > #define _NET_PAGE_POOL_H
> >@@ -66,9 +68,10 @@ struct page_pool_params {
> > };
> >
> > struct page_pool {
> >-	struct rcu_head rcu;
> > 	struct page_pool_params p;
> >
> >+        u32 pages_state_hold_cnt;
> >+
> > 	/*
> > 	 * Data structure for allocation side
> > 	 *
> >@@ -96,6 +99,8 @@ struct page_pool {
> > 	 * TODO: Implement bulk return pages into this structure.
> > 	 */
> > 	struct ptr_ring ring;
> >+
> >+	atomic_t pages_state_release_cnt;
> > };
> >
> > struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> >@@ -109,8 +114,6 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
> >
> > struct page_pool *page_pool_create(const struct page_pool_params *params);
> >
> >-void page_pool_destroy(struct page_pool *pool);
> >-
> > void __page_pool_free(struct page_pool *pool);
> > static inline void page_pool_free(struct page_pool *pool)
> > {
> >@@ -143,6 +146,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> > 	__page_pool_put_page(pool, page, true);
> > }
> >
> >+/* API user MUST have disconnected alloc-side (not allowed to call
> >+ * page_pool_alloc_pages()) before calling this.  The free-side can
> >+ * still run concurrently, to handle in-flight packet-pages.
> >+ *
> >+ * A request to shutdown can fail (with false) if there are still
> >+ * in-flight packet-pages.
> >+ */
> >+bool __page_pool_request_shutdown(struct page_pool *pool);
> >+static inline bool page_pool_request_shutdown(struct page_pool *pool)
> >+{
> >+	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
> >+	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
> >+	 */
> >+#ifdef CONFIG_PAGE_POOL
> >+	return __page_pool_request_shutdown(pool);
> >+#endif
> >+}  
> 
> The free side can ran in softirq, that means fast cache recycle is accessed.
> And it increments not atomic pool->alloc.count.
> 
> For instance While redirect, for remote interface, while .ndo_xdp_xmit the
> xdp_return_frame_rx_napi(xdpf) is called everywhere in error path ....
> 
> In the same time, simultaneously, the work queue can try one more
> time to clear cash, calling __page_pool_request_shutdown()....
>
> Question, what prevents pool->alloc.count to be corrupted by race,
> causing to wrong array num and as result wrong page to be unmapped/put ....or
> even page leak. alloc.count usage is not protected,
> __page_pool_request_shutdown() is called not from same rx NAPI, even not from
> NAPI.
> 
> Here, while alloc cache empty procedure in __page_pool_request_shutdown():

You forgot to copy this comment, which explains:

	/* Empty alloc cache, assume caller made sure this is
	 * no-longer in use, and page_pool_alloc_pages() cannot be
	 * call concurrently.
	 */

> while (pool->alloc.count) {
> 	page = pool->alloc.cache[--pool->alloc.count];
> 	__page_pool_return_page(pool, page);
> }
> 
> For me seems all works fine, but I can't find what have I missed?

You have missed that, it is the drivers responsibility to "disconnect"
the xdp_rxq_info before calling shutdown.  Which means that it is not
allowed to be used for RX, while the driver is shutting down a
RX-queue.  For drivers this is very natural, else other things will
break.

 
> ...
> 
> Same question about how xdp frame should be returned for drivers running
> tx napi exclusively, it can be still softirq but another CPU? What API
> should be used to return xdp frame.

You have to use the normal xdp_return_frame() which doesn't do "direct"
return.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
