Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDC41B2011
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgDUHlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgDUHlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 03:41:08 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765932084D;
        Tue, 21 Apr 2020 07:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587454867;
        bh=Nbpcjvf4OfQ6/2rbNcF4XSAXJpyKzoe6+kQqdiYXyL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ux6xM77N6e3zjcMhKqKkdPDzL8BNNWgNngXIeQat43yqC0nlQLUhfbDvC0IRskK4a
         lzXX4ZT/0h9u4DpM21iqQivITIIy8PZvfZnm9XI2slLBPWpJY6DkcnyZ0ZnL+Yq49u
         drScS8rGC++743FnPenRISkU6YuS2/Gft9+GbSfU=
Date:   Tue, 21 Apr 2020 08:41:02 +0100
From:   Will Deacon <will@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Alex Belits <abelits@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v3 03/13] task_isolation: add instruction
 synchronization memory barrier
Message-ID: <20200421074101.GA15021@willie-the-truck>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
 <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
 <d995795c731d6ecceb36bdf1c1df3d72fefd023d.camel@marvell.com>
 <20200415124427.GB28304@C02TD0UTHF1T.local>
 <e4d2cda6f011e80a0d8e482b85bca1c57665fcfd.camel@marvell.com>
 <20200420122350.GB12889@willie-the-truck>
 <20200420123628.GB69441@C02TD0UTHF1T.local>
 <20200420135523.GA18711@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420135523.GA18711@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 02:55:23PM +0100, Will Deacon wrote:
> On Mon, Apr 20, 2020 at 01:36:28PM +0100, Mark Rutland wrote:
> > On Mon, Apr 20, 2020 at 01:23:51PM +0100, Will Deacon wrote:
> > > IIUC, we don't need to do anything on arm64 because taking an exception acts
> > > as a context synchronization event, so I don't think you should try to
> > > expose this as a new barrier macro. Instead, just make it a pre-requisite
> > > that architectures need to ensure this behaviour when entering the kernel
> > > from userspace if they are to select HAVE_ARCH_TASK_ISOLATION.
> > 
> > The CSE from the exception isn't sufficient here, because it needs to
> > occur after the CPU has re-registered to receive IPIs for
> > kick_all_cpus_sync(). Otherwise there's a window between taking the
> > exception and re-registering where a necessary context synchronization
> > event can be missed. e.g.
> > 
> > CPU A				CPU B
> > [ Modifies some code ]		
> > 				[ enters exception ]
> > [ D cache maintenance ]
> > [ I cache maintenance ]
> > [ IPI ]				// IPI not taken
> >   ...				[ register for IPI ] 
> > [ IPI completes ] 
> > 				[ execute stale code here ]
> 
> Thanks.
> 
> > However, I think 'IMB' is far too generic, and we should have an arch
> > hook specific to task isolation, as it's far less likely to be abused as
> > IMB will.
> 
> What guarantees we don't run any unsynchronised module code between
> exception entry and registering for the IPI? It seems like we'd want that
> code to run as early as possible, e.g. as part of
> task_isolation_user_exit() but that doesn't seem to be what's happening.

Sorry, I guess that's more a question for Alex.

Alex -- do you think we could move the "register for IPI" step earlier
so that it's easier to reason about the code that runs in the dead zone
during exception entry?

Will
