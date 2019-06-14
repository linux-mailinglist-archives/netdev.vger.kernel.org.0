Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9434568D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfFNHlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:41:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42040 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfFNHlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dMa51kg57fAa4NjsSOviOfP9gGy0J52rQSs24i78lqM=; b=enxNyPGfXRJ13CeS7m9p9KG21
        CAI3rfauRIHJfVS9oNQsEcK5NuzFFZpbXcwFW0dlOpM8YfXXmZUApq3Gnz8Q/oUDAlGcVIvWiMDt5
        y6DN9xseIb0N3NavBCFfjc/pqRVUw0PSKFS/nO32WgxFy6KJaJku201BKfsVRRGltg2BT65O66e+T
        XCsaWVePnFoaP1V8qN1ERxmF4DYSW0CZwr3WliQqmLGelLnyXTswdG9chzija+kqid4SrEWBTfIJj
        EbtEvn3HPHfEjQkn40caRbdi//HC0PTasJfOSHrg45Zy3WRZztaaqcwOM+qF1o0oz+8ra4g80NaBv
        C83qEkdqQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbgqA-0005t2-S6; Fri, 14 Jun 2019 07:41:39 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0F21A209C9EB8; Fri, 14 Jun 2019 09:41:37 +0200 (CEST)
Date:   Fri, 14 Jun 2019 09:41:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614074136.GR3436@hirez.programming.kicks-ass.net>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
 <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble>
 <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 11:00:09PM -0700, Alexei Starovoitov wrote:

> There is something wrong with
> commit d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")

It assumes we can always unwind stack, which is, imo, not a weird thing.

> If I simply revert it and have CONFIG_UNWINDER_FRAME_POINTER=y
> JITed stacks work just fine, because
> bpf_get_stackid()->get_perf_callchain()
> need to start unwinding before any bpf stuff.

How does stack unwinding work if we try and unwind from an interrupt
that hits inside a BPF program? That too needs to work properly.

> After that commit it needs to go through which is a bug on its own.
> imo patch 1 doesn't really fix that issue.

This we agree on, patch 1 doesn't solve that at all. But we also should
not loose the initial regs->ip value.

> As far as mangled rbp can we partially undo old
> commit 177366bf7ceb ("bpf: change x86 JITed program stack layout")
> that introduced that rbp adjustment.

> Going through bpf code is only interesting in case of panics somewhere
> in bpf helpers. Back then we didn't even have ksym of jited code.

I disagree here, interrupts/NMIs hitting inside BPF should be able to
reliably unwind the entire stack. Back then is irrelevant, these days we
expect a reliable unwind.

> Anyhow I agree that we need to make the jited frame proper,
> but unwinding need to start before any bpf stuff.
> That's a bigger issue.

I strongly disagree, we should be able to unwind through bpf.
