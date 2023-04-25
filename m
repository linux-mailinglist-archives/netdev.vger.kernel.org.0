Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B786EE678
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbjDYRQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbjDYRQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:16:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3982110EF
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 10:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682442949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QIaVUQ2kkkd1foj1zcvHm82kEONSqPRsWu1f6N9g/Wg=;
        b=SUiHHkYUwW85AOKOILb39mxlW903QI5z2v0uRswdMh8uB6DuArmc8cY4FAG5resrPR8n4A
        wxeOVvniQT2L3KO+LaRoaXeE/CItZ2alHiasKiqm28kTE7fIAXT3t9lMyye+EklN44lNO/
        WmWSFPJkBkQnT1NZgE87w7xL1rWrW/c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-XDdFthw9O1qxyONoG3QHmw-1; Tue, 25 Apr 2023 13:15:45 -0400
X-MC-Unique: XDdFthw9O1qxyONoG3QHmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F09EB381D4C6;
        Tue, 25 Apr 2023 17:15:44 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5CF840C2064;
        Tue, 25 Apr 2023 17:15:44 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D70F7307372E8;
        Tue, 25 Apr 2023 19:15:43 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V1 2/3] page_pool: Use static_key for shutdown
 phase
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lorenzo@kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linyunsheng@huawei.com, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Date:   Tue, 25 Apr 2023 19:15:43 +0200
Message-ID: <168244294384.1741095.6037010854411310099.stgit@firesoul>
In-Reply-To: <168244288038.1741095.1092368365531131826.stgit@firesoul>
References: <168244288038.1741095.1092368365531131826.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Performance is very important for page pool (PP). This add the use of
static_key APIs for regaining a single instruction, which makes the
new PP shutdown scheme zero impact.

We are uncertain if this is 100% correct, because static_key APIs uses
a mutex lock and it is uncertain if all contexts that can return pages
can support this. We could spawn a workqueue (like we just removed) to
workaround this issue.

Seeking input if this is worth the complexity.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/page_pool.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ce7e8dda6403..3821d8874b15 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -25,6 +25,8 @@
 
 #define BIAS_MAX	LONG_MAX
 
+DEFINE_STATIC_KEY_FALSE(pp_shutdown_phase);
+
 #ifdef CONFIG_PAGE_POOL_STATS
 /* alloc_stat_inc is intended to be used in softirq context */
 #define alloc_stat_inc(pool, __stat)	(pool->alloc_stats.__stat++)
@@ -378,7 +380,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	int i, nr_pages;
 
 	/* API usage BUG: PP in shutdown phase, cannot alloc new pages */
-	if (WARN_ON(pool->p.flags & PP_FLAG_SHUTDOWN))
+	if (static_key_enabled(&pp_shutdown_phase) &&
+	    WARN_ON(pool->p.flags & PP_FLAG_SHUTDOWN))
 		return NULL;
 
 	/* Don't support bulk alloc for high-order pages */
@@ -609,7 +612,7 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 		recycle_stat_inc(pool, ring_full);
 		page_pool_return_page(pool, page);
 	}
-	if (pool->p.flags & PP_FLAG_SHUTDOWN)
+	if (static_branch_unlikely(&pp_shutdown_phase))
 		page_pool_shutdown_attempt(pool);
 }
 EXPORT_SYMBOL(page_pool_put_defragged_page);
@@ -659,7 +662,7 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 		page_pool_return_page(pool, data[i]);
 
 out:
-	if (pool->p.flags & PP_FLAG_SHUTDOWN)
+	if (static_branch_unlikely(&pp_shutdown_phase))
 		page_pool_shutdown_attempt(pool);
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);
@@ -817,7 +820,15 @@ static int page_pool_release(struct page_pool *pool)
 noinline
 static void page_pool_shutdown_attempt(struct page_pool *pool)
 {
-	page_pool_release(pool);
+	int inflight;
+
+	if (!(pool->p.flags & PP_FLAG_SHUTDOWN))
+		return;
+
+	inflight = page_pool_release(pool);
+
+	if (static_key_enabled(&pp_shutdown_phase) && !inflight)
+		static_branch_dec(&pp_shutdown_phase);
 }
 
 void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
@@ -861,6 +872,7 @@ void page_pool_destroy(struct page_pool *pool)
 	 * Enter into shutdown phase, and retry release to handle races.
 	 */
 	pool->p.flags |= PP_FLAG_SHUTDOWN;
+	static_branch_inc(&pp_shutdown_phase);
 	page_pool_shutdown_attempt(pool);
 }
 EXPORT_SYMBOL(page_pool_destroy);


