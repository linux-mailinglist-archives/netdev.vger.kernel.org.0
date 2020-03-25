Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6338C1922A2
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgCYI21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:28:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51786 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbgCYI21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585124905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TFygb80jlF4QeDh0UcQJf4z7lxP0GjHs8oBGU5kZ/LY=;
        b=DgSLI2gD92rAher9NpkjKhTFLxQxip5kSW+2Iax8ugH9F3P+k+fkFkdC3G8DnaGkhnpaV7
        Ye7EMJRZVAa5NdoKSwceZalwcfDjMTyCZe+y81yVZ6y3rzoFNuXsqxaNWVmRGPbRQMgjtJ
        33KLuzaCaNXqutvz1gj3FiLL3ag5GaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398--wrucZ-_OuGjWFyt-5Vxzw-1; Wed, 25 Mar 2020 04:28:08 -0400
X-MC-Unique: -wrucZ-_OuGjWFyt-5Vxzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2AFC1902EA2;
        Wed, 25 Mar 2020 08:28:05 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-14-13.pek2.redhat.com [10.72.14.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0023CFC5;
        Wed, 25 Mar 2020 08:27:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V8 0/9] vDPA support
Date:   Wed, 25 Mar 2020 16:27:02 +0800
Message-Id: <20200325082711.1107-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:

This is an update version of vDPA support in kernel.

vDPA device is a device that uses a datapath which complies with the
virtio specifications with vendor specific control path. vDPA devices
can be both physically located on the hardware or emulated by
software. vDPA hardware devices are usually implemented through PCIE
with the following types:

- PF (Physical Function) - A single Physical Function
- VF (Virtual Function) - Device that supports single root I/O
  virtualization (SR-IOV). Its Virtual Function (VF) represents a
  virtualized instance of the device that can be assigned to different
  partitions
- ADI (Assignable Device Interface) and its equivalents - With
  technologies such as Intel Scalable IOV, a virtual device (VDEV)
  composed by host OS utilizing one or more ADIs. Or its equivalent
  like SF (Sub function) from Mellanox.

From a driver's perspective, depends on how and where the DMA
translation is done, vDPA devices are split into two types:

- Platform specific DMA translation - From the driver's perspective,
  the device can be used on a platform where device access to data in
  memory is limited and/or translated. An example is a PCIE vDPA whose
  DMA request was tagged via a bus (e.g PCIE) specific way. DMA
  translation and protection are done at PCIE bus IOMMU level.
- Device specific DMA translation - The device implements DMA
  isolation and protection through its own logic. An example is a vDPA
  device which uses on-chip IOMMU.

To hide the differences and complexity of the above types for a vDPA
device/IOMMU options and in order to present a generic virtio device
to the upper layer, a device agnostic framework is required.

This series introduces a software vDPA bus which abstracts the
common attributes of vDPA device, vDPA bus driver and the
communication method, the bus operations (vdpa_config_ops) between the
vDPA device abstraction and the vDPA bus driver. This allows multiple
types of drivers to be used for vDPA device like the virtio_vdpa and
vhost_vdpa driver to operate on the bus and allow vDPA device could be
used by either kernel virtio driver or userspace vhost drivers as:

   virtio drivers  vhost drivers
          |             |
    [virtio bus]   [vhost uAPI]
          |             |
   virtio device   vhost device
   virtio_vdpa drv vhost_vdpa drv
             \       /
            [vDPA bus]
                 |
            vDPA device
            hardware drv
                 |
            [hardware bus]
                 |
            vDPA hardware

virtio_vdpa driver is a transport implementation for kernel virtio
drivers on top of vDPA bus operations. An alternative is to refactor
virtio bus which is sub-optimal since the bus and drivers are designed
to be use by kernel subsystem, a non-trivial major refactoring is
needed which may impact a brunches of drivers and devices
implementation inside the kernel. Using a new transport may grealy
simply both the design and changes.

