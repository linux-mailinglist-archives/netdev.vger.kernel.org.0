Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5176F284A5E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 12:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFKfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 06:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFKfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 06:35:45 -0400
Received: from localhost (deu95-h05-176-171-255-236.dsl.sta.abo.bbox.fr [176.171.255.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 902922080A;
        Tue,  6 Oct 2020 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601980544;
        bh=iZXnIWy2l9HS4uSNbQ+gW7Bpg/P6i/Lo3Y/xZuANNPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IzBvH0x38Q/wYJTIs5xaQFknuuvw6tcwd+CJNR1lm5ErfYidSkQjB904MEqA24RDp
         tWuIQrtdCJMR7a62G9Nlp4ziIGdX717ojn/gcpR91sYQmkZ8UIA2ZkS3hbBkc0HrHC
         p9Drw9nndIDRv0SXKKYRaOh3zKeZCO/pdThg+b38=
Date:   Tue, 6 Oct 2020 12:35:41 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Alex Belits <abelits@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Message-ID: <20201006103541.GA31325@lothringen>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
 <20201001135640.GA1748@lothringen>
 <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
 <20201004231404.GA66364@lothringen>
 <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 02:52:49PM -0400, Nitesh Narayan Lal wrote:
> 
> On 10/4/20 7:14 PM, Frederic Weisbecker wrote:
> > On Sun, Oct 04, 2020 at 02:44:39PM +0000, Alex Belits wrote:
> >> On Thu, 2020-10-01 at 15:56 +0200, Frederic Weisbecker wrote:
> >>> External Email
> >>>
> >>> -------------------------------------------------------------------
> >>> ---
> >>> On Wed, Jul 22, 2020 at 02:49:49PM +0000, Alex Belits wrote:
> >>>> +/*
> >>>> + * Description of the last two tasks that ran isolated on a given
> >>>> CPU.
> >>>> + * This is intended only for messages about isolation breaking. We
> >>>> + * don't want any references to actual task while accessing this
> >>>> from
> >>>> + * CPU that caused isolation breaking -- we know nothing about
> >>>> timing
> >>>> + * and don't want to use locking or RCU.
> >>>> + */
> >>>> +struct isol_task_desc {
> >>>> +	atomic_t curr_index;
> >>>> +	atomic_t curr_index_wr;
> >>>> +	bool	warned[2];
> >>>> +	pid_t	pid[2];
> >>>> +	pid_t	tgid[2];
> >>>> +	char	comm[2][TASK_COMM_LEN];
> >>>> +};
> >>>> +static DEFINE_PER_CPU(struct isol_task_desc, isol_task_descs);
> >>> So that's quite a huge patch that would have needed to be split up.
> >>> Especially this tracing engine.
> >>>
> >>> Speaking of which, I agree with Thomas that it's unnecessary. It's
> >>> too much
> >>> code and complexity. We can use the existing trace events and perform
> >>> the
> >>> analysis from userspace to find the source of the disturbance.
> >> The idea behind this is that isolation breaking events are supposed to
> >> be known to the applications while applications run normally, and they
> >> should not require any analysis or human intervention to be handled.
> > Sure but you can use trace events for that. Just trace interrupts, workqueues,
> > timers, syscalls, exceptions and scheduler events and you get all the local
> > disturbance. You might want to tune a few filters but that's pretty much it.
> >
> > As for the source of the disturbances, if you really need that information,
> > you can trace the workqueue and timer queue events and just filter those that
> > target your isolated CPUs.
> >
> 
> I agree that we can do all those things with tracing.
> However, IMHO having a simplified logging mechanism to gather the source of
> violation may help in reducing the manual effort.
> 
> Although, I am not sure how easy will it be to maintain such an interface
> over time.

The thing is: tracing is your simplified logging mechanism here. You can achieve
the same in userspace with _way_ less code, no race, and you can do it in
bash.

Thanks.



