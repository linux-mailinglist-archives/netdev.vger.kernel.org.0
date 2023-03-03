Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0BA6AA595
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjCCXZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCCXZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:25:48 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A58A5F529;
        Fri,  3 Mar 2023 15:25:46 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v16so3796241wrn.0;
        Fri, 03 Mar 2023 15:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HT4lMsyMd/rs0g+TV8A+KT4h9PkSvQGCF9byQHf1DIU=;
        b=GB9gHpM1/YH4fvMKd1B5na4rsk8TWxVS1Q7ALBwj5REffUo9YwcnAeKeqR4Y3Jn4Ws
         ZYWqHFNw7i3atecqxT5Ep7++QSM6DefZ9kTya5RXN4u+6siDiWtk2nEUgUW2zQRFWbv9
         eny/qlyAv7QtAWF11S/cKIzNLyD3+W9jwm+2euWFtj5IiaGJmBGNysBoA7WoALWVSvtV
         ejlml4/ND3nOuZTBHW7XWFxdnxY/8TDwtJp0tAw+QJgj+JPm8jJT1ydUtcl4nLKqCyXK
         d3e8yyCGB0Qv1Tnmxb/SRAhxa+kUqszMZyOuwpAeYq6hCfvUJ72HexrsrrFyOkJtYdyR
         MRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HT4lMsyMd/rs0g+TV8A+KT4h9PkSvQGCF9byQHf1DIU=;
        b=I4MGMi71snCqCO/6nKi/s0HqxMAku7OBKViJ3Mao7GID6XV5KcRWdMmW673zTv4S7O
         dJAtLMwDXtEw420KhXbSH//Mkq18aqVelcqeyQuzjDGD/hu5GttlMNJfpd+x0Y5ttfL6
         BIyZCIrVSECLp+TdAvXRVepAlWg9LRbFHGOt8shuSRJTBFHcLsJ//AVywebxhvLgLKKI
         p3Ws7YKkMSbt8J2hcWalFess2X6FQaXUmZ+l3Bp4gOv2k/ddbPs3bhmvIM2yHehmAKXA
         6JllOsepHetUSEKm5/EWCpITCGYA2O4xQ7KhKCguMCCd5fJBJqrfkoqWKBc7Iz+h7VYK
         sJzA==
X-Gm-Message-State: AO0yUKV6iSgMrCK/av14LDWXGOmGRY+DjEQyuiHi7pk9y8UO3h2DLcP6
        9zezcGqnxDbwmk1xVp73Cd70D1MR0HCz38WNe2DDsOMJ
X-Google-Smtp-Source: AK7set9TreEW0oSDmH3l6mmX/7Gu9n8UZ2iD1V3jej0mPY7Y4qba8ASGbcssxlDQOIKmSeNt0uPSIKKlahf0sX5+Yr4=
X-Received: by 2002:a5d:6485:0:b0:2c5:4adc:6e52 with SMTP id
 o5-20020a5d6485000000b002c54adc6e52mr1698427wri.3.1677885944464; Fri, 03 Mar
 2023 15:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20221222221244.1290833-1-kuba@kernel.org> <20221222221244.1290833-3-kuba@kernel.org>
 <87r0u6j721.ffs@tglx> <20230303133143.7b35433f@kernel.org> <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 3 Mar 2023 15:25:32 -0800
Message-ID: <CAA93jw5nHjHTFiN9D4wCeOJ4UYmP2537Ar+5ZsCYftzhg7RLPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
To:     paulmck@kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 3, 2023 at 2:56=E2=80=AFPM Paul E. McKenney <paulmck@kernel.org=
> wrote:
>
> On Fri, Mar 03, 2023 at 01:31:43PM -0800, Jakub Kicinski wrote:
> > On Fri, 03 Mar 2023 14:30:46 +0100 Thomas Gleixner wrote:
> > > > -         if (time_before(jiffies, end) && !need_resched() &&
> > > > -             --max_restart)
> > > > +         unsigned long limit;
> > > > +
> > > > +         if (time_is_before_eq_jiffies(end) || !--max_restart)
> > > > +                 limit =3D SOFTIRQ_OVERLOAD_TIME;
> > > > +         else if (need_resched())
> > > > +                 limit =3D SOFTIRQ_DEFER_TIME;
> > > > +         else
> > > >                   goto restart;
> > > >
> > > > +         __this_cpu_write(overload_limit, jiffies + limit);
> > >
> > > The logic of all this is non-obvious and I had to reread it 5 times t=
o
> > > conclude that it is matching the intent. Please add comments.
> > >
> > > While I'm not a big fan of heuristical duct tape, this looks harmless
> > > enough to not end up in an endless stream of tweaking. Famous last
> > > words...
> >
> > Would it all be more readable if I named the "overload_limit"
> > "overloaded_until" instead? Naming..
> > I'll add comments, too.
> >
> > > But without the sched_clock() changes the actual defer time depends o=
n
> > > HZ and the point in time where limit is set. That means it ranges fro=
m 0
> > > to 1/HZ, i.e. the 2ms defer time ends up with close to 10ms on HZ=3D1=
00 in
> > > the worst case, which perhaps explains the 8ms+ stalls you are still
> > > observing. Can you test with that sched_clock change applied, i.e. th=
e
> > > first two commits from
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core=
/softirq
> > >
> > > 59be25c466d9 ("softirq: Use sched_clock() based timeout")
> > > bd5a5bd77009 ("softirq: Rewrite softirq processing loop")
> >
> > Those will help, but I spent some time digging into the jiffies related
> > warts with kprobes - while annoying they weren't a major source of wake
> > ups. (FWIW the jiffies noise on our workloads is due to cgroup stats
> > disabling IRQs for multiple ms on the timekeeping CPU).
> >
> > Here are fresh stats on why we wake up ksoftirqd on our Web workload
> > (collected over 100 sec):
> >
> > Time exceeded:      484
> > Loop max run out:  6525
> > need_resched():   10219
> > (control: 17226 - number of times wakeup_process called for ksirqd)
> >
> > As you can see need_resched() dominates.
> >
> > Zooming into the time exceeded - we can count nanoseconds between
> > __do_softirq starting and the check. This is the histogram of actual
> > usecs as seen by BPF (AKA ktime_get_mono_fast_ns() / 1000):
> >
> > [256, 512)             1 |                                             =
       |
