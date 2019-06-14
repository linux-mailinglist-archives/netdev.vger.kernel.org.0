Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E91E451DE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 04:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfFNC2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 22:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNC2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 22:28:52 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41B3EC057E9F;
        Fri, 14 Jun 2019 02:28:51 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3543D5ED44;
        Fri, 14 Jun 2019 02:28:50 +0000 (UTC)
Date:   Thu, 13 Jun 2019 21:28:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614022848.ly4vlgsz6fa4bcbl@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614015848.todgfogryjn573nd@treble>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 14 Jun 2019 02:28:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:58:48PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 06:42:45PM -0700, Alexei Starovoitov wrote:
> > On Thu, Jun 13, 2019 at 08:30:51PM -0500, Josh Poimboeuf wrote:
> > > On Thu, Jun 13, 2019 at 03:00:55PM -0700, Alexei Starovoitov wrote:
> > > > > @@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
> > > > >  	 * calls and calls to noreturn functions.
> > > > >  	 */
> > > > >  	orc = orc_find(state->signal ? state->ip : state->ip - 1);
> > > > > -	if (!orc)
> > > > > -		goto err;
> > > > > +	if (!orc) {
> > > > > +		/*
> > > > > +		 * As a fallback, try to assume this code uses a frame pointer.
> > > > > +		 * This is useful for generated code, like BPF, which ORC
> > > > > +		 * doesn't know about.  This is just a guess, so the rest of
> > > > > +		 * the unwind is no longer considered reliable.
> > > > > +		 */
> > > > > +		orc = &orc_fp_entry;
> > > > > +		state->error = true;
> > > > 
> > > > That seems fragile.
> > > 
> > > I don't think so.  The unwinder has sanity checks to make sure it
> > > doesn't go off the rails.  And it works just fine.  The beauty is that
> > > it should work for all generated code (not just BPF).
> > > 
> > > > Can't we populate orc_unwind tables after JIT ?
> > > 
> > > As I mentioned it would introduce a lot more complexity.  For each JIT
> > > function, BPF would have to tell ORC the following:
> > > 
> > > - where the BPF function lives
> > > - how big the stack frame is
> > > - where RBP and other callee-saved regs are on the stack
> > 
> > that sounds like straightforward addition that ORC should have anyway.
> > right now we're not using rbp in the jit-ed code,
> > but one day we definitely will.
> > Same goes for r12. It's reserved right now for 'strategic use'.
> > We've been thinking to add another register to bpf isa.
> > It will map to r12 on x86. arm64 and others have plenty of regs to use.
> > The programs are getting bigger and register spill/fill starting to
> > become a performance concern. Extra register will give us more room.
> 
> With CONFIG_FRAME_POINTER, RBP isn't available.  If you look at all the
> code in the entire kernel you'll notice that BPF JIT is pretty much the
> only one still clobbering it.

Hm.  If you wanted to eventually use R12 for other purposes, there might
be a way to abstract BPF_REG_FP such that it doesn't actually need a
dedicated register.  The BPF program's frame pointer will always be a
certain constant offset away from RBP (real frame pointer), so accesses
to BPF_REG_FP could still be based on RBP, but with an offset added to
it.

-- 
Josh
