Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D922908E9
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 17:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410466AbgJPPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408815AbgJPPx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 11:53:26 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BA4C0613D3
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 08:53:25 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w17so3163779ilg.8
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 08:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQZtkpvXIzZn78MZ/518fJ3McjRmtqXJZU082+s0tHs=;
        b=DQ/jBBwGj3IXg/jL7AZlb8hl361K8V4f8WWxzstsNleOL1xnvATPjl/huCQeEqwXtJ
         KQZvGkXEsbQJGrJANu+nNhMb3Yl3C/zQqCi2Qf0+8wgOX/TBCB+jLAZrX9lnPVc6Z+c7
         3h/i4aAZxoOXJSRcgAQ5nBYlv3WQA7TOf5rSgjmBYbLfuGA1+B0EIXf1I5hUPvPhHPiz
         NFnb4SZHYiI1dP2tUwVC73W82O+vxJv5U75qFK8lH0ylfVgdcxjlU7y4ElonEX4dqavR
         lNdymfS+GJE5L27dS7+C9Rs+lnSBE7BFtYpxN5VCuELfkrbKS1hiz/G6X01Z+OHMQchX
         ixgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQZtkpvXIzZn78MZ/518fJ3McjRmtqXJZU082+s0tHs=;
        b=djQ9T9oHRfD4W8Z/Dibi7jSLs/HHUqxSIj2FpMROO+hjbA6nK3uLXAY8pMe5fdm59u
         ktSLKdNXSs5UxLrri7lveOOfWrCR8hoH5NaSSM5CQqc8Z1Lih7/hhn3gWfo6+xjqNzkE
         XZuIZTfNcux7sG0HdBExgqie82SmESg4BPKBuCZxpnpRtA00WYn7MdhBku2qxt1LkAsV
         pAEKp+BMXkvzaw0IInpnx6IJ5PyYOfmffJujgHS4WIZvHeVlZ3npVzL5dKtRZmcqhKVh
         mCnWflqzsgoktMA9y6oQQ/WHq025Ksjf7KK7svzQfGrgYRVAs8f/T6vCJZwiRC/vzQEe
         9GYg==
X-Gm-Message-State: AOAM532F94HF91azaW/U8pQ/LFpJft0gYvEey5Z0Vzf70+QPNDa1ljnB
        o4QY8YAhteKWMsjIdxkvM7EqYWKAXwnK5gOlSotiBw==
X-Google-Smtp-Source: ABdhPJzdD/QEjK8XyQTH6ju80PkeKVeEPXCh5f3MnbkzqCcjWo/aKGpcDm7BaIUX8lC6vZUTUeQswmhhiY4eWLaGvq4=
X-Received: by 2002:a92:c213:: with SMTP id j19mr3342293ilo.205.1602863604809;
 Fri, 16 Oct 2020 08:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201016121007.2378114-1-a.nogikh@yandex.ru>
In-Reply-To: <20201016121007.2378114-1-a.nogikh@yandex.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Oct 2020 17:53:13 +0200
Message-ID: <CANn89iLRStQ12mpExh4oOdUcH6QmT5PMDJ3TGkrpULLFqGuoFQ@mail.gmail.com>
Subject: Re: [PATCH] netem: prevent division by zero in tabledist
To:     Aleksandr Nogikh <a.nogikh@yandex.ru>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dave Taht <dave.taht@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 2:10 PM Aleksandr Nogikh <a.nogikh@yandex.ru> wrote:
>
> From: Aleksandr Nogikh <nogikh@google.com>
>
> Currently it is possible to craft a special netlink RTM_NEWQDISC
> command that result in jitter being equal to 0x80000000. It is enough
> to set 32 bit jitter to 0x02000000 (it will later be multiplied by
> 2^6) or set 64 bit jitter via TCA_NETEM_JITTER64. This causes an
> overflow during the generation of uniformly districuted numbers in
> tabledist, which in turn leads to division by zero (sigma != 0, but
> sigma * 2 is 0).
>
> The related fragment of code needs 32-bit division - see commit
> 9b0ed89 ("netem: remove unnecessary 64 bit modulus"), so
> switching to 64 bit is not an option.
>
> Fix the issue by preventing 32 bit integer overflows in
> tabledist. Also, instead of truncating s64 integer to s32, truncate it
> to u32, as negative standard deviation does not make sense anyway.
>
> Reported-by: syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> ---
>  net/sched/sch_netem.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index 84f82771cdf5..d8b0bf1b5346 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -315,7 +315,7 @@ static bool loss_event(struct netem_sched_data *q)
>   * std deviation sigma.  Uses table lookup to approximate the desired
>   * distribution, and a uniformly-distributed pseudo-random source.
>   */
> -static s64 tabledist(s64 mu, s32 sigma,
> +static s64 tabledist(s64 mu, u32 sigma,
>                      struct crndstate *state,
>                      const struct disttable *dist)
>  {
> @@ -329,8 +329,14 @@ static s64 tabledist(s64 mu, s32 sigma,
>         rnd = get_crandom(state);
>
>         /* default uniform distribution */
> -       if (dist == NULL)
> +       if (!dist) {
> +               /* Sigma is too big to perform 32 bit division.
> +                * Use the widest possible deviation.
> +                */
> +               if ((u64)sigma * 2ULL >= U32_MAX)

Or simply
    if (sigma >= U32_MAX/2)

> +                       return mu + rnd - U32_MAX / 2;

Since only syzbot can possibly use these silly parameters, what about capping
the parameters in control path, when netem is setup/changed, instead
of adding a test in the fast path ?
