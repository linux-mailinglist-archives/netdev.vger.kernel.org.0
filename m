Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E53254CDD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgH0STR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgH0STN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 14:19:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7383422CBB;
        Thu, 27 Aug 2020 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598552353;
        bh=mSvxAjoE8zTewRmmd8aDrqeNFzQsDcFL3aU1oyNqc8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H4fhmtQGC/0QB1RHGU4ok0yO4+03JXb1lVtMqCv9014Noxekj4/PtuVepMZOJCYKF
         tU7ZOvRYzLEzDbjux31Lgqeg5VcbUHZD1MTrsnFv5yvQOCrz60p+CAamhMYvsO17D9
         3buSwqCmLGgw5AZqwTbei43ZXPmL4mB4J/94FLj4=
Date:   Thu, 27 Aug 2020 11:19:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Brady, Alan" <alan.brady@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 08/15] iecm: Implement vector allocation
Message-ID: <20200827111911.0884af35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MW3PR11MB45226215CC02BFE53CD9F01E8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-9-anthony.l.nguyen@intel.com>
        <20200824134136.7ceabe06@kicinski-fedora-PC1C0HJN>
        <MW3PR11MB45226215CC02BFE53CD9F01E8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 17:28:29 +0000 Brady, Alan wrote:
> > On Mon, 24 Aug 2020 10:32:59 -0700 Tony Nguyen wrote:  
> > >  static void iecm_mb_intr_rel_irq(struct iecm_adapter *adapter)  {
> > > -	/* stub */
> > > +	int irq_num;
> > > +
> > > +	irq_num = adapter->msix_entries[0].vector;
> > > +	synchronize_irq(irq_num);  
> > 
> > I don't think you need to sync irq before freeing it.
> 
> I see other non-Intel drivers syncing before disable/free and Intel
> drivers have historically done it, not that that's necessarily
> correct, but are you certain?

/**
 *	free_irq - free an interrupt allocated with request_irq
 *	@irq: Interrupt line to free
 *	@dev_id: Device identity to free
 *
 *	Remove an interrupt handler. The handler is removed and if the
 *	interrupt line is no longer in use by any driver it is disabled.
 *	On a shared IRQ the caller must ensure the interrupt is disabled
 *	on the card it drives before calling this function. The function
 *	does not return until any executing interrupts for this IRQ
 *	have completed.
 *
 *	This function must not be called from interrupt context.
 *
 *	Returns the devname argument passed to request_irq.
 */
