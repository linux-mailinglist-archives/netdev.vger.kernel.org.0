Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F31E1C2801
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 21:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEBTVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 15:21:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727908AbgEBTVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 15:21:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588447280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y2N0/7L/seOua7FnU1iVc+jQRmQ0Fv8OF3YcHDeW7UY=;
        b=MRNPt3krS1CYJT4E8XmQHeEt6tgBDJroNQS78W/BlHBippeOb7usMWREG16MYsJryCGzEs
        e5o5ZqzsrHgye0OIMZiYRvWtyQnu0ohqny7iAGwObMWj4X3h77blcZqf1WlABV3o8if82J
        x4K/5eHqMDR0RrFLd6f8/eFyoPNfNoI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-6-r8jhzePPK0rDIxFl7YoQ-1; Sat, 02 May 2020 15:21:11 -0400
X-MC-Unique: 6-r8jhzePPK0rDIxFl7YoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6432B18CA26B;
        Sat,  2 May 2020 19:21:09 +0000 (UTC)
Received: from treble (ovpn-112-188.rdu2.redhat.com [10.10.112.188])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA07D2B4CB;
        Sat,  2 May 2020 19:21:07 +0000 (UTC)
Date:   Sat, 2 May 2020 14:21:05 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200502192105.xp2osi5z354rh4sm@treble>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 08:06:22PM -0700, Alexei Starovoitov wrote:
> On Fri, May 01, 2020 at 02:56:17PM -0500, Josh Poimboeuf wrote:
> > On Fri, May 01, 2020 at 12:40:53PM -0700, Alexei Starovoitov wrote:
> > > On Fri, May 01, 2020 at 02:22:04PM -0500, Josh Poimboeuf wrote:
> > > > On Fri, May 01, 2020 at 12:09:30PM -0700, Alexei Starovoitov wrote:
> > > > > On Thu, Apr 30, 2020 at 02:07:43PM -0500, Josh Poimboeuf wrote:
> > > > > > Objtool decodes instructions and follows all potential code branches
> > > > > > within a function.  But it's not an emulator, so it doesn't track
> > > > > > register values.  For that reason, it usually can't follow
> > > > > > intra-function indirect branches, unless they're using a jump table
> > > > > > which follows a certain format (e.g., GCC switch statement jump tables).
> > > > > > 
> > > > > > In most cases, the generated code for the BPF jump table looks a lot
> > > > > > like a GCC jump table, so objtool can follow it.  However, with
> > > > > > RETPOLINE=n, GCC keeps the jump table address in a register, and then
> > > > > > does 160+ indirect jumps with it.  When objtool encounters the indirect
> > > > > > jumps, it can't tell which jump table is being used (or even whether
> > > > > > they might be sibling calls instead).
> > > > > > 
> > > > > > This was fixed before by disabling an optimization in ___bpf_prog_run(),
> > > > > > using the "optimize" function attribute.  However, that attribute is bad
> > > > > > news.  It doesn't append options to the command-line arguments.  Instead
> > > > > > it starts from a blank slate.  And according to recent GCC documentation
> > > > > > it's not recommended for production use.  So revert the previous fix:
> > > > > > 
> > > > > >   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > > > > > 
> > > > > > With that reverted, solve the original problem in a different way by
> > > > > > getting rid of the "goto select_insn" indirection, and instead just goto
> > > > > > the jump table directly.  This simplifies the code a bit and helps GCC
> > > > > > generate saner code for the jump table branches, at least in the
> > > > > > RETPOLINE=n case.
> > > > > > 
> > > > > > But, in the RETPOLINE=y case, this simpler code actually causes GCC to
> > > > > > generate far worse code, ballooning the function text size by +40%.  So
> > > > > > leave that code the way it was.  In fact Alexei prefers to leave *all*
> > > > > > the code the way it was, except where needed by objtool.  So even
> > > > > > non-x86 RETPOLINE=n code will continue to have "goto select_insn".
> > > > > > 
> > > > > > This stuff is crazy voodoo, and far from ideal.  But it works for now.
> > > > > > Eventually, there's a plan to create a compiler plugin for annotating
> > > > > > jump tables.  That will make this a lot less fragile.
> > > > > 
> > > > > I don't like this commit log.
> > > > > Here you're saying that the code recognized by objtool is sane and good
> > > > > whereas well optimized gcc code is somehow voodoo and bad.
> > > > > That is just wrong.
> > > > 
> > > > I have no idea what you're talking about.
> > > > 
> > > > Are you saying that ballooning the function text size by 40% is well
> > > > optimized GCC code?  It seems like a bug to me.  That's the only place I
> > > > said anything bad about GCC code.
> > > 
> > > It could be a bug, but did you benchmark the speed of interpreter ?
> > > Is it faster or slower with 40% more code ?
> > > Did you benchmark it on other archs ?
> > 
> > I thought we were in agreement that 40% text growth is bad.  Isn't that
> > why you wanted to keep 'goto select_insn' for the retpoline case?
> 
> Let me see whether I got this right.
> In first the sentence above you're claiming that I've agreed that 
> 'goto select_insn' is bad for retpoline case and in the second sentence
> you're saying that I wanted to keep it because it's bad?
> In other words you're saying I wanted bad code for retpoline case for
> some mischievous purpose?
> Do you really think so or just trolling?

