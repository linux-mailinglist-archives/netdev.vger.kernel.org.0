Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3AA576218
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiGOMu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiGOMu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:50:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DE532ED5A
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657889427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yG6DZkuyy9DwOyDsoQVS06AJjtPTlfn1QRvO2HjX0rY=;
        b=N1lfnIryme9XxbWC4hSW2Jb/cfOSnMgKe9iQeaT31JYP1FGEK7MZAazLOwQd2ELARcSiwP
        csIa3ODwCDLXmVLM5LDRFmLO6wJ5F7iurYoGn6JzB0SMaQZRoN4OxVOmlt3tepNPbz7ExH
        UFCAHy20QptBNiIBQ0fMtThwABEH7ls=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-DWMnpf_aMruFoaMM0WX1bg-1; Fri, 15 Jul 2022 08:50:16 -0400
X-MC-Unique: DWMnpf_aMruFoaMM0WX1bg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A4BE101A58D;
        Fri, 15 Jul 2022 12:50:16 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.192.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1FBF40CFD0A;
        Fri, 15 Jul 2022 12:50:14 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     alexander.duyck@gmail.com
Cc:     kuba@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        chen45464546@163.com
Subject: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
Date:   Fri, 15 Jul 2022 14:50:13 +0200
Message-Id: <20220715125013.247085-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

V3: add a comment to explain why we return NULL.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 mm/page_alloc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e008a3df0485..59c4dddf379f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5617,6 +5617,18 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0)) {
+			/*
+			 * The caller is trying to allocate a fragment
+			 * with fragsz > PAGE_SIZE but the cache isn't big
+			 * enough to satisfy the request, this may
+			 * happen in low memory conditions.
+			 * We don't release the cache page because
+			 * it could make memory pressure worse
+			 * so we simply return NULL here.
+			 */
+			return NULL;
+		}
 	}
 
 	nc->pagecnt_bias--;
-- 
2.31.1

