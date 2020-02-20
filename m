Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDA2165531
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBTCmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:42:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:48607 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbgBTCmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:42:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 18:42:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="229327721"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga008.jf.intel.com with ESMTP; 19 Feb 2020 18:42:42 -0800
Date:   Thu, 20 Feb 2020 10:42:21 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200220024220.GA43609@___>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <20200218135359.GA9608@ziepe.ca>
 <20200219025217.GA971968@___>
 <20200219131102.GN31668@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200219131102.GN31668@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 09:11:02AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 19, 2020 at 10:52:38AM +0800, Tiwei Bie wrote:
> > > > +static int __init vhost_vdpa_init(void)
> > > > +{
> > > > +	int r;
> > > > +
> > > > +	idr_init(&vhost_vdpa.idr);
> > > > +	mutex_init(&vhost_vdpa.mutex);
> > > > +	init_waitqueue_head(&vhost_vdpa.release_q);
> > > > +
> > > > +	/* /dev/vhost-vdpa/$vdpa_device_index */
> > > > +	vhost_vdpa.class = class_create(THIS_MODULE, "vhost-vdpa");
> > > > +	if (IS_ERR(vhost_vdpa.class)) {
> > > > +		r = PTR_ERR(vhost_vdpa.class);
> > > > +		goto err_class;
> > > > +	}
> > > > +
> > > > +	vhost_vdpa.class->devnode = vhost_vdpa_devnode;
> > > > +
> > > > +	r = alloc_chrdev_region(&vhost_vdpa.devt, 0, MINORMASK + 1,
> > > > +				"vhost-vdpa");
> > > > +	if (r)
> > > > +		goto err_alloc_chrdev;
> > > > +
> > > > +	cdev_init(&vhost_vdpa.cdev, &vhost_vdpa_fops);
> > > > +	r = cdev_add(&vhost_vdpa.cdev, vhost_vdpa.devt, MINORMASK + 1);
> > > > +	if (r)
> > > > +		goto err_cdev_add;
> > > 
> > > It is very strange, is the intention to create a single global char
> > > dev?
> > 
> > No. It's to create a per-vdpa char dev named
> > vhost-vdpa/$vdpa_device_index in dev.
> > 
> > I followed the code in VFIO which creates char dev
> > vfio/$GROUP dynamically, e.g.:
> > 
> > https://github.com/torvalds/linux/blob/b1da3acc781c/drivers/vfio/vfio.c#L2164-L2180
> > https://github.com/torvalds/linux/blob/b1da3acc781c/drivers/vfio/vfio.c#L373-L387
> > https://github.com/torvalds/linux/blob/b1da3acc781c/drivers/vfio/vfio.c#L1553
> > 
> > Is it something unwanted?
> 
> Yes it is unwanted. This is some special pattern for vfio's unique
> needs. 
> 
> Since this has a struct device for each char dev instance please use
> the normal cdev_device_add() driven pattern here, or justify why it
> needs to be special like this.

I see. Thanks! I will embed the cdev in each vhost_vdpa
structure directly.

Regards,
Tiwei

> 
> Jason
