Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA71349989
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCYScl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhCYScF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 14:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 080CE619F7;
        Thu, 25 Mar 2021 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616697125;
        bh=vgaoyUHD2opsIULR8ITivkS+N3OHO+wLVMj+7x4VBmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHhacoc6sD0RKXuVGSYjpHegkZxCVCcT2pywrJYAL9SjOYqvvB9Gl8TM1LpxQBor3
         C7BT0Iy9eBUA4zPqrAvOFM0i2+ncfUoV64/ggWMZKy0RtochLFXp2SuDT/ybjdyWwM
         oVU6Phb4KColSRf9cO7dXCOK1UeL9TozihuQsyBB3osEvVSUU25iYU+84sbH/x94yc
         yPNtmN2zw7jaduLP2l0hhSLk+h6EqCm37VmFBvvVzZx9bJfUWtpmvPHLNOXC4hlfug
         MfwpXSqEK8RPlbywhi6Er8eE2TCaHQ2EmcSwX7tYZVidGzm6Z9VnmwE8/aPhrwCWJS
         BgbP43Xwepkfg==
Date:   Fri, 26 Mar 2021 03:31:57 +0900
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
Message-ID: <20210325183157.GA32286@redsun51.ssa.fujisawa.hgst.com>
References: <20210311214424.GQ2356281@nvidia.com>
 <20210325172144.GA696830@bjorn-Precision-5520>
 <20210325173646.GG2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325173646.GG2356281@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
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

I think that was someone else who said that.

FWIW, the nvme "offline" state just means a driver can't use the nvme
capabilities of the device. You can bind a driver to it if you want, but
no IO will be possible, so it's fine if you bind your VF to something
like vfio prior to starting a VM, or just not have a driver bound to
anything during the intial resource assignment.
 
> In linux offline and no driver attached are the same thing, you'd
> never want an API to make a nvme device with a driver attached offline
> because it would break the driver.
> 
> So I think it is good as is (well one of the 8 versions anyhow).
> 
> Keith didn't go into detail why the queue allocations in nvme were any
> different than the queue allocations in mlx5. 

The NVMe IO queue resources are assignable just like the MSIx vectors.
But they're not always assigned 1:1. For example:

  NVMe has an admin queue that always requires an interrupt vector. Does
  the VM driver want this vector to share with the IO queues, or do we
  want a +1 vector for that queue? 

  Maybe the VM is going to use a user space polling driver, so now you
  don't even need MSIx vectors on the function assigned to that VM. You
  just need to assign the IO queue resouces, and reserve the MSIx
  resources for another function.

  The Linux nvme driver allows a mix of poll + interrupt queues, so the
  user may want to allocate more IO queues than interrupts.

A kernel interface for assigning interrupt vectors gets us only halfway
to configuring the assignable resources.

> I expect they can probably work the same where the # of interrupts is
> an upper bound on the # of CPUs that can get queues and the device,
> once instantiated, could be configured for the number of queues to
> actually operate, if it wants.