I *never* said anything about 'goto select_insn' being bad for the
retpoline case.

GETTING RID OF IT is bad for the retpoline case, i.e. text explosion.

That's why (I thought) you wanted to keep it for the retpoline case.

Go back and read the words I've written instead of accusing me of
trolling... WTF.

> Let's look at the facts.
> I've applied your patch and the kernel crashed on the very first test in
> selftests/bpf which makes me believe that you only compile tested it.

Yes, that was a dumb mistake.  But to be fair, I asked you about that
change, and you said it was ok:

  https://lkml.kernel.org/r/20200430042400.45vvqx4ocwwogp3j@ast-mbp.dhcp.thefacebook.com

Now I see it's obviously a bug.

> Taking the question "is 40% text growth is bad?" out of context... Ohh yes.
> but if 40% extra code gives 10% speedup to interpreter it's suddenly good, right?
> Since you didn't run basic tests I don't think you've tested performance either.
> So this direct->indirect patch might cause performance degradation to
> architectures that don't have JIT.
> On x86-64 JIT=y is the default, so I'm fine taking that performance risk
> only for the case where that risk has to be taken. In other words to help
> objtool understand the code and only for the case where objtool cannot do
> it with existing code.
> The 40% potential text decrease after direct->indirect transiton is
> irrelevant here. It must be a separate patch after corresponding
> performance benchmarking is done.
> Just claiming in commit log that current code is obviously bad
> is misleading to folks who will be reading it later.

No.  I didn't say the current code is obviously bad.  You seem to be
confused about what the problem is.

> Also as I explained earlier direct->indirect in C is not a contract
> for the compiler. Currently there is single C line:
> goto *jumptable[insn->code];
> but gcc/clang may generate arbitrary number of indirect jumps
> for this function.
> Changing the macro from "goto select_insn" to "goto *jumptable"
> messes with compiler optimizations and there is no guarantee
> that the code is going to be better or worse.
> Why do you think there are two identical macros there?
> #define CONT     ({ insn++; goto select_insn; })
> #define CONT_JMP ({ insn++; goto select_insn; })
> Why not one?
> The answer is in old patch from 2014:
> https://patchwork.ozlabs.org/project/netdev/patch/1393910304-4004-2-git-send-email-ast@plumgrid.com/
> +#define CONT ({insn++; LOAD_IMM; goto select_insn; })
> +#define CONT_JMP ({insn++; LOAD_IMM; goto select_insn; })
> +/* some compilers may need help:
> + * #define CONT_JMP ({insn++; LOAD_IMM; goto *jumptable[insn->code]; })
> + */
>
> That was the patch after dozens of performance experiments
> with different gcc versions on different cpus.
> Six years ago the interpreter performance could be improved
> if _one_ of these macros replaced direct with indirect
> for certain versions of gcc. But not both macros.

I'm not sure why you're explaining this to me again.  Obviously the
compiler is free to do whatever optimizations it wants.

> To be honest I don't think you're interested in doing performance
> analysis here. You just want to shut up that objtool warning and
> move on, right? So please do so without making misleading statements
> about goodness or badness of generated code.

Based on several of your comments above it sounds like you have a
fundamental misunderstanding of the problem.  It's a little complicated,
but I tried to explain it as clearly as I could in the patch
description.  Let me try again:

The existing 'goto select_insn' + RETPOLINE=n produces code which
objtool can't understand.  (Though it can handle RETPOLINE=y just fine.)

Ideally we would get rid of that label and just change all the 'goto
select_insn' to 'goto *jumptable[insn->code]'.  That allows objtool to
follow the code in both retpoline and non-retpoline cases.  It also
simplifies the code flow and (IMO) makes it easier for GCC to find
optimizations.

However, for the RETPOLINE=y case, that simplification actually would
cause GCC to grow the function text size by 40%.  I thought we were in
agreement that significant text growth would be universally bad,
presumably because of i-cache locality/pressure issues.  However I can
leave out any such judgements in the patch description, if that's what
you prefer.  But then I'd still need to give a justification for the
#ifdef.

If you're not worried about the possibility of the text growth being
bad, because as you mentioned there's no guarantee the code is going to
be better or worse, I'm fine with that.  Then the patch can become a lot
simpler (no weird #ifdefs) and we can just do 'goto *jumptable[insn->code]'
everywhere.

Or, if you want to minimize the patch's impact on other arches, and keep
the current patch the way it is (with bug fixed and changed patch
description), that's fine too.  I can change the patch description
accordingly.

Or if you want me to measure the performance impact of the +40% code
growth, and *then* decide what to do, that's also fine.  But you'd need
to tell me what tests to run.

-- 
Josh

