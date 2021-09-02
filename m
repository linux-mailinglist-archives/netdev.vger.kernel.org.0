Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB803FE6C2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhIBAyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhIBAyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:54:03 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE64C061575;
        Wed,  1 Sep 2021 17:53:05 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e133so575145ybh.0;
        Wed, 01 Sep 2021 17:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ayvaPcH4PeKRgsTyQAb7B44ose8e+hCAQVDtMMshj1c=;
        b=aKp0EVSD/3Wtm5nG6cJmiWxRrTAH1ZjeGxTJCfi/kfCyNiMzIhfcMvN/SeR6kC4XZl
         34V/OvEFtwo9aJv6ArOIB3oz/2hYmAzxHWrCrJYXGRdE8N8s4QFJqCWcoE4JU3f21cOF
         ACNJAxIyT5Tz9CInE1WcX4ovVacfVZtieshiBL+zcKyxMXc1PuGVC6TDDJRLO7rJwxZH
         2hukrbKsZNyNRdFKPIJsGeazdxOa88NzHHkiE5axgecCDHZY6E5w7/n8yxwAKlqoeA7x
         QGyAu1SmOBJT/3eRw65RMaF6gigkFnickeMxetASQ2SiDOovKaoBo/Cm33rDN1Qpfd64
         NLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ayvaPcH4PeKRgsTyQAb7B44ose8e+hCAQVDtMMshj1c=;
        b=kvF4K1XnTScsXCnHTde4bB+e1raeP7TM1wc+d87xZL6vnxZfhZ/bndGNxBGIsP16ET
         Twe+szuVAfkU0W7lllcTcKWimm0R5QRnTwurJzM1SciF2c8dMi66ttzif+nhf3vgm4g5
         0m+iSj8jGD3AXo3/1ty74W9R25tukIYAdNCW5nfxde/9OF9AxeSABk0eKtpAyRViwMKC
         /sCFdNn4uaHDq/34JKR4mTdgSXS1rvNw47CjHSs1zyZBy91uQE8OF4Gf9BhMWDHQNaCX
         3PqRqrD24DtRjObWEKz9pQxAhiNQt/AxxzaFbEbrJ8J9qogYp8Lh5NQ0/3gU84lMaigB
         FbiA==
X-Gm-Message-State: AOAM530rySfeD4n22bK+RYj09fJkEFy4kJrqPvRrIccNKAcrmGybA6Tt
        GADV5VnkpYbOh3jOeYmenRT4Ut8FGUwKKrZy/tE=
X-Google-Smtp-Source: ABdhPJztdGAJRd4iX0setcCzorAm22re+j5ywoKLRLbkMzeJPvS4C2lR17Uyyr85G4WXYZqlWTSKfxRDQS92JmsntGM=
X-Received: by 2002:a25:bdc5:: with SMTP id g5mr861952ybk.403.1630543985128;
 Wed, 01 Sep 2021 17:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210825195823.381016-1-davemarchevsky@fb.com>
 <20210825195823.381016-4-davemarchevsky@fb.com> <CAEf4BzaNH1vRQr5jZO_m3haUaV5rXKiH5AJLFrM5iwbkEja=VQ@mail.gmail.com>
 <f4bd93de-14e1-855d-eb31-1de4697ce7d7@fb.com>
