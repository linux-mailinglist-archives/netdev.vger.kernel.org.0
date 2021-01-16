Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54AE2F8C42
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 09:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbhAPIho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 03:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbhAPIho (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 03:37:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50D3323339;
        Sat, 16 Jan 2021 08:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610786223;
        bh=fUvGUa8buxclXkXy2ODilNx+gwyZaEszpeJx/QXoyOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GoFeK0uWk4BJEnorD8fa6slsAvhbOP/pVxsxaczQqnOnh9xtzhsYQV69eqwT/Pzb/
         NBxfqhXaOOEn7C2UR+qIqcal2RsW3zctlZIdEnmxIXTe1DOAcv93cQqLy/73I80TEM
         YYQsXJQ7C9jxI4lclMikQ1r/7d0E/K2P2SRuxPWfwmzOTTeP6TrxQzxoGoWn9ok/bq
         PmQaQUYrHyYRFXo1j5gNa+WamZZMiGXGFfikYKvDGAwSYDyHCmi9nzyBBOU7xkJP7I
         H/TZNNpwwlSu/Z9SmtL3m9odiVJ7vtHDUT8cESWGqpyLyvMxtIqf4x1zQ7xyDGRmuk
         mxCcghA8K7yjQ==
Date:   Sat, 16 Jan 2021 10:36:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH mlx5-next v2 2/5] PCI: Add SR-IOV sysfs entry to read
 total number of dynamic MSI-X vectors
Message-ID: <20210116083659.GM944463@unreal>
References: <20210114103140.866141-1-leon@kernel.org>
 <20210114103140.866141-3-leon@kernel.org>
 <20210114170536.004601d1@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114170536.004601d1@omen.home.shazbot.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:05:36PM -0700, Alex Williamson wrote:
> On Thu, 14 Jan 2021 12:31:37 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
>
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
> > index 34a8c6bcde70..530c249cc3da 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > @@ -395,3 +395,17 @@ Description:
> >  		The file is writable if the PF is bound to a driver that
> >  		set sriov_vf_total_msix > 0 and there is no driver bound
> >  		to the VF.
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
>
> As with previous, why expose it if not supported?

It is much simpler to the users implement logic that operates
accordingly to this value instead of relying on exist/not-exist and
anyway handle 0 to be on the safe side.

>
> This seems pretty challenging for userspace to use; aiui they would
> need to iterate all the VFs to learn how many vectors are already
> allocated, subtract that number from this value, all while hoping they
> aren't racing someone else doing the same.  Would it be more useful if
> this reported the number of surplus vectors available?

Only privileged users are allowed to do it, so it is unlikely that we
will have more than one entity which manages PFs/VFs assignments.

Users already count number of CPUs they give to the VMs, so counting
resources is not new to them.

I didn't count in the kernel because it will require from users to
understand and treat "0" differently to understand that the pool is
depleted. So they will need to count max size of the pool anyway.

Unless we want to have two knobs, one of max and another for current,
they will count. The thing is that users will count anyway and won't
use the current value. It gives nothing.

>
> How would a per VF limit be exposed?  Do we expect users to know the
> absolutely MSI-X vector limit or the device specific limit?  Thanks,

At this stage yes, we can discuss it later when the need will arise.

Thanks
