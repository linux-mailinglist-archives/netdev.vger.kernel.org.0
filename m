Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80154F7361
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 12:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKKLre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 06:47:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726810AbfKKLre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 06:47:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573472852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tXiMLzgmTFtEnSRRzR2T7LROml+tfBK8coHaxiZtDMU=;
        b=JdRXfdXd34X2A9GYLWipRQ2g9fW9PFLYFP84M2u6Ads6SeZdoC4Xs71fLZfz2DsYOccEnU
        0mBenAq3QvDjbENObf6rxolWuYSFrja5oUG3CB6Eekp1GlnbFOXNJC/EW5su1u7lorSkua
        s+IA4Y3BsZL/6FrrFrFOoZw4VOFsvsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-obsdoc_jNWWf0grIl8x0pg-1; Mon, 11 Nov 2019 06:47:28 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F8811005502;
        Mon, 11 Nov 2019 11:47:27 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A4185E1AD;
        Mon, 11 Nov 2019 11:47:22 +0000 (UTC)
Date:   Mon, 11 Nov 2019 12:47:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <ilias.apalodimas@linaro.org>,
        <kernel-team@fb.com>, brouer@redhat.com
Subject: Re: [RFC PATCH 1/1] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191111124721.5a2afe91@carbon>
In-Reply-To: <20191111062038.2336521-2-jonathan.lemon@gmail.com>
References: <20191111062038.2336521-1-jonathan.lemon@gmail.com>
        <20191111062038.2336521-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: obsdoc_jNWWf0grIl8x0pg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 22:20:38 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> The page pool keeps track of the number of pages in flight, and
> it isn't safe to remove the pool until all pages are returned.
>=20
> Disallow removing the pool until all pages are back, so the pool
> is always available for page producers.
>=20
> Make the page pool responsible for its own delayed destruction

I like this part, making page_pool responsible for its own delayed
destruction.  I originally also wanted to do this, but got stuck on
mem.id getting removed prematurely from rhashtable.  You actually
solved this, via introducing a disconnect callback, from page_pool into
mem_allocator_disconnect(). I like it.

> instead of relying on XDP, so the page pool can be used without
> xdp.

This is a misconception, the xdp_rxq_info_reg_mem_model API does not
imply driver is using XDP.  Yes, I know the naming is sort of wrong,
contains "xdp". Also the xdp_mem_info name.  Ilias and I have discussed
to rename this several times.

The longer term plan is/was to use this (xdp_)mem_info as generic
return path for SKBs, creating a more flexible memory model for
networking.  This patch is fine and in itself does not disrupt/change
that, but your offlist changes does.  As your offlist changes does
imply a performance gain, I will likely accept this (and then find
another plan for more flexible memory model for networking).


> When all pages are returned, free the pool and notify xdp if the
> pool is being being used by xdp.  Perform a table walk since some
> drivers (cpsw) may share the pool among multiple xdp_rxq_info.

I misunderstood this description, first after reading the code in
details, I realized that this describe your disconnect callback.  And
how the mem.id removal is safe, by being delayed until after all pages
are returned.   The notes below is the code, was just for me to follow
this disconnect callback system, which I think is fine... left it if
others also want to double check the correctness.
=20
> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warni=
ng")
>=20
No newline between "Fixes" line and :Signed-off-by:

> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
>  include/net/page_pool.h                       |  55 +++-----
>  include/net/xdp_priv.h                        |   4 -
>  include/trace/events/xdp.h                    |  19 +--
>  net/core/page_pool.c                          | 115 ++++++++++------
>  net/core/xdp.c                                | 130 +++++++-----------
[...]


> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..bfe96326335d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
[...]
>  /* Cleanup page_pool state from page */
> @@ -338,31 +333,10 @@ static void __page_pool_empty_ring(struct page_pool=
 *pool)
