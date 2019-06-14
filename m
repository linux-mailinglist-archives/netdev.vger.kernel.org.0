Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F5846D05
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfFNXyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfFNXyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 19:54:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAE9F3083391;
        Fri, 14 Jun 2019 23:54:24 +0000 (UTC)
Received: from treble (ovpn-112-39.rdu2.redhat.com [10.10.112.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E62DF60CA3;
        Fri, 14 Jun 2019 23:54:20 +0000 (UTC)
Date:   Fri, 14 Jun 2019 18:54:17 -0500
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
Message-ID: <20190614235417.7oagddee75xo7otp@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
 <20190614211916.jnxakyfwilcv6r57@treble>
 <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
 <20190614231311.gfeb47rpjoholuov@treble>
 <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 14 Jun 2019 23:54:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:23:41PM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 14, 2019 at 4:13 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Fri, Jun 14, 2019 at 02:27:30PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > >
> > > > On Fri, Jun 14, 2019 at 02:05:56PM -0700, Alexei Starovoitov wrote:
> > > > > Have you tested it ?
> > > > > I really doubt, since in my test both CONFIG_UNWINDER_ORC and
> > > > > CONFIG_UNWINDER_FRAME_POINTER failed to unwind through such odd frame.
> > > >
> > > > Hm, are you seeing selftest failures?  They seem to work for me.
> > > >
> > > > > Here is much simple patch that I mentioned in the email yesterday,
> > > > > but you failed to listen instead of focusing on perceived 'code readability'.
> > > > >
> > > > > It makes one proper frame and both frame and orc unwinders are happy.
> > > >
> > > > I'm on my way out the door and I just skimmed it, but it looks fine.
> > > >
> > > > Some of the code and patch description look familiar, please be sure to
> > > > give me proper credit.
> > >
> > > credit means something positive.
> >
> > So you only give credit for *good* stolen code.  I must have missed that
> > section of the kernel patch guidelines.
> 
> what are you talking about?
> you've posted one bad patch. I pointed out multiple issues in it.
> Then proposed another bad idea. I pointed out another set of issues.
> Than David proposed yet another idea that you've implemented
> and claimed that it's working when it was not.
> Then I got fed up with this thread and fix it for real by reverting
> that old commit that I mentioned way earlier.
> https://patchwork.ozlabs.org/patch/1116307/
> Where do you see your code or ideas being used?
> I see none.

Obviously I wasn't referring to this new whitewashed patch for which I
wasn't even on Cc, despite being one of the people (along with Peter Z)
who convinced you that there was a problem to begin with.

The previous patch you posted has my patch description, push/pop and
comment changes, with no credit:

https://lkml.kernel.org/r/20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com

-- 
Josh
