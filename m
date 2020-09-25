Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F02F279525
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgIYXvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgIYXvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:51:08 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCD6C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:51:08 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a19so4019985ilq.10
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwPCpvlGEXVCK7abPyNGQgzEOxvQF6kh//0Vu7ozBOM=;
        b=E1CX1pGk1a07LptIb63J06QU7s0JzfJhGzlUXQfjmcR4pfo7brKv17sqYk1XsLwpXX
         NTw/3qruitwiVC2aGvrxnZYyobBVy8jyfUuXjRhLF8j7TFLa9SkiSwV4KQXFq9TgIYK3
         ChDslzSoAzj0K4cLXUS0JodA80zXWwP2JiK3Xfhs9Hiamki4mKuKRaD2ZXTXvV22RlCX
         jiXrN7UfYYQ6VKBK9/WHMD7PfSpb+rOlLtA9uo7KEf2N0hW7LjOkXOT0A5v/d9YS/R52
         ltM5yAq/jRKtXRv+iJZRVsrF5vpUe3mtVbLTCdc9gziYv7rCJGOUJCVNveMpPkHpj6aU
         0Btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwPCpvlGEXVCK7abPyNGQgzEOxvQF6kh//0Vu7ozBOM=;
        b=Dib4v+odI+ROl1jFiBR9hkQOLw8QJRm6crwrB84KlVi3aVZYCf4vYBLWfHpdWZ/kvH
         Y/oui2qckDpMXNZ7bxhwh4AF8O/T1VnjUiIO1Md/pqJdd6Vr+ung/z2a5Eu5b2aQHJQj
         Tk0iE3kFpPwUZcuCkGnkXapEl/swbU0cLAa7CMQuWX6VCrtFrIk3RSnoLhIP97UZT3bk
         8PCL4ZOSAwToX5yD/6tPLoo/JSu9dngGev/in2Dh4kY0LHsxeAZjNoGe6k92sfCXOvNy
         NyzWOdsyT88BMB8Xu1EAOcb16dmqoEH6vcYA+HylcJt4RMG+mKZ0dB+Db6EgmafUYyox
         kQDg==
X-Gm-Message-State: AOAM532gTqWKsyHT2ME+buGEOgIwxCcwblK+89Q8qK+0OSazoe9hZsEU
        2mXOEf91EXlnzCsRo5YbuABf0Eo4NEmvkKNfuMKcR4ZBNwU2Fg==
X-Google-Smtp-Source: ABdhPJxg5p0MTScwNTu3ngP6gAGVQ00KrJunhK5l8Rij3uOxfplU8/t0oTVimtXhH0V7rmUTEcz2i8VqBl/43Iuyv4s=
X-Received: by 2002:a92:d645:: with SMTP id x5mr2305547ilp.79.1601077867314;
 Fri, 25 Sep 2020 16:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <20200914172453.1833883-2-weiwan@google.com>
 <2ab7cdc1-b9e1-48c7-89b2-a10cd5e19545@www.fastmail.com>
In-Reply-To: <2ab7cdc1-b9e1-48c7-89b2-a10cd5e19545@www.fastmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 25 Sep 2020 16:50:56 -0700
Message-ID: <CAEA6p_DyU7jyHEeRiWFtNZfMPQjJJEV2jN1MV-+5txumC5nmZg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/6] net: implement threaded-able napi poll
 loop support
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 12:46 PM Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
>
> Hello,
>
> Happy to see this work being resurrected (in case it is useful). :)
>
> On Mon, Sep 14, 2020, at 19:24, Wei Wang wrote:
> >
> > [...]
> >
> > +static void napi_thread_start(struct napi_struct *n)
> > +{
> > +     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
> > +             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
> > +                                        n->dev->name, n->napi_id);
> > +}
> > +
>
> The format string is only based on variable strings. To ease a quick
> grep for napi threads with ps I would propose to use "napi-%s-%d" or
> something alike to distinguish all threads created that way.
>

Ack. Will add this in the next version.

> Some other comments and questions:
>
> Back then my plan was to get this somewhat integrated with the
> `threadirqs` kernel boot option because triggering the softirq from
> threaded context (if this option is set) seemed wrong to me. Maybe in
> theory the existing interrupt thread could already be used in this case.
> This would also allow for fine tuning the corresponding threads as in
> this patch series.
>
> Maybe the whole approach of threaded irqs plus the already existing
> infrastructure could also be used for this series if it wouldn't be an
> all or nothing opt-in based on the kernel cmd line parameter? napi would
> then be able to just poll directly inline in the interrupt thread.
>

I took a look at the current "threadirqs" implementation. From my
understanding, the kthread used there is to handle irq from the
driver, and needs driver-specific thread_fn to be used. It is not as
generic as in the napi layer where a common napi_poll() related
function could be used as the thread handler. Or did I misunderstand
your point?


> The difference for those kthreads and the extra threads created here
> would be that fifo scheduling policy is set by default and they seem to
> automatically get steered to the appropriate CPUs via the IRQTF_AFFINITY
> mechanism. Maybe this approach is useful here as well?
>
> I hadn't had a look at the code for a while thus my memories might be
> wrong here.

Yes. Using a higher priority thread policy and doing pinning could be
beneficial in certain workloads. But I think this should be left to
the user/admin to do the tuning accordingly.

>
> Thanks,
> Hannes
