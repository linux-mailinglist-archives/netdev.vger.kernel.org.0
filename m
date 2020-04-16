Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492AD1AC84F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437398AbgDPPGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392342AbgDPNwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:52:12 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83F1C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:52:11 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jP4vy-0002sr-Sr; Thu, 16 Apr 2020 15:52:02 +0200
Date:   Thu, 16 Apr 2020 15:52:02 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net 1/2] amd-xgbe: Use __napi_schedule() in BH context
Message-ID: <20200416135202.txc5kwibczh5vl4c@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-2-bigeasy@linutronix.de>
 <9c632f8c-96a5-bb01-bac5-6aa0be58166a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c632f8c-96a5-bb01-bac5-6aa0be58166a@amd.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-02 11:19:00 [-0600], Tom Lendacky wrote:
> On 11/26/19 4:20 PM, Sebastian Andrzej Siewior wrote:
> > The driver uses __napi_schedule_irqoff() which is fine as long as it is
> > invoked with disabled interrupts by everybody. Since the commit
> > mentioned below the driver may invoke xgbe_isr_task() in tasklet/softirq
> > context. This may lead to list corruption if another driver uses
> > __napi_schedule_irqoff() in IRQ context.
> > 
> > Use __napi_schedule() which safe to use from IRQ and softirq context.
> > 
> > Fixes: 85b85c853401d ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

*ping*
This still applies and is independent of the conversation in 2/2.

> > ---
> >  drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> > index 98f8f20331544..3bd20f7651207 100644
> > --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> > +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> > @@ -514,7 +514,7 @@ static void xgbe_isr_task(unsigned long data)
> >  				xgbe_disable_rx_tx_ints(pdata);
> >  
> >  				/* Turn on polling */
> > -				__napi_schedule_irqoff(&pdata->napi);
> > +				__napi_schedule(&pdata->napi);
> >  			}
> >  		} else {
> >  			/* Don't clear Rx/Tx status if doing per channel DMA
> > 

Sebastian
