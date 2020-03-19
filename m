Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF16918AE78
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 09:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCSIk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 04:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSIk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 04:40:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A53D20724;
        Thu, 19 Mar 2020 08:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584607255;
        bh=dHtJENXjO0z7ELO16+oHxTUd6KSiGYOo+FAU1g3r1L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XAF/A62c4v2KZMa+b7MNCvt5Okc6ArSh27nZ6WmkbKaRhYOcWXD+8cWrAPcz+Oxd5
         GcEJnnmipmcEEfVQKgD3elLE172vOeV5zt61gPiItbhWXmp1y4AT19XvauDwP8kAkL
         YnG/UNS29vEd98MwDnk+VTNPMtTHoyQsUCF7HqAk=
Date:   Thu, 19 Mar 2020 09:40:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 04/15] orinoco_usb: Use the regular completion
 interfaces
Message-ID: <20200319084053.GA3492783@kroah.com>
References: <20200318204302.693307984@linutronix.de>
 <20200318204407.793899611@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204407.793899611@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:06PM +0100, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The completion usage in this driver is interesting:
> 
>   - it uses a magic complete function which according to the comment was
>     implemented by invoking complete() four times in a row because
>     complete_all() was not exported at that time.
> 
>   - it uses an open coded wait/poll which checks completion:done. Only one wait
>     side (device removal) uses the regular wait_for_completion() interface.
> 
> The rationale behind this is to prevent that wait_for_completion() consumes
> completion::done which would prevent that all waiters are woken. This is not
> necessary with complete_all() as that sets completion::done to UINT_MAX which
> is left unmodified by the woken waiters.
> 
> Replace the magic complete function with complete_all() and convert the
> open coded wait/poll to regular completion interfaces.
> 
> This changes the wait to exclusive wait mode. But that does not make any
> difference because the wakers use complete_all() which ignores the
> exclusive mode.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
> V2: New patch to avoid conversion to swait functions later.
> ---
>  drivers/net/wireless/intersil/orinoco/orinoco_usb.c |   21 ++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> --- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
> +++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
> @@ -365,17 +365,6 @@ static struct request_context *ezusb_all
>  	return ctx;
>  }
>  
> -
> -/* Hopefully the real complete_all will soon be exported, in the mean
> - * while this should work. */
> -static inline void ezusb_complete_all(struct completion *comp)
> -{
> -	complete(comp);
> -	complete(comp);
> -	complete(comp);
> -	complete(comp);
> -}

That's so funny... :(

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
