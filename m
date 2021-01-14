Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E372F6080
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbhANLsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbhANLsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:48:30 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE54C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 03:47:44 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id a6so3245376qtw.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 03:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7zlk5pCQoka+PfAC4PASpL+4y3UpC4S531KyERmJBw=;
        b=ZE8P/VZ6aVPsnkQTxgeSqK8AyML44NMzDst0EI1a5EwxVjEG3WX6b3T9rqmCYMQYWS
         xYw/cL8ivjt7sGzbDt2MACulsAVKMMxkgZlYmgW6A8xYBjEoTUy+h87qnd/Shm0y60VW
         WsyQr3WfvGYI8svK+Mg0TNHtOLNELvq1s1B4ZzbbGOz4as+8ZtNM9pwYYKNb/tVPrTWZ
         PkmrendVFVTg5TVPBPgecFxchLJcdglXxECYFHSeIl0ZV/DrGiSLeeDHuuTMtDNYdemJ
         E0+lRkPrhwGw1yph75b5pbbMV7Jw91GPqn1x8osuxymPHYrz+jED0UzLyT8xjUKd9blf
         4/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7zlk5pCQoka+PfAC4PASpL+4y3UpC4S531KyERmJBw=;
        b=XZ5MLuRk5aAR/Uiv2rK6UuuRSsxMHgK6Qh2C542EBgedpqMFtURmXNKya6Z5HxgqBK
         nIAL7Jq9BE2Z1/OIvHjhikABH0Jr7yfVaMjzM6/2HMrFCwjBp0G2Ew/L4jCHctsCukYq
         BJC6LIe2hr8CNSWRnxuGCvkcUUOW8gxgv8JQv/JBFXpd7PHNI17ohC/wVsjwN/t495BF
         ckS28Zll0oIxF2cmUy8o9zY38b/8CtJWvd+EXh/I6wFJuw23GdSzscJnaSu2ZvKoA3qG
         bd+aPtG7smh0sxC/j9KFFlIl20b2pIrfzT1DOvC/WJC0M5860P12HW1NdQUrH9AjSbMQ
         lYsA==
X-Gm-Message-State: AOAM532DyiaiDjTdEQmB4kx7oSm9tapYsHDRQl11GzNwFn585dj8uRbT
        Gc2JR8hJfJKZjZJ+jMhYDqtVqIXAqSGPIAuyAdStOA==
X-Google-Smtp-Source: ABdhPJyUZR/R9jo3eRmNWwSSH6XpKIaGwPinnUBCthLw532XWAQMNHChL/xAHmSwe61+e6/qnUOCuijSjqeuyDIOh50=
X-Received: by 2002:ac8:4e1c:: with SMTP id c28mr6662207qtw.67.1610624863289;
 Thu, 14 Jan 2021 03:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20210113133523.39205-1-alobakin@pm.me> <20210113133635.39402-1-alobakin@pm.me>
 <20210113133635.39402-2-alobakin@pm.me> <CANn89i+azKGzpt4LrVVVCQdf82TLOC=dwUjA4NK3ziQHSKvtFw@mail.gmail.com>
 <20210114114046.7272-1-alobakin@pm.me>
In-Reply-To: <20210114114046.7272-1-alobakin@pm.me>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 14 Jan 2021 12:47:31 +0100
Message-ID: <CACT4Y+adbmvvbzFnzRZzmpdTipg7ye53uR6OrnU9_K030sfzzA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/3] skbuff: (re)use NAPI skb cache on
 allocation path
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
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

On Thu, Jan 14, 2021 at 12:41 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 13 Jan 2021 15:36:05 +0100
>
> > On Wed, Jan 13, 2021 at 2:37 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >>
> >> Instead of calling kmem_cache_alloc() every time when building a NAPI
> >> skb, (re)use skbuff_heads from napi_alloc_cache.skb_cache. Previously
> >> this cache was only used for bulk-freeing skbuff_heads consumed via
> >> napi_consume_skb() or __kfree_skb_defer().
> >>
> >> Typical path is:
> >>  - skb is queued for freeing from driver or stack, its skbuff_head
> >>    goes into the cache instead of immediate freeing;
> >>  - driver or stack requests NAPI skb allocation, an skbuff_head is
> >>    taken from the cache instead of allocation.
> >>
> >> Corner cases:
> >>  - if it's empty on skb allocation, bulk-allocate the first half;
> >>  - if it's full on skb consuming, bulk-wipe the second half.
> >>
> >> Also try to balance its size after completing network softirqs
> >> (__kfree_skb_flush()).
> >
> > I do not see the point of doing this rebalance (especially if we do not change
> > its name describing its purpose more accurately).
> >
> > For moderate load, we will have a reduced bulk size (typically one or two).
> > Number of skbs in the cache is in [0, 64[ , there is really no risk of
> > letting skbs there for a long period of time.
> > (32 * sizeof(sk_buff) = 8192)
> > I would personally get rid of this function completely.
>
> When I had a cache of 128 entries, I had worse results without this
> function. But seems like I forgot to retest when I switched to the
> original size of 64.
> I also thought about removing this function entirely, will test.
>
> > Also it seems you missed my KASAN support request ?
> > I guess this is a matter of using kasan_unpoison_range(), we can ask for help.
>
> I saw your request, but don't see a reason for doing this.
> We are not caching already freed skbuff_heads. They don't get
> kmem_cache_freed before getting into local cache. KASAN poisons
> them no earlier than at kmem_cache_free() (or did I miss someting?).
> heads being cached just get rid of all references and at the moment
> of dropping to the cache they are pretty the same as if they were
> allocated.

KASAN should not report false positives in this case.
But I think Eric meant preventing false negatives. If we kmalloc 17
bytes, KASAN will detect out-of-bounds accesses beyond these 17 bytes.
But we put that data into 128-byte blocks, KASAN will miss
out-of-bounds accesses beyond 17 bytes up to 128 bytes.
The same holds for "logical" use-after-frees when object is free, but
not freed into slab.

An important custom cache should use annotations like
kasan_poison_object_data/kasan_unpoison_range.
