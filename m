Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04E415CAA
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbhIWLS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240493AbhIWLSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:18:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2566760EC0;
        Thu, 23 Sep 2021 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632395842;
        bh=zKKSudppIjrRqr4TCmMFfzY41RyPZoIxc16LkmrNL/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oGeyDLaX4lQGPaOi+ovJOGnARXuHikewcOJiJ3hcTJg+HCmlpKK1hZtk193nKXj4g
         VYu/lY3gBmp7kNdJui6EMFwTnpeYXgpuv0Bl+Y07GxUpVyxMBmGsSamPafWauMYP+k
         fqIh+VPDyu99HwV8vYMFOxlzjCs3iTdnatfa4xqRM8qSHWFfJaxrNeyFzV5OoA0D//
         POBzO/pushbYCHybc5JuG8dkHMipLBXOF6zYLttGANC2mQuh6OAygYDuVRmVU86wpm
         PuJj+caSmaVs+3Cs1WwJVmh3D/6t2pwj7pg7iw6BN4tNxHcGkmdJetP0VtBzM0XO1s
         pHvTXnMKMiWyw==
Date:   Thu, 23 Sep 2021 14:17:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <YUxiPqShZT4bk0uL@unreal>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <42729adc4df649f7b3ce5dc95e66e2dc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42729adc4df649f7b3ce5dc95e66e2dc@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 10:33:10AM +0000, Shameerali Kolothum Thodi wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon@kernel.org]
> > Sent: 22 September 2021 11:39
> > To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>; Alex Williamson
> > <alex.williamson@redhat.com>; Bjorn Helgaas <bhelgaas@google.com>; David
> > S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kirti
> > Wankhede <kwankhede@nvidia.com>; kvm@vger.kernel.org;
> > linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
> > linux-rdma@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > <saeedm@nvidia.com>
> > Subject: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
> > transition validity
> > 
> > From: Yishai Hadas <yishaih@nvidia.com>
> > 
> > Add an API in the core layer to check migration state transition validity
> > as part of a migration flow.
> > 
> > The valid transitions follow the expected usage as described in
> > uapi/vfio.h and triggered by QEMU.
> > 
> > This ensures that all migration implementations follow a consistent
> > migration state machine.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/vfio.c  | 41 +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h |  1 +
> >  2 files changed, 42 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 3c034fe14ccb..c3ca33e513c8 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -1664,6 +1664,47 @@ static int vfio_device_fops_release(struct inode
> > *inode, struct file *filep)
> >  	return 0;
> >  }
> > 
> > +/**
> > + * vfio_change_migration_state_allowed - Checks whether a migration state
> > + *   transition is valid.
> > + * @new_state: The new state to move to.
> > + * @old_state: The old state.
> > + * Return: true if the transition is valid.
> > + */
> > +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state)
> > +{
> > +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
> > +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
> > +		[VFIO_DEVICE_STATE_STOP] = {
> > +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> > +			[VFIO_DEVICE_STATE_RESUMING] = 1,
> > +		},
> > +		[VFIO_DEVICE_STATE_RUNNING] = {
> > +			[VFIO_DEVICE_STATE_STOP] = 1,
> > +			[VFIO_DEVICE_STATE_SAVING] = 1,
> > +			[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING]
> > = 1,
> 
> Do we need to allow _RESUMING state here or not? As per the "State transitions"
> section from uapi/linux/vfio.h, 

It looks like we missed this state transition.

Thanks

> 
> " * 4. To start the resuming phase, the device state should be transitioned from
>  *    the _RUNNING to the _RESUMING state."
> 
> IIRC, I have seen that transition happening on the destination dev while testing the 
> HiSilicon ACC dev migration. 
> 
> Thanks,
> Shameer
> 
> > +		},
> > +		[VFIO_DEVICE_STATE_SAVING] = {
> > +			[VFIO_DEVICE_STATE_STOP] = 1,
> > +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> > +		},
> > +		[VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING] = {
> > +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> > +			[VFIO_DEVICE_STATE_SAVING] = 1,
> > +		},
> > +		[VFIO_DEVICE_STATE_RESUMING] = {
> > +			[VFIO_DEVICE_STATE_RUNNING] = 1,
> > +			[VFIO_DEVICE_STATE_STOP] = 1,
> > +		},
> > +	};
> > +
> > +	if (new_state > MAX_STATE || old_state > MAX_STATE)
> > +		return false;
> > +
> > +	return vfio_from_state_table[old_state][new_state];
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_change_migration_state_allowed);
> > +
> >  static long vfio_device_fops_unl_ioctl(struct file *filep,
> >  				       unsigned int cmd, unsigned long arg)
> >  {
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index b53a9557884a..e65137a708f1 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -83,6 +83,7 @@ extern struct vfio_device
> > *vfio_device_get_from_dev(struct device *dev);
> >  extern void vfio_device_put(struct vfio_device *device);
> > 
> >  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> > +bool vfio_change_migration_state_allowed(u32 new_state, u32 old_state);
> > 
> >  /* events for the backend driver notify callback */
> >  enum vfio_iommu_notify_type {
> > --
> > 2.31.1
> 
