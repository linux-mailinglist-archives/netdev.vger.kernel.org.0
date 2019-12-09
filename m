Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7260B116CE2
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 13:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLIMO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 07:14:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59715 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727074AbfLIMO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 07:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575893665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Apt4uwaxuL/GdM/7/LiwOzp4hDNBl7P5GRSmWMq3P7A=;
        b=gOxAj3zdxhapWNrWKUhZnf7gAYxnh/1pD5SVmVXoh1HAzkCK3F9ruZpEciWsdvWF49lGow
        yPvHrJM4ieiNIGHMQ2TYUMrX7x7K2ir1MKO0BfH2e/u+cU9eYEgi+4PMA4ZEQkPKi9nqw0
        HeL6sJP28AcRHUnd1hENDGd2jlMOxFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-owbv3OOjPuyGnGOgX2TJnA-1; Mon, 09 Dec 2019 07:14:24 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CCEE107ACC4;
        Mon,  9 Dec 2019 12:14:22 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F0445D9D6;
        Mon,  9 Dec 2019 12:14:17 +0000 (UTC)
Date:   Mon, 9 Dec 2019 13:14:16 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191209131416.238d4ae4@carbon>
In-Reply-To: <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
        <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: owbv3OOjPuyGnGOgX2TJnA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Dec 2019 03:52:41 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Fri, 2019-12-06 at 17:32 +0800, Li RongQing wrote:
> > some drivers uses page pool, but not require to allocate
> > pages from bound node, or simply assign pool.p.nid to
> > NUMA_NO_NODE, and the commit d5394610b1ba ("page_pool:
> > Don't recycle non-reusable pages") will block this kind
> > of driver to recycle
> > 
> > so take page as reusable when page belongs to current
> > memory node if nid is NUMA_NO_NODE
> > 
> > v1-->v2: add check with numa_mem_id from Yunsheng
> > 
> > Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > Suggested-by: Yunsheng Lin <linyunsheng@huawei.com>
> > Cc: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  net/core/page_pool.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index a6aefe989043..3c8b51ccd1c1 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -312,12 +312,17 @@ static bool __page_pool_recycle_direct(struct
> > page *page,
> >  /* page is NOT reusable when:
> >   * 1) allocated when system is under some pressure.
> > (page_is_pfmemalloc)
> >   * 2) belongs to a different NUMA node than pool->p.nid.
> > + * 3) belongs to a different memory node than current context
> > + * if pool->p.nid is NUMA_NO_NODE
> >   *
> >   * To update pool->p.nid users must call page_pool_update_nid.
> >   */
> >  static bool pool_page_reusable(struct page_pool *pool, struct page
> > *page)
> >  {
> > -	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool-  
> > >p.nid;  
> > +	return !page_is_pfmemalloc(page) &&
> > +		(page_to_nid(page) == pool->p.nid ||
> > +		(pool->p.nid == NUMA_NO_NODE &&
> > +		page_to_nid(page) == numa_mem_id()));
> >  }
> >    
> 
> Cc'ed Jesper, Ilias & Jonathan.
> 
> I don't think it is correct to check that the page nid is same as
> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow all
> pages to recycle, because you can't assume where pages are allocated
> from and where they are being handled.
> 
> I suggest the following:
> 
> return !page_pfmemalloc() && 
> ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE );
> 
> 1) never recycle emergency pages, regardless of pool nid.
> 2) always recycle if pool is NUMA_NO_NODE.
> 
> the above change should not add any overhead, a modest branch predictor
> will handle this with no effort.
> 
> Jesper et al. what do you think?

The patch description doesn't explain the problem very well.

Lets first establish what the problem is.  After I took at closer look,
I do think we have a real problem here...

If function alloc_pages_node() is called with NUMA_NO_NODE (see below
signature), then the nid is re-assigned to numa_mem_id().

Our current code checks: page_to_nid(page) == pool->p.nid which seems
bogus, as pool->p.nid=NUMA_NO_NODE and the page NID will not return
NUMA_NO_NODE... as it was set to the local detect numa node, right?

So, we do need a fix... but the question is that semantics do we want?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


/*
 * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
 * prefer the current CPU's closest node. Otherwise node must be valid and
 * online.
 */
static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
						unsigned int order)
{
	if (nid == NUMA_NO_NODE)
		nid = numa_mem_id();

	return __alloc_pages_node(nid, gfp_mask, order);
}

static bool pool_page_reusable(struct page_pool *pool, struct page *page)
{
	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
}

