Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681C844AA8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfFMS23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:28:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfFMS22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:28:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9226F4E908;
        Thu, 13 Jun 2019 18:28:28 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1675F541C1;
        Thu, 13 Jun 2019 18:28:23 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 400143009AEFD;
        Thu, 13 Jun 2019 20:28:22 +0200 (CEST)
Subject: [PATCH net-next v1 04/11] xdp: page_pool related fix to cpumap
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:22 +0200
Message-ID: <156045050219.29115.8292087953605173791.stgit@firesoul>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 13 Jun 2019 18:28:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When converting an xdp_frame into an SKB, and sending this into the network
stack, then the underlying XDP memory model need to release associated
resources, because the network stack don't have callbacks for XDP memory
models.  The only memory model that needs this is page_pool, when a driver
use the DMA-mapping feature.

Introduce page_pool_release_page(), which basically does the same as
page_pool_unmap_page(). Add xdp_release_frame() as the XDP memory model
interface for calling it, if the memory model match MEM_TYPE_PAGE_POOL, to
save the function call overhead for others. Have cpumap call
xdp_release_frame() before xdp_scrub_frame().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h |   15 ++++++++++++++-
 include/net/xdp.h       |   15 +++++++++++++++
 kernel/bpf/cpumap.c     |    3 +++
 net/core/xdp.c          |   15 +++++++++++++++
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ad218cef88c5..e240fac4c5b9 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -110,7 +110,6 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 void page_pool_destroy(struct page_pool *pool);
-void page_pool_unmap_page(struct page_pool *pool, struct page *page);
 
 /* Never call this directly, use helpers below */
 void __page_pool_put_page(struct page_pool *pool,
@@ -133,6 +132,20 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	__page_pool_put_page(pool, page, true);
 }
 
+/* Disconnects a page (from a page_pool).  API users can have a need
+ * to disconnect a page (from a page_pool), to allow it to be used as
+ * a regular page (that will eventually be returned to the normal
+ * page-allocator via put_page).
+ */
+void page_pool_unmap_page(struct page_pool *pool, struct page *page);
+static inline void page_pool_release_page(struct page_pool *pool,
+					  struct page *page)
+{
+#ifdef CONFIG_PAGE_POOL
+	page_pool_unmap_page(pool, page);
+#endif
+}
+
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
 	return page->dma_addr;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0f25b3675c5c..a06e5f2dfcc5 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -129,6 +129,21 @@ void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
 
+/* When sending xdp_frame into the network stack, then there is no
+ * return point callback, which is needed to release e.g. DMA-mapping
+ * resources with page_pool.  Thus, have explicit function to release
+ * frame resources.
+ */
+void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
+static inline void xdp_release_frame(struct xdp_frame *xdpf)
+{
+	struct xdp_mem_info *mem = &xdpf->mem;
+
+	/* Curr only page_pool needs this */
+	if (mem->type == MEM_TYPE_PAGE_POOL)
+		__xdp_release_frame(xdpf->data, mem);
+}
+
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 		     struct net_device *dev, u32 queue_index);
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index cf727d77c6c6..b7a3eab4f7c8 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -209,6 +209,9 @@ static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 	 * - RX ring dev queue index	(skb_record_rx_queue)
 	 */
 
+	/* Until page_pool get SKB return path, release DMA here */
+	xdp_release_frame(xdpf);
+
 	/* Allow SKB to reuse area used by xdp_frame */
 	xdp_scrub_frame(xdpf);
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 762abeb89847..179d90570afe 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -381,6 +381,21 @@ void xdp_return_buff(struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL_GPL(xdp_return_buff);
 
+/* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
+void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
+{
+	struct xdp_mem_allocator *xa;
+	struct page *page;
+
+	rcu_read_lock();
+	xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
+	page = virt_to_head_page(data);
+	if (xa)
+		page_pool_release_page(xa->page_pool, page);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(__xdp_release_frame);
+
 int xdp_attachment_query(struct xdp_attachment_info *info,
 			 struct netdev_bpf *bpf)
 {

