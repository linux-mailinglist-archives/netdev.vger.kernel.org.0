Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7233546B8E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfFNVJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:09:39 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38794 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfFNVJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 17:09:39 -0400
Received: by mail-lf1-f67.google.com with SMTP id b11so2631637lfa.5;
        Fri, 14 Jun 2019 14:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+qcQqKKiwG5w/oU+IdQmrJep2NZINj+7oHHR2xuPAs=;
        b=JZgmpSN5yYfkYncJcrElvwgj4OEKjnzhrx8Y+npBWHEEuKFlCyctIyLRfaU938eSkm
         ydMtdUPeeOfgQQURVMKfqK5NKTdU7LHNx1zVxE2GWcRDWX37vp7FI5rGwoLG8xJTfTDx
         LBxaxJUIE3LoGGZv72sycp+bIzdufJ0YNeriF14LBX3Jcvv1KWD8c99rc3pewjd+sta/
         ItdO9veSuvCL165PQEk67A/nFrfZQvVm/yVCR/or0MYXrg3B1JbsmUqYESQ6Tl0JvrJd
         CeffGRnQXnZAnccg16IAk4p0kQ19Q9mil9ZnsQqxy4XPWGAn/1N1/v8xaJbtOpF4zM+1
         UJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+qcQqKKiwG5w/oU+IdQmrJep2NZINj+7oHHR2xuPAs=;
        b=bNY2PgJVMhTvF3mlxEnxx1n7zaVtFom7gvuQBGRZq5GuahRbkhBdXJwMk1VN9azAac
         ClmMpOL0oack2D8treazh7zztGKFWb+cXkHMU7P+6dVOtr7lHtb4FdR2Q6iy/T1gSV3b
         cKwD6xpnQFJZXIRPdeNu0DvsnoQ9+E5xMKxwfS0tBoWtQY+bf2defC8ukS0cegRMGZ2R
         xnIOx0LaFuK8jVDq4L98mB04i6KVFeIOqBRPLNm7rTzcFV1lvqFRAtlysXd3O8eAflkn
         M5L5hKAzWqMKfH5/MtMSB/Jw2zgc0+/bbYohvT0TFy4FkpGi8RjHZxiXmYUVkm61WL3A
         ll2w==
X-Gm-Message-State: APjAAAW6ML8TawHMIjDCgTYO3cuf1lTFn0l2SZD/BI7XvnN35+iPTi0k
        9v/udD1VtBJnE/PBjI2OsZQ3nZx/+M+cRszshm0=
X-Google-Smtp-Source: APXvYqwq3u11dKxHDI2QG+IVfwb5B8nZjpa6KleNqVDZBV7nlRkSDMvzbqX2F0p7SNA9c9JGRz7K0eBuO85AA8OMvew=
X-Received: by 2002:a19:dc45:: with SMTP id f5mr19270731lfj.162.1560546576551;
 Fri, 14 Jun 2019 14:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com> <20190614210745.kwiqm5pkgabruzuj@treble>
In-Reply-To: <20190614210745.kwiqm5pkgabruzuj@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 14:09:25 -0700
Message-ID: <CAADnVQLK3ixK1JWF_mfScZoFzFF=6O8f1WcqkYqiejKeex1GSQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 2:07 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 01:58:42PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 12:56:41PM -0500, Josh Poimboeuf wrote:
> > > Objtool currently ignores ___bpf_prog_run() because it doesn't
> > > understand the jump table.  This results in the ORC unwinder not being
> > > able to unwind through non-JIT BPF code.
> > >
> > > Luckily, the BPF jump table resembles a GCC switch jump table, which
> > > objtool already knows how to read.
> > >
> > > Add generic support for reading any static local jump table array named
> > > "jump_table", and rename the BPF variable accordingly, so objtool can
> > > generate ORC data for ___bpf_prog_run().
> > >
> > > Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > > Reported-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > ---
> > >  kernel/bpf/core.c     |  5 ++---
> > >  tools/objtool/check.c | 16 ++++++++++++++--
> > >  2 files changed, 16 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index 7c473f208a10..aa546ef7dbdc 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > >  {
> > >  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> > >  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> > > -   static const void *jumptable[256] = {
> > > +   static const void *jump_table[256] = {
> > >             [0 ... 255] = &&default_label,
> > >             /* Now overwrite non-defaults ... */
> > >             BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
> > > @@ -1315,7 +1315,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > >  #define CONT_JMP ({ insn++; goto select_insn; })
> > >
> > >  select_insn:
> > > -   goto *jumptable[insn->code];
> > > +   goto *jump_table[insn->code];
> > >
> > >     /* ALU */
> > >  #define ALU(OPCODE, OP)                    \
> > > @@ -1558,7 +1558,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > >             BUG_ON(1);
> > >             return 0;
> > >  }
> > > -STACK_FRAME_NON_STANDARD(___bpf_prog_run); /* jump table */
> > >
> > >  #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
> > >  #define DEFINE_BPF_PROG_RUN(stack_size) \
> > > diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> > > index 172f99195726..8341c2fff14f 100644
> > > --- a/tools/objtool/check.c
> > > +++ b/tools/objtool/check.c
> > > @@ -18,6 +18,8 @@
> > >
> > >  #define FAKE_JUMP_OFFSET -1
> > >
> > > +#define JUMP_TABLE_SYM_PREFIX "jump_table."
> >
> > since external tool will be looking at it should it be named
> > "bpf_jump_table." to avoid potential name conflicts?
> > Or even more unique name?
> > Like "bpf_interpreter_jump_table." ?
>
> No, the point is that it's a generic feature which can also be used any
> non-BPF code which might also have a jump table.

and you're proposing to name all such jump tables in the kernel
as static foo jump_table[] ?
