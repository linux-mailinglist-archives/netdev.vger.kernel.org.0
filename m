Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7FC348C23
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhCYJCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:02:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:38958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYJCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 05:02:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616662949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4KPBFe0XybqKsFmMmUb7cVLIpaMGEswxqCxAFWNw8sM=;
        b=Nb7XPpOuVRDN3w6eNmTUhnynRp9xVASYQCH5sOuzsTCxTi8EBOJus9BNROk8Y+uw8/71Jm
        vvy3H7614dTf4N43U50ZNRjc026/j3m7CVjESgZCffKsRHPWNDxPNR1DjWYMRNOEc16W4E
        jrPliVKNSqfRLthmUwuSmCKoJAaENcs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2918AC16;
        Thu, 25 Mar 2021 09:02:28 +0000 (UTC)
Date:   Thu, 25 Mar 2021 10:02:28 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <YFxRpKfwQwobt7IK@dhcp22.suse.cz>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
 <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
 <YFsA78FfzICrnFf7@dhcp22.suse.cz>
 <YFut+cZhsJec7Pud@cmpxchg.org>
 <CAOFY-A0Y0ye74bnpcWsKOPZMJSrFW8mJxVJrpwiy2dcGgUJ5Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFY-A0Y0ye74bnpcWsKOPZMJSrFW8mJxVJrpwiy2dcGgUJ5Tw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 24-03-21 15:49:15, Arjun Roy wrote:
> On Wed, Mar 24, 2021 at 2:24 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Wed, Mar 24, 2021 at 10:12:46AM +0100, Michal Hocko wrote:
> > > On Tue 23-03-21 11:47:54, Arjun Roy wrote:
> > > > On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > >
> > > > > On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> > > > > [...]
> > > > > > Here is an idea of how it could work:
> > > > > >
> > > > > > struct page already has
> > > > > >
> > > > > >                 struct {        /* page_pool used by netstack */
> > > > > >                         /**
> > > > > >                          * @dma_addr: might require a 64-bit value even on
> > > > > >                          * 32-bit architectures.
> > > > > >                          */
> > > > > >                         dma_addr_t dma_addr;
> > > > > >                 };
> > > > > >
> > > > > > and as you can see from its union neighbors, there is quite a bit more
> > > > > > room to store private data necessary for the page pool.
> > > > > >
> > > > > > When a page's refcount hits zero and it's a networking page, we can
> > > > > > feed it back to the page pool instead of the page allocator.
> > > > > >
> > > > > > From a first look, we should be able to use the PG_owner_priv_1 page
> > > > > > flag for network pages (see how this flag is overloaded, we can add a
> > > > > > PG_network alias). With this, we can identify the page in __put_page()
> > > > > > and __release_page(). These functions are already aware of different
> > > > > > types of pages and do their respective cleanup handling. We can
> > > > > > similarly make network a first-class citizen and hand pages back to
> > > > > > the network allocator from in there.
> > > > >
> > > > > For compound pages we have a concept of destructors. Maybe we can extend
> > > > > that for order-0 pages as well. The struct page is heavily packed and
> > > > > compound_dtor shares the storage without other metadata
> > > > >                                         int    pages;    /*    16     4 */
> > > > >                         unsigned char compound_dtor;     /*    16     1 */
> > > > >                         atomic_t   hpage_pinned_refcount; /*    16     4 */
> > > > >                         pgtable_t  pmd_huge_pte;         /*    16     8 */
> > > > >                         void *     zone_device_data;     /*    16     8 */
> > > > >
> > > > > But none of those should really require to be valid when a page is freed
> > > > > unless I am missing something. It would really require to check their
> > > > > users whether they can leave the state behind. But if we can establish a
> > > > > contract that compound_dtor can be always valid when a page is freed
> > > > > this would be really a nice and useful abstraction because you wouldn't
> > > > > have to care about the specific type of page.
> >
> > Yeah technically nobody should leave these fields behind, but it
> > sounds pretty awkward to manage an overloaded destructor with a
> > refcounted object:
> >
> > Either every put would have to check ref==1 before to see if it will
> > be the one to free the page, and then set up the destructor before
> > putting the final ref. But that means we can't support lockless
> > tryget() schemes like we have in the page cache with a destructor.

I do not follow the ref==1 part. I mean to use the hugetlb model where
the destructore is configured for the whole lifetime until the page is
freed back to the allocator (see below).

> Ah, I think I see what you were getting at with your prior email - at
> first I thought your suggestion was that, since the driver may have
> its own refcount, every put would need to check ref == 1 and call into
> the driver if need be.
> 
> Instead, and correct me if I'm wrong, it seems like what you're advocating is:
> 1) The (opted in) driver no longer hangs onto the ref,
> 2) Now refcount can go all the way to 0,
> 3) And when it does, due to the special destructor this page has, it
> goes back to the driver, rather than the system?

Yes, this is the model we use for hugetlb pages for example. Have a look
at free_huge_page path (HUGETLB_PAGE_DTOR destructor). It can either
enqueue a freed page to its pool or to the page allocator depending on
the pool state.
 
[...]
> > > If you are going to claim a page flag then it would be much better to
> > > have it more generic. Flags are really scarce and if all you care about
> > > is PageHasDestructor() and provide one via page->dtor then the similar
> > > mechanism can be reused by somebody else. Or does anything prevent that?
> >
> > I was suggesting to alias PG_owner_priv_1, which currently isn't used
> > on network pages. We don't need to allocate a brandnew page flag.
> >
> 
> Just to be certain, is there any danger of having a page, that would
> not be a network driver page originally, being inside __put_page(),
> such that PG_owner_priv_1 is set (but with one of its other overloaded
> meanings)?

Yeah this is a real question. And from what Johannes is saying this
might pose some problem for this specific flags. I still need to check
all the users to be certain. One thing is clear though.  PG_owner_priv_1
is not a part of PAGE_FLAGS_CHECK_AT_FREE so it is not checked when a
page is freed so it is possible that the flag is left behind when
somebody does final put_page which makes things harder.

But that would be the case even when the flag is used for network
specific handling because you cannot tell it from other potential users
who are outside of networking...
-- 
Michal Hocko
SUSE Labs
