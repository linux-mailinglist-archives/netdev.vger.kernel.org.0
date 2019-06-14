Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29A446375
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFNP4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfFNP4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 11:56:23 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D010CA1FF;
        Fri, 14 Jun 2019 15:56:23 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 159A173D3B;
        Fri, 14 Jun 2019 15:56:21 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:56:20 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614155620.f2kdlh4ttrxyyzuc@treble>
References: <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
 <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble>
 <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
 <20190614133004.gopjz64vbqmbbzqn@treble>
 <CAADnVQLp+Eq3fz6u+Q3_2UxDwdn1hKESwS5O856BabJE4wfPJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQLp+Eq3fz6u+Q3_2UxDwdn1hKESwS5O856BabJE4wfPJw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 14 Jun 2019 15:56:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 08:31:53AM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 6:34 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Thu, Jun 13, 2019 at 11:00:09PM -0700, Alexei Starovoitov wrote:
> > > > +   if (src_reg == BPF_REG_FP) {
> > > > +           /*
> > > > +            * If the value was copied from RBP (real frame pointer),
> > > > +            * adjust it to the BPF program's frame pointer value.
> > > > +            *
> > > > +            * add dst, -40
> > > > +            */
> > > > +           EMIT4(add_1mod(0x48, dst_reg), 0x83, add_1reg(0xC0, dst_reg),
> > > > +                 0xD8);
> > > > +   }
> > > > +
> > >
> > > That won't work. Any register can point to a stack.
> >
> > Right, but if the stack pointer comes from BPF_REG_FP then won't the
> > above correct it?  Then if the pointer gets passed around to other
> > registers it will have the correct value.  Or did I miss your point?
> 
> At the beginning of the program frame pointer is bpf_reg_fp,
> but later it can be in any register. It can be spilled into stack.
> Some math done on it and that adjusted pointer passed into
> another jited function.
> It's perfectly fine for one bpf program to modify stack of
> another bpf program. The verifier checks the safety bounds, etc.

I still don't get what you're saying.  The above patch attempted to
cover all those scenarios by always subtracting an offset from all movs
and stack accesses relating to BPF_REG_FP.  It might be missing a case
or two but it seems like it should work.  From the program's point of
view, BPF_REG_FP should always show the right value no matter where it
gets moved to.

But anyway, David L's nested frame idea might be a much simpler change.
I'll look at that.

-- 
Josh
