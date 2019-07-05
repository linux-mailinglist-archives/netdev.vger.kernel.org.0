Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895B05FF76
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 04:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfGECYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 22:24:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:3030 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbfGECYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 22:24:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 19:24:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,453,1557212400"; 
   d="scan'208";a="191500375"
Received: from npg-dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.151])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jul 2019 19:24:31 -0700
Date:   Fri, 5 Jul 2019 10:23:07 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190705022307.GA8263@___>
References: <20190703091339.1847-1-tiwei.bie@intel.com>
 <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
 <20190703115245.GA22374@___>
 <64833f91-02cd-7143-f12e-56ab93b2418d@redhat.com>
 <20190703130817.GA1978@___>
 <b01b8e28-8d96-31dd-56f4-ca7793498c55@redhat.com>
 <20190704062134.GA21116@___>
 <c67f628f-e0c1-9a41-6c5d-b6bbda31467d@redhat.com>
 <20190704070242.GA27369@___>
 <513c62ba-3f44-f4cf-3b3d-e0e03b6a6de1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <513c62ba-3f44-f4cf-3b3d-e0e03b6a6de1@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 08:30:00AM +0800, Jason Wang wrote:
> On 2019/7/4 下午3:02, Tiwei Bie wrote:
> > On Thu, Jul 04, 2019 at 02:35:20PM +0800, Jason Wang wrote:
> > > On 2019/7/4 下午2:21, Tiwei Bie wrote:
> > > > On Thu, Jul 04, 2019 at 12:31:48PM +0800, Jason Wang wrote:
> > > > > On 2019/7/3 下午9:08, Tiwei Bie wrote:
> > > > > > On Wed, Jul 03, 2019 at 08:16:23PM +0800, Jason Wang wrote:
> > > > > > > On 2019/7/3 下午7:52, Tiwei Bie wrote:
> > > > > > > > On Wed, Jul 03, 2019 at 06:09:51PM +0800, Jason Wang wrote:
> > > > > > > > > On 2019/7/3 下午5:13, Tiwei Bie wrote:
> > > > > > > > > > Details about this can be found here:
> > > > > > > > > > 
> > > > > > > > > > https://lwn.net/Articles/750770/
> > > > > > > > > > 
> > > > > > > > > > What's new in this version
> > > > > > > > > > ==========================
> > > > > > > > > > 
> > > > > > > > > > A new VFIO device type is introduced - vfio-vhost. This addressed
> > > > > > > > > > some comments from here:https://patchwork.ozlabs.org/cover/984763/
> > > > > > > > > > 
> > > > > > > > > > Below is the updated device interface:
> > > > > > > > > > 
> > > > > > > > > > Currently, there are two regions of this device: 1) CONFIG_REGION
> > > > > > > > > > (VFIO_VHOST_CONFIG_REGION_INDEX), which can be used to setup the
> > > > > > > > > > device; 2) NOTIFY_REGION (VFIO_VHOST_NOTIFY_REGION_INDEX), which
> > > > > > > > > > can be used to notify the device.
> > > > > > > > > > 
> > > > > > > > > > 1. CONFIG_REGION
> > > > > > > > > > 
> > > > > > > > > > The region described by CONFIG_REGION is the main control interface.
> > > > > > > > > > Messages will be written to or read from this region.
> > > > > > > > > > 
> > > > > > > > > > The message type is determined by the `request` field in message
> > > > > > > > > > header. The message size is encoded in the message header too.
> > > > > > > > > > The message format looks like this:
> > > > > > > > > > 
> > > > > > > > > > struct vhost_vfio_op {
> > > > > > > > > > 	__u64 request;
> > > > > > > > > > 	__u32 flags;
> > > > > > > > > > 	/* Flag values: */
> > > > > > > > > >       #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
> > > > > > > > > > 	__u32 size;
> > > > > > > > > > 	union {
> > > > > > > > > > 		__u64 u64;
> > > > > > > > > > 		struct vhost_vring_state state;
> > > > > > > > > > 		struct vhost_vring_addr addr;
> > > > > > > > > > 	} payload;
> > > > > > > > > > };
> > > > > > > > > > 
> > > > > > > > > > The existing vhost-kernel ioctl cmds are reused as the message
> > > > > > > > > > requests in above structure.
> > > > > > > > > Still a comments like V1. What's the advantage of inventing a new protocol?
> > > > > > > > I'm trying to make it work in VFIO's way..
> > > > > > > > 
> > > > > > > > > I believe either of the following should be better:
> > > > > > > > > 
> > > > > > > > > - using vhost ioctl,  we can start from SET_VRING_KICK/SET_VRING_CALL and
> > > > > > > > > extend it with e.g notify region. The advantages is that all exist userspace
> > > > > > > > > program could be reused without modification (or minimal modification). And
> > > > > > > > > vhost API hides lots of details that is not necessary to be understood by
> > > > > > > > > application (e.g in the case of container).
> > > > > > > > Do you mean reusing vhost's ioctl on VFIO device fd directly,
> > > > > > > > or introducing another mdev driver (i.e. vhost_mdev instead of
> > > > > > > > using the existing vfio_mdev) for mdev device?
> > > > > > > Can we simply add them into ioctl of mdev_parent_ops?
> > > > > > Right, either way, these ioctls have to be and just need to be
> > > > > > added in the ioctl of the mdev_parent_ops. But another thing we
> > > > > > also need to consider is that which file descriptor the userspace
> > > > > > will do the ioctl() on. So I'm wondering do you mean let the
> > > > > > userspace do the ioctl() on the VFIO device fd of the mdev
> > > > > > device?
> > > > > > 
> > > > > Yes.
> > > > Got it! I'm not sure what's Alex opinion on this. If we all
> > > > agree with this, I can do it in this way.
> > > > 
> > > > > Is there any other way btw?
> > > > Just a quick thought.. Maybe totally a bad idea.
> > > 
> > > It's not for sure :)
> > Thanks!
> > 
> > > 
> > > >    I was thinking
> > > > whether it would be odd to do non-VFIO's ioctls on VFIO's device
> > > > fd. So I was wondering whether it's possible to allow binding
> > > > another mdev driver (e.g. vhost_mdev) to the supported mdev
> > > > devices. The new mdev driver, vhost_mdev, can provide similar
> > > > ways to let userspace open the mdev device and do the vhost ioctls
> > > > on it. To distinguish with the vfio_mdev compatible mdev devices,
> > > > the device API of the new vhost_mdev compatible mdev devices
> > > > might be e.g. "vhost-net" for net?
> > > > 
> > > > So in VFIO case, the device will be for passthru directly. And
> > > > in VHOST case, the device can be used to accelerate the existing
> > > > virtualized devices.
> > > > 
> > > > How do you think?
> > > 
> > > If my understanding is correct, there will be no VFIO ioctl if we go for
> > > vhost_mdev?
> > Yeah, exactly. If we go for vhost_mdev, we may have some vhost nodes
> > in /dev similar to what /dev/vfio/* does to handle the $UUID and open
> > the device (e.g. similar to VFIO_GROUP_GET_DEVICE_FD in VFIO). And
> > to setup the device, we can try to reuse the ioctls of the existing
> > kernel vhost as much as possible.
> 
> 
> Interesting, actually, I've considered something similar. I think there
> should be no issues other than DMA:

Yeah, that's something we need to optimize to make it more
lightweight and efficient. How about allowing userspace to
do map/unmap operations like what VFIO provides?

> 
> - Need to invent new API for DMA mapping other than SET_MEM_TABLE? (Which is
> too heavyweight).
> 
> - Need to consider a way to co-work with both on chip IOMMU (your proposal
> should be fine) and scalable IOV.

Maybe we can make it possible to let the parent device know
the mappings (mapping events) if they need (it would be helpful
for software-based device as well).

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
> > > > Thanks,
> > > > Tiwei
> > > > > Thanks
> > > > > 
