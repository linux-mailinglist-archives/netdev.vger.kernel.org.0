Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B92F5370
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfKHSUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:20:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29210 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726446AbfKHSUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573237236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWbCaNnZzBCmvu2buu71oIjD5hbrfBX8U53P282HSIw=;
        b=D019uoZqH3vS6Xwt1CQoDZEAoEi2yI8lGcGt2uPbBFFgjeppQeqd7vBJnmVaajd/XScxCe
        SW4M1eVyQ5q4lNimj3blc8TVMesLWZ4LNX5mPu2U1AnlBoS7Ltt12jKHdy7IZ0XVMKoLEL
        /rGj9v5Xb+nJYhw/3UVvaKwf3jpvsRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-0iGfr7E7O1CQepWdYlh_jw-1; Fri, 08 Nov 2019 13:20:33 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FFC5477;
        Fri,  8 Nov 2019 18:20:31 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A010E6084E;
        Fri,  8 Nov 2019 18:20:23 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CA77030FC134F;
        Fri,  8 Nov 2019 19:20:22 +0100 (CET)
Subject: [net-next v1 PATCH 1/2] xdp: revert forced mem allocator removal
 for page_pool
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 Nov 2019 19:20:22 +0100
Message-ID: <157323722276.10408.11333995838112864686.stgit@firesoul>
In-Reply-To: <157323719180.10408.3472322881536070517.stgit@firesoul>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 0iGfr7E7O1CQepWdYlh_jw-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forced removal of XDP mem allocator, specifically related to page_pool, tur=
ned
out to be a wrong approach.  Special thanks to Jonathan Lemon for convincin=
g me.
This patch is a partial revert of commit d956a048cd3f (=E2=80=9Cxdp: force =
mem allocator
removal and periodic warning=E2=80=9D).

It is much better to provide a guarantee that page_pool object stays valid
until 'inflight' pages reach zero, making it safe to remove.

We keep the periodic warning via a work-queue, but increased interval to
5-minutes. The reason is to have a way to catch bugs, where inflight
pages/packets never reach zero, indicating some kind of leak. These kind of
bugs have been observed while converting drivers over to use page_pool API.

Details on when to crash the kernel. If page_pool API is misused and
somehow __page_pool_free() is invoked while there are still inflight
frames, then (like before) a WARN() is triggered and not a BUG(). This can
potentially lead to use-after-free, which we try to catch via poisoning the
page_pool object memory with some NULL pointers. Doing it this way,
pinpoint both the driver (likely) prematurely freeing page_pool via WARN(),
and crash-dump for inflight page/packet show who to blame for late return.

Fixes: d956a048cd3f (=E2=80=9Cxdp: force mem allocator removal and periodic=
 warning=E2=80=9D)
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/trace/events/xdp.h |   35 +++--------------------------------
 net/core/page_pool.c       |    8 ++++++--
 net/core/xdp.c             |   36 +++++++++++++-----------------------
 3 files changed, 22 insertions(+), 57 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index c7e3c9c5bad3..a3ead2b1f00e 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -318,9 +318,9 @@ __MEM_TYPE_MAP(__MEM_TYPE_TP_FN)
 TRACE_EVENT(mem_disconnect,
=20
 =09TP_PROTO(const struct xdp_mem_allocator *xa,
-=09=09 bool safe_to_remove, bool force),
+=09=09 bool safe_to_remove),
=20
-=09TP_ARGS(xa, safe_to_remove, force),
+=09TP_ARGS(xa, safe_to_remove),
=20
 =09TP_STRUCT__entry(
 =09=09__field(const struct xdp_mem_allocator *,=09xa)
@@ -328,7 +328,6 @@ TRACE_EVENT(mem_disconnect,
 =09=09__field(u32,=09=09mem_type)
 =09=09__field(const void *,=09allocator)
 =09=09__field(bool,=09=09safe_to_remove)
-=09=09__field(bool,=09=09force)
 =09=09__field(int,=09=09disconnect_cnt)
 =09),
=20
@@ -338,17 +337,15 @@ TRACE_EVENT(mem_disconnect,
 =09=09__entry->mem_type=09=3D xa->mem.type;
 =09=09__entry->allocator=09=3D xa->allocator;
 =09=09__entry->safe_to_remove=09=3D safe_to_remove;
-=09=09__entry->force=09=09=3D force;
 =09=09__entry->disconnect_cnt=09=3D xa->disconnect_cnt;
 =09),
=20
 =09TP_printk("mem_id=3D%d mem_type=3D%s allocator=3D%p"
-=09=09  " safe_to_remove=3D%s force=3D%s disconnect_cnt=3D%d",
+=09=09  " safe_to_remove=3D%s disconnect_cnt=3D%d",
 =09=09  __entry->mem_id,
 =09=09  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
 =09=09  __entry->allocator,
 =09=09  __entry->safe_to_remove ? "true" : "false",
-=09=09  __entry->force ? "true" : "false",
 =09=09  __entry->disconnect_cnt
 =09)
 );
@@ -387,32 +384,6 @@ TRACE_EVENT(mem_connect,
 =09)
 );
=20
-TRACE_EVENT(mem_return_failed,
-
-=09TP_PROTO(const struct xdp_mem_info *mem,
-=09=09 const struct page *page),
-
-=09TP_ARGS(mem, page),
-
-=09TP_STRUCT__entry(
-=09=09__field(const struct page *,=09page)
-=09=09__field(u32,=09=09mem_id)
-=09=09__field(u32,=09=09mem_type)
-=09),
-
-=09TP_fast_assign(
-=09=09__entry->page=09=09=3D page;
-=09=09__entry->mem_id=09=09=3D mem->id;
-=09=09__entry->mem_type=09=3D mem->type;
-=09),
-
-=09TP_printk("mem_id=3D%d mem_type=3D%s page=3D%p",
-=09=09  __entry->mem_id,
-=09=09  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
-=09=09  __entry->page
-=09)
-);
-
 #endif /* _TRACE_XDP_H */
