Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466E16084B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGEOuI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Jul 2019 10:50:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfGEOuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 10:50:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65412308213B;
        Fri,  5 Jul 2019 14:49:57 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D63269D90A;
        Fri,  5 Jul 2019 14:49:47 +0000 (UTC)
Date:   Fri, 5 Jul 2019 08:49:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190705084946.67b8f9f5@x1.home>
In-Reply-To: <20190704062134.GA21116@___>
References: <20190703091339.1847-1-tiwei.bie@intel.com>
        <7b8279b2-aa7e-7adc-eeff-20dfaf4400d0@redhat.com>
        <20190703115245.GA22374@___>
        <64833f91-02cd-7143-f12e-56ab93b2418d@redhat.com>
        <20190703130817.GA1978@___>
        <b01b8e28-8d96-31dd-56f4-ca7793498c55@redhat.com>
        <20190704062134.GA21116@___>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 05 Jul 2019 14:50:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 14:21:34 +0800
Tiwei Bie <tiwei.bie@intel.com> wrote:

> On Thu, Jul 04, 2019 at 12:31:48PM +0800, Jason Wang wrote:
> > On 2019/7/3 下午9:08, Tiwei Bie wrote:  
> > > On Wed, Jul 03, 2019 at 08:16:23PM +0800, Jason Wang wrote:  
> > > > On 2019/7/3 下午7:52, Tiwei Bie wrote:  
> > > > > On Wed, Jul 03, 2019 at 06:09:51PM +0800, Jason Wang wrote:  
> > > > > > On 2019/7/3 下午5:13, Tiwei Bie wrote:  
> > > > > > > Details about this can be found here:
> > > > > > > 
> > > > > > > https://lwn.net/Articles/750770/
> > > > > > > 
> > > > > > > What's new in this version
> > > > > > > ==========================
> > > > > > > 
> > > > > > > A new VFIO device type is introduced - vfio-vhost. This addressed
> > > > > > > some comments from here:https://patchwork.ozlabs.org/cover/984763/
> > > > > > > 
> > > > > > > Below is the updated device interface:
> > > > > > > 
> > > > > > > Currently, there are two regions of this device: 1) CONFIG_REGION
> > > > > > > (VFIO_VHOST_CONFIG_REGION_INDEX), which can be used to setup the
> > > > > > > device; 2) NOTIFY_REGION (VFIO_VHOST_NOTIFY_REGION_INDEX), which
> > > > > > > can be used to notify the device.
> > > > > > > 
> > > > > > > 1. CONFIG_REGION
> > > > > > > 
> > > > > > > The region described by CONFIG_REGION is the main control interface.
> > > > > > > Messages will be written to or read from this region.
> > > > > > > 
> > > > > > > The message type is determined by the `request` field in message
> > > > > > > header. The message size is encoded in the message header too.
> > > > > > > The message format looks like this:
> > > > > > > 
> > > > > > > struct vhost_vfio_op {
> > > > > > > 	__u64 request;
> > > > > > > 	__u32 flags;
> > > > > > > 	/* Flag values: */
> > > > > > >     #define VHOST_VFIO_NEED_REPLY 0x1 /* Whether need reply */
> > > > > > > 	__u32 size;
> > > > > > > 	union {
> > > > > > > 		__u64 u64;
> > > > > > > 		struct vhost_vring_state state;
> > > > > > > 		struct vhost_vring_addr addr;
> > > > > > > 	} payload;
> > > > > > > };
> > > > > > > 
> > > > > > > The existing vhost-kernel ioctl cmds are reused as the message
> > > > > > > requests in above structure.  
> > > > > > Still a comments like V1. What's the advantage of inventing a new protocol?  
> > > > > I'm trying to make it work in VFIO's way..
> > > > >   
> > > > > > I believe either of the following should be better:
> > > > > > 
> > > > > > - using vhost ioctl,  we can start from SET_VRING_KICK/SET_VRING_CALL and
> > > > > > extend it with e.g notify region. The advantages is that all exist userspace
> > > > > > program could be reused without modification (or minimal modification). And
> > > > > > vhost API hides lots of details that is not necessary to be understood by
> > > > > > application (e.g in the case of container).  
> > > > > Do you mean reusing vhost's ioctl on VFIO device fd directly,
> > > > > or introducing another mdev driver (i.e. vhost_mdev instead of
> > > > > using the existing vfio_mdev) for mdev device?  
> > > > Can we simply add them into ioctl of mdev_parent_ops?  
> > > Right, either way, these ioctls have to be and just need to be
> > > added in the ioctl of the mdev_parent_ops. But another thing we
> > > also need to consider is that which file descriptor the userspace
> > > will do the ioctl() on. So I'm wondering do you mean let the
> > > userspace do the ioctl() on the VFIO device fd of the mdev
> > > device?
> > >   
> > 
> > Yes.  
> 
> Got it! I'm not sure what's Alex opinion on this. If we all
> agree with this, I can do it in this way.
> 
> > Is there any other way btw?  
> 
> Just a quick thought.. Maybe totally a bad idea. I was thinking
> whether it would be odd to do non-VFIO's ioctls on VFIO's device
> fd. So I was wondering whether it's possible to allow binding
> another mdev driver (e.g. vhost_mdev) to the supported mdev
> devices. The new mdev driver, vhost_mdev, can provide similar
> ways to let userspace open the mdev device and do the vhost ioctls
> on it. To distinguish with the vfio_mdev compatible mdev devices,
> the device API of the new vhost_mdev compatible mdev devices
> might be e.g. "vhost-net" for net?
> 
> So in VFIO case, the device will be for passthru directly. And
> in VHOST case, the device can be used to accelerate the existing
> virtualized devices.
> 
> How do you think?

VFIO really can't prevent vendor specific ioctls on the device file
descriptor for mdevs, but a) we'd want to be sure the ioctl address
space can't collide with ioctls we'd use for vfio defined purposes and
b) maybe the VFIO user API isn't what you want in the first place if
you intend to mostly/entirely ignore the defined ioctl set and replace
them with your own.  In the case of the latter, you're also not getting
the advantages of the existing VFIO userspace code, so why expose a
VFIO device at all.

The mdev interface does provide a general interface for creating and
managing virtual devices, vfio-mdev is just one driver on the mdev
bus.  Parav (Mellanox) has been doing work on mdev-core to help clean
out vfio-isms from the interface, aiui, with the intent of implementing
another mdev bus driver for using the devices within the kernel.  It
seems like this vhost-mdev driver might be similar, using mdev but not
necessarily vfio-mdev to expose devices.  Thanks,

Alex
