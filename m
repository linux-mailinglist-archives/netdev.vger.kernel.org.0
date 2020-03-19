Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3875E18AEC7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 09:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCSIwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 04:52:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:35642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgCSIwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 04:52:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 25E85B117;
        Thu, 19 Mar 2020 08:52:16 +0000 (UTC)
Date:   Thu, 19 Mar 2020 01:51:09 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
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
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200319085109.vrvmpesytul3ek3e@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.211530902@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200318204408.211530902@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020, Thomas Gleixner wrote:
>+Owner semantics
>+===============
>+
>+Most lock types in the Linux kernel have strict owner semantics, i.e. the
>+context (task) which acquires a lock has to release it.
>+
>+There are two exceptions:
>+
>+  - semaphores
>+  - rwsems
>+
>+semaphores have no strict owner semantics for historical reasons. They are

I would rephrase this to:

semaphores have no owner semantics for historical reason, and as such
trylock and release operations can be called from interrupt context. They
are ...

>+often used for both serialization and waiting purposes. That's generally
>+discouraged and should be replaced by separate serialization and wait
>+mechanisms.
            ^ , such as mutexes or completions.

>+
>+rwsems have grown interfaces which allow non owner release for special
>+purposes. This usage is problematic on PREEMPT_RT because PREEMPT_RT
>+substitutes all locking primitives except semaphores with RT-mutex based
>+implementations to provide priority inheritance for all lock types except
>+the truly spinning ones. Priority inheritance on ownerless locks is
>+obviously impossible.
>+
>+For now the rwsem non-owner release excludes code which utilizes it from
>+being used on PREEMPT_RT enabled kernels. In same cases this can be
>+mitigated by disabling portions of the code, in other cases the complete
>+functionality has to be disabled until a workable solution has been found.

Thanks,
Davidlohr
