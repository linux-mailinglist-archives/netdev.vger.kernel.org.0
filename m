Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4FA2F4350
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbhAMEq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbhAMEq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:46:58 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843C9C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 20:46:18 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n4so1564960iow.12
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 20:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tOWy8KhOizbd2Dn5a2Cj2vcBNaHIiB2CBvkXn3Ip+EE=;
        b=d2NYmxC2uL6xEKj/wkCG8Sa3jmX1U1Uj7nFnDywZfdP0ZvKieml5KnAgVwy3X1iNHw
         v21pdcqXK691gbaofSUUiZQIt367J/hM+bXGAuID6SJmwNZe2KQKflt6imTBloG86oP/
         SDGMF8bVPwVW9aFpnNBL0iLeUX6bEo5hQT5ZXJop22oSGZgXIS1qGrYlSpmwjXZ7G+Ng
         7528zhJjZn4LNTMp1gMUxmxx5T2bVUpQeWmTC699GvesPVxT794KXGjhy57J+c/25hNA
         amfiO0H4WuutwudKyx1KU2gYhasQUZEgaWP8iBC80yYn+J+yIOIaeTe3V/EtHGOY4V2d
         3N3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tOWy8KhOizbd2Dn5a2Cj2vcBNaHIiB2CBvkXn3Ip+EE=;
        b=qkj76s/z4u7Eb47+yEF85awgLVaDuCcp9uBp/aezNW7qPPcgc83FIWNwC1t8WMMFJe
         G27keQNfegGustJBU+9pz1swktjPzR298hPaWsogCP93oMy9VBnzIC6CUAoaPEhSdxt1
         SH5VHw1fV9ugTXI2IeBITd0XTku2t+RJB4Q/yiGKiTQbyktuDKkdrsBGbgV8rs15EnDe
         Kc/ZcDxXuWNqGFAIahR2Hgfjbxy3pplCqC4DOBZvLtp9R7woZHAXOo9MQZ6T2ypm9x0W
         NGDUJKyiaY4treL4bBEpl4PC7lILLX355fqSBTtepcdoIqUR9ajFf3xBIJiHrBq/1mo6
         V4gQ==
X-Gm-Message-State: AOAM530OzzNOTxVG79zYxxCndgjxPYdWCjl7x30xb1nAKgocfwu2SL/v
        7UKuO8TGgjSX17WXa8aOLyB4HA8TDrTjIH2pyOdCYQ==
X-Google-Smtp-Source: ABdhPJwnBeA2ec/2H8aOEf+fFHqLpYaEfN6ZYygIV52IDKJSjBiTX+tgp41wMMOPpYRMXHYpQjb+5rAxM50iiA1LgAg=
X-Received: by 2002:a05:6e02:42:: with SMTP id i2mr582043ilr.68.1610513177471;
 Tue, 12 Jan 2021 20:46:17 -0800 (PST)
MIME-Version: 1.0
References: <20210111182655.12159-1-alobakin@pm.me> <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
 <20210112110802.3914-1-alobakin@pm.me> <CANn89iKEc_8_ySqV+KrbheTDKRL4Ws6JUKYeKXfogJNhfd+pGQ@mail.gmail.com>
 <20210112170242.414b8664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112170242.414b8664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Jan 2021 05:46:05 +0100
Message-ID: <CANn89i+ppTAPYwQ2mH5cZtcMqanFU8hXzD4szdygrjOBewPb+Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
To:     Jakub Kicinski <kuba@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 2:02 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 12 Jan 2021 13:23:16 +0100 Eric Dumazet wrote:
> > On Tue, Jan 12, 2021 at 12:08 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > >
> > > From: Edward Cree <ecree.xilinx@gmail.com>
> > > Date: Tue, 12 Jan 2021 09:54:04 +0000
> > >
> > > > Without wishing to weigh in on whether this caching is a good idea...
> > >
> > > Well, we already have a cache to bulk flush "consumed" skbs, although
> > > kmem_cache_free() is generally lighter than kmem_cache_alloc(), and
> > > a page frag cache to allocate skb->head that is also bulking the
> > > operations, since it contains a (compound) page with the size of
> > > min(SZ_32K, PAGE_SIZE).
> > > If they wouldn't give any visible boosts, I think they wouldn't hit
> > > mainline.
> > >
> > > > Wouldn't it be simpler, rather than having two separate "alloc" and "flush"
> > > >  caches, to have a single larger cache, such that whenever it becomes full
> > > >  we bulk flush the top half, and when it's empty we bulk alloc the bottom
> > > >  half?  That should mean fewer branches, fewer instructions etc. than
> > > >  having to decide which cache to act upon every time.
> > >
> > > I though about a unified cache, but couldn't decide whether to flush
> > > or to allocate heads and how much to process. Your suggestion answers
> > > these questions and generally seems great. I'll try that one, thanks!
> >
> > The thing is : kmalloc() is supposed to have batches already, and nice
> > per-cpu caches.
> >
> > This looks like an mm issue, are we sure we want to get over it ?
> >
> > I would like a full analysis of why SLAB/SLUB does not work well for
> > your test workload.
>
> +1, it does feel like we're getting into mm territory

I read the existing code, and with Edward Cree idea of reusing the
existing cache (storage of pointers),
ths now all makes sense, since there will be not much added code (and
new storage of 64 pointers)

The remaining issue is to make sure KASAN will still work, we need
this to detect old and new bugs.

Thanks !
