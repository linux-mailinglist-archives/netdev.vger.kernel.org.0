Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4518AE7B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 09:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgCSIlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 04:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgCSIlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 04:41:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237512072C;
        Thu, 19 Mar 2020 08:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584607277;
        bh=Ax69JWe2mAO3MiZ3t8XP/HcweZkT7pxlhXJ1svHjTis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZqqpZ2jqJGbiLh1O9e+6Zp6HeAL9Yj2e7wjAbOpeJv419lkji1jaJB7nHjmMhGzm
         7GPB5mhSV879Jnm+FzyKpqgQIUxX3FrelEzxKQJHyPfzrXshDpuEU831YrsdrjaF5K
         ZKnx/byPP6ThnVhPThevhoLaMVz4u7vaQJ77K2II=
Date:   Thu, 19 Mar 2020 09:41:15 +0100
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
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 03/15] usb: gadget: Use completion interface instead
 of open coding it
Message-ID: <20200319084115.GB3492783@kroah.com>
References: <20200318204302.693307984@linutronix.de>
 <20200318204407.700914073@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204407.700914073@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:05PM +0100, Thomas Gleixner wrote:
> ep_io() uses a completion on stack and open codes the waiting with:
> 
>   wait_event_interruptible (done.wait, done.done);
> and
>   wait_event (done.wait, done.done);
> 
> This waits in non-exclusive mode for complete(), but there is no reason to
> do so because the completion can only be waited for by the task itself and
> complete() wakes exactly one exlusive waiter.
> 
> Replace the open coded implementation with the corresponding
> wait_for_completion*() functions.
> 
> No functional change.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
> V2: New patch to avoid the conversion to swait interfaces later
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
