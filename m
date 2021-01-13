Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25D62F416C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbhAMB5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbhAMB5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 20:57:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2208822C9F;
        Wed, 13 Jan 2021 01:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610503015;
        bh=Amu/cikGa7YJQx3uelzrmW2o2xZpT5Xgzi863pY06g4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kQEs1uwSMqP7MsbWT1iTgTRgS4YC5Md0viHcmzaWKf9tudgpEPKsTNPRXU6fOi0uX
         eUtc0eIwKW3EE+zJ1Rj4pKcYH5uuK08m2OnQneshZ5TRePlAu4jaTud3p391mf6sez
         8qUcrrSmJvSA1BVgTXL2Sy9kdxX+XZg0xmWmzms94lycTnjU7zlfqPscx7NYE/N/MO
         Sld5EoQGBFA2+nyyb5B/Ne3ODwNdIm7VltJgAKK5YNC0C2/NCB+8LfIJSbIfmWJf2h
         7RzB4WmAAjzfXQpG0TstrHk+DPX8CXR9fQ1Pa9CBu7BFKfLXSe4D+pQNPpol4tK2+E
         +0vt74xu1Eg4Q==
Date:   Tue, 12 Jan 2021 17:56:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next v2 5/7] ibmvnic: serialize access to work queue
Message-ID: <20210112175649.1ebbb6e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113004049.GA216185@us.ibm.com>
References: <20210112181441.206545-1-sukadev@linux.ibm.com>
        <20210112181441.206545-6-sukadev@linux.ibm.com>
        <47e7f34d0c8a14eefba6aac00b08fc39cab61679.camel@kernel.org>
        <20210113004049.GA216185@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 16:40:49 -0800 Sukadev Bhattiprolu wrote:
> Saeed Mahameed [saeed@kernel.org] wrote:
> > On Tue, 2021-01-12 at 10:14 -0800, Sukadev Bhattiprolu wrote:  
> 
> <snip>
> > > @@ -5467,7 +5472,15 @@ static int ibmvnic_remove(struct vio_dev *dev)
> > >  		return -EBUSY;
> > >  	}
> > >  
> > > +	/* If ibmvnic_reset() is scheduling a reset, wait for it to
> > > +	 * finish. Then prevent it from scheduling any more resets
> > > +	 * and have the reset functions ignore any resets that have
> > > +	 * already been scheduled.
> > > +	 */
> > > +	spin_lock_irqsave(&adapter->remove_lock, flags);
> > >  	adapter->state = VNIC_REMOVING;
> > > +	spin_unlock_irqrestore(&adapter->remove_lock, flags);
> > > +  
> > 
> > Why irqsave/restore variants ? are you expecting this spinlock to be
> > held in interruptcontext ?
> >   
> > >  	spin_unlock_irqrestore(&adapter->state_lock, flags);  
> 
> Good question.
> 
> One of the callers of ibmvnic_reset() is the ->ndo_tx_timeout()
> method which gets called from the watchdog timer.

watchdog is a normal timer, so it's gonna run in softirq, you don't
need to mask irqs.

