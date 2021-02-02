Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C31230CB2D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbhBBTPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:15:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239455AbhBBTMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 14:12:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4458864E3D;
        Tue,  2 Feb 2021 19:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612293080;
        bh=5CMHvq2AZyfB5l1to1DKLhb6cV7jVUYUbIBHJWolr84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pBk9uZzmgkrbPfmKasC2lGDUS/LJYganPhoiX0LkYnVXoiO9VLBeuNmPB0CaKBeCN
         +oWCjtSO9LsLXjWoMOZnfaanMMalSH6oe2H+Z648vYdTNBNiVPihwCP3/VK+DeBNE5
         4CVosx7M/9uEvIVeyNw+nF8IDE/3Pp8l+AlscnfHT3BvXmICr4fr9RkpPB8yH46Abv
         8HskldQxY+P+GZWi/KUdRJW/K0W3VvxYXBEpY9DeVzXhkPKDOZ8QiDmylJxVvd38Fy
         FvzSu0nLoKpAWTAF6tSXu/6Su5Umnm+LZqT6wY6F1WtO2PPVYsIa9iwBEfZ0bdk8VK
         xXar1smSr7YTA==
Date:   Tue, 2 Feb 2021 21:11:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v5 3/4] net/mlx5: Dynamically assign MSI-X
 vectors count
Message-ID: <20210202191116.GG3264866@unreal>
References: <20210126085730.1165673-4-leon@kernel.org>
 <20210202172508.GA113855@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202172508.GA113855@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 11:25:08AM -0600, Bjorn Helgaas wrote:
> On Tue, Jan 26, 2021 at 10:57:29AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > The number of MSI-X vectors is PCI property visible through lspci, that
> > field is read-only and configured by the device. The static assignment
> > of an amount of MSI-X vectors doesn't allow utilize the newly created
> > VF because it is not known to the device the future load and configuration
> > where that VF will be used.
> >
> > To overcome the inefficiency in the spread of such MSI-X vectors, we
> > allow the kernel to instruct the device with the needed number of such
> > vectors.
> >
> > Such change immediately increases the amount of MSI-X vectors for the
> > system with @ VFs from 12 vectors per-VF, to be 32 vectors per-VF.
>
> Not knowing anything about mlx5, it looks like maybe this gets some
> parameters from firmware on the device, then changes the way MSI-X
> vectors are distributed among VFs?

The mlx5 devices can operate in one of two modes: static MSI-X vector
table size and dynamic.

For the same number of VFs, the device will get 12 vectors per-VF in static
mode. In dynamic, the total number is higher and we will be able to distribute
new amount better.

>
> I don't understand the implications above about "static assignment"
> and "inefficiency in the spread."  I guess maybe this takes advantage
> of the fact that you know how many VFs are enabled, so if NumVFs is
> less that TotalVFs, you can assign more vectors to each VF?

Internally, in the FW, we are using different pool and configuration scheme
for such distribution. In static mode, the amount is pre-configured through
our FW configuration tool (nvconfig), in dynamic, the driver is fully
responsible. And yes. NumVFs helps to utilize it is better.

>
> If that's the case, spell it out a little bit.  The current text makes
> it sound like you discovered brand new MSI-X vectors somewhere,
> regardless of how many VFs are enabled, which doesn't sound right.

I will do.

>
> > Before this patch:
> > [root@server ~]# lspci -vs 0000:08:00.2
> > 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> > ....
> > 	Capabilities: [9c] MSI-X: Enable- Count=12 Masked-
> >
> > After this patch:
> > [root@server ~]# lspci -vs 0000:08:00.2
> > 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> > ....
> > 	Capabilities: [9c] MSI-X: Enable- Count=32 Masked-
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/main.c    |  4 ++
> >  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  5 ++
> >  .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 72 +++++++++++++++++++
> >  .../net/ethernet/mellanox/mlx5/core/sriov.c   | 13 +++-
> >  4 files changed, 92 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index ca6f2fc39ea0..79cfcc844156 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -567,6 +567,10 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
> >  	if (MLX5_CAP_GEN_MAX(dev, mkey_by_name))
> >  		MLX5_SET(cmd_hca_cap, set_hca_cap, mkey_by_name, 1);
> >
> > +	if (MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix))
> > +		MLX5_SET(cmd_hca_cap, set_hca_cap, num_total_dynamic_vf_msix,
> > +			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
> > +
> >  	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
> >  }
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> > index 0a0302ce7144..5babb4434a87 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> > @@ -172,6 +172,11 @@ int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
> >  		       struct notifier_block *nb);
> >  int mlx5_irq_detach_nb(struct mlx5_irq_table *irq_table, int vecidx,
> >  		       struct notifier_block *nb);
> > +
> > +int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
> > +			    int msix_vec_count);
> > +int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
> > +
> >  struct cpumask *
> >  mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
> >  struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> > index 6fd974920394..2a35888fcff0 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> > @@ -55,6 +55,78 @@ static struct mlx5_irq *mlx5_irq_get(struct mlx5_core_dev *dev, int vecidx)
> >  	return &irq_table->irq[vecidx];
> >  }
> >
> > +/**
> > + * mlx5_get_default_msix_vec_count() - Get defaults of number of MSI-X vectors
> > + * to be set
>
> s/defaults of number of/default number of/
> s/to be set/to be assigned to each VF/ ?
>
> > + * @dev: PF to work on
> > + * @num_vfs: Number of VFs was asked when SR-IOV was enabled
>
> s/Number of VFs was asked when SR-IOV was enabled/Number of enabled VFs/ ?
>
> > + **/
>
> Documentation/doc-guide/kernel-doc.rst says kernel-doc comments end
> with just "*/" (not "**/").

The netdev uses this style all other the place. Also it is internal API
call, the kdoc is not needed here, so I followed existing format.

I'll fix all comments and resubmit.

Thanks
