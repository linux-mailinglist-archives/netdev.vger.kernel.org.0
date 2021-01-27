Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086993064DD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhA0UMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:12:44 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:56920 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbhA0UM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:12:29 -0500
Date:   Wed, 27 Jan 2021 20:11:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611778289; bh=qxnDWFVEqg5VGfDWPP9D9tEqnWHHalzlBI7RQuSD1Vc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Jm5Eiw1SE4FqIosGATgxGGliy7MW7yjcwsjhgvAwQ+PggG0Bw0ZeQWCyFoxMM5jak
         GGjzN6mdBg72k4wtOOTQG1zPOwmrFcg+gjFodALcTEbRRa99WEUo7ELS4VnspMRlxe
         CNx5jcoVWopBkmLe1LBb4rT5pbNvOBAZ08YoK80unO0YA6n0zs/FLxIFVS6jVpP0ot
         XVNP3ryyb5vzVnDcahUDWe+SmSOwNFJzywpMD764BaOv0uU+gPiIm3DGLDcBw7VLRs
         Li7kLE4U6Ei40YVQE3kUwBa2ommgbaVrgxgjg2s6U7XoHsnV6gE6jo2iCFa5LFrshn
         osxMqD+ejTCbg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 3/4] net: introduce common dev_page_is_reserved()
Message-ID: <20210127201031.98544-4-alobakin@pm.me>
In-Reply-To: <20210127201031.98544-1-alobakin@pm.me>
References: <20210127201031.98544-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bunch of drivers test the page before reusing/recycling for two
common conditions:
 - if a page was allocated under memory pressure (pfmemalloc page);
 - if a page was allocated at a distant memory node (to exclude
   slowdowns).

Introduce and use a new common function for doing this and eliminate
all functions-duplicates from drivers.

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 ++--------
 drivers/net/ethernet/intel/fm10k/fm10k_main.c     |  9 ++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 15 +--------------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c       | 15 +--------------
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 11 +----------
 drivers/net/ethernet/intel/igb/igb_main.c         |  7 +------
 drivers/net/ethernet/intel/igc/igc_main.c         |  7 +------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  7 +------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  7 +------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 +------
 include/linux/skbuff.h                            | 15 +++++++++++++++
 11 files changed, 27 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/=
ethernet/hisilicon/hns3/hns3_enet.c
index 512080640cbc..f71e3d963750 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2800,12 +2800,6 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_en=
et_ring *ring,
 =09writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
 }
