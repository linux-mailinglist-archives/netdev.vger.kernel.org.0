Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B85615FBD8
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgBOA6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 19:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgBOA6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 19:58:48 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A1E20726;
        Sat, 15 Feb 2020 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581728327;
        bh=qQdMWI/hShIHuWjswHk7grezUTy23KqZTNQg7GC+6Nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gz+TIv6+Wc3ztCvMPoX1T/9kLzkclmcKq9t//snBno53dQ8MmkJQc3wjOEM84nHjm
         aDSAvRY96j0v1a4+5FgVzS4m2PjEvXojrA1xg7KQdDxNjHmJHyRWULYzKTB38CRvfG
         BgwE8TeZcGZwwLwmC7wmgy9zQOJI0b1zlF9yP5S0=
Date:   Fri, 14 Feb 2020 19:53:46 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, parav@mellanox.com, galpress@amazon.com,
        selvin.xavier@broadcom.com, sriharsha.basavapatna@broadcom.com,
        benve@cisco.com, bharat@chelsio.com, xavier.huwei@huawei.com,
        yishaih@mellanox.com, leonro@mellanox.com, mkalderon@marvell.com,
        aditr@vmware.com, Kiran Patil <kiran.patil@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Message-ID: <20200215005346.GB32359@kroah.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
 <20200214170240.GA4034785@kroah.com>
 <20200214203455.GX31668@ziepe.ca>
 <20200214204341.GB4086224@kroah.com>
 <20200215000154.GZ31668@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200215000154.GZ31668@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 08:01:54PM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 14, 2020 at 03:43:41PM -0500, Greg KH wrote:
> > On Fri, Feb 14, 2020 at 04:34:55PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Feb 14, 2020 at 09:02:40AM -0800, Greg KH wrote:
> > > > > +/**
> > > > > + * virtbus_dev_register - add a virtual bus device
> > > > > + * @vdev: virtual bus device to add
> > > > > + */
> > > > > +int virtbus_dev_register(struct virtbus_device *vdev)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!vdev->release) {
> > > > > +		dev_err(&vdev->dev, "virtbus_device .release callback NULL\n");
> > > > 
> > > > "virtbus_device MUST have a .release callback that does something!\n" 
> > > > 
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	device_initialize(&vdev->dev);
> > > > > +
> > > > > +	vdev->dev.bus = &virtual_bus_type;
> > > > > +	vdev->dev.release = virtbus_dev_release;
> > > > > +	/* All device IDs are automatically allocated */
> > > > > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > > > > +	if (ret < 0) {
> > > > > +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> > > > > +		put_device(&vdev->dev);
> > > > 
> > > > If you allocate the number before device_initialize(), no need to call
> > > > put_device().  Just a minor thing, no big deal.
> > > 
> > > If *_regster does put_device on error then it must always do
> > > put_device on any error, for instance the above return -EINVAL with
> > > no put_device leaks memory.
> > 
> > That's why I said to move the ida_simple_get() call to before
> > device_initialize() is called.  Once device_initialize() is called, you
> > HAVE to call put_device().
> 
> Yes put_device() becomes mandatory, but if the ida is moved up then
> the caller doesn't know how to handle an error:
> 
>    if (ida_simple_get() < 0)
>        return -EINVAL; // caller must do kfree
>    device_initialize();
>    if (device_register())
>        return -EINVAL // caller must do put_device

No, call put_device() before returning.

Ugh, anyway, this is all trivial stuff, the code is correct as-is,
nevermind.  If it bugs me enough, I'll send a patch that ends up
removing one more line of code than adding :)

greg k-h
