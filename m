Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B0E56D71A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 09:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiGKHwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 03:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiGKHwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 03:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F27AC1C922
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 00:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657525955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0fVL/6h+ioYmSvIw9J0PUDh//b3naVw7P8qpW/RZmLE=;
        b=bcHXY+8tP0k2MRaOw1rdiFYhCb/+VIcHkKbuq/h4C5oKxYLWdzbc0aNvEOXyvMc5AFS2pL
        TtDXg6Ibai/6ox7d1Qh3tS+ZhGSsPV0fSjdkZ8e4bdJvpYMRqBBNi4xnHf90+yCssEdq+L
        9M1zTnvt/cPrabrNjgYzvR4P9EiJ9BE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-mz4UEfffNoaNIqStyUEDOg-1; Mon, 11 Jul 2022 03:52:28 -0400
X-MC-Unique: mz4UEfffNoaNIqStyUEDOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 405982999B38;
        Mon, 11 Jul 2022 07:52:28 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.40.192.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6CEF40D296D;
        Mon, 11 Jul 2022 07:52:26 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     alexander.duyck@gmail.com
Cc:     kuba@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        chen45464546@163.com
Subject: [PATCH] mm: prevent page_frag_alloc() from corrupting the memory
Date:   Mon, 11 Jul 2022 09:52:25 +0200
Message-Id: <20220711075225.15687-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
If this happens, the cache will be smaller than the fragment, causing
memory corruptions.

Prevent this from happening by checking if the newly allocated cache
is large enough for the fragment; if not, the allocation will fail
and page_frag_alloc() will return NULL.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 mm/page_alloc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e008a3df0485..7fb000d7e90c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5611,12 +5611,17 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 		/* if size can vary use size else just use PAGE_SIZE */
 		size = nc->size;
 #endif
-		/* OK, page count is 0, we can safely set it */
-		set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
-
 		/* reset page count bias and offset to start of new frag */
 		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
 		offset = size - fragsz;
+		if (unlikely(offset < 0)) {
+			free_the_page(page, compound_order(page));
+			nc->va = NULL;
+			return NULL;
+		}
+
+		/* OK, page count is 0, we can safely set it */
+		set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
 	}
 
 	nc->pagecnt_bias--;
-- 
2.31.1

