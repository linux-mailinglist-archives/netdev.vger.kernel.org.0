Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9F3A5F02
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 03:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfICB6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 21:58:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:28616 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbfICB6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 21:58:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Sep 2019 18:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,461,1559545200"; 
   d="scan'208";a="181988659"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.71])
  by fmsmga008.fm.intel.com with ESMTP; 02 Sep 2019 18:58:29 -0700
Date:   Tue, 3 Sep 2019 09:56:02 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [RFC v3] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190903015602.GA11404@___>
References: <20190828053712.26106-1-tiwei.bie@intel.com>
 <b91820c4-2fe2-55ee-5089-5f7c94322521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b91820c4-2fe2-55ee-5089-5f7c94322521@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 12:15:05PM +0800, Jason Wang wrote:
> On 2019/8/28 下午1:37, Tiwei Bie wrote:
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
> > >      based DMA API and potentially reuse a lot of VFIO code in QEMU.
> > > 
> > >      But in this case, we have two choices for the VFIO device interface
> > >      (i.e. the interface on top of VFIO device fd):
> > > 
> > >      A) we may invent a new vhost protocol (as demonstrated by the code
> > >         in this RFC) on VFIO device fd to make it work in VFIO's way,
> > >         i.e. regions and irqs.
> > > 
> > >      B) Or as you proposed, instead of inventing a new vhost protocol,
> > >         we can reuse most existing vhost ioctls on the VFIO device fd
> > >         directly. There should be no conflicts between the VFIO ioctls
> > >         (type is 0x3B) and VHOST ioctls (type is 0xAF) currently.
> > > 
> > > #2. Instead of exposing a VFIO device, we may expose a VHOST device.
> > >      And we will introduce a new mdev driver vhost-mdev to do this.
> > >      It would be natural to reuse the existing kernel vhost interface
> > >      (ioctls) on it as much as possible. But we will need to invent
> > >      some APIs for DMA programming (reusing VHOST_SET_MEM_TABLE is a
> > >      choice, but it's too heavy and doesn't support vIOMMU by itself).
> > This version is more like a quick PoC to try Jason's proposal on
> > reusing vhost ioctls. And the second way (#1/B) in above three
> > choices was chosen in this version to demonstrate the idea quickly.
> > 
> > Now the userspace API looks like this:
> > 
> > - VFIO's container/group based IOMMU API is used to do the
> >    DMA programming.
> > 
> > - Vhost's existing ioctls are used to setup the device.
> > 
> > And the device will report device_api as "vfio-vhost".
> > 
> > Note that, there are dirty hacks in this version. If we decide to
> > go this way, some refactoring in vhost.c/vhost.h may be needed.
> > 
> > PS. The direct mapping of the notify registers isn't implemented
> >      in this version.
> > 
> > [1] https://lkml.org/lkml/2019/7/9/101
> 
> 
> Thanks for the patch, see comments inline.
> 
> 
> > 
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > ---
> >   drivers/vhost/Kconfig      |   9 +
> >   drivers/vhost/Makefile     |   3 +
> >   drivers/vhost/mdev.c       | 382 +++++++++++++++++++++++++++++++++++++
> >   include/linux/vhost_mdev.h |  58 ++++++
> >   include/uapi/linux/vfio.h  |   2 +
> >   include/uapi/linux/vhost.h |   8 +
> >   6 files changed, 462 insertions(+)
> >   create mode 100644 drivers/vhost/mdev.c
> >   create mode 100644 include/linux/vhost_mdev.h
[...]
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
> 
> 
> So this is used to start or stop the device. This means if userspace want to
> drive a network device, the API is not 100% compatible. Any blocker for
> this? E.g for SET_BACKEND, we can pass a fd and then identify the type of
> backend.

This is a legacy from the previous RFC code. I didn't try to
get rid of it while getting this POC to work. I can try to make
the vhost ioctls fully compatible with the existing userspace
if possible.

> 
> Another question is, how can user know the type of a device?

Maybe we can introduce an attribute in $UUID/ to tell the type.

> 
> 
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
[...]
> > +struct mdev_device;
> > +struct vhost_mdev;
> > +
> > +typedef int (*vhost_mdev_start_device_t)(struct vhost_mdev *vdpa);
> > +typedef int (*vhost_mdev_stop_device_t)(struct vhost_mdev *vdpa);
> > +typedef int (*vhost_mdev_set_features_t)(struct vhost_mdev *vdpa);
> > +typedef void (*vhost_mdev_notify_device_t)(struct vhost_mdev *vdpa, int queue_id);
> > +typedef u64 (*vhost_mdev_get_notify_addr_t)(struct vhost_mdev *vdpa, int queue_id);
> > +typedef u16 (*vhost_mdev_get_vring_base_t)(struct vhost_mdev *vdpa, int queue_id);
> > +typedef void (*vhost_mdev_features_changed_t)(struct vhost_mdev *vdpa);
> > +
> > +struct vhost_mdev_device_ops {
> > +	vhost_mdev_start_device_t	start;
> > +	vhost_mdev_stop_device_t	stop;
> > +	vhost_mdev_notify_device_t	notify;
> > +	vhost_mdev_get_notify_addr_t	get_notify_addr;
> > +	vhost_mdev_get_vring_base_t	get_vring_base;
> > +	vhost_mdev_features_changed_t	features_changed;
> > +};
> 
> 
> Consider we want to implement a network device, who is going to implement
> the device configuration space? I believe it's not good to invent another
> set of API for doing this. So I believe we want something like
> read_config/write_config here.
> 
> Then I came up an idea:
> 
> 1) introduce a new mdev bus transport, and a new mdev driver virtio_mdev
> 2) vDPA (either software or hardware) can register as a device of virtio
> mdev device
> 3) then we can use kernel virtio driver to drive vDPA device and utilize
> kernel networking/storage stack
> 4) for userspace driver like vhost-mdev, it could be built of top of mdev
> transport
> 
> Having a full new transport for virtio, the advantages are obvious:
> 
> 1) A generic solution for both kernel and userspace driver and support
> configuration space access
> 2) For kernel driver, exist kernel networking/storage stack could be reused,
> and so did fast path implementation (e.g XDP, io_uring etc).
> 2) For userspace driver, the function of virtio transport is a superset of
> vhost, any API could be built on top easily (e.g vhost ioctl).
> 
> What's your thought?

