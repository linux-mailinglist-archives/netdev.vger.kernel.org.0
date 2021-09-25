Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE24180F8
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 12:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244119AbhIYKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 06:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235805AbhIYKMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 06:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64C7610C9;
        Sat, 25 Sep 2021 10:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632564643;
        bh=7g5nUt6S+63DfyoI33cOS6neqOn00oZEYSazRW7icKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e87ZqnKl688T/SQGcH9+jwjV014Tulyt7Hb3OxSjdxnCIm7oEZ/EpJ73lS0FYFky+
         w/MwitlU/UyQB3xXw7YZVKNcVS1KmP9X01uvgwDkuwXB3yUvmCneQ2EumdVqaGD+I7
         oibmJ1i0v7DyUubmNeADkZerUZmsr3tXNZMwt0s8MRMAeW7hHPrw4A+cQuh+Lqyp70
         RjO6S23V10pYJOBLZ5Kht/XmdgA0nn9Dt2OR+EqVL/1QjYUirI/PZ/Zx+ct6/4fNyT
         QALmldECZr9nyTMlqDDYKWOytn11twX33WlFOnstjzbJUB9Lv9EIXUppsidnGUqccs
         g6W9kC9yAb3ew==
Date:   Sat, 25 Sep 2021 13:10:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
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
Message-ID: <YU71n4WSIztOdpbw@unreal>
References: <YUwgNPL++APsFJ49@unreal>
 <20210924130845.GA410176@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924130845.GA410176@bhelgaas>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 08:08:45AM -0500, Bjorn Helgaas wrote:
> On Thu, Sep 23, 2021 at 09:35:32AM +0300, Leon Romanovsky wrote:
> > On Wed, Sep 22, 2021 at 04:59:30PM -0500, Bjorn Helgaas wrote:
> > > On Wed, Sep 22, 2021 at 01:38:50PM +0300, Leon Romanovsky wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > 
> > > > The PCI core uses the VF index internally, often called the vf_id,
> > > > during the setup of the VF, eg pci_iov_add_virtfn().
> > > > 
> > > > This index is needed for device drivers that implement live migration
> > > > for their internal operations that configure/control their VFs.
> > > >
> > > > Specifically, mlx5_vfio_pci driver that is introduced in coming patches
> > > > from this series needs it and not the bus/device/function which is
> > > > exposed today.
> > > > 
> > > > Add pci_iov_vf_id() which computes the vf_id by reversing the math that
> > > > was used to create the bus/device/function.
> > > > 
> > > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > > 
> > > mlx5_core_sriov_set_msix_vec_count() looks like it does basically the
> > > same thing as pci_iov_vf_id() by iterating through VFs until it finds
> > > one with a matching devfn (although it *doesn't* check for a matching
> > > bus number, which seems like a bug).
> > > 
> > > Maybe that should use pci_iov_vf_id()?
> > 
> > Yes, I gave same comment internally and we decided to simply reduce the
> > amount of changes in mlx5_core to have less distractions and submit as a
> > followup. Most likely will add this hunk in v1.
> 
> I guess it backfired as far as reducing distractions, because now it
> just looks like a job half-done.

Partially :)
I didn't expect to see acceptance of this series in v0, we wanted to
gather feedback as early as possible.

> 
> And it still looks like the existing code is buggy.  This is called
> via sysfs, so if the PF is on bus X and the user writes to
> sriov_vf_msix_count for a VF on bus X+1, it looks like
> mlx5_core_sriov_set_msix_vec_count() will set the count for the wrong
> VF.

In mlx5_core_sriov_set_msix_vec_count(), we receive VF that is connected
to PF which has "struct mlx5_core_dev". My expectation is that they share
same bus as that PF was the one who created VFs. The mlx5 devices supports
upto 256 VFs and it is far below the bus split mentioned in PCI spec.

How can VF and their respective PF have different bus numbers?

Thanks

> 
> Bjorn
