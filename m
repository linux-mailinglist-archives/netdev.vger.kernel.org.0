Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C362A6433
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgKDMYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:24:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726344AbgKDMYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604492692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OoCAW5bYOrSTsyToPsJ15TqE4jwYO9Qy/CvnKeekXrI=;
        b=Sg361rPKy3F+nkuhZcyYnBtyAfrpIywc+CdoiOMmEvPKWSj3fSZBNSQIMDsYaQMLzs/vPF
        a7/Bd6iWUACkKwpN5Q3ExBO6xsJkvpD2wgaLCc6B7UvR3fBg6sUjxBotSbmuaLRjIKfWrm
        xmLkLKrnjyPGRmbGI9B6oFMc45TRXyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-qx5xiX-UOju6eqjokG9sVA-1; Wed, 04 Nov 2020 07:24:48 -0500
X-MC-Unique: qx5xiX-UOju6eqjokG9sVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84DEB8797D3;
        Wed,  4 Nov 2020 12:24:46 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B94DF6266E;
        Wed,  4 Nov 2020 12:24:32 +0000 (UTC)
Date:   Wed, 4 Nov 2020 13:24:30 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v3 net-next 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201104132430.73594bb6@carbon>
In-Reply-To: <b8638a44f1aee8feb3a1f6b949653e2125eb0867.1604484917.git.lorenzo@kernel.org>
References: <cover.1604484917.git.lorenzo@kernel.org>
        <b8638a44f1aee8feb3a1f6b949653e2125eb0867.1604484917.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 11:22:55 +0100 Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ef98372facf6..236c5ed3aa66 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
[...]
> @@ -408,6 +410,39 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  }
>  EXPORT_SYMBOL(page_pool_put_page);
>  
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count)
> +{
> +	int i, len = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page = virt_to_head_page(data[i]);
> +
> +		if (likely(page_ref_count(page) == 1 &&
> +			   pool_page_reusable(pool, page))) {
> +			if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +				page_pool_dma_sync_for_device(pool, page, -1);
> +
> +			/* bulk pages for ptr_ring cache */
> +			data[len++] = page;
> +		} else {
> +			page_pool_release_page(pool, page);
> +			put_page(page);
> +		}
> +	}
> +
> +	/* Grab the producer spinlock for concurrent access to
> +	 * ptr_ring page_pool cache
> +	 */
> +	page_pool_ring_lock(pool);
> +	for (i = 0; i < len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, data[i]))
> +			page_pool_return_page(pool, data[i]);
> +	}
> +	page_pool_ring_unlock(pool);
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);

I don't like that you are replicating the core logic from
page_pool_put_page() in this function.  This means that we as
maintainers need to keep both of this places up-to-date.

Let me try to re-implement this, while sharing the refcnt logic:
(completely untested, not even compiled)

---
 net/core/page_pool.c |   58 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ef98372facf6..c785e9825a0d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -362,8 +362,9 @@ static bool pool_page_reusable(struct page_pool *pool, struct page *page)
  * If the page refcnt != 1, then the page will be returned to memory
  * subsystem.
  */
-void page_pool_put_page(struct page_pool *pool, struct page *page,
-			unsigned int dma_sync_size, bool allow_direct)
+static struct page*
+__page_pool_put_page(struct page_pool *pool, struct page *page,
+		     unsigned int dma_sync_size, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
@@ -381,13 +382,10 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
 
 		if (allow_direct && in_serving_softirq())
 			if (page_pool_recycle_in_cache(page, pool))
-				return;
+				return NULL;
 
-		if (!page_pool_recycle_in_ring(pool, page)) {
-			/* Cache full, fallback to free pages */
-			page_pool_return_page(pool, page);
-		}
-		return;
+		/* Page found as candidate for recycling */
+		return page;
 	}
 	/* Fallback/non-XDP mode: API user have elevated refcnt.
 	 *
@@ -405,9 +403,53 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
 	/* Do not replace this with page_pool_return_page() */
 	page_pool_release_page(pool, page);
 	put_page(page);
+	return NULL;
+}
+
+void page_pool_put_page(struct page_pool *pool, struct page *page,
+			unsigned int dma_sync_size, bool allow_direct)
+{
+	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
+
+	if (page && !page_pool_recycle_in_ring(pool, page)) {
+		/* Cache full, fallback to free pages */
+		page_pool_return_page(pool, page);
+	}
 }
 EXPORT_SYMBOL(page_pool_put_page);
 
+/* Caller must not use data area after call, as this function overwrites it */
+void page_pool_put_page_bulk(struct page_pool *pool, void **data, int count)
+{
+	int i, len = 0, len2 = 0;
+
+	for (i = 0; i < count; i++) {
+		struct page *page = virt_to_head_page(data[i]);
+
+		page = __page_pool_put_page(pool, page, -1 , false);
+
+		/* Approved for recycling for ptr_ring cache */
+		if (page)
+			data[len++] = page;
+	}
+
+	/* Bulk producer into ptr_ring page_pool cache */
+	page_pool_ring_lock(pool);
+	for (i = 0; i < len; i++) {
+		if (__ptr_ring_produce(&pool->ring, data[i]))
+			data[len2++] = data[i];
+	}
+	page_pool_ring_unlock(pool);
+
+	/* Unlikely case of ptr_ring cache full, free pages outside producer
+	 * lock, given put_page() with refcnt==1 can be an expensive operation.
+	 */
+	for (i = 0; i < len2; i++) {
+		page_pool_return_page(pool, data[i]);
+	}
+}
+EXPORT_SYMBOL(page_pool_put_page_bulk);
+
 static void page_pool_empty_ring(struct page_pool *pool)
 {
 	struct page *page;


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

