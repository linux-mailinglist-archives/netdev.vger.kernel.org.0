Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E82FB1B1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 07:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhASGje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732677AbhASFkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 00:40:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCFBD20707;
        Tue, 19 Jan 2021 05:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611034775;
        bh=30QA8sfSITs3gpwA/1iUXVHhw489NQgc3I22GSDkfmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GStJBH73usYbmfGoHh7ojXBl3SErt/0PQPdS80ZofKrM9VIsxdZMu1ql/trUXMRr5
         OgSP6RlJHTK83iiX9O0SywESB13dBGDJxAvw5gkyEIJ9mxkORGH5v5UORsfYs5tDXV
         JAmIzBctzrBW3oRFbWu9DB9IjHV1tVwcbVwjAtS/J4u3xB7tySqIo7oENCmoiMpYfm
         NlYl6m4/yQFth61wxD8CgY5NqO82F6OoEbNTqkZZ9QdS3gLbMjNSMYVI4G7O3CE8If
         LdrmLnbsiM65Wk/UT2HQhEgeBUwi/EB8zNgiwPpTJ3oG5EkItJMqxW4yW7MtoLOhT5
         NxLeiO8+W5bAA==
Date:   Tue, 19 Jan 2021 07:39:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH mlx5-next v2 0/5] Dynamically assign MSI-X vectors count
Message-ID: <20210119053931.GC21258@unreal>
References: <20210114103140.866141-1-leon@kernel.org>
 <20210114095128.0f388f08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210117054409.GQ944463@unreal>
 <20210117072441.GA1242829@unreal>
 <20210118100732.51803b06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118100732.51803b06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 10:07:32AM -0800, Jakub Kicinski wrote:
> On Sun, 17 Jan 2021 09:24:41 +0200 Leon Romanovsky wrote:
> > On Sun, Jan 17, 2021 at 07:44:09AM +0200, Leon Romanovsky wrote:
> > > On Thu, Jan 14, 2021 at 09:51:28AM -0800, Jakub Kicinski wrote:
> > > > On Thu, 14 Jan 2021 12:31:35 +0200 Leon Romanovsky wrote:
> > > > > The number of MSI-X vectors is PCI property visible through lspci, that
> > > > > field is read-only and configured by the device.
> > > > >
> > > > > The static assignment of an amount of MSI-X vectors doesn't allow utilize
> > > > > the newly created VF because it is not known to the device the future load
> > > > > and configuration where that VF will be used.
> > > > >
> > > > > The VFs are created on the hypervisor and forwarded to the VMs that have
> > > > > different properties (for example number of CPUs).
> > > > >
> > > > > To overcome the inefficiency in the spread of such MSI-X vectors, we
> > > > > allow the kernel to instruct the device with the needed number of such
> > > > > vectors, before VF is initialized and bounded to the driver.
> > > >
> > > >
> > > > Hi Leon!
> > > >
> > > > Looks like you got some missing kdoc here, check out the test in
> > > > patchwork so we don't need to worry about this later:
> > > >
> > > > https://patchwork.kernel.org/project/netdevbpf/list/?series=414497
> > >
> > > Thanks Jakub,
> > >
> > > I'll add kdocs to internal mlx5 functions.
> > > IMHO, they are useless.
>
> It's just scripts/kernel-doc, and it's checking if the kdoc is _valid_,
> your call if you want to add kdoc, just a comment, or nothing at all.

I prefer clean CI, so will add.

>
> > At the end, it looks like CI false alarm.
> >
> > drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:81: warning: Function parameter or member 'dev' not described in 'mlx5_set_msix_vec_count'
> > drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:81: warning: Function parameter or member 'function_id' not described in 'mlx5_set_msix_vec_count'
> > drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:81: warning: Function parameter or member 'msix_vec_count' not described in 'mlx5_set_msix_vec_count'
> > New warnings added
> >
> > The function mlx5_set_msix_vec_count() is documented.
> > +/**
> > + * mlx5_set_msix_vec_count() - Set dynamically allocated MSI-X to the VF
> > + * @dev - PF to work on
> > + * @function_id - internal PCI VF function id
> > + * @msix_vec_count - Number of MSI-X to set
> > + **/
> > +int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
> > +			    int msix_vec_count)
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210114103140.866141-5-leon@kernel.org/
>
> AFAIU that's not valid kdoc, I _think_ you need to replace ' -' with ':'
> for arguments (not my rules).

Right, I figured it when submitted v3.

Thanks
