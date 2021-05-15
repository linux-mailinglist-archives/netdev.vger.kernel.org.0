Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB2381AA2
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 21:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhEOTHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 15:07:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44106 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhEOTHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 15:07:17 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621105562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zALTCEjPn7sztZNd85u8yKI0LRF8p9B5oT1vb4kC4jA=;
        b=Mf3g6XafW+5Mdu/oDormRTpHArjnxMIoM7A6M91I9DWkStkG2Hmp1L1R8efGMsDOIQMdnj
        ifFak5poU+DhdItzq5Lr5K7xEc48UZWCgHEwv4T9ry/8dunwKSyIwmT39mRAbEB7UC5hx5
        mamsVyq8MQV6H1kvK6RWduRcumvlL+7ob1Mpq2+xh0l+dvyj0TGn/ZJ/NNnhptQl+vi+7q
        KRTEkC8zwNVoKBHncLNaFBZao6/AG+FlE/YkjcdGiZOJ1Pfe3XyjcEf5radzuTVqMoDQKN
        mmhlH2TYyyF+AfTMwftGf4o/GiC6qW+Diwfn3epK91oo6gskej72U+5IJXK9LA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621105562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zALTCEjPn7sztZNd85u8yKI0LRF8p9B5oT1vb4kC4jA=;
        b=YHxvqS/DXfYP5E3WLEomds0pQNYkCPQqE33PLYC/wRV1n2dn+6vvamXw1bTneAg5b3VZYm
        2BNQg/fPrMcnUTAQ==
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
In-Reply-To: <20210515130926.GC21560@worktop.programming.kicks-ass.net>
References: <877dk162mo.ffs@nanos.tec.linutronix.de> <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN> <87sg2p2hbl.ffs@nanos.tec.linutronix.de> <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN> <87fsyp2f8s.ffs@nanos.tec.linutronix.de> <20210514144130.7287af8e@kicinski-fedora-PC1C0HJN> <871ra83nop.ffs@nanos.tec.linutronix.de> <20210515130926.GC21560@worktop.programming.kicks-ass.net>
Date:   Sat, 15 May 2021 21:06:01 +0200
Message-ID: <87k0nz24x2.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15 2021 at 15:09, Peter Zijlstra wrote:
> On Sat, May 15, 2021 at 01:23:02AM +0200, Thomas Gleixner wrote:
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -691,7 +691,9 @@ void flush_smp_call_function_from_idle(v
>>  	cfd_seq_store(this_cpu_ptr(&cfd_seq_local)->idle, CFD_SEQ_NOCPU,
>>  		      smp_processor_id(), CFD_SEQ_IDLE);
>>  	local_irq_save(flags);
>> +	lockdep_set_softirq_raise_safe();
>>  	flush_smp_call_function_queue(true);
>> +	lockdep_clear_softirq_raise_safe();
>>  	if (local_softirq_pending())
>>  		do_softirq();
>
> I think it might make more sense to raise hardirq_count() in/for
> flush_smp_call_function_queue() callers that aren't already from hardirq
> context. That's this site and smpcfd_dying_cpu().
>
> Then we can do away with this new special case.

Right.

Though I just checked smpcfd_dying_cpu(). That ones does not run
softirqs after flushing the function queue and it can't do that because
that's in the CPU dying phase with interrupts disabled where the CPU is
already half torn down.

Especially as softirq processing enables interrupts, which might cause
even more havoc.

Anyway how is it safe to run arbitrary functions there after the CPU
removed itself from the online mask? That's daft to put it mildly.

Thanks,

        tglx




