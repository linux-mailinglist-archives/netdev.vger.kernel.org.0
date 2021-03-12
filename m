Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569103385E6
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 07:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhCLGck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 01:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhCLGcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 01:32:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A8264F7E;
        Fri, 12 Mar 2021 06:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615530735;
        bh=x7ZS2xlO1VmRSQpQBaH61aAHjBGzV0tZAn3dkwlPL6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OqZaGeJKWnJXu/p4ez/w4RCY87r5WqEi2oHol6Dit/kMCITyMoGfIs24KCRuJaShb
         QeMTMiJJBLTnkx74hBZHXL/NDiKSq1oNDU+12I6gJgu0d15WADfGzluVjT+QaZZyBz
         vkpVbwmNYjkiieLbtP3eDk0bc0SAaENgTiQtFgInsHN93VrptxeSMmmLO1ctEiClj9
         vOw2gcEJwqAOnq9CK3+Q6rTMfDK+zXxLtNGLKv0xJRjOlodgpqf9dsRUYJHYN/8lkC
         ObTh/bcCm6KKyCF38xWuv4IKMTdWQzXTfpcN8MzdlQdmJyY54euJu01ia3X1NWKVor
         Lfdr2vtOQ9mZg==
Date:   Fri, 12 Mar 2021 08:32:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEsK6zoNY+BXfbQ7@unreal>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
 <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com>
 <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 06:53:16PM -0800, Alexander Duyck wrote:
> On Thu, Mar 11, 2021 at 3:21 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Mar 11, 2021 at 01:49:24PM -0800, Alexander Duyck wrote:
> > > > We don't need to invent new locks and new complexity for something
> > > > that is trivially solved already.
> > >
> > > I am not wanting a new lock. What I am wanting is a way to mark the VF
> > > as being stale/offline while we are performing the update. With that
> > > we would be able to apply similar logic to any changes in the future.
> >
> > I think we should hold off doing this until someone comes up with HW
> > that needs it. The response time here is microseconds, it is not worth
> > any complexity

<...>

> Another way to think of this is that we are essentially pulling a
> device back after we have already allocated the VFs and we are
> reconfiguring it before pushing it back out for usage. Having a flag
> that we could set on the VF device to say it is "under
> construction"/modification/"not ready for use" would be quite useful I
> would think.

It is not simple flag change, but change of PCI state machine, which is
far more complex than holding two locks or call to sysfs_create_file in
the loop that made Bjorn nervous.

I want to remind again that the suggestion here has nothing to do with
the real use case of SR-IOV capable devices in the Linux.

The flow is:
1. Disable SR-IOV driver autoprobe
2. Create as much as possible VFs
3. Wait for request from the user to get VM
4. Change MSI-X table according to requested in item #3
5. Bind ready to go VF to VM
6. Inform user about VM readiness

The destroy flow includes VM destroy and unbind.

Let's focus on solutions for real problems instead of trying to solve theoretical
cases that are not going to be tested and deployed.

Thanks
