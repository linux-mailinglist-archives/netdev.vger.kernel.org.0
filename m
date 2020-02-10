Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F389D156E22
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 04:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgBJD5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 22:57:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgBJD5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 22:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581307051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FpaNsEwT/ks+uSjIzZvFcpf96lfi9mqPgeVQPWwqQKs=;
        b=V8vhku9frgr1FMr1SCcN5PnSCbkyo052XS0frT1yA2uscBpbNsx1q+vuuvMs9xnL48Mj1l
        5XFlw2HreRI5CHvSLW+l1VJOK5if2GB7Hn/veknmZjzeGD9aMiMsoj6/tm04HSMwWbOhB7
        TrpmrPt0b1bLT/2DR3PDfMRtkUNfUuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-zqTqYp5IPvKusquXu357Vg-1; Sun, 09 Feb 2020 22:57:27 -0500
X-MC-Unique: zqTqYp5IPvKusquXu357Vg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03CD8800D5E;
        Mon, 10 Feb 2020 03:57:25 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-219.pek2.redhat.com [10.72.13.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB5E9101D481;
        Mon, 10 Feb 2020 03:56:13 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 0/5] vDPA support
Date:   Mon, 10 Feb 2020 11:56:03 +0800
Message-Id: <20200210035608.10002-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:

This is an updated version of kernel support for vDPA device. Various
changes were made based on the feedback since last verion. One major
change is to drop the sysfs API and leave the management interface for
future development, and introudce the incremental DMA bus
operations. Please see changelog for more information.

The work on vhost, IFCVF (intel VF driver for vDPA) and qemu is
ongoing.

Please provide feedback.

Thanks

Change from V1:

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

V1: https://lkml.org/lkml/2020/1/16/353

Jason Wang (5):
  vhost: factor out IOTLB
  vringh: IOTLB support
  vDPA: introduce vDPA bus
  virtio: introduce a vDPA based transport
  vdpasim: vDPA device simulator

 MAINTAINERS                    |   2 +
 drivers/vhost/Kconfig          |   7 +
 drivers/vhost/Kconfig.vringh   |   1 +
 drivers/vhost/Makefile         |   2 +
 drivers/vhost/net.c            |   2 +-
 drivers/vhost/vhost.c          | 221 ++++-------
 drivers/vhost/vhost.h          |  36 +-
 drivers/vhost/vhost_iotlb.c    | 171 +++++++++
 drivers/vhost/vringh.c         | 421 ++++++++++++++++++--
 drivers/virtio/Kconfig         |  15 +
 drivers/virtio/Makefile        |   2 +
 drivers/virtio/vdpa/Kconfig    |  26 ++
 drivers/virtio/vdpa/Makefile   |   3 +
 drivers/virtio/vdpa/vdpa.c     | 160 ++++++++
 drivers/virtio/vdpa/vdpa_sim.c | 678 +++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_vdpa.c   | 392 +++++++++++++++++++
 include/linux/vdpa.h           | 233 +++++++++++
 include/linux/vhost_iotlb.h    |  45 +++
 include/linux/vringh.h         |  36 ++
 19 files changed, 2249 insertions(+), 204 deletions(-)
 create mode 100644 drivers/vhost/vhost_iotlb.c
 create mode 100644 drivers/virtio/vdpa/Kconfig
 create mode 100644 drivers/virtio/vdpa/Makefile
 create mode 100644 drivers/virtio/vdpa/vdpa.c
 create mode 100644 drivers/virtio/vdpa/vdpa_sim.c
 create mode 100644 drivers/virtio/virtio_vdpa.c
 create mode 100644 include/linux/vdpa.h
 create mode 100644 include/linux/vhost_iotlb.h

--=20
2.19.1

