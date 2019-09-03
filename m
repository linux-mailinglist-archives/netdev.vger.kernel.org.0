Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D310A664D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 12:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfICKM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 06:12:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45400 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbfICKMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 06:12:54 -0400
Received: by mail-ed1-f67.google.com with SMTP id f19so4001576eds.12;
        Tue, 03 Sep 2019 03:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nlLiM8uLHsTDV4s6ID+NIMbu8WjtXqoyK3qwNgbSYiM=;
        b=vYs1vRw1/oFdO+o5wGpcE2A/R7zo/Kl/5y58VHC1qwuEW+S49QlOrlhnRmwC9HOsAY
         FnBil7y+kIKi95xbWFV+xx3t15Km/EPCz+JVokw+S1BC468rqY8g6vTsTucryzndRCoX
         6c6hrOy9+gS837EAp89pk5tjCAsuXUzbZESD9axQkdFT1bkr/p3ijDTqUdPwx3wmareF
         PCe40FAwiA2tv/zIEw8RLstnK1sCgwoVB12HgxWeNhHtqTsCzhxzcqdSKpS7XlIx1NSy
         8mq73tvcH1hbcn7mwhGf0UgtHak8edsOPJ/jwm8875dUUNt2G5pzdVwp7fSj1jKy9Hcw
         JdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nlLiM8uLHsTDV4s6ID+NIMbu8WjtXqoyK3qwNgbSYiM=;
        b=W/YLNTr5EJxg5x/CymgyOJpyn0qMVL+IhtpRQNvxNuPtM2g6PdE1E9RmMS+nH0SvVs
         5HBlgWX2hwgw8xHfcgSBEJComVEOqW7ZHo8WJvMRt99bhQNs+Ijv/crYsyflkh6+MfTa
         zgC/d9gP/3eY0b3Z93OHpguzOBEa3SYWbDtDpgsteg6Tw7J3xxWbcTEcZ/DHcKzaVL82
         BaO6p7TPAtvJ4new5nstdmqTbDbO/NxPtXL/r5XvkY5vrzSAwjAhP+MtlcdWmK+xWgwf
         aODq+6YS/hTnxT9Hs+5u7pi9zuWGspKIXVJOHEHWWKEtXcBb74lDb+/GTPA7IseAg51K
         mU8w==
X-Gm-Message-State: APjAAAW5dlMfOuHJO6C5QjIrauAEu2ZjqSXlteNZD7U1xX+aDj/1C1xi
        e0ZfPPbtp3L/zqfQJuflviazXdc7KUDbzxM3LMg=
X-Google-Smtp-Source: APXvYqwk7nOMr1+qIcSpfZV7tnQtSDqzNfFRemJjn8SDcf/xGL+pUZVZJfwXknVYstIzNG+hA++Oic1gK1++akzHGwQ=
X-Received: by 2002:a50:d552:: with SMTP id f18mr11387509edj.36.1567505572724;
 Tue, 03 Sep 2019 03:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190903010817.GA13595@embeddedor> <cb7d53cd-3f1e-146b-c1ab-f11a584a7224@gmail.com>
In-Reply-To: <cb7d53cd-3f1e-146b-c1ab-f11a584a7224@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 3 Sep 2019 13:12:41 +0300
Message-ID: <CA+h21hpCAJhE8xhsgDQ55_MUUiesV=uVY4tD=TzaCE6wynUPoQ@mail.gmail.com>
Subject: Re: [PATCH] net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Sep 2019 at 10:19, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 9/3/19 3:08 AM, Gustavo A. R. Silva wrote:
> > Add suffix LL to constant 1000 in order to avoid a potential integer
> > overflow and give the compiler complete information about the proper
> > arithmetic to use. Notice that this constant is being used in a context
> > that expects an expression of type s64, but it's currently evaluated
> > using 32-bit arithmetic.
> >
> > Addresses-Coverity-ID: 1453459 ("Unintentional integer overflow")
> > Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> >  net/sched/sch_taprio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 8d8bc2ec5cd6..956f837436ea 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -966,7 +966,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
> >
> >  skip:
> >       picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
> > -                                speed * 1000 * 1000);
> > +                                speed * 1000LL * 1000);
> >
> >       atomic64_set(&q->picos_per_byte, picos_per_byte);
> >       netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
> >
>
> But, why even multiplying by 1,000,000 in the first place, this seems silly,
> a standard 32 bit divide could be used instead.
>
> ->
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8d8bc2ec5cd6281d811fd5d8a5c5211ebb0edd73..944b1af3215668e927d486b6c6c65c4599fb9539 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -965,8 +965,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
>                 speed = ecmd.base.speed;
>
>  skip:
> -       picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
> -                                  speed * 1000 * 1000);
> +       picos_per_byte = (USEC_PER_SEC * 8) / speed;
>
>         atomic64_set(&q->picos_per_byte, picos_per_byte);
>         netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
>
>
>

Right. And while we're at it, there's still the potential
division-by-zero problem which I still don't know how to solve without
implementing a full-blown __ethtool_get_link_ksettings parser that
checks against all the possible outputs it can have under the "no
carrier" condition - see "[RFC PATCH 1/1] phylink: Set speed to
SPEED_UNKNOWN when there is no PHY connected" for details.
And there's also a third fix to be made: the netdev_dbg should be made
to print "speed" instead of "ecmd.base.speed".

Thanks,
-Vladimir
