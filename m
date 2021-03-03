Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5121932C3F7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354596AbhCDAJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:09:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1582426AbhCCKU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:20:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614766772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lVfA4qsQ/EcXcCKiEC4CuqfV0xUeTJfshoPATWapESA=;
        b=InmdwqdRS6Q9PtVjzk3EPgSVha1/xzV699YuwbXfYn0QWP7EJgDSnnutrCIgJz37wdHC5m
        gapa8aUP7GW/iEs6qh0iL1NdzdnYT8Fiqi+5R+itpU9yrPZdhqamzJZUriS7Ftdy2ccVfg
        jbfJcFP1dj26Sh5hkMH8PyQL9JEl1Eo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-hoiVQ_PyMYyo5ByJpG6gZA-1; Wed, 03 Mar 2021 05:19:28 -0500
X-MC-Unique: hoiVQ_PyMYyo5ByJpG6gZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1DA6835E20;
        Wed,  3 Mar 2021 10:19:26 +0000 (UTC)
Received: from carbon (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACB3B60BFA;
        Wed,  3 Mar 2021 10:19:20 +0000 (UTC)
Date:   Wed, 3 Mar 2021 11:19:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 4/5] net: page_pool: refactor dma_map into own function
 page_pool_dma_map
Message-ID: <20210303111919.3c6e29cc@carbon>
In-Reply-To: <20210303091825.GO3697@techsingularity.net>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
        <20210301161200.18852-5-mgorman@techsingularity.net>
        <YD6IosORkdRN9B2x@enceladus>
        <20210303091825.GO3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Mar 2021 09:18:25 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:
> On Tue, Mar 02, 2021 at 08:49:06PM +0200, Ilias Apalodimas wrote:
> > On Mon, Mar 01, 2021 at 04:11:59PM +0000, Mel Gorman wrote:  
> > > From: Jesper Dangaard Brouer <brouer@redhat.com>
> > > 
> > > In preparation for next patch, move the dma mapping into its own
> > > function, as this will make it easier to follow the changes.
> > > 
> > > V2: make page_pool_dma_map return boolean (Ilias)
> > >   
> > 
> > [...]
> >   
> > > @@ -211,30 +234,14 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> > >  	if (!page)
> > >  		return NULL;
> > >  
> > > -	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> > > -		goto skip_dma_map;
> > > -
> > > -	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
> > > -	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
> > > -	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
> > > -	 * This mapping is kept for lifetime of page, until leaving pool.
> > > -	 */
> > > -	dma = dma_map_page_attrs(pool->p.dev, page, 0,
> > > -				 (PAGE_SIZE << pool->p.order),
> > > -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> > > -	if (dma_mapping_error(pool->p.dev, dma)) {
> > > +	if (pp_flags & PP_FLAG_DMA_MAP &&  
> > 
> > Nit pick but can we have if ((pp_flags & PP_FLAG_DMA_MAP) && ...
> >   
> 
> Done.

Thanks for fixing this nitpick, and carrying the patch.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

