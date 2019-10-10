Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E292ED2FBF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfJJRqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:46:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfJJRqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 13:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZN+OUN9W8FzXlO76uCvRGIEqVKcVuqua8JKE2EZMJ8k=; b=T9t2ShH9YEa7GRPS2i5zKMxqL
        Up4FY734dGyKukcNThLLksD1ud2bx5e1aJlTdt1GpuT0u2E8oMFXrOsR3Zp0YeD9+r3InYv0ITmwh
        0KGsWFSyiisY5zluyf4KjOAw0TKJ7hT0UyzfnbLzuH+xmpZlUkD7vZdwAOy7DthZKqQ3NsS3OKn1s
        1JQyPpj8wJ6KMu93vwCA9grfTfJ9c1Wt8WinQPN6wxmkWnv94VRoUB3yktGVlLxFQBrHP0oaQwBFz
        kZTAHn6LybajHMqkZWoj+oQreu1xw5p26DUasKxzI/lyvQeTcRlZev9sujJp8fxFilf1KrdTZPhTG
        FhyYDlsMw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIcW4-0004Ih-EP; Thu, 10 Oct 2019 17:46:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 31D3F3013A4;
        Thu, 10 Oct 2019 19:45:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 86909220F94C4; Thu, 10 Oct 2019 19:46:18 +0200 (CEST)
Date:   Thu, 10 Oct 2019 19:46:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Message-ID: <20191010174618.GT2328@hirez.programming.kicks-ass.net>
References: <20191010061916.198761-1-songliubraving@fb.com>
 <20191010061916.198761-3-songliubraving@fb.com>
 <20191010073608.GO2311@hirez.programming.kicks-ass.net>
 <a1d30b11-2759-0293-5612-48150db92775@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d30b11-2759-0293-5612-48150db92775@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 05:19:01PM +0000, Alexei Starovoitov wrote:
> On 10/10/19 12:36 AM, Peter Zijlstra wrote:
> > On Wed, Oct 09, 2019 at 11:19:16PM -0700, Song Liu wrote:
> >> bpf stackmap with build-id lookup (BPF_F_STACK_BUILD_ID) can trigger A-A
> >> deadlock on rq_lock():
> >>
> >> rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> >> [...]
> >> Call Trace:
> >>   try_to_wake_up+0x1ad/0x590
> >>   wake_up_q+0x54/0x80
> >>   rwsem_wake+0x8a/0xb0
> >>   bpf_get_stack+0x13c/0x150
> >>   bpf_prog_fbdaf42eded9fe46_on_event+0x5e3/0x1000
> >>   bpf_overflow_handler+0x60/0x100
> >>   __perf_event_overflow+0x4f/0xf0
> >>   perf_swevent_overflow+0x99/0xc0
> >>   ___perf_sw_event+0xe7/0x120
> >>   __schedule+0x47d/0x620
> >>   schedule+0x29/0x90
> >>   futex_wait_queue_me+0xb9/0x110
> >>   futex_wait+0x139/0x230
> >>   do_futex+0x2ac/0xa50
> >>   __x64_sys_futex+0x13c/0x180
> >>   do_syscall_64+0x42/0x100
> >>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>
> > 
> >> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> >> index 052580c33d26..3b278f6b0c3e 100644
> >> --- a/kernel/bpf/stackmap.c
> >> +++ b/kernel/bpf/stackmap.c
> >> @@ -287,7 +287,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
> >>   	bool irq_work_busy = false;
> >>   	struct stack_map_irq_work *work = NULL;
> >>
> >> -	if (in_nmi()) {
> >> +	if (in_nmi() || this_rq_is_locked()) {
> >>   		work = this_cpu_ptr(&up_read_work);
> >>   		if (work->irq_work.flags & IRQ_WORK_BUSY)
> >>   			/* cannot queue more up_read, fallback */
> > 
> > This is horrific crap. Just say no to that get_build_id_offset()
> > trainwreck.
> 
> this is not a helpful comment.
> What issues do you see with this approach?

It will still generate deadlocks if I place a tracepoint inside a lock
that nests inside rq->lock, and it won't ever be able to detect that.
Say do the very same thing on trace_hrtimer_start(), which is under
cpu_base->lock, which nests inside rq->lock. That should give you an
AB-BA.

tracepoints / perf-overflow should _never_ take locks.

All of stack_map_get_build_id_offset() is just disguisting games; I did
tell you guys how to do lockless vma lookups a few years ago -- and yes,
that is invasive core mm surgery. But this is just disguisting hacks for
not wanting to do it right.

Basically the only semi-sane thing to do with that trainwreck is
s/in_nmi()/true/ and pray.

On top of that I just hate buildids in general.

