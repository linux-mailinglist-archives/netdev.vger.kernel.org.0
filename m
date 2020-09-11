Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9387265941
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgIKGW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 02:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgIKGWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 02:22:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DD9221EB;
        Fri, 11 Sep 2020 06:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599805371;
        bh=RXWz2Q1kkAl4t00VZDK+YTtnXoO2Y+/66lxmxxsMQhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/wbDJJaqA683iXRRzUutNDqI+TBYUQu/Cx46nW3PUvamh396/LrtCPG7EskSRy9k
         +WCF+UDKjE8AV++aynqOB/t0am8taizadhf75qKRNWFxddmopzZ9L8wos47Fl248VB
         dTPAxsmByxsxBNZMihhuE0U9zc6Mwm5qEYWgwDCE=
Date:   Fri, 11 Sep 2020 08:22:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200911062247.GB554610@kroah.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
 <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
 <20200910202513.GH3354160@lunn.ch>
 <CAFCwf11P7pEJ+Av9oiwdQFor5Kh9JeKvVTBXnMzWusKCRz7mHw@mail.gmail.com>
 <20200910203848.GJ3354160@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910203848.GJ3354160@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:38:48PM +0200, Andrew Lunn wrote:
> On Thu, Sep 10, 2020 at 11:30:33PM +0300, Oded Gabbay wrote:
> > On Thu, Sep 10, 2020 at 11:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Can you please elaborate on how to do this with a single driver that
> > > > is already in misc ?
> > > > As I mentioned in the cover letter, we are not developing a
> > > > stand-alone NIC. We have a deep-learning accelerator with a NIC
> > > > interface.
> > >
> > > This sounds like an MFD.
> > >
> > >      Andrew
> > 
> > Yes and no. There is only one functionality - training of deep
> > learning (Accelerating compute operations) :)
> > The rdma is just our method of scaling-out - our method of
> > intra-connection between GAUDI devices (similar to NVlink or AMD
> > crossfire).
> > So the H/W exposes a single physical function at the PCI level. And
> > thus Linux can call a single driver for it during the PCI probe.
> 
> Yes, it probes the MFD driver. The MFD driver then creates platform
> drivers for the sub functions. i.e. it would create an Ethernet
> platform driver. That then gets probed in the usual way. The child
> device can get access to the parent device, if it needs to share
> things, e.g. a device on a bus. This is typically I2C or SPI, but
> there is no reason it cannot be a PCI device.
> 
> Go look in drivers/mfd.

Why do we keep going down this path each time this comes up...

No, mfd doesn't work for this case, but the "virtual bus" that gets
posted ever once in a while would solve this issue.  Hopefully one day
the Intel developers will wake up and post it again here so that we can
review it and hopefully merge it to solve this very common problem...

thanks,

greg k-h
