Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26CFB47016
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfFOM55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 08:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfFOM55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 08:57:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A174B308213A;
        Sat, 15 Jun 2019 12:57:55 +0000 (UTC)
Received: from treble (ovpn-120-23.rdu2.redhat.com [10.10.120.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A2B4379E;
        Sat, 15 Jun 2019 12:57:51 +0000 (UTC)
Date:   Sat, 15 Jun 2019 07:57:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
Message-ID: <20190615125748.2c4xpgfuccanjx5d@treble>
References: <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
 <20190614211916.jnxakyfwilcv6r57@treble>
 <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
 <20190614231311.gfeb47rpjoholuov@treble>
 <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
 <20190614235417.7oagddee75xo7otp@treble>
 <CAADnVQ+mjtgZExhtKDu6bbaVSHUfOYb=XeJodPB5+WdjtLYvCA@mail.gmail.com>
 <20190615042747.awyy4djqe6vfmles@treble>
 <CAADnVQJV6Yb9EyXE+NG6Nd1KLhhoF2Nr6BN=fihYnW7H0cvRoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQJV6Yb9EyXE+NG6Nd1KLhhoF2Nr6BN=fihYnW7H0cvRoQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Sat, 15 Jun 2019 12:57:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 10:16:53PM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 9:27 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Fri, Jun 14, 2019 at 05:02:36PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Jun 14, 2019 at 4:54 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > > The previous patch you posted has my patch description, push/pop and
> > > > comment changes, with no credit:
> > > >
> > > > https://lkml.kernel.org/r/20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com
> > >
> > > I'm sorry for reusing one sentence from your commit log and
> > > not realizing you want credit for that.
> > > Will not happen again.
> >
> > Um.  What are you talking about?  The entire patch was clearly derived
> > from mine.  Not just "one sentence from your commit log".  The title,
> > the pushes/pops in the prologue/epilogue, the removal of the
> > "ebpf_from_cbpf" argument, the code spacing, and some of the non trivial
> > comment changes were the same.
> >
> > > I also suggest you never touch anything bpf related.
> > > Just to avoid this credit claims and threads like this one.
> >
> > Wth.  I made a simple request for credit.  Anybody can see the patch was
> > derived from mine.  It's not like I really care.  It's just basic human
> > decency.
> 
> derived? do you really think so ?
> Please fix your orc stuff that is still broken.
> Human decency is fixing stuff that you're responsible for.
> Your commit d15d356887e7 on April 23 broke stack traces.
> And we reported it 3 weeks ago.
> Yet instead of fixing it you kept arguing about JIT frame pointers
> that is orthogonal issue and was in this state for the last 2 years.

Again you're not making sense.  The fix has already been posted.  That
was the point of this patch set.

It's your call if you want to cherry pick the FP fix (which is a
dependency of the ORC fix) without taking the others.

-- 
Josh