vhost_vdpa driver is a new type of vhost device which allows userspace
vhost drivers to use vDPA devices via vhost uAPI (with minor
extension). This help to minimize the changes of existed vhost drivers
for using vDPA devices.

With the abstraction of vDPA bus and vDPA bus operations, the
difference and complexity of the under layer hardware is hidden from
upper layer. The vDPA bus drivers on top can use a unified
vdpa_config_ops to control different types of vDPA device.

Two drivers were implemented with the framework introduced in this
series:

- Intel IFC VF driver which depends on the platform IOMMU for DMA
  translation
- VDPA simulator which is a software test device with an emulated
  onchip IOMMU

Future work:

- direct doorbell mapping support
- control virtqueue support
- dirty page tracking support
- direct interrupt support
- management API (devlink)

Please review.

Thanks

Changes from V7:

- refine kconfig to solve the dependency issues on archs that lacks of
  CONFIG_VIRTUALIZATION (kbuild)

Changes from V6:

- vdpa_alloc_device() will allocate parent strcture (Jason)
- remove the vdpa core dev info in IFCVF patch (Jason)
- provide a free method in the vdpa bus operations for drivet to free
  private data
- switch to use new layout in vdapsim and IFCVF
- make IFCVF depends on PCI_MSI (kbuild)
- some tweaks on the IFCVF driver

Changes from V5:

- include Intel IFCVF driver and vhost-vdpa drivers
- add the platform IOMMU support for vhost-vdpa
- check the return value of dev_set_name() (Jason)
- various tweaks and fixes

Changes from V4:

- use put_device() instead of kfree when fail to register virtio
  device (Jason)
- simplify the error handling when allocating vdpasim device (Jason)
- don't use device_for_each_child() during module exit (Jason)
- correct the error checking for vdpa_alloc_device() (Harpreet, Lingshan)

Changes from V3:

- various Kconfig fixes (Randy)

Changes from V2:

- release idr in the release function for put_device() unwind (Jason)
- don't panic when fail to register vdpa bus (Jason)
- use unsigned int instead of int for ida (Jason)
- fix the wrong commit log in virito_vdpa patches (Jason)
- make vdpa_sim depends on RUNTIME_TESTING_MENU (Michael)
- provide a bus release function for vDPA device (Jason)
- fix the wrong unwind when creating devices for vDPA simulator (Jason)
- move vDPA simulator to a dedicated directory (Lingshan)
- cancel the work before release vDPA simulator

Changes from V1:

- drop sysfs API, leave the management interface to future development
  (Michael)
- introduce incremental DMA ops (dma_map/dma_unmap) (Michael)
- introduce dma_device and use it instead of parent device for doing
  IOMMU or DMA from bus driver (Michael, Jason, Ling Shan, Tiwei)
- accept parent device and dma device when register vdpa device
- coding style and compile fixes (Randy)
- using vdpa_xxx instead of xxx_vdpa (Jason)
- ove vDPA accessors to header and make it static inline (Jason)
- split vdp_register_device() into two helpers vdpa_init_device() and
  vdpa_register_device() which allows intermediate step to be done (Jason=
)
- warn on invalidate queue state when fail to creating virtqueue (Jason)
- make to_virtio_vdpa_device() static (Jason)
- use kmalloc/kfree instead of devres for virtio vdpa device (Jason)
- avoid using cast in vdpa bus function (Jason)
- introduce module_vdpa_driver and fix module refcnt (Jason)
- fix returning freed address in vdapsim coherent DMA addr allocation (Da=
n)
- various other fixes and tweaks

V7: https://lkml.org/lkml/2020/3/24/21
V6: https://lkml.org/lkml/2020/3/18/88
V5: https://lkml.org/lkml/2020/2/26/58
V4: https://lkml.org/lkml/2020/2/20/59
V3: https://lkml.org/lkml/2020/2/19/1347
V2: https://lkml.org/lkml/2020/2/9/275
V1: https://lkml.org/lkml/2020/1/16/353

