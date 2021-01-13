Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2522F509E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbhAMREY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbhAMREY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 12:04:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FDFE23437;
        Wed, 13 Jan 2021 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610557423;
        bh=wJWj0rmsXwfQIv726JLKYsjPlKPpdeduj5DEQcebtLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Etz/WcT7yBdVKr4uoLEw2RzjGok1cCu1/obuOfhOnBg0hZiFjEVgsos3pQZSPx9/3
         sqzTRwnLXrmcObPc+/hW9ZPQDMh0fx2zcwX35caaPf+G514OJorfiKaPTdwO2Ot2ie
         trDEtDqm3ZSvNooOpVP0e9XYXMeYhUbQj/hMJgOgKXfLni7FFBcT7laNl0ocJ5mrkO
         4I0FNbi0H1nGVztBFMU97TgNIkc78b2ymtgG//s8sY1pkUqJPu/iut7R9hdWaUBKHR
         niWjijix0b2bXNZb/lhJ1KQMLt+nmV+BTCr9PA45/MueM0dJGmFdGiQIvlcZr4GK9z
         lDfoQKYuXnSRQ==
Date:   Wed, 13 Jan 2021 09:03:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and
 reusing
Message-ID: <20210113090341.74832be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89i+ppTAPYwQ2mH5cZtcMqanFU8hXzD4szdygrjOBewPb+Q@mail.gmail.com>
References: <20210111182655.12159-1-alobakin@pm.me>
        <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
        <20210112110802.3914-1-alobakin@pm.me>
        <CANn89iKEc_8_ySqV+KrbheTDKRL4Ws6JUKYeKXfogJNhfd+pGQ@mail.gmail.com>
        <20210112170242.414b8664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+ppTAPYwQ2mH5cZtcMqanFU8hXzD4szdygrjOBewPb+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 05:46:05 +0100 Eric Dumazet wrote:
> On Wed, Jan 13, 2021 at 2:02 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 12 Jan 2021 13:23:16 +0100 Eric Dumazet wrote:  
> > > On Tue, Jan 12, 2021 at 12:08 PM Alexander Lobakin <alobakin@pm.me> wrote:  
> > > >
> > > > From: Edward Cree <ecree.xilinx@gmail.com>
> > > > Date: Tue, 12 Jan 2021 09:54:04 +0000
> > > >  
> > > > > Without wishing to weigh in on whether this caching is a good idea...  
> > > >
> > > > Well, we already have a cache to bulk flush "consumed" skbs, although
> > > > kmem_cache_free() is generally lighter than kmem_cache_alloc(), and
> > > > a page frag cache to allocate skb->head that is also bulking the
> > > > operations, since it contains a (compound) page with the size of
> > > > min(SZ_32K, PAGE_SIZE).
> > > > If they wouldn't give any visible boosts, I think they wouldn't hit
> > > > mainline.
> > > >  
> > > > > Wouldn't it be simpler, rather than having two separate "alloc" and "flush"
> > > > >  caches, to have a single larger cache, such that whenever it becomes full
> > > > >  we bulk flush the top half, and when it's empty we bulk alloc the bottom
> > > > >  half?  That should mean fewer branches, fewer instructions etc. than
> > > > >  having to decide which cache to act upon every time.  
> > > >
> > > > I though about a unified cache, but couldn't decide whether to flush
> > > > or to allocate heads and how much to process. Your suggestion answers
> > > > these questions and generally seems great. I'll try that one, thanks!  
> > >
> > > The thing is : kmalloc() is supposed to have batches already, and nice
> > > per-cpu caches.
> > >
> > > This looks like an mm issue, are we sure we want to get over it ?
> > >
> > > I would like a full analysis of why SLAB/SLUB does not work well for
> > > your test workload.  
> >
> > +1, it does feel like we're getting into mm territory  
> 
> I read the existing code, and with Edward Cree idea of reusing the
> existing cache (storage of pointers),
> ths now all makes sense, since there will be not much added code (and
> new storage of 64 pointers)
> 
> The remaining issue is to make sure KASAN will still work, we need
> this to detect old and new bugs.

IDK much about MM, but we already have a kmem_cache for skbs and now
we're building a cache on top of a cache.  Shouldn't MM take care of
providing a per-CPU BH-only lockless cache?
