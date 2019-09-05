Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28962AA7E0
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390498AbfIEQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:03:18 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39707 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389591AbfIEQDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 12:03:17 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so2618975qki.6
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 09:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ARdJcCTl1yvQzK9KFLXbOHVAx1PUXY0NiCi5/Ki6zRU=;
        b=srJv115Is3P1U681GfWFzKE7i0Oyph2BEelIw9RQDw4Dln8DnSnc88Tiza/8Et1j36
         3OEPDoDLDWMDlfCdb9bby1HL0sCkqqlMEzLjdLZh8tpE4MRAyc99rr6a/hlqrGjxx2m/
         KaXYbChyJ7NwsgcfkNrN3Qr78Nqmzy3gFHjtA/dT2vDsmG502OtHEQGe9og31RxU+rJI
         tS2S5wrJxZz/0XgpVwuQsY+3fY3ghD8rqtVwNRBRhNdj8C68YXgGsHZ8G7KJlj71db1s
         oKW1//ih086eB7lxRtuLID5QBMTp+6gknvrXt5Gk+261Ch7f+flyF9712noDYKC6CGOJ
         B6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARdJcCTl1yvQzK9KFLXbOHVAx1PUXY0NiCi5/Ki6zRU=;
        b=aVfaEHF9x7kVmDK4f/xZm7k6kf0a+8SLset1h72S9nEDqzmnbp5/CoDpNI/id73gv9
         DHVjR+ViClachP9utWu/gLdMT3kG0/1A796sGLzqxoEl4nju9uyqVSGz2om7HqvG5pKC
         LohEoMQ/d7AiDEF0i6fTT/uJH22Xk2kM372gWM8A5k2iyVpPpk9phtcwiuVeIRcDmHYC
         yYODrTLUind7JEJKI/0/nstd8qJhLPXrldKY90kMRQam8fT9myy2DL05IKsDY/ptBGwa
         IW3MuBJShThKsU5snHGFV34aJj8b3msLipKg+sB1aSF2suvLX8ASyfnV+0TEWkAbBJ77
         I1YA==
X-Gm-Message-State: APjAAAU6i+Gu2uBG+Cc5Y4If4gmVS5+Febk2vpA+UA8oxCynf9v82Ojv
        ToGew0xH+HkLzMUCbIwc4yIBjA==
X-Google-Smtp-Source: APXvYqwz5Ih1cBni0LNoxZQih9BYTQsib4BYdkphk3cPMd+iJT2Lx0QIEW7e93FPRyn81x6iF6WcRA==
X-Received: by 2002:ae9:e50f:: with SMTP id w15mr3683737qkf.129.1567699396301;
        Thu, 05 Sep 2019 09:03:16 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p126sm1346062qkc.84.2019.09.05.09.03.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 09:03:15 -0700 (PDT)
Message-ID: <1567699393.5576.96.camel@lca.pw>
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
Date:   Thu, 05 Sep 2019 12:03:13 -0400
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
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-05 at 20:32 +0900, Sergey Senozhatsky wrote:
> On (09/04/19 16:42), Qian Cai wrote:
> > > Let me think more.
> > 
> > To summary, those look to me are all good long-term improvement that would
> > reduce the likelihood of this kind of livelock in general especially for
> > other
> > unknown allocations that happen while processing softirqs, but it is still
> > up to
> > the air if it fixes it 100% in all situations as printk() is going to take
> > more
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
>  	pending_output = (curr_log_seq != log_next_seq);
>  	logbuf_unlock_irqrestore(flags);
>  
> +	if (!pending_output)
> +		return printed_len;
> +
>  	/* If called from the scheduler, we can not call up(). */
> -	if (!in_sched && pending_output) {
> +	if (!in_sched) {
>  		/*
>  		 * Disable preemption to avoid being preempted while holding
>  		 * console_sem which would prevent anyone from printing to
> @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		if (console_trylock_spinning())
>  			console_unlock();
>  		preempt_enable();
> -	}
>  
> -	if (pending_output)
> +		wake_up_interruptible(&log_wait);
> +	} else {
>  		wake_up_klogd();
> +	}
>  	return printed_len;
>  }
>  EXPORT_SYMBOL(vprintk_emit);
> ---
> 
> > and could deal with console hardware that involve irq_exit() anyway.
> 
> printk->console_driver->write() does not involve irq.

Hmm, from the article,

https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter

"Since transmission of a single or multiple characters may take a long time
relative to CPU speeds, a UART maintains a flag showing busy status so that the
host system knows if there is at least one character in the transmit buffer or
shift register; "ready for next character(s)" may also be signaled with an
interrupt."
