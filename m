Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA1C338C41
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 13:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhCLMBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 07:01:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231806AbhCLMB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 07:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615550488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/YD6Q71Aksymyb9dGOjs1wIYzShPMYRZ/V0FzuY3l0I=;
        b=Py/6Z8LNg6bU7MtszJcHiw0cM/eIBrVff8atsjjdjcNfCA6cUZQuqPeXmpPJRz9qT+zrnK
        mXkzC5cL8t98U30iAjAnPv7eH8qrJPvXIw7NVBwvPI5YIC/QRvcQooJgtfet9aujHb74of
        iRjxlna4nGwK64dtzPAhWcRgAp7FuFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-FaWDElQNOj-6zJZCRj3vow-1; Fri, 12 Mar 2021 07:01:24 -0500
X-MC-Unique: FaWDElQNOj-6zJZCRj3vow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF313D6809;
        Fri, 12 Mar 2021 12:01:12 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A5CF5C1C4;
        Fri, 12 Mar 2021 12:01:10 +0000 (UTC)
Date:   Fri, 12 Mar 2021 13:01:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210312130108.65b83747@carbon>
In-Reply-To: <20210310113836.GQ3697@techsingularity.net>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
        <20210301161200.18852-3-mgorman@techsingularity.net>
        <pj41zl7dmfnuby.fsf@u570694869fb251.ant.amazon.com>
        <20210310113836.GQ3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 11:38:36 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Wed, Mar 10, 2021 at 01:04:17PM +0200, Shay Agroskin wrote:
> > 
> > Mel Gorman <mgorman@techsingularity.net> writes:
> >   
> > > 
> > > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > > index 8572a1474e16..4903d1cc48dc 100644
> > > --- a/include/linux/gfp.h
> > > +++ b/include/linux/gfp.h
> > > @@ -515,6 +515,10 @@ static inline int arch_make_page_accessible(struct
> > > page *page)
> > >  }
> > >  #endif
> > >   +int __alloc_pages_bulk_nodemask(gfp_t gfp_mask, int preferred_nid,
> > > +				nodemask_t *nodemask, int nr_pages,
> > > +				struct list_head *list);
> > > +
> > >  struct page *
> > >  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int
> > > preferred_nid,
> > >  							nodemask_t  *nodemask);
> > > @@ -525,6 +529,14 @@ __alloc_pages(gfp_t gfp_mask, unsigned int order,
> > > int preferred_nid)
> > >  	return __alloc_pages_nodemask(gfp_mask, order,  preferred_nid, NULL);
> > >  }
> > > +/* Bulk allocate order-0 pages */
> > > +static inline unsigned long
> > > +alloc_pages_bulk(gfp_t gfp_mask, unsigned long nr_pages, struct
> > > list_head *list)
> > > +{
> > > +	return __alloc_pages_bulk_nodemask(gfp_mask, numa_mem_id(), NULL,
> > > +							nr_pages, list);  
> > 
> > Is the second line indentation intentional ? Why not align it to the first
> > argument (gfp_mask) ?
> >   
> 
> No particular reason. I usually pick this as it's visually clearer to me
> that it's part of the same line when the multi-line is part of an if block.
> 
> > > +}
> > > +
[...]
> > 
> > Same indentation comment as before
> >   
> 
> Again, simple personal perference to avoid any possibility it's mixed
> up with a later line. There has not been consistent code styling
> enforcement of what indentation style should be used for a multi-line
> within mm/page_alloc.c

Hi Shay, it is might be surprising that indentation style actually
differs slightly in different parts of the kernel.  I started in
networking area of the kernel, and I was also surprised when I started
working in MM area that the coding style differs.  I can tell you that
the indentation style Mel choose is consistent with the code styling in
MM area.  I usually respect that even-though I prefer the networking
style as I was "raised" with that style.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

