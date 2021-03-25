Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14253497CC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCYRWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhCYRVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1340D61A0E;
        Thu, 25 Mar 2021 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616692906;
        bh=OgKWZEOsJOK4/SVXsL7MTI612oZFPQhN5a0ZrYVs5Aw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Mln6K4ETpsF7fXVHN7FbRe0JZdRt+oUhar/kUUDoYPq8YG/QLMU8nry6pElxi6Y9r
         gtDNh9l+AoBnTkeKnwM+Wer0iZ06AGBDEUQ4Lt9xMhyhjAPpp5apn/WWos0OcVQ7Du
         Quyk1n0/DoyB+unu9q5n3V5jq4Oy1sYL15lXv9JPrREOuMCUXIpsy8p93HfvPNdIY7
         UMO+FcHfqTxBwk3LDBDRzE2CwFTVvXbCLEPx9BwdpU0bBFowIrn1tUMav0/CtUxRCe
         3RT2VuGXvJA9XnnHSfWDq3bNcw/3FeSth0v6OuPzixhTihSYJWLgte4bE4ZlXbZEhk
         ljsgsBqmtkzjQ==
Date:   Thu, 25 Mar 2021 12:21:44 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20210325172144.GA696830@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311214424.GQ2356281@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 05:44:24PM -0400, Jason Gunthorpe wrote:
> On Fri, Mar 12, 2021 at 05:50:34AM +0900, Keith Busch wrote:
> > On Thu, Mar 11, 2021 at 04:22:34PM -0400, Jason Gunthorpe wrote:
> > > On Thu, Mar 11, 2021 at 12:16:02PM -0700, Keith Busch wrote:
> > > > On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> > > > > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > > > > > 
> > > > > > I'm not so much worried about management software as the
> > > > > > fact that this is a vendor specific implementation detail
> > > > > > that is shaping how the kernel interfaces are meant to
> > > > > > work. Other than the mlx5 I don't know if there are any
> > > > > > other vendors really onboard with this sort of solution.
> > > > > 
> > > > > I know this is currently vendor-specific, but I thought the
> > > > > value proposition of dynamic configuration of VFs for
> > > > > different clients sounded compelling enough that other
> > > > > vendors would do something similar.  But I'm not an SR-IOV
> > > > > guy and have no vendor insight, so maybe that's not the
> > > > > case?
> > > > 
> > > > NVMe has a similar feature defined by the standard where a PF
> > > > controller can dynamically assign MSIx vectors to VFs. The
> > > > whole thing is managed in user space with an ioctl, though. I
> > > > guess we could wire up the driver to handle it through this
> > > > sysfs interface too, but I think the protocol specific tooling
> > > > is more appropriate for nvme.
> > > 
> > > Really? Why not share a common uAPI?
> > 
> > We associate interrupt vectors with other dynamically assigned
> > nvme specific resources (IO queues), and these are not always
> > allocated 1:1.
> 
> mlx5 is doing that too, the end driver gets to assign the MSI vector
> to a CPU and then dynamically attach queues to it.
> 
> I'm not sure I get why nvme would want to link those two things as
> the CPU assignment and queue attach could happen in a VM while the
> MSIX should be in the host?
> 
> > A common uAPI for MSIx only gets us half way to configuring the
> > VFs for that particular driver.
> >
> > > Do you have a standards reference for this?
> > 
> > Yes, sections 5.22 and 8.5 from this spec:
> > 
> >   https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4a-2020.03.09-Ratified.pdf
> > 
> > An example of open source tooling implementing this is nvme-cli's
> > "nvme virt-mgmt" command.
> 
> Oh it is fascinating! 8.5.2 looks like exactly the same thing being
> implemented here for mlx5, including changing the "Read only" config
> space value
> 
> Still confused why this shouldn't be the same API??

NVMe and mlx5 have basically identical functionality in this respect.
Other devices and vendors will likely implement similar functionality.
It would be ideal if we had an interface generic enough to support
them all.

Is the mlx5 interface proposed here sufficient to support the NVMe
model?  I think it's close, but not quite, because the the NVMe
"offline" state isn't explicitly visible in the mlx5 model.

I'd like to see an argument that nvme-cli *could* be implemented on
top of this.  nvme-cli uses an ioctl and we may not want to
reimplement it with a new interface, but if Leon's interface is
*capable* of supporting the NVMe model, it's a good clue that it may
also work for future devices.

If this isn't quite enough to support the NVMe model, what would it
take to get there?

Bjorn
