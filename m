Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874EF2AF15F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKKNAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:00:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgKKNAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605099640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LHzk4kHvXcojxXA+XRzoh4JcvbpffRClf0ZQRlgeXk=;
        b=R++a7aNhOiHq9ZUESaaxN+wMvrall9aWDP0h3TeznkbOlth535+0X7UwHR48CRtKmGf7SP
        x+JJamM1x0htVG5j7y0MdpoX3oyEOwsg3akLl5svQeX5UrwvvPgQfbgFcW3Wiaki1Qp0tC
        JWamV2mzmDGgJO/fqSBq33NkxxkSdr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-T8wP8U-TNk68D8onxA4Pyg-1; Wed, 11 Nov 2020 08:00:37 -0500
X-MC-Unique: T8wP8U-TNk68D8onxA4Pyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1ACE804B90;
        Wed, 11 Nov 2020 13:00:35 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0046A27BBE;
        Wed, 11 Nov 2020 12:59:54 +0000 (UTC)
Date:   Wed, 11 Nov 2020 13:59:53 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, ilias.apalodimas@linaro.org,
        brouer@redhat.com
Subject: Re: [PATCH v5 net-nex 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201111135953.6482dff5@carbon>
In-Reply-To: <20201111104331.GA3988@lore-desk>
References: <cover.1605020963.git.lorenzo@kernel.org>
        <1229970bf6f36fd4689169a2e47fdcc664d28366.1605020963.git.lorenzo@kernel.org>
        <5fabaf0c4a68a_bb2602085a@john-XPS-13-9370.notmuch>
        <20201111104331.GA3988@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 11:43:31 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> > Lorenzo Bianconi wrote:  
> > > Introduce the capability to batch page_pool ptr_ring refill since it is
> > > usually run inside the driver NAPI tx completion loop.
> > > 
> > > Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  include/net/page_pool.h | 26 ++++++++++++++++
> > >  net/core/page_pool.c    | 69 +++++++++++++++++++++++++++++++++++------
> > >  net/core/xdp.c          |  9 ++----
> > >  3 files changed, 87 insertions(+), 17 deletions(-)  
> > 
> > [...]
> >   
> > > +/* Caller must not use data area after call, as this function overwrites it */
> > > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > > +			     int count)
> > > +{
> > > +	int i, bulk_len = 0, pa_len = 0;
> > > +
> > > +	for (i = 0; i < count; i++) {
> > > +		struct page *page = virt_to_head_page(data[i]);
> > > +
> > > +		page = __page_pool_put_page(pool, page, -1, false);
> > > +		/* Approved for bulk recycling in ptr_ring cache */
> > > +		if (page)
> > > +			data[bulk_len++] = page;
> > > +	}
> > > +
> > > +	if (unlikely(!bulk_len))
> > > +		return;
> > > +
> > > +	/* Bulk producer into ptr_ring page_pool cache */
> > > +	page_pool_ring_lock(pool);
> > > +	for (i = 0; i < bulk_len; i++) {
> > > +		if (__ptr_ring_produce(&pool->ring, data[i]))
> > > +			data[pa_len++] = data[i];  
> > 
> > How about bailing out on the first error? bulk_len should be less than
> > 16 right, so should we really keep retying hoping ring->size changes?  
> 
> do you mean doing something like:
> 
> 	page_pool_ring_lock(pool);
> 	if (__ptr_ring_full(&pool->ring)) {
> 		pa_len = bulk_len;
> 		page_pool_ring_unlock(pool);
> 		goto out;
> 	}
> 	...
> out:
> 	for (i = 0; i < pa_len; i++) {
> 		...
> 	}

I think this is the change John is looking for:

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a06606f07df0..3093fe4e1cd7 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -424,7 +424,7 @@ EXPORT_SYMBOL(page_pool_put_page);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
                             int count)
 {
-       int i, bulk_len = 0, pa_len = 0;
+       int i, bulk_len = 0;
        bool order0 = (pool->p.order == 0);
 
        for (i = 0; i < count; i++) {
@@ -448,17 +448,18 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
        page_pool_ring_lock(pool);
        for (i = 0; i < bulk_len; i++) {
                if (__ptr_ring_produce(&pool->ring, data[i]))
-                       data[pa_len++] = data[i];
+                       break; /* ring_full */
        }
        page_pool_ring_unlock(pool);
 
-       if (likely(!pa_len))
+       /* Hopefully all pages was return into ptr_ring */
+       if (likely(i == bulk_len))
                return;
 
-       /* ptr_ring cache full, free pages outside producer lock since
-        * put_page() with refcnt == 1 can be an expensive operation
+       /* ptr_ring cache full, free remaining pages outside producer lock
+        * since put_page() with refcnt == 1 can be an expensive operation
         */
-       for (i = 0; i < pa_len; i++)
+       for (; i < bulk_len; i++)
                page_pool_return_page(pool, data[i]);
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);


> I do not know if it is better or not since the consumer can run in
> parallel. @Jesper/Ilias: any idea?

Currently it is not very likely that the consumer runs in parallel, but
is it possible. (As you experienced on your testlab with mlx5, the
DMA-TX completion did run on another CPU, but I asked you to
reconfigure this to have it run on same CPU, as it is suboptimal).
When we (finally) support this memory type for SKBs it will be more
normal to happen.

But, John is right, for ptr_ring we should exit as soon the first
"produce" fails.  This is because I know how ptr_ring works internally.
The "consumer" will free slots in chunks of 16 slots, so it is not very
likely that a slot opens up.

> >   
> > > +	}
> > > +	page_pool_ring_unlock(pool);
> > > +
> > > +	if (likely(!pa_len))
> > > +		return;
> > > +
> > > +	/* ptr_ring cache full, free pages outside producer lock since
> > > +	 * put_page() with refcnt == 1 can be an expensive operation
> > > +	 */
> > > +	for (i = 0; i < pa_len; i++)
> > > +		page_pool_return_page(pool, data[i]);
> > > +}
> > > +EXPORT_SYMBOL(page_pool_put_page_bulk);
> > > +  
> > 
> > Otherwise LGTM.  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

