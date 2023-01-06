Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A561666051D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjAFQxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbjAFQxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:53:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2FA6E0C0
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=38Qf+Z+DyorIl/jTzxoGVQ9eElw18urL37eoCfexcdM=; b=lnA9B+VTkEH5jaZmYs+khnGSy+
        QfMtquLQzWeq+ROuukq0CYuaeESWRSM/DVBGtD0PyioFqb1CV4iGUfEw61EzVwnUawYGzGR+v22hZ
        NMsbYxvpkPv3n9xH4U9YGI5UkveibE+Qv4R36oWEMzOskOMsnuDIQlCxVvw2/nndw1kuNrI8fg45C
        WmO9karVv14eHbr/2kMltsuRr2yyuzQiDVu+w/h8QWaGoqFpQ1KdcN/5XUWMoefkWrd3gF6Xolc+t
        sHwraoDfwVHPasvEtGoi2fcm6BZ6Zo2fW325KiptW70JKLJeVxacSD+r/XNESzmsXIpkwK8D0XiAr
        334jJNLA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDpxk-00HKNw-D2; Fri, 06 Jan 2023 16:53:00 +0000
Date:   Fri, 6 Jan 2023 16:53:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 17/24] page_pool: Convert page_pool_return_skb_page()
 to use netmem
Message-ID: <Y7hR7KAzsOPsXrA1@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-18-willy@infradead.org>
 <1545f7e7-3c2c-435a-b597-0824decf571c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545f7e7-3c2c-435a-b597-0824decf571c@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 04:49:12PM +0100, Jesper Dangaard Brouer wrote:
> On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> > This function accesses the pagepool members of struct page directly,
> > so it needs to become netmem.  Add page_pool_put_full_netmem() and
> > page_pool_recycle_netmem().
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >   include/net/page_pool.h | 14 +++++++++++++-
> >   net/core/page_pool.c    | 13 ++++++-------
> >   2 files changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index fbb653c9f1da..126c04315929 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -464,10 +464,16 @@ static inline void page_pool_put_page(struct page_pool *pool,
> >   }
> >   /* Same as above but will try to sync the entire area pool->max_len */
> > +static inline void page_pool_put_full_netmem(struct page_pool *pool,
> > +		struct netmem *nmem, bool allow_direct)
> > +{
> > +	page_pool_put_netmem(pool, nmem, -1, allow_direct);
> > +}
> > +
> >   static inline void page_pool_put_full_page(struct page_pool *pool,
> >   					   struct page *page, bool allow_direct)
> >   {
> > -	page_pool_put_page(pool, page, -1, allow_direct);
> > +	page_pool_put_full_netmem(pool, page_netmem(page), allow_direct);
> >   }
> >   /* Same as above but the caller must guarantee safe context. e.g NAPI */
> > @@ -477,6 +483,12 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> >   	page_pool_put_full_page(pool, page, true);
> >   }
> > +static inline void page_pool_recycle_netmem(struct page_pool *pool,
> > +					    struct netmem *nmem)
> > +{
> > +	page_pool_put_full_netmem(pool, nmem, true);
>                                               ^^^^
> 
> It is not clear in what context page_pool_recycle_netmem() will be used,
> but I think the 'true' (allow_direct=true) might be wrong here.
> 
> It is only in limited special cases (RX-NAPI context) we can allow
> direct return to the RX-alloc-cache.

Mmm.  It's a c'n'p of the previous function:

static inline void page_pool_recycle_direct(struct page_pool *pool,
                                            struct page *page)
{
        page_pool_put_full_page(pool, page, true);
}

so perhaps it's just badly named?
