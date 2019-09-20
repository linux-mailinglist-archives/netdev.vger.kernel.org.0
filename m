Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E537B89F7
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 06:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437164AbfITEY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 00:24:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:63541 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404405AbfITEYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 00:24:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 21:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,527,1559545200"; 
   d="scan'208";a="199622970"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.71])
  by orsmga002.jf.intel.com with ESMTP; 19 Sep 2019 21:24:22 -0700
Date:   Fri, 20 Sep 2019 12:21:38 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [RFC v4 3/3] vhost: introduce mdev based hardware backend
Message-ID: <20190920042138.GA11868@___>
References: <20190917010204.30376-1-tiwei.bie@intel.com>
 <20190917010204.30376-4-tiwei.bie@intel.com>
 <0b0f74ba-8958-dd7d-3e98-f7a58b1ec5f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b0f74ba-8958-dd7d-3e98-f7a58b1ec5f7@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 03:26:30PM +0800, Jason Wang wrote:
> On 2019/9/17 上午9:02, Tiwei Bie wrote:
> > diff --git a/drivers/vhost/mdev.c b/drivers/vhost/mdev.c
> > new file mode 100644
> > index 000000000000..8c6597aff45e
> > --- /dev/null
> > +++ b/drivers/vhost/mdev.c
> > @@ -0,0 +1,462 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2018-2019 Intel Corporation.
> > + */
> > +
> > +#include <linux/compat.h>
> > +#include <linux/kernel.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/mdev.h>
> > +#include <linux/module.h>
> > +#include <linux/vfio.h>
> > +#include <linux/vhost.h>
> > +#include <linux/virtio_mdev.h>
> > +
> > +#include "vhost.h"
> > +
> > +struct vhost_mdev {
> > +	struct mutex mutex;
> > +	struct vhost_dev dev;
> > +	struct vhost_virtqueue *vqs;
> > +	int nvqs;
> > +	u64 state;
> > +	u64 features;
> > +	u64 acked_features;
> > +	struct vfio_group *vfio_group;
> > +	struct vfio_device *vfio_device;
> > +	struct mdev_device *mdev;
> > +};
> > +
> > +/*
> > + * XXX
> > + * We assume virtio_mdev.ko exposes below symbols for now, as we
> > + * don't have a proper way to access parent ops directly yet.
> > + *
> > + * virtio_mdev_readl()
> > + * virtio_mdev_writel()
> > + */
> > +extern u32 virtio_mdev_readl(struct mdev_device *mdev, loff_t off);
> > +extern void virtio_mdev_writel(struct mdev_device *mdev, loff_t off, u32 val);
> 
> 
> Need to consider a better approach, I feel we should do it through some kind
> of mdev driver instead of talk to mdev device directly.

Yeah, a better approach is really needed here.
Besides, we may want a way to allow accessing the mdev
device_ops proposed in below series outside the
drivers/vfio/mdev/ directory.

https://lkml.org/lkml/2019/9/12/151

I.e. allow putting mdev drivers outside above directory.


> > +
> > +	for (queue_id = 0; queue_id < m->nvqs; queue_id++) {
> > +		vq = &m->vqs[queue_id];
> > +
> > +		if (!vq->desc || !vq->avail || !vq->used)
> > +			break;
> > +
> > +		virtio_mdev_writel(mdev, VIRTIO_MDEV_QUEUE_NUM, vq->num);
> > +
> > +		if (!vhost_translate_ring_addr(vq, (u64)vq->desc,
> > +					       vhost_get_desc_size(vq, vq->num),
> > +					       &addr))
> > +			return -EINVAL;
> 
> 
> Interesting, any reason for doing such kinds of translation to HVA? I
> believe the add should already an IOVA that has been map by VFIO.

Currently, in the software based vhost-kernel and vhost-user
backends, QEMU will pass ring addresses as HVA in SET_VRING_ADDR
ioctl when iotlb isn't enabled. If it's OK to let QEMU pass GPA
in vhost-mdev in this case, then this translation won't be needed.

Thanks,
Tiwei
