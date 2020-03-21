Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE918DF80
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 11:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgCUKmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 06:42:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37993 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgCUKmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 06:42:15 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFbZX-0001a5-00; Sat, 21 Mar 2020 11:41:43 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 5D7DDFFC8D; Sat, 21 Mar 2020 11:41:42 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
In-Reply-To: <20200319100459.GA18506@infradead.org>
References: <20200318204302.693307984@linutronix.de> <20200318204408.102694393@linutronix.de> <20200319100459.GA18506@infradead.org>
Date:   Sat, 21 Mar 2020 11:41:42 +0100
Message-ID: <8736a2rnvd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Mar 18, 2020 at 09:43:09PM +0100, Thomas Gleixner wrote:
>> The PS3 notification interrupt and kthread use a hacked up completion to
>> communicate. Since we're wanting to change the completion implementation and
>> this is abuse anyway, replace it with a simple rcuwait since there is only ever
>> the one waiter.
>> 
>> AFAICT the kthread uses TASK_INTERRUPTIBLE to not increase loadavg, kthreads
>> cannot receive signals by default and this one doesn't look different. Use
>> TASK_IDLE instead.
>
> I think the right fix here is to jut convert the thing to a threaded
> interrupt handler and kill off the stupid kthread.

That'd be a major surgery.

> But I wonder how alive the whole PS3 support is to start with..

There seem to be a few enthusiast left which have a Other-OS capable PS3

Thanks,

        tglx

