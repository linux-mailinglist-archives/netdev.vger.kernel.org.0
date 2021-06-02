Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664013992BB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhFBSpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:45:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5874 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229468AbhFBSpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:45:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152IeM6B000494;
        Wed, 2 Jun 2021 11:43:12 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xrcdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 11:43:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 11:43:10 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Jun 2021 11:43:07 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <linux-nvme@lists.infradead.org>, <sagi@grimberg.me>, <hch@lst.de>,
        <axboe@fb.com>, <kbusch@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [PATCH 0/8] NVMeTCP Offload ULP
Date:   Wed, 2 Jun 2021 21:42:38 +0300
Message-ID: <20210602184246.14184-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TJGZK2uk-QCq1xw2Mvhrfyw0_14nPBaR
X-Proofpoint-GUID: TJGZK2uk-QCq1xw2Mvhrfyw0_14nPBaR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_10:2021-06-02,2021-06-02 signatures=0
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

The nvme-tcp-offload layers and API compared to nvme-tcp and nvme-rdma:

* NVMe layer: *

       [ nvme/nvme-fabrics/blk-mq ]
             |
        (nvme API and blk-mq API)
             |
             |			 
* Vendor agnostic transport layer: *

      [ nvme-rdma ] [ nvme-tcp ] [ nvme-tcp-offload ]
             |        |             |
           (Verbs) 
             |        |             |
             |     (Socket)
             |        |             |
             |        |        (nvme-tcp-offload API)
             |        |             |
             |        |             |
* Vendor Specific Driver: *

             |        |             |
           [ qedr ]       
                      |             |
                   [ qede ]
                                    |
                                  [ qedn ]


Performance:
============
With this implementation on top of the Marvell qedn driver (using the
Marvell FastLinQ NIC), we were able to demonstrate the following CPU
utilization improvement:

On AMD EPYC 7402, 2.80GHz, 28 cores:
- For 16K queued read IOs, 16jobs, 4qd (50Gbps line rate): 
  Improved the CPU utilization from 15.1% with NVMeTCP SW to 4.7% with 
  NVMeTCP offload.

On Intel(R) Xeon(R) Gold 5122 CPU, 3.60GHz, 16 cores: 
- For 512K queued read IOs, 16jobs, 4qd (25Gbps line rate): 
  Improved the CPU utilization from 16.3% with NVMeTCP SW to 1.1% with 
  NVMeTCP offload.

In addition, we were able to demonstrate the following latency improvement:
- For 200K read IOPS (16 jobs, 16 qd, with fio rate limiter):
  Improved the average latency from 105 usec with NVMeTCP SW to 39 usec 
  with NVMeTCP offload.
  
  Improved the 99.99 tail latency from 570 usec with NVMeTCP SW to 91 usec 
  with NVMeTCP offload.

The end-to-end offload latency was measured from fio while running against 
back end of null device.


Upstream plan:
==============
The RFC series "NVMeTCP Offload ULP and QEDN Device Driver" 
https://lore.kernel.org/netdev/20210531225222.16992-1-smalin@marvell.com/
was designed in a modular way so that part 1 (nvme-tcp-offload) and 
part 2 (qed) are independent and part 3 (qedn) depends on both parts 1+2.

- Part 1 (RFC patch 1-8): NVMeTCP Offload ULP
  The nvme-tcp-offload patches, will be sent to 
  'linux-nvme@lists.infradead.org'.
  
- Part 2 (RFC patches 9-15): QED NVMeTCP Offload
  The qed infrastructure, will be sent to 'netdev@vger.kernel.org'.

Once part 1 and 2 are accepted:

- Part 3 (RFC patches 16-27): QEDN NVMeTCP Offload
  The qedn patches, will be sent to 'linux-nvme@lists.infradead.org'.
 
Marvell is fully committed to maintain, test, and address issues with 
the new nvme-tcp-offload layer.


Usage:
======
With the Marvell NVMeTCP offload design, the network-device (qede) and the 
offload-device (qedn) are paired on each port - Logically similar to the 
RDMA model.
The user will interact with the network-device in order to configure 
the ip/vlan. The NVMeTCP configuration is populated as part of the 
nvme connect command.

Example:
Assign IP to the net-device (from any existing Linux tool):

    ip addr add 100.100.0.101/24 dev p1p1

This IP will be used by both net-device (qede) and offload-device (qedn).

In order to connect from "sw" nvme-tcp through the net-device (qede):

    nvme connect -t tcp -s 4420 -a 100.100.0.100 -n testnqn

In order to connect from "offload" nvme-tcp through the offload-device (qedn):

    nvme connect -t tcp_offload -s 4420 -a 100.100.0.100 -n testnqn
	
An alternative approach, and as a future enhancement that will not impact this 
series will be to modify nvme-cli with a new flag that will determine 
if "-t tcp" should be the regular nvme-tcp (which will be the default) 
or nvme-tcp-offload.
Exmaple:
    nvme connect -t tcp -s 4420 -a 100.100.0.100 -n testnqn -[new flag]


