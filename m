Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9DC046B8B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfFNVHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNVHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 17:07:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2982359441;
        Fri, 14 Jun 2019 21:07:54 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B3CA5C29A;
        Fri, 14 Jun 2019 21:07:52 +0000 (UTC)
Date:   Fri, 14 Jun 2019 16:07:45 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Message-ID: <20190614210745.kwiqm5pkgabruzuj@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 14 Jun 2019 21:07:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 01:58:42PM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 12:56:41PM -0500, Josh Poimboeuf wrote:
> > Objtool currently ignores ___bpf_prog_run() because it doesn't
> > understand the jump table.  This results in the ORC unwinder not being
> > able to unwind through non-JIT BPF code.
> > 
> > Luckily, the BPF jump table resembles a GCC switch jump table, which
> > objtool already knows how to read.
> > 
> > Add generic support for reading any static local jump table array named
> > "jump_table", and rename the BPF variable accordingly, so objtool can
> > generate ORC data for ___bpf_prog_run().
> > 
> > Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > Reported-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  kernel/bpf/core.c     |  5 ++---
> >  tools/objtool/check.c | 16 ++++++++++++++--
> >  2 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 7c473f208a10..aa546ef7dbdc 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> >  {
> >  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> >  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> > -	static const void *jumptable[256] = {
> > +	static const void *jump_table[256] = {
> >  		[0 ... 255] = &&default_label,
> >  		/* Now overwrite non-defaults ... */
> >  		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
> > @@ -1315,7 +1315,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> >  #define CONT_JMP ({ insn++; goto select_insn; })
> >  
> >  select_insn:
> > -	goto *jumptable[insn->code];
> > +	goto *jump_table[insn->code];
> >  
> >  	/* ALU */
> >  #define ALU(OPCODE, OP)			\
> > @@ -1558,7 +1558,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> >  		BUG_ON(1);
> >  		return 0;
> >  }
> > -STACK_FRAME_NON_STANDARD(___bpf_prog_run); /* jump table */
> >  
> >  #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
> >  #define DEFINE_BPF_PROG_RUN(stack_size) \
> > diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> > index 172f99195726..8341c2fff14f 100644
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -18,6 +18,8 @@
> >  
> >  #define FAKE_JUMP_OFFSET -1
> >  
> > +#define JUMP_TABLE_SYM_PREFIX "jump_table."
> 
> since external tool will be looking at it should it be named 
> "bpf_jump_table." to avoid potential name conflicts?
> Or even more unique name?
> Like "bpf_interpreter_jump_table." ?

No, the point is that it's a generic feature which can also be used any
non-BPF code which might also have a jump table.

-- 
Josh
