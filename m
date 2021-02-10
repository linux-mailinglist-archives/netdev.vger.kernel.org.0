Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC9315AC4
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhBJALt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234774AbhBJADk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 19:03:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D94C164E42;
        Wed, 10 Feb 2021 00:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612915379;
        bh=/9zjf6RObGkGCMF7oOa3KfpvjKGFcmQSd9nZzvEVr00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vI+C4co13VkpKpF7c4nYz2E3SFgymNijm7IbZTeJDEywSMILm4ZGnLXXjwx2QR1F1
         Q1WC+7zQFU4UCvX7s+ZmpKgSn6SXD6biDqLFMizzNqSf15pr3QLoqBK6BssNVLnL/d
         z/VQ1GwurpMYmOJOwLun7ksWBUwkYL7VQXuw6J3cEeTFA446GiEM7bYo39hw2eE6bJ
         0AoYptCguKDFUSNmVF9oHnzxminkLFsB48TzyYSZrYtIYb17VeW3v2QybFs1+7RV9M
         8Hwk5o/a5oZuMLjxlWyD8IKJkvC3Jk0+xjF5Mo/BCdUNHgUFfhr/bgN0xvzl1LM6U9
         kJqV1HteITluw==
Date:   Tue, 9 Feb 2021 17:02:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Daniel Kiss <daniel.kiss@arm.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <20210210000257.GA1683281@ubuntu-m3-large-x86>
References: <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <YCKwxNDkS9rdr43W@krava>
 <YCLdJPPC+6QjUsR4@krava>
 <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 12:09:31PM -0800, Nick Desaulniers wrote:
> On Tue, Feb 9, 2021 at 11:06 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Feb 09, 2021 at 05:13:42PM +0100, Jiri Olsa wrote:
> > > On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> > >
> > > SNIP
> > >
> > > > > > > >                 DW_AT_prototyped        (true)
> > > > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > > > >                 DW_AT_external  (true)
> > > > > > > >
> > > > > > >
> > > > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc data.
> > > > > > > vfs_truncate's address is not recorded as ftrace-attachable, and thus
> > > > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > > > strange, given vfs_truncate is just a normal global function.
> > > > >
> > > > > right, I can't see it in mcount adresses.. but it begins with instructions
> > > > > that appears to be nops, which would suggest it's traceable
> > > > >
> > > > >   ffff80001031f430 <vfs_truncate>:
> > > > >   ffff80001031f430: 5f 24 03 d5   hint    #34
> > > > >   ffff80001031f434: 1f 20 03 d5   nop
> > > > >   ffff80001031f438: 1f 20 03 d5   nop
> > > > >   ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > > >
> > > > > > >
> > > > > > > I'd like to understand this issue before we try to fix it, but there
> > > > > > > is at least one improvement we can make: pahole should check ftrace
> > > > > > > addresses only for static functions, not the global ones (global ones
> > > > > > > should be always attachable, unless they are special, e.g., notrace
> > > > > > > and stuff). We can easily check that by looking at the corresponding
> > > > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-attachable
> > > >
> > > > I'm still trying to build the kernel.. however ;-)
> > >
> > > I finally reproduced.. however arm's not using mcount_loc
> > > but some other special section.. so it's new mess for me
> >
> > so ftrace data actualy has vfs_truncate address but with extra 4 bytes:
> >
> >         ffff80001031f434
> >
> > real vfs_truncate address:
> >
> >         ffff80001031f430 g     F .text  0000000000000168 vfs_truncate
> >
> > vfs_truncate disasm:
> >
> >         ffff80001031f430 <vfs_truncate>:
> >         ffff80001031f430: 5f 24 03 d5   hint    #34
> >         ffff80001031f434: 1f 20 03 d5   nop
> >         ffff80001031f438: 1f 20 03 d5   nop
> >         ffff80001031f43c: 3f 23 03 d5   hint    #25
> >
> > thats why we don't match it in pahole.. I checked few other functions
> > and some have the same problem and some match the function boundary
> >
> > those that match don't have that first hint instrucion, like:
> >
> >         ffff800010321e40 <do_faccessat>:
> >         ffff800010321e40: 1f 20 03 d5   nop
> >         ffff800010321e44: 1f 20 03 d5   nop
> >         ffff800010321e48: 3f 23 03 d5   hint    #25
> >
> > any hints about hint instructions? ;-)
> 
> aarch64 makes *some* newer instructions reuse the "hint" ie "nop"
> encoding space to make software backwards compatible on older hardware
> that doesn't support such instructions.  Is this BTI, perhaps? (The
> function is perhaps the destination of an indirect call?)

It seems like it. The issue is not reproducible when
CONFIG_ARM64_BTI_KERNEL is not set.

Cheers,
Nathan
