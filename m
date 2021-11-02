Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5232F443499
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhKBRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhKBRgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:36:49 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C544EC061714;
        Tue,  2 Nov 2021 10:34:14 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j75so195075ybj.6;
        Tue, 02 Nov 2021 10:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPfpElktK4PDzmfQbw0guPM1gr47Q9xCYm+h2aTotgE=;
        b=Oip7CLUWGA+mEWHObhjbzZ6+V71aXjpU1utGTTKFDI0CLADVeo6OclplfGTUMLAxUO
         skWa0bpMEJbWm1agieSdOwYQoc8oi9WcIvzldsgS/vRd004SMlsPtJzhfeK57+5XEb09
         Y+VghKgalCnaDYAaWthPs+5A1IWg15FfCe/gfpcqU9zvkBhCBUSZpDlWJsp90jpmOpyn
         N9GM9XzsvEh74U0uEcIzQjjw8LQpffoBOff40Aj4uR92MGcttDjFuECyjJxdhCe5/kV4
         T1RkHXED5t9DjTw57XTjBWFpGqTwKjvhgsI1yWXI8+Z6evTmt+cpGCKOtJ/k6Qz20zZb
         LKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPfpElktK4PDzmfQbw0guPM1gr47Q9xCYm+h2aTotgE=;
        b=J/4Wb+6A8WsqUnB73DnpCQ9UGTprs3h8JtOEEpEeWIY4tD4F8e/QFy17TZuYbRqE69
         +c6bNgYjQAfGl0zNylSlkhhZUtVjHVmm6SaU/GK3Yj7wMcFyTjXXav5fhYYJrExvUtp2
         TDvnPkruzUyEXx4g4c/zN4bl7B8sZrK3T06OrG6PYdVSlkPuPm2enJTvv+WjPsAHAUs4
         TbV2S5uSZ9elfRAXqdQHBW553bjvGpqhkzME/10hQyxgz/luw8OEygtRGTo4EJdV/BNf
         ZsuPb8wmd5+M6d2fhS/sy9HbHDo09p1uwFzjelBzEOSea8pZkLCruOxbYh7FP3q2mQSI
         cuZw==
X-Gm-Message-State: AOAM530weF5axoeiKvdCPcmZC1O2KK5XRHZ8ZRT+E0Aehk/p3TQSd5Wl
        5r8PQ/Dz/jtzdcw6FtH/w4/noZ79PCnGhHPJgws=
X-Google-Smtp-Source: ABdhPJxX3wRsVxrnCbgfi9tBRt2o7a6DVZSd12hAMFaUpaW6KNsIDN5StMptEsoEibW0p31BVn5qkl8dY8BMq/kjoWQ=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr38201554ybj.433.1635874453820;
 Tue, 02 Nov 2021 10:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
 <1635142354.46h6w5c2rx.naveen@linux.ibm.com> <c8d7390b-c07c-75cd-e9e9-4b8f0b786cc6@iogearbox.net>
 <87zgqs8upq.fsf@mpe.ellerman.id.au> <1635854227.x13v13l6az.naveen@linux.ibm.com>
 <87h7cu8y98.fsf@mpe.ellerman.id.au>
In-Reply-To: <87h7cu8y98.fsf@mpe.ellerman.id.au>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Nov 2021 10:34:02 -0700
Message-ID: <CAEf4BzYvPgdyJ+jwHPke1NmVkjUUBA7-qT8VrgwXS3zZCxEQMw@mail.gmail.com>
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hari Bathini <hbathini@linux.ibm.com>, jniethe5@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Networking <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Song Liu <songliubraving@fb.com>,
        linux- stable <stable@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 6:48 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> "Naveen N. Rao" <naveen.n.rao@linux.ibm.com> writes:
