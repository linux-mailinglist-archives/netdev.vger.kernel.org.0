Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BAE312693
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBGSOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:14:35 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229491AbhBGSOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:14:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117I5Rew029232;
        Sun, 7 Feb 2021 10:13:32 -0800
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrakky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:13:32 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:31 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:30 -0800
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 10:13:27 -0800
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <Erik.Smith@dell.com>,
        <Douglas.Farley@dell.com>, <smalin@marvell.com>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <pkushwaha@marvell.com>, <nassa@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v3 00/11] NVMeTCP Offload ULP and QEDN Device Driver
Date:   Sun, 7 Feb 2021 20:13:13 +0200
Message-ID: <20210207181324.11429-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_08:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


With the goal of enabling a generic infrastructure that allows NVMe/TCP 
offload devices like NICs to seamlessly plug into the NVMe-oF stack, this 
patch series introduces the nvme-tcp-offload ULP host layer, which will 
be a new transport type called "tcp-offload" and will serve as an 
abstraction layer to work with vendor specific nvme-tcp offload drivers.

NVMeTCP offload is a full offload of the NVMeTCP protocol, this includes 
both the TCP level and the NVMeTCP level.

The nvme-tcp-offload transport can co-exist with the existing tcp and 
other transports. The tcp offload was designed so that stack changes are 
kept to a bare minimum: only registering new transports. 
All other APIs, ops etc. are identical to the regular tcp transport.
Representing the TCP offload as a new transport allows clear and manageable
differentiation between the connections which should use the offload path
and those that are not offloaded (even on the same device).


Queue Initialization:
=====================
The nvme-tcp-offload ULP module shall register with the existing 
nvmf_transport_ops (.name = "tcp_offload"), nvme_ctrl_ops and blk_mq_ops.
The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
with the following ops:
 - claim_dev() - in order to resolve the route to the target according to
                 the net_dev.
 - create_queue() - in order to create offloaded nvme-tcp queue.

The nvme-tcp-offload ULP module shall manage all the controller level
functionalities, call claim_dev and based on the return values shall call
the relevant module create_queue in order to create the admin queue and
the IO queues.


IO-path:
========
The nvme-tcp-offload shall work at the IO-level - the nvme-tcp-offload 
ULP module shall pass the request (the IO) to the nvme-tcp-offload vendor
driver and later, the nvme-tcp-offload vendor driver returns the request
completion (the IO completion).
No additional handling is needed in between; this design will reduce the
CPU utilization as we will describe below.

The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
with the following IO-path ops:
 - init_req()
 - map_sg() - in order to map the request sg (similar to 
              nvme_rdma_map_data() ).
 - send_req() - in order to pass the request to the handling of the
                offload driver that shall pass it to the vendor specific
				device.
 - poll_queue()

Once the IO completes, the nvme-tcp-offload vendor driver shall call 
command.done() that will invoke the nvme-tcp-offload ULP layer to
complete the request.


TCP events:
===========
The Marvell FastLinQ NIC HW engine handle all the TCP re-transmissions
and OOO events.


Teardown and errors:
====================
In case of NVMeTCP queue error the nvme-tcp-offload vendor driver shall
call the nvme_tcp_ofld_report_queue_err.
The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
with the following teardown ops:
 - drain_queue()
 - destroy_queue()
 

 The Marvell FastLinQ NIC HW engine:
====================================
The Marvell NIC HW engine is capable of offloading the entire TCP/IP
stack and managing up to 64K connections per PF, already implemented and 
upstream use cases for this include iWARP (by the Marvell qedr driver) 
and iSCSI (by the Marvell qedi driver).
In addition, the Marvell NIC HW engine offloads the NVMeTCP queue layer
and is able to manage the IO level also in case of TCP re-transmissions
and OOO events.
The HW engine enables direct data placement (including the data digest CRC
calculation and validation) and direct data transmission (including data
digest CRC calculation).


The Marvell qedn driver:
========================
The new driver will be added under "drivers/nvme/hw" and will be enabled
by the Kconfig "Marvell NVM Express over Fabrics TCP offload".
As part of the qedn init, the driver will register as a pci device driver 
and will work with the Marvell fastlinQ NIC.
As part of the probe, the driver will register to the nvme_tcp_offload
(ULP) and to the qed module (qed_nvmetcp_ops) - similar to other
"qed_*_ops" which are used by the qede, qedr, qedf and qedi device
drivers.
  
 
The series' patches:
===================
Patch 1-2       Add the nvme-tcp-offload ULP module, including the APIs.
Patches 3-5     nvme-tcp-offload ULP controller level functionalities.
Patch 6         nvme-tcp-offload ULP queue level functionalities.
Patch 7         nvme-tcp-offload ULP IO level functionalities.
Patch 8			nvme-qedn Marvell's NVMeTCP HW offload vendor driver.
Patch 9			net-qed NVMeTCP Offload PF level FW and HW HSI.
Patch 10-11		nvme-qedn probe level functionalities.


