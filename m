Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B4EEC419
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfKANzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:55:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:1155 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfKANzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 09:55:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 06:55:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,255,1569308400"; 
   d="scan'208";a="190964201"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga007.jf.intel.com with ESMTP; 01 Nov 2019 06:55:40 -0700
Date:   Fri, 1 Nov 2019 21:56:28 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v4] vhost: introduce mdev based hardware backend
Message-ID: <20191101135628.GA18045@___>
References: <20191031140114.25615-1-tiwei.bie@intel.com>
 <f9036643-7aaf-7107-8bf0-85975ab95d4b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9036643-7aaf-7107-8bf0-85975ab95d4b@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 01, 2019 at 03:17:39PM +0800, Jason Wang wrote:
> On 2019/10/31 下午10:01, Tiwei Bie wrote:
> > This patch introduces a mdev based hardware vhost backend.
> > This backend is built on top of the same abstraction used
> > in virtio-mdev and provides a generic vhost interface for
> > userspace to accelerate the virtio devices in guest.
> > 
> > This backend is implemented as a mdev device driver on top
> > of the same mdev device ops used in virtio-mdev but using
> > a different mdev class id, and it will register the device
> > as a VFIO device for userspace to use. Userspace can setup
> > the IOMMU with the existing VFIO container/group APIs and
> > then get the device fd with the device name. After getting
> > the device fd of this device, userspace can use vhost ioctls
> > to setup the backend.
> > 
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > ---
> > This patch depends on below series:
> > https://lkml.org/lkml/2019/10/30/62
> > 
> > v3 -> v4:
> > - Rebase on top of virtio-mdev series v6;
> > - Some minor tweaks and improvements;
> > 
> > v2 -> v3:
> > - Fix the return value (Jason);
> > - Don't cache unnecessary information in vhost-mdev (Jason);
> > - Get rid of the memset in open (Jason);
> > - Add comments for VHOST_SET_MEM_TABLE, ... (Jason);
> > - Filter out unsupported features in vhost-mdev (Jason);
> > - Add _GET_DEVICE_ID ioctl (Jason);
> > - Add _GET_CONFIG/_SET_CONFIG ioctls (Jason);
> > - Drop _GET_QUEUE_NUM ioctl (Jason);
> > - Fix the copy-paste errors in _IOW/_IOR usage;
> > - Some minor fixes and improvements;
> > 
> > v1 -> v2:
> > - Replace _SET_STATE with _SET_STATUS (MST);
> > - Check status bits at each step (MST);
> > - Report the max ring size and max number of queues (MST);
> > - Add missing MODULE_DEVICE_TABLE (Jason);
> > - Only support the network backend w/o multiqueue for now;
> > - Some minor fixes and improvements;
> > - Rebase on top of virtio-mdev series v4;
> > 
> > RFC v4 -> v1:
> > - Implement vhost-mdev as a mdev device driver directly and
> >    connect it to VFIO container/group. (Jason);
> > - Pass ring addresses as GPAs/IOVAs in vhost-mdev to avoid
> >    meaningless HVA->GPA translations (Jason);
> > 
> > RFC v3 -> RFC v4:
> > - Build vhost-mdev on top of the same abstraction used by
> >    virtio-mdev (Jason);
> > - Introduce vhost fd and pass VFIO fd via SET_BACKEND ioctl (MST);
> > 
> > RFC v2 -> RFC v3:
> > - Reuse vhost's ioctls instead of inventing a VFIO regions/irqs
> >    based vhost protocol on top of vfio-mdev (Jason);
> > 
> > RFC v1 -> RFC v2:
> > - Introduce a new VFIO device type to build a vhost protocol
> >    on top of vfio-mdev;
> > 
> >   drivers/vfio/mdev/mdev_core.c    |  20 ++
> >   drivers/vfio/mdev/mdev_private.h |   1 +
> >   drivers/vhost/Kconfig            |  12 +
> >   drivers/vhost/Makefile           |   3 +
> >   drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
> >   include/linux/mdev.h             |   5 +
> >   include/uapi/linux/vhost.h       |  18 +
> >   include/uapi/linux/vhost_types.h |   8 +
> >   8 files changed, 623 insertions(+)
> >   create mode 100644 drivers/vhost/mdev.c
> > 
> > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > index 22ca589750d8..109dbac01a8f 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -96,6 +96,26 @@ mdev_get_virtio_ops(struct mdev_device *mdev)
> >   }
> >   EXPORT_SYMBOL(mdev_get_virtio_ops);
> > +/* Specify the vhost device ops for the mdev device, this
> > + * must be called during create() callback for vhost mdev device.
> > + */
> > +void mdev_set_vhost_ops(struct mdev_device *mdev,
> > +			const struct virtio_mdev_device_ops *vhost_ops)
> > +{
> > +	mdev_set_class(mdev, MDEV_CLASS_ID_VHOST);
> > +	mdev->vhost_ops = vhost_ops;
> > +}
> > +EXPORT_SYMBOL(mdev_set_vhost_ops);
> > +
> > +/* Get the vhost device ops for the mdev device. */
> > +const struct virtio_mdev_device_ops *
> > +mdev_get_vhost_ops(struct mdev_device *mdev)
> > +{
> > +	WARN_ON(mdev->class_id != MDEV_CLASS_ID_VHOST);
> > +	return mdev->vhost_ops;
> > +}
> > +EXPORT_SYMBOL(mdev_get_vhost_ops);
> > +
> >   struct device *mdev_dev(struct mdev_device *mdev)
> >   {
> >   	return &mdev->dev;
> > diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> > index 7b47890c34e7..5597c846e52f 100644
> > --- a/drivers/vfio/mdev/mdev_private.h
> > +++ b/drivers/vfio/mdev/mdev_private.h
> > @@ -40,6 +40,7 @@ struct mdev_device {
> >   	union {
> >   		const struct vfio_mdev_device_ops *vfio_ops;
> >   		const struct virtio_mdev_device_ops *virtio_ops;
> > +		const struct virtio_mdev_device_ops *vhost_ops;
> 
> 
> Any reason why virtio_ops is not used for vhost here?

I don't have a strong opinion on this.
Will use virtio_ops directly.

> 
> Other looks good.

Thanks!

> 
> Thanks
> 
> 
