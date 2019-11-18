Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835981002AF
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfKRKnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:43:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726464AbfKRKnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574073790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8jlmal5dvxCfO7XDigN1s/AlBMfJgLUYN1XHbPjGr8=;
        b=PZdKr83Pnw+WIpsn8Ex8sMFmPGCNFYhkhxjSyQLunGL+xC9/RxPacP51YPWYQnEMUN3uyz
        s1r9RxNEudn5hRLAIaCV/JB3EF/CoDA3lODbB2LSPoS7+Q+XTzg5oB34vyLfUlnknjKCED
        vc3lBc8VkHuNNq1YuvpL9W2IRybj+9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-m7LyLCiWPGWMN_xDf-2JsQ-1; Mon, 18 Nov 2019 05:43:07 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FC1E800A02;
        Mon, 18 Nov 2019 10:43:01 +0000 (UTC)
Received: from [10.72.12.65] (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96026101F6D2;
        Mon, 18 Nov 2019 10:42:35 +0000 (UTC)
Subject: Re: [PATCH V12 0/6] mdev based hardware virtio offloading support
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        gregkh@linuxfoundation.org, jgg@mellanox.com
References: <20191118061703.8669-1-jasowang@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <427143e8-d422-3d5c-7e66-7ad063841bb2@redhat.com>
Date:   Mon, 18 Nov 2019 18:42:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118061703.8669-1-jasowang@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: m7LyLCiWPGWMN_xDf-2JsQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/18 =E4=B8=8B=E5=8D=882:16, Jason Wang wrote:
> Hi all:
>
> There are hardwares that can do virtio datapath offloading while
> having its own control path. This path tries to implement a mdev based
> unified API to support using kernel virtio driver to drive those
> devices. This is done by introducing a new mdev transport for virtio
> (virtio_mdev) and register itself as a new kind of mdev driver. Then
> it provides a unified way for kernel virtio driver to talk with mdev
> device implementation.
>
> Though the series only contains kernel driver support, the goal is to
> make the transport generic enough to support userspace drivers. This
> means vhost-mdev[1] could be built on top as well by resuing the
> transport.
>
> A sample driver is also implemented which simulate a virito-net
> loopback ethernet device on top of vringh + workqueue. This could be
> used as a reference implementation for real hardware driver.
>
> Also a real IFC VF driver was also posted here[2] which is a good
> reference for vendors who is interested in their own virtio datapath
> offloading product.
>
> Consider mdev framework only support VFIO device and driver right now,
> this series also extend it to support other types. This is done
> through decoupling VFIO specific bits out of mdev core and make mdev
> an independent module that allows to be used by multiple types of
> buses.
>
> Pktgen test was done with virito-net + mvnet loop back device.
>
> Please review.
>
> [1] https://lkml.org/lkml/2019/11/5/424
> [2] https://lkml.org/lkml/2019/11/5/227
>
> Changes from V11:
> - decouple VFIO specific bits out of mdev core
> - make mdev an indepdent module to allow buses other than VFIO mdev
> - allow structure composition of mdev through specifiy the size of
>    mdev structure
> - introduce mdev_vfio structure and store the VFIO specific callbacks
>    there
> - don't use "mdev" bus for virtio, use a new "mdev_virtio" bus, and
>    store the virtio specific callbacks in mdev_virtio structure.
> - do the class_id, matching on top of "mdev_virtio" bus


It looks to me this series get some conflicts with gvt-linux.git. Will=20
fix them and post v13.

Thanks


>
> Changes from V10:
> - rename mvnet to mvnet_loopback
> - fix typo in the help text for sample Kconfig
>
> Changes from V9:
> - Tweak the help text for virito-mdev kconfig
>
> Changes from V8:
> - try silent checkpatch, some are still there becuase they were inherited
>    from virtio_config_ops which needs to be resolved in an independent se=
ries
> - tweak on the comment and doc
> - remove VIRTIO_MDEV_F_VERSION_1 completely
> - rename CONFIG_VIRTIO_MDEV_DEVICE to CONFIG_VIRTIO_MDEV
>
> Changes from V7:
> - drop {set|get}_mdev_features for virtio
> - typo and comment style fixes
>
> Changes from V6:
> - rename ops files and compile guard
>
> Changes from V5:
> - use dev_warn() instead of WARN(1) when class id is not set
> - validate id_table before trying to do matching between device and
>    driver
> - add wildcard for modpost script
> - use unique name for id_table
> - move get_mdev_features() to be the first member of virtio_device_ops
>    and more comments for it
> - typo fixes for the comments above virtio_mdev_ops
>
> Changes from V4:
> - keep mdev_set_class() for the device that doesn't use device ops
> - use union for device ops pointer in mdev_device
> - introduce class specific helper for getting is device ops
> - use WARN_ON instead of BUG_ON in mdev_set_virtio_ops
> - explain details of get_mdev_features() and get_vendor_id()
> - distinguish the optional virito device ops from mandatory ones and
>    make get_generation() optional
> - rename vfio_mdev.h to vfio_mdev_ops.h, rename virito_mdev.h to
>    virtio_mdev_ops.h
> - don't abuse version fileds in virtio_mdev structure, use features
>    instead
> - fix warning during device remove
> - style & docs tweaks and typo fixes
>
> Changes from V3:
> - document that class id (device ops) must be specified in create()
> - add WARN() when trying to set class_id when it has already set
> - add WARN() when class_id is not specified in create() and correctly
>    return an error in this case
> - correct the prototype of mdev_set_class() in the doc
> - add documention of mdev_set_class()
> - remove the unnecessary "class_id_fail" label when class id is not
>    specified in create()
> - convert id_table in vfio_mdev to const
> - move mdev_set_class and its friends after mdev_uuid()
> - suqash the patch of bus uevent into patch of introducing class id
> - tweak the words in the docs per Cornelia suggestion
> - tie class_id and device ops through class specific initialization
>    routine like mdev_set_vfio_ops()
> - typos fixes in the docs of virtio-mdev callbacks
> - document the usage of virtqueues in struct virtio_mdev_device
> - remove the useless vqs array in struct virtio_mdev_device
> - rename MDEV_ID_XXX to MDEV_CLASS_ID_XXX
>
> Changes from V2:
> - fail when class_id is not specified
> - drop the vringh patch
> - match the doc to the code
> - tweak the commit log
> - move device_ops from parent to mdev device
> - remove the unused MDEV_ID_VHOST
>
> Changes from V1:
> - move virtio_mdev.c to drivers/virtio
> - store class_id in mdev_device instead of mdev_parent
> - store device_ops in mdev_device instead of mdev_parent
> - reorder the patch, vringh fix comes first
> - really silent compiling warnings
> - really switch to use u16 for class_id
> - uevent and modpost support for mdev class_id
> - vraious tweaks per comments from Parav
>
> Changes from RFC-V2:
> - silent compile warnings on some specific configuration
> - use u16 instead u8 for class id
> - reseve MDEV_ID_VHOST for future vhost-mdev work
> - introduce "virtio" type for mvnet and make "vhost" type for future
>    work
> - add entries in MAINTAINER
> - tweak and typos fixes in commit log
>
> Changes from RFC-V1:
> - rename device id to class id
> - add docs for class id and device specific ops (device_ops)
> - split device_ops into seperate headers
> - drop the mdev_set_dma_ops()
> - use device_ops to implement the transport API, then it's not a part
>    of UAPI any more
> - use GFP_ATOMIC in mvnet sample device and other tweaks
> - set_vring_base/get_vring_base support for mvnet device
>
>
> Jason Wang (6):
>    mdev: make mdev bus agnostic
>    mdev: split out VFIO bus specific parent ops
>    mdev: move to drivers/
>    mdev: introduce mediated virtio bus
>    virtio: introduce a mdev based transport
>    docs: sample driver to demonstrate how to implement virtio-mdev
>      framework
>
>   .../driver-api/vfio-mediated-device.rst       |  94 ++-
>   MAINTAINERS                                   |  11 +-
>   drivers/Kconfig                               |   2 +
>   drivers/Makefile                              |   1 +
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  26 +-
>   drivers/mdev/Kconfig                          |  29 +
>   drivers/mdev/Makefile                         |   7 +
>   drivers/{vfio =3D> }/mdev/mdev_core.c           | 107 ++-
>   drivers/{vfio =3D> }/mdev/mdev_driver.c         |  29 +-
>   drivers/{vfio =3D> }/mdev/mdev_private.h        |  18 +-
>   drivers/{vfio =3D> }/mdev/mdev_sysfs.c          |   0
>   drivers/mdev/vfio.c                           |  76 ++
>   drivers/mdev/virtio.c                         | 126 ++++
>   drivers/s390/cio/vfio_ccw_ops.c               |  23 +-
>   drivers/s390/crypto/vfio_ap_ops.c             |  34 +-
>   drivers/s390/crypto/vfio_ap_private.h         |   2 +-
>   drivers/vfio/mdev/Kconfig                     |  11 -
>   drivers/vfio/mdev/Makefile                    |   4 -
>   drivers/vfio/mdev/vfio_mdev.c                 |  45 +-
>   drivers/vfio/vfio_iommu_type1.c               |   6 +-
>   drivers/virtio/Kconfig                        |  13 +
>   drivers/virtio/Makefile                       |   1 +
>   drivers/virtio/virtio_mdev.c                  | 409 +++++++++++
>   include/linux/mdev.h                          |  49 +-
>   include/linux/mdev_vfio.h                     |  68 ++
>   include/linux/mdev_virtio.h                   | 168 +++++
>   include/linux/mod_devicetable.h               |   8 +
>   samples/Kconfig                               |  10 +
>   samples/vfio-mdev/Makefile                    |   1 +
>   samples/vfio-mdev/mbochs.c                    |  26 +-
>   samples/vfio-mdev/mdpy.c                      |  27 +-
>   samples/vfio-mdev/mtty.c                      |  24 +-
>   samples/vfio-mdev/mvnet_loopback.c            | 690 ++++++++++++++++++
>   scripts/mod/devicetable-offsets.c             |   3 +
>   scripts/mod/file2alias.c                      |  12 +
>   35 files changed, 1924 insertions(+), 236 deletions(-)
>   create mode 100644 drivers/mdev/Kconfig
>   create mode 100644 drivers/mdev/Makefile
>   rename drivers/{vfio =3D> }/mdev/mdev_core.c (76%)
>   rename drivers/{vfio =3D> }/mdev/mdev_driver.c (83%)
>   rename drivers/{vfio =3D> }/mdev/mdev_private.h (81%)
>   rename drivers/{vfio =3D> }/mdev/mdev_sysfs.c (100%)
>   create mode 100644 drivers/mdev/vfio.c
>   create mode 100644 drivers/mdev/virtio.c
>   create mode 100644 drivers/virtio/virtio_mdev.c
>   create mode 100644 include/linux/mdev_vfio.h
>   create mode 100644 include/linux/mdev_virtio.h
>   create mode 100644 samples/vfio-mdev/mvnet_loopback.c
>

