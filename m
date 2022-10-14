Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C608F5FEEB9
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJNNfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJNNfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:35:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12914D274
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=sklxLmCw6q5TUWkZXhxlV+TewM+gvpE5fEdVDt2mW/8=; b=NG
        Gxfr/YMagbnrPeqR1W1g1r3qI2gQx11a3fUBOe8wZXWHTPKeFDapLQpwHX2knCxGvNx6EzJL+h4GK
        bq5FRYHzLOvoV4CqutoX61wPoH5cH5fOP4ytMjnKz3dZSB7mO6wYLC28KQdwM8RqmHaAgwz23thma
        /MH0ijE6wlyvbH0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ojKqQ-001yQp-Q7; Fri, 14 Oct 2022 15:35:22 +0200
Date:   Fri, 14 Oct 2022 15:35:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <Y0llmkQqmWLDLm52@lunn.ch>
References: <20221014103443.138574-1-ihuguet@redhat.com>
 <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 02:43:47PM +0200, Íñigo Huguet wrote:
> On Fri, Oct 14, 2022 at 2:14 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Fix trying to acquire rtnl_lock at the beginning of those functions, and
> > > returning if NIC closing is ongoing. Also do the "linkstate" stuff in a
> > > workqueue instead than in a threaded irq, where sleeping or waiting a
> > > mutex for a long time is discouraged.
> >
> > What happens when the same interrupt fires again, while the work queue
> > is still active? The advantage of the threaded interrupt handler is
> > that the interrupt will be kept disabled, and should not fire again
> > until the threaded interrupt handler exits.
> 
> Nothing happens, if it's already queued, it won't be queued again, and
> when it runs it will evaluate the last link state. And in the worst
> case, it will be enqueued to run again, and if linkstate has changed
> it will be evaluated again. This will rarely happen and it's harmless.
> 
> Also, I haven't checked it but these lines suggest that the IRQ is
> auto-disabled in the hw until you enable it again. I didn't rely on
> this, anyway.
>         self->aq_hw_ops->hw_irq_enable(self->aq_hw,
>                                        BIT(self->aq_nic_cfg.link_irq_vec));
> 
> Honestly I was a bit in doubt on doing this, with the threaded irq it
> would also work. I'd like to hear more opinions about this and I can
> change it back.

Ethernet PHYs do all there interrupt handling in threaded IRQs. That
can require a number of MDIO transactions. So we can be talking about
64 bits at 2.5MHz, so 25uS or more. We have not seen issues with that.

> > If MACSEC is enabled, aq_nic_update_link_status() is called with RTNL
> > held. If it is not enabled, RTNL is not held. This sort of
> > inconsistency could lead to further locking bugs, since it is not
> > obvious. Please try to make this consistent.
> 
> This is not new in these patches, that's what was already happening, I
> just moved it to get the lock a bit earlier. In my opinion, this is as
> it should be: why acquire a mutex if you don't have anything to
> protect with it? And it's worse with rtnl_lock which is held by many
> processes, and can be held for quite long times...

Maybe the lock needs to be moved closer to what actually needs to be
protect? What is it protecting?

	 Andrew
