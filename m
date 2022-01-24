Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA7D49766C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 01:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbiAXAYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 19:24:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53184 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiAXAYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 19:24:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69CB2B80E51;
        Mon, 24 Jan 2022 00:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440D9C340E3;
        Mon, 24 Jan 2022 00:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642983852;
        bh=P/lqko8P7xtknEbgcLI6VJ2sVk31CTsnfJpTAf51kzc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lBBXF/Gus2uXDKe22zqfrtIXigjUonbKhX2TOoaBF4bAOru3YrdFtiaLJHLPs5e93
         KiYidh5zf400FOhYUOfXvD0u187I6gN6oT3i1s/cmvoUZp8OSb2C3glzYdGpXvgjt8
         UHW/cIV8Pv+37vv1EIAFg34u+si0S8d8H+CHLVkrjPvvx0yuQNAeynDDcsIZlmJo8I
         mPPdcMSyKY/BADiWiQs/qQtpIOxKA2eu10ZWzhL7NvXnQawm43Vl/UkwCeZgVcfQD2
         eA8zMx/i2Arw0Ch+v/o3FnaFYI1WwBDj9xQZL1qWhZG7ooTKnU9+rFZi2yYShsvKBu
         1N6R/xIR7/5vQ==
Date:   Mon, 24 Jan 2022 09:24:05 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v3 0/9] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220124092405.665e9e0fc3ce14b16a1a9fcf@kernel.org>
In-Reply-To: <Ye3ptcW0eAFRYm58@krava>
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
        <CAEf4Bzbbimea3ydwafXSHFiEffYx5zAcwGNKk8Zi6QZ==Vn0Ug@mail.gmail.com>
        <20220121135510.7cfa6540e31824aa39b1c1b8@kernel.org>
        <CAEf4Bza0eTft2kjcm9HhKpAm=AuXnGwZfZ+sYpVVBvj93PBreQ@mail.gmail.com>
        <Ye3ptcW0eAFRYm58@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 00:50:13 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Fri, Jan 21, 2022 at 09:29:00AM -0800, Andrii Nakryiko wrote:
> > On Thu, Jan 20, 2022 at 8:55 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >
> > > On Thu, 20 Jan 2022 14:24:15 -0800
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > > On Wed, Jan 19, 2022 at 6:56 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > >
> > > > > Hello Jiri,
> > > > >
> > > > > Here is the 3rd version of fprobe. I added some comments and
> > > > > fixed some issues. But I still saw some problems when I add
> > > > > your selftest patches.
> > > > >
> > > > > This series introduces the fprobe, the function entry/exit probe
> > > > > with multiple probe point support. This also introduces the rethook
> > > > > for hooking function return as same as kretprobe does. This
> > > > > abstraction will help us to generalize the fgraph tracer,
> > > > > because we can just switch it from rethook in fprobe, depending
> > > > > on the kernel configuration.
> > > > >
> > > > > The patch [1/9] and [7/9] are from Jiri's series[1]. Other libbpf
> > > > > patches will not be affected by this change.
> > > > >
> > > > > [1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> > > > >
> > > > > However, when I applied all other patches on top of this series,
> > > > > I saw the "#8 bpf_cookie" test case has been stacked (maybe related
> > > > > to the bpf_cookie issue which Andrii and Jiri talked?) And when I
> > > > > remove the last selftest patch[2], the selftest stopped at "#112
> > > > > raw_tp_test_run".
> > > > >
> > > > > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#m242d2b3a3775eeb5baba322424b15901e5e78483
> > > > >
> > > > > Note that I used tools/testing/selftests/bpf/vmtest.sh to check it.
> > > > >
> > > > > This added 2 more out-of-tree patches. [8/9] is for adding wildcard
> > > > > support to the sample program, [9/9] is a testing patch for replacing
> > > > > kretprobe trampoline with rethook.
> > > > > According to this work, I noticed that using rethook in kretprobe
> > > > > needs 2 steps.
> > > > >  1. port the rethook on all architectures which supports kretprobes.
> > > > >     (some arch requires CONFIG_KPROBES for rethook)
> > > > >  2. replace kretprobe trampoline with rethook for all archs, at once.
> > > > >     This must be done by one treewide patch.
> > > > >
> > > > > Anyway, I'll do the kretprobe update in the next step as another series.
> > > > > (This testing patch is just for confirming the rethook is correctly
> > > > >  implemented.)
> > > > >
> > > > > BTW, on the x86, ftrace (with fentry) location address is same as
> > > > > symbol address. But on other archs, it will be different (e.g. arm64
> > > > > will need 2 instructions to save link-register and call ftrace, the
> > > > > 2nd instruction will be the ftrace location.)
> > > > > Does libbpf correctly handle it?
> 
> hm, I'm probably missing something, but should this be handled by arm
> specific kernel code? user passes whatever is found in kallsyms, right?

In x86, fentry nop is always placed at the first instruction of the function,
but the other arches couldn't do that if they use LR (link register) for
storing return address instead of stack. E.g. arm64 saves lr and call the
ftrace. Then ftrace location address of a function is not the symbol address.

Anyway, I updated fprobe to handle those cases. I also found some issues
on rethook, so let me update the series again.

> > > >
> > > > libbpf doesn't do anything there. The interface for kprobe is based on
> > > > function name and kernel performs name lookups internally to resolve
> > > > IP. For fentry it's similar (kernel handles IP resolution), but
> > > > instead of function name we specify BTF ID of a function type.
> > >
> > > Hmm, according to Jiri's original patch, it seems to pass an array of
> > > addresses. So I thought that has been resolved by libbpf.
> > >
> > > +                       struct {
> > > +                               __aligned_u64   addrs;
> > 
> > I think this is a pointer to an array of pointers to zero-terminated C strings
> 
> I used direct addresses, because bpftrace already has them, so there was
> no point passing strings, I cann add support for that

So now both direct address array or symbol array are OK.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
