Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CC53451DC
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCVVfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhCVVfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 17:35:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B012DC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 14:35:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so9197775pjg.5
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 14:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bvWxgszd7bHSN3N05Mi+My4+fLUUN/q4y4GSdnnqfGg=;
        b=mRzbnQLF26AWforqhEC+mDfTuD2X3cK4cOJBlHoZhMEtBui2PxCGJUttFUCFBKptep
         0pkH6ZRjliu+qXCXul703r89Xv0Cl0jt8IeU3nJLieaX1mbUFiXXmCD3I9ks/zRBmJpT
         woVOp5xrBQNKut3INrmTibjKWmlUmoxir8Wcf5s+E4bgvxYX8LGXFCwrUUBmhWP6Qpbo
         ySsDLmcxJMFptBvyaNFwT7BsUtTkYaAGG5iM7jJ+OcRURCCu0lzkpdN6nqwthBakyD9T
         MO3u7zQBkGzl2VsOx2rE9yk3OBICbepuIP1b0HczySkgkZE8BYVGRQXgCfTgWuXW7qbu
         ulMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bvWxgszd7bHSN3N05Mi+My4+fLUUN/q4y4GSdnnqfGg=;
        b=aZqAOUc/kgifdDmJLuGbgZ9Wv/rgEVsnS+7RH1l0ESZ3LjKMSAX9xZbB3a2BvsA3O/
         p9fIkD/NE30R2P1s9dlxCmOHpd//jGLS+FosYEkenLRYK4Os7PcXHPtF27xJ4TLkLd3A
         1sl28fwUmFBDu7ME/3EpZwIGIcsLfkO5WGth240S+7QgjAEo4CIe51DKeIl9ZF792Xct
         iCP0SGHJdcAzKZsQkLFRWUOpz7HgHLnr9s5xPNAKcTUe9uQX5nGZslmxxRHV9IdqFOB9
         d2cZkxPF/tP1CNnOKhunyOLVD6WH9IAnK2oQru9OxIMJtf52G8FHWJEsixFldVRRCwbI
         2glA==
X-Gm-Message-State: AOAM531jYoHq3VCdCNp689A0EMLwlJowG/gfvgEvJfk7qsevtjPJ3sDo
        acDqPq1TKwEm02gwPeyoYKz+WOBR6Jg6MuS+4qVpiA==
X-Google-Smtp-Source: ABdhPJy3nOis36aF8Jpz7Q5Gc5E5d4xxy2G8zfjwkTkKswbAyg9eAeKJdVs+PYuPH60O5ui3kI1pNfkH2nUr1IShHZA=
X-Received: by 2002:a17:90a:9d82:: with SMTP id k2mr1069462pjp.48.1616448922819;
 Mon, 22 Mar 2021 14:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
