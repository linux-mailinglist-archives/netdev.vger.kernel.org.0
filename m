Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA45337F44
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhCKUus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhCKUun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:50:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2111164F85;
        Thu, 11 Mar 2021 20:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495842;
        bh=DI+EP7jvvI8zPaooAfT1H8L6lnFLOR6mT3+LqPukgAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nwM4AQxsZw2beRVHJbvVjmQvBy4DFXcV+MCtZ61v6zh5Zf59j7GwLlfX5zND1EtZE
         1qR7z8zcn9+FevBXUDKsGlmAwqHNfKjFfCXtllK6xPCaqsz3M6+nxc38D+TSnuI8v8
         xZbz5P3mrxHuulsmBKLUkGXQBGlBLKw7dZkdBeYsYWPbhq/q2kskAmcfwDup3v1zOT
         6o6d68BvfiarHUPmj0nHmSAkB/+em+sw5H1nOS/Q0eR0YQR0TCZzaMrvdBS9Df8Zgn
         2MQ53opVBFDR9X6zs6Ew4/whOMFx3ycHEZk/Flf+9qu2+RqJSqrvPLwZpMSfL5LHEK
         KXfpnG1ysDirg==
Date:   Fri, 12 Mar 2021 05:50:34 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
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
Message-ID: <20210311205034.GA32525@redsun51.ssa.fujisawa.hgst.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <20210311191602.GA36893@C02WT3WMHTD6>
 <20210311202234.GO2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311202234.GO2356281@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 04:22:34PM -0400, Jason Gunthorpe wrote:
> On Thu, Mar 11, 2021 at 12:16:02PM -0700, Keith Busch wrote:
> > On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> > > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > > > 
> > > > I'm not so much worried about management software as the fact that
> > > > this is a vendor specific implementation detail that is shaping how
> > > > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > > > know if there are any other vendors really onboard with this sort of
> > > > solution.
> > > 
> > > I know this is currently vendor-specific, but I thought the value
> > > proposition of dynamic configuration of VFs for different clients
> > > sounded compelling enough that other vendors would do something
> > > similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> > > maybe that's not the case?
> > 
> > NVMe has a similar feature defined by the standard where a PF controller can
> > dynamically assign MSIx vectors to VFs. The whole thing is managed in user
> > space with an ioctl, though. I guess we could wire up the driver to handle it
> > through this sysfs interface too, but I think the protocol specific tooling is
> > more appropriate for nvme.
> 
> Really? Why not share a common uAPI?

We associate interrupt vectors with other dynamically assigned nvme
specific resources (IO queues), and these are not always allocated 1:1.
A common uAPI for MSIx only gets us half way to configuring the VFs for
that particular driver.
 
> Do you have a standards reference for this?

Yes, sections 5.22 and 8.5 from this spec:

  https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4a-2020.03.09-Ratified.pdf

An example of open source tooling implementing this is nvme-cli's
"nvme virt-mgmt" command.
