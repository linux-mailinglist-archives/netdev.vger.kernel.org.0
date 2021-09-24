Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24710417519
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345613AbhIXNO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346890AbhIXNMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9CFE600D3;
        Fri, 24 Sep 2021 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632488927;
        bh=DEsVxs5QhqXr9Us56Qs9QAHy1u7Pz1zYs7zcB+8p/O0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=oCiN2ZLP0OBWWJKhIXTdoEKBzx1SSQRtp5hdFjA060S6OBi1avIKghqNtF8WEPs4F
         TTrBVcV/tYB5b4W55juUMbPfxOlRSzXokaakeGGiwp63Q8nRWkr1p04iQu97HO6/JQ
         OtDTd8KpNpy3dTz2qaDOQxGsWcdWsPztbulQPw2nb9UAoekB0gvnUK/0Xn4RnUun5D
         V+x87zvJRCBWlHlWMl4RiY0lhzJ8QeEuFZ8wqPfpNlrRciC1jtvOEnzlsTZIGE1y87
         I68RbHim87p8mEcdmOoQj82Ur2jmBDpuT37SPE+26F1cFDkaq8Qo8cE1AVdEO24GHg
         wSPrFdkxzDeqA==
Date:   Fri, 24 Sep 2021 08:08:45 -0500
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
Message-ID: <20210924130845.GA410176@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUwgNPL++APsFJ49@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 09:35:32AM +0300, Leon Romanovsky wrote:
> On Wed, Sep 22, 2021 at 04:59:30PM -0500, Bjorn Helgaas wrote:
> > On Wed, Sep 22, 2021 at 01:38:50PM +0300, Leon Romanovsky wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > 
> > > The PCI core uses the VF index internally, often called the vf_id,
> > > during the setup of the VF, eg pci_iov_add_virtfn().
> > > 
> > > This index is needed for device drivers that implement live migration
> > > for their internal operations that configure/control their VFs.
> > >
> > > Specifically, mlx5_vfio_pci driver that is introduced in coming patches
> > > from this series needs it and not the bus/device/function which is
> > > exposed today.
> > > 
> > > Add pci_iov_vf_id() which computes the vf_id by reversing the math that
> > > was used to create the bus/device/function.
> > > 
> > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > mlx5_core_sriov_set_msix_vec_count() looks like it does basically the
> > same thing as pci_iov_vf_id() by iterating through VFs until it finds
> > one with a matching devfn (although it *doesn't* check for a matching
> > bus number, which seems like a bug).
> > 
> > Maybe that should use pci_iov_vf_id()?
> 
> Yes, I gave same comment internally and we decided to simply reduce the
> amount of changes in mlx5_core to have less distractions and submit as a
> followup. Most likely will add this hunk in v1.

I guess it backfired as far as reducing distractions, because now it
just looks like a job half-done.

And it still looks like the existing code is buggy.  This is called
via sysfs, so if the PF is on bus X and the user writes to
sriov_vf_msix_count for a VF on bus X+1, it looks like
mlx5_core_sriov_set_msix_vec_count() will set the count for the wrong
VF.

Bjorn
