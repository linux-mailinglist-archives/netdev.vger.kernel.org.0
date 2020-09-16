Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE30626BE56
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 09:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIPHlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 03:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIPHlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 03:41:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DDA20809;
        Wed, 16 Sep 2020 07:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600242103;
        bh=BMMd8sHq9Uc24jVPYlSvOGvoD4Z5w5C7QYU90Lm6k/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpAj5Lg784g39MwWyqtVx7VlQtD2yeTDLQ8/Vzvegu0CM066ODFFKlMlYFGjNOr1M
         Jn5pX0lO2D21mjI3/m2g4juXn7i0sax2aUrD7OzCI8xRHMfNDehy0n6bXcxkyzlxGD
         4CZUhibFjJmDOEfdZU+iY/ZN2loGEFpH3V/uUrvg=
Date:   Wed, 16 Sep 2020 09:42:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200916074217.GB189144@kroah.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
 <20200916062614.GF142621@kroah.com>
 <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 09:36:23AM +0300, Oded Gabbay wrote:
> On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> > > On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> > > >
> > > > From: Oded Gabbay <oded.gabbay@gmail.com>
> > > > Date: Tue, 15 Sep 2020 20:10:08 +0300
> > > >
> > > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > > into the habanalabs driver.
> > > > >
> > > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > > are in that patch's commit message.
> > > > >
> > > > > Link to v2 cover letter:
> > > > > https://lkml.org/lkml/2020/9/12/201
> > > >
> > > > I agree with Jakub, this driver definitely can't go-in as it is currently
> > > > structured and designed.
> > > Why is that ?
> > > Can you please point to the things that bother you or not working correctly?
> > > I can't really fix the driver if I don't know what's wrong.
> > >
> > > In addition, please read my reply to Jakub with the explanation of why
> > > we designed this driver as is.
> > >
> > > And because of the RDMA'ness of it, the RDMA
> > > > folks have to be CC:'d and have a chance to review this.
> > > As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> > > the kernel and we can't connect to it due to the lack of H/W support
> > > we have
> > > Therefore, I don't see why we need to CC linux-rdma.
> > > I understood why Greg asked me to CC you because we do connect to the
> > > netdev and standard eth infrastructure, but regarding the RDMA, it's
> > > not really the same.
> >
> > Ok, to do this "right" it needs to be split up into separate drivers,
> > hopefully using the "virtual bus" code that some day Intel will resubmit
> > again that will solve this issue.
> Hi Greg,
> Can I suggest an alternative for the short/medium term ?
> 
> In an earlier email, Jakub said:
> "Is it not possible to move the files and still build them into a single
> module?"
> 
> I thought maybe that's a good way to progress here ?

Cross-directory builds of a single module are crazy.  Yes, they work,
but really, that's a mess, and would never suggest doing that.

> First, split the content to Ethernet and RDMA.
> Then move the Ethernet part to drivers/net but build it as part of
> habanalabs.ko.
> Regarding the RDMA code, upstream/review it in a different patch-set
> (maybe they will want me to put the files elsewhere).
> 
> What do you think ?

I think you are asking for more work there than just splitting out into
separate modules :)

thanks,

greg k-h
