Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D657345132
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfFNBaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfFNBaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 21:30:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1CD4E307D90D;
        Fri, 14 Jun 2019 01:30:55 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E36555F9A6;
        Fri, 14 Jun 2019 01:30:52 +0000 (UTC)
Date:   Thu, 13 Jun 2019 20:30:51 -0500
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
Message-ID: <20190614013051.6gnwduy4dsygbamj@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 14 Jun 2019 01:30:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 03:00:55PM -0700, Alexei Starovoitov wrote:
> > @@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
> >  	 * calls and calls to noreturn functions.
> >  	 */
> >  	orc = orc_find(state->signal ? state->ip : state->ip - 1);
> > -	if (!orc)
> > -		goto err;
> > +	if (!orc) {
> > +		/*
> > +		 * As a fallback, try to assume this code uses a frame pointer.
> > +		 * This is useful for generated code, like BPF, which ORC
> > +		 * doesn't know about.  This is just a guess, so the rest of
> > +		 * the unwind is no longer considered reliable.
> > +		 */
> > +		orc = &orc_fp_entry;
> > +		state->error = true;
> 
> That seems fragile.

I don't think so.  The unwinder has sanity checks to make sure it
doesn't go off the rails.  And it works just fine.  The beauty is that
it should work for all generated code (not just BPF).

> Can't we populate orc_unwind tables after JIT ?

As I mentioned it would introduce a lot more complexity.  For each JIT
function, BPF would have to tell ORC the following:

- where the BPF function lives
- how big the stack frame is
- where RBP and other callee-saved regs are on the stack

There's a lot more fragility lurking there, compared to the above.

Not to mention the unwinder would need BPF-specific knowledge, unless we
created some generic abstraction for generated code to register their
functions (which we have actually considered in the past).  But the
above approach is much simpler: just have all generated code use frame
pointers.

-- 
Josh
