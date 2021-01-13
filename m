Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FBA2F40EF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbhAMBD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbhAMBDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 20:03:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BB3D2312E;
        Wed, 13 Jan 2021 01:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610499764;
        bh=1ar0eB8cpBDMlvgsTxEJtgHSkcfpvXM3Tv7f3mt2YPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=duoxvqWkehgc9Nyje3pyd/TGQZY7bi5BQL+O7mnnIpGdeb8amdkM7lT51Fh0KijFw
         1wVGsZ9cF9A6lL+MdMM1Va5Ucbnzt2T9ulczKtNDDcsoiJYq+hmhGiKY6GfZM+06xK
         4Y71U3onYJlm3xnO86qm4EVP1Im/s15wbKTWN0TT2ChbBLn4F6M29r61H9/yl3366x
         QORBL3lRE2Sr2VdoP8lIuLKuDXYpZHt8Gw+Ld8EGN2lLvj4CXrl+IH7eBR/1iO/EpL
         FOJsE2VrIAAXa4VARZ57qT2X6NGcloKx1Q0hpepoOrnDhtZvBUs+BrQrqk3ZHGR9g8
         6GSV1XCWPeOkg==
Date:   Tue, 12 Jan 2021 17:02:42 -0800
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
Message-ID: <20210112170242.414b8664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKEc_8_ySqV+KrbheTDKRL4Ws6JUKYeKXfogJNhfd+pGQ@mail.gmail.com>
References: <20210111182655.12159-1-alobakin@pm.me>
        <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
        <20210112110802.3914-1-alobakin@pm.me>
        <CANn89iKEc_8_ySqV+KrbheTDKRL4Ws6JUKYeKXfogJNhfd+pGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 13:23:16 +0100 Eric Dumazet wrote:
> On Tue, Jan 12, 2021 at 12:08 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > From: Edward Cree <ecree.xilinx@gmail.com>
> > Date: Tue, 12 Jan 2021 09:54:04 +0000
> >  
> > > Without wishing to weigh in on whether this caching is a good idea...  
> >
> > Well, we already have a cache to bulk flush "consumed" skbs, although
> > kmem_cache_free() is generally lighter than kmem_cache_alloc(), and
> > a page frag cache to allocate skb->head that is also bulking the
> > operations, since it contains a (compound) page with the size of
> > min(SZ_32K, PAGE_SIZE).
> > If they wouldn't give any visible boosts, I think they wouldn't hit
> > mainline.
> >  
> > > Wouldn't it be simpler, rather than having two separate "alloc" and "flush"
> > >  caches, to have a single larger cache, such that whenever it becomes full
> > >  we bulk flush the top half, and when it's empty we bulk alloc the bottom
> > >  half?  That should mean fewer branches, fewer instructions etc. than
> > >  having to decide which cache to act upon every time.  
> >
> > I though about a unified cache, but couldn't decide whether to flush
> > or to allocate heads and how much to process. Your suggestion answers
> > these questions and generally seems great. I'll try that one, thanks!
>  
> The thing is : kmalloc() is supposed to have batches already, and nice
> per-cpu caches.
> 
> This looks like an mm issue, are we sure we want to get over it ?
> 
> I would like a full analysis of why SLAB/SLUB does not work well for
> your test workload.

+1, it does feel like we're getting into mm territory

> More details, more numbers.... before we accept yet another
> 'networking optimization' adding more code to the 'fast' path.
> 
> More code means more latencies when all code needs to be brought up in
> cpu caches.

