Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B5261645
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbgIHRHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731816AbgIHRGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:06:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A14CC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:06:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q6so16058849ild.12
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nP2eTHm0HLp1NJvN8Ksk3K5JaxC4dOo3fpyeorLIMDg=;
        b=GpPIYpLhfnGa6FoUdveZCt5KrYgzH3ly2Ky3MrsGKo75CdD1ovPDtlIeVxRKa1dpDY
         wcc1yeFEnQIiGU1iNQHPWZ8oqcYLEGpYJ+sOsdE1ZdzB4Vjj1fzRQ9iDxOhpfkcpOLUR
         Ffm9VIBi0Iq/cuwfPOHST4QCbii5UUtqBAeUj8q1PiLPeiUVktI+kqbhZDWVn29pNkJ5
         Vi9YNGvzWC4bCoBh55WEXcaWbn6oHyoGScl+jyhfXLodXP2r5UqT63wk2Oj9D2VrUiPA
         ZuK1o4zUStouImsCfi5xysEg4NlZP2JlLatVnazwxPMyK/DESvyrsccduhav6VCPupqy
         PMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nP2eTHm0HLp1NJvN8Ksk3K5JaxC4dOo3fpyeorLIMDg=;
        b=H/1Y3XWJkIvqPOH5JswWL7d7HYOhth9KR0Svoy8CS6Kpgd4tfCg9Hw0p8MUt2qAw9a
         YIJ49Hi2el4WxhAEDScVs+mkltjNOXlHkCffXmPC+Jebwi+00ugPR/cBt+QmLbm5qXPb
         id8qrB58NNCxLNGPiBj6q0JrAXR9yXKCExyu1MNjIv+hpbCDpHC9qI15bPYkJ3nj1xCC
         8dpheXDt8su/nzDI9sIzdD36bsObAomNuuYYmIUTS9+MpXUPZPlAgDronCVyIRATs6E1
         jnHfcxZ52kiJXGdiROHTnB1EhnsMF8jLU9xK3a6XaF6tbfR/rZ0aFKfayYR3powcOUer
         3+nw==
X-Gm-Message-State: AOAM5307MwYvCt0z+U13WjgF3ClxZrtKlSkWPWJfn58wpb7FJ+UnYF+T
        /T8z6uQnJK7Kjfs6uG9z+B0IliGrfFT+3PPiJmb2GA==
X-Google-Smtp-Source: ABdhPJwDwWXPzn0PaSCTKPU8PwaffIQ8sH1y+ci39LgNhbY+O5RvSofEb1BcQxIx/gddaZ8WrRNMHyzkp/GZIQrb/I0=
X-Received: by 2002:a92:4001:: with SMTP id n1mr24507622ila.69.1599584796466;
 Tue, 08 Sep 2020 10:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200908082023.3690438-1-edumazet@google.com> <7f56f2d0-e741-bc24-c671-14e53607be2b@gmail.com>
In-Reply-To: <7f56f2d0-e741-bc24-c671-14e53607be2b@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Sep 2020 19:06:25 +0200
Message-ID: <CANn89iLxQB7HQRq7fFBp7DoypkzbTeR-=p_04FoUn9uw-s+jig@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 6:50 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/8/20 2:20 AM, Eric Dumazet wrote:
> > syzbot reported twice a lockdep issue in fib6_del() [1]
> > which I think is caused by net->ipv6.fib6_null_entry
> > having a NULL fib6_table pointer.
> >
> > fib6_del() already checks for fib6_null_entry special
> > case, we only need to return earlier.
> >
> > Bug seems to occur very rarely, I have thus chosen
> > a 'bug origin' that makes backports not too complex.
> >
> > [1]
> > WARNING: suspicious RCU usage
> > 5.9.0-rc4-syzkaller #0 Not tainted
> > -----------------------------
> > net/ipv6/ip6_fib.c:1996 suspicious rcu_dereference_protected() usage!
> >
> > other info that might help us debug this:
> >
> > rcu_scheduler_active = 2, debug_locks = 1
> > 4 locks held by syz-executor.5/8095:
> >  #0: ffffffff8a7ea708 (rtnl_mutex){+.+.}-{3:3}, at: ppp_release+0x178/0x240 drivers/net/ppp/ppp_generic.c:401
> >  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: spin_trylock_bh include/linux/spinlock.h:414 [inline]
> >  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: fib6_run_gc+0x21b/0x2d0 net/ipv6/ip6_fib.c:2312
> >  #2: ffffffff89bd6a40 (rcu_read_lock){....}-{1:2}, at: __fib6_clean_all+0x0/0x290 net/ipv6/ip6_fib.c:2613
> >  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
> >  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: __fib6_clean_all+0x107/0x290 net/ipv6/ip6_fib.c:2245
> >
> > stack backtrace:
> > CPU: 1 PID: 8095 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x198/0x1fd lib/dump_stack.c:118
> >  fib6_del+0x12b4/0x1630 net/ipv6/ip6_fib.c:1996
> >  fib6_clean_node+0x39b/0x570 net/ipv6/ip6_fib.c:2180
> >  fib6_walk_continue+0x4aa/0x8e0 net/ipv6/ip6_fib.c:2102
> >  fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2150
> >  fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2230
> >  __fib6_clean_all+0x120/0x290 net/ipv6/ip6_fib.c:2246
>
> This is walking a table and __fib6_clean_all takes the lock for the
> table (and you can see that above), so puzzling how fib6_del can be
> called for an entry with NULL fib6_table.

So you think the test for  (rt == net->ipv6.fib6_null_entry)
should be replaced by

BUG_ON(rt == net->ipv6.fib6_null_entry); ?
