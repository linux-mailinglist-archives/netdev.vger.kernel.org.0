Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F6B463A9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfFNQLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:11:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfFNQLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 12:11:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAE55C057F30;
        Fri, 14 Jun 2019 16:11:04 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A6595DE00;
        Fri, 14 Jun 2019 16:11:03 +0000 (UTC)
Date:   Fri, 14 Jun 2019 11:11:01 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated
 code
Message-ID: <20190614161101.vobuleyjap777ol5@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble>
 <20190614070852.GQ3436@hirez.programming.kicks-ass.net>
 <20190614073536.d3xkhwhq3fuivwt5@ast-mbp.dhcp.thefacebook.com>
 <20190614081116.GU3436@hirez.programming.kicks-ass.net>
 <CAADnVQJ_-mFCeWoq-Uz9VRFkb3eLgAK+yC5hG=N7t5riGhmLWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQJ_-mFCeWoq-Uz9VRFkb3eLgAK+yC5hG=N7t5riGhmLWg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 14 Jun 2019 16:11:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 08:13:49AM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 1:11 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, Jun 14, 2019 at 12:35:38AM -0700, Alexei Starovoitov wrote:
> > > On Fri, Jun 14, 2019 at 09:08:52AM +0200, Peter Zijlstra wrote:
> > > > On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> > > > > On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:
> > > >
> > > > > > and to patches 8 and 9.
> > > > >
> > > > > Well, it's your code, but ... can I ask why?  AT&T syntax is the
> > > > > standard for Linux, which is in fact the OS we are developing for.
> > > >
> > > > I agree, all assembly in Linux is AT&T, adding Intel notation only
> > > > serves to cause confusion.
> > >
> > > It's not assembly. It's C code that generates binary and here
> > > we're talking about comments.
> >
> > And comments are useless if they don't clarify. Intel syntax confuses.
> >
> > > I'm sure you're not proposing to do:
> > > /* mov src, dst */
> > > #define EMIT_mov(DST, SRC)                                                               \
> > > right?
> >
> > Which is why Josh reversed both of them. The current Intel order is just
> > terribly confusing. And I don't see any of the other JITs having
> > confusing comments like this.
> >
> > > bpf_jit_comp.c stays as-is. Enough of it.
> >
> > I think you're forgetting this is also arch/x86 code, and no, it needs
> > changes because its broken wrt unwinding.
> 
> See MAINTAINERS file.
> If you guys keep insisting on pointless churn like this
> we'll move arch/x86/net/ into net/ where it probably belongs.
> netdev has its own comment style too.
> And it is also probably confusing to some folks.

So if I understand correctly, you're proposing that we move x86-specific
code to net/arch/x86 so you don't have to make your code readable to
others and adhere to kernel style guidelines?

-- 
Josh