Queue Initialization Design:
============================
The nvme-tcp-offload ULP module shall register with the existing 
nvmf_transport_ops (.name = "tcp_offload"), nvme_ctrl_ops and blk_mq_ops.
The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
with the following ops:
- claim_dev() - in order to resolve the route to the target according to
                the paired net_dev.
- create_queue() - in order to create offloaded nvme-tcp queue.

The nvme-tcp-offload ULP module shall manage all the controller level
functionalities, call claim_dev and based on the return values shall call
the relevant module create_queue in order to create the admin queue and
the IO queues.


IO-path Design:
===============
The nvme-tcp-offload shall work at the IO-level - the nvme-tcp-offload 
ULP module shall pass the request (the IO) to the nvme-tcp-offload vendor
driver and later, the nvme-tcp-offload vendor driver returns the request
completion (the IO completion).
No additional handling is needed in between; this design will reduce the
CPU utilization as we will describe below.

The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
with the following IO-path ops:
- send_req() - in order to pass the request to the handling of the
               offload driver that shall pass it to the vendor specific device.
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


nvme-tcp-offload Future work:
=============================
- NVMF_OPT_HOST_IFACE Support.


Changes since RFC v1:
=====================
- nvme-tcp-offload: Fix nvme_tcp_ofld_ops return values.
- nvme-tcp-offload: Remove NVMF_TRTYPE_TCP_OFFLOAD.
- nvme-tcp-offload: Add nvme_tcp_ofld_poll() implementation.
- nvme-tcp-offload: Fix nvme_tcp_ofld_queue_rq() to check map_sg() and 
  send_req() return values.

Changes since RFC v2:
=====================
- nvme-tcp-offload: Fixes in controller and queue level (patches 3-6).
- qedn: Add the Marvell's NVMeTCP HW offload vendor driver init and probe
  (patches 8-11).
  
Changes since RFC v3:
=====================
- nvme-tcp-offload: Add the full implementation of the nvme-tcp-offload layer 
  including the new ops: setup_ctrl(), release_ctrl(), commit_rqs() and new 
  flows (ASYNC and timeout).
- nvme-tcp-offload: Add device maximums: max_hw_sectors, max_segments.
- nvme-tcp-offload: layer design and optimization changes.

Changes since RFC v4:
=====================
(Many thanks to Hannes Reinecke for his feedback)
- nvme_tcp_offload: Add num_hw_vectors in order to limit the number of queues.
- nvme_tcp_offload: Add per device private_data.
- nvme_tcp_offload: Fix header digest, data digest and tos initialization.

Changes since RFC v5:
=====================
(Many thanks to Sagi Grimberg for his feedback)
- nvme-fabrics: Expose nvmf_check_required_opts() globally (as a new patch).
- nvme_tcp_offload: Remove io-queues BLK_MQ_F_BLOCKING.
- nvme_tcp_offload: Fix the nvme_tcp_ofld_stop_queue (drain_queue) flow.
- nvme_tcp_offload: Fix the nvme_tcp_ofld_free_queue (destroy_queue) flow.
- nvme_tcp_offload: Change rwsem to mutex.
- nvme_tcp_offload: remove redundant fields.
- nvme_tcp_offload: Remove the "new" from setup_ctrl().
- nvme_tcp_offload: Remove the init_req() and commit_rqs() ops.
- nvme_tcp_offload: Minor fixes in nvme_tcp_ofld_create_ctrl() ansd 
  nvme_tcp_ofld_free_queue().
- nvme_tcp_offload: Patch 8 (timeout and async) was squeashed into 
  patch 7 (io level).

Changes since RFC v6:
=====================
- No changes in nvme_tcp_offload (only in qedn).


Arie Gershberg (2):
  nvme-tcp-offload: Add controller level implementation
  nvme-tcp-offload: Add controller level error recovery implementation

Dean Balandin (3):
  nvme-tcp-offload: Add device scan implementation
  nvme-tcp-offload: Add queue level implementation
  nvme-tcp-offload: Add IO level implementation

Prabhakar Kushwaha (2):
  nvme-fabrics: Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS
    definitions
  nvme-fabrics: Expose nvmf_check_required_opts() globally

Shai Malin (1):
  nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP

 MAINTAINERS                     |    8 +
 drivers/nvme/host/Kconfig       |   17 +
 drivers/nvme/host/Makefile      |    3 +
 drivers/nvme/host/fabrics.c     |   12 +-
 drivers/nvme/host/fabrics.h     |    9 +
 drivers/nvme/host/tcp-offload.c | 1318 +++++++++++++++++++++++++++++++
 drivers/nvme/host/tcp-offload.h |  206 +++++
 7 files changed, 1564 insertions(+), 9 deletions(-)
 create mode 100644 drivers/nvme/host/tcp-offload.c
 create mode 100644 drivers/nvme/host/tcp-offload.h

-- 
2.22.0

