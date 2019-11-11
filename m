Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA3F791B
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKKQs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:48:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26561 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbfKKQsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:48:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573490933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHcb9xMzvnoFwitwZbsJ+TxtpnUZfs2mIGFvP+6VJXM=;
        b=Ilw0C34K6/pK7J6lZ39vZ+iuSh46zjDIl4BKUB4Y8LQ4F/Hp8GUOa/ebYWFvOuSypMQU41
        sLPBeZ6sUynLqRAjk4RzNM3MO67+Cte8HSfXg/619RyXkWEGF2ZNLG2A7AJz1A/KvSO5tL
        DvKPcAhV5kQqbWMRQrCLavxDBIAaBLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-eVL9ODY9PPKEp2X4pS_55Q-1; Mon, 11 Nov 2019 11:48:50 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 790E818B9FCE;
        Mon, 11 Nov 2019 16:48:49 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 418D765E80;
        Mon, 11 Nov 2019 16:48:38 +0000 (UTC)
Date:   Mon, 11 Nov 2019 17:48:35 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for non-coherent devices
Message-ID: <20191111174835.7344731b@carbon>
In-Reply-To: <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
        <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: eVL9ODY9PPKEp2X4pS_55Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 14:09:09 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce the following parameters in order to add the possibility to syn=
c
> DMA memory area before putting allocated buffers in the page_pool caches:

> - sync: set to 1 if device is non cache-coherent and needs to flush DMA a=
rea

I don't agree that this is only for non cache-coherent devices.

This change is generally for all device drivers.  Via setting 'sync'
(which I prefer to rename 'dma_sync') driver request that page_pool
takes over doing DMA-sync-for-device. (Very important, DMA-sync-for-CPU
is still drivers responsibility).  Drivers can benefit from removing
their calls to dma_sync_single_for_device().

We need to define meaning/semantics of this setting (my definition):
- This means that all pages that driver gets from page_pool, will be
  DMA-synced-for-device.

> - offset: DMA address offset where the DMA engine starts copying rx data

> - max_len: maximum DMA memory size page_pool is allowed to flush. This
>   is currently used in __page_pool_alloc_pages_slow routine when pages
>   are allocated from page allocator

Implementation wise (you did as I suggested offlist), and does the
DMA-sync-for-device at return-time page_pool_put_page() time, because
we (often) know the length that was/can touched by CPU.  This is key to
the optimization, that we know this length.

I also think you/we need to explain why this optimization is correct,
my attempt:=20

This optimization reduce the length of the DMA-sync-for-device.  The
optimization is valid, because page is initially DMA-synced-for-device,
as defined via max_len.  At driver RX time, the driver will do a
DMA-sync-for-CPU on the memory for the packet length.  What is
important is the memory occupied by packet payload, because this is the
memory CPU is allowed to read and modify.  If CPU have not written into
a cache-line, then we know that CPU will not be flushing this, thus it
doesn't need a DMA-sync-for-device.  As we don't track cache-lines
written into, simply use the full packet length as dma_sync_size, at
page_pool recycle time.  This also take into account any tail-extend.


> These parameters are supposed to be set by device drivers


