Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B743A3469
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFJUCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhFJUCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:02:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DAEC613F1;
        Thu, 10 Jun 2021 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623355247;
        bh=ZbRvzCT7wna4OsitGKZ+uEppwjq/LPjh5F/SwhxsvIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=it1PG+R5MO443wIpHpOu52Wp7/yNhdoVxG8Ar5iSyJLybhL0qRCWf+X1Js86t3GNz
         9X2d4POr6Z8djOs42/VuoWMyLaM3oTyaagYIzVmMRiM7EiynqhPxtfyTZqbFMR1rvo
         fxTtwWzLdXGGd+h9Rw06HuGpDATp4XLAcGwL6Je4gcJi8HU7Kpfs3Fm6l+jXisE8il
         I5SEZkaU3f/ZVbStLDvmwkO9oufSpN5FVnVmz4VCS5oEhuC4mJyGn3NidjN3qS32Zv
         DafKhl5qLVDFD/Ly7Wl6shQjosw6s8FsamH/AE+KynX1+5FNSagLp0VOQNAsTO+ceQ
         UCtSRuWwEEtsA==
Date:   Thu, 10 Jun 2021 13:00:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>, Yonghong Song <yhs@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        nathan@kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <YMJvbGEz0xu9JU9D@gmail.com>
References: <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:52:37AM -0700, Alexei Starovoitov wrote:
> On Thu, Jun 10, 2021 at 10:06 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > > > I guess the main question: what should happen if a bpf program writer
> > > > does _not_ use compiler nor check_shl_overflow()?
> >
> > I think the BPF runtime needs to make such actions defined, instead of
> > doing a blind shift. It needs to check the size of the shift explicitly
> > when handling the shift instruction.
> 
> Such ideas were brought up in the past and rejected.
> We're not going to sacrifice performance to make behavior a bit more
> 'defined'. CPUs are doing it deterministically.

What CPUs do is not the whole story.  The compiler can assume that the shift
amount is less than the width and use that assumption in other places, resulting
in other things being miscompiled.

Couldn't you just AND the shift amounts with the width minus 1?  That would make
the shifts defined, and the compiler would optimize out the AND on any CPU that
interprets the shift amounts modulo the width anyway (e.g., x86).

- Eric
