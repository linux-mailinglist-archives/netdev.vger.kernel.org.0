Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514D86F1C6F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346076AbjD1QRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjD1QRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:17:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568802D5B
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682698589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wynb7GdU79YYV9ENu+xz5worQ7/3FbOaM+jXoCkc6Vg=;
        b=HvGu5DsPytF4C1TZWFpc7b0tGlx6L836lbXlm4nf5L3T57a/E+SHT5py65hsAqI4FbAhnP
        b+4+TInZIC+wdEwc/89H1s6+bWP9IMgQ9R2cFdxtqsotYXIYx+TVncR6bfPfo63R3yvwka
        kVP6HDXsvzNA8fDIfhAOZEUbOIo0GYc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-0Ujl1XxlO36hZnV-ImNXYA-1; Fri, 28 Apr 2023 12:16:26 -0400
X-MC-Unique: 0Ujl1XxlO36hZnV-ImNXYA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 858BF38237CE;
        Fri, 28 Apr 2023 16:16:25 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46F15492C13;
        Fri, 28 Apr 2023 16:16:25 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 68AC7307372E8;
        Fri, 28 Apr 2023 18:16:24 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V3 2/2] mm/page_pool: catch page_pool memory
 leaks
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
Date:   Fri, 28 Apr 2023 18:16:24 +0200
Message-ID: <168269858438.2191653.17490250680021679888.stgit@firesoul>
In-Reply-To: <168269854650.2191653.8465259808498269815.stgit@firesoul>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 8e39705c7bdc..137b72f8ab8b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1247,6 +1247,9 @@ static inline bool page_expected_state(struct page *page,
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
+#endif
+#ifdef CONFIG_PAGE_POOL
+			((page->pp_magic & ~0x3UL) == PP_SIGNATURE) |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1273,6 +1276,10 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
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


