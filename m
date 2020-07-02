Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A36211E0A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgGBIWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:22:08 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59346 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgGBIWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:08 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628LuYq081675;
        Thu, 2 Jul 2020 03:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678116;
        bh=KmDEx84ZylqeHRRIg+ywtR6uqUDz71eDn9DrKmWcHRo=;
        h=From:To:CC:Subject:Date;
        b=JYTSz6tCbffjaS8p0R98jFdU890cGlFgkaOIUX73Isf6MRMb/U17YWcenQm9dERCa
         uNWmCgLlLq60cM9CJqROng6gAsyNsVmRi/7u5UBoPIUD9KHejtBD55BvUyeeVEw5IC
         /B77fRU9Di3zLD24jEuw3XemZ32TkSelC9dgTAEw=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628LoK6065017
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:21:51 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:21:50 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:21:50 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYC006145;
        Thu, 2 Jul 2020 03:21:45 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 00/22] Enhance VHOST to enable SoC-to-SoC communication
Date:   Thu, 2 Jul 2020 13:51:21 +0530
Message-ID: <20200702082143.25259-1-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enhances Linux Vhost support to enable SoC-to-SoC
communication over MMIO. This series enables rpmsg communication between
two SoCs using both PCIe RC<->EP and HOST1-NTB-HOST2

1) Modify vhost to use standard Linux driver model
2) Add support in vring to access virtqueue over MMIO
3) Add vhost client driver for rpmsg
4) Add PCIe RC driver (uses virtio) and PCIe EP driver (uses vhost) for
   rpmsg communication between two SoCs connected to each other
5) Add NTB Virtio driver and NTB Vhost driver for rpmsg communication
   between two SoCs connected via NTB
6) Add configfs to configure the components

UseCase1 :

 VHOST RPMSG                     VIRTIO RPMSG
      +                               +
      |                               |
      |                               |
      |                               |
      |                               |
+-----v------+                 +------v-------+
|   Linux    |                 |     Linux    |
|  Endpoint  |                 | Root Complex |
|            <----------------->              |
|            |                 |              |
|    SOC1    |                 |     SOC2     |
+------------+                 +--------------+

UseCase 2:

     VHOST RPMSG                                      VIRTIO RPMSG
          +                                                 +
          |                                                 |
          |                                                 |
          |                                                 |
          |                                                 |
   +------v------+                                   +------v------+
   |             |                                   |             |
   |    HOST1    |                                   |    HOST2    |
   |             |                                   |             |
   +------^------+                                   +------^------+
          |                                                 |
          |                                                 |
+---------------------------------------------------------------------+
|  +------v------+                                   +------v------+  |
|  |             |                                   |             |  |
|  |     EP      |                                   |     EP      |  |
|  | CONTROLLER1 |                                   | CONTROLLER2 |  |
|  |             <----------------------------------->             |  |
|  |             |                                   |             |  |
|  |             |                                   |             |  |
|  |             |  SoC With Multiple EP Instances   |             |  |
|  |             |  (Configured using NTB Function)  |             |  |
|  +-------------+                                   +-------------+  |
+---------------------------------------------------------------------+

Software Layering:

The high-level SW layering should look something like below. This series
adds support only for RPMSG VHOST, however something similar should be
done for net and scsi. With that any vhost device (PCI, NTB, Platform
device, user) can use any of the vhost client driver.


    +----------------+  +-----------+  +------------+  +----------+
    |  RPMSG VHOST   |  | NET VHOST |  | SCSI VHOST |  |    X     |
    +-------^--------+  +-----^-----+  +-----^------+  +----^-----+
            |                 |              |              |
            |                 |              |              |
            |                 |              |              |
+-----------v-----------------v--------------v--------------v----------+
|                            VHOST CORE                                |
+--------^---------------^--------------------^------------------^-----+
         |               |                    |                  |
         |               |                    |                  |
         |               |                    |                  |
+--------v-------+  +----v------+  +----------v----------+  +----v-----+
|  PCI EPF VHOST |  | NTB VHOST |  |PLATFORM DEVICE VHOST|  |    X     |
+----------------+  +-----------+  +---------------------+  +----------+

This was initially proposed here [1]

[1] -> https://lore.kernel.org/r/2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com


