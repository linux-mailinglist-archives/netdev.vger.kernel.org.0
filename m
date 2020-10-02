Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7567E281150
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387729AbgJBLh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgJBLh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:37:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90050206E3;
        Fri,  2 Oct 2020 11:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601638646;
        bh=52T8DRC2Y31zWxjKo+G6lHo/OWXv9ZVzHIq4b0DDrX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lfud0s9S8MO5/NxyZ+EWr5DzmVTpUhTZMVuFhmjQZos0prsimvXlpK585Nauy6pBb
         /oajtDume8aS8LK5lVyEE2mLFfdakMbwNL0yrXnINoRw/+rrqrZImWoRPvL+B2DmMS
         Dv8kow4aEH3IfZSOj8bCN5eIohFF6dLRafFVW+NQ=
Date:   Fri, 2 Oct 2020 13:37:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Status of orinoco_usb
Message-ID: <20201002113725.GB3292884@kroah.com>
References: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 12:35:17PM +0200, Sebastian Andrzej Siewior wrote:
> I was trying to get rid of the in in_softirq() in ezusb_req_ctx_wait()
> within the orinoco usb driver,
> drivers/net/wireless/intersil/orinoco/orinoco_usb.c. A small snippet:
> 
> | static void ezusb_req_ctx_wait(struct ezusb_priv *upriv,
> |                                struct request_context *ctx)
> …
> |                 if (in_softirq()) {
> |                         /* If we get called from a timer, timeout timers don't
> |                          * get the chance to run themselves. So we make sure
> |                          * that we don't sleep for ever */
> |                         int msecs = DEF_TIMEOUT * (1000 / HZ);
> | 
> |                         while (!try_wait_for_completion(&ctx->done) && msecs--)
> |                                 udelay(1000);
> |                 } else {
> |                         wait_for_completion(&ctx->done);
> …
> | }
> 
> This is broken. The EHCI and XHCI HCD will complete the URB in
> BH/tasklet. Should we ever get here in_softirq() then we will spin
> here/wait here until the timeout passes because the tasklet won't be
> able to run. OHCI/UHCI HCDs still complete in hard-IRQ so it would work
> here.
> 
> Is it possible to end up here in softirq context or is this a relic?

I think it's a relic of where USB host controllers completed their urbs
in hard-irq mode.  The BH/tasklet change is a pretty recent change.

> Well I have no hardware but I see this:
> 
>   orinoco_set_monitor_channel() [I assume that this is fully preemtible]
>   -> orinoco_lock() [this should point to ezusb_lock_irqsave() which
>                      does spin_lock_bh(lock), so from here on
> 		     in_softirq() returns true]
>   -> hw->ops->cmd_wait() [-> ezusb_docmd_wait()]
>   -> ezusb_alloc_ctx() [ sets ctx->in_rid to EZUSB_RID_ACK/0x0710 ]
>   -> ezusb_access_ltv()
>      -> if (ctx->in_rid)
>        -> ezusb_req_ctx_wait(upriv, ctx);
> 	 -> ctx->state should be EZUSB_CTX_REQ_COMPLETE so we end up in
> 	    the while loop above. So we udelay() 3 * 1000 * 1ms = 3sec.
> 	 -> Then ezusb_access_ltv() should return with an error due to
> 	    timeout.
> 
> This isn't limited to exotic features like monitor mode. orinoco_open()
> does orinoco_lock() followed by orinoco_hw_program_rids() which in the
> end invokes ezusb_write_ltv(,, EZUSB_RID_ACK) which is non-zero and also
> would block (ezusb_xmit() would use 0 as the last argument so it won't
> block).
> 
> I don't see how this driver can work on EHCI/XHCI HCD as of today.
> The driver is an orphan since commit
>    3a59babbee409 ("orinoco: update status in MAINTAINERS")
> 
> which is ten years ago. If I replace in_softirq() with a `may_sleep'
> argument then it is still broken.
> Should it be removed?

We can move it out to drivers/staging/ and then drop it to see if anyone
complains that they have the device and is willing to test any changes.

thanks,

greg k-h
