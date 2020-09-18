Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8D326FBCF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 13:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIRLwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 07:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgIRLwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 07:52:31 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A689620DD4;
        Fri, 18 Sep 2020 11:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600429951;
        bh=TvMPgZK5sOPbg0bfG2ojrK71ZfXtDu5Hgw4HTxKyKQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jCiVpWJY4mpXE9A0zT61qXO7YMe2ZOLu/vV089cTp1jeF5tS+EE4wfV5YnaAbrTAH
         8uI3oU+iLHWwJhC4LYlg+gq5tH41T/oaz9VM2odA9NPUVWyOuEwPgFXkG2V7Q+2E9h
         0MRGlC6+R2trD2d6Jlz6Vxklrm8bxlWIblk22VOU=
Date:   Fri, 18 Sep 2020 14:52:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918115227.GR869610@unreal>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> >> infrastructure for communication between multiple accelerators. Same
> >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> >> The RDMA implementation we did does NOT support some basic RDMA
> >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> >> library or to connect to the rdma infrastructure in the kernel.
> >
> > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > you can't add random device offloads as IOCTL to nedevs.
> >
> > RDMA is the proper home for all the networking offloads that don't fit
> > into netdev.
> >
> > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > all. I'm sure this can too.
>
> Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> was suggested to go through the vfio subsystem instead.
>
> I think this comes back to the discussion we had when EFA was upstreamed, which
> is what's the bar to get accepted to the RDMA subsystem.
> IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
>
> Does GAUDI fit these requirements? If not, should it be in a different subsystem
> or should we open the "what qualifies as an RDMA device" question again?

I want to remind you that rdma-core requirement came to make sure that
anything exposed from the RDMA to the userspace is strict with proper
UAPI header hygiene.

I doubt that Havana's ioctls are backed by anything like this.

Thanks
