Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4892B2DCCF6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgLQH1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:27:33 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4093 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgLQH12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 02:27:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdb08380000>; Wed, 16 Dec 2020 23:26:48 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Thu, 17 Dec 2020 07:26:26 +0000
Date:   Thu, 17 Dec 2020 09:26:22 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <eli@mellanox.com>, <lingshan.zhu@intel.com>,
        <rob.miller@broadcom.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [PATCH 00/21] Control VQ support in vDPA
Message-ID: <20201217072622.GA183776@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608190008; bh=AeN8b9KPyrD/VVYP2KcQSRMHK50hVuE+3vlPQDmcSQc=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=asq6UKVoAxwr6HevCOVogu4mA3BIipaPZN3JWPg7N17CyrkMxxEYmvjdvkZrNgy48
         nkk8rvftwca0dCa7sKpQSKodMw9KZdLsnlPA124yx9HoZwFWbHsYXri/hiXP/kn31J
         hYQqiUrT+3AsCh8mwOJu5L4eFDwBx+mWYwGB2n8954QIEK6zV7adWvEQrre1MgHqYO
         CoM7dz0h9CXoHNrRc9Dv88XDD/yIQY/1PirSTa6y0xb3v8wkPk9bGWbzh0sdbOIP6u
         aEkM1/a0K8vPdcOjx6ql+UiBFHChHI6E/2pZl5AbemM/UqJu916aQwhEPqGWgtRCgL
         ecKaYbVIhls+Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:47:57PM +0800, Jason Wang wrote:

Hi Jason,
I saw the patchset and will start reviewing it starting Dec 27. I am out
of office next week.

> Hi All:
> 
> This series tries to add the support for control virtqueue in vDPA.
> 
> Control virtqueue is used by networking device for accepting various
> commands from the driver. It's a must to support multiqueue and other
> configurations.
> 
> When used by vhost-vDPA bus driver for VM, the control virtqueue
> should be shadowed via userspace VMM (Qemu) instead of being assigned
> directly to Guest. This is because Qemu needs to know the device state
> in order to start and stop device correctly (e.g for Live Migration).
> 
> This requies to isolate the memory mapping for control virtqueue
> presented by vhost-vDPA to prevent guest from accesing it directly.
> 
> To achieve this, vDPA introduce two new abstractions:
> 
> - address space: identified through address space id (ASID) and a set
>                  of memory mapping in maintained
> - virtqueue group: the minimal set of virtqueues that must share an
>                  address space
> 
> Device needs to advertise the following attributes to vDPA:
> 
> - the number of address spaces supported in the device
> - the number of virtqueue groups supported in the device
> - the mappings from a specific virtqueue to its virtqueue groups
> 
> The mappings from virtqueue to virtqueue groups is fixed and defined
> by vDPA device driver. E.g:
> 
> - For the device that has hardware ASID support, it can simply
>   advertise a per virtqueue virtqueue group.
> - For the device that does not have hardware ASID support, it can
>   simply advertise a single virtqueue group that contains all
>   virtqueues. Or if it wants a software emulated control virtqueue, it
>   can advertise two virtqueue groups, one is for cvq, another is for
>   the rest virtqueues.
> 
> vDPA also allow to change the association between virtqueue group and
> address space. So in the case of control virtqueue, userspace
> VMM(Qemu) may use a dedicated address space for the control virtqueue
> group to isolate the memory mapping.
> 
> The vhost/vhost-vDPA is also extend for the userspace to:
> 
> - query the number of virtqueue groups and address spaces supported by
>   the device
> - query the virtqueue group for a specific virtqueue
> - assocaite a virtqueue group with an address space
> - send ASID based IOTLB commands
> 
> This will help userspace VMM(Qemu) to detect whether the control vq
> could be supported and isolate memory mappings of control virtqueue
> from the others.
> 
> To demonstrate the usage, vDPA simulator is extended to support
> setting MAC address via a emulated control virtqueue.
> 
> Please review.
> 
> Changes since RFC:
> 
> - tweak vhost uAPI documentation
> - switch to use device specific IOTLB really in patch 4
> - tweak the commit log
> - fix that ASID in vhost is claimed to be 32 actually but 16bit
>   actually
> - fix use after free when using ASID with IOTLB batching requests
> - switch to use Stefano's patch for having separated iov
> - remove unused "used_as" variable
> - fix the iotlb/asid checking in vhost_vdpa_unmap()
> 
> Thanks
> 
> Jason Wang (20):
>   vhost: move the backend feature bits to vhost_types.h
>   virtio-vdpa: don't set callback if virtio doesn't need it
>   vhost-vdpa: passing iotlb to IOMMU mapping helpers
>   vhost-vdpa: switch to use vhost-vdpa specific IOTLB
>   vdpa: add the missing comment for nvqs in struct vdpa_device
>   vdpa: introduce virtqueue groups
>   vdpa: multiple address spaces support
>   vdpa: introduce config operations for associating ASID to a virtqueue
>     group
>   vhost_iotlb: split out IOTLB initialization
>   vhost: support ASID in IOTLB API
>   vhost-vdpa: introduce asid based IOTLB
>   vhost-vdpa: introduce uAPI to get the number of virtqueue groups
>   vhost-vdpa: introduce uAPI to get the number of address spaces
>   vhost-vdpa: uAPI to get virtqueue group id
>   vhost-vdpa: introduce uAPI to set group ASID
>   vhost-vdpa: support ASID based IOTLB API
>   vdpa_sim: advertise VIRTIO_NET_F_MTU
>   vdpa_sim: factor out buffer completion logic
>   vdpa_sim: filter destination mac address
>   vdpasim: control virtqueue support
> 
> Stefano Garzarella (1):
>   vdpa_sim: split vdpasim_virtqueue's iov field in out_iov and in_iov
> 
>  drivers/vdpa/ifcvf/ifcvf_main.c   |   9 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  11 +-
>  drivers/vdpa/vdpa.c               |   8 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 292 ++++++++++++++++++++++++------
>  drivers/vhost/iotlb.c             |  23 ++-
>  drivers/vhost/vdpa.c              | 246 ++++++++++++++++++++-----
>  drivers/vhost/vhost.c             |  23 ++-
>  drivers/vhost/vhost.h             |   4 +-
>  drivers/virtio/virtio_vdpa.c      |   2 +-
>  include/linux/vdpa.h              |  42 ++++-
>  include/linux/vhost_iotlb.h       |   2 +
>  include/uapi/linux/vhost.h        |  25 ++-
>  include/uapi/linux/vhost_types.h  |  10 +-
>  13 files changed, 561 insertions(+), 136 deletions(-)
> 
> -- 
> 2.25.1
> 