Performance:
============
With this implementation on top of the Marvell qedn driver (using the
Marvell FastLinQ NIC), we were able to demonstrate x3 CPU utilization
improvement for 4K queued read/write IOs and up to x20 in case of 512K
read/write IOs.
In addition, we were able to demonstrate latency improvement, and 
specifically 99.99% tail latency improvement of up to x2-5 (depends on
the queue-depth).


Future work:
============
For simplicity, the RFC series does not include the following 
functionalities which will be added based on the comments on patches 1-11.
 - nvme-tcp-offload teardown, IO timeout and async flows.
 - qedn device/queue/IO level.
 
 
Long term future work:
============
 - The nvme-tcp-offload ULP target abstraction layer.
 - The Marvell nvme-tcp-offload "qednt" target driver.


Changes since RFC v1:
=====================
- Fix nvme_tcp_ofld_ops return values.
- Remove NVMF_TRTYPE_TCP_OFFLOAD.
- Add nvme_tcp_ofld_poll() implementation.
- Fix nvme_tcp_ofld_queue_rq() to check map_sg() and send_req() return
  values.


Changes since RFC v2:
=====================
- Add qedn - Marvell's NVMeTCP HW offload vendor driver init and probe
  (patches 8-11).
- Fixes in controller and queue level (patches 3-6).
  

Arie Gershberg (3):
  nvme-fabrics: Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS
    definitions
  nvme-tcp-offload: Add controller level implementation
  nvme-tcp-offload: Add controller level error recovery implementation

Dean Balandin (3):
  nvme-tcp-offload: Add device scan implementation
  nvme-tcp-offload: Add queue level implementation
  nvme-tcp-offload: Add IO level implementation

Shai Malin (5):
  nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP
  nvme-qedn: Add qedn - Marvell's NVMeTCP HW offload vendor driver
  net-qed: Add NVMeTCP Offload PF Level FW and HW HSI
  nvme-qedn: Add qedn probe
  nvme-qedn: Add IRQ and fast-path resources initializations

 MAINTAINERS                                   |   10 +
 drivers/net/ethernet/qlogic/Kconfig           |    3 +
 drivers/net/ethernet/qlogic/qed/Makefile      |    1 +
 drivers/net/ethernet/qlogic/qed/qed.h         |    3 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |    1 +
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |  269 ++++
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |   48 +
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |    2 +
 drivers/nvme/Kconfig                          |    1 +
 drivers/nvme/Makefile                         |    1 +
 drivers/nvme/host/Kconfig                     |   16 +
 drivers/nvme/host/Makefile                    |    3 +
 drivers/nvme/host/fabrics.c                   |    7 -
 drivers/nvme/host/fabrics.h                   |    7 +
 drivers/nvme/host/tcp-offload.c               | 1123 +++++++++++++++++
 drivers/nvme/host/tcp-offload.h               |  185 +++
 drivers/nvme/hw/Kconfig                       |    9 +
 drivers/nvme/hw/Makefile                      |    3 +
 drivers/nvme/hw/qedn/Makefile                 |    3 +
 drivers/nvme/hw/qedn/qedn.c                   |  652 ++++++++++
 drivers/nvme/hw/qedn/qedn.h                   |   90 ++
 include/linux/qed/common_hsi.h                |    1 +
 include/linux/qed/nvmetcp_common.h            |   47 +
 include/linux/qed/qed_if.h                    |   22 +
 include/linux/qed/qed_nvmetcp_if.h            |   71 ++
 25 files changed, 2571 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
 create mode 100644 drivers/nvme/host/tcp-offload.c
 create mode 100644 drivers/nvme/host/tcp-offload.h
 create mode 100644 drivers/nvme/hw/Kconfig
 create mode 100644 drivers/nvme/hw/Makefile
 create mode 100644 drivers/nvme/hw/qedn/Makefile
 create mode 100644 drivers/nvme/hw/qedn/qedn.c
 create mode 100644 drivers/nvme/hw/qedn/qedn.h
 create mode 100644 include/linux/qed/nvmetcp_common.h
 create mode 100644 include/linux/qed/qed_nvmetcp_if.h

-- 
2.22.0

