Return-Path: <netdev+bounces-4711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C0370DFB6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71B261C20DCC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A82A1F922;
	Tue, 23 May 2023 14:53:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24D1F17A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:53:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4971CD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684853580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0VBtvZeRIDwJBsf1UEDSI5VydF2ePAZSTRJieedCE2w=;
	b=Bc1HZRICOnZ4rWOfg8VckxnuDcPIXUgpy12XTHfGkBqvviXmRtr+TVjnVvOXmaEebLlHeW
	g4Xv/d/U0V6NrzOW/9OZvvgLleg8vqxmPJeqjgJFBTLzQragRwLPR6tCVDm+GoZW7Bg2ic
	XmSf3a9rYFuI+05hXYdiFxjr5y6waSM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-F7ED3jOaNYOIEIWeDgZB8w-1; Tue, 23 May 2023 10:52:56 -0400
X-MC-Unique: F7ED3jOaNYOIEIWeDgZB8w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BAEC8039BE;
	Tue, 23 May 2023 14:52:54 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43415400F49;
	Tue, 23 May 2023 14:52:54 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
	by firesoul.localdomain (Postfix) with ESMTP id 503A1307372E8;
	Tue, 23 May 2023 16:52:53 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V4 1/2] mm/page_pool: catch page_pool memory
 leaks
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>, netdev@vger.kernel.org,
 Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org,
 Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, lorenzo@kernel.org,
 =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 linyunsheng@huawei.com, bpf@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 willy@infradead.org
Date: Tue, 23 May 2023 16:52:53 +0200
Message-ID: <168485357325.2849279.485978688281828101.stgit@firesoul>
In-Reply-To: <168485351546.2849279.13771638045665633339.stgit@firesoul>
References: <168485351546.2849279.13771638045665633339.stgit@firesoul>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pages belonging to a page_pool (PP) instance must be freed through the
PP APIs in-order to correctly release any DMA mappings and release
refcnt on the DMA device when freeing PP instance. When PP release a
page (page_pool_release_page) the page->pp_magic value is cleared.

This patch detect a leaked PP page in free_page_is_bad() via
unexpected state of page->pp_magic value being PP_SIGNATURE.

We choose to report and treat it as a bad page. It would be possible
to release the page via returning it to the PP instance as the
page->pp pointer is likely still valid.

Notice this code is only activated when either compiled with
CONFIG_DEBUG_VM or boot cmdline debug_pagealloc=on, and
CONFIG_PAGE_POOL.

Reduced example output of leak with PP_SIGNATURE = dead000000000040:

 BUG: Bad page state in process swapper/0  pfn:110bbf
 page:000000005bc8cfb8 refcount:0 mapcount:0 mapping:0000000000000000 index:0x110bbf000 pfn:0x110bbf
 flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
 raw: 002fffff80000000 dead000000000040 ffff888117255000 0000000000000000
 raw: 0000000110bbf000 000000000000003e 00000000ffffffff 0000000000000000
 page dumped because: page_pool leak
 [...]

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 47421bedc12b..e6b996da39d4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1085,6 +1085,9 @@ static inline bool page_expected_state(struct page *page,
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
+#endif
+#ifdef CONFIG_PAGE_POOL
+			((page->pp_magic & ~0x3UL) == PP_SIGNATURE) |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1111,6 +1114,10 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 #ifdef CONFIG_MEMCG
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
+#endif
+#ifdef CONFIG_PAGE_POOL
+	if (unlikely((page->pp_magic & ~0x3UL) == PP_SIGNATURE))
+		bad_reason = "page_pool leak";
 #endif
 	return bad_reason;
 }