In-Reply-To: <YFJ+5+NBOBiUbGWS@cmpxchg.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Mon, 22 Mar 2021 14:35:11 -0700
Message-ID: <CAOFY-A17g-Aq_TsSX8=mD7ZaSAqx3gzUuCJT8K0xwrSuYdP4Kw@mail.gmail.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 3:12 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Tue, Mar 16, 2021 at 11:05:11PM -0700, Arjun Roy wrote:
> > On Tue, Mar 16, 2021 at 3:27 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > Hello,
> > >
> > > On Mon, Mar 15, 2021 at 09:16:45PM -0700, Arjun Roy wrote:
> > > > From: Arjun Roy <arjunroy@google.com>
> > > >
> > > > TCP zerocopy receive is used by high performance network applications
> > > > to further scale. For RX zerocopy, the memory containing the network
> > > > data filled by the network driver is directly mapped into the address
> > > > space of high performance applications. To keep the TLB cost low,
> > > > these applications unmap the network memory in big batches. So, this
> > > > memory can remain mapped for long time. This can cause a memory
> > > > isolation issue as this memory becomes unaccounted after getting
> > > > mapped into the application address space. This patch adds the memcg
> > > > accounting for such memory.
> > > >
> > > > Accounting the network memory comes with its own unique challenges.
> > > > The high performance NIC drivers use page pooling to reuse the pages
> > > > to eliminate/reduce expensive setup steps like IOMMU. These drivers
> > > > keep an extra reference on the pages and thus we can not depend on the
> > > > page reference for the uncharging. The page in the pool may keep a
> > > > memcg pinned for arbitrary long time or may get used by other memcg.
> > >
> > > The page pool knows when a page is unmapped again and becomes
> > > available for recycling, right? Essentially the 'free' phase of that
> > > private allocator. That's where the uncharge should be done.
> > >
> >
> > In general, no it does not.  The page pool, how it operates and whether it
> > exists in the first place, is an optimization that a given NIC driver can choose
> > to make - and so there's no generic plumbing that ties page unmap events to
> > something that a page pool could subscribe to that I am aware of. All it can do
> > is check, at a given point, whether it can reuse a page or not, typically by
> > checking the current page refcount.
> >
> > A couple of examples for drivers with such a mechanism - mlx5:
> > (https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c#L248)
>
>         if (page_ref_count(cache->page_cache[cache->head].page) != 1)
>
> So IIUC it co-opts the page count used by the page allocator, offset
> by the base ref of the pool. That means it doesn't control the put
> path and won't be aware of when pages are used and unused.
>
> How does it free those pages back to the system eventually? Does it
> just do a series of put_page() on pages in the pool when something
> determines it is too big?
>
> However it does it, it found some way to live without a
> destructor. But now we need one.
>
> > Or intel fm10k:
> > (https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/fm10k/fm10k_main.c#L207)
> >
> > Note that typically map count is not checked (maybe because page-flipping
> > receive zerocopy did not exist as a consideration when the driver was written).
> >
> > So given that the page pool is essentially checking on demand for whether a page
> > is usable or not - since there is no specific plumbing invoked when a page is
> > usable again (i.e. unmapped, in this case) - we opted to hook into when the
> > mapcount is decremented inside unmap() path.
>
> The problem is that the page isn't reusable just because it's
> unmapped. The user may have vmspliced those pages into a pipe and be
> pinning them long after the unmap.
>
> I don't know whether that happens in real life, but it's a legitimate
> thing to do. At the very least it would be an avenue for abuse.
>
> > > For one, it's more aligned with the usual memcg charge lifetime rules.
> > >
> > > But also it doesn't add what is essentially a private driver callback
> > > to the generic file unmapping path.
> > >
> >
> > I understand the concern, and share it - the specific thing we'd like to avoid
> > is to have driver specific code in the unmap path, and not in the least because
> > any given driver could do its own thing.
> >
> > Rather, we consider this mechanism that we added as generic to zerocopy network
> > data reception - that it does the right thing, no matter what the driver is
> > doing. This would be transparent to the driver, in other words - all the driver
> > has to do is to continue doing what it was before, using page->refcnt == 1 to
> > decide whether it can use a page or if it is not already in use.
> >
> >
> > Consider this instead as a broadly applicable networking feature adding a
> > callback to the unmap path, instead of a particular driver. And while it is just
> > TCP at present, it fundamentally isn't limited to TCP.
> >
> > I do have a request for clarification, if you could specify the usual memcg
> > charge lifetime rules that you are referring to here? Just to make sure we're on
> > the same page.
>
> Usually, the charge lifetime is tied to the allocation lifetime. It
> ends when the object is fed back to whatever pool it came out of, its
> data is considered invalid, and its memory is available to new allocs.
>
> This isn't the case here, and as per above you may uncharge the page
> long before the user actually relinquishes it.
>
> > > 1. The NR_FILE_MAPPED accounting. It is longstanding Linux behavior
> > >    that driver pages mapped into userspace are accounted as file
> > >    pages, because userspace is actually doing mmap() against a driver
> > >    file/fd (as opposed to an anon mmap). That is how they show up in
> > >    vmstat, in meminfo, and in the per process stats. There is no
> > >    reason to make memcg deviate from this. If we don't like it, it
> > >    should be taken on by changing vm_insert_page() - not trick rmap
> > >    into thinking these arent memcg pages and then fixing it up with
> > >    additional special-cased accounting callbacks.
> > >
> > >    v1 did this right, it charged the pages the way we handle all other
> > >    userspace pages: before rmap, and then let the generic VM code do
> > >    the accounting for us with the cgroup-aware vmstat infrastructure.
> >
> > To clarify, are you referring to the v1 approach for this patch from a
> > few weeks ago?
>
> Yes.
>
> > (i.e. charging for the page before vm_insert_page()). This patch changes when
> > the charging happens, and, as you note, makes it a forced charge since we've
> > already inserted the mappings into the user's address space - but it isn't
> > otherwise fundamentally different from v1 in what it does. And unmap is the
> > same.
>
> Right. The places where it IS different are the problem ;)
>
> Working around native VM accounting; adding custom accounting that is
> inconsistent with the rest of the system; force-charging a quantity of
> memory that the container may not be entitled to.
>
> Please revert back to precharging like in v1.
>

v3 will do so.

> > The period of double counting in v1 of this patch was from around the time we do
> > vm_insert_page() (note that the pages were accounted just prior to being
> > inserted) till the struct sk_buff's were disposed of - for an skb
> > that's up to 45 pages.
>
> That's seems fine.
>
> Can there be instances where the buffers are pinned by something else
> for indefinite lengths of time?
>
> > But note that is for one socket, and there can be quite a lot of open
> > sockets and
> > depending on what happens in terms of scheduling the period of time we're
> > double counting can be a bit high.
>
> You mean thread/CPU scheduling?
>
> If it comes down to that, I'm not convinced this is a practical
> concern at this point.
>
> I think we can assume that the number of sockets and the number of
> concurrent threads going through the receive path at any given time
> will scale with the size of the cgroup. And even a thousand threads
> reading from a thousand sockets at exactly the same time would double
> charge a maximum of 175M for a brief period of time. Since few people
> have 1,000 CPUs the possible overlap is further reduced.
>
> This isn't going to be a problem in the real world.
>
> > >    The way I see it, any conflict here is caused by the pages being
> > >    counted in the SOCK counter already, but not actually *tracked* on
> > >    a per page basis. If it's worth addressing, we should look into
> > >    fixing the root cause over there first if possible, before trying
> > >    to work around it here.
> > >
> >
> > When you say tracked on a per-page basis, I assume you mean using the usual
> > mechanism where a page has a non-null memcg set, with unaccounting occuring when
> > the refcount goes to 0.
>
> Right.
>
> > Networking currently will account/unaccount bytes just based on a
> > page count (and the memcg set in struct sock) rather than setting it in the page
> > itself - because the recycling of pages means the next time around it could be
> > charged to another memcg. And the refcount never goes to 1 due to the pooling
> > (in the absence of eviction for busy pages during packet reception). When
> > sitting in the driver page pool, non-null memcg does not work since we do not
> > know which socket (thus which memcg) the page would be destined for since we do
> > not know whose packet arrives next.
> >
> > The page pooling does make this all this a bit awkward, and the approach
> > in this patch seems to me the cleanest solution.
>
> I don't think it's clean, but as per above it also isn't complete.
>
> What's necessary is to give the network page pool a hookup to the
> page's put path so it knows when pages go unused.
>
> This would actually be great not just for this patch, but also for
> accounting the amount of memory consumed by the network stack in
> general, at the system level. This can be a sizable chunk these days,
> especially with some of the higher end nics. Users currently have no
> idea where their memory is going. And it seems it couldn't even answer
> this question right now without scanning the entire pool. It'd be
> great if it could track used and cached pages and report to vmstat.
>
> It would also be good if it could integrate with the page reclaim path
> and return any unused pages when the system is struggling with memory
> pressure. I don't see how it could easily/predictably do that without
> a good handle on what is and isn't used.
>
> These are all upsides even before your patch. Let's stop working
> around this quirk in the page pool, we've clearly run into the limit
> of this implementation.
>
>
> Here is an idea of how it could work:
>
> struct page already has
>
>                 struct {        /* page_pool used by netstack */
>                         /**
>                          * @dma_addr: might require a 64-bit value even on
>                          * 32-bit architectures.
>                          */
>                         dma_addr_t dma_addr;
>                 };
>
> and as you can see from its union neighbors, there is quite a bit more
> room to store private data necessary for the page pool.
>
> When a page's refcount hits zero and it's a networking page, we can
> feed it back to the page pool instead of the page allocator.
>
> From a first look, we should be able to use the PG_owner_priv_1 page
> flag for network pages (see how this flag is overloaded, we can add a
> PG_network alias). With this, we can identify the page in __put_page()
> and __release_page(). These functions are already aware of different
> types of pages and do their respective cleanup handling. We can
> similarly make network a first-class citizen and hand pages back to
> the network allocator from in there.
>
> Now the network KNOWS which of its pages are in use and which
> aren't. You can use that to uncharge pages without the DoS vector, and
> it'd go a great length toward introspecting and managing this memory -
> and not sit in a black hole as far as users and the MM are concerned.
>

To make sure we're on the same page, then, here's a tentative
mechanism - I'd rather get buy in before spending too much time on
something that wouldn't pass muster afterwards.

A) An opt-in mechanism, that a driver needs to explicitly support, in
order to get properly accounted receive zerocopy.
B) Failure to opt-in (e.g. unchanged old driver) can either lead to
unaccounted zerocopy (ie. existing behaviour) or, optionally,
effectively disabled zerocopy (ie. any call to zerocopy will return
something like EINVAL) (perhaps controlled via some sysctl, which
either lets zerocopy through or not with/without accounting).

