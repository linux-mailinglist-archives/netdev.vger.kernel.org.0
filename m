Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64224B8927
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 04:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437086AbfITCTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 22:19:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:25069 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437065AbfITCTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 22:19:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 19:19:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,527,1559545200"; 
   d="scan'208";a="362711315"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.71])
  by orsmga005.jf.intel.com with ESMTP; 19 Sep 2019 19:19:14 -0700
Date:   Fri, 20 Sep 2019 10:16:30 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [RFC v4 0/3] vhost: introduce mdev based hardware backend
Message-ID: <20190920021630.GA4108@___>
References: <20190917010204.30376-1-tiwei.bie@intel.com>
 <993841ed-942e-c90b-8016-8e7dc76bf13a@redhat.com>
 <20190917105801.GA24855@___>
 <fa6957f3-19ad-f351-8c43-65bc8342b82e@redhat.com>
 <20190918102923-mutt-send-email-mst@kernel.org>
 <d2efe7e4-cf13-437d-e2dc-e2779fac7d2f@redhat.com>
 <20190919154552.GA27657@___>
 <43aaf7dc-f08b-8898-3c55-908ff4d68866@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43aaf7dc-f08b-8898-3c55-908ff4d68866@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 09:30:58AM +0800, Jason Wang wrote:
> On 2019/9/19 下午11:45, Tiwei Bie wrote:
> > On Thu, Sep 19, 2019 at 09:08:11PM +0800, Jason Wang wrote:
> > > On 2019/9/18 下午10:32, Michael S. Tsirkin wrote:
> > > > > > > So I have some questions:
> > > > > > > 
> > > > > > > 1) Compared to method 2, what's the advantage of creating a new vhost char
> > > > > > > device? I guess it's for keep the API compatibility?
> > > > > > One benefit is that we can avoid doing vhost ioctls on
> > > > > > VFIO device fd.
> > > > > Yes, but any benefit from doing this?
> > > > It does seem a bit more modular, but it's certainly not a big deal.
> > > Ok, if we go this way, it could be as simple as provide some callback to
> > > vhost, then vhost can just forward the ioctl through parent_ops.
> > > 
> > > > > > > 2) For method 2, is there any easy way for user/admin to distinguish e.g
> > > > > > > ordinary vfio-mdev for vhost from ordinary vfio-mdev?
> > > > > > I think device-api could be a choice.
> > > > > Ok.
> > > > > 
> > > > > 
> > > > > > > I saw you introduce
> > > > > > > ops matching helper but it's not friendly to management.
> > > > > > The ops matching helper is just to check whether a given
> > > > > > vfio-device is based on a mdev device.
> > > > > > 
> > > > > > > 3) A drawback of 1) and 2) is that it must follow vfio_device_ops that
> > > > > > > assumes the parameter comes from userspace, it prevents support kernel
> > > > > > > virtio drivers.
> > > > > > > 
> > > > > > > 4) So comes the idea of method 3, since it register a new vhost-mdev driver,
> > > > > > > we can use device specific ops instead of VFIO ones, then we can have a
> > > > > > > common API between vDPA parent and vhost-mdev/virtio-mdev drivers.
> > > > > > As the above draft shows, this requires introducing a new
> > > > > > VFIO device driver. I think Alex's opinion matters here.
> > > Just to clarify, a new type of mdev driver but provides dummy
> > > vfio_device_ops for VFIO to make container DMA ioctl work.
> > I see. Thanks! IIUC, you mean we can provide a very tiny
> > VFIO device driver in drivers/vhost/mdev.c, e.g.:
> > 
> > static int vfio_vhost_mdev_open(void *device_data)
> > {
> > 	if (!try_module_get(THIS_MODULE))
> > 		return -ENODEV;
> > 	return 0;
> > }
> > 
> > static void vfio_vhost_mdev_release(void *device_data)
> > {
> > 	module_put(THIS_MODULE);
> > }
> > 
> > static const struct vfio_device_ops vfio_vhost_mdev_dev_ops = {
> > 	.name		= "vfio-vhost-mdev",
> > 	.open		= vfio_vhost_mdev_open,
> > 	.release	= vfio_vhost_mdev_release,
> > };
> > 
> > static int vhost_mdev_probe(struct device *dev)
> > {
> > 	struct mdev_device *mdev = to_mdev_device(dev);
> > 
> > 	... Check the mdev device_id proposed in ...
> > 	... https://lkml.org/lkml/2019/9/12/151 ...
> 
> 
> To clarify, this should be done through the id_table fields in
> vhost_mdev_driver, and it should claim it supports virtio-mdev device only:
> 
> 
> static struct mdev_class_id id_table[] = {
>     { MDEV_ID_VIRTIO },
>     { 0 },
> };
> 
> 
> static struct mdev_driver vhost_mdev_driver = {
>     ...
>     .id_table = id_table,
> }

In this way, both of virtio-mdev and vhost-mdev will try to
take this device. We may want a way to let vhost-mdev take this
device only when users explicitly ask it to do it. Or maybe we
can have a different MDEV_ID for vhost-mdev but share the device
ops with virtio-mdev.

> 
> 
> > 
> > 	return vfio_add_group_dev(dev, &vfio_vhost_mdev_dev_ops, mdev);
> 
> 
> And in vfio_vhost_mdev_ops, all its need is to just implement vhost-net
> ioctl and translate them to virtio-mdev transport (e.g device_ops I proposed
> or ioctls other whatever other method) API.

I see, so my previous understanding is basically correct:

https://lkml.org/lkml/2019/9/17/332

I.e. we won't have a separate vhost fd and we will do all vhost
ioctls on the VFIO device fd backed by this new VFIO driver.

> And it could have a dummy ops
> implementation for the other device_ops.
> 
> 
> > }
> > 
> > static void vhost_mdev_remove(struct device *dev)
> > {
> > 	vfio_del_group_dev(dev);
> > }
> > 
> > static struct mdev_driver vhost_mdev_driver = {
> > 	.name	= "vhost_mdev",
> > 	.probe	= vhost_mdev_probe,
> > 	.remove	= vhost_mdev_remove,
> > };
> > 
> > So we can bind above mdev driver to the virtio-mdev compatible
> > mdev devices when we want to use vhost-mdev.
> > 
> > After binding above driver to the mdev device, we can setup IOMMU
> > via VFIO and get VFIO device fd of this mdev device, and pass it
> > to vhost fd (/dev/vhost-mdev) with a SET_BACKEND ioctl.
> 
> 
> Then what vhost-mdev char device did is just forwarding ioctl back to this
> vfio device fd which seems a overkill. It's simpler that just do ioctl on
> the device ops directly.

Yes.

Thanks,
Tiwei


> 
> Thanks
> 
> 
> > 
> > Thanks,
> > Tiwei
> > 
> > > Thanks
> > > 
> > > 
> > > > > Yes, it is.
> > > > > 
> > > > > Thanks
> > > > > 
> > > > > 
