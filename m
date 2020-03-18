Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0667518A823
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 23:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCRW2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 18:28:55 -0400
Received: from ale.deltatee.com ([207.54.116.67]:55828 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCRW2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 18:28:55 -0400
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1jEhAx-0000sH-OT; Wed, 18 Mar 2020 16:28:36 -0600
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
        linuxppc-dev@lists.ozlabs.org
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.521507446@linutronix.de>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9bb6db07-12c4-c272-3a98-baed2ac2f738@deltatee.com>
Date:   Wed, 18 Mar 2020 16:28:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200318204408.521507446@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au, dave@stgolabs.net, oleg@redhat.com, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, davem@davemloft.net, kvalo@codeaurora.org, linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, balbi@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com, kurt.schwemmer@microsemi.com, bigeasy@linutronix.de, arnd@arndb.de, rdunlap@infradead.org, rostedt@goodmis.org, joel@joelfernandes.org, paulmck@kernel.org, will@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE,MYRULES_EXCLUSIVE autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-03-18 2:43 p.m., Thomas Gleixner wrote:
> There is no semantical or functional change:
> 
>   - completions use the exclusive wait mode which is what swait provides
> 
>   - complete() wakes one exclusive waiter
> 
>   - complete_all() wakes all waiters while holding the lock which protects
>     the wait queue against newly incoming waiters. The conversion to swait
>     preserves this behaviour.
> 
> complete_all() might cause unbound latencies with a large number of waiters
> being woken at once, but most complete_all() usage sites are either in
> testing or initialization code or have only a really small number of
> concurrent waiters which for now does not cause a latency problem. Keep it
> simple for now.

Seems like it would be worth adding a note for this to the
complete_all() doc string. Otherwise developers will not likely find out
about this issue and may not keep it as simple as you'd like.

Logan
