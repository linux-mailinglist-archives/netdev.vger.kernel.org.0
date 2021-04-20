Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C108365D68
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhDTQeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhDTQeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:34:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C6660FEA;
        Tue, 20 Apr 2021 16:33:39 +0000 (UTC)
Date:   Tue, 20 Apr 2021 12:33:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210420123338.0cfbb29f@gandalf.local.home>
In-Reply-To: <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
        <20210415170007.31420132@gandalf.local.home>
        <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
        <20210416124834.05862233@gandalf.local.home>
        <YH7OXrjBIqvEZbsc@krava>
        <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 08:33:43 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:


> I don't see how you can do it without BTF.

I agree. 

> The mass-attach feature should prepare generic 6 or so arguments
> from all functions it attached to.
> On x86-64 it's trivial because 6 regs are the same.
> On arm64 is now more challenging since return value regs overlaps with
> first argument, so bpf trampoline (when it's ready for arm64) will look
> a bit different than bpf trampoline on x86-64 to preserve arg0, arg1,
> ..arg6, ret
> 64-bit values that bpf prog expects to see.
> On x86-32 it's even more trickier, since the same 6 args need to be copied
> from a combination of regs and stack.
> This is not some hypothetical case. We already use BTF in x86-32 JIT
> and btf_func_model was introduced specifically to handle such cases.
> So I really don't see how ftrace can do that just yet. It has to understand BTF

ftrace doesn't need to understand BTF, but the call back does. Ftrace will
give the callback all the information it needs to get the arguments from
the regs that hold the arguments and a pointer to the stack.

It's a limited set of regs that produce the arguments. ftrace only needs to
supply it. How those regs are converted to arguments requires more
understanding of those arguments, which BTF can give you.


> of all of the funcs it attaches to otherwise it's just saving all regs.
> That approach was a pain to deal with.
> Just look at bpf code samples with ugly per architecture macros to access regs.
> BPF trampoline solved it and I don't think going back to per-arch macros
> is an option at this point.

How does it solve it besides a one to one mapped trampoline to function?
Once you attach more than one function to the trampoline, it needs BTF to
translate it, and you need to save enough regs to have access to the args
that are needed.

For a direct call, which attaches to only one function, you could do short
cuts. If the function you hook to, only has one argument, you may be able
to safely call the callback code and only save that one argument. But as
soon as you want to attach to more than one function to the same
trampoline, you will need to save the regs of the args with the most
arguments.

What ftrace can give you is what I have called "ftrace_regs", which is
really just pt_regs with only the arguments saved. This is much less than
the ftrace_regs_caller that is used by kprobes. Because kprobes expects to
be called by an int3. ftrace_regs_caller() is much faster than an int3, but
still needs to save all regs that an interrupt would save (including
flags!) and makes it slower than a normal ftrace_caller() (and why I
created the two). But the ftrace_caller() saves only the regs needed to
create arguments (as ftrace must handle all functions and all their args,
so that the callback does not corrupt them).

For x86_64, this is rdi, rsi, rdx, rcx, r8, r9. That's all that is saved.
And this is passed to the callback as well as the stack pointer. With this
information, you could get any arguments of any function on x86_64. And it
is trivial to do the same for other architectures.

For every function attached to ftrace, you would have a BPF program created
from the BTF of the function prototype to parse the arguments. The
ftrace_regs holds only the information needed to retrieve those arguments,
Have a hash that maps the traced function with its bpf program and then
simply execute that, feeding it the ftrace_regs. Then the bpf program could
parse out the arguments.

That is, you could have BPF hook to the ftrace callback (and it lets you
hook to a subset of functions), have a hash table that maps the function to
the BTF prototype of that function. Then you can have a generic BPF program
look up the BTF prototype of the function it is passed (via the hash), and
then retrieve the arguments.

The ftrace_regs could also be stored on the shadow stack to parse on the
return exit entry too (as Jiri wants to do).

Yes, the BPF trampoline is fine for a 1 to 1 mapping of a function to its
bpf program, but once you want to attach more than 1 function to a
trampoline, you'll need a way to parse its arguments for each function that
the trampoline is attached to. The difference is, you'll need a lookup table
to find the BTF of the function that is called.

I think this is doable.

-- Steve
