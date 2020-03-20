Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF818C7C7
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 08:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgCTG75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 02:59:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCTG75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 02:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iZ+tfXP9s+9EAQeQf95cP5ovh7AcQ3rFatDjmNA0Hpo=; b=SS2stUyn7rcx2bDE5sgbJPy234
        X9zm/vp1W32VRiUAiag9wc6+PVqSgvIgsex3vU9E84yi9emMqCBjOL8b7qfPZtQkzzDv+ofwjR/c0
        QqIG4wFoyXYG03dKfZLr/ByjjOnzQZgMIsED/UXA3TjGOpdi16UiLfl7+s/pKrebSwQXNd9u4pstl
        +qXtTUiOQHDVZkhWsyHsqIFLLUunbIQgVzbJEP1S4/2sDgk9ikKUV9u7HOeGT3pSs1gwB2yhFrrPK
        c3xR/dV7sjrTgGqDl4NyeXhuFf9XPfBkHa1DsefnsUIiMYD5W+PnILH3G4rhCIrK0mmmME0frAQvb
        yfAFAVTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jFBdD-00080q-N8; Fri, 20 Mar 2020 06:59:47 +0000
Date:   Thu, 19 Mar 2020 23:59:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
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
        linux-usb <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch V2 11/15] completion: Use simple wait queues
Message-ID: <20200320065947.GA25206@infradead.org>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.521507446@linutronix.de>
 <CAGRGNgXAW14=8ntTiB_hJ_nLq7WC_oFR3N9BNjqVEZM=ze85tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRGNgXAW14=8ntTiB_hJ_nLq7WC_oFR3N9BNjqVEZM=ze85tQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 10:25:41AM +1100, Julian Calaby wrote:
> > +++ b/drivers/usb/gadget/function/f_fs.c
> > @@ -1703,7 +1703,7 @@ static void ffs_data_put(struct ffs_data
> >                 pr_info("%s(): freeing\n", __func__);
> >                 ffs_data_clear(ffs);
> >                 BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
> > -                      waitqueue_active(&ffs->ep0req_completion.wait) ||
> > +                      swait_active(&ffs->ep0req_completion.wait) ||
> 
> This looks like some code is reaching deep into the dirty dark corners
> of the completion implementation, should there be some wrapper around
> this to hide that?

Or just remote it entirely..
