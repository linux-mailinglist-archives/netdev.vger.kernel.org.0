Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3FA3031EF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbhAYQto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:49:44 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:36301 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730901AbhAYQs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:48:29 -0500
Date:   Mon, 25 Jan 2021 16:47:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611593248; bh=PQjqCY1n/n+4wNCpUtWb3rQkV1Ny0cNm6fdbl7f6pik=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=QV6ZOPg0656nfl1DEH/S322UL4+pstgUgCc1D1CKk+HVHLbKEV+ewpATEWp5Q2eyp
         0lsWNC9+XSddJ1LCqgvTPbHc+S6hYcR8A4hVYiJyLTitAeI7WF+1rsWLslrCAGkOX5
         jEkHVWyb1P69/EUyfSsZLxVqP0CyMZ7v7Rm68NXplu9W1/G6howkrSHUKDizycGriX
         bKgyr8xwzvdhUKVpkxSpn5yG1ZaFwioid4sNE2m+1MmTEKHoAbrkxIuQO3CM5rhdD1
         I/HRYbQNpisrempK/yISGDWXVzxypGSshKmbXw98Hv/d4DeohCAi9HLwK50hsgD7G+
         YLKFDroD9T46g==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org,
        Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 3/3] net: page_pool: simplify page recycling condition tests
Message-ID: <20210125164612.243838-4-alobakin@pm.me>
In-Reply-To: <20210125164612.243838-1-alobakin@pm.me>
References: <20210125164612.243838-1-alobakin@pm.me>
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

pool_page_reusable() is a leftover from pre-NUMA-aware times. For now,
this function is just a redundant wrapper over page_is_pfmemalloc(),
so Inline it into its sole call site.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/page_pool.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f3c690b8c8e3..ad8b0707af04 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -350,14 +350,6 @@ static bool page_pool_recycle_in_cache(struct page *pa=
ge,
 =09return true;
 }
=20
-/* page is NOT reusable when:
- * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
- */
-static bool pool_page_reusable(struct page_pool *pool, struct page *page)
-{
-=09return !page_is_pfmemalloc(page);
-}
-
 /* If the page refcnt =3D=3D 1, this will try to recycle the page.
  * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
  * the configured size min(dma_sync_size, pool->max_len).
@@ -373,9 +365,11 @@ __page_pool_put_page(struct page_pool *pool, struct pa=
ge *page,
 =09 * regular page allocator APIs.
 =09 *
 =09 * refcnt =3D=3D 1 means page_pool owns page, and can recycle it.
+=09 *
+=09 * page is NOT reusable when allocated when system is under
+=09 * some pressure. (page_is_pfmemalloc)
 =09 */
-=09if (likely(page_ref_count(page) =3D=3D 1 &&
-=09=09   pool_page_reusable(pool, page))) {
+=09if (likely(page_ref_count(page) =3D=3D 1 && !page_is_pfmemalloc(page)))=
 {
 =09=09/* Read barrier done in page_ref_count / READ_ONCE */
=20
 =09=09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
--=20
2.30.0


