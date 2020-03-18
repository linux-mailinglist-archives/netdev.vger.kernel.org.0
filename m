Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6759618A6EF
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCRV0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCRV0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 17:26:42 -0400
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A258F20772;
        Wed, 18 Mar 2020 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584566801;
        bh=1vEeYFZKs+pqphscw5LB3ggCm30tEd47/HI2FhiZYUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Q/k/7g6Fs8MEcVqp9/2TZdaWhoFsMx+/onLyytrPDHvgE7rsxzjDskMuxtp1gXUyp
         Wi8odsF7QYIzY8B/+b/sb2a70+RZ3Hw1++0HvDbEESz4VY9HIVMcyf/qe7Y3lXxsgr
         qFhaS+Q26CaVOqmqGEp0gY8SFNEjRw7VXlRty4cQ=
Date:   Wed, 18 Mar 2020 16:26:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-pci@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 02/15] pci/switchtec: Replace completion wait queue
 usage for poll
Message-ID: <20200318212639.GA242647@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204407.607241357@linutronix.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:04PM +0100, Thomas Gleixner wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The poll callback is using the completion wait queue and sticks it into
> poll_wait() to wake up pollers after a command has completed.
> 
> This works to some extent, but cannot provide EPOLLEXCLUSIVE support
> because the waker side uses complete_all() which unconditionally wakes up
> all waiters. complete_all() is required because completions internally use
> exclusive wait and complete() only wakes up one waiter by default.
> 
> This mixes conceptually different mechanisms and relies on internal
> implementation details of completions, which in turn puts contraints on
> changing the internal implementation of completions.
> 
> Replace it with a regular wait queue and store the state in struct
> switchtec_user.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Kurt Schwemmer <kurt.schwemmer@microsemi.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

But please tweak the subject so it matches the other:

  - pci/switchtec: Replace completion wait queue usage for poll
  + PCI/switchtec: Replace completion wait queue usage for poll

> ---
> V2: Reworded changelog.
> ---
>  drivers/pci/switch/switchtec.c |   22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> --- a/drivers/pci/switch/switchtec.c
> +++ b/drivers/pci/switch/switchtec.c
> @@ -52,10 +52,11 @@ struct switchtec_user {
>  
>  	enum mrpc_state state;
>  
> -	struct completion comp;
> +	wait_queue_head_t cmd_comp;
>  	struct kref kref;
>  	struct list_head list;
>  
> +	bool cmd_done;
>  	u32 cmd;
>  	u32 status;
>  	u32 return_code;
> @@ -77,7 +78,7 @@ static struct switchtec_user *stuser_cre
>  	stuser->stdev = stdev;
>  	kref_init(&stuser->kref);
>  	INIT_LIST_HEAD(&stuser->list);
> -	init_completion(&stuser->comp);
> +	init_waitqueue_head(&stuser->cmd_comp);
>  	stuser->event_cnt = atomic_read(&stdev->event_cnt);
>  
>  	dev_dbg(&stdev->dev, "%s: %p\n", __func__, stuser);
> @@ -175,7 +176,7 @@ static int mrpc_queue_cmd(struct switcht
>  	kref_get(&stuser->kref);
>  	stuser->read_len = sizeof(stuser->data);
>  	stuser_set_state(stuser, MRPC_QUEUED);
> -	reinit_completion(&stuser->comp);
> +	stuser->cmd_done = false;
>  	list_add_tail(&stuser->list, &stdev->mrpc_queue);
>  
>  	mrpc_cmd_submit(stdev);
> @@ -222,7 +223,8 @@ static void mrpc_complete_cmd(struct swi
>  		memcpy_fromio(stuser->data, &stdev->mmio_mrpc->output_data,
>  			      stuser->read_len);
>  out:
> -	complete_all(&stuser->comp);
> +	stuser->cmd_done = true;
> +	wake_up_interruptible(&stuser->cmd_comp);
>  	list_del_init(&stuser->list);
>  	stuser_put(stuser);
>  	stdev->mrpc_busy = 0;
> @@ -529,10 +531,11 @@ static ssize_t switchtec_dev_read(struct
>  	mutex_unlock(&stdev->mrpc_mutex);
>  
>  	if (filp->f_flags & O_NONBLOCK) {
> -		if (!try_wait_for_completion(&stuser->comp))
> +		if (!stuser->cmd_done)
>  			return -EAGAIN;
>  	} else {
> -		rc = wait_for_completion_interruptible(&stuser->comp);
> +		rc = wait_event_interruptible(stuser->cmd_comp,
> +					      stuser->cmd_done);
>  		if (rc < 0)
>  			return rc;
>  	}
> @@ -580,7 +583,7 @@ static __poll_t switchtec_dev_poll(struc
>  	struct switchtec_dev *stdev = stuser->stdev;
>  	__poll_t ret = 0;
>  
> -	poll_wait(filp, &stuser->comp.wait, wait);
> +	poll_wait(filp, &stuser->cmd_comp, wait);
>  	poll_wait(filp, &stdev->event_wq, wait);
>  
>  	if (lock_mutex_and_test_alive(stdev))
> @@ -588,7 +591,7 @@ static __poll_t switchtec_dev_poll(struc
>  
>  	mutex_unlock(&stdev->mrpc_mutex);
>  
> -	if (try_wait_for_completion(&stuser->comp))
> +	if (stuser->cmd_done)
>  		ret |= EPOLLIN | EPOLLRDNORM;
>  
>  	if (stuser->event_cnt != atomic_read(&stdev->event_cnt))
> @@ -1272,7 +1275,8 @@ static void stdev_kill(struct switchtec_
>  
>  	/* Wake up and kill any users waiting on an MRPC request */
>  	list_for_each_entry_safe(stuser, tmpuser, &stdev->mrpc_queue, list) {
> -		complete_all(&stuser->comp);
> +		stuser->cmd_done = true;
> +		wake_up_interruptible(&stuser->cmd_comp);
>  		list_del_init(&stuser->list);
>  		stuser_put(stuser);
>  	}
> 
