Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC72D5E40
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 11:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfJNJJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 05:09:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbfJNJJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 05:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jTDg8IH5LozhrHxBzB1ClkZ0/ElvKEYcyD0vSMTfAMM=; b=K3XJqY2A6oBGRw6kRpPiaOQjd
        R5BN5Dq6pF/0JhnsPRxtpWWk3SRhuBf4OaTYksweoovT8STtsBNklhSms9feMWz1FVkQj/pAMXWju
        BFBxigEgsrPcV3AbOol/mBX82m4TUFI0Cdq2J4muN2/ITFjS9BBxo6I+F2gWJvQSr4wXLAUQz6+IK
        DAu0BA0WxJAamB5i8RVz93Q0htTdlOHNuXfjGndhVuojIdkL8Yuults5HeC/5tPgnxbg3wg+f82PE
        MBna5j9S75u/caXq+uN16gL3Nc+akwh7V3O9ln9BmPj9CUiVoLWNqahtpFqIzC6klChW0OGJx/m/Y
        bcECZYdfg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJwLh-0004AL-PF; Mon, 14 Oct 2019 09:09:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 23284305E42;
        Mon, 14 Oct 2019 11:08:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 17665202BC5A3; Mon, 14 Oct 2019 11:09:03 +0200 (CEST)
Date:   Mon, 14 Oct 2019 11:09:03 +0200
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
Message-ID: <20191014090903.GA2328@hirez.programming.kicks-ass.net>
References: <20191010061916.198761-1-songliubraving@fb.com>
 <20191010061916.198761-3-songliubraving@fb.com>
 <20191010073608.GO2311@hirez.programming.kicks-ass.net>
 <a1d30b11-2759-0293-5612-48150db92775@fb.com>
 <20191010174618.GT2328@hirez.programming.kicks-ass.net>
 <4865df4d-7d13-0655-f3b4-5d025aaa1edb@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4865df4d-7d13-0655-f3b4-5d025aaa1edb@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 06:06:14PM +0000, Alexei Starovoitov wrote:
> On 10/10/19 10:46 AM, Peter Zijlstra wrote:

> > All of stack_map_get_build_id_offset() is just disguisting games; I did
> > tell you guys how to do lockless vma lookups a few years ago -- and yes,
> > that is invasive core mm surgery. But this is just disguisting hacks for
> > not wanting to do it right.
> 
> you mean speculative page fault stuff?
> That was my hope as well and I offered Laurent all the help to land it.
> Yet after a year since we've talked the patches are not any closer
> to landing.
> Any other 'invasive mm surgery' you have in mind?

Indeed that series. It had RCU managed VMAs and lockless VMA lookups,
which is exactly what you need here.

> > Basically the only semi-sane thing to do with that trainwreck is
> > s/in_nmi()/true/ and pray.
> > 
> > On top of that I just hate buildids in general.
> 
> Emotions aside... build_id is useful and used in production.
> It's used widely because it solves real problems.

AFAIU it solves the problem of you not knowing what version of the
binary runs where; which I was hoping your cloud infrastructure thing
would actually know already.

Anyway, I know what it does, I just don't nessecarily agree it is the
right way around that particular problem (also, the way I'm personally
affected is that perf-record is dead slow by default due to built-id
post processing).

And it obviously leads to horrible hacks like the code currently under
discussion :/

> This dead lock is from real servers and not from some sanitizer wannabe.

If you enable CFS bandwidth control and run this function on the
trace_hrtimer_start() tracepoint, you should be able to trigger a real
AB-BA lockup.

> Hence we need to fix it as cleanly as possible and quickly.
> s/in_nmi/true/ is certainly an option.

That is the best option; because tracepoints / perf-overflow handlers
really should not be taking any locks.

> I'm worried about overhead of doing irq_work_queue() all the time.
> But I'm not familiar with mechanism enough to justify the concerns.
> Would it make sense to do s/in_nmi/irgs_disabled/ instead?

irqs_disabled() should work in this particular case because rq->lock
(and therefore all it's nested locks) are IRQ-safe.