=20
 #include <trace/define_trace.h>
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5bc65587f1c4..226f2eb30418 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -346,7 +346,7 @@ static void __warn_in_flight(struct page_pool *pool)
=20
 =09distance =3D _distance(hold_cnt, release_cnt);
=20
-=09/* Drivers should fix this, but only problematic when DMA is used */
+=09/* BUG but warn as kernel should crash later */
 =09WARN(1, "Still in-flight pages:%d hold:%u released:%u",
 =09     distance, hold_cnt, release_cnt);
 }
@@ -360,12 +360,16 @@ void __page_pool_free(struct page_pool *pool)
 =09WARN(pool->alloc.count, "API usage violation");
 =09WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
=20
-=09/* Can happen due to forced shutdown */
 =09if (!__page_pool_safe_to_destroy(pool))
 =09=09__warn_in_flight(pool);
=20
 =09ptr_ring_cleanup(&pool->ring, NULL);
=20
+=09/* Make sure kernel will crash on use-after-free */
+=09pool->ring.queue =3D NULL;
+=09pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] =3D NULL;
+=09pool->alloc.count =3D PP_ALLOC_CACHE_SIZE;
+
 =09if (pool->p.flags & PP_FLAG_DMA_MAP)
 =09=09put_device(pool->p.dev);
=20
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 20781ad5f9c3..8673f199d9f4 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head =
*rcu)
 =09kfree(xa);
 }
=20
-static bool __mem_id_disconnect(int id, bool force)
+static bool __mem_id_disconnect(int id)
 {
 =09struct xdp_mem_allocator *xa;
 =09bool safe_to_remove =3D true;
@@ -104,30 +104,26 @@ static bool __mem_id_disconnect(int id, bool force)
 =09if (xa->mem.type =3D=3D MEM_TYPE_PAGE_POOL)
 =09=09safe_to_remove =3D page_pool_request_shutdown(xa->page_pool);
=20
-=09trace_mem_disconnect(xa, safe_to_remove, force);
+=09trace_mem_disconnect(xa, safe_to_remove);
=20
-=09if ((safe_to_remove || force) &&
+=09if ((safe_to_remove) &&
 =09    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
 =09=09call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
=20
 =09mutex_unlock(&mem_id_lock);
-=09return (safe_to_remove|force);
+=09return safe_to_remove;
 }
=20
-#define DEFER_TIME (msecs_to_jiffies(1000))
-#define DEFER_WARN_INTERVAL (30 * HZ)
-#define DEFER_MAX_RETRIES 120
+#define DEFER_TIME (msecs_to_jiffies(1000UL))
+#define DEFER_WARN_INTERVAL (600UL * HZ)
=20
 static void mem_id_disconnect_defer_retry(struct work_struct *wq)
 {
 =09struct delayed_work *dwq =3D to_delayed_work(wq);
 =09struct xdp_mem_allocator *xa =3D container_of(dwq, typeof(*xa), defer_w=
q);
-=09bool force =3D false;
+=09unsigned long defer_time;
=20
-=09if (xa->disconnect_cnt > DEFER_MAX_RETRIES)
-=09=09force =3D true;
-
-=09if (__mem_id_disconnect(xa->mem.id, force))
+=09if (__mem_id_disconnect(xa->mem.id))
 =09=09return;
=20
 =09/* Periodic warning */
@@ -140,7 +136,8 @@ static void mem_id_disconnect_defer_retry(struct work_s=
truct *wq)
 =09}
=20
 =09/* Still not ready to be disconnected, retry later */
-=09schedule_delayed_work(&xa->defer_wq, DEFER_TIME);
+=09defer_time =3D min(DEFER_WARN_INTERVAL, DEFER_TIME * xa->disconnect_cnt=
);
+=09schedule_delayed_work(&xa->defer_wq, defer_time);
 }
=20
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
@@ -161,7 +158,7 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *=
xdp_rxq)
 =09if (id =3D=3D 0)
 =09=09return;
=20
-=09if (__mem_id_disconnect(id, false))
+=09if (__mem_id_disconnect(id))
 =09=09return;
=20
 =09/* Could not disconnect, defer new disconnect attempt to later */
@@ -402,15 +399,8 @@ static void __xdp_return(void *data, struct xdp_mem_in=
fo *mem, bool napi_direct,
 =09=09/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 =09=09xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 =09=09page =3D virt_to_head_page(data);
-=09=09if (likely(xa)) {
-=09=09=09napi_direct &=3D !xdp_return_frame_no_direct();
-=09=09=09page_pool_put_page(xa->page_pool, page, napi_direct);
-=09=09} else {
-=09=09=09/* Hopefully stack show who to blame for late return */
-=09=09=09WARN_ONCE(1, "page_pool gone mem.id=3D%d", mem->id);
-=09=09=09trace_mem_return_failed(mem, page);
-=09=09=09put_page(page);
-=09=09}
+=09=09napi_direct &=3D !xdp_return_frame_no_direct();
+=09=09page_pool_put_page(xa->page_pool, page, napi_direct);
 =09=09rcu_read_unlock();
 =09=09break;
 =09case MEM_TYPE_PAGE_SHARED:

