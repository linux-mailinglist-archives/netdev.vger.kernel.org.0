Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69151338EEE
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 14:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCLNhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 08:37:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhCLNgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 08:36:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E742064FD6;
        Fri, 12 Mar 2021 13:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615556199;
        bh=IgvfWN4FdKSbPuArR2z1vB9S58Cgh830mSjrvY30dD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8JTJKYFV4htN57lyadr7mDInf3Ile3Cs8/BNb08hzSxINfojXFlcS0wO/c1B0HRb
         3blvXwHL3ASCIAeDyAunDeNd12LDsyKjrv0hCDuSZGqjAGhfAriM6xVAAedmbmUUfo
         vCS1gCe2EwCdpIgH4mO5d+XnxmRHN0Chi2TvJUIWEcHrHleGhHy1fwspH7Q7hSExJJ
         XTAZm8YvfawT3K/xTA2PGPGa3cUagnoEoP0jUUfAmRoHKkb/leKRjI9JH3spSzsGQe
         QvOeUHE1U8cVKdHwSsvHuislYrOH+bu/egR68VB4LwErOuD+HXr/Wm+zk7Q+dhx9Q8
         3qR97yJZRrayA==
Date:   Fri, 12 Mar 2021 06:36:37 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210312133637.GA43947@C02WT3WMHTD6>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
 <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com>
 <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
 <20210312130017.GT2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312130017.GT2356281@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 09:00:17AM -0400, Jason Gunthorpe wrote:
> On Thu, Mar 11, 2021 at 06:53:16PM -0800, Alexander Duyck wrote:
> > On Thu, Mar 11, 2021 at 3:21 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Thu, Mar 11, 2021 at 01:49:24PM -0800, Alexander Duyck wrote:
> > > > > We don't need to invent new locks and new complexity for something
> > > > > that is trivially solved already.
> > > >
> > > > I am not wanting a new lock. What I am wanting is a way to mark the VF
> > > > as being stale/offline while we are performing the update. With that
> > > > we would be able to apply similar logic to any changes in the future.
> > >
> > > I think we should hold off doing this until someone comes up with HW
> > > that needs it. The response time here is microseconds, it is not worth
> > > any complexity
> > 
> > I disagree. Take a look at section 8.5.3 in the NVMe document that was
> > linked to earlier:
> > https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4a-2020.03.09-Ratified.pdf
> > 
> > This is exactly what they are doing and I think it makes a ton of
> > sense. Basically the VF has to be taken "offline" before you are
> 
> AFAIK this is internal to the NVMe command protocol, not something we
> can expose generically to the OS. mlx5 has no protocol to "offline" an
> already running VF, for instance.
> 
> The way Leon has it arranged that online/offline scheme has no
> relevance because there is no driver or guest attached to the VF to
> see the online/offline transition.
> 
> I wonder if people actually do offline a NVMe VF from a hypervisor?
> Seems pretty weird.

I agree, that would be weird. I'm pretty sure you can't modify these resources
once you attach the nvme VF to a guest. The resource allocation needs to happen
prior to that.
 
> > Another way to think of this is that we are essentially pulling a
> > device back after we have already allocated the VFs and we are
> > reconfiguring it before pushing it back out for usage. Having a flag
> > that we could set on the VF device to say it is "under
> > construction"/modification/"not ready for use" would be quite useful I
> > would think.
> 
> Well, yes, the whole SRIOV VF lifecycle is a pretty bad fit for the
> modern world.
> 
> I'd rather not see a half-job on a lifecycle model by hacking in
> random flags. It needs a proper comprehensive design.
> 
> Jason