>  =09}
>  }
> =20
> -static void __warn_in_flight(struct page_pool *pool)
> +static void page_pool_free(struct page_pool *pool)
>  {
> -=09u32 release_cnt =3D atomic_read(&pool->pages_state_release_cnt);
> -=09u32 hold_cnt =3D READ_ONCE(pool->pages_state_hold_cnt);
> -=09s32 distance;
> -
> -=09distance =3D _distance(hold_cnt, release_cnt);
> -
> -=09/* Drivers should fix this, but only problematic when DMA is used */
> -=09WARN(1, "Still in-flight pages:%d hold:%u released:%u",
> -=09     distance, hold_cnt, release_cnt);
> -}
> -
> -void __page_pool_free(struct page_pool *pool)
> -{
> -=09/* Only last user actually free/release resources */
> -=09if (!page_pool_put(pool))
> -=09=09return;
> -
> -=09WARN(pool->alloc.count, "API usage violation");
> -=09WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> -
> -=09/* Can happen due to forced shutdown */
> -=09if (!__page_pool_safe_to_destroy(pool))
> -=09=09__warn_in_flight(pool);
> +=09if (pool->disconnect)
> +=09=09pool->disconnect(pool);

Callback to mem reg system.

> =20
>  =09ptr_ring_cleanup(&pool->ring, NULL);
> =20
> @@ -371,12 +345,8 @@ void __page_pool_free(struct page_pool *pool)
> =20
>  =09kfree(pool);
>  }
> -EXPORT_SYMBOL(__page_pool_free);
> =20
> -/* Request to shutdown: release pages cached by page_pool, and check
> - * for in-flight pages
> - */
> -bool __page_pool_request_shutdown(struct page_pool *pool)
> +static void page_pool_scrub(struct page_pool *pool)
>  {
>  =09struct page *page;
> =20
> @@ -393,7 +363,64 @@ bool __page_pool_request_shutdown(struct page_pool *=
pool)
>  =09 * be in-flight.
>  =09 */
>  =09__page_pool_empty_ring(pool);
> -
> -=09return __page_pool_safe_to_destroy(pool);
>  }
> -EXPORT_SYMBOL(__page_pool_request_shutdown);
> +
> +static int page_pool_release(struct page_pool *pool)
> +{
> +=09int inflight;
> +
> +=09page_pool_scrub(pool);
> +=09inflight =3D page_pool_inflight(pool);
> +=09if (!inflight)
> +=09=09page_pool_free(pool);
> +
> +=09return inflight;
> +}
> +
> +static void page_pool_release_retry(struct work_struct *wq)
> +{
> +=09struct delayed_work *dwq =3D to_delayed_work(wq);
> +=09struct page_pool *pool =3D container_of(dwq, typeof(*pool), release_d=
w);
> +=09int inflight;
> +
> +=09inflight =3D page_pool_release(pool);
> +=09if (!inflight)
> +=09=09return;
> +
> +=09/* Periodic warning */
> +=09if (time_after_eq(jiffies, pool->defer_warn)) {
> +=09=09int sec =3D (s32)((u32)jiffies - (u32)pool->defer_start) / HZ;
> +
> +=09=09pr_warn("%s() stalled pool shutdown %d inflight %d sec\n",
> +=09=09=09__func__, inflight, sec);
> +=09=09pool->defer_warn =3D jiffies + DEFER_WARN_INTERVAL;
> +=09}
> +
> +=09/* Still not ready to be disconnected, retry later */
> +=09schedule_delayed_work(&pool->release_dw, DEFER_TIME);
> +}
> +
> +void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(vo=
id *))
> +{
> +=09refcount_inc(&pool->user_cnt);
> +=09pool->disconnect =3D disconnect;
> +}

Function page_pool_use_xdp_mem is used by xdp.c to register the callback.

> +void page_pool_destroy(struct page_pool *pool)
> +{
> +=09if (!pool)
> +=09=09return;
> +
> +=09if (!page_pool_put(pool))
> +=09=09return;
> +
> +=09if (!page_pool_release(pool))
> +=09=09return;
> +
> +=09pool->defer_start =3D jiffies;
> +=09pool->defer_warn  =3D jiffies + DEFER_WARN_INTERVAL;
> +
> +=09INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
> +=09schedule_delayed_work(&pool->release_dw, DEFER_TIME);
> +}
> +EXPORT_SYMBOL(page_pool_destroy);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 20781ad5f9c3..e334fad0a6b8 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> =20
>  void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
> @@ -153,38 +139,21 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_in=
fo *xdp_rxq)
[...]
> +=09if (xdp_rxq->mem.type =3D=3D MEM_TYPE_PAGE_POOL) {
> +=09=09rcu_read_lock();
> +=09=09xa =3D rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
> +=09=09page_pool_destroy(xa->page_pool);
> +=09=09rcu_read_unlock();
>  =09}
[...]

Calling page_pool_destroy() instead of mem_allocator_disconnect().


> @@ -371,7 +340,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *x=
dp_rxq,
>  =09}
> =20
>  =09if (type =3D=3D MEM_TYPE_PAGE_POOL)
> -=09=09page_pool_get(xdp_alloc->page_pool);
> +=09=09page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);

Register callback to mem_allocator_disconnect().

> =20
>  =09mutex_unlock(&mem_id_lock);
> =20
> @@ -402,15 +371,8 @@ static void __xdp_return(void *data, struct xdp_mem_=
info *mem, bool napi_direct,
>  =09=09/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
>  =09=09xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>  =09=09page =3D virt_to_head_page(data);
> -=09=09if (likely(xa)) {
> -=09=09=09napi_direct &=3D !xdp_return_frame_no_direct();
> -=09=09=09page_pool_put_page(xa->page_pool, page, napi_direct);
> -=09=09} else {
> -=09=09=09/* Hopefully stack show who to blame for late return */
> -=09=09=09WARN_ONCE(1, "page_pool gone mem.id=3D%d", mem->id);
> -=09=09=09trace_mem_return_failed(mem, page);
> -=09=09=09put_page(page);
> -=09=09}
> +=09=09napi_direct &=3D !xdp_return_frame_no_direct();
> +=09=09page_pool_put_page(xa->page_pool, page, napi_direct);
>  =09=09rcu_read_unlock();
>  =09=09break;
>  =09case MEM_TYPE_PAGE_SHARED:

This should be correct.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

