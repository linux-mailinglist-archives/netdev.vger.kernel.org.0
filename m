Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83DF533C2A
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbiEYMAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiEYMAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:00:30 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C140B6542
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:00:28 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s14so8516595ybc.10
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJSFJC8NL6T/0QdSyTjcqhTPA35xx/xPeeTOEfdokr8=;
        b=DCBuQhAZeTTBq2YdwVLAJTB1pN3BShJ0xL10UgT29F5qqClKvLq3U+lqJCvyK6CL6k
         FtPihI6P99LxL6M8715GoI/CAvIJS3heSaHevB4KmMmgoHHse7Up2oHM5doz6dA9VKui
         8vmHQSZUIaz7vbl/D76j4c/zDgfOUyPn+RkLjrDzZh6vpT27jx7kL2bA3Jza1jjxl95V
         Gt2QmB8Efar/Vd0UQWQRl2hwsewYEBWjo7ODtIGjPd53B7xwJBBc09eFr+SDsl3En3EP
         LY87frIoI987eiFcRtoGlVDSjuY9qsbIqaCWHIv2LJpyY1bp0Lwdvsrn+hGXWX7RviJ6
         3rwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJSFJC8NL6T/0QdSyTjcqhTPA35xx/xPeeTOEfdokr8=;
        b=QTk9apYGo8UpVKCNN65HiG9kGRhh0kFeilBwRgro1jpCqKMYYX64FHt89bGsPDlEuz
         viCdlNcyyPi82qr6f7i1v07YqEVZU5YwQBp5iQN+rIlPKyxkmoWIkucZj6iF6uWuudjI
         xtsJfdlMJrRMRQr4xtudb2uyR3/MPCg5CsZ31rOdYPTNtCy7uLmlkuyCFrZOh8ES8++2
         sEq5nmmm5YrmdeicVPVIgh5jq5J0DGG4p16BnCOp8eYlyatBCQRVHdC8LuEdy503LkJW
         PN463d7LgZDUj26zWop47BJ3cCNi9++M5mlWT6kxXhl2Ez2W6ADzdeswjWI/lYwGfoYL
         LNxA==
X-Gm-Message-State: AOAM531mD//e4FjxyYsl5sPpQxB06oPWXX4RXdaxVcN/HJuzgX2vm1Qg
        rHdjFVdR9MqCSW4vY1MnZL2slun0IJAF3vIzAT5p3g==
X-Google-Smtp-Source: ABdhPJxF4ETJipeP9oezm6T+5TRRyDMoj/K9Rj04LDTL+b2TULV2ZGuwXNvWdYFpmc7f8koF254XhfYNV6Iib5W+urE=
X-Received: by 2002:a5b:148:0:b0:650:15bd:97ab with SMTP id
 c8-20020a5b0148000000b0065015bd97abmr11092174ybp.231.1653480027414; Wed, 25
 May 2022 05:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <50c8042451454d8e907dd026ed5a3d53@AcuMS.aculab.com> <42e84c99d8d254646fdfb66b001429fedd4c5830.camel@redhat.com>
In-Reply-To: <42e84c99d8d254646fdfb66b001429fedd4c5830.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 May 2022 05:00:15 -0700
Message-ID: <CANn89iKZhkL15b+pBft+XsUK+brxnQ6bX146Nz+YJ3FW-J1hyg@mail.gmail.com>
Subject: Re: Softirq latencies causing lost ethernet packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "greearb@candelatech.com" <greearb@candelatech.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tj@kernel.org" <tj@kernel.org>,
        "priikone@iki.fi" <priikone@iki.fi>,
        "peterz@infradead.org" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 4:01 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-05-25 at 09:01 +0000, David Laight wrote:
> > I've finally discovered why I'm getting a lot of lost ethernet
> > packets in one of my high packet rate tests (400k/sec short UDP).
> >
> > The underlying problem is that the napi callbacks need to loop
> > in the softirq code.
> > For my test I need the cpu to be running at well over 50% 'softint'.
> > (And that is just for the ethernet receive, RPS is moving the IP/UDP
> > processing elsewhere.)
> >
> > The problems are caused by this bit of code in __do_softirq():
> >
> >         pending = local_softirq_pending();
> >         if (pending) {
> >                 if (time_before(jiffies, end) && !need_resched() &&
> >                     --max_restart)
> >                         goto restart;
> >
> >                 wakeup_softirqd();
> >         }
> >
> > Eric's c10d73671 changed it from:
> >         if (pending) {
> >                 if (--max_restart)
> >                         goto restart;
> >
> >                 wakeup_softirqd();
> >         }
> >
> > to
> >         if (pending) {
> >                 if (time_before(jiffies, end) && !need_resched())
> >                         goto restart;
> >
> >                 wakeup_softirqd();
> >         }
> >
> > Because just running 10 copies caused excessive latencies.
> >
> > The good work was then undone by 34376a50f that added the
> > 'max_restart' check back (with its limit of 10) to avoid
> > an issue with stop_machine getting stuck (jiffies doesn't
> > increment).
> >
> > This can (probably) be fixed by setting the limit to 1000.
> >
> > However there is a separate issue with the need_resched() check.
> > In my tests this is stopping the softint/napi callbacks for
> > anything up to 9 milliseconds - more than enough to drop packets.
> >
> > The problem here is that the softirqd are low priority processes.
> > The application processes the receive the UDP all run under the
> > realtime scheduler (priority -51).
> > If the softint interrupts my RT process it is fine.
> > But the following sequence isn't:
> >  - softint runs on idle process.
> >  - RT process scheduled on the same cpu
> >  - __do_softirq() detects need_resched() calls wakeup_softirqd()
> >  - scheduler switches from the idle to my RT process.
> >  - RT process runs for several milliseconds.
> >  - finally softirqd is scheduled
> >
> > The softint is usually higher priority than any RT thread
> > (because it just steals the context).
> > But in the more unusual case of an RT process being scheduled
> > while the softint is active it suddenly becomes lower priority
> > than the RT process.
> >
> > I'm sure what the intended purpose of the need_resched() is?
> > I think it was eric's first thought for a limit, but he had to
> > add the jiffies test as well to avoid RCU stalls.
> >
> > The jiffies test itself might be problematic.
> > It is fixed at 2 jiffies - 1ms to 2ms at 1000Hz.
> > I'm expecting the softint code to be running at (maybe) 80% cpu.
> > So that limit would need increasing.
> > There is a similar limit in the napi code - but that is configurable
> > (and, I think, just causes the softing code to loop).
> >
> > But if RCU stalls are a problem maybe the rcu read lock ought to
> > disable softints?
> > So the softint is run when the rcu lock is released.
> >
> > I did try setting the softirqd processes to a much higher priority
> > but that didn't seem to help - I didn't look exactly why.
> >
> > While I could use processor affinities to stop the application's
> > RT threads running on the softint-heavy cpu that is all hard
> > and difficult to arrange.
> > In any case the application can make use of the non-softint time
> > on those cpu.
>
> Overall this looks like a scenario where the napi threaded model could
> help?
>
> echo 1 > /sys/class/net/<dev name>/threaded
>
> and than set the napi threads scheduling parameter as it fit you
> better.
>
> Cheers,
>
> Paolo

Also, make sure your user threads are not allowed to run on the cpu
servicing NIC interrupts.
