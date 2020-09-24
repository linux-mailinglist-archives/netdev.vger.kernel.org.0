Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6A277B6A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgIXWAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:00:08 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69B1C0613CE;
        Thu, 24 Sep 2020 15:00:08 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id k2so535587ybp.7;
        Thu, 24 Sep 2020 15:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pKYk9NKtuWMtgoXxhp4Rv9//Tr5ksbU6b88USgZUqZA=;
        b=ElF6EmKm+sBw1Zq7QOkisAZS+FD/zmxYXJH3IEHyW+cIIQYzl+x2drtcSD6iy9vR7v
         CZTUzgn6nTEDMQIulhWUV8EY8eIcvckRPUWQvPwdq4APndQ58jz5DV6GNtHwmlJZOsYf
         wk8GOg27DQFAbPSHJ7PnRyFGAkAwTDORNZaxcCsXQ/SblGZUWg1oRpUFrsUg8XMsHjxd
         U2OBNR9fpjLaKZJhCzO8UaXFXi8tA3f8lNyJRbXWqWguFzFZWIv+GIGtxMuIVsAIdli/
         yi6T5mii75qFTVS+HENWtXFWLO7eM0uTl5O69KGDv1tUDmXPsvhhMdV2y8VZXw3KA4iJ
         NbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pKYk9NKtuWMtgoXxhp4Rv9//Tr5ksbU6b88USgZUqZA=;
        b=CTlWOmZYfGa4u8sk5BwPOVBNCw9THTqdanwki6eD4pjr6U8CEIlNk2Tuq1Kd3tZ2kI
         UTyC1iwrqy6wPaubjEPxBR/UaIKmmgBC78pgqeNkQr1IWNCPMOccQqT+G4JdzRHARXGr
         x2NcYxf1w/e5zdVZnyoCNsNYWdXt3OzcdI0sdzX36zVkgJWFBXwTulMl4Y33vj54kzAB
         N65lZmgAFD0Z6/1udu98filTcT33xHtNdb2D2vW5N5U+NhEmIaTJ4+HBQ9E6BlWCfcyU
         tcFaPwV1wfMRp66XghmrM8kOwejmJ8sFeniH9np4814bh7OHEeamUduIjt5Ons+4pWsN
         9/cw==
X-Gm-Message-State: AOAM531p2VKRelQLGrGqZs2jaTpsa99+qESYuA7SwvVBbfxhFDMhFwW1
        ZnhxTh6k5HcnoLUFAOgUkgHrzYOdrZ9Mcfvc4sg=
X-Google-Smtp-Source: ABdhPJwXnB4g/1VZO6nQgueJGiooiM8/njarbbb9+sl5G8UIOigfiNIOrlHnJpEywMIAIN5tE6nUzwGas46S7/IIkQM=
X-Received: by 2002:a25:4446:: with SMTP id r67mr1234096yba.459.1600984807951;
 Thu, 24 Sep 2020 15:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk> <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <874knn1bw4.fsf@toke.dk> <CAEf4BzaBvvZdgekg13T3e4uj5Q9Rf1RTFP__ZPsU-NMp2fVXxw@mail.gmail.com>
 <87zh5ec1gs.fsf@toke.dk>
In-Reply-To: <87zh5ec1gs.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 14:59:57 -0700
Message-ID: <CAEf4BzZxfzQabDCdmby1XMQV7qQ_C=rATWOb=cN-Q1rfxR+nVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 2:24 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Sep 24, 2020 at 7:36 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Tue, Sep 22, 2020 at 08:38:38PM +0200, Toke H=C3=83=C6=92=C3=82=
=C2=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
> >> >> @@ -746,7 +748,9 @@ struct bpf_prog_aux {
> >> >>      u32 max_rdonly_access;
> >> >>      u32 max_rdwr_access;
> >> >>      const struct bpf_ctx_arg_aux *ctx_arg_info;
> >> >> -    struct bpf_prog *linked_prog;
> >> >
> >> > This change breaks bpf_preload and selftests test_bpffs.
> >> > There is really no excuse not to run the selftests.
> >>
> >> I did run the tests, and saw no more breakages after applying my patch=
es
> >> than before. Which didn't catch this, because this is the current stat=
e
> >> of bpf-next selftests:
> >>
> >> # ./test_progs  | grep FAIL
> >> test_lookup_update:FAIL:map1_leak inner_map1 leaked!
> >> #10/1 lookup_update:FAIL
> >> #10 btf_map_in_map:FAIL
> >
> > this failure suggests you are not running the latest kernel, btw
>
> I did see that discussion (about the reverted patch), and figured that
> was the case. So I did a 'git pull' just before testing, and still got
> this.
>
> $ git describe HEAD
> v5.9-rc3-2681-g182bf3f3ddb6
>
> so any other ideas? :)

