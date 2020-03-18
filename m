Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E09F18A6E8
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgCRVZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRVZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 17:25:16 -0400
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A267920772;
        Wed, 18 Mar 2020 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584566716;
        bh=PPihHaGg1zzpn1nHu5VlZHYT+H8Lm/yb44OJhzptGDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=J4R5BuBT7s0ufQ6OkQFm2DJaGU3GVO9cGs2MX4LtzTi7i9JWE5dM20xu5JQTXlZ83
         PEvcq3DTg4VilmyOANCyGwCHYadT4otbhpLYSpa8TZJkQXYvR3a8J+LlUM3ulELzZx
         jLKhC0M9bULug4AxIw26CRfmCEZy/H4Ad8J0WRnI=
Date:   Wed, 18 Mar 2020 16:25:13 -0500
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
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 01/15] PCI/switchtec: Fix init_completion race
 condition with poll_wait()
Message-ID: <20200318212513.GA240916@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204407.497942274@linutronix.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:03PM +0100, Thomas Gleixner wrote:
> From: Logan Gunthorpe <logang@deltatee.com>
> 
> The call to init_completion() in mrpc_queue_cmd() can theoretically
> race with the call to poll_wait() in switchtec_dev_poll().
> 
>   poll()			write()
>     switchtec_dev_poll()   	  switchtec_dev_write()
>       poll_wait(&s->comp.wait);      mrpc_queue_cmd()
> 			               init_completion(&s->comp)
> 				         init_waitqueue_head(&s->comp.wait)
> 
> To my knowledge, no one has hit this bug.
> 
> Fix this by using reinit_completion() instead of init_completion() in
> mrpc_queue_cmd().
> 
> Fixes: 080b47def5e5 ("MicroSemi Switchtec management interface driver")
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lkml.kernel.org/r/20200313183608.2646-1-logang@deltatee.com

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Not because I understand and have reviewed this, but because I trust
you to do the right thing and it belongs with the rest of the series.

> ---
>  drivers/pci/switch/switchtec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
> index a823b4b8ef8a..81dc7ac01381 100644
> --- a/drivers/pci/switch/switchtec.c
> +++ b/drivers/pci/switch/switchtec.c
> @@ -175,7 +175,7 @@ static int mrpc_queue_cmd(struct switchtec_user *stuser)
>  	kref_get(&stuser->kref);
>  	stuser->read_len = sizeof(stuser->data);
>  	stuser_set_state(stuser, MRPC_QUEUED);
> -	init_completion(&stuser->comp);
> +	reinit_completion(&stuser->comp);
>  	list_add_tail(&stuser->list, &stdev->mrpc_queue);
>  
>  	mrpc_cmd_submit(stdev);
> -- 
> 2.20.1
> 
> 