> > Michael Ellerman wrote:
> >> Daniel Borkmann <daniel@iogearbox.net> writes:
> >>> On 10/25/21 8:15 AM, Naveen N. Rao wrote:
> >>>> Hari Bathini wrote:
> >>>>> Running program with bpf-to-bpf function calls results in data access
> >>>>> exception (0x300) with the below call trace:
> >>>>>
> >>>>>     [c000000000113f28] bpf_int_jit_compile+0x238/0x750 (unreliable)
> >>>>>     [c00000000037d2f8] bpf_check+0x2008/0x2710
> >>>>>     [c000000000360050] bpf_prog_load+0xb00/0x13a0
> >>>>>     [c000000000361d94] __sys_bpf+0x6f4/0x27c0
> >>>>>     [c000000000363f0c] sys_bpf+0x2c/0x40
> >>>>>     [c000000000032434] system_call_exception+0x164/0x330
> >>>>>     [c00000000000c1e8] system_call_vectored_common+0xe8/0x278
> >>>>>
> >>>>> as bpf_int_jit_compile() tries writing to write protected JIT code
> >>>>> location during the extra pass.
> >>>>>
> >>>>> Fix it by holding off write protection of JIT code until the extra
> >>>>> pass, where branch target addresses fixup happens.
> >>>>>
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
> >>>>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> >>>>> ---
> >>>>>  arch/powerpc/net/bpf_jit_comp.c | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> Thanks for the fix!
> >>>>
> >>>> Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> >>>
> >>> LGTM, I presume this fix will be routed via Michael.
> >>
> >> Thanks for reviewing, I've picked it up.
> >>
> >>> BPF selftests have plenty of BPF-to-BPF calls in there, too bad this was
> >>> caught so late. :/
> >>
> >> Yeah :/
> >>
> >> STRICT_KERNEL_RWX is not on by default in all our defconfigs, so that's
> >> probably why no one caught it.
> >
> > Yeah, sorry - we should have caught this sooner.
> >
> >>
> >> I used to run the BPF selftests but they stopped building for me a while
> >> back, I'll see if I can get them going again.
> >
> > Ravi had started looking into getting the selftests working well before
> > he left. I will take a look at this.
>
> Thanks.
>
> I got them building with something like:
>
>  - turning on DEBUG_INFO and DEBUG_INFO_BTF and rebuilding vmlinux
>  - grabbing clang 13 from:
>    https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang+llvm-13.0.0-powerpc64le-linux-ubuntu-18.04.tar.xz
>  - PATH=$HOME/clang+llvm-13.0.0-powerpc64le-linux-ubuntu-18.04/bin/:$PATH
>  - apt install:
>    - libelf-dev
>    - dwarves
>    - python-docutils
>    - libcap-dev
>
>
> The DEBUG_INFO requirement is a bit of a pain for me. I generally don't

We do need DWARF to be present during BTF generation. We don't really
need to preserve DWARF after BTF is generated, though. But no one
added that config option and corresponding optimization. If you can
figure out how to do that, I'm sure a bunch of folks will appreciate
being able to specify CONFIG_DEBUG_INFO_BTF without CONFIG_DEBUG_INFO
dependency.


> build with that enabled, because the resulting kernels are stupidly
> large. I'm not sure if that's a hard requirement, or if the vmlinux has
> to match the running kernel exactly?
>
> There is logic in tools/testing/bpf/Makefile to use VMLINUX_H instead of
> extracting the BTF from the vmlinux (line 247), but AFAICS that's
> unreachable since 1a3449c19407 ("selftests/bpf: Clarify build error if
> no vmlinux"), which makes it a hard error to not have a VMLINUX_BTF.

Yeah, you can pass pre-generated vmlinux.h through VMLINUX_H, which we
do for libbpf CI (see [0]) when running latest selftests against old
kernels (we test 4.9 and 5.5 currently). Latest vmlinux image (which
you can override with VMLINUX_BTF) is required for custom kernel
module which we use during selftests. But if you don't provide the
matching kernel, everything should still build fine, the test module
won't load properly and we'll skip a few tests. You still should get a
good coverage.

So in short, given we are able to build selftests and run it against
4.9 and 5.5, you should be able to as well.

  [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/build_selftests.sh#L29-L30

>
> cheers
