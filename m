Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3E6349967
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhCYSUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhCYSUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 14:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B369F619F3;
        Thu, 25 Mar 2021 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616696423;
        bh=nYvyamT1qqwFUF7/E24BZ7nx9p3alEmWvbnRcQoeHHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=vOhDpc9QBTn7vY3+oOG3UeN04MYRiJeYK8xCxF8nv7f0+Iap3bjEyhOwNW/e7Q3xA
         eaP2YCNXjBelFVu8OJf07eGJHtLaRlzQ0ZVyPz4D72aQx8nP65R++wFIyr9PUAziwT
         NSpQc9ovIqlK0/z7qBHkj+B3HnxhvKPJ4bp1kPQSYwn9sbaDjtxti9WQXVdTGoTOd1
         I21/HwBSALlPo5io6do9u0gOAHOVoKdC+6PRtwouQ8vyKUDidM1QCl2T5gtYPeRSyY
         igo8mVSncCx4K3CeO3xj0jrf/OoHrvphOA/Ohz0dCFDoG7IYnUZx7EHvrb/h+t1ACM
         EMjJiaD/HMmdQ==
Date:   Thu, 25 Mar 2021 13:20:21 -0500
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
Message-ID: <20210325182021.GA795636@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325173646.GG2356281@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> 
> > NVMe and mlx5 have basically identical functionality in this respect.
> > Other devices and vendors will likely implement similar functionality.
> > It would be ideal if we had an interface generic enough to support
> > them all.
> > 
> > Is the mlx5 interface proposed here sufficient to support the NVMe
> > model?  I think it's close, but not quite, because the the NVMe
> > "offline" state isn't explicitly visible in the mlx5 model.
> 
> I thought Keith basically said "offline" wasn't really useful as a
> distinct idea. It is an artifact of nvme being a standards body
> divorced from the operating system.
> 
> In linux offline and no driver attached are the same thing, you'd
> never want an API to make a nvme device with a driver attached offline
> because it would break the driver.

I think the sticky part is that Linux driver attach is not visible to
the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
can only assign resources to a VF when the VF is offline, and the VF
is only usable when it is online.

For NVMe, software must ask the PF to make those online/offline
transitions via Secondary Controller Offline and Secondary Controller
Online commands [1].  How would this be integrated into this sysfs
interface?

> So I think it is good as is (well one of the 8 versions anyhow).
> 
> Keith didn't go into detail why the queue allocations in nvme were any
> different than the queue allocations in mlx5. I expect they can
> probably work the same where the # of interrupts is an upper bound on
> the # of CPUs that can get queues and the device, once instantiated,
> could be configured for the number of queues to actually operate, if
> it wants.

I don't really care about the queue allocations.  I don't think we
need to solve those here; we just need to make sure that what we do
here doesn't preclude NVMe queue allocations.

Bjorn

[1] NVMe 1.4a, sec 5.22