That memory leak was fixed in 1d4e1eab456e ("bpf: Fix map leak in
HASH_OF_MAPS map") at the end of July. So while your git repo might be
checked out on a recent enough commit, could it be that the kernel
that you are running is not what you think you are running?

I specifically built kernel from the same commit and double-checked:

[vmuser@archvm bpf]$ uname -r
5.9.0-rc6-01779-g182bf3f3ddb6
[vmuser@archvm bpf]$ sudo ./test_progs -t map_in_map
#10/1 lookup_update:OK
#10/2 diff_size:OK
#10 btf_map_in_map:OK
Summary: 1/2 PASSED, 0 SKIPPED, 0 FAILED

>
> >> configure_stack:FAIL:BPF load failed; run with -vv for more info
> >> #72 sk_assign:FAIL
>
> (and what about this one, now that I'm asking?)

Did you run with -vv? Jakub Sitnicki (cc'd) might probably help, if
you provide a bit more details.

>
> >> test_test_bpffs:FAIL:bpffs test  failed 255
> >> #96 test_bpffs:FAIL
> >> Summary: 113/844 PASSED, 14 SKIPPED, 4 FAILED
> >>
> >> The test_bpffs failure happens because the umh is missing from the
> >> .config; and when I tried to fix this I ended up with:
> >
> > yeah, seems like selftests/bpf/config needs to be updated to mention
> > UMH-related config values:
> >
> > CONFIG_BPF_PRELOAD=3Dy
> > CONFIG_BPF_PRELOAD_UMD=3Dm|y
> >
> > with that test_bpffs shouldn't fail on master
>
> Yup, did get that far, and got the below...
>
> >>
> >> [..]
> >>   CC [M]  kernel/bpf/preload/bpf_preload_kern.o
> >>
> >> Auto-detecting system features:
> >> ...                        libelf: [ OFF ]
> >> ...                          zlib: [ OFF ]
> >> ...                           bpf: [ OFF ]
> >>
> >> No libelf found
> >
> > might be worthwhile to look into why detection fails, might be
> > something with Makefiles or your environment
>
> I think it's actually another instance of the bug I fixed with this
> commit:
>
> 1eb832ac2dee ("tools/bpf: build: Make sure resolve_btfids cleans up after=
 itself")
>
> which I finally remembered after being tickled by the error message
> seeming familiar. And indeed, manually removing the 'feature' directory
> in kernel/bpf/preload seems to fix the issue, so I'm planning to go fix
> that Makefile as well...
>

glad we got to the bottom of it

> >> ...which I just put down to random breakage, turned off the umh and
> >> continued on my way (ignoring the failed test). Until you wrote this I
> >> did not suspect this would be something I needed to pay attention to.
> >> Now that you did mention it, I'll obviously go investigate some more, =
my
> >> point is just that in this instance it's not accurate to assume I just
> >> didn't run the tests... :)
> >
> > Don't just assume some tests are always broken. Either ask or
> > investigate on your own. Such cases do happen from time to time while
> > we wait for a fix in bpf to get merged into bpf-next or vice versa,
> > but it's rare. We now have two different CI systems running selftests
> > all the time, in addition to running them locally as well, so any
> > permanent test failure is very apparent and annoying, so we fix them
> > quickly. So, when in doubt - ask or fix.
>
> That's good to know; and I do think the situation has improved
> immensely. There was a time when the selftests broke every other week
> (or so it felt, at least), and I guess I'm still a bit scarred from
> that.
>
> One thing that would be really useful would be to have a 'reference
> config' or something like that. Missing config options are a common
> reason for test failures (as we have just seen above), and it's not
> always obvious which option is missing for each test. Even something
> like grepping .config for BPF doesn't catch everything. If you already
> have a CI running, just pointing to that config would be a good start
> (especially if it has history). In an ideal world I think it would be
> great if each test could detect whether the kernel has the right config
> set for its features and abort with a clear error message if it isn't...

so tools/testing/selftests/bpf/config is intended to list all the
config values necessary, but given we don't update them often we
forget to update them when selftests requiring extra kernel config are
added, unfortunately.

As for CI's config, check [0], that's what we use to build kernels.
Kernel config is intentionally pretty minimal and is running in a
single-user mode in pretty stripped down environment, so might not
work as is for full-blown VM. But you can still take a look.

  [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/configs=
/latest.config

>
> >> > I think I will just start marking patches as changes-requested when =
I see that
> >> > they break tests without replying and without reviewing.
> >> > Please respect reviewer's time.
> >>
> >> That is completely fine if the tests are working in the first place. A=
nd
> >
> > They are and hopefully moving forward that would be your assumption.
>
> Sure, with the exception of the two tests still failing that I mentioned
> above. Which I'm hoping you can help figure out the reason for :)
>
> -Toke
>
