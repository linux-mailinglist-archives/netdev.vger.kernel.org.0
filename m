Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C330F8F4B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfKLMIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:08:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbfKLMIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573560522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7iUAhtoRpuz1lEsCRCyZMoKSexzf3Hmek3CFOPhqms=;
        b=NdydN4rCt/bhBv8yd6PCzLf8hAY3BkEDYXIwm6n2VsNZQs+P2JpdhvYKyb7dzvxyXB2YKA
        ZkAXezBejdcRo+JBcItdLdO9mqIqGS14d4vWagbOz7Ysvc+tiLIJFDQHayGztilYr+LVWM
        9+GVbkrEF5i7Kka6cs9DQV748w1ewDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-SxOnUrumMQmmv8KtxidKHQ-1; Tue, 12 Nov 2019 07:08:39 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C5AB801FD2;
        Tue, 12 Nov 2019 12:08:38 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD8CA1001B08;
        Tue, 12 Nov 2019 12:08:33 +0000 (UTC)
Date:   Tue, 12 Nov 2019 13:08:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>, <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight
 == 0.
Message-ID: <20191112130832.6b3d69d5@carbon>
In-Reply-To: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: SxOnUrumMQmmv8KtxidKHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 21:32:10 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> The page pool keeps track of the number of pages in flight, and
> it isn't safe to remove the pool until all pages are returned.
>=20
> Disallow removing the pool until all pages are back, so the pool
> is always available for page producers.
>=20
> Make the page pool responsible for its own delayed destruction
> instead of relying on XDP, so the page pool can be used without
> xdp.

Can you please change this to:
 [... can be used without] xdp memory model.

=20
> When all pages are returned, free the pool and notify xdp if the
> pool is registered with the xdp memory system.  Have the callback
> perform a table walk since some drivers (cpsw) may share the pool
> among multiple xdp_rxq_info.
>=20
> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic warni=
ng")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
[...]
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..bfe96326335d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
[...]

Found an issue, see below.

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
>  =09ptr_ring_cleanup(&pool->ring, NULL);
> =20
> @@ -371,12 +345,8 @@ void __page_pool_free(struct page_pool *pool)
> =20
>  =09kfree(pool);
>  }
> -EXPORT_SYMBOL(__page_pool_free);

I don't think this is correct according to RCU.

Let me reproduce the resulting version of page_pool_free():

 static void page_pool_free(struct page_pool *pool)
 {
=09if (pool->disconnect)
=09=09pool->disconnect(pool);

=09ptr_ring_cleanup(&pool->ring, NULL);

=09if (pool->p.flags & PP_FLAG_DMA_MAP)
=09=09put_device(pool->p.dev);

=09kfree(pool);
 }

The issue is that pool->disconnect() will call into
mem_allocator_disconnect() -> mem_xa_remove(), and mem_xa_remove() does
a RCU delayed free.  And this function immediately does a kfree(pool).

I do know that we can ONLY reach this page_pool_free() function, when
inflight =3D=3D 0, but that can happen as soon as __page_pool_clean_page()
does the decrement, and after this trace_page_pool_state_release()
still have access the page_pool object (thus, hard to catch use-after-free)=
.

 =20
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
> +
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
> index 20781ad5f9c3..8e405abaf05a 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -70,10 +70,6 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_he=
ad *rcu)
> =20
>  =09xa =3D container_of(rcu, struct xdp_mem_allocator, rcu);
> =20
> -=09/* Allocator have indicated safe to remove before this is called */
> -=09if (xa->mem.type =3D=3D MEM_TYPE_PAGE_POOL)
> -=09=09page_pool_free(xa->page_pool);
> -
>  =09/* Allow this ID to be reused */
>  =09ida_simple_remove(&mem_id_pool, xa->mem.id);
> =20
> @@ -85,10 +81,41 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_h=
ead *rcu)
>  =09kfree(xa);
>  }
> =20
> -static bool __mem_id_disconnect(int id, bool force)
> +static void mem_xa_remove(struct xdp_mem_allocator *xa)
> +{
> +=09trace_mem_disconnect(xa);
> +
> +=09mutex_lock(&mem_id_lock);
> +
> +=09if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
> +=09=09call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);

RCU delayed free.

> +
> +=09mutex_unlock(&mem_id_lock);
> +}
> +
> +static void mem_allocator_disconnect(void *allocator)
> +{
> +=09struct xdp_mem_allocator *xa;
> +=09struct rhashtable_iter iter;
> +
> +=09rhashtable_walk_enter(mem_id_ht, &iter);
> +=09do {
> +=09=09rhashtable_walk_start(&iter);
> +
> +=09=09while ((xa =3D rhashtable_walk_next(&iter)) && !IS_ERR(xa)) {
> +=09=09=09if (xa->allocator =3D=3D allocator)
> +=09=09=09=09mem_xa_remove(xa);
> +=09=09}
> +
> +=09=09rhashtable_walk_stop(&iter);
> +
> +=09} while (xa =3D=3D ERR_PTR(-EAGAIN));
> +=09rhashtable_walk_exit(&iter);
> +}
>
> +static void mem_id_disconnect(int id)
>  {
>  =09struct xdp_mem_allocator *xa;
> -=09bool safe_to_remove =3D true;
> =20
>  =09mutex_lock(&mem_id_lock);
> =20
> @@ -96,51 +123,15 @@ static bool __mem_id_disconnect(int id, bool force)
>  =09if (!xa) {
>  =09=09mutex_unlock(&mem_id_lock);
>  =09=09WARN(1, "Request remove non-existing id(%d), driver bug?", id);
> -=09=09return true;
> +=09=09return;
>  =09}
> -=09xa->disconnect_cnt++;
> =20
> -=09/* Detects in-flight packet-pages for page_pool */
> -=09if (xa->mem.type =3D=3D MEM_TYPE_PAGE_POOL)
> -=09=09safe_to_remove =3D page_pool_request_shutdown(xa->page_pool);
> +=09trace_mem_disconnect(xa);
> =20
> -=09trace_mem_disconnect(xa, safe_to_remove, force);
> -
> -=09if ((safe_to_remove || force) &&
> -=09    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
> +=09if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
>  =09=09call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
> =20
>  =09mutex_unlock(&mem_id_lock);
> -=09return (safe_to_remove|force);
> -}
[...]

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

