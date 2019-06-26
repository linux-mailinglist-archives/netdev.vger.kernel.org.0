Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC01567B8
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfFZLg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:36:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:44212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbfFZLg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 07:36:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2502AB9B;
        Wed, 26 Jun 2019 11:36:25 +0000 (UTC)
Date:   Wed, 26 Jun 2019 20:36:19 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 01/16] qlge: Remove irq_cnt
Message-ID: <20190626113619.GA27420@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <DM6PR18MB2697814343012B4363482290ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB2697814343012B4363482290ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/26 08:59, Manish Chopra wrote:
> > -----Original Message-----
> > From: Benjamin Poirier <bpoirier@suse.com>
> > Sent: Monday, June 17, 2019 1:19 PM
> > To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> > NIC-Dev@marvell.com>; netdev@vger.kernel.org
> > Subject: [PATCH net-next 01/16] qlge: Remove irq_cnt
> > 
> > qlge uses an irq enable/disable refcounting scheme that is:
> > * poorly implemented
> > 	Uses a spin_lock to protect accesses to the irq_cnt atomic variable
> > * buggy
> > 	Breaks when there is not a 1:1 sequence of irq - napi_poll, such as
> > 	when using SO_BUSY_POLL.
> > * unnecessary
> > 	The purpose or irq_cnt is to reduce irq control writes when
> > 	multiple work items result from one irq: the irq is re-enabled
> > 	after all work is done.
> > 	Analysis of the irq handler shows that there is only one case where
> > 	there might be two workers scheduled at once, and those have
> > 	separate irq masking bits.
> 
> I believe you are talking about here for asic error recovery worker and MPI worker.
> Which separate IRQ masking bits are you referring here ?

INTR_EN with intr_dis_mask for completion interrupts
INTR_MASK bit INTR_MASK_PI for mpi interrupts

> >  static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const char *str)
> > @@ -2500,21 +2451,22 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
> >  	u32 var;
> >  	int work_done = 0;
> > 
> > -	spin_lock(&qdev->hw_lock);
> > -	if (atomic_read(&qdev->intr_context[0].irq_cnt)) {
> > -		netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
> > -			     "Shared Interrupt, Not ours!\n");
> > -		spin_unlock(&qdev->hw_lock);
> > -		return IRQ_NONE;
> > -	}
> > -	spin_unlock(&qdev->hw_lock);
> > +	/* Experience shows that when using INTx interrupts, the device does
> > +	 * not always auto-mask the interrupt.
> > +	 * When using MSI mode, the interrupt must be explicitly disabled
> > +	 * (even though it is auto-masked), otherwise a later command to
> > +	 * enable it is not effective.
> > +	 */
> > +	if (!test_bit(QL_MSIX_ENABLED, &qdev->flags))
> > +		ql_disable_completion_interrupt(qdev, 0);
> 
> Current code is disabling completion interrupt in case of MSI-X zeroth vector.
> This change will break that behavior. Shouldn't zeroth vector in case of MSI-X also disable completion interrupt ?
> If not, please explain why ?

In msix mode there's no need to explicitly disable completion
interrupts, they are reliably auto-masked, according to my observations.
I tested this on two QLE8142 adapters.

Do you have reason to believe this might not always be the case?

> 
> > 
> > -	var = ql_disable_completion_interrupt(qdev, intr_context->intr);
> > +	var = ql_read32(qdev, STS);
> > 
> >  	/*
> >  	 * Check for fatal error.
> >  	 */
> >  	if (var & STS_FE) {
> > +		ql_disable_completion_interrupt(qdev, 0);
> 
> Why need to do it again here ? if before this it can disable completion interrupt for INT-X case and MSI-X zeroth vector case ?

I couldn't test this code path, so I preserved the original behavior.

> 
> >  		ql_queue_asic_error(qdev);
> >  		netdev_err(qdev->ndev, "Got fatal error, STS = %x.\n", var);
> >  		var = ql_read32(qdev, ERR_STS);
> > @@ -2534,7 +2486,6 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
> >  		 */
> >  		netif_err(qdev, intr, qdev->ndev,
> >  			  "Got MPI processor interrupt.\n");
> > -		ql_disable_completion_interrupt(qdev, intr_context->intr);
> 
> Why disable interrupt is not required here ?

The interrupt source _is_ masked:
		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));

> While in case of Fatal error case above ql_disable_completion_interrupt() is being called ?
> Also, in case of MSI-X zeroth vector it will not disable completion interrupt but at the end, it will end of qlge_isr() enabling completion interrupt.
> Seems like disabling and enabling might not be in sync in case of MSI-X zeroth vector.

I guess you forgot to consider that completion interrupts are
auto-masked in msix mode.
