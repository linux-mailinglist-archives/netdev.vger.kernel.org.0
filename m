Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32AF3811F8
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhENUsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231607AbhENUsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 16:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE30F61106;
        Fri, 14 May 2021 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621025216;
        bh=mkns6LF2/0IsfAvHI7FNhoNi0kJUepJlW1v2yduiTHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnS3kvkqfNSGUbnLoPGFV4VANmMUsj/0vzeKICiTfLdy+8qAMhg9Gmicpw+seA5h0
         2gp6GeJp1V4Jw4awkP5phUsYmgndgEU4DsWiIHjZ/FjkVgtKb4DoEsbQTvBlWaxY8O
         +pKGvQbRdE81PTrFQu0FguOigC0F8bVTJr+ecytDpSK+kQJbRuP6TvsIg1l/99OhDv
         wPrmt7UNDjaIAJJeSoij/zeqBHbg4S5gS9qMXGZF4PJwtSUA/QZHbDyWZHIZCCx73k
         YFsGvkHxNXIViG+CYdLFI4tRGAKZmbttQSx6q1draRM9kZWY4yRxuEVUfyIFS+OjeF
         ng7PpCYba+wsQ==
Date:   Fri, 14 May 2021 13:46:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
Message-ID: <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87sg2p2hbl.ffs@nanos.tec.linutronix.de>
References: <877dk162mo.ffs@nanos.tec.linutronix.de>
        <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
        <87sg2p2hbl.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 22:25:50 +0200 Thomas Gleixner wrote:
> On Fri, May 14 2021 at 12:38, Jakub Kicinski wrote:
> 
> > On Fri, 14 May 2021 12:17:19 +0200 Thomas Gleixner wrote:  
> >> The driver invokes napi_schedule() in several places from task
> >> context. napi_schedule() raises the NET_RX softirq bit and relies on the
> >> calling context to ensure that the softirq is handled. That's usually on
> >> return from interrupt or on the outermost local_bh_enable().
> >> 
> >> But that's not the case here which causes the soft interrupt handling to be
> >> delayed to the next interrupt or local_bh_enable(). If the task in which
> >> context this is invoked is the last runnable task on a CPU and the CPU goes
> >> idle before an interrupt arrives or a local_bh_disable/enable() pair
> >> handles the pending soft interrupt then the NOHZ idle code emits the
> >> following warning.
> >> 
> >>   NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
> >> 
> >> Prevent this by wrapping the napi_schedule() invocation from task context
> >> into a local_bh_disable/enable() pair.  
> >
> > I should have read through my inbox before replying :)
> >
> > I'd go for switching to raise_softirq_irqoff() in ____napi_schedule()...
> > why not?  
> 
> Except that some instruction cycle beancounters might complain about
> the extra conditional for the sane cases.
> 
> But yes, I'm fine with that as well. That's why this patch is marked RFC :)

When we're in the right context (irq/bh disabled etc.) the cost is just
read of preempt_count() and jump, right? And presumably preempt_count()
is in the cache already, because those sections aren't very long. Let me
make this change locally and see if it is in any way perceivable.

Obviously if anyone sees a way to solve the problem without much
ifdefinery and force_irqthreads checks that'd be great - I don't.
I'd rather avoid pushing this kind of stuff out to the drivers.
