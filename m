Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE50FEBC9
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 12:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfKPLWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 06:22:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727505AbfKPLWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 06:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573903367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4HMm5TYaoEmQX8epqHbRRFzlwmFcGftnFt62PprOmeI=;
        b=Bn2zYLHQv7TpCnx00zEI0i6GdvRi3EaFwBGexwtrW8DSpL4/s0dK+z596MxGeCBK/3Bxuc
        tubCZ2QVib6uij/NMKgHLnrzA9RmhmSu9ZCUAdBkaS21X8eOyJXgrQOOLYRPJJXblAOXzt
        xiJ/2kRIyPF2TQ5pxBpznk6Ark2duUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-KXMD1hp6Pqq08ZX51F2d3g-1; Sat, 16 Nov 2019 06:22:46 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83503107ACC4;
        Sat, 16 Nov 2019 11:22:44 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAEBB60142;
        Sat, 16 Nov 2019 11:22:43 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2723F30FC134D;
        Sat, 16 Nov 2019 12:22:43 +0100 (CET)
Subject: [net-next v2 PATCH 2/3] page_pool: add destroy attempts counter and
 rename tracepoint
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
Date:   Sat, 16 Nov 2019 12:22:43 +0100
Message-ID: <157390336309.4062.14581799027142237081.stgit@firesoul>
In-Reply-To: <157390333500.4062.15569811103072483038.stgit@firesoul>
References: <157390333500.4062.15569811103072483038.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: KXMD1hp6Pqq08ZX51F2d3g-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Jonathan change the page_pool to become responsible to its
own shutdown via deferred work queue, then the disconnect_cnt
counter was removed from xdp memory model tracepoint.

This patch change the page_pool_inflight tracepoint name to
page_pool_release, because it reflects the new responsability
better.  And it reintroduces a counter that reflect the number of
times page_pool_release have been tried.

The counter is also used by the code, to only empty the alloc
cache once.  With a stuck work queue running every second and
counter being 64-bit, it will overrun in approx 584 billion
years. For comparison, Earth lifetime expectancy is 7.5 billion
years, before the Sun will engulf, and destroy, the Earth.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 include/net/page_pool.h          |    2 ++
 include/trace/events/page_pool.h |    9 ++++++---
 net/core/page_pool.c             |   13 +++++++++++--
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 1121faa99c12..ace881c15dcb 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -112,6 +112,8 @@ struct page_pool {
 =09 * refcnt serves purpose is to simplify drivers error handling.
 =09 */
 =09refcount_t user_cnt;
+
+=09u64 destroy_cnt;
 };
=20
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_p=
ool.h
index 47b5ee880aa9..ee7f1aca7839 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -10,7 +10,7 @@
=20
 #include <net/page_pool.h>
=20
-TRACE_EVENT(page_pool_inflight,
+TRACE_EVENT(page_pool_release,
=20
 =09TP_PROTO(const struct page_pool *pool,
 =09=09 s32 inflight, u32 hold, u32 release),
@@ -22,6 +22,7 @@ TRACE_EVENT(page_pool_inflight,
 =09=09__field(s32,=09inflight)
 =09=09__field(u32,=09hold)
 =09=09__field(u32,=09release)
+=09=09__field(u64,=09cnt)
 =09),
=20
 =09TP_fast_assign(
@@ -29,10 +30,12 @@ TRACE_EVENT(page_pool_inflight,
 =09=09__entry->inflight=09=3D inflight;
 =09=09__entry->hold=09=09=3D hold;
 =09=09__entry->release=09=3D release;
+=09=09__entry->cnt=09=09=3D pool->destroy_cnt;
 =09),
=20
-=09TP_printk("page_pool=3D%p inflight=3D%d hold=3D%u release=3D%u",
-=09  __entry->pool, __entry->inflight, __entry->hold, __entry->release)
+=09TP_printk("page_pool=3D%p inflight=3D%d hold=3D%u release=3D%u cnt=3D%l=
lu",
+=09=09__entry->pool, __entry->inflight, __entry->hold,
+=09=09__entry->release, __entry->cnt)
 );
=20
 TRACE_EVENT(page_pool_state_release,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index dfc2501c35d9..e28db2ef8e12 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -200,7 +200,7 @@ static s32 page_pool_inflight(struct page_pool *pool)
=20
 =09inflight =3D _distance(hold_cnt, release_cnt);
=20
-=09trace_page_pool_inflight(pool, inflight, hold_cnt, release_cnt);
+=09trace_page_pool_release(pool, inflight, hold_cnt, release_cnt);
 =09WARN(inflight < 0, "Negative(%d) inflight packet-pages", inflight);
=20
 =09return inflight;
@@ -349,10 +349,13 @@ static void page_pool_free(struct page_pool *pool)
 =09kfree(pool);
 }
=20
-static void page_pool_scrub(struct page_pool *pool)
+static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 {
 =09struct page *page;
=20
+=09if (pool->destroy_cnt)
+=09=09return;
+
 =09/* Empty alloc cache, assume caller made sure this is
 =09 * no-longer in use, and page_pool_alloc_pages() cannot be
 =09 * call concurrently.
@@ -361,6 +364,12 @@ static void page_pool_scrub(struct page_pool *pool)
 =09=09page =3D pool->alloc.cache[--pool->alloc.count];
 =09=09__page_pool_return_page(pool, page);
 =09}
+}
+
+static void page_pool_scrub(struct page_pool *pool)
+{
+=09page_pool_empty_alloc_cache_once(pool);
+=09pool->destroy_cnt++;
=20
 =09/* No more consumers should exist, but producers could still
 =09 * be in-flight.

