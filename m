Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0D22F05F8
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 09:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbhAJIah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 03:30:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbhAJIah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 03:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8420F22273;
        Sun, 10 Jan 2021 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610267396;
        bh=G+UQup1g+I+zstsEp0eshj8ErLn76Crd8fgT2ioXoa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZE5IHn/2SLhg4z/7JgaY9gBwRBFodS+X4SjYoPMffSAIdtDwGSVg5LKJgvPcndkrN
         WTGysMYyU07POEDgeyRV8EcQnRkCtWJQhth5SidSFpH2iDJ0C2C7pTUFq7xhOpEBU1
         0AjguLmhMW5LK6IPNx9cSoK+pJ1P9VIBh2+xq3PC1pCUikmHPbM+pa85hAu1XeWDpR
         8Zh003ZQ/0THeJv3dfedk7fxh1TEqwqN1ILZ6SZ0S3aUu1qsu/NNER8HaudCbqBpVl
         mhjVgGpRHlTpeIaCf0IUdBSgCW+nfJTu/FnfB2B/dAYz7BaI4qy94ZGbhBcOQVJGfq
         J7dDxXKeRK75w==
Date:   Sun, 10 Jan 2021 10:29:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Don Dutile <ddutile@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
Message-ID: <20210110082952.GF31158@unreal>
References: <20210108005721.GA1403391@bjorn-Precision-5520>
 <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> > [+cc Alex, Don]
> >
> > This patch does not actually *configure* the number of vectors, so the
> > subject is not quite accurate.  IIUC, this patch adds a sysfs file
> > that can be used to configure the number of vectors.  The subject
> > should mention the sysfs connection.
> >
> > On Sun, Jan 03, 2021 at 10:24:37AM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > This function is applicable for SR-IOV VFs because such devices allocate
> > > their MSI-X table before they will run on the targeted hardware and they
> > > can't guess the right amount of vectors.
> > This sentence doesn't quite have enough context to make sense to me.
> > Per PCIe r5.0, sec 9.5.1.2, I think PFs and VFs have independent MSI-X
> > Capabilities.  What is the connection between the PF MSI-X and the VF
> > MSI-X?
> +1... strip this commit log section and write it with correct, technical content.
> PFs & VF's have indep MSIX caps.
>
> Q: is this an issue where (some) mlx5's have a large msi-x capability (per VF) that may overwhelm a system's, (pci-(sub)-tree) MSI / intr capability,
> and this is a sysfs-based tuning knob to reduce the max number on such 'challenged' systems?
> -- ah; reading further below, it's based on some information gleemed from the VM's capability for intr. support.
>     -- or maybe IOMMU (intr) support on the host system, and the VF can't exceed it or config failure in VM... whatever... its some VM cap that's being accomodated.

I hope that this answers.
https://lore.kernel.org/linux-pci/20210110082206.GD31158@unreal/T/#md5dfc2edaaa686331ab3ce73496df7f58421c550

This feature is for MSI-X repartition and reduction.

> > The MSI-X table sizes should be determined by the Table Size in the
> > Message Control register.  Apparently we write a VF's Table Size
> > before a driver is bound to the VF?  Where does that happen?
> >
> > "Before they run on the targeted hardware" -- do you mean before the
> > VF is passed through to a guest virtual machine?  You mention "target
> > VM" below, which makes more sense to me.  VFs don't "run"; they're not
> > software.  I apologize for not being an expert in the use of VFs.
> >
> > Please mention the sysfs path in the commit log.
> >
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >   Documentation/ABI/testing/sysfs-bus-pci | 16 +++++++
> > >   drivers/pci/iov.c                       | 57 +++++++++++++++++++++++++
> > >   drivers/pci/msi.c                       | 30 +++++++++++++
> > >   drivers/pci/pci-sysfs.c                 |  1 +
> > >   drivers/pci/pci.h                       |  1 +
> > >   include/linux/pci.h                     |  8 ++++
> > >   6 files changed, 113 insertions(+)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> > > index 25c9c39770c6..30720a9e1386 100644
> > > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > > @@ -375,3 +375,19 @@ Description:
> > >   		The value comes from the PCI kernel device state and can be one
> > >   		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
> > >   		The file is read only.
> > > +
> > > +What:		/sys/bus/pci/devices/.../vf_msix_vec
> > > +Date:		December 2020
> > > +Contact:	Leon Romanovsky <leonro@nvidia.com>
> > > +Description:
> > > +		This file is associated with the SR-IOV VFs. It allows overwrite
> > > +		the amount of MSI-X vectors for that VF. This is needed to optimize
> > > +		performance of newly bounded devices by allocating the number of
> > > +		vectors based on the internal knowledge of targeted VM.
> > s/allows overwrite/allows configuration of/
> > s/for that/for the/
> > s/amount of/number of/
> > s/bounded/bound/
> >
> > What "internal knowledge" is this?  AFAICT this would have to be some
> > user-space administration knowledge, not anything internal to the
> > kernel.
> Correct; likely a libvirt VM (section of its) description;

Right, libvirt and/or orchestration software.

Thanks