The proposed mechanism would involve:
1) Some way of marking a page as being allocated by a driver that has
decided to opt into this mechanism. Say, a page flag, or a memcg flag.
2) A callback provided by the driver, that takes a struct page*, and
returns a boolean. The value of the boolean being true indicates that
any and all refs on the page are held by the driver. False means there
exists at least one reference that is not held by the driver.
3) A branch in put_page() that, for pages marked thus, will consult
the driver callback and if it returns true, will uncharge the memcg
for the page.

The anonymous struct you defined above is part of a union that I think
normally is one qword in length (well, could be more depending on the
typedefs I saw there) and I think that can be co-opted to provide the
driver callback - though, it might require growing the struct by one
more qword since there may be drivers like mlx5 that are already using
the field already in there  for dma_addr.

Anyways, the callback could then be used by the driver to handle the
other accounting quirks you mentioned, without needing to scan the
full pool.

Of course there are corner cases and such to properly account for, but
I just wanted to provide a really rough sketch to see if this
(assuming it were properly implemented) was what you had in mind. If
so I can put together a v3 patch.

Per my response to Andrew earlier, this would make it even more
confusing whether this is to be applied against net-next or mm trees.
But that's a bridge to cross when we get to it.

What are your thoughts?

Thanks,
-Arjun






> Thanks,
> Johannes
