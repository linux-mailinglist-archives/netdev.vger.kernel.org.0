Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C289E1796
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404370AbfJWKOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:14:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:6622 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404000AbfJWKOq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 06:14:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 03:14:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="197388690"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 03:14:42 -0700
Date:   Wed, 23 Oct 2019 18:11:36 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
Message-ID: <20191023101135.GA6367@___>
References: <20191022095230.2514-1-tiwei.bie@intel.com>
 <47a572fd-5597-1972-e177-8ee25ca51247@redhat.com>
 <20191023030253.GA15401@___>
 <ac36f1e3-b972-71ac-fe0c-3db03e016dcf@redhat.com>
 <20191023070747.GA30533@___>
 <106834b5-dae5-82b2-0f97-16951709d075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <106834b5-dae5-82b2-0f97-16951709d075@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 03:25:00PM +0800, Jason Wang wrote:
> On 2019/10/23 下午3:07, Tiwei Bie wrote:
> > On Wed, Oct 23, 2019 at 01:46:23PM +0800, Jason Wang wrote:
> > > On 2019/10/23 上午11:02, Tiwei Bie wrote:
> > > > On Tue, Oct 22, 2019 at 09:30:16PM +0800, Jason Wang wrote:
> > > > > On 2019/10/22 下午5:52, Tiwei Bie wrote:
> > > > > > This patch introduces a mdev based hardware vhost backend.
> > > > > > This backend is built on top of the same abstraction used
> > > > > > in virtio-mdev and provides a generic vhost interface for
> > > > > > userspace to accelerate the virtio devices in guest.
> > > > > > 
> > > > > > This backend is implemented as a mdev device driver on top
> > > > > > of the same mdev device ops used in virtio-mdev but using
> > > > > > a different mdev class id, and it will register the device
> > > > > > as a VFIO device for userspace to use. Userspace can setup
> > > > > > the IOMMU with the existing VFIO container/group APIs and
> > > > > > then get the device fd with the device name. After getting
> > > > > > the device fd of this device, userspace can use vhost ioctls
> > > > > > to setup the backend.
> > > > > > 
> > > > > > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > > > > > ---
> > > > > > This patch depends on below series:
> > > > > > https://lkml.org/lkml/2019/10/17/286
> > > > > > 
> > > > > > v1 -> v2:
> > > > > > - Replace _SET_STATE with _SET_STATUS (MST);
> > > > > > - Check status bits at each step (MST);
> > > > > > - Report the max ring size and max number of queues (MST);
> > > > > > - Add missing MODULE_DEVICE_TABLE (Jason);
> > > > > > - Only support the network backend w/o multiqueue for now;
> > > > > Any idea on how to extend it to support devices other than net? I think we
> > > > > want a generic API or an API that could be made generic in the future.
> > > > > 
> > > > > Do we want to e.g having a generic vhost mdev for all kinds of devices or
> > > > > introducing e.g vhost-net-mdev and vhost-scsi-mdev?
> > > > One possible way is to do what vhost-user does. I.e. Apart from
> > > > the generic ring, features, ... related ioctls, we also introduce
> > > > device specific ioctls when we need them. As vhost-mdev just needs
> > > > to forward configs between parent and userspace and even won't
> > > > cache any info when possible,
> > > 
> > > So it looks to me this is only possible if we expose e.g set_config and
> > > get_config to userspace.
> > The set_config and get_config interface isn't really everything
> > of device specific settings. We also have ctrlq in virtio-net.
> 
> 
> Yes, but it could be processed by the exist API. Isn't it? Just set ctrl vq
> address and let parent to deal with that.

I mean how to expose ctrlq related settings to userspace?

