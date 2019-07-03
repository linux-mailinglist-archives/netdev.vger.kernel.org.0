Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86EBB5E340
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGCLyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:54:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:7366 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfGCLyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 07:54:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 04:54:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="172108791"
Received: from npg-dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.151])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Jul 2019 04:54:08 -0700
Date:   Wed, 3 Jul 2019 19:52:45 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190703115245.GA22374@___>
References: <20190703091339.1847-1-tiwei.bie@intel.com>
 <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 06:09:51PM +0800, Jason Wang wrote:
> On 2019/7/3 下午5:13, Tiwei Bie wrote:
> > Details about this can be found here:
> > 
> > https://lwn.net/Articles/750770/
> > 
> > What's new in this version
> > ==========================
> > 
> > A new VFIO device type is introduced - vfio-vhost. This addressed
> > some comments from here: https://patchwork.ozlabs.org/cover/984763/
> > 
> > Below is the updated device interface:
> > 
> > Currently, there are two regions of this device: 1) CONFIG_REGION
> > (VFIO_VHOST_CONFIG_REGION_INDEX), which can be used to setup the
> > device; 2) NOTIFY_REGION (VFIO_VHOST_NOTIFY_REGION_INDEX), which
> > can be used to notify the device.
> > 
> > 1. CONFIG_REGION
> > 
> > The region described by CONFIG_REGION is the main control interface.
> > Messages will be written to or read from this region.
> > 
> > The message type is determined by the `request` field in message
> > header. The message size is encoded in the message header too.
> > The message format looks like this:
> > 
> > struct vhost_vfio_op {
> > 	__u64 request;
> > 	__u32 flags;
> > 	/* Flag values: */
> >   #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
> > 	__u32 size;
> > 	union {
> > 		__u64 u64;
> > 		struct vhost_vring_state state;
> > 		struct vhost_vring_addr addr;
> > 	} payload;
> > };
> > 
> > The existing vhost-kernel ioctl cmds are reused as the message
> > requests in above structure.
> 
> 
> Still a comments like V1. What's the advantage of inventing a new protocol?

I'm trying to make it work in VFIO's way..

> I believe either of the following should be better:
> 
> - using vhost ioctl,  we can start from SET_VRING_KICK/SET_VRING_CALL and
> extend it with e.g notify region. The advantages is that all exist userspace
> program could be reused without modification (or minimal modification). And
> vhost API hides lots of details that is not necessary to be understood by
> application (e.g in the case of container).

Do you mean reusing vhost's ioctl on VFIO device fd directly,
or introducing another mdev driver (i.e. vhost_mdev instead of
using the existing vfio_mdev) for mdev device?

> 
> - using PCI layout, then you don't even need to re-invent notifiy region at
> all and we can pass-through them to guest.

Like what you said previously, virtio has transports other than PCI.
And it will look a bit odd when using transports other than PCI..

> 
> Personally, I prefer vhost ioctl.

+1

> 
> 
> > 
[...]
> > 
> > 3. VFIO interrupt ioctl API
> > 
> > VFIO interrupt ioctl API is used to setup device interrupts.
> > IRQ-bypass can also be supported.
> > 
> > Currently, the data path interrupt can be configured via the
> > VFIO_VHOST_VQ_IRQ_INDEX with virtqueue's callfd.
> 
> 
> How about DMA API? Do you expect to use VFIO IOMMU API or using vhost
> SET_MEM_TABLE? VFIO IOMMU API is more generic for sure but with
> SET_MEM_TABLE DMA can be done at the level of parent device which means it
> can work for e.g the card with on-chip IOMMU.

Agree. In this RFC, it assumes userspace will use VFIO IOMMU API
to do the DMA programming. But like what you said, there could be
a problem when using cards with on-chip IOMMU.

> 
> And what's the plan for vIOMMU?

As this RFC assumes userspace will use VFIO IOMMU API, userspace
just needs to follow the same way like what vfio-pci device does
in QEMU to support vIOMMU.

> 
> 
> > 
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > ---
> >   drivers/vhost/Makefile     |   2 +
> >   drivers/vhost/vdpa.c       | 770 +++++++++++++++++++++++++++++++++++++
> >   include/linux/vdpa_mdev.h  |  72 ++++
> >   include/uapi/linux/vfio.h  |  19 +
> >   include/uapi/linux/vhost.h |  25 ++
> >   5 files changed, 888 insertions(+)
> >   create mode 100644 drivers/vhost/vdpa.c
> >   create mode 100644 include/linux/vdpa_mdev.h
> 
> 
> We probably need some sample parent device implementation. It could be a
> software datapath like e.g we can start from virtio-net device in guest or a
> vhost/tap on host.

Yeah, something like this would be interesting!

Thanks,
Tiwei

> 
> Thanks
> 
> 
> > 
