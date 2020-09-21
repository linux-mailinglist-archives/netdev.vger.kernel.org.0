Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA7927215E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgIUKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgIUKj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 06:39:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E886D20EDD;
        Mon, 21 Sep 2020 10:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600684798;
        bh=KlmuPZPj6gyZCovHSdQpzORTFZB+K9TJGNXNs5AsJLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mn4zVUurGVrrjxKuvbctD7Uf3KVF3SZyMFrKHgjL29YlsHQh+j74CGVWUGw3Q3XJj
         yFI8T1JdXupduBPekzcFB46fSlbeoLhyZo3GeymQFxiS2mkttvANSaDUXc6NwUQhUw
         rkQ+Wj5lt+LWbr8ilJEDSLUodkw5pOEcEsepI/dE=
Date:   Mon, 21 Sep 2020 13:39:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, izur@habana.ai
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200921103954.GB1223944@unreal>
References: <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
 <20200919172730.GC2733595@kroah.com>
 <20200919192235.GB8409@ziepe.ca>
 <20200920084702.GA533114@kroah.com>
 <CAFCwf112t7es1FFsEW1oRtc-H7qZEjZxEGd7p7VFP9Y5BAeDmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf112t7es1FFsEW1oRtc-H7qZEjZxEGd7p7VFP9Y5BAeDmA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 10:05:39PM +0300, Oded Gabbay wrote:
> On Sun, Sep 20, 2020 at 11:47 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Sep 19, 2020 at 04:22:35PM -0300, Jason Gunthorpe wrote:
> > > On Sat, Sep 19, 2020 at 07:27:30PM +0200, Greg Kroah-Hartman wrote:
> > > > > It's probably heresy, but why do I need to integrate into the RDMA subsystem ?
> > > > > I understand your reasoning about networking (Ethernet) as the driver
> > > > > connects to the kernel networking stack (netdev), but with RDMA the
> > > > > driver doesn't use or connect to anything in that stack. If I were to
> > > > > support IBverbs and declare that I support it, then of course I would
> > > > > need to integrate to the RDMA subsystem and add my backend to
> > > > > rdma-core.
> > > >
> > > > IBverbs are horrid and I would not wish them on anyone.  Seriously.
> > >
> > > I'm curious what drives this opinion? Did you have it since you
> > > reviewed the initial submission all those years ago?
> >
> > As I learned more about that interface, yes, I like it less and less :)
> >
> > But that's the userspace api you all are stuck with, for various
> > reasons, my opinion doesn't matter here.
> >
> > > > I think the general rdma apis are the key here, not the userspace api.
> > >
> > > Are you proposing that habana should have uAPI in drivers/misc and
> > > present a standard rdma-core userspace for it? This is the only
> > > userspace programming interface for RoCE HW. I think that would be
> > > much more work.
> > >
> > > If not, what open source userspace are you going to ask them to
> > > present to merge the kernel side into misc?
> >
> > I don't think that they have a userspace api to their rdma feature from
> > what I understand, but I could be totally wrong as I do not know their
> > hardware at all, so I'll let them answer this question.
>
> Hi Greg,
> We do expose a new IOCTL to enable the user to configure connections
> between multiple GAUDI devices.

How is it different from RDMA QP configuration?

>
> Having said that, we restrict this IOCTL to be used only by the same
> user who is doing the compute on our device, as opposed to a real RDMA
> device where any number of applications can send and receive.

The ability to support multiple applications is not RDMA-requirement,
but the implementation. For example MPI jobs are single user of RDMA device.

> In addition, this IOCTL limits the user to connect ONLY to another
> GAUDI device and not to a 3rd party RDMA device.

I don't see how it is different from EFA with their SQD QP type or mlx5
devices with DC QPs that you can connect only to similar devices (no
interoperability).

Thanks