Kishon Vijay Abraham I (22):
  vhost: Make _feature_ bits a property of vhost device
  vhost: Introduce standard Linux driver model in VHOST
  vhost: Add ops for the VHOST driver to configure VHOST device
  vringh: Add helpers to access vring in MMIO
  vhost: Add MMIO helpers for operations on vhost virtqueue
  vhost: Introduce configfs entry for configuring VHOST
  virtio_pci: Use request_threaded_irq() instead of request_irq()
  rpmsg: virtio_rpmsg_bus: Disable receive virtqueue callback when
    reading messages
  rpmsg: Introduce configfs entry for configuring rpmsg
  rpmsg: virtio_rpmsg_bus: Add Address Service Notification support
  rpmsg: virtio_rpmsg_bus: Move generic rpmsg structure to
    rpmsg_internal.h
  virtio: Add ops to allocate and free buffer
  rpmsg: virtio_rpmsg_bus: Use virtio_alloc_buffer() and
    virtio_free_buffer()
  rpmsg: Add VHOST based remote processor messaging bus
  samples/rpmsg: Setup delayed work to send message
  samples/rpmsg: Wait for address to be bound to rpdev for sending
    message
  rpmsg.txt: Add Documentation to configure rpmsg using configfs
  virtio_pci: Add VIRTIO driver for VHOST on Configurable PCIe Endpoint
    device
  PCI: endpoint: Add EP function driver to provide VHOST interface
  NTB: Add a new NTB client driver to implement VIRTIO functionality
  NTB: Add a new NTB client driver to implement VHOST functionality
  NTB: Describe the ntb_virtio and ntb_vhost client in the documentation

 Documentation/driver-api/ntb.rst              |   11 +
 Documentation/rpmsg.txt                       |   56 +
 drivers/ntb/Kconfig                           |   18 +
 drivers/ntb/Makefile                          |    2 +
 drivers/ntb/ntb_vhost.c                       |  776 +++++++++++
 drivers/ntb/ntb_virtio.c                      |  853 ++++++++++++
 drivers/ntb/ntb_virtio.h                      |   56 +
 drivers/pci/endpoint/functions/Kconfig        |   11 +
 drivers/pci/endpoint/functions/Makefile       |    1 +
 .../pci/endpoint/functions/pci-epf-vhost.c    | 1144 ++++++++++++++++
 drivers/rpmsg/Kconfig                         |   10 +
 drivers/rpmsg/Makefile                        |    3 +-
 drivers/rpmsg/rpmsg_cfs.c                     |  394 ++++++
 drivers/rpmsg/rpmsg_core.c                    |    7 +
 drivers/rpmsg/rpmsg_internal.h                |  136 ++
 drivers/rpmsg/vhost_rpmsg_bus.c               | 1151 +++++++++++++++++
 drivers/rpmsg/virtio_rpmsg_bus.c              |  184 ++-
 drivers/vhost/Kconfig                         |    1 +
 drivers/vhost/Makefile                        |    2 +-
 drivers/vhost/net.c                           |   10 +-
 drivers/vhost/scsi.c                          |   24 +-
 drivers/vhost/test.c                          |   17 +-
 drivers/vhost/vdpa.c                          |    2 +-
 drivers/vhost/vhost.c                         |  730 ++++++++++-
 drivers/vhost/vhost_cfs.c                     |  341 +++++
 drivers/vhost/vringh.c                        |  332 +++++
 drivers/vhost/vsock.c                         |   20 +-
 drivers/virtio/Kconfig                        |    9 +
 drivers/virtio/Makefile                       |    1 +
 drivers/virtio/virtio_pci_common.c            |   25 +-
 drivers/virtio/virtio_pci_epf.c               |  670 ++++++++++
 include/linux/mod_devicetable.h               |    6 +
 include/linux/rpmsg.h                         |    6 +
 {drivers/vhost => include/linux}/vhost.h      |  132 +-
 include/linux/virtio.h                        |    3 +
 include/linux/virtio_config.h                 |   42 +
 include/linux/vringh.h                        |   46 +
 samples/rpmsg/rpmsg_client_sample.c           |   32 +-
 tools/virtio/virtio_test.c                    |    2 +-
 39 files changed, 7083 insertions(+), 183 deletions(-)
 create mode 100644 drivers/ntb/ntb_vhost.c
 create mode 100644 drivers/ntb/ntb_virtio.c
 create mode 100644 drivers/ntb/ntb_virtio.h
 create mode 100644 drivers/pci/endpoint/functions/pci-epf-vhost.c
 create mode 100644 drivers/rpmsg/rpmsg_cfs.c
 create mode 100644 drivers/rpmsg/vhost_rpmsg_bus.c
 create mode 100644 drivers/vhost/vhost_cfs.c
 create mode 100644 drivers/virtio/virtio_pci_epf.c
 rename {drivers/vhost => include/linux}/vhost.h (66%)

-- 
2.17.1

