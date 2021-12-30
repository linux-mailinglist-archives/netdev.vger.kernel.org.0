Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C04481F5B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbhL3TA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:00:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240323AbhL3TA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 14:00:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JCaguvZJred69+OwQjeSn/23D9RZwu02S0tDcpDSXbo=; b=HvVX/l0iBKS+2inWVACGi41QKJ
        HCwAr7mxYT6DS4Dpp0xHZo2mm3gxsxnf/HFpsDOzVlpcKyYfshT1as9yfkJ01RNFdWfRADZ38E0wA
        bapH/0rmYaaZI0gXTbF+fli8ffuCo6eoazupBnOF588bKexSeGVH9yV2LW44Fp8MF3XE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n30f0-000BTf-1h; Thu, 30 Dec 2021 20:00:22 +0100
Date:   Thu, 30 Dec 2021 20:00:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] net/fungible: Add service module for
 Fungible drivers
Message-ID: <Yc4Bxu8f9S5w3VsM@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-3-dmichail@fungible.com>
 <Yc3sLEjF6O1CaMZZ@lunn.ch>
 <CAOkoqZnoOgGDGcnDeOQxjZ_eYh8eyFHK_E+w7E6QHWAvaembKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZnoOgGDGcnDeOQxjZ_eYh8eyFHK_E+w7E6QHWAvaembKw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 10:24:10AM -0800, Dimitris Michailidis wrote:
> On Thu, Dec 30, 2021 at 9:28 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +/* Wait for the CSTS.RDY bit to match @enabled. */
> > > +static int fun_wait_ready(struct fun_dev *fdev, bool enabled)
> > > +{
> > > +     unsigned int cap_to = NVME_CAP_TIMEOUT(fdev->cap_reg);
> > > +     unsigned long timeout = ((cap_to + 1) * HZ / 2) + jiffies;
> > > +     u32 bit = enabled ? NVME_CSTS_RDY : 0;
> >
> > Reverse Christmas tree, since this is a network driver.
> 
> The longer line in the middle depends on the previous line, I'd need to
> remove the initializers to sort these by length.

Yes.


> > Please also consider using include/linux/iopoll.h. The signal handling
> > might make that not possible, but signal handling in driver code is in
> > itself very unusual.
> 
> This initialization is based on NVMe, hence the use of NVMe registers,
> and this function is based on nvme_wait_ready(). The check sequence
> including signal handling comes from there.
> 
> iopoll is possible with the signal check removed, though I see I'd need a
> shorter delay than the 100ms used here and it doesn't check for reads of
> all 1s, which happen occasionally. My preference though would be to keep
> this close to the NVMe version. Let me know.

I knew it would be hard to directly use iopoll, which is why i only
said 'consider'. The problem is, this implementation has the same bug
nearly everybody makes when writing their own implementation of what
iopoll does, which is why i always point people at iopoll.

msleep(100) guarantees that it will not return within 100ms. That is
all. Consider what happens when msleep(100) actually sleeps for
1000.

	Andrew