In-Reply-To: <f4bd93de-14e1-855d-eb31-1de4697ce7d7@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Sep 2021 17:52:53 -0700
Message-ID: <CAEf4BzbVuHzZGQLO9F7jYj1ewdjixiza=CWnthPL9MQzAHByeA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/6] libbpf: Modify bpf_printk to choose
 helper based on arg count
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 4:29 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> On 8/30/21 7:55 PM, Andrii Nakryiko wrote:
> > On Wed, Aug 25, 2021 at 12:58 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> >>
> >> Instead of being a thin wrapper which calls into bpf_trace_printk,
> >> libbpf's bpf_printk convenience macro now chooses between
> >> bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
> >> format string) is >3, use bpf_trace_vprintk, otherwise use the older
> >> helper.
> >>
> >> The motivation behind this added complexity - instead of migrating
> >> entirely to bpf_trace_vprintk - is to maintain good developer experience
> >> for users compiling against new libbpf but running on older kernels.
> >> Users who are passing <=3 args to bpf_printk will see no change in their
> >> bytecode.
> >>
> >> __bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
> >> macros elsewhere in the file - it allows use of bpf_trace_vprintk
> >> without manual conversion of varargs to u64 array. Previous
> >> implementation of bpf_printk macro is moved to __bpf_printk for use by
> >> the new implementation.
> >>
> >> This does change behavior of bpf_printk calls with >3 args in the "new
> >> libbpf, old kernels" scenario. On my system, using a clang built from
> >> recent upstream sources (14.0.0 https://github.com/llvm/llvm-project.git
> >> 50b62731452cb83979bbf3c06e828d26a4698dca), attempting to use 4 args to
> >> __bpf_printk (old impl) results in a compile-time error:
> >>
> >>   progs/trace_printk.c:21:21: error: too many args to 0x6cdf4b8: i64 = Constant<6>
> >>         trace_printk_ret = __bpf_printk("testing,testing %d %d %d %d\n",
> >>
> >> I was able to replicate this behavior with an older clang as well. When
> >> the format string has >3 format specifiers, there is no output to the
> >> trace_pipe in either case.
> >>
> >> After this patch, using bpf_printk with 4 args would result in a
> >> trace_vprintk helper call being emitted and a load-time failure on older
> >> kernels.
> >>
> >> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> >> ---
> >>  tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
> >>  1 file changed, 37 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> >> index b9987c3efa3c..5f087306cdfe 100644
> >> --- a/tools/lib/bpf/bpf_helpers.h
> >> +++ b/tools/lib/bpf/bpf_helpers.h
> >> @@ -14,14 +14,6 @@
> >>  #define __type(name, val) typeof(val) *name
> >>  #define __array(name, val) typeof(val) *name[]
> >>
> >> -/* Helper macro to print out debug messages */
> >> -#define bpf_printk(fmt, ...)                           \
> >> -({                                                     \
> >> -       char ____fmt[] = fmt;                           \
> >> -       bpf_trace_printk(____fmt, sizeof(____fmt),      \
> >> -                        ##__VA_ARGS__);                \
> >> -})
> >> -
> >>  /*
> >>   * Helper macro to place programs, maps, license in
> >>   * different sections in elf_bpf file. Section names
> >> @@ -224,4 +216,41 @@ enum libbpf_tristate {
> >>                      ___param, sizeof(___param));               \
> >>  })
> >>
> >> +/* Helper macro to print out debug messages */
> >> +#define __bpf_printk(fmt, ...)                         \
> >> +({                                                     \
> >> +       char ____fmt[] = fmt;                           \
> >> +       bpf_trace_printk(____fmt, sizeof(____fmt),      \
> >> +                        ##__VA_ARGS__);                \
> >> +})
> >> +
> >> +/*
> >> + * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic arguments
> >> + * instead of an array of u64.
> >> + */
> >> +#define __bpf_vprintk(fmt, args...)                            \
> >> +({                                                             \
> >> +       static const char ___fmt[] = fmt;                       \
> >> +       unsigned long long ___param[___bpf_narg(args)];         \
> >> +                                                               \
> >> +       _Pragma("GCC diagnostic push")                          \
> >> +       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
> >> +       ___bpf_fill(___param, args);                            \
> >> +       _Pragma("GCC diagnostic pop")                           \
> >> +                                                               \
> >> +       bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
> >> +                    ___param, sizeof(___param));               \
> >
> > nit: is this really misaligned or it's just Gmail's rendering?
>
> It's misaligned, will fix. As is __bpf_pick_printk below.
>
> >> +})
> >> +
> >> +#define ___bpf_pick_printk(...) \
> >> +       ___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,       \
> >> +               __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,             \
> >> +               __bpf_vprintk, __bpf_vprintk, __bpf_printk, __bpf_printk,               \
> >> +               __bpf_printk, __bpf_printk)
> >
> > There is no best solution with macros, but I think this one is
> > extremely error prone because __bpf_nth invocation is very long and
> > it's hard to even see where printk turns into vprintk.
> >
> > How about doing it similarly to ___empty in bpf_core_read.h? It will
> > be something like this (untested and not even compiled, just a demo)
> >
> > #define __bpf_printk_kind(...) ___bpf_nth(_, ##__VA_ARGS__, new, new,
> > new, new, new, <however many>, new, old /*3*/, old /*2*/, old /*1*/,
> > old /*0*/)
> >
> > #define bpf_printk(fmt, args...) ___bpf_apply(___bpf_printk_,
> > ___bpf_narg(args))(fmt, args)
> >
> >
> > And you'll have s/__bpf_printk/__bpf_printk_old/ (using
> > bpf_trace_printk) and s/__bpf_printk_new/__bpf_vprintk/ (using
> > bpf_trace_vprintk).
> >
> > This new/old distinction makes it a bit clearer to me. I find
> > __bpf_nth so counterintuitive that I try not to use it directly
> > anywhere at all.
>
> When you're saying 'error prone' here, do you mean something like
> 'hard to understand and modify'? Asking because IMO adding
> ___bpf_apply here makes it harder to understand. Having the full
> helper macros in ___bpf_nth makes it obvious that they're being used
> somehow.

