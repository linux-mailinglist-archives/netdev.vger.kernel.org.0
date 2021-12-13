Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994584730F6
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbhLMP4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbhLMP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:56:33 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9694BC06173F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 07:56:33 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id x32so39322251ybi.12
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 07:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJvT79EfcA7O0EY/8/ibhfo/O9cdo3pl3yfd1aNngOA=;
        b=TmeDngSyR8aTmXx91HH/CW8JsF4ov1PSJRE8TgYYvD+FzXxvUQCtJkq3lPBmDRMwt2
         SzdNYNa+tvX6Z+KN77/kqG9/aXuFXfTqKXmQcx0EbmgWkSPGMaJDy8XNa5lE/dp95n4M
         pvXG6tVJqE69hSvjV45bmynX/IbKKgWuEJar6MApx+nvX1KQQU4iEnk18X87gNvPSso+
         qojOfHej71CFMlOk7RheAe23e//oYCMJTb0GH+AO25NwEbILS3hRe2cqB2seOntW+X2i
         1mh8z9Br5IjxUvVPiy96EOX7D6YyRnjVNgjVBX38V63b00E/tZn8Ejl9vX+VYlPfnM2u
         JpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJvT79EfcA7O0EY/8/ibhfo/O9cdo3pl3yfd1aNngOA=;
        b=jZg6oQGl9GJgu+Ph6A+X9eNzP5GPM1a+HOxOQEWPCZJQOPGwsHNBHApisvx/v8MiQP
         IQ0ANDX6vosZJvssahDh3a9/9/MN3h4GhEqgq0282FXFzA2IycemppXAQ2vhRD4nPMno
         v0Bl4/140BsaYmM7Ht/CsyEWZSzharO3wtB7DOVnDuI/7ksItbf7fnuARQ/pu2W0mHqx
         5WCgMFzDQ5iu89qqaQ7V5Byj7kH4VLtm+bBW8uQobbkVw/nc0yAKJhiY0X30Wab7IbJL
         WovjYn5T040qkZqdH1rFccgnO4OjJZPdDoIUvbbaZo+/YdWBXarg9qykRz2EjU8pgndQ
         s0og==
X-Gm-Message-State: AOAM531ZARtOwk8Qh/uzTToXHUyzMZt10G4yyxpEIkGozliDfRF0z31C
        8k5uH2YyrMbhVcxOAvtxm5gLQZKYsaY/v5YgqMs9pg==
X-Google-Smtp-Source: ABdhPJxlK8jZHDGMWgi6JUell0daIec/wGzGFUvgQQWqotEzT3/6vJvJEXBx5S7k7Nm+v4Yjje3FKcYQK583wCVjouo=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr35214440ybp.383.1639410992399;
 Mon, 13 Dec 2021 07:56:32 -0800 (PST)
MIME-Version: 1.0
References: <45d12aa0c95049a392d52ff239d42d83@AcuMS.aculab.com>
 <52edd5fd-daa0-729b-4646-43450552d2ab@intel.com> <96b6a476c4154da3bd04996139cd8a6d@AcuMS.aculab.com>
In-Reply-To: <96b6a476c4154da3bd04996139cd8a6d@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Dec 2021 07:56:20 -0800
Message-ID: <CANn89i+4acJp8ohBMWU4sketLfitKCzmS8FQTvduxumYYketvw@mail.gmail.com>
Subject: Re: [PATCH] x86/lib: Remove the special case for odd-aligned buffers
 in csum_partial.c
To:     David Laight <David.Laight@aculab.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Noah Goldstein <goldstein.w.n@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 7:37 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Dave Hansen
> > Sent: 13 December 2021 15:02
> .c
> >
> > On 12/13/21 6:43 AM, David Laight wrote:
> > > There is no need to special case the very unusual odd-aligned buffers.
> > > They are no worse than 4n+2 aligned buffers.
> > >
> > > Signed-off-by: David Laight <david.laight@aculab.com>
> > > ---
> > >
> > > On an i7-7700 misaligned buffers add 2 or 3 clocks (in 115) to a 512 byte
> > >   checksum.
> > > That is just measuring the main loop with an lfence prior to rdpmc to
> > > read PERF_COUNT_HW_CPU_CYCLES.
> >
> > I'm a bit confused by this changelog.
> >
> > Are you saying that the patch causes a (small) performance regression?
> >
> > Are you also saying that the optimization here is not worth it because
> > it saves 15 lines of code?  Or that the misalignment checks themselves
> > add 2 or 3 cycles, and this is an *optimization*?
>
> I'm saying that it can't be worth optimising for a misaligned
> buffer because the cost of the buffer being misaligned is so small.
> So the test for a misaligned buffer are going to cost more than
> and plausible gain.
>
> Not only that the buffer will never be odd aligned at all.
>
> The code is left in from a previous version that did do aligned
> word reads - so had to do extra for odd alignment.
>
> Note that code is doing misaligned reads for the more likely 4n+2
> aligned ethernet receive buffers.
> I doubt that even a test for that would be worthwhile even if you
> were checksumming full sized ethernet packets.
>
> So the change is deleting code that is never actually executed
> from the hot path.
>

I think I left this code because I got confused with odd/even case,
but this is handled by upper functions like csum_block_add()

What matters is not if the start of a frag is odd/even, but what
offset it is in the overall ' frame', if a frame is split into multiple
areas (scatter/gather)

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
