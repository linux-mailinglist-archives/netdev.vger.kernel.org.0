Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21CEE964E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 07:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfJ3GQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 02:16:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:10611 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfJ3GQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 02:16:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 23:16:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="374792704"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga005.jf.intel.com with ESMTP; 29 Oct 2019 23:16:20 -0700
Date:   Wed, 30 Oct 2019 14:17:11 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
Subject: Re: [RFC] vhost_mdev: add network control vq support
Message-ID: <20191030061711.GA11968@___>
References: <20191029101726.12699-1-tiwei.bie@intel.com>
 <59474431-9e77-567c-9a46-a3965f587f65@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59474431-9e77-567c-9a46-a3965f587f65@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 06:51:32PM +0800, Jason Wang wrote:
> On 2019/10/29 下午6:17, Tiwei Bie wrote:
> > This patch adds the network control vq support in vhost-mdev.
> > A vhost-mdev specific op is introduced to allow parent drivers
> > to handle the network control commands come from userspace.
> 
> Probably work for userspace driver but not kernel driver.

Exactly. This is only for userspace.

I got your point now. In virtio-mdev kernel driver case,
the ctrl-vq can be special as well.

> 
> 
> >
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > ---
> > This patch depends on below patch:
> > https://lkml.org/lkml/2019/10/29/335
> >
> >  drivers/vhost/mdev.c             | 37 ++++++++++++++++++++++++++++++--
> >  include/linux/virtio_mdev_ops.h  | 10 +++++++++
> >  include/uapi/linux/vhost.h       |  7 ++++++
> >  include/uapi/linux/vhost_types.h |  6 ++++++
> >  4 files changed, 58 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
> > index 35b2fb33e686..c9b3eaa77405 100644
> > --- a/drivers/vhost/mdev.c
> > +++ b/drivers/vhost/mdev.c
> > @@ -47,6 +47,13 @@ enum {
> >  		(1ULL << VIRTIO_NET_F_HOST_UFO) |
> >  		(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> >  		(1ULL << VIRTIO_NET_F_STATUS) |
> > +		(1ULL << VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) |
> > +		(1ULL << VIRTIO_NET_F_CTRL_VQ) |
> > +		(1ULL << VIRTIO_NET_F_CTRL_RX) |
> > +		(1ULL << VIRTIO_NET_F_CTRL_VLAN) |
> > +		(1ULL << VIRTIO_NET_F_CTRL_RX_EXTRA) |
> > +		(1ULL << VIRTIO_NET_F_GUEST_ANNOUNCE) |
> > +		(1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR) |
> >  		(1ULL << VIRTIO_NET_F_SPEED_DUPLEX),
> >  };
> >  
> > @@ -362,6 +369,29 @@ static long vhost_mdev_vring_ioctl(struct vhost_mdev *m, unsigned int cmd,
> >  	return r;
> >  }
> >  
> > +/*
> > + * Device specific (e.g. network) ioctls.
> > + */
> > +static long vhost_mdev_dev_ioctl(struct vhost_mdev *m, unsigned int cmd,
> > +				 void __user *argp)
> > +{
> > +	struct mdev_device *mdev = m->mdev;
> > +	const struct virtio_mdev_device_ops *ops = mdev_get_vhost_ops(mdev);
> > +
> > +	switch (m->virtio_id) {
> > +	case VIRTIO_ID_NET:
> > +		switch (cmd) {
> > +		case VHOST_MDEV_NET_CTRL:
> > +			if (!ops->net.ctrl)
> > +				return -ENOTSUPP;
> > +			return ops->net.ctrl(mdev, argp);
> > +		}
> > +		break;
> > +	}
> > +
> > +	return -ENOIOCTLCMD;
> > +}
> 
> As you comment above, then vhost-mdev need device specific stuffs.

Yeah. But this device specific stuff is quite small and
simple. It's just to forward the settings between parent
and userspace. But I totally agree it would be really
great if we could avoid it in an elegant way.

> 
> 
> > +
> >  static int vhost_mdev_open(void *device_data)
> >  {
> >  	struct vhost_mdev *m = device_data;
> > @@ -460,8 +490,11 @@ static long vhost_mdev_unlocked_ioctl(void *device_data,
> >  		 * VHOST_SET_LOG_FD are not used yet.
> >  		 */
> >  		r = vhost_dev_ioctl(&m->dev, cmd, argp);
> > -		if (r == -ENOIOCTLCMD)
> > -			r = vhost_mdev_vring_ioctl(m, cmd, argp);
> > +		if (r == -ENOIOCTLCMD) {
> > +			r = vhost_mdev_dev_ioctl(m, cmd, argp);
> > +			if (r == -ENOIOCTLCMD)
> > +				r = vhost_mdev_vring_ioctl(m, cmd, argp);
> > +		}
> >  	}
> >  
> >  	mutex_unlock(&m->mutex);
> > diff --git a/include/linux/virtio_mdev_ops.h b/include/linux/virtio_mdev_ops.h
> > index d417b41f2845..622861804ebd 100644
> > --- a/include/linux/virtio_mdev_ops.h
> > +++ b/include/linux/virtio_mdev_ops.h
> > @@ -20,6 +20,8 @@ struct virtio_mdev_callback {
> >  	void *private;
> >  };
> >  
> > +struct vhost_mdev_net_ctrl;
> > +
> >  /**
> >   * struct vfio_mdev_device_ops - Structure to be registered for each
> >   * mdev device to register the device for virtio/vhost drivers.
> > @@ -151,6 +153,14 @@ struct virtio_mdev_device_ops {
> >  
> >  	/* Mdev device ops */
> >  	u64 (*get_mdev_features)(struct mdev_device *mdev);
> > +
> > +	/* Vhost-mdev (MDEV_CLASS_ID_VHOST) specific ops */
> > +	union {
> > +		struct {
> > +			int (*ctrl)(struct mdev_device *mdev,
> > +				    struct vhost_mdev_net_ctrl __user *ctrl);
> > +		} net;
> > +	};
> 
> And so did device_ops. I still think we'd try out best to avoid such thing.

I totally agree we should try our best to avoid it.
But in this case, I think it may be worth considering
as it does simplify the userspace API and the parent
driver implementation a lot..


> 
> Thanks
> 
> 
> >  };
> >  
> >  void mdev_set_virtio_ops(struct mdev_device *mdev,
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index 061a2824a1b3..3693b2cba0c4 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -134,4 +134,11 @@
> >  /* Get the max ring size. */
> >  #define VHOST_MDEV_GET_VRING_NUM	_IOR(VHOST_VIRTIO, 0x76, __u16)
> >  
> > +/* VHOST_MDEV device specific defines */
> > +
> > +/* Send virtio-net commands. The commands follow the same definition
> > + * of the virtio-net commands defined in virtio-spec.
> > + */
> > +#define VHOST_MDEV_NET_CTRL		_IOW(VHOST_VIRTIO, 0x77, struct vhost_mdev_net_ctrl *)
> > +
> >  #endif
> > diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
> > index 7b105d0b2fb9..e76b4d8e35e5 100644
> > --- a/include/uapi/linux/vhost_types.h
> > +++ b/include/uapi/linux/vhost_types.h
> > @@ -127,6 +127,12 @@ struct vhost_mdev_config {
> >  	__u8 buf[0];
> >  };
> >  
> > +struct vhost_mdev_net_ctrl {
> > +	__u8 class;
> > +	__u8 cmd;
> > +	__u8 cmd_data[0];
> > +} __attribute__((packed));
> > +
> >  /* Feature bits */
> >  /* Log all write descriptors. Can be changed while device is active. */
> >  #define VHOST_F_LOG_ALL 26
> 
