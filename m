Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB0A18CBED
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgCTKpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:45:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33516 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgCTKpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 06:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gpF47OFbSCOaH9j5hP1QeTQDztS/I2yzYL1A8Yg/DCI=; b=m8gRkUViv+3RtA+3AN1Hq8RB2p
        /nd8koJA7/ftGKlqVgXGyTS1/R5zs5CBqOx+xx+6K9nCiYjvgKGyw0YC0ClboDv10bRHr9uFVti5l
        EKvrd8vTTtGuSCXjYHyBDIj5z1uJ87Gimm+Jq3l7cxSmAzKhoX5U0dufJsqNv3jrKQNIBSslh2ZBx
        d6J4/8w72QCJsw2WMsEdzs02t4aMmq5QQ4FsVoSmBkcn0g/+PBYsMy74VM0WnvU6eDHMxJ7NO6YW7
        oGhprUfFSJmuJzo+np93Zq4slkqAXWnt+jp4L4s7owS9q9n3ZLlPNQHf+KIrDpK7Ir2rNYPzd9bem
        57qKm1WQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFF8f-0006yB-F2; Fri, 20 Mar 2020 10:44:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 627F2300606;
        Fri, 20 Mar 2020 11:44:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 48697285E2762; Fri, 20 Mar 2020 11:44:26 +0100 (CET)
Date:   Fri, 20 Mar 2020 11:44:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     tglx@linutronix.de, arnd@arndb.de, balbi@kernel.org,
        bhelgaas@google.com, bigeasy@linutronix.de, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, rdunlap@infradead.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 17/15] rcuwait: Inform rcuwait_wake_up() users if a
 wakeup was attempted
Message-ID: <20200320104426.GD20696@hirez.programming.kicks-ass.net>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-2-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320085527.23861-2-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 01:55:25AM -0700, Davidlohr Bueso wrote:

> diff --git a/kernel/exit.c b/kernel/exit.c
> index 6cc6cc485d07..b0bb0a8ec4b1 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -234,9 +234,10 @@ void release_task(struct task_struct *p)
>  		goto repeat;
>  }
>  
> -void rcuwait_wake_up(struct rcuwait *w)
> +bool rcuwait_wake_up(struct rcuwait *w)
>  {
>  	struct task_struct *task;
> +	bool ret = false;
>  
>  	rcu_read_lock();
>  
> @@ -254,10 +255,15 @@ void rcuwait_wake_up(struct rcuwait *w)
>  	smp_mb(); /* (B) */
>  
>  	task = rcu_dereference(w->task);
> -	if (task)
> +	if (task) {
>  		wake_up_process(task);
> +	        ret = true;

		ret = wake_up_process(task); ?

> +	}
>  	rcu_read_unlock();
> +
> +	return ret;
>  }
> +EXPORT_SYMBOL_GPL(rcuwait_wake_up);
