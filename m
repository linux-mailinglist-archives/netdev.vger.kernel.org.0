Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10942F8019
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbhAOPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbhAOPyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 10:54:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4658E2399A;
        Fri, 15 Jan 2021 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610726000;
        bh=xcAi+Iqu4oZx2eusHike+l12iaufd9GIBbzS27SXg3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FL7JIj9n016W2xk4/IGq5WhiCJj6yJ6C3GaRg7NNrRa8+1vKZPkEd7/ZbjxugqZpK
         4n5LMOJRZvu2to4HoythVLQoixZ0bCCNE14FXSaShtgOa29y5V4J6gv1rKv5AqX9W+
         dhN69SJfvsbIC4d/qG9n4er39eqoydqTsnlAvoTBiyw4sKjFZD8gdMBVTxdrHHO8ly
         H6ypd/LbEZSG9vcGOKh1xkW7MnfzVi1VPLUmSIbttmweVAvJahFCN+jrs7vR4uhAbt
         b0jjAQKiu9riWrFV58saF/z4kOnyoGa/lGikyc9jRQ/7VimLVh+r/UzO46YHu+97kO
         P0S4Wk6vRvHOQ==
Date:   Fri, 15 Jan 2021 17:53:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210115155315.GJ944463@unreal>
References: <CAKgT0UeTXMeH24L9=wsPc2oJ=ZJ5jSpJeOqiJvsB2J9TFRFzwQ@mail.gmail.com>
 <20210114164857.GN4147@nvidia.com>
 <CAKgT0UcKqt=EgE+eitB8-u8LvxqHBDfF+u2ZSi5urP_Aj0Btvg@mail.gmail.com>
 <20210114182945.GO4147@nvidia.com>
 <CAKgT0UcQW+nJjTircZAYs1_GWNrRud=hSTsphfVpsc=xaF7aRQ@mail.gmail.com>
 <20210114200825.GR4147@nvidia.com>
 <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org>
 <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115140619.GA4147@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
>
> > That said, it only works at the driver level. So if the firmware is
> > the one that is having to do this it also occured to me that if this
> > update happened on FLR that would probably be preferred.
>
> FLR is not free, I'd prefer not to require it just for some
> philosophical reason.
>
> > Since the mlx5 already supports devlink I don't see any reason why the
> > driver couldn't be extended to also support the devlink resource
> > interface and apply it to interrupts.
>
> So you are OK with the PF changing the VF as long as it is devlink not
> sysfs? Seems rather arbitary?
>
> Leon knows best, but if I recall devlink becomes wonky when the VF
> driver doesn't provide a devlink instance. How does it do reload of a
> VF then?
>
> I think you end up with essentially the same logic as presented here
> with sysfs.

The reasons why I decided to go with sysfs are:
1. This MSI-X table size change is applicable to ALL devices in the world,
and not only netdev.
2. This is purely PCI field and apply equally with same logic to all
subsystems and not to netdev only.
3. The sysfs interface is the standard way of configuring PCI/core, not
devlink.
4. This is how orchestration software provisioning VFs already. It fits
real world usage of SR-IOV, not the artificial one that is proposed during
the discussion.

So the idea to use devlink just because mlx5 supports it, sound really
wrong to me. If it was other driver from another subsystem without
devlink support, the request to use devlink won't never come.

Thanks

>
> > > It is possible for vfio to fake the MSI-X capability and limit what a
> > > user can access, but I don't think that's what is being done here.
> >
> > Yeah, I am assuming that is what is being done here.
>
> Just to be really clear, that assumption is wrong
>
> Jason
