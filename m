Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D18D34A21E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 07:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhCZGoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 02:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhCZGoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 02:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E835A61984;
        Fri, 26 Mar 2021 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616741048;
        bh=Hm7sCymXzN0wESAsfhGfW2mVzoE06j6T59EPX8RUXkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VLWFc6Qb1+k8fn5plwONXJlNYgwj3OifCFFRjkL962F58Nz3F+f9DDfWIm87JpbWV
         lnTJrWObUItrSxi1yNAr5xp7bC9KzcantBw2Zmus96yFSIDQ7arJG/6CLwbM2k9jB7
         WR1exkOwmEtsrG/Fy9bien0IgJh0fA5keGeS0W9K3UobBT4HgX/B6QT9nsI/JYZxII
         35D+eNvhpLu94bDezzphvzVbEQQZQTaP3rOBaKkUCLxDIGHVGetQyqfCl+VqABREkg
         OyMH98ROxi44wqAYjaQ8Go6hvSIKaoJhXLNM+aF320VFQpRaVJYQPZ8xL/AVUU61VC
         0L4vajJO17tqQ==
Date:   Fri, 26 Mar 2021 09:44:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Keith Busch <kbusch@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YF2CtFmOxL6Noi96@unreal>
References: <20210325173646.GG2356281@nvidia.com>
 <20210325182021.GA795636@bjorn-Precision-5520>
 <20210325182836.GJ2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325182836.GJ2356281@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 03:28:36PM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 25, 2021 at 01:20:21PM -0500, Bjorn Helgaas wrote:
> > On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> > > 
> > > > NVMe and mlx5 have basically identical functionality in this respect.
> > > > Other devices and vendors will likely implement similar functionality.
> > > > It would be ideal if we had an interface generic enough to support
> > > > them all.
> > > > 
> > > > Is the mlx5 interface proposed here sufficient to support the NVMe
> > > > model?  I think it's close, but not quite, because the the NVMe
> > > > "offline" state isn't explicitly visible in the mlx5 model.
> > > 
> > > I thought Keith basically said "offline" wasn't really useful as a
> > > distinct idea. It is an artifact of nvme being a standards body
> > > divorced from the operating system.
> > > 
> > > In linux offline and no driver attached are the same thing, you'd
> > > never want an API to make a nvme device with a driver attached offline
> > > because it would break the driver.
> > 
> > I think the sticky part is that Linux driver attach is not visible to
> > the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
> > can only assign resources to a VF when the VF is offline, and the VF
> > is only usable when it is online.
> > 
> > For NVMe, software must ask the PF to make those online/offline
> > transitions via Secondary Controller Offline and Secondary Controller
> > Online commands [1].  How would this be integrated into this sysfs
> > interface?
> 
> Either the NVMe PF driver tracks the driver attach state using a bus
> notifier and mirrors it to the offline state, or it simply
> offline/onlines as part of the sequence to program the MSI change.
> 
> I don't see why we need any additional modeling of this behavior. 
> 
> What would be the point of onlining a device without a driver?

Agree, we should remember that we are talking about Linux kernel model
and implementation, where _no_driver_ means _offline_.

Thanks

> 
> Jason
