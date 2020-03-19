Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8D218AFB8
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgCSJTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 05:19:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgCSJTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 05:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=SB/qCDEi+ZlLoLxSkMyuujlTlFYXH48WLPTca/+wLJY=; b=NwKhFNciaaQRedaPUzwWPcEuDO
        6YVQI3gxcvsFKcY2D95xHQnwZQ6Fq7XXnfo4XgG40qTzyiZHbhFfhMxGGXxMXL5nOdm9z64lms9Z+
        MX1zySziAorbSKFBt7djHH284Q+NJF6Bb99TR0xCyf+90inBaIDUn//3J4VlfMgAhymPi6uBU+vmN
        JUAT7xa4tCtk6ndbnC5NazgC8uPsUvQyULtff1Ve5ZeXuOYhtibKip39ePOa8ICTYje92d/Ntl5jK
        VrGi7zImBW85bGdyp0jXcfivDfYp8D/VIudF0S6oSHSTX5GpQUuBccuLm4TkctWy6ecIxYgPnnbEz
        X6WpnIEA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jErKJ-0001Bz-4R; Thu, 19 Mar 2020 09:18:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4ABB83013A4;
        Thu, 19 Mar 2020 10:18:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31213285F232E; Thu, 19 Mar 2020 10:18:50 +0100 (CET)
Date:   Thu, 19 Mar 2020 10:18:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
Message-ID: <20200319091850.GM20730@hirez.programming.kicks-ass.net>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.102694393@linutronix.de>
 <20200319090024.wbrywc77tff3ro7i@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200319090024.wbrywc77tff3ro7i@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 10:00:24AM +0100, Sebastian Andrzej Siewior wrote:
> On 2020-03-18 21:43:09 [+0100], Thomas Gleixner wrote:
> > --- a/arch/powerpc/platforms/ps3/device-init.c
> > +++ b/arch/powerpc/platforms/ps3/device-init.c
> > @@ -725,12 +728,12 @@ static int ps3_notification_read_write(s
> >  	unsigned long flags;
> >  	int res;
> >  
> > -	init_completion(&dev->done);
> >  	spin_lock_irqsave(&dev->lock, flags);
> >  	res = write ? lv1_storage_write(dev->sbd.dev_id, 0, 0, 1, 0, lpar,
> >  					&dev->tag)
> >  		    : lv1_storage_read(dev->sbd.dev_id, 0, 0, 1, 0, lpar,
> >  				       &dev->tag);
> > +	dev->done = false;
> >  	spin_unlock_irqrestore(&dev->lock, flags);
> >  	if (res) {
> >  		pr_err("%s:%u: %s failed %d\n", __func__, __LINE__, op, res);
> > @@ -738,14 +741,10 @@ static int ps3_notification_read_write(s
> >  	}
> >  	pr_debug("%s:%u: notification %s issued\n", __func__, __LINE__, op);
> >  
> > -	res = wait_event_interruptible(dev->done.wait,
> > -				       dev->done.done || kthread_should_stop());
> > +	rcuwait_wait_event(&dev->wait, dev->done || kthread_should_stop(), TASK_IDLE);
> > +
> …
> 
> Not sure it matters but this struct `dev' is allocated on stack. Should
> the interrupt fire *before* rcuwait_wait_event() set wait.task to NULL
> then it is of random value on the first invocation of rcuwait_wake_up().
> ->
> 
> diff --git a/arch/powerpc/platforms/ps3/device-init.c b/arch/powerpc/platforms/ps3/device-init.c
> index 197347c3c0b24..e87360a0fb40d 100644
> --- a/arch/powerpc/platforms/ps3/device-init.c
> +++ b/arch/powerpc/platforms/ps3/device-init.c
> @@ -809,6 +809,7 @@ static int ps3_probe_thread(void *data)
>  	}
>  
>  	spin_lock_init(&dev.lock);
> +	rcuwait_init(&dev.wait);
>  
>  	res = request_irq(irq, ps3_notification_interrupt, 0,
>  			  "ps3_notification", &dev);
> 

Very good, sorry for that.
