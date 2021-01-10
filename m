Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECC52F0610
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 09:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbhAJIsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 03:48:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbhAJIsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 03:48:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B31ED239EB;
        Sun, 10 Jan 2021 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610268459;
        bh=irKAhtaJtCZe7N6lWVZH9hxZFfZco7OZkLCmKDfdn88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAS/0EP5SqObKkIVZntlBA6V9qV71hEJ1cFHBihZ7qcN1biUc63pVcAbKioWPMj0a
         79/x4ZxBMDd3rcA+f1fspyX3ayFf/MGSrAeG5xq4F64ZQsnmA9+nBhrgsJs2vsop2k
         KEz80++RprQXuTHZThW2vLo+gaSuQtoVpXi4QcyK85O9gHuztKQosoB4ji4foSE5q9
         tO4HprIXJCb9PQr8owxzgkBWF2vo86v+lOO2J0iboKIteAXXEKUzjShV+vZbifG/hE
         ZvHS3QM3ih0TEIKT5Id3QfRtolvGajdm82mb+4irp8m+UK/ZZzFHj54oZyEJnJLqrG
         kqd46rVmb81RQ==
Date:   Sun, 10 Jan 2021 10:47:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
Message-ID: <20210110084735.GH31158@unreal>
References: <20210108005721.GA1403391@bjorn-Precision-5520>
 <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
 <20210108072525.GB31158@unreal>
 <20210108092145.7c70ff74@omen.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108092145.7c70ff74@omen.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 09:21:45AM -0700, Alex Williamson wrote:
> On Fri, 8 Jan 2021 09:25:25 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> > > On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
> > > > [+cc Alex, Don]
> >
> > <...>
> >
> > > > Help me connect the dots here.  Is this required because of something
> > > > peculiar to mlx5, or is something like this required for all SR-IOV
> > > > devices because of the way the PCIe spec is written?
> > > So, overall, I'm guessing the mlx5 device can have 1000's of MSIX -- say, one per send/receive/completion queue.
> > > This device capability may exceed the max number MSIX a VM can have/support (depending on guestos).
> > > So, a sysfs tunable is used to set the max MSIX available, and thus, the device puts >1 send/rcv/completion queue intr on a given MSIX.
> > >
> > > ok, time for Leon to better state what this patch does,
> > > and why it's needed on mlx5 (and may be applicable to other/future high-MSIX devices assigned to VMs (NVME?)).
> > > Hmmm, now that I said it, why is it SRIOV-centric and not pci-device centric (can pass a PF w/high number of MSIX to a VM).
> >
> > Thanks Don and Bjorn,
> >
> > I will answer on all comments a little bit later when I will return
> > to the office (Sunday).
> >
> > However it is important for me to present the use case.
> >
> > Our mlx5 SR-IOV devices were always capable to drive many MSI-X (upto 2K,
> > don't catch me on exact number), however when user created VFs, the FW has
> > no knowledge of how those VFs will be used. So FW had no choice but statically
> > and equally assign same amount of MSI-X to all VFs.
> >
> > After SR-IOV VF creation, user will bind those new VFs to the VMs, but
> > the VMs have different number of CPUs and despite HW being able to deliver
> > all needed number of vectors (in mlx5 netdev world, number of channels == number
> > of CPUs == number of vectors), we will be limited by already set low number
> > of vectors.
> >
> > So it is not for vector reduction, but more for vector re-partition.
> >
> > As an example, imagine mlx5 with two VFs. One VF is bounded to VM with 200 CPUs
> > and another is bounded to VM with 1 CPU. They need different amount of MSI-X vectors.
> >
> > Hope that I succeeded to explain :).
>
> The idea is not unreasonable imo, but without knowing the size of the
> vector pool, range available per vf, or ultimately whether the vf
> supports this feature before we try to configure it, I don't see how
> userspace is expected to make use of this in the general case.  If the
> configuration requires such specific vf vector usage and pf driver
> specific knowledge, I'm not sure it's fit as a generic pci-sysfs
> interface.  Thanks,

I didn't prohibit read of newly created sysfs file, but if I change
the implementation to vf_msix_vec_show() to return -EOPNOTSUPP for
not-supported device, the software will be able to distinguish
supported/not-supported.

SW will read this file:
	-> success -> feature supported
	-> failure -> feature not supported

There is one extra sysfs file needed: vf_total_msix. That file will
give total number of MSI-X vectors that is possible to configure.

The same logic (supported/not-supported) can be applicable here as well.

The feature itself will be used by orchestration software that will
make decisions based on already configured values or future promises
and the overall total number. The positive outcome of this scheme
that driver stays lean.

Thanks

>
> Alex
>
