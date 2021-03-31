Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5534F8DE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhCaGjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233686AbhCaGim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 02:38:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEBFB61994;
        Wed, 31 Mar 2021 06:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617172722;
        bh=zQksZIaYo6ADILLxi+ozvpGeg9YmwSasUmij4Kbo66o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xP1VRycqtrE4Qgs/YtN/kTOX1Su8JNvi4H3bB6Se6ITEA8fHsSHmWK4vP3zmRJugb
         59jgHJErRIAY9NH3Pz1xU4Pi4iyVbaL3ekmSm0E4LWEqBbC1Y/Jl3rO6MDSgYHRC/O
         GnIzKiqiy83vYbb969Kis/Hglgehtq79QkDhr1O0=
Date:   Wed, 31 Mar 2021 08:38:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YGQY72LnGB6bfIsI@kroah.com>
References: <20210330194716.GV2710221@ziepe.ca>
 <20210330204141.GA1305530@bjorn-Precision-5520>
 <20210330224341.GW2710221@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330224341.GW2710221@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 07:43:41PM -0300, Jason Gunthorpe wrote:
> > With 0000:01:00.0/sriov/BB:DD.F/vf_msix_count, sriov/ will contain
> > 1 file and 1K subdirectories.
> 
> The smallest directory sizes is with the current patch since it
> re-uses the existing VF directory. Do we care about directory size at
> the sysfs level?

No, that should not matter.

The "issue" here is that you "broke" the device chain here by adding a
random kobject to the directory tree: "BB:DD.F"

Again, devices are allowed to have attributes associated with it to be
_ONE_ subdirectory level deep.

So, to use your path above, this is allowed:
	0000:01:00.0/sriov/vf_msix_count

as these are sriov attributes for the 0000:01:00.0 device, but this is
not:
	0000:01:00.0/sriov/BB:DD.F/vf_msix_count
as you "threw" a random kobject called BB:DD.F into the middle.

If you want to have "BB:DD.F" in there, then it needs to be a real
struct device and _THEN_ it needs to point its parent to "0000:01:00.0",
another struct device, as "sriov" is NOT ANYTHING in the heirachy here
at all.

Does that help?  The rules are:
	- Once you use a 'struct device', all subdirs below that device
	  are either an attribute group for that device or a child
	  device.
	- A struct device can NOT have an attribute group as a parent,
	  it can ONLY have another struct device as a parent.

If you break those rules, the kernel has the ability to get really
confused unless you are very careful, and userspace will be totally lost
as you can not do anything special there.

> > I'm dense and don't fully understand Greg's subdirectory comment.
> 
> I also don't know udev well enough. I've certainly seen drivers
> creating extra subdirectories using kobjects.

And those drivers are broken.  Please point them out to me and I will be
glad to go fix them.  Or tell their authors why they are broken :)

> > But it doesn't seem like that level of control would be in a udev rule
> > anyway.  A PF udev rule might *start* a program to manage MSI-X
> > vectors, but such a program should be able to deal with whatever
> > directory structure we want.
> 
> Yes, I can't really see this being used from udev either. 

It doesn't matter if you think it could be used, it _will_ be used as
you are exposing this stuff to userspace.

> I assume there is also the usual race about triggering the uevent
> before the subdirectories are created, but we have the
> dev_set_uevent_suppress() thing now for that..

Unless you are "pci bus code" you shouldn't be using that :)

thanks,

greg k-h