Jason Wang (7):
  vhost: refine vhost and vringh kconfig
  vhost: allow per device message handler
  vhost: factor out IOTLB
  vringh: IOTLB support
  vDPA: introduce vDPA bus
  virtio: introduce a vDPA based transport
  vdpasim: vDPA device simulator

Tiwei Bie (1):
  vhost: introduce vDPA-based backend

Zhu Lingshan (1):
  virtio: Intel IFC VF driver for VDPA

 MAINTAINERS                             |   2 +
 arch/arm/kvm/Kconfig                    |   2 -
 arch/arm64/kvm/Kconfig                  |   2 -
 arch/mips/kvm/Kconfig                   |   2 -
 arch/powerpc/kvm/Kconfig                |   2 -
 arch/s390/kvm/Kconfig                   |   4 -
 arch/x86/kvm/Kconfig                    |   4 -
 drivers/Kconfig                         |   2 +
 drivers/misc/mic/Kconfig                |   4 -
 drivers/net/caif/Kconfig                |   4 -
 drivers/vhost/Kconfig                   |  42 +-
 drivers/vhost/Kconfig.vringh            |   6 -
 drivers/vhost/Makefile                  |   6 +
 drivers/vhost/iotlb.c                   | 177 +++++
 drivers/vhost/net.c                     |   5 +-
 drivers/vhost/scsi.c                    |   2 +-
 drivers/vhost/vdpa.c                    | 883 ++++++++++++++++++++++++
 drivers/vhost/vhost.c                   | 233 +++----
 drivers/vhost/vhost.h                   |  45 +-
 drivers/vhost/vringh.c                  | 421 ++++++++++-
 drivers/vhost/vsock.c                   |   2 +-
 drivers/virtio/Kconfig                  |  15 +
 drivers/virtio/Makefile                 |   2 +
 drivers/virtio/vdpa/Kconfig             |  37 +
 drivers/virtio/vdpa/Makefile            |   4 +
 drivers/virtio/vdpa/ifcvf/Makefile      |   3 +
 drivers/virtio/vdpa/ifcvf/ifcvf_base.c  | 386 +++++++++++
 drivers/virtio/vdpa/ifcvf/ifcvf_base.h  | 132 ++++
 drivers/virtio/vdpa/ifcvf/ifcvf_main.c  | 474 +++++++++++++
 drivers/virtio/vdpa/vdpa.c              | 180 +++++
 drivers/virtio/vdpa/vdpa_sim/Makefile   |   2 +
 drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c | 629 +++++++++++++++++
 drivers/virtio/virtio_vdpa.c            | 396 +++++++++++
 include/linux/vdpa.h                    | 247 +++++++
 include/linux/vhost_iotlb.h             |  47 ++
 include/linux/vringh.h                  |  36 +
 include/uapi/linux/vhost.h              |  24 +
 include/uapi/linux/vhost_types.h        |   8 +
 38 files changed, 4224 insertions(+), 248 deletions(-)
 delete mode 100644 drivers/vhost/Kconfig.vringh
 create mode 100644 drivers/vhost/iotlb.c
 create mode 100644 drivers/vhost/vdpa.c
 create mode 100644 drivers/virtio/vdpa/Kconfig
 create mode 100644 drivers/virtio/vdpa/Makefile
 create mode 100644 drivers/virtio/vdpa/ifcvf/Makefile
 create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_base.c
 create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_base.h
 create mode 100644 drivers/virtio/vdpa/ifcvf/ifcvf_main.c
 create mode 100644 drivers/virtio/vdpa/vdpa.c
 create mode 100644 drivers/virtio/vdpa/vdpa_sim/Makefile
 create mode 100644 drivers/virtio/vdpa/vdpa_sim/vdpa_sim.c
 create mode 100644 drivers/virtio/virtio_vdpa.c
 create mode 100644 include/linux/vdpa.h
 create mode 100644 include/linux/vhost_iotlb.h

--=20
2.20.1

