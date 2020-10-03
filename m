Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56A2820D5
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 05:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgJCDyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 23:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgJCDyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 23:54:52 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5DC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 20:54:51 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id f15so3081817ilj.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 20:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0iOQNpMhR7U1FgYM8E/Ua+xB3gweiORdqVQ3ZmWEOk=;
        b=QkHEOz+Egu60WInssW82SFR6smVoWMxsr/MfLrNrtnB3cbJbiGbrxUGkGMi3jwNDNn
         225JuWpbl+wNFzj/g5lDNM395RCDRsU7cLroHd8KeJF8L7/ah2BH3XydUIzP7rNF87US
         QvLWfuwDjFcgRVLcwR2ka4zGj+Tkj/RJcUnX0BYb3KD9Z5jgA7xTY0QsACPvxhXgNwT0
         Hg77lNripA7zn5JD/kyLvuQy3Mz3SCj+s7dJ6i3oKJvUooNhZ4yZdLur7uI7etxNoHBa
         u1iuAERfwL1Tob+a0mW/MLrSQk1ehPaII/5Mjsck3XiRogPUlvt0N9Y9gqnF8jb5C0Y7
         gsRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0iOQNpMhR7U1FgYM8E/Ua+xB3gweiORdqVQ3ZmWEOk=;
        b=MveLVetm127GYKd/1Ax/FOQ0ui44fDemmjJt1Fc6ZJDLpJcRWFHwUcqlBZvNyeinFn
         Yg9MjtAECFHMmGvIXMJ6QClr6NstOcIKH6jSyv0/L2GYLraLuCrHeEpHEwkujUo7dY0U
         IIj1FoE7ieOURuc9X1Z6dH6MGxKjtAo5HBbHvO/KZPhC/lU53E7ocmiSUUNo4Iv/XAzM
         le0TAyU4Jymx3zS4plL+TnHf/KbAUcGcgabHFUGj2c8CyHv7ORyU1E0LCBX7gDSHveuk
         ljZunLTGEniEPYSzoNRjn332Ke15cCL6Yop+9nXllJ4Bt1q8Ggx3yoDdbivc5gN/oUsA
         RpSQ==
X-Gm-Message-State: AOAM530A3DZi2lUVAPeUY3Nj12Zfm3wZTR5dHDFzrV8/nBi7Kw+Dglys
        sdDJ+gPZ259q2OOmc1Ba2ic2OPCvRYSPupJ/Zpk+7A==
X-Google-Smtp-Source: ABdhPJz0YkZeQkkZJ28kgXR6+zgbQXDetrujzT22cEY4m7955swLivp+pTj4PSkmHoVA9s1gNQNj4K2G0jFQdaFVdBc=
X-Received: by 2002:a92:5882:: with SMTP id z2mr4351350ilf.137.1601697291001;
 Fri, 02 Oct 2020 20:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com> <20201002.160042.621154959486835359.davem@davemloft.net>
 <CAADnVQKdwB9ZnBnyqJG7kysBnwFr+BYBAEF=sqHj-=VRr-j34Q@mail.gmail.com>
In-Reply-To: <CAADnVQKdwB9ZnBnyqJG7kysBnwFr+BYBAEF=sqHj-=VRr-j34Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 3 Oct 2020 05:54:38 +0200
Message-ID: <CANn89iLJSHhb=7mibKTBF2bbceFqSM0kNOANdFZ3rTaM3kwj7w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Wei Wang <weiwan@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 1:15 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 2, 2020 at 4:02 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Wei Wang <weiwan@google.com>
> > Date: Wed, 30 Sep 2020 12:21:35 -0700
> >
> >  ...
> > > And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> > > entity per host, is that kthread is more configurable than workqueue,
> > > and we could leverage existing tuning tools for threads, like taskset,
> > > chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> > > if we eventually want to provide busy poll feature using kernel threads
> > > for napi poll, kthread seems to be more suitable than workqueue.
> > ...
> >
> > I think we still need to discuss this some more.
> >
> > Jakub has some ideas and I honestly think the whole workqueue
> > approach hasn't been fully considered yet.
>
> I want to point out that it's not kthread vs wq. I think the mechanism
> has to be pluggable. The kernel needs to support both kthread and wq.
> Or maybe even the 3rd option. Whatever it might be.
> Via sysctl or something.
> I suspect for some production workloads wq will perform better.
> For the others it will be kthread.
> Clearly kthread is more tunable, but not everyone would have
> knowledge and desire to do the tunning.

The exact same arguments can be used against RPS and RFS

RPS went first, and was later augmented with RFS (with very different goals)

They both are opt-in

> We can argue what should be the default, but that's secondary.
>
> > If this wan't urgent years ago (when it was NACK'd btw), it isn't
> > urgent for 5.10 so I don't know why we are pushing so hard for
> > this patch series to go in as-is right now.
> >
> > Please be patient and let's have a full discussion on this.
>
> +1. This is the biggest change to the kernel networking in years.
> Let's make it right.

Sure. I do not think it is urgent.

This has been revived by Felix some weeks ago, and I think we were the
ones spending time on the proposed patch set.
Not giving feedback to Felix would have been "something not right".

We reviewed and tested Felix patches, and came up with something more flexible.

Sure, a WQ is already giving nice results on appliances, because there
you do not need strong isolation.
Would a kthread approach also work well on appliances ? Probably...
