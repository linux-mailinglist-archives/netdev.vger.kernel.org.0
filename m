Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B684C7F69
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 01:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiCAAmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 19:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiCAAmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 19:42:15 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7536727CEE
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:41:35 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g20so19928940edw.6
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cUh7YOptqnvj33mIS3WykOaibv0ctq8lQu0USbAcExo=;
        b=gduPBw6Te4zeyjZyaNuQQxqABiMq6fHp34ckrObT/FmzNLnDhHL/6KerjIgP5i0R8H
         Vm0a8HwZ8W8PnRRZRxnIsSc7yENLFtSGfKUqeeqvjpp8888PKIgF8NBwqM5k9ZzIrQCZ
         iYuicfiGesL4zlgkSDywOQeUUhyrP2kMozUBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cUh7YOptqnvj33mIS3WykOaibv0ctq8lQu0USbAcExo=;
        b=mcO7LAgldxJSt7Bw2wteEm2ZDKlYjUqojuVxektcUcZ1WVbGBV/Wbqh3J7A0UhqgS0
         88mbb45zOlhX0X7avfOOQ8dM/vIjAo/fdc+sKbTQ0O4fajbYAguQSdSBVc/M2lnw8LOn
         iiaAJYn6QiqUHG7JxEZE/iEseqeZhyl7r6LvQp6boJHmu9L6U6srItyY5828iPeFuIZy
         1FqoS7ZNYeqfLK/r5exPc/60zou7fnDHnSNcUQXdy/tAwnPVEc58LPvE9vRLd7JfJe1Z
         GlmfUGPBCfMG5+YPi+gyCFgWznP7umKIYcNAVTV5ZMDPH06DwuooVmt8d8xeqfADuzjJ
         NBOw==
X-Gm-Message-State: AOAM533qo5QHk9887L+vvHgSNSA4f0B02zdZblx7M1iE03liKgIpwRn1
        83Y3Ey0+m3hwLhBacau3VwLvkwObvvu27B73vLE=
X-Google-Smtp-Source: ABdhPJzidh9YNXNZNWwbijefpCnM+m5bCAsMmuQ+VJHzG4CgMtnMzD5GGTRZJi3+gimW+2nVtkgYcw==
X-Received: by 2002:a50:d5d6:0:b0:413:4be5:8ec1 with SMTP id g22-20020a50d5d6000000b004134be58ec1mr21991107edj.383.1646095293779;
        Mon, 28 Feb 2022 16:41:33 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id fr6-20020a170906890600b006d6e584920asm54561ejc.68.2022.02.28.16.41.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 16:41:32 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id dr20so3530039ejc.6
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 16:41:31 -0800 (PST)
X-Received: by 2002:ac2:4d91:0:b0:443:127b:558a with SMTP id
 g17-20020ac24d91000000b00443127b558amr14552706lfe.542.1646095280878; Mon, 28
 Feb 2022 16:41:20 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <CAHk-=wj8fkosQ7=bps5K+DDazBXk=ypfn49A0sEq+7-nZnyfXA@mail.gmail.com>
 <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com> <FC710A1A-524E-481B-A668-FC258F529A2E@gmail.com>
In-Reply-To: <FC710A1A-524E-481B-A668-FC258F529A2E@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 16:41:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=whLK11HyvpUtEftOjc3Gup2V77KpAQ2fycj3uai=qceHw@mail.gmail.com>
Message-ID: <CAHk-=whLK11HyvpUtEftOjc3Gup2V77KpAQ2fycj3uai=qceHw@mail.gmail.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 1:47 PM Jakob Koschel <jakobkoschel@gmail.com> wrote:
>
> The goal of this is to get compiler warnings right? This would indeed be great.

Yes, so I don't mind having a one-time patch that has been gathered
using some automated checker tool, but I don't think that works from a
long-term maintenance perspective.

So if we have the basic rule being "don't use the loop iterator after
the loop has finished, because it can cause all kinds of subtle
issues", then in _addition_ to fixing the existing code paths that
have this issue, I really would want to (a) get a compiler warning for
future cases and (b) make it not actually _work_ for future cases.

Because otherwise it will just happen again.

> Changing the list_for_each_entry() macro first will break all of those cases
> (e.g. the ones using 'list_entry_is_head()).

So I have no problems with breaking cases that we basically already
have a patch for due to  your automated tool. There were certainly
more than a handful, but it didn't look _too_ bad to just make the
rule be "don't use the iterator after the loop".

Of course, that's just based on that patch of yours. Maybe there are a
ton of other cases that your patch didn't change, because they didn't
match your trigger case, so I may just be overly optimistic here.

But basically to _me_, the important part is that the end result is
maintainable longer-term. I'm more than happy to have a one-time patch
to fix a lot of dubious cases if we can then have clean rules going
forward.

> I assumed it is better to fix those cases first and then have a simple
> coccinelle script changing the macro + moving the iterator into the scope
> of the macro.

So that had been another plan of mine, until I actually looked at
changing the macro. In the one case I looked at, it was ugly beyond
belief.

It turns out that just syntactically, it's really nice to give the
type of the iterator from outside the way we do now. Yeah, it may be a
bit odd, and maybe it's partly because I'm so used to the
"list_for_each_list_entry()" syntax, but moving the type into the loop
construct really made it nasty - either one very complex line, or
having to split it over two lines which was even worse.

Maybe the place I looked at just happened to have a long typename, but
it's basically always going to be a struct, so it's never a _simple_
type. And it just looked very odd adn unnatural to have the type as
one of the "arguments" to that list_for_each_entry() macro.

So yes, initially my idea had been to just move the iterator entirely
inside the macro. But specifying the type got so ugly that I think
that

        typeof (pos) pos

trick inside the macro really ends up giving us the best of all worlds:

 (a) let's us keep the existing syntax and code for all the nice cases
that did everything inside the loop anyway

 (b) gives us a nice warning for any normal use-after-loop case
(unless you explicitly initialized it like that
sgx_mmu_notifier_release() function did for no good reason

 (c) also guarantees that even if you don't get a warning,
non-converted (or newly written) bad code won't actually _work_

so you end up getting the new rules without any ambiguity or mistaken

> With this you are no longer able to set the 'outer' pos within the list
> iterator loop body or am I missing something?

Correct. Any assignment inside the loop will be entirely just to the
local loop case. So any "break;" out of the loop will have to set
another variable - like your updated patch did.

> I fail to see how this will make most of the changes in this
> patch obsolete (if that was the intention).

I hope my explanation above clarifies my thinking: I do not dislike
your patch, and in fact your patch is indeed required to make the new
semantics work.

What I disliked was always the maintainability of your patch - making
the rules be something that isn't actually visible in the source code,
and letting the old semantics still work as well as they ever did, and
having to basically run some verification pass to find bad users.

(I also disliked your original patch that mixed up the "CPU
speculation type safety" with the actual non-speculative problems, but
that was another issue).

                Linus
