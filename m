Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAF5418AF8
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 22:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhIZUZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 16:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhIZUZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 16:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD45B60EE4;
        Sun, 26 Sep 2021 20:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632687824;
        bh=UyDa7RcM8FAe1YGnTgWQsVLHnoPiMluibSBU3LwwEYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=E/WwhkU8QrirBHQB4gV+UmUP+1owZhhMt1FjHYxZVijY/PLiLZR45z/AznYyTrhdT
         Dw5AkXWayukNM9G3BVDs8e6xBAso0arLQIEK0KePkyDQYVLNSIlZ02aZ/6nW2MMSY7
         T8g283jfeQOhP7NPdUBuNr4fCMk2jQIkdJT366X1LNJVaoh+bXQEhiKKZoi3YAn3ZK
         9SWDWaRBIcK/Dd6hLYzUA8WIOIhZjqpdyjWdmikI185j2jYLXWanKK5EKaIaZSz7yM
         BYUi+/RPnMoGqp4BV1pI4dBMH/fqM1Hb0FVhSKBWMd/OxwEusX1iM8RXLrlZZQ5avh
         Z1lLzxrLjb5OQ==
Date:   Sun, 26 Sep 2021 15:23:41 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/7] PCI/IOV: Provide internal VF index
Message-ID: <20210926202341.GA588922@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVAVAfU3aL6JJg3i@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 09:36:49AM +0300, Leon Romanovsky wrote:
> On Sat, Sep 25, 2021 at 12:41:15PM -0500, Bjorn Helgaas wrote:
> > On Sat, Sep 25, 2021 at 01:10:39PM +0300, Leon Romanovsky wrote:
> > > On Fri, Sep 24, 2021 at 08:08:45AM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Sep 23, 2021 at 09:35:32AM +0300, Leon Romanovsky wrote:
> > > > > On Wed, Sep 22, 2021 at 04:59:30PM -0500, Bjorn Helgaas wrote:
> > > > > > On Wed, Sep 22, 2021 at 01:38:50PM +0300, Leon Romanovsky wrote:
> > > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > > 
> > > > > > > The PCI core uses the VF index internally, often called the vf_id,
> > > > > > > during the setup of the VF, eg pci_iov_add_virtfn().
> > > > > > > 
> > > > > > > This index is needed for device drivers that implement live migration
> > > > > > > for their internal operations that configure/control their VFs.
> > > > > > >
> > > > > > > Specifically, mlx5_vfio_pci driver that is introduced in coming patches
> > > > > > > from this series needs it and not the bus/device/function which is
> > > > > > > exposed today.
> > > > > > > 
> > > > > > > Add pci_iov_vf_id() which computes the vf_id by reversing the math that
> > > > > > > was used to create the bus/device/function.
> > > > > > > 
> > > > > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > > 
> > > > > > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > > > > > 
> > > > > > mlx5_core_sriov_set_msix_vec_count() looks like it does basically the
> > > > > > same thing as pci_iov_vf_id() by iterating through VFs until it finds
> > > > > > one with a matching devfn (although it *doesn't* check for a matching
> > > > > > bus number, which seems like a bug).
> > > ...
> > 
> > > > And it still looks like the existing code is buggy.  This is called
> > > > via sysfs, so if the PF is on bus X and the user writes to
> > > > sriov_vf_msix_count for a VF on bus X+1, it looks like
> > > > mlx5_core_sriov_set_msix_vec_count() will set the count for the wrong
> > > > VF.
> > > 
> > > In mlx5_core_sriov_set_msix_vec_count(), we receive VF that is connected
> > > to PF which has "struct mlx5_core_dev". My expectation is that they share
> > > same bus as that PF was the one who created VFs. The mlx5 devices supports
> > > upto 256 VFs and it is far below the bus split mentioned in PCI spec.
> > > 
> > > How can VF and their respective PF have different bus numbers?
> > 
> > See PCIe r5.0, sec 9.2.1.2.  For example,
> > 
> >   PF 0 on bus 20
> >     First VF Offset   1
> >     VF Stride         1
> >     NumVFs          511
> >   VF 0,1   through VF 0,255 on bus 20
> >   VF 0,256 through VF 0,511 on bus 21
> > 
> > This is implemented in pci_iov_add_virtfn(), which computes the bus
> > number and devfn from the VF ID.
> > 
> > pci_iov_virtfn_devfn(VF 0,1) == pci_iov_virtfn_devfn(VF 0,256), so if
> > the user writes to sriov_vf_msix_count for VF 0,256, it looks like
> > we'll call mlx5_set_msix_vec_count() for VF 0,1 instead of VF 0,256.
> 
> This is PCI spec split that I mentioned.
> 
> > 
> > The spec encourages devices that require no more than 256 devices to
> > locate them all on the same bus number (PCIe r5.0, sec 9.1), so if you
> > only have 255 VFs, you may avoid the problem.
> > 
> > But in mlx5_core_sriov_set_msix_vec_count(), it's not obvious that it
> > is safe to assume the bus number is the same.
> 
> No problem, we will make it more clear.

IMHO you should resolve it by using the new interface.  Better
performing, unambiguous regardless of how many VFs the device
supports.  What's the down side?
