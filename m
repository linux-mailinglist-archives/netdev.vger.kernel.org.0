Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5D45E37
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfFNNbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbfFNNbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:31:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2758308219E;
        Fri, 14 Jun 2019 13:31:37 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 620DC1798D;
        Fri, 14 Jun 2019 13:31:36 +0000 (UTC)
Date:   Fri, 14 Jun 2019 08:31:34 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614132615.qsbnvvnidba7cl55@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
 <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble>
 <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
 <20190614074136.GR3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614074136.GR3436@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 14 Jun 2019 13:31:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 09:41:37AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 13, 2019 at 11:00:09PM -0700, Alexei Starovoitov wrote:
> 
> > There is something wrong with
> > commit d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> 
> It assumes we can always unwind stack, which is, imo, not a weird thing.
> 
> > If I simply revert it and have CONFIG_UNWINDER_FRAME_POINTER=y
> > JITed stacks work just fine, because
> > bpf_get_stackid()->get_perf_callchain()
> > need to start unwinding before any bpf stuff.
> 
> How does stack unwinding work if we try and unwind from an interrupt
> that hits inside a BPF program? That too needs to work properly.
>
> > After that commit it needs to go through which is a bug on its own.
> > imo patch 1 doesn't really fix that issue.
> 
> This we agree on, patch 1 doesn't solve that at all. But we also should
> not loose the initial regs->ip value.
> 
> > As far as mangled rbp can we partially undo old
> > commit 177366bf7ceb ("bpf: change x86 JITed program stack layout")
> > that introduced that rbp adjustment.
> 
> > Going through bpf code is only interesting in case of panics somewhere
> > in bpf helpers. Back then we didn't even have ksym of jited code.
> 
> I disagree here, interrupts/NMIs hitting inside BPF should be able to
> reliably unwind the entire stack. Back then is irrelevant, these days we
> expect a reliable unwind.

Right.  Also, JIT code can call into C code, which could

a) try to unwind
b) call WARN()
c) hit a panic
d) get preempted by code which does any of the above
e) etc

> > Anyhow I agree that we need to make the jited frame proper,
> > but unwinding need to start before any bpf stuff.
> > That's a bigger issue.
> 
> I strongly disagree, we should be able to unwind through bpf.

-- 
Josh
