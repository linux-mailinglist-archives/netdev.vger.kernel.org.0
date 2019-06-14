Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0C745155
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfFNBve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfFNBve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 21:51:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B19210C94;
        Fri, 14 Jun 2019 01:51:34 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B16860FBD;
        Fri, 14 Jun 2019 01:51:33 +0000 (UTC)
Date:   Thu, 13 Jun 2019 20:51:31 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated
 code
Message-ID: <20190614015131.wmw63qwzjyzack7f@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble>
 <20190614013719.eqwpqfxukh6nhgec@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614013719.eqwpqfxukh6nhgec@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 14 Jun 2019 01:51:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 06:37:21PM -0700, Alexei Starovoitov wrote:
> On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> > On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Jun 13, 2019 at 08:20:59AM -0500, Josh Poimboeuf wrote:
> > > > Objtool currently ignores ___bpf_prog_run() because it doesn't
> > > > understand the jump table.  This results in the ORC unwinder not being
> > > > able to unwind through non-JIT BPF code.
> > > > 
> > > > Luckily, the BPF jump table resembles a GCC switch jump table, which
> > > > objtool already knows how to read.
> > > > 
> > > > Add generic support for reading any static local jump table array named
> > > > "jump_table", and rename the BPF variable accordingly, so objtool can
> > > > generate ORC data for ___bpf_prog_run().
> > > > 
> > > > Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > > > Reported-by: Song Liu <songliubraving@fb.com>
> > > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > ---
> > > >  kernel/bpf/core.c     |  5 ++---
> > > >  tools/objtool/check.c | 16 ++++++++++++++--
> > > >  2 files changed, 16 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > > index 7c473f208a10..aa546ef7dbdc 100644
> > > > --- a/kernel/bpf/core.c
> > > > +++ b/kernel/bpf/core.c
> > > > @@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > > >  {
> > > >  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> > > >  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> > > > -	static const void *jumptable[256] = {
> > > > +	static const void *jump_table[256] = {
> > > 
> > > Nack to the change like above
> > 
> > "jump table" is two words, so does it not make sense to separate them
> > with an underscore for readability?
> > 
> > I created a generic feature in objtool for this so that other code can
> > also use it.  So a generic name (and typical Linux naming convention --
> > separating words with an underscore) makes sense here.
> > 
> > > and to patches 8 and 9.
> > 
> > Well, it's your code, but ... can I ask why?  AT&T syntax is the
> > standard for Linux, which is in fact the OS we are developing for.
> > 
> > It makes the code extra confusing for it to be annotated differently
> > than all other Linux asm code.  And due to the inherent complexity of
> > generating code at runtime, I'd think we'd want to make the code as
> > readable as possible, for as many people as possible (i.e. other Linux
> > developers).
> 
> imo your changes make it less readable.

How does introducing an underscore between two words make them less
readable?

> please do not randomly change names and style based on your own preferences.

These are Linux standards, not my own preferences.

> dst=src
> mov(dst,src)
> memcpy(dst,src)
> if people want to have more bugs in assembler code. it's their call.
> bpf_jit_comp.c is C code. dest is on the left.

So you don't like the ordering of the src,dst function arguments?  Ok.

But what do you think about the AT&T syntax comments?

-- 
Josh
