Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F36120070
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLPI67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbfLPI67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 03:58:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBDC620725;
        Mon, 16 Dec 2019 08:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576486738;
        bh=EnZQIWB1lA6ulYzXsZ8ljZJd1sLn8omB6XyKYMsh2GY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ASetZ31CjFD2xyc3mPFsySo7doulRnvUBwtHsaEY02XZV/UIi7LpWDwMFQDs5xpf4
         G6ToqsVjwYtUaVsvdlkUQ83lNetmQbjf8ZhNViroGGBZheTDa9U5+6wa6X+vXG/2cy
         AviTx68x1qxjNh/4WNye3ZKb9+CyR+uXeUdYKCrQ=
Date:   Mon, 16 Dec 2019 09:58:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Message-ID: <20191216085852.GA1139951@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <4b7ee2ce-1415-7c58-f00e-6fdad08c1e99@mellanox.com>
 <20191216071509.GA916540@kroah.com>
 <b1242f0f-c34d-e6af-1731-fec9c947c478@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1242f0f-c34d-e6af-1731-fec9c947c478@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:36:02AM +0000, Parav Pandit wrote:
> On 12/16/2019 12:45 PM, Greg KH wrote:
> > On Mon, Dec 16, 2019 at 03:48:05AM +0000, Parav Pandit wrote:
> [..]
> >>> I feel like the virtual bus code is getting better, but this use of the
> >>> code, um, no, not ok.
> >>>
> >>> Either way, this series is NOT ready to be merged anywhere, please do
> >>> not try to rush things.
> >>>
> >>> Also, what ever happened to my "YOU ALL MUST AGREE TO WORK TOGETHER"
> >>> requirement between this group, and the other group trying to do the
> >>> same thing?  I want to see signed-off-by from EVERYONE involved before
> >>> we are going to consider this thing.
> >>
> >> I am working on RFC where PCI device is sliced to create sub-functions.
> >> Each sub-function/slice is created dynamically by the user.
> >> User gives sf-number at creation time which will be used for plumbing by
> >> systemd/udev, devlink ports.
> > 
> > That sounds exactly what is wanted here as well, right?
> 
> Not exactly.
> Here, in i40 use case - there is a PCI function.
> This PCI function is used by two drivers:
> (1) vendor_foo_netdev.ko creating Netdevice (class net)
> (2) vendor_foo_rdma.ko creating RDMA device (class infiniband)
> 
> And both drivers are notified using matching service virtbus, which
> attempts to create to two virtbus_devices with different driver-id, one
> for each class of device.

Yes, that is fine.

> However, devices of both class (net, infiniband) will have parent device
> as PCI device.

That is fine.

> In case of sub-functions, created rdma and netdevice will have parent as
> the sub-function 'struct device'. This way those SFs gets their
> systemd/udev plumbing done rightly.

huh?  The rdma and netdevice will have as their parent device the
virtdevice that is on the virtbus.  Not the PCI device's 'struct
device'.

thanks,

greg k-h
