Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3C573976
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiGMO7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiGMO7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3420C17AA8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657724343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w0hQGbL9sUey3asO5//RVCwLG4Fv9JCcj/VgRL7bqrA=;
        b=Wlv0eujUUSBI0Nh8MKH3PKaULoOXEaPSIXslKd7MR7QpE0L/W2fjAT0b8yLJ/MLMDQPSIv
        KamRNw8aUcAU1fkVyjhG4RgcnqJxpr3lJrkLYkuv7NpohirPekJ67v5Wk0D4K5DLV/IehR
        gyh4lUOFxXkMUHbj8i597CRBvsKEOOI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-z1xXtB4MP9-llpg5yvzC_A-1; Wed, 13 Jul 2022 10:58:57 -0400
X-MC-Unique: z1xXtB4MP9-llpg5yvzC_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC9DC3C2F762;
        Wed, 13 Jul 2022 14:58:56 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.192.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84B2B2026D07;
        Wed, 13 Jul 2022 14:58:55 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     alexander.duyck@gmail.com
Cc:     kuba@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        chen45464546@163.com
Subject: [PATCH] mm: prevent page_frag_alloc() from corrupting the memory
Date:   Wed, 13 Jul 2022 16:58:54 +0200
Message-Id: <20220713145854.147356-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of drivers call page_frag_alloc() with a
fragment's size > PAGE_SIZE.
In low memory conditions, __page_frag_cache_refill() may fail the order 3
cache allocation and fall back to order 0;
In this case, the cache will be smaller than the fragment, causing
memory corruptions.

Prevent this from happening by checking if the newly allocated cache
is large enough for the fragment; if not, the allocation will fail
and page_frag_alloc() will return NULL.

V2: do not free the cache page because this could make memory pressure
even worse, just return NULL.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e008a3df0485..b1407254a826 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5617,6 +5617,8 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0))
+			return NULL;
 	}
 
 	nc->pagecnt_bias--;
-- 
2.31.1

