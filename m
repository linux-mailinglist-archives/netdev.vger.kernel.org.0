Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3315C30E75E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhBCX3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:29:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232733AbhBCX3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612394884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qk0MRndwsudTUKG83wO3htOmgtnK5DShnl+yULNhutc=;
        b=Eazmsv3WGJRWmge5fhdyuOhFf9l/nWodnrm3fBI0ai9xKJli0aJVzLjou3ymW0UShMKBZO
        h/hI6/Yi7s05wJL3BCua7Ta0QbP/V2jodCxLBS3nUXk2PliZgE/qI7koQUwkmmCOVGu9Re
        /0SYmPvTQQcATmuWRqlSDVzAzsodLAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-sP3f55tYM9yrX1Mu_6I9qQ-1; Wed, 03 Feb 2021 18:28:00 -0500
X-MC-Unique: sP3f55tYM9yrX1Mu_6I9qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA5B41083E9D;
        Wed,  3 Feb 2021 23:27:55 +0000 (UTC)
Received: from treble (ovpn-113-81.rdu2.redhat.com [10.10.113.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27B245C1B4;
        Wed,  3 Feb 2021 23:27:44 +0000 (UTC)
Date:   Wed, 3 Feb 2021 17:27:35 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: BUG: KASAN: stack-out-of-bounds in
 unwind_next_frame+0x1df5/0x2650
Message-ID: <20210203232735.nw73kugja56jp4ls@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
 <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
 <20210203190518.nlwghesq75enas6n@treble>
 <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 02:41:53PM -0800, Ivan Babrou wrote:
> On Wed, Feb 3, 2021 at 11:05 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > > > Can you pretty please not line-wrap console output? It's unreadable.
> > >
> > > GMail doesn't make it easy, I'll send a link to a pastebin next time.
> > > Let me know if you'd like me to regenerate the decoded stack.
> > >
> > > > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> > > >
> > > > Not sure what tree you're on, but that's not the upstream commit.
> > >
> > > I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> > > added a link to the upstream hash right below.
> > >
> > > > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > > > >
> > > > >     tracepoint: Optimize using static_call()
> > > > >
> > > >
> > > > There's a known issue with that patch, can you try:
> > > >
> > > >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> > >
> > > I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> > > of v5.9 (to make it reproducible), and the patch did not help. Do I
> > > need to apply the whole series or something else?
> >
> > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > It will spit out a bunch of stack data.
> 
> Here's the three I'm building:
> 
> * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> 
> It contains:
> 
> * v5.9 tag as the base
> * static_call-2020-10-12 tag
> * dm-crypt patches to reproduce the issue with KASAN
> * x86/unwind: Add 'unwind_debug' cmdline option
> * tracepoint: Fix race between tracing and removing tracepoint
> 
> The very same issue can be reproduced on 5.10.11 with no patches,
> but I'm going with 5.9, since it boils down to static call changes.
> 
> Here's the decoded stack from the kernel with unwind debug enabled:
> 
> * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> 
> See my first email for the exact commands that trigger this.

Thanks.  Do you happen to have the original dmesg, before running it
through the post-processing script?


I assume you're using decode_stacktrace.sh?  It could use some
improvement, it's stripping the function offset.

Also spaces are getting inserted in odd places, messing the alignment.

[  137.291837][    C0] ffff88809c409858: d7c4f3ce817a1700 (0xd7c4f3ce817a1700)
[  137.291837][    C0] ffff88809c409860: 0000000000000000 (0x0)
[  137.291839][    C0] ffff88809c409868: 00000000ffffffff (0xffffffff)
[ 137.291841][ C0] ffff88809c409870: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
[ 137.291843][ C0] ffff88809c409878: ffffffffa4f01a52 unwind_next_frame (arch/x86/kernel/unwind_orc.c:380 arch/x86/kernel/unwind_orc.c:553)
[  137.291844][    C0] ffff88809c409880: ffff88809c409ac8 (0xffff88809c409ac8)
[  137.291845][    C0] ffff88809c409888: 0000000000000086 (0x86)

-- 
Josh