This sounds interesting to me! ;)

But I'm not quite sure whether it's the best choice to abstract
vhost accelerators as virtio device in vDPA. Virtio device is
the frontend device. There are some backend features missing in
virtio currently. E.g. there is no way to tell the virtio device
to do dirty page logging. Besides, e.g. the control vq in network
case seems not a quite good interface for a backend device. In
this case, the userspace virtio-mdev driver in QEMU will do the
DMA mapping to allow guest driver to be able to use GPA/IOVA to
access the Rx/Tx queues of the virtio-mdev device directly, but
I'm wondering will this userspace virtio-mdev driver in QEMU use
similar IOVA to access the software based control vq of the same
virtio-mdev device at the same time?

Thanks,
Tiwei

> 
> Thanks
> 
> 
> > +
> > +struct vhost_mdev *vhost_mdev_alloc(struct mdev_device *mdev,
> > +		void *private, int nvqs);
> > +void vhost_mdev_free(struct vhost_mdev *vdpa);
> > +
> > +ssize_t vhost_mdev_read(struct mdev_device *mdev, char __user *buf,
> > +		size_t count, loff_t *ppos);
> > +ssize_t vhost_mdev_write(struct mdev_device *mdev, const char __user *buf,
> > +		size_t count, loff_t *ppos);
> > +long vhost_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
> > +		unsigned long arg);
> > +int vhost_mdev_mmap(struct mdev_device *mdev, struct vm_area_struct *vma);
> > +int vhost_mdev_open(struct mdev_device *mdev);
> > +void vhost_mdev_close(struct mdev_device *mdev);
> > +
> > +int vhost_mdev_set_device_ops(struct vhost_mdev *vdpa,
> > +		const struct vhost_mdev_device_ops *ops);
> > +int vhost_mdev_set_features(struct vhost_mdev *vdpa, u64 features);
> > +struct eventfd_ctx *vhost_mdev_get_call_ctx(struct vhost_mdev *vdpa,
> > +		int queue_id);
> > +int vhost_mdev_get_acked_features(struct vhost_mdev *vdpa, u64 *features);
> > +int vhost_mdev_get_vring_num(struct vhost_mdev *vdpa, int queue_id, u16 *num);
> > +int vhost_mdev_get_vring_base(struct vhost_mdev *vdpa, int queue_id, u16 *base);
> > +int vhost_mdev_get_vring_addr(struct vhost_mdev *vdpa, int queue_id,
> > +		struct vhost_vring_addr *addr);
> > +int vhost_mdev_get_log_base(struct vhost_mdev *vdpa, int queue_id,
> > +		void **log_base, u64 *log_size);
> > +struct mdev_device *vhost_mdev_get_mdev(struct vhost_mdev *vdpa);
> > +void *vhost_mdev_get_private(struct vhost_mdev *vdpa);
> > +
> > +#endif /* _VHOST_MDEV_H */
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 8f10748dac79..0300d6831cc5 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -201,6 +201,7 @@ struct vfio_device_info {
> >   #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
> >   #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
> >   #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
> > +#define VFIO_DEVICE_FLAGS_VHOST	(1 << 6)	/* vfio-vhost device */
> >   	__u32	num_regions;	/* Max region index + 1 */
> >   	__u32	num_irqs;	/* Max IRQ index + 1 */
> >   };
> > @@ -217,6 +218,7 @@ struct vfio_device_info {
> >   #define VFIO_DEVICE_API_AMBA_STRING		"vfio-amba"
> >   #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
> >   #define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
> > +#define VFIO_DEVICE_API_VHOST_STRING		"vfio-vhost"
> >   /**
> >    * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index 40d028eed645..5afbc2f08fa3 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -116,4 +116,12 @@
> >   #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> >   #define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> > +/* VHOST_MDEV specific defines */
> > +
> > +#define VHOST_MDEV_SET_STATE	_IOW(VHOST_VIRTIO, 0x70, __u64)
> > +
> > +#define VHOST_MDEV_S_STOPPED	0
> > +#define VHOST_MDEV_S_RUNNING	1
> > +#define VHOST_MDEV_S_MAX	2
> > +
> >   #endif
