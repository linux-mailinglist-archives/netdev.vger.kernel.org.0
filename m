Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DBD48641
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbfFQO5c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jun 2019 10:57:32 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:32197 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbfFQO5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:57:31 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-190-hVB7mw-INdG5k3bducDmrQ-1; Mon, 17 Jun 2019 15:57:27 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 17 Jun 2019 15:57:26 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 17 Jun 2019 15:57:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        "Kairui Song" <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Thread-Topic: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Thread-Index: AQHVIvP1MMjmbNr75kSp44+RDLqGVaaf832A
Date:   Mon, 17 Jun 2019 14:57:26 +0000
Message-ID: <28948180f13343b3b7b1f58878cebe3e@AcuMS.aculab.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: hVB7mw-INdG5k3bducDmrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov
> Sent: 14 June 2019 21:59
> 
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

If external code might need to process such symbols then
jump_table_bpf_interpreter would (probably) make the symbols
easier to locate.

Oh, and blue is a good colour :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

