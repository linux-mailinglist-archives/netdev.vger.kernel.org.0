Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF5EA7906
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 04:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfIDCuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 22:50:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:28684 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbfIDCub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 22:50:31 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 19:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="183761055"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.71])
  by fmsmga007.fm.intel.com with ESMTP; 03 Sep 2019 19:50:28 -0700
Date:   Wed, 4 Sep 2019 10:48:01 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [RFC v3] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190904024801.GA5671@___>
References: <20190828053712.26106-1-tiwei.bie@intel.com>
 <20190903043704-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903043704-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 07:26:03AM -0400, Michael S. Tsirkin wrote:
> On Wed, Aug 28, 2019 at 01:37:12PM +0800, Tiwei Bie wrote:
> > Details about this can be found here:
> > 
> > https://lwn.net/Articles/750770/
> > 
> > What's new in this version
> > ==========================
> > 
> > There are three choices based on the discussion [1] in RFC v2:
> > 
> > > #1. We expose a VFIO device, so we can reuse the VFIO container/group
> > >     based DMA API and potentially reuse a lot of VFIO code in QEMU.
> > >
> > >     But in this case, we have two choices for the VFIO device interface
> > >     (i.e. the interface on top of VFIO device fd):
> > >
> > >     A) we may invent a new vhost protocol (as demonstrated by the code
> > >        in this RFC) on VFIO device fd to make it work in VFIO's way,
> > >        i.e. regions and irqs.
> > >
> > >     B) Or as you proposed, instead of inventing a new vhost protocol,
> > >        we can reuse most existing vhost ioctls on the VFIO device fd
> > >        directly. There should be no conflicts between the VFIO ioctls
> > >        (type is 0x3B) and VHOST ioctls (type is 0xAF) currently.
> > >
> > > #2. Instead of exposing a VFIO device, we may expose a VHOST device.
> > >     And we will introduce a new mdev driver vhost-mdev to do this.
> > >     It would be natural to reuse the existing kernel vhost interface
> > >     (ioctls) on it as much as possible. But we will need to invent
> > >     some APIs for DMA programming (reusing VHOST_SET_MEM_TABLE is a
> > >     choice, but it's too heavy and doesn't support vIOMMU by itself).
> > 
> > This version is more like a quick PoC to try Jason's proposal on
> > reusing vhost ioctls. And the second way (#1/B) in above three
> > choices was chosen in this version to demonstrate the idea quickly.
> > 
> > Now the userspace API looks like this:
> > 
> > - VFIO's container/group based IOMMU API is used to do the
> >   DMA programming.
> > 
> > - Vhost's existing ioctls are used to setup the device.
> > 
> > And the device will report device_api as "vfio-vhost".
> > 
> > Note that, there are dirty hacks in this version. If we decide to
> > go this way, some refactoring in vhost.c/vhost.h may be needed.
> > 
> > PS. The direct mapping of the notify registers isn't implemented
> >     in this version.
> > 
> > [1] https://lkml.org/lkml/2019/7/9/101
> > 
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> 
> ....
> 
> > +long vhost_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
> > +		      unsigned long arg)
> > +{
> > +	void __user *argp = (void __user *)arg;
> > +	struct vhost_mdev *vdpa;
> > +	unsigned long minsz;
> > +	int ret = 0;
> > +
> > +	if (!mdev)
> > +		return -EINVAL;
> > +
> > +	vdpa = mdev_get_drvdata(mdev);
> > +	if (!vdpa)
> > +		return -ENODEV;
> > +
> > +	switch (cmd) {
> > +	case VFIO_DEVICE_GET_INFO:
> > +	{
> > +		struct vfio_device_info info;
> > +
> > +		minsz = offsetofend(struct vfio_device_info, num_irqs);
> > +
> > +		if (copy_from_user(&info, (void __user *)arg, minsz)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		if (info.argsz < minsz) {
> > +			ret = -EINVAL;
> > +			break;
> > +		}
> > +
> > +		info.flags = VFIO_DEVICE_FLAGS_VHOST;
> > +		info.num_regions = 0;
> > +		info.num_irqs = 0;
> > +
> > +		if (copy_to_user((void __user *)arg, &info, minsz)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		break;
> > +	}
> > +	case VFIO_DEVICE_GET_REGION_INFO:
> > +	case VFIO_DEVICE_GET_IRQ_INFO:
> > +	case VFIO_DEVICE_SET_IRQS:
> > +	case VFIO_DEVICE_RESET:
> > +		ret = -EINVAL;
> > +		break;
> > +
> > +	case VHOST_MDEV_SET_STATE:
> > +		ret = vhost_set_state(vdpa, argp);
> > +		break;
> > +	case VHOST_GET_FEATURES:
> > +		ret = vhost_get_features(vdpa, argp);
> > +		break;
> > +	case VHOST_SET_FEATURES:
> > +		ret = vhost_set_features(vdpa, argp);
> > +		break;
> > +	case VHOST_GET_VRING_BASE:
> > +		ret = vhost_get_vring_base(vdpa, argp);
> > +		break;
> > +	default:
> > +		ret = vhost_dev_ioctl(&vdpa->dev, cmd, argp);
> > +		if (ret == -ENOIOCTLCMD)
> > +			ret = vhost_vring_ioctl(&vdpa->dev, cmd, argp);
> > +	}
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(vhost_mdev_ioctl);
> 
> 
> I don't have a problem with this approach. A small question:
> would it make sense to have two fds: send vhost ioctls
> on one and vfio ioctls on another?
> We can then pass vfio fd to the vhost fd with a
> SET_BACKEND ioctl.
> 
> What do you think?

I like this idea! I will give it a try.
So we can introduce /dev/vhost-mdev to have the vhost fd, and let
userspace pass vfio fd to the vhost fd with a SET_BACKEND ioctl.

Thanks a lot!
Tiwei

> 
> -- 
> MST
