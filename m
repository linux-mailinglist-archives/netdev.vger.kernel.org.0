Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A5726FC00
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIRMDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgIRMDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 08:03:45 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7247321582;
        Fri, 18 Sep 2020 12:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600430625;
        bh=EO90FkAcyHdLTcPE+7fKS87YRHUsQQ2e1yJv4hbuiFY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1+anVRzL9lCTOsGOPzkUU2dkPuADzZxYoQ3S4wt1SR2qxmDAFpiat9nznjFrf8CBa
         VkMKdh34cz9iH/LIpLxn1XFCMzwtcobtRquPt3T2PPKh2HY0kLykUeK90/k7mEdvb3
         vG5wNuOgk2BhcfBYPGzVXoyX2qRt8yIt6SrlsZ1o=
Date:   Fri, 18 Sep 2020 15:03:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Gal Pressman <galpress@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918120340.GT869610@unreal>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:56:09PM +0300, Oded Gabbay wrote:
> On Fri, Sep 18, 2020 at 2:52 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> > > On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > > > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> > > >> infrastructure for communication between multiple accelerators. Same
> > > >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > > >> The RDMA implementation we did does NOT support some basic RDMA
> > > >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > > >> library or to connect to the rdma infrastructure in the kernel.
> > > >
> > > > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > > > you can't add random device offloads as IOCTL to nedevs.
> > > >
> > > > RDMA is the proper home for all the networking offloads that don't fit
> > > > into netdev.
> > > >
> > > > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > > > all. I'm sure this can too.
> > >
> > > Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> > > was suggested to go through the vfio subsystem instead.
> > >
> > > I think this comes back to the discussion we had when EFA was upstreamed, which
> > > is what's the bar to get accepted to the RDMA subsystem.
> > > IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> > > ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
> > >
> > > Does GAUDI fit these requirements? If not, should it be in a different subsystem
> > > or should we open the "what qualifies as an RDMA device" question again?
> >
> > I want to remind you that rdma-core requirement came to make sure that
> > anything exposed from the RDMA to the userspace is strict with proper
> > UAPI header hygiene.
> >
> > I doubt that Havana's ioctls are backed by anything like this.
> >
> > Thanks
>
> Why do you doubt that ? Have you looked at our code ?
> Our uapi and IOCTLs interface is based on drm subsystem uapi interface
> and it is very safe and protected.

Yes, I looked and didn't find open-source users of your UAPI headers.
It is not related to being safe or protected by to the common request
to present userspace that relies on those exported interfaces.

> Otherwise Greg would have never allowed me to go upstream in the first place.

Nice, can we get a link?

>
> We have a single function which is the entry point for all the IOCTLs
> of our drivers (only one IOCTL is RDMA related, all the others are
> compute related).
> That function is almost 1:1 copy of the function in drm.

DRM has same rules as RDMA, no kernel code will be merged without seeing
open-source userspace.

Thanks

>
> Thanks,
> Oded
