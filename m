Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205422F284A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbhALGQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbhALGQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 01:16:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EBC1206E9;
        Tue, 12 Jan 2021 06:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610432139;
        bh=c6tyWxprww/4ROQ93yiG3cN7IOvwGECUGF1dHM038AQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K3XL207jPsUySe7cGwEo+sNYxiUaUIeQ04Z2naKZbLESTfTkIdijqzrDv1C7JUwdH
         +5IIVEIDy30eldpwgnSvBTzEgvkLkzuI3jc83pFRvzD8978O3/4Gn9LYiKWeWcwf0A
         1iA0sczRPqJU/dRrfLmmQwBcGq6seJbK9jyicBM/37BQfuhvCOWJ5e530Y2EmrCT1/
         h0uPSX2zZ50dbxeMQOUV1sa5pGFTH2sFlHXmuvvn12MykHbaISxtkBt9yHKGkDQaS4
         7KUoPKNatI7nOyGv+FCUJ1QqWlZjY/puUWQg69PGhhsNTcjU0OyXzbPAz+tAA3Yh6H
         6u+leHsOIji/g==
Date:   Tue, 12 Jan 2021 08:15:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Don Dutile <ddutile@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next v1 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210112061535.GB4678@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-2-leon@kernel.org>
 <CAKgT0UcJrSNMPAOoniRSnUn+wyRUkL62AfgR3-8QbAkak=pQ=w@mail.gmail.com>
 <397a7ed5-c98f-560e-107e-0b354bebb9bd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <397a7ed5-c98f-560e-107e-0b354bebb9bd@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 10:25:42PM -0500, Don Dutile wrote:
> On 1/11/21 2:30 PM, Alexander Duyck wrote:
> > On Sun, Jan 10, 2021 at 7:12 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Extend PCI sysfs interface with a new callback that allows configure
> > > the number of MSI-X vectors for specific SR-IO VF. This is needed
> > > to optimize the performance of newly bound devices by allocating
> > > the number of vectors based on the administrator knowledge of targeted VM.
> > >
> > > This function is applicable for SR-IOV VF because such devices allocate
> > > their MSI-X table before they will run on the VMs and HW can't guess the
> > > right number of vectors, so the HW allocates them statically and equally.
> > >
> > > The newly added /sys/bus/pci/devices/.../vf_msix_vec file will be seen
> > > for the VFs and it is writable as long as a driver is not bounded to the VF.
> > >
> > > The values accepted are:
> > >   * > 0 - this will be number reported by the VF's MSI-X capability
> > >   * < 0 - not valid
> > >   * = 0 - will reset to the device default value
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >   Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++++
> > >   drivers/pci/iov.c                       | 62 +++++++++++++++++++++++++
> > >   drivers/pci/msi.c                       | 29 ++++++++++++
> > >   drivers/pci/pci-sysfs.c                 |  1 +
> > >   drivers/pci/pci.h                       |  2 +
> > >   include/linux/pci.h                     |  8 +++-
> > >   6 files changed, 121 insertions(+), 1 deletion(-)

<...>

> > > +
> > This doesn't make sense to me. You are getting the vector count for
> > the PCI device and reporting that. Are you expecting to call this on
> > the PF or the VFs? It seems like this should be a PF attribute and not
> > be called on the individual VFs.
> >
> > If you are calling this on the VFs then it doesn't really make any
> > sense anyway since the VF is not a "VF PCI dev representor" and
> > shouldn't be treated as such. In my opinion if we are going to be
> > doing per-port resource limiting that is something that might make
> > more sense as a part of the devlink configuration for the VF since the
> > actual change won't be visible to an assigned device.
> if the op were just limited to nic ports, devlink may be used; but I believe Leon is trying to handle it from an sriov/vf perspective for other non-nic devices as well,
> e.g., ib ports, nvme vf's (which don't have a port concept at all).

Right, the SR-IOV VFs are common entities outside of nic/devlink world.
In addition to the netdev world, SR-IOV is used for crypto, storage, FPGA
and IB devices.

From what I see, There are three possible ways to configure MSI-X vector count:
1. PCI device is on the same CPU - regular server/desktop as we know it.
2. PCI device is on remote CPU - SmartNIC use case, the CPUs are
connected through eswitch model.
3. Some direct interface - DEVX for the mlx5_ib.

This implementation handles item #1 for all devices without any exception.
From my point of view, the majority of interested users of this feature
will use this option.

The second item should be solved differently (with devlink) when configuring
eswitch port, but it is orthogonal to the item #1 and I will do it after.

The third item is not managed by the kernel, so not relevant for our discussion.

Thanks
