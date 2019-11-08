Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB417F5371
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbfKHSUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:20:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44775 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbfKHSUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573237238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFKgszGEpzR2nnwoquaFNs0TBvv5DvOXN/SDdEuxKgM=;
        b=i6xkgcPjR6hcoMQ9YTUzlJdVV3meXj/7qhw5O7gVWMSCuN1F+PwdUXNxjVlnQ4kFhB62/O
        T1+2WikkRN5rN0qq0CK5cT//2AkskrC8aDNnZ2C/Z7XC1PUO7Hh8EjyNmXBuBlWFRJ3RQv
        Ja4MDaS2UT+jhYqilzC3bBWmLGIPLmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-3Ew8BlhkMJ6n5sNt-KfY-Q-1; Fri, 08 Nov 2019 13:20:35 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66AC48017E0;
        Fri,  8 Nov 2019 18:20:34 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF6EF600CA;
        Fri,  8 Nov 2019 18:20:28 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id DC2F730FC134D;
        Fri,  8 Nov 2019 19:20:27 +0100 (CET)
Subject: [net-next v1 PATCH 2/2] page_pool: make inflight returns more
 robust via blocking alloc cache
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
Date:   Fri, 08 Nov 2019 19:20:27 +0100
Message-ID: <157323722783.10408.5060384163093162553.stgit@firesoul>
In-Reply-To: <157323719180.10408.3472322881536070517.stgit@firesoul>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 3Ew8BlhkMJ6n5sNt-KfY-Q-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When requesting page_pool shutdown, it's a requirement that consumer
RX-side have been disconnected, but __page_pool_request_shutdown()
have a loop that empty RX alloc cache each time. Producers can still
be inflight, but they MUST NOT return pages into RX alloc cache. Thus,
the RX alloc cache MUST remain empty after the first clearing, else it
is considered a bug. Lets make it more clear this is only cleared once.

This patch only empty RX alloc cache once and then block alloc cache.
The alloc cache is blocked via pretending it is full, and then also
poisoning the last element. This blocks producers from using fast-path,
and consumer (which is not allowed) will see a NULL pointer.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h |    2 ++
 net/core/page_pool.c    |   28 +++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..ab39b7955f9b 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -107,6 +107,8 @@ struct page_pool {
 =09 * refcnt serves purpose is to simplify drivers error handling.
 =09 */
 =09refcount_t user_cnt;
+
+=09bool shutdown_in_progress;
 };
=20
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 226f2eb30418..89feee635d08 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -357,7 +357,7 @@ void __page_pool_free(struct page_pool *pool)
 =09if (!page_pool_put(pool))
 =09=09return;
=20
-=09WARN(pool->alloc.count, "API usage violation");
+=09WARN(!pool->shutdown_in_progress, "API usage violation");
 =09WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
=20
 =09if (!__page_pool_safe_to_destroy(pool))
@@ -367,8 +367,6 @@ void __page_pool_free(struct page_pool *pool)
=20
 =09/* Make sure kernel will crash on use-after-free */
 =09pool->ring.queue =3D NULL;
-=09pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] =3D NULL;
-=09pool->alloc.count =3D PP_ALLOC_CACHE_SIZE;
=20
 =09if (pool->p.flags & PP_FLAG_DMA_MAP)
 =09=09put_device(pool->p.dev);
@@ -377,22 +375,38 @@ void __page_pool_free(struct page_pool *pool)
 }
 EXPORT_SYMBOL(__page_pool_free);
=20
-/* Request to shutdown: release pages cached by page_pool, and check
- * for in-flight pages
- */
-bool __page_pool_request_shutdown(struct page_pool *pool)
+/* Empty alloc cache once and block it */
+void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 {
 =09struct page *page;
=20
+=09if (pool->shutdown_in_progress)
+=09=09return;
+
 =09/* Empty alloc cache, assume caller made sure this is
 =09 * no-longer in use, and page_pool_alloc_pages() cannot be
 =09 * call concurrently.
 =09 */
 =09while (pool->alloc.count) {
 =09=09page =3D pool->alloc.cache[--pool->alloc.count];
+=09=09pool->alloc.cache[pool->alloc.count] =3D NULL;
 =09=09__page_pool_return_page(pool, page);
 =09}
=20
+=09/* Block alloc cache, pretend it's full and poison last element */
+=09pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] =3D NULL;
+=09pool->alloc.count =3D PP_ALLOC_CACHE_SIZE;
+
+=09pool->shutdown_in_progress =3D true;
+}
+
+/* Request to shutdown: release pages cached by page_pool, and check
+ * for in-flight pages. RX-alloc side MUST be stopped prior to this.
+ */
+bool __page_pool_request_shutdown(struct page_pool *pool)
+{
+=09page_pool_empty_alloc_cache_once(pool);
+
 =09/* No more consumers should exist, but producers could still
 =09 * be in-flight.
 =09 */

