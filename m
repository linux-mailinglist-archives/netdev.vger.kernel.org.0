Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF812FB138
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 07:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbhASGVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:21:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728956AbhASFi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 00:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D9C0207B1;
        Tue, 19 Jan 2021 05:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611034691;
        bh=icZxTvui0uXyecHvXQypSINhhAwhfI8fl7Y6Gu74ZsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kqhF4JpoZe9r41AtsGL8PsbiLn37goEt/RLJHT0Yzu3GEL/SwoN4l1KPjk9uMKnxF
         CdTrhvzs1kF/TS/cT4vvlqs+fSyCPHTDWXHIB/gwRN17UpwQmNSnAs/Yeoh8kxSjJI
         3BedgcLkUiff1yGjcQffaOS2/Cuwsr39CUvZNCdA3MFA0a6fNPCBX0FQITAebvxfk6
         Fp0G7va5qGTQfRGN/aGafoGOLr9JkRJwilxVoHky480VAb3gTXbtgC8ZzTZiE1GaJp
         cZU1kZ0FteJqGXkXwRGrvPbvkS9vBdh5W4Zj8+fdwAB7itJejXlCSblgsH3MJGI1kx
         kw5qIP1QCpnVA==
Date:   Tue, 19 Jan 2021 07:38:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210119053807.GB21258@unreal>
References: <20210110150727.1965295-1-leon@kernel.org>
 <20210110150727.1965295-3-leon@kernel.org>
 <YAW/Wtr0thScxvK/@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAW/Wtr0thScxvK/@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 06:03:22PM +0100, Greg KH wrote:
> On Sun, Jan 10, 2021 at 05:07:24PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Some SR-IOV capable devices provide an ability to configure specific
> > number of MSI-X vectors on their VF prior driver is probed on that VF.
> >
> > In order to make management easy, provide new read-only sysfs file that
> > returns a total number of possible to configure MSI-X vectors.
> >
> > cat /sys/bus/pci/devices/.../sriov_vf_total_msix
> >   = 0 - feature is not supported
> >   > 0 - total number of MSI-X vectors to consume by the VFs
> >
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
> >  drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
> >  drivers/pci/pci.h                       |  3 +++
> >  include/linux/pci.h                     |  2 ++
> >  4 files changed, 50 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > index 05e26e5da54e..64e9b700acc9 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > @@ -395,3 +395,17 @@ Description:
> >  		The file is writable if the PF is bound to a driver that
> >  		supports the ->sriov_set_msix_vec_count() callback and there
> >  		is no driver bound to the VF.
> > +
> > +What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
> > +Date:		January 2021
> > +Contact:	Leon Romanovsky <leonro@nvidia.com>
> > +Description:
> > +		This file is associated with the SR-IOV PFs.
> > +		It returns a total number of possible to configure MSI-X
> > +		vectors on the enabled VFs.
> > +
> > +		The values returned are:
> > +		 * > 0 - this will be total number possible to consume by VFs,
> > +		 * = 0 - feature is not supported
> > +
> > +		If no SR-IOV VFs are enabled, this value will return 0.
> > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > index 42c0df4158d1..0a6ddf3230fd 100644
> > --- a/drivers/pci/iov.c
> > +++ b/drivers/pci/iov.c
> > @@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
> >  	return count;
> >  }
> >
> > +static ssize_t sriov_vf_total_msix_show(struct device *dev,
> > +					struct device_attribute *attr,
> > +					char *buf)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(dev);
> > +
> > +	return sprintf(buf, "%d\n", pdev->sriov->vf_total_msix);
>
> Nit, please use sysfs_emit() for new sysfs files.

I'll do, thanks.

>
> thanks,
>
> greg k-h