=20
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 11 +++++++----
>  net/core/page_pool.c    | 39 +++++++++++++++++++++++++++++++++------
>  2 files changed, 40 insertions(+), 10 deletions(-)
>=20
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2cbcdbdec254..defbfd90ab46 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -65,6 +65,9 @@ struct page_pool_params {
>  =09int=09=09nid;  /* Numa node id to allocate from pages from */
>  =09struct device=09*dev; /* device, for DMA pre-mapping purposes */
>  =09enum dma_data_direction dma_dir; /* DMA mapping direction */
> +=09unsigned int=09max_len; /* max DMA sync memory size */
> +=09unsigned int=09offset;  /* DMA addr offset */
> +=09u8 sync;
>  };
> =20
>  struct page_pool {
> @@ -150,8 +153,8 @@ static inline void page_pool_destroy(struct page_pool=
 *pool)
>  }
> =20
>  /* Never call this directly, use helpers below */
> -void __page_pool_put_page(struct page_pool *pool,
> -=09=09=09  struct page *page, bool allow_direct);
> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> +=09=09=09  unsigned int dma_sync_size, bool allow_direct);
> =20
>  static inline void page_pool_put_page(struct page_pool *pool,
>  =09=09=09=09      struct page *page, bool allow_direct)
> @@ -160,14 +163,14 @@ static inline void page_pool_put_page(struct page_p=
ool *pool,
>  =09 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>  =09 */
>  #ifdef CONFIG_PAGE_POOL
> -=09__page_pool_put_page(pool, page, allow_direct);
> +=09__page_pool_put_page(pool, page, 0, allow_direct);
>  #endif
>  }
>  /* Very limited use-cases allow recycle direct */
>  static inline void page_pool_recycle_direct(struct page_pool *pool,
>  =09=09=09=09=09    struct page *page)
>  {
> -=09__page_pool_put_page(pool, page, true);
> +=09__page_pool_put_page(pool, page, 0, true);
>  }
> =20
>  /* API user MUST have disconnected alloc-side (not allowed to call
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..af9514c2d15b 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -112,6 +112,17 @@ static struct page *__page_pool_get_cached(struct pa=
ge_pool *pool)
>  =09return page;
>  }
> =20
> +/* Used for non-coherent devices */
> +static void page_pool_dma_sync_for_device(struct page_pool *pool,
> +=09=09=09=09=09  struct page *page,
> +=09=09=09=09=09  unsigned int dma_sync_size)
> +{
> +=09dma_sync_size =3D min(dma_sync_size, pool->p.max_len);
> +=09dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
> +=09=09=09=09=09 pool->p.offset, dma_sync_size,
> +=09=09=09=09=09 pool->p.dma_dir);
> +}
> +
>  /* slow path */
>  noinline
>  static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> @@ -156,6 +167,10 @@ static struct page *__page_pool_alloc_pages_slow(str=
uct page_pool *pool,
>  =09}
>  =09page->dma_addr =3D dma;
> =20
> +=09/* non-coherent devices - flush memory */
> +=09if (pool->p.sync)
> +=09=09page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> +
>  skip_dma_map:
>  =09/* Track how many pages are held 'in-flight' */
>  =09pool->pages_state_hold_cnt++;
> @@ -255,7 +270,8 @@ static void __page_pool_return_page(struct page_pool =
*pool, struct page *page)
>  }
> =20
>  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
> -=09=09=09=09   struct page *page)
> +=09=09=09=09=09  struct page *page,
> +=09=09=09=09=09  unsigned int dma_sync_size)
>  {
>  =09int ret;
>  =09/* BH protection not needed if current is serving softirq */
> @@ -264,6 +280,10 @@ static bool __page_pool_recycle_into_ring(struct pag=
e_pool *pool,
>  =09else
>  =09=09ret =3D ptr_ring_produce_bh(&pool->ring, page);
> =20
> +=09/* non-coherent devices - flush memory */
> +=09if (ret =3D=3D 0 && pool->p.sync)
> +=09=09page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> +
>  =09return (ret =3D=3D 0) ? true : false;
>  }
> =20
> @@ -273,18 +293,23 @@ static bool __page_pool_recycle_into_ring(struct pa=
ge_pool *pool,
>   * Caller must provide appropriate safe context.
>   */
>  static bool __page_pool_recycle_direct(struct page *page,
> -=09=09=09=09       struct page_pool *pool)
> +=09=09=09=09       struct page_pool *pool,
> +=09=09=09=09       unsigned int dma_sync_size)
>  {
>  =09if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
>  =09=09return false;
> =20
>  =09/* Caller MUST have verified/know (page_ref_count(page) =3D=3D 1) */
>  =09pool->alloc.cache[pool->alloc.count++] =3D page;
> +
> +=09/* non-coherent devices - flush memory */
> +=09if (pool->p.sync)
> +=09=09page_pool_dma_sync_for_device(pool, page, dma_sync_size);
>  =09return true;
>  }
> =20
> -void __page_pool_put_page(struct page_pool *pool,
> -=09=09=09  struct page *page, bool allow_direct)
> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> +=09=09=09  unsigned int dma_sync_size, bool allow_direct)
>  {
>  =09/* This allocator is optimized for the XDP mode that uses
>  =09 * one-frame-per-page, but have fallbacks that act like the
> @@ -296,10 +321,12 @@ void __page_pool_put_page(struct page_pool *pool,
>  =09=09/* Read barrier done in page_ref_count / READ_ONCE */
> =20
>  =09=09if (allow_direct && in_serving_softirq())
> -=09=09=09if (__page_pool_recycle_direct(page, pool))
> +=09=09=09if (__page_pool_recycle_direct(page, pool,
> +=09=09=09=09=09=09       dma_sync_size))
>  =09=09=09=09return;
> =20
> -=09=09if (!__page_pool_recycle_into_ring(pool, page)) {
> +=09=09if (!__page_pool_recycle_into_ring(pool, page,
> +=09=09=09=09=09=09   dma_sync_size)) {
>  =09=09=09/* Cache full, fallback to free pages */
>  =09=09=09__page_pool_return_page(pool, page);
>  =09=09}



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

