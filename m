Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF26E15F896
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389246AbgBNVRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389164AbgBNVRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 16:17:04 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0E6624650;
        Fri, 14 Feb 2020 21:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715024;
        bh=kwJZryH9PYTfAgDGtFgbmMLNd0kxk71mAKpiZB1yWV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pF9+ek0Z6PsREEEJaI4Y8E1Vz3bPtYrgr158u15CTfoyqrCzTSKk3QcMq5DIP8jNf
         iARoEJykQgwfBl5KjnUl/hz1O5dGTSLXb8e+DM0mKjaC/svwDs4ByXxNvdfL0QfNK1
         pRf55/6GIYzsM6RzxwTRLPSCHT5kAYpSO2v/wVmU=
Date:   Fri, 14 Feb 2020 15:45:00 -0500
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
Message-ID: <20200214204500.GC4086224@kroah.com>
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
> > > +	put_device(&vdev->dev);
> > > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > 
> > You need to do this before put_device().
> 
> Shouldn't it be in the release function? The ida index should not be
> re-used until the kref goes to zero..

Doesn't really matter, once you have unregistered it, you can reuse it.
But yes, putting it in release() is the safest thing to do.

> > > +struct virtbus_device {
> > > +	struct device dev;
> > > +	const char *name;
> > > +	void (*release)(struct virtbus_device *);
> > > +	int id;
> > > +	const struct virtbus_dev_id *matched_element;
> > > +};
> > 
> > Any reason you need to make "struct virtbus_device" a public structure
> > at all? 
> 
> The general point of this scheme is to do this in a public header:
> 
> +struct iidc_virtbus_object {
> +	struct virtbus_device vdev;
> +	struct iidc_peer_dev *peer_dev;
> +};
> 
> And then this when the driver binds:

Ah, yes, nevermind, I missed that.

greg k-h
