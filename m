Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2126918B0DE
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 11:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCSKFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 06:05:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgCSKFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 06:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RLVEuHmxmZu2Kjv19dCQm8XyJEDFSZ0VVAjIyaTJTz4=; b=cA/7RqtLr/Y+EQOGncl86ATPPw
        cweMgFaBjTszA8DTL4VjR0rgeOfXlGi0qJnS7dLZxnnFOHXFmGApyQedYDJCpFL05dhOuRf9c2VLk
        DTHRzu55zE7JmJ1wGp00p9ECLFsYQewcR9e101lLVz2OgDrrusFhGzhi02k7CifCPaHHkXQIsFF88
        gFnLBNJ4QSavWSf8Vas3WjQ9VgCyht70rLCAWxZlBoll936eCyRowqIX87sCIe0amQ0xyAmAIlBdz
        WpwQWFFofp4O3pdqfSndw8O5aM9mJkvdU5aZIpAe87UH3oRDCICxapeQfvqC2A38rFMAM9feWpFM6
        8fQpZhZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEs2t-0005hq-Qq; Thu, 19 Mar 2020 10:04:59 +0000
Date:   Thu, 19 Mar 2020 03:04:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Message-ID: <20200319100459.GA18506@infradead.org>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.102694393@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204408.102694393@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:09PM +0100, Thomas Gleixner wrote:
> The PS3 notification interrupt and kthread use a hacked up completion to
> communicate. Since we're wanting to change the completion implementation and
> this is abuse anyway, replace it with a simple rcuwait since there is only ever
> the one waiter.
> 
> AFAICT the kthread uses TASK_INTERRUPTIBLE to not increase loadavg, kthreads
> cannot receive signals by default and this one doesn't look different. Use
> TASK_IDLE instead.

I think the right fix here is to jut convert the thing to a threaded
interrupt handler and kill off the stupid kthread.

But I wonder how alive the whole PS3 support is to start with..
