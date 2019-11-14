Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7EFCB91
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfKNRMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:12:55 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:43259 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfKNRMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 12:12:54 -0500
Received: by mail-qv1-f65.google.com with SMTP id cg2so2638488qvb.10
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 09:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SB/N8Ptzig01YWuKDW7xcQj/aLQWm5msLsK8SizfSFo=;
        b=qRoRkibLDkcQeR+vKYb00RQD2hLN4GpsM8H3Rg9diqaMAGdGQG05Fuldi+pIaVRXch
         0zcUzLv2py01YRPPrf7a0x2OrRiYQohi1KokhFEdAO61TLNrTLSv7uNsrKwvC0wdS8JN
         mTrvLFwjZJQ8Pdp0zENa3s7u+CDf1fJ8dx71b/qyG7OFNI6inJK8NbtqYaMRItkOvgWl
         NjdgT/e+IQOd1DaHss5gzUJLAh1ff4Cg1KjZf5Tp1ag+3ErPKNo20iYeCv4O2tOSnwNq
         pzSyaEmOyQVTL9coQiTg36LP7ZrEBXMdHhC3k2RDybvQR0CwVtYW6ebrUhYa9KSr9P1R
         J4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SB/N8Ptzig01YWuKDW7xcQj/aLQWm5msLsK8SizfSFo=;
        b=qgUZEyjqHQWlBvgxqPItXjy5V9/m3qSmZ0sU5lu2LnBD9J2+uqCHJQt49TxzLDi9Pm
         c/icl1KXngytYvvcSXH7bUdsr1bEoozHs6plMKVad6TnLWYdALnBenxHyKmuK5UPGdMC
         EP2evGduF0818k5sQ3GVZ2MXQpG9GRNnAX36yT8nRNOolJpx/j0CTSKnqhCCEOguxaD2
         0fTybdlvbbtEU8Ei3yMoE1rw7PcAR08dvexvg6k0B0jFf0MfsmfCcsxzzEoPidm+6NiU
         hfLJcVFa93kToGQ7mGAdsugLk5PHlbvT8NIRcyWR/U3dlhRP8IfR3ubr7r6m3yhV4srP
         rHgw==
X-Gm-Message-State: APjAAAWmElJX8eEVSFYmIFxB/omwgqjl8vS0Qxx4o1D4cT0AGlLl6FrG
        8oCln2Rzg1MV1ul76ok2gH+TpA==
X-Google-Smtp-Source: APXvYqzoFtd1AN7Cola7hUsKJ9xrGflS6FS7qygdW7w7JD2mf/QMeEHLk/uebwsvk//zVKmpVvMrsQ==
X-Received: by 2002:a0c:c588:: with SMTP id a8mr9137649qvj.9.1573751573612;
        Thu, 14 Nov 2019 09:12:53 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n55sm3444361qta.24.2019.11.14.09.12.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 09:12:52 -0800 (PST)
Message-ID: <1573751570.5937.122.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Nov 2019 12:12:50 -0500
In-Reply-To: <20190905113208.GA521@jagdpanzerIV>
References: <20190903185305.GA14028@dhcp22.suse.cz>
         <1567546948.5576.68.camel@lca.pw> <20190904061501.GB3838@dhcp22.suse.cz>
         <20190904064144.GA5487@jagdpanzerIV> <20190904065455.GE3838@dhcp22.suse.cz>
         <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
         <1567599263.5576.72.camel@lca.pw>
         <20190904144850.GA8296@tigerII.localdomain>
         <1567629737.5576.87.camel@lca.pw> <20190905113208.GA521@jagdpanzerIV>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-05 at 20:32 +0900, Sergey Senozhatsky wrote:
> On (09/04/19 16:42), Qian Cai wrote:
> > > Let me think more.
> > 
> > To summary, those look to me are all good long-term improvement that would
> > reduce the likelihood of this kind of livelock in general especially for other
> > unknown allocations that happen while processing softirqs, but it is still up to
> > the air if it fixes it 100% in all situations as printk() is going to take more
> > time
> 
> Well. So. I guess that we don't need irq_work most of the time.
> 
> We need to queue irq_work for "safe" wake_up_interruptible(), when we
> know that we can deadlock in scheduler. IOW, only when we are invoked
> from the scheduler. Scheduler has printk_deferred(), which tells printk()
> that it cannot do wake_up_interruptible(). Otherwise we can just use
> normal wake_up_process() and don't need that irq_work->wake_up_interruptible()
> indirection. The parts of the scheduler, which by mistake call plain printk()
> from under pi_lock or rq_lock have chances to deadlock anyway and should
> be switched to printk_deferred().
> 
> I think we can queue significantly much less irq_work-s from printk().
> 
> Petr, Steven, what do you think?

Sergey, do you still plan to get this patch merged?

> 
> Something like this. Call wake_up_interruptible(), switch to
> wake_up_klogd() only when called from sched code.
> 
> ---
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index cd51aa7d08a9..89cb47882254 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	pending_output = (curr_log_seq != log_next_seq);
>  	logbuf_unlock_irqrestore(flags);
>  
> +	if (!pending_output)
> +		return printed_len;
> +
>  	/* If called from the scheduler, we can not call up(). */
> -	if (!in_sched && pending_output) {
> +	if (!in_sched) {
>  		/*
>  		 * Disable preemption to avoid being preempted while holding
>  		 * console_sem which would prevent anyone from printing to
> @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		if (console_trylock_spinning())
>  			console_unlock();
>  		preempt_enable();
> -	}
>  
> -	if (pending_output)
> +		wake_up_interruptible(&log_wait);
> +	} else {
>  		wake_up_klogd();
> +	}
>  	return printed_len;
>  }
>  EXPORT_SYMBOL(vprintk_emit);
> ---
> 
> > and could deal with console hardware that involve irq_exit() anyway.
> 
> printk->console_driver->write() does not involve irq.
> 
> > On the other hand, adding __GPF_NOWARN in the build_skb() allocation will fix
> > this known NET_TX_SOFTIRQ case which is common when softirqd involved at least
> > in short-term. It even have a benefit to reduce the overall warn_alloc() noise
> > out there.
> 
> That's not up to me to decide.
> 
> 	-ss
