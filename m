Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7415F893
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389196AbgBNVRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389164AbgBNVRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 16:17:03 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69DF22314;
        Fri, 14 Feb 2020 21:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715023;
        bh=y3jgCNPs8S4Qg8H0qeaEJbTuKUejEsA/EKHTT3RzQb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQwJQrke1IlPPTKaC4LPRHgCZAV9ku9rhxN5fsi+/7qCvCfqp+Q62/jeWmwtzhDMH
         IXWDJEoL0UVcscaTEuwbTnI2mq5OV+i4NJOo0zwjQhm0yGsryMqae6j0nfoyzi3Ht1
         aezsSTHp+CJYefnMhC8xkz6hR2/awUt5C+Gu2/JM=
Date:   Fri, 14 Feb 2020 15:43:41 -0500
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
Message-ID: <20200214204341.GB4086224@kroah.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
 <20200214170240.GA4034785@kroah.com>
 <20200214203455.GX31668@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214203455.GX31668@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 04:34:55PM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 14, 2020 at 09:02:40AM -0800, Greg KH wrote:
> > > +/**
> > > + * virtbus_dev_register - add a virtual bus device
> > > + * @vdev: virtual bus device to add
> > > + */
> > > +int virtbus_dev_register(struct virtbus_device *vdev)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!vdev->release) {
> > > +		dev_err(&vdev->dev, "virtbus_device .release callback NULL\n");
> > 
> > "virtbus_device MUST have a .release callback that does something!\n" 
> > 
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	device_initialize(&vdev->dev);
> > > +
> > > +	vdev->dev.bus = &virtual_bus_type;
> > > +	vdev->dev.release = virtbus_dev_release;
> > > +	/* All device IDs are automatically allocated */
> > > +	ret = ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > > +	if (ret < 0) {
> > > +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> > > +		put_device(&vdev->dev);
> > 
> > If you allocate the number before device_initialize(), no need to call
> > put_device().  Just a minor thing, no big deal.
> 
> If *_regster does put_device on error then it must always do
> put_device on any error, for instance the above return -EINVAL with
> no put_device leaks memory.

That's why I said to move the ida_simple_get() call to before
device_initialize() is called.  Once device_initialize() is called, you
HAVE to call put_device().

Just trying to make code smaller :)

greg k-h
