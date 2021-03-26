Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D197F34AD1D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCZRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCZRIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 13:08:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2698561A38;
        Fri, 26 Mar 2021 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616778513;
        bh=YKDykDVQ6KTEU7hT/GXP9jb6Ht59J6HUtCvZspqwUyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=rRUOHKdiPSDwgWtMrMoIXOvWs3VOISZGUO0+28Sv55mKmVIxSOZ87Aba9C+V9JZSQ
         RqhIcAOWjHMXK7gdyWo5D5qEb0eIlX/yPYF9c515wEqv8TiaS2hF4X+FFoLd0l9qjQ
         0csayiFFwacng5/+3ZM5lfgqMyCzqqTcuPx9d3DRzELBHB6BRMuYhKm7ezCaaHeMkD
         edA9O0yYU3L36CtuCrCNGldqYN0j2PRThoZCg3hIJxGW8lFAz6n/m47wvDTLF3dyQn
         UbwdoDzr8RV40ulIkuTbhn2oh+/+P0quhPsAk8BQQE7Djqy91apPXys5oPcCZdXOfP
         m9zZJgEtvm0bg==
Date:   Fri, 26 Mar 2021 12:08:31 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20210326170831.GA890834@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 09:00:50AM -0700, Alexander Duyck wrote:
> On Thu, Mar 25, 2021 at 11:44 PM Leon Romanovsky <leon@kernel.org> wrote:
> > On Thu, Mar 25, 2021 at 03:28:36PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Mar 25, 2021 at 01:20:21PM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> > > > >
> > > > > > NVMe and mlx5 have basically identical functionality in this respect.
> > > > > > Other devices and vendors will likely implement similar functionality.
> > > > > > It would be ideal if we had an interface generic enough to support
> > > > > > them all.
> > > > > >
> > > > > > Is the mlx5 interface proposed here sufficient to support the NVMe
> > > > > > model?  I think it's close, but not quite, because the the NVMe
> > > > > > "offline" state isn't explicitly visible in the mlx5 model.
> > > > >
> > > > > I thought Keith basically said "offline" wasn't really useful as a
> > > > > distinct idea. It is an artifact of nvme being a standards body
> > > > > divorced from the operating system.
> > > > >
> > > > > In linux offline and no driver attached are the same thing, you'd
> > > > > never want an API to make a nvme device with a driver attached offline
> > > > > because it would break the driver.
> > > >
> > > > I think the sticky part is that Linux driver attach is not visible to
> > > > the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
> > > > can only assign resources to a VF when the VF is offline, and the VF
> > > > is only usable when it is online.
> > > >
> > > > For NVMe, software must ask the PF to make those online/offline
> > > > transitions via Secondary Controller Offline and Secondary Controller
> > > > Online commands [1].  How would this be integrated into this sysfs
> > > > interface?
> > >
> > > Either the NVMe PF driver tracks the driver attach state using a bus
> > > notifier and mirrors it to the offline state, or it simply
> > > offline/onlines as part of the sequence to program the MSI change.
> > >
> > > I don't see why we need any additional modeling of this behavior.
> > >
> > > What would be the point of onlining a device without a driver?
> >
> > Agree, we should remember that we are talking about Linux kernel model
> > and implementation, where _no_driver_ means _offline_.
> 
> The only means you have of guaranteeing the driver is "offline" is by
> holding on the device lock and checking it. So it is only really
> useful for one operation and then you have to release the lock. The
> idea behind having an "offline" state would be to allow you to
> aggregate multiple potential operations into a single change.
> 
> For example you would place the device offline, then change
> interrupts, and then queues, and then you could online it again. The
> kernel code could have something in place to prevent driver load on
> "offline" devices. What it gives you is more of a transactional model
> versus what you have right now which is more of a concurrent model.

Thanks, Alex.  Leon currently does enforce the "offline" situation by
holding the VF device lock while checking that it has no driver and
asking the PF to do the assignment.  I agree this is only useful for a
single operation.  Would the current series *prevent* a transactional
model from being added later if it turns out to be useful?  I think I
can imagine keeping the same sysfs files but changing the
implementation to check for the VF being offline, while adding
something new to control online/offline.

I also want to resurrect your idea of associating
"sriov_vf_msix_count" with the PF instead of the VF.  I really like
that idea, and it better reflects the way both mlx5 and NVMe work.  I
don't think there was a major objection to it, but the discussion
seems to have petered out after your suggestion of putting the PCI
bus/device/funcion in the filename, which I also like [1].

Leon has implemented a ton of variations, but I don't think having all
the files in the PF directory was one of them.

Bjorn

[1] https://lore.kernel.org/r/CAKgT0Ue363fZEwqGUa1UAAYotUYH8QpEADW1U5yfNS7XkOLx0Q@mail.gmail.com
