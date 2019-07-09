Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48254630EA
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGIGez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:34:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:34626 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfGIGey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 02:34:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 23:34:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,469,1557212400"; 
   d="scan'208";a="167889966"
Received: from npg-dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.66])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2019 23:34:50 -0700
Date:   Tue, 9 Jul 2019 14:33:17 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, mst@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com, idos@mellanox.com,
        Rob Miller <rob.miller@broadcom.com>,
        Ariel Adam <aadam@redhat.com>
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190709063317.GA29300@___>
References: <20190703091339.1847-1-tiwei.bie@intel.com>
 <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
 <20190703115245.GA22374@___>
 <64833f91-02cd-7143-f12e-56ab93b2418d@redhat.com>
 <20190703130817.GA1978@___>
 <b01b8e28-8d96-31dd-56f4-ca7793498c55@redhat.com>
 <20190704062134.GA21116@___>
 <20190705084946.67b8f9f5@x1.home>
 <20190708061625.GA15936@___>
 <deae5ede-57e9-41e6-ea42-d84e07ca480a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <deae5ede-57e9-41e6-ea42-d84e07ca480a@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 10:50:38AM +0800, Jason Wang wrote:
> On 2019/7/8 下午2:16, Tiwei Bie wrote:
> > On Fri, Jul 05, 2019 at 08:49:46AM -0600, Alex Williamson wrote:
> > > On Thu, 4 Jul 2019 14:21:34 +0800
> > > Tiwei Bie <tiwei.bie@intel.com> wrote:
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
> > > > > > > > > >      #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
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
> > > > > Yes.
> > > > Got it! I'm not sure what's Alex opinion on this. If we all
> > > > agree with this, I can do it in this way.
> > > > 
> > > > > Is there any other way btw?
> > > > Just a quick thought.. Maybe totally a bad idea. I was thinking
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
> > > VFIO really can't prevent vendor specific ioctls on the device file
> > > descriptor for mdevs, but a) we'd want to be sure the ioctl address
> > > space can't collide with ioctls we'd use for vfio defined purposes and
> > > b) maybe the VFIO user API isn't what you want in the first place if
> > > you intend to mostly/entirely ignore the defined ioctl set and replace
> > > them with your own.  In the case of the latter, you're also not getting
> > > the advantages of the existing VFIO userspace code, so why expose a
> > > VFIO device at all.
> > Yeah, I totally agree.
> 
> 
> I guess the original idea is to reuse the VFIO DMA/IOMMU API for this. Then
> we have the chance to reuse vfio codes in qemu for dealing with e.g vIOMMU.

Yeah, you are right. We have several choices here:

#1. We expose a VFIO device, so we can reuse the VFIO container/group
    based DMA API and potentially reuse a lot of VFIO code in QEMU.

    But in this case, we have two choices for the VFIO device interface
    (i.e. the interface on top of VFIO device fd):

    A) we may invent a new vhost protocol (as demonstrated by the code
       in this RFC) on VFIO device fd to make it work in VFIO's way,
       i.e. regions and irqs.

    B) Or as you proposed, instead of inventing a new vhost protocol,
       we can reuse most existing vhost ioctls on the VFIO device fd
       directly. There should be no conflicts between the VFIO ioctls
       (type is 0x3B) and VHOST ioctls (type is 0xAF) currently.

#2. Instead of exposing a VFIO device, we may expose a VHOST device.
    And we will introduce a new mdev driver vhost-mdev to do this.
    It would be natural to reuse the existing kernel vhost interface
    (ioctls) on it as much as possible. But we will need to invent
    some APIs for DMA programming (reusing VHOST_SET_MEM_TABLE is a
    choice, but it's too heavy and doesn't support vIOMMU by itself).

I'm not sure which one is the best choice we all want..
Which one (#1/A, #1/B, or #2) would you prefer?

> 
> 
> > 
> > > The mdev interface does provide a general interface for creating and
> > > managing virtual devices, vfio-mdev is just one driver on the mdev
> > > bus.  Parav (Mellanox) has been doing work on mdev-core to help clean
> > > out vfio-isms from the interface, aiui, with the intent of implementing
> > > another mdev bus driver for using the devices within the kernel.
> > Great to know this! I found below series after some searching:
> > 
> > https://lkml.org/lkml/2019/3/8/821
> > 
> > In above series, the new mlx5_core mdev driver will do the probe
> > by calling mlx5_get_core_dev() first on the parent device of the
> > mdev device. In vhost_mdev, maybe we can also keep track of all
> > the compatible mdev devices and use this info to do the probe.
> 
> 
> I don't get why this is needed. My understanding is if we want to go this
> way, there're actually two parts. 1) Vhost mdev that implements the device
> managements and vhost ioctl. 2) Vhost it self, which can accept mdev fd as
> it backend through VHOST_NET_SET_BACKEND.

I think with vhost-mdev (or with vfio-mdev if we agree to do vhost
ioctls on vfio device fd directly), we don't need to open /dev/vhost-net
(and there is no VHOST_NET_SET_BACKEND needed) at all. Either way,
after getting the fd of the mdev, we just need to do vhost ioctls
on it directly.

> 
> 
> > But we also need a way to allow vfio_mdev driver to distinguish
> > and reject the incompatible mdev devices.
> 
> 
> One issue for this series is that it doesn't consider DMA isolation at all.
> 
> 
> > 
> > > It
> > > seems like this vhost-mdev driver might be similar, using mdev but not
> > > necessarily vfio-mdev to expose devices.  Thanks,
> > Yeah, I also think so!
> 
> 
> I've cced some driver developers for their inputs. I think we need a sample
> parent drivers in the next version for us to understand the full picture.
> 
> 
> Thanks
> 
> 
> > 
> > Thanks!
> > Tiwei
> > 
> > > Alex
