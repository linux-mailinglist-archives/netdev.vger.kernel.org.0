Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CE112B610
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfL0RNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:13:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33711 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726839AbfL0RNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577466810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odbH8gJBbD1Pv+mLxQ4TOL4Mya35csb8zC9B5Ma4whY=;
        b=RWGVtOBbOHUBWsU0pcSITv/5qGziWSgGJcnPtj3xLG8s7RAsetOvePzYs0RLhwd613RUos
        FKGyCVzRT79gzCfDg+92EIHDwxsuhDLFr1vgI44ZjHSLvDLPzNLvJlJb2I5IcFuAuuq4R/
        fgYHDB6ZUHhf9hdjKsXjf6vN/Qrh2m4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-nt8F_wOIOUaO6c-c10SXeg-1; Fri, 27 Dec 2019 12:13:26 -0500
X-MC-Unique: nt8F_wOIOUaO6c-c10SXeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 461571005516;
        Fri, 27 Dec 2019 17:13:25 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E75515C28C;
        Fri, 27 Dec 2019 17:13:24 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1451930736C73;
        Fri, 27 Dec 2019 18:13:24 +0100 (CET)
Subject: [net-next v6 PATCH 2/2] page_pool: help compiler remove code in case
 CONFIG_NUMA=n
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, mhocko@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 18:13:24 +0100
Message-ID: <157746680401.257308.5144161565322223279.stgit@firesoul>
In-Reply-To: <157746672570.257308.7385062978550192444.stgit@firesoul>
References: <157746672570.257308.7385062978550192444.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kernel is compiled without NUMA support, then page_pool NUMA
config setting (pool->p.nid) doesn't make any practical sense. The
compiler cannot see that it can remove the code paths.

This patch avoids reading pool->p.nid setting in case of !CONFIG_NUMA,
in allocation and numa check code, which helps compiler to see the
optimisation potential. It leaves update code intact to keep API the
same.

 $ ./scripts/bloat-o-meter net/core/page_pool.o-numa-enabled \
                           net/core/page_pool.o-numa-disabled
 add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-113 (-113)
 Function                                     old     new   delta
 page_pool_create                             401     398      -3
 __page_pool_alloc_pages_slow                 439     426     -13
 page_pool_refill_alloc_cache                 425     328     -97
 Total: Before=3611, After=3498, chg -3.13%

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 748f0d36f4be..28fe694f9ab2 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -113,7 +113,12 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool,
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
 	 */
+#ifdef CONFIG_NUMA
 	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;
+#else
+	/* Ignore pool->p.nid setting if !CONFIG_NUMA, helps compiler */
+	pref_nid = numa_mem_id(); /* will be zero like page_to_nid() */
+#endif
 
 	/* Slower-path: Get pages from locked ring queue */
 	spin_lock(&r->consumer_lock);
@@ -200,7 +205,11 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	 */
 
 	/* Cache was empty, do real allocation */
+#ifdef CONFIG_NUMA
 	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
+#else
+	page = alloc_pages(gfp, pool->p.order);
+#endif
 	if (!page)
 		return NULL;
 