Hm... I disagree on ___bpf_nth being easier, because of both *reverse*
and *positional* notation. But whichever you prefer, not a big deal.
In this particular case it takes lots of attention to even see at
which position __bpf_vprintk switches to __bpf_printk. They are too
similar and not both verbose and not distinctive enough, IMO.

bpf_apply feels more natural, but I'm the one who wrote a bunch of
bpf_core_read.h macro using that approach, so I'm totally biased.
(Though I wrote and used bpf__nth as well, yet I still hate it, but
it's just a necessary evil).

>
> But I feel more strongly that these should not be renamed to __bpf_printk_{old,new}.
> Although this is admittedly an edge case, I'd like to leave an 'escape
> hatch' for power users who might not want bpf_printk to change the
> helper call underneath them - they could use the __bpf_{v}printk
> macros directly. Of course they could do the same with _{old,new},
> but the rename obscures the name of the underlying helper called,
> which is the very thing the hypothetical power user cares about in
> this scenario.

Any of the __ prefixed macro should not be used by anyone and are not
considered part of the API. We can rename, remove, break them at any
time. So regardless of the above, one should not use __bpf_vprintk or
__bpf_vprintk directly in their BPF apps.

>
> One concrete example of such a user: someone who keeps up with
> latest bpf developments but needs to run their programs on a fleet
> which has some % of older kernels. Using __bpf_printk directly to
> force a compile error for >3 fmt args instead of being bitten at
> load time would be desireable.

it's not hard for such users to just copy/paste (and actually have
cleaner name). __bpf_printk() is not a hard macro that needs to be
reused by end users.

>
> Also, 'new' name leaves open possibility that something newer comes
> along in the future and turns 'new' into 'old', which feels churny.
> Although if these are never used directly it doesn't matter.

Right, internal implementation details, as far as end users are concerned.

>
> I agree with 'it's hard to even see where printk turns into vprintk'
> and like your comment idea. If you're fine with keeping names as-is,
> will still add /*3*/ /*2*/... and perhaps a /*BOUNDARY*/ marking the
> switch from vprintk to printk.

BOUNDARY is probably an overkill. Positional comments might be nice, try it.

>
> >
> >> +
> >> +#define bpf_printk(fmt, args...)               \
> >> +({                                             \
> >> +       ___bpf_pick_printk(args)(fmt, args);    \
> >> +})
> >
> > not sure ({ }) buys you anything?...
>
> Agreed, will fix.
>
> >> +
> >>  #endif
> >> --
> >> 2.30.2
> >>
>
