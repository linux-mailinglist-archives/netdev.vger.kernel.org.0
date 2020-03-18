Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CF918A7CE
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 23:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCRWMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 18:12:44 -0400
Received: from ale.deltatee.com ([207.54.116.67]:55594 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCRWMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 18:12:43 -0400
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1jEgut-0000dp-Ap; Wed, 18 Mar 2020 16:12:00 -0600
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
References: <20200318204302.693307984@linutronix.de>
 <20200318204407.607241357@linutronix.de>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <2256dbd5-8f1d-70c5-8855-855638ce3ef4@deltatee.com>
Date:   Wed, 18 Mar 2020 16:11:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200318204407.607241357@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: linuxppc-dev@lists.ozlabs.org, arnd@arndb.de, mpe@ellerman.id.au, dave@stgolabs.net, oleg@redhat.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, davem@davemloft.net, kvalo@codeaurora.org, linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, balbi@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com, kurt.schwemmer@microsemi.com, bigeasy@linutronix.de, rdunlap@infradead.org, rostedt@goodmis.org, joel@joelfernandes.org, paulmck@kernel.org, will@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE,MYRULES_EXCLUSIVE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.2
Subject: Re: [patch V2 02/15] pci/switchtec: Replace completion wait queue
 usage for poll
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-03-18 2:43 p.m., Thomas Gleixner wrote:
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

While I've been against open coding the completion in this driver for a
while, I'm convinced by the EPOLLEXCLUSIVE argument for this change.
I've reviewed and lightly tested the change with hardware:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks,

Logan

> Cc: Kurt Schwemmer <kurt.schwemmer@microsemi.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
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