> 
> 
> > 
> > > 
> > > > I think it might be better to do
> > > > this in one generic vhost-mdev module.
> > > 
> > > Looking at definitions of VhostUserRequest in qemu, it mixed generic API
> > > with device specific API. If we want go this ways (a generic vhost-mdev),
> > > more questions needs to be answered:
> > > 
> > > 1) How could userspace know which type of vhost it would use? Do we need to
> > > expose virtio subsystem device in for userspace this case?
> > > 
> > > 2) That generic vhost-mdev module still need to filter out unsupported
> > > ioctls for a specific type. E.g if it probes a net device, it should refuse
> > > API for other type. This in fact a vhost-mdev-net but just not modularize it
> > > on top of vhost-mdev.
> > > 
> > > 
> > > > > > - Some minor fixes and improvements;
> > > > > > - Rebase on top of virtio-mdev series v4;
> > [...]
> > > > > > +
> > > > > > +static long vhost_mdev_get_features(struct vhost_mdev *m, u64 __user *featurep)
> > > > > > +{
> > > > > > +	if (copy_to_user(featurep, &m->features, sizeof(m->features)))
> > > > > > +		return -EFAULT;
> > > > > As discussed in previous version do we need to filter out MQ feature here?
> > > > I think it's more straightforward to let the parent drivers to
> > > > filter out the unsupported features. Otherwise it would be tricky
> > > > when we want to add more features in vhost-mdev module,
> > > 
> > > It's as simple as remove the feature from blacklist?
> > It's not really that easy. It may break the old drivers.
> 
> 
> I'm not sure I understand here, we do feature negotiation anyhow. For old
> drivers do you mean the guest drivers without MQ?

For old drivers I mean old parent drivers. It's possible
to compile old drivers on new kernels.

I'm not quite sure how will we implement MQ support in
vhost-mdev. If we need to introduce new virtio_mdev_device_ops
callbacks and an old driver exposed the MQ feature,
then the new vhost-mdev will see this old driver expose
MQ feature but not provide corresponding callbacks.

> 
> 
> > 
> > > 
> > > > i.e. if
> > > > the parent drivers may expose unsupported features and relay on
> > > > vhost-mdev to filter them out, these features will be exposed
> > > > to userspace automatically when they are enabled in vhost-mdev
> > > > in the future.
> > > 
> > > The issue is, it's only that vhost-mdev knows its own limitation. E.g in
> > > this patch, vhost-mdev only implements a subset of transport API, but parent
> > > doesn't know about that.
> > > 
> > > Still MQ as an example, there's no way (or no need) for parent to know that
> > > vhost-mdev does not support MQ.
> > The mdev is a MDEV_CLASS_ID_VHOST mdev device. When the parent
> > is being developed, it should know the currently supported features
> > of vhost-mdev.
> 
> 
> How can parent know MQ is not supported by vhost-mdev?

Good point. I agree vhost-mdev should filter out the unsupported
features. But in the meantime, I think drivers also shouldn't
expose unsupported features.

> 
> 
> > 
> > > And this allows old kenrel to work with new
> > > parent drivers.
> > The new drivers should provide things like VIRTIO_MDEV_F_VERSION_1
> > to be compatible with the old kernels. When VIRTIO_MDEV_F_VERSION_1
> > is provided/negotiated, the behaviours should be consistent.
> 
> 
> To be clear, I didn't mean a change in virtio-mdev API, I meant:
> 
> 1) old vhost-mdev kernel driver that filters out MQ
> 
> 2) new parent driver that support MQ
> 
> 
> > 
> > > So basically we have three choices here:
> > > 
> > > 1) Implement what vhost-user did and implement a generic vhost-mdev (but may
> > > still have lots of device specific code). To support advanced feature which
> > > requires the access to config, still lots of API that needs to be added.
> > > 
> > > 2) Implement what vhost-kernel did, have a generic vhost-mdev driver and a
> > > vhost bus on top for match a device specific API e.g vhost-mdev-net. We
> > > still have device specific API but limit them only to device specific
> > > module. Still require new ioctls for advanced feature like MQ.
> > > 
> > > 3) Simply expose all virtio-mdev transport to userspace.
> > Currently, virtio-mdev transport is a set of function callbacks
> > defined in kernel. How to simply expose virtio-mdev transport to
> > userspace?
> 
> 
> The most straightforward way is to have an 1:1 mapping between ioctl and
> virito_mdev_device_ops.

Seems we are already trying to do 1:1 mapping between ioctl
and virtio_mdev_device_ops in vhost-mdev now (the major piece
missing is get_device_id/get_config/set_config).


> 
> Thanks
> 
> 
> > 
> > 
> > > A generic module
> > > without any type specific code (like virtio-mdev). No need dedicated API for
> > > e.g MQ. But then the API will look much different than current vhost did.
> > > 
> > > Consider the limitation of 1) I tend to choose 2 or 3. What's you opinion?
> > > 
> > > 
> 
