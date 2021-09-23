Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37577415846
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 08:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbhIWGhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 02:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239312AbhIWGhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 02:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE0F6103D;
        Thu, 23 Sep 2021 06:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632378935;
        bh=DEKVsUEz3rB/lWfDPCmtwUG21EgoliQ4AdWEdVy1G4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TYUzK6CIkvGFuMRyNE99h2HYsmLBhwlwdophnZordr6fK3vWI6QJ9YcWz2N4XDaab
         3qUohiEm+tsTsS+R3ftMBKqBt3PIubaDE3FGnu5HRSE8GPA7wV3dDIC21aSAZihvgy
         zO5z/S+AYuWJic/RgUSDTj8REgFAgMbf7xzxlOngNezsYacei0HI12BT1iGEAwqxmA
         SPycfdhf0XK/VvZSWAu+cBsqq0pcpbo/BAj5tEVydyxYY/lfV9gJh5UZY+26l32f7B
         z7gZwU5EHhV+G/MKWDkxzjHMhTXcV6EpKwLwsXLGymVQRSPXntArvr/W3vHeix2gLs
         c+0W+FZoW5BMA==
Date:   Thu, 23 Sep 2021 09:35:32 +0300
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
Message-ID: <YUwgNPL++APsFJ49@unreal>
References: <8d5bba9a6a1067989c3291fa2929528578812334.1632305919.git.leonro@nvidia.com>
 <20210922215930.GA231505@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922215930.GA231505@bhelgaas>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 04:59:30PM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 22, 2021 at 01:38:50PM +0300, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > The PCI core uses the VF index internally, often called the vf_id,
> > during the setup of the VF, eg pci_iov_add_virtfn().
> > 
> > This index is needed for device drivers that implement live migration
> > for their internal operations that configure/control their VFs.
> >
> > Specifically, mlx5_vfio_pci driver that is introduced in coming patches
> > from this series needs it and not the bus/device/function which is
> > exposed today.
> > 
> > Add pci_iov_vf_id() which computes the vf_id by reversing the math that
> > was used to create the bus/device/function.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> mlx5_core_sriov_set_msix_vec_count() looks like it does basically the
> same thing as pci_iov_vf_id() by iterating through VFs until it finds
> one with a matching devfn (although it *doesn't* check for a matching
> bus number, which seems like a bug).
> 
> Maybe that should use pci_iov_vf_id()?

Yes, I gave same comment internally and we decided to simply reduce the
amount of changes in mlx5_core to have less distractions and submit as a
followup. Most likely will add this hunk in v1.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index e8185b69ac6c..b66be0b4244a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -209,15 +209,8 @@ int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count)
        /* Reversed translation of PCI VF function number to the internal
         * function_id, which exists in the name of virtfn symlink.
         */
-       for (id = 0; id < pci_num_vf(pf); id++) {
-               if (!sriov->vfs_ctx[id].enabled)
-                       continue;
-
-               if (vf->devfn == pci_iov_virtfn_devfn(pf, id))
-                       break;
-       }
-
-       if (id == pci_num_vf(pf) || !sriov->vfs_ctx[id].enabled)
+       id = pci_iov_vf_id(vf);
+       if (id < 0 || !sriov->vfs_ctx[id].enabled)
                return -EINVAL;

        return mlx5_set_msix_vec_count(dev, id + 1, msix_vec_count);

Thanks

> 
> > ---
> >  drivers/pci/iov.c   | 14 ++++++++++++++
> >  include/linux/pci.h |  7 ++++++-
> >  2 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index dafdc652fcd0..e7751fa3fe0b 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -33,6 +33,20 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
> >  
> > +int pci_iov_vf_id(struct pci_dev *dev)
> > +{
> > +	struct pci_dev *pf;
> > +
> > +	if (!dev->is_virtfn)
> > +		return -EINVAL;
> > +
> > +	pf = pci_physfn(dev);
> > +	return (((dev->bus->number << 8) + dev->devfn) -
> > +		((pf->bus->number << 8) + pf->devfn + pf->sriov->offset)) /
> > +	       pf->sriov->stride;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_iov_vf_id);
> > +
> >  /*
> >   * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
> >   * change when NumVFs changes.
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index cd8aa6fce204..4d6c73506e18 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -2153,7 +2153,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
> >  #ifdef CONFIG_PCI_IOV
> >  int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
> >  int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
> > -
> > +int pci_iov_vf_id(struct pci_dev *dev);
> >  int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
> >  void pci_disable_sriov(struct pci_dev *dev);
> >  
> > @@ -2181,6 +2181,11 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
> >  {
> >  	return -ENOSYS;
> >  }
> > +static inline int pci_iov_vf_id(struct pci_dev *dev)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> 
> Drop the blank line to match the surrounding stubs.

Sure, thanks

> 
> >  static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
> >  { return -ENODEV; }
> 
