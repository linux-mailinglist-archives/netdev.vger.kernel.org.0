Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67A195E60
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgC0TO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:14:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0TO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=wi9sMkFTjgwfQzFt05plG4rnAYvM3lDU42pKvwyq4Dk=; b=ARU9xHbF+qAAz2eVBrwRTExEhX
        jwbbaXg4N6bxYjwT1WFJStJwWCN9ZHaVD3NmDI1LZV1T0tf4AIdqj5K2taxObMmf+eMC0i5CbjuQu
        cvF7lxBZu5bLZ+0AdIzFsdJG1EATpc/ptIx2pCL2bB+g/yJEKAss2RthpcAMSl290YviOrnbOvJlX
        ikCrnWobf8fDzpkViu46vqNLHYHj5LdPU4VdWSuQTRIwjeJYR5Vvgah5hoQLR7Vo5XfSfN1jnONov
        0vwoM1oP/OGhYcNpgo1xpE+4HqhYQCyvKV32Q/9MINxoqL2BVCx+yMkvLrwb/lioD1mQXbZAvA7f/
        wH3hOZwQ==;
Received: from [2602:306:37b0:7840:b51a:dd8c:5d76:65e]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHuRN-0006Pi-D5; Fri, 27 Mar 2020 19:14:49 +0000
Subject: Re: [patch V3 12/20] powerpc/ps3: Convert half completion to rcuwait
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200321112544.878032781@linutronix.de>
 <20200321113241.930037873@linutronix.de>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <f3210d53-dfb1-6bbc-cc82-832105fcfaa2@infradead.org>
Date:   Fri, 27 Mar 2020 12:14:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200321113241.930037873@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/21/20 4:25 AM, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The PS3 notification interrupt and kthread use a hacked up completion to
> communicate. Since we're wanting to change the completion implementation and
> this is abuse anyway, replace it with a simple rcuwait since there is only ever
> the one waiter.
> 
> AFAICT the kthread uses TASK_INTERRUPTIBLE to not increase loadavg, kthreads
> cannot receive signals by default and this one doesn't look different. Use
> TASK_IDLE instead.

I tested the patch set applied against v5.6-rc7 on the PS3 and it worked
as expected.

Tested by: Geoff Levand <geoff@infradead.org>

