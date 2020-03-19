Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D91CA18BA4C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgCSPEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:04:30 -0400
Received: from ms.lwn.net ([45.79.88.28]:33904 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgCSPE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 11:04:29 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id DB45F384;
        Thu, 19 Mar 2020 15:04:27 +0000 (UTC)
Date:   Thu, 19 Mar 2020 09:04:26 -0600
From:   Jonathan Corbet <corbet@lwn.net>
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
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200319090426.512510cb@lwn.net>
In-Reply-To: <20200318204408.211530902@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
        <20200318204408.211530902@linutronix.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 21:43:10 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The kernel provides a variety of locking primitives. The nesting of these
> lock types and the implications of them on RT enabled kernels is nowhere
> documented.
> 
> Add initial documentation.

...time to add a a couple of nits...:)

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> V2: Addressed review comments from Randy
> ---
>  Documentation/locking/index.rst     |    1 
>  Documentation/locking/locktypes.rst |  298 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 299 insertions(+)
>  create mode 100644 Documentation/locking/locktypes.rst
> 
> --- a/Documentation/locking/index.rst
> +++ b/Documentation/locking/index.rst
> @@ -7,6 +7,7 @@ locking
>  .. toctree::
>      :maxdepth: 1
>  
> +    locktypes
>      lockdep-design
>      lockstat
>      locktorture
> --- /dev/null
> +++ b/Documentation/locking/locktypes.rst
> @@ -0,0 +1,298 @@
> +.. _kernel_hacking_locktypes:
> +

So ... I vaguely remember that some Thomas guy added a document saying we
should be putting SPDX tags on our files? :)

> +==========================
> +Lock types and their rules
> +==========================

[...]

> +PREEMPT_RT caveats
> +==================
> +
> +spinlock_t and rwlock_t
> +-----------------------
> +
> +The substitution of spinlock_t and rwlock_t on PREEMPT_RT enabled kernels
> +with RT-mutex based implementations has a few implications.
> +
> +On a non PREEMPT_RT enabled kernel the following code construct is
> +perfectly fine::
> +
> +   local_irq_disable();
> +   spin_lock(&lock);
> +
> +and fully equivalent to::
> +
> +   spin_lock_irq(&lock);
> +
> +Same applies to rwlock_t and the _irqsave() suffix variant.
> +
> +On a PREEMPT_RT enabled kernel this breaks because the RT-mutex
> +substitution expects a fully preemptible context.
> +
> +The preferred solution is to use :c:func:`spin_lock_irq()` or
> +:c:func:`spin_lock_irqsave()` and their unlock counterparts.

We don't need (and shouldn't use) :c:func: anymore; just saying
spin_lock_irq() will cause the Right Things to happen.

Thanks,
jon