=20
-static bool hns3_page_is_reusable(struct page *page)
-{
-=09return page_to_nid(page) =3D=3D numa_mem_id() &&
-=09=09!page_is_pfmemalloc(page);
-}
-
 static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
 {
 =09return (page_count(cb->priv) - cb->pagecnt_bias) =3D=3D 1;
@@ -2826,7 +2820,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, =
int i,
 =09/* Avoid re-using remote pages, or the stack is still using the page
 =09 * when page_offset rollback to zero, flag default unreuse
 =09 */
-=09if (unlikely(!hns3_page_is_reusable(desc_cb->priv)) ||
+=09if (unlikely(dev_page_is_reserved(desc_cb->priv)) ||
 =09    (!desc_cb->page_offset && !hns3_can_reuse_page(desc_cb))) {
 =09=09__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
 =09=09return;
@@ -3084,7 +3078,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring=
, unsigned int length,
 =09=09memcpy(__skb_put(skb, length), va, ALIGN(length, sizeof(long)));
=20
 =09=09/* We can reuse buffer as-is, just make sure it is local */
-=09=09if (likely(hns3_page_is_reusable(desc_cb->priv)))
+=09=09if (likely(!dev_page_is_reserved(desc_cb->priv)))
 =09=09=09desc_cb->reuse_flag =3D 1;
 =09=09else /* This page cannot be reused so discard it */
 =09=09=09__page_frag_cache_drain(desc_cb->priv,
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/et=
hernet/intel/fm10k/fm10k_main.c
index 99b8252eb969..9f547dd8c914 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -194,17 +194,12 @@ static void fm10k_reuse_rx_page(struct fm10k_ring *rx=
_ring,
 =09=09=09=09=09 DMA_FROM_DEVICE);
 }
=20
-static inline bool fm10k_page_is_reserved(struct page *page)
-{
-=09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
-}
-
 static bool fm10k_can_reuse_rx_page(struct fm10k_rx_buffer *rx_buffer,
 =09=09=09=09    struct page *page,
 =09=09=09=09    unsigned int __maybe_unused truesize)
 {
 =09/* avoid re-using remote pages */
-=09if (unlikely(fm10k_page_is_reserved(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
@@ -266,7 +261,7 @@ static bool fm10k_add_rx_frag(struct fm10k_rx_buffer *r=
x_buffer,
 =09=09memcpy(__skb_put(skb, size), va, ALIGN(size, sizeof(long)));
=20
 =09=09/* page is not reserved, we can reuse buffer as-is */
-=09=09if (likely(!fm10k_page_is_reserved(page)))
+=09=09if (likely(!dev_page_is_reserved(page)))
 =09=09=09return true;
=20
 =09=09/* this page cannot be reused so discard it */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethe=
rnet/intel/i40e/i40e_txrx.c
index 2574e78f7597..4c295671aa09 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1843,19 +1843,6 @@ static bool i40e_cleanup_headers(struct i40e_ring *r=
x_ring, struct sk_buff *skb,
 =09return false;
 }
=20
-/**
- * i40e_page_is_reusable - check if any reuse is possible
- * @page: page struct to check
- *
- * A page is not reusable if it was allocated under low memory
- * conditions, or it's not in the same NUMA node as this CPU.
- */
-static inline bool i40e_page_is_reusable(struct page *page)
-{
-=09return (page_to_nid(page) =3D=3D numa_mem_id()) &&
-=09=09!page_is_pfmemalloc(page);
-}
-
 /**
  * i40e_can_reuse_rx_page - Determine if this page can be reused by
  * the adapter for another receive
@@ -1891,7 +1878,7 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buf=
fer *rx_buffer,
 =09struct page *page =3D rx_buffer->page;
=20
 =09/* Is any reuse possible? */
-=09if (unlikely(!i40e_page_is_reusable(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethe=
rnet/intel/iavf/iavf_txrx.c
index 256fa07d54d5..a6b552465f03 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1141,19 +1141,6 @@ static void iavf_reuse_rx_page(struct iavf_ring *rx_=
ring,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-/**
- * iavf_page_is_reusable - check if any reuse is possible
- * @page: page struct to check
- *
- * A page is not reusable if it was allocated under low memory
- * conditions, or it's not in the same NUMA node as this CPU.
- */
-static inline bool iavf_page_is_reusable(struct page *page)
-{
-=09return (page_to_nid(page) =3D=3D numa_mem_id()) &&
-=09=09!page_is_pfmemalloc(page);
-}
-
 /**
  * iavf_can_reuse_rx_page - Determine if this page can be reused by
  * the adapter for another receive
@@ -1187,7 +1174,7 @@ static bool iavf_can_reuse_rx_page(struct iavf_rx_buf=
fer *rx_buffer)
 =09struct page *page =3D rx_buffer->page;
=20
 =09/* Is any reuse possible? */
-=09if (unlikely(!iavf_page_is_reusable(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethern=
et/intel/ice/ice_txrx.c
index 422f53997c02..623bbd27870f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -728,15 +728,6 @@ bool ice_alloc_rx_bufs(struct ice_ring *rx_ring, u16 c=
leaned_count)
 =09return !!cleaned_count;
 }
=20
-/**
- * ice_page_is_reserved - check if reuse is possible
- * @page: page struct to check
- */
-static bool ice_page_is_reserved(struct page *page)
-{
-=09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
-}
-
 /**
  * ice_rx_buf_adjust_pg_offset - Prepare Rx buffer for reuse
  * @rx_buf: Rx buffer to adjust
@@ -776,7 +767,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx=
_buf_pgcnt)
 =09struct page *page =3D rx_buf->page;
=20
 =09/* avoid re-using remote pages */
-=09if (unlikely(ice_page_is_reserved(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethern=
et/intel/igb/igb_main.c
index 84d4284b8b32..f3020a73323d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8215,18 +8215,13 @@ static void igb_reuse_rx_page(struct igb_ring *rx_r=
ing,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-static inline bool igb_page_is_reserved(struct page *page)
-{
-=09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
-}
-
 static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
 {
 =09unsigned int pagecnt_bias =3D rx_buffer->pagecnt_bias;
 =09struct page *page =3D rx_buffer->page;
=20
 =09/* avoid re-using remote pages */
-=09if (unlikely(igb_page_is_reserved(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethern=
et/intel/igc/igc_main.c
index 43aec42e6d9d..8d51fb86be2e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1648,18 +1648,13 @@ static void igc_reuse_rx_page(struct igc_ring *rx_r=
ing,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-static inline bool igc_page_is_reserved(struct page *page)
-{
-=09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
-}
-
 static bool igc_can_reuse_rx_page(struct igc_rx_buffer *rx_buffer)
 {
 =09unsigned int pagecnt_bias =3D rx_buffer->pagecnt_bias;
 =09struct page *page =3D rx_buffer->page;
=20
 =09/* avoid re-using remote pages */
-=09if (unlikely(igc_page_is_reserved(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index e08c01525fd2..37cc117c3aa6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1940,11 +1940,6 @@ static void ixgbe_reuse_rx_page(struct ixgbe_ring *r=
x_ring,
 =09new_buff->pagecnt_bias=09=3D old_buff->pagecnt_bias;
 }
=20
-static inline bool ixgbe_page_is_reserved(struct page *page)
-{
-=09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
-}
-
 static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer,
 =09=09=09=09    int rx_buffer_pgcnt)
 {
@@ -1952,7 +1947,7 @@ static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_b=
uffer *rx_buffer,
 =09struct page *page =3D rx_buffer->page;
=20
 =09/* avoid re-using remote pages */
-=09if (unlikely(ixgbe_page_is_reserved(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/ne=
t/ethernet/intel/ixgbevf/ixgbevf_main.c
index a14e55e7fce8..24caa0d2d572 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -781,18 +781,13 @@ static void ixgbevf_reuse_rx_page(struct ixgbevf_ring=
 *rx_ring,
 =09new_buff->pagecnt_bias =3D old_buff->pagecnt_bias;
 }
=20
-static inline bool ixgbevf_page_is_reserved(struct page *page)
-{
-=09return (page_to_nid(page) !=3D numa_mem_id()) || page_is_pfmemalloc(pag=
e);
-}
-
 static bool ixgbevf_can_reuse_rx_page(struct ixgbevf_rx_buffer *rx_buffer)
 {
 =09unsigned int pagecnt_bias =3D rx_buffer->pagecnt_bias;
 =09struct page *page =3D rx_buffer->page;
=20
 =09/* avoid re-using remote pages */
-=09if (unlikely(ixgbevf_page_is_reserved(page)))
+=09if (unlikely(dev_page_is_reserved(page)))
 =09=09return false;
=20
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index dec93d57542f..5b9fb979adc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -212,11 +212,6 @@ static inline u32 mlx5e_decompress_cqes_start(struct m=
lx5e_rq *rq,
 =09return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
 }
=20
-static inline bool mlx5e_page_is_reserved(struct page *page)
-{
-=09return page_is_pfmemalloc(page) || page_to_nid(page) !=3D numa_mem_id()=
;
-}
-
 static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq,
 =09=09=09=09      struct mlx5e_dma_info *dma_info)
 {
@@ -229,7 +224,7 @@ static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *=
rq,
 =09=09return false;
 =09}
=20
-=09if (unlikely(mlx5e_page_is_reserved(dma_info->page))) {
+=09if (unlikely(dev_page_is_reserved(dma_info->page))) {
 =09=09stats->cache_waive++;
 =09=09return false;
 =09}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b027526da4f9..688782513d09 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2938,6 +2938,21 @@ static inline struct page *dev_alloc_page(void)
 =09return dev_alloc_pages(0);
 }
=20
+/**
+ * dev_page_is_reserved - check whether a page can be reused for network R=
x
+ * @page: the page to test
+ *
+ * A page shouldn't be considered for reusing/recycling if it was allocate=
d
+ * under memory pressure or at a distant memory node.
+ *
+ * Returns true if this page should be returned to page allocator, false
+ * otherwise.
+ */
+static inline bool dev_page_is_reserved(const struct page *page)
+{
+=09return page_is_pfmemalloc(page) || page_to_nid(page) !=3D numa_mem_id()=
;
+}
+
 /**
  *=09skb_propagate_pfmemalloc - Propagate pfmemalloc if skb is allocated a=
fter RX page
  *=09@page: The page that was allocated from skb_alloc_page
--=20
2.30.0