> > [512, 1K)              0 |                                             =
       |
> > [1K, 2K)             217 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  =
       |
> > [2K, 4K)             266 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=
@@@@@@@|
> >
> > So yes, we can probably save ourselves ~200 wakeup with a better clock
> > but that's just 1.3% of the total wake ups :(
> >
> >
> > Now - now about the max loop count. I ORed the pending softirqs every
> > time we get to the end of the loop. Looks like vast majority of the
> > loop counter wake ups are exclusively due to RCU:
> >
> > @looped[512]: 5516
> >
> > Where 512 is the ORed pending mask over all iterations
> > 512 =3D=3D 1 << RCU_SOFTIRQ.
> >
> > And they usually take less than 100us to consume the 10 iterations.
> > Histogram of usecs consumed when we run out of loop iterations:
> >
> > [16, 32)               3 |                                             =
       |
> > [32, 64)            4786 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=
@@@@@@@|
> > [64, 128)            871 |@@@@@@@@@                                    =
       |
> > [128, 256)            34 |                                             =
       |
> > [256, 512)             9 |                                             =
       |
> > [512, 1K)            262 |@@                                           =
       |
> > [1K, 2K)              35 |                                             =
       |
> > [2K, 4K)               1 |                                             =
       |
> >
> > Paul, is this expected? Is RCU not trying too hard to be nice?
>
> This is from way back in the day, so it is quite possible that better
> tuning and/or better heuristics should be applied.
>
> On the other hand, 100 microseconds is a good long time from an
> CONFIG_PREEMPT_RT=3Dy perspective!

All I have to add to this conversation is the observation that
sampling things at the
nyquist rate helps to observe problems like these.

So if you care about sub 8ms response time, a sub 4ms sampling rate is need=
ed.

> > # cat /sys/module/rcutree/parameters/blimit
> > 10
> >
> > Or should we perhaps just raise the loop limit? Breaking after less
> > than 100usec seems excessive :(


> But note that RCU also has rcutree.rcu_divisor, which defaults to 7.
> And an rcutree.rcu_resched_ns, which defaults to three milliseconds
> (3,000,000 nanoseconds).  This means that RCU will do:
>
> o       All the callbacks if there are less than ten.
>
> o       Ten callbacks or 1/128th of them, whichever is larger.
>
> o       Unless the larger of them is more than 100 callbacks, in which
>         case there is an additional limit of three milliseconds worth
>         of them.
>
> Except that if a given CPU ends up with more than 10,000 callbacks
> (rcutree.qhimark), that CPU's blimit is set to 10,000.
>
> So there is much opportunity to tune the existing heuristics and also
> much opportunity to tweak the heuristics themselves.

This I did not know, and to best observe rcu in action nyquist is 1.5ms...

Something with less constants and more curves seems in order.

>
> But let's see a good use case before tweaking, please.  ;-)
>
>                                                         Thanx, Paul
>
> > > whether that makes a difference? Those two can be applied with some
> > > minor polishing. The rest of that series is broken by f10020c97f4c
> > > ("softirq: Allow early break").
> > >
> > > There is another issue with this overload limit. Assume max_restart o=
r
> > > timeout triggered and limit was set to now + 100ms. ksoftirqd runs an=
d
> > > gets the issue resolved after 10ms.
> > >
> > > So for the remaining 90ms any invocation of raise_softirq() outside o=
f
> > > (soft)interrupt context, which wakes ksoftirqd again, prevents
> > > processing on return from interrupt until ksoftirqd gets on the CPU a=
nd
> > > goes back to sleep, because task_is_running() =3D=3D true and the sta=
le
> > > limit is not after jiffies.
> > >
> > > Probably not a big issue, but someone will notice on some weird workl=
oad
> > > sooner than later and the tweaking will start nevertheless. :) So may=
be
> > > we fix it right away. :)
> >
> > Hm, Paolo raised this point as well, but the overload time is strictly
> > to stop paying attention to the fact ksoftirqd is running.
> > IOW current kernels behave as if they had overload_limit of infinity.
> >
> > The current code already prevents processing until ksoftirqd schedules
> > in, after raise_softirq() from a funky context.



--=20
A pithy note on VOQs vs SQM: https://blog.cerowrt.org/post/juniper/
Dave T=C3=A4ht CEO, TekLibre, LLC
