Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FCF2F9132
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 08:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbhAQHEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 02:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbhAQHDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 02:03:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D59D122DCC;
        Sun, 17 Jan 2021 07:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610866988;
        bh=YArbnueRtnIjrGOTerwTqZg6yLJwCFTeTpU4TdS0lJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sehurNiwy22fR4D7DO0pi46g1Q83QUOiZQzpinsOWCfGFBWpyTKWWSJNd104iecyP
         1vA2mPIoS+5h0JxKlduiNu/kvlaFx4v4iMWfzqw4U8i5UqV9FtWbZFScEyLeujiFbY
         hzlo2JirDf14nd4onOtxSqIp9M4Fd09tmJ7C0B5s2YDKwhgy0g79GyUmIWGli5YL1r
         2cDy8/CQD0qR9+gnbmDGTOWEYcGuO8xhYiHkCc8GQALaRf7WzcaT8zXnksR7SeBsCi
         3sCzsz8AlmBbSIDGNkQaJc0p+TBVxuWdowGYYpDwKT2xW10v+7WYeYkK9LccK9kN6o
         eZt6ZtRAYcD4w==
Date:   Sun, 17 Jan 2021 09:03:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH mlx5-next v2 1/5] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210117070304.GA1226161@unreal>
References: <20210114103140.866141-1-leon@kernel.org>
 <20210114103140.866141-2-leon@kernel.org>
 <20210114170543.143cce49@omen.home.shazbot.org>
 <20210116082331.GL944463@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116082331.GL944463@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 10:23:31AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 14, 2021 at 05:05:43PM -0700, Alex Williamson wrote:
> > On Thu, 14 Jan 2021 12:31:36 +0200
> > Leon Romanovsky <leon@kernel.org> wrote:
> >
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
> > > The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count file will be seen
> > > for the VFs and it is writable as long as a driver is not bounded to the VF.
> > >
> > > The values accepted are:
> > >  * > 0 - this will be number reported by the VF's MSI-X capability
> > >  * < 0 - not valid
> > >  * = 0 - will reset to the device default value
> > >
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-bus-pci | 20 +++++++++
> > >  drivers/pci/iov.c                       | 58 +++++++++++++++++++++++++
> > >  drivers/pci/msi.c                       | 47 ++++++++++++++++++++
> > >  drivers/pci/pci-sysfs.c                 |  1 +
> > >  drivers/pci/pci.h                       |  2 +
> > >  include/linux/pci.h                     |  3 ++
> > >  6 files changed, 131 insertions(+)

<...>

> > > +static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
> > > +					  struct attribute *a, int n)
> > > +{
> > > +	struct device *dev = kobj_to_dev(kobj);
> > > +
> > > +	if (dev_is_pf(dev))
> > > +		return 0;
> >
> > Wouldn't it be cleaner to also hide this on VFs where
> > pci_msix_vec_count() returns an error or where the PF driver doesn't
> > implement .sriov_set_msix_vec_count()?  IOW, expose it only where it
> > could actually work.
>
> I wasn't sure about the policy in PCI/core, but sure will change.

I ended adding checks of msix_cap, but can't check .sriov_set_msix_vec_count.
The latter will require to hold device_lock on PF that can disappear later, it
is too racy.

Thanks
