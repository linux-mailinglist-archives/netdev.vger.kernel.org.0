Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B1E3A5858
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 14:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFMMwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 08:52:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:31517 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhFMMwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 08:52:39 -0400
IronPort-SDR: 3ob981kT0RUGGfugcxzfsX4eC/WJr41X5ELYAFfhXSF3XJMRQbKniI7epCFqdlfHX5C64Y3Om6
 ofANfwyroy2g==
X-IronPort-AV: E=McAfee;i="6200,9189,10013"; a="193029486"
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="193029486"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2021 05:50:36 -0700
IronPort-SDR: LKTytCiVWRjipUoLarzGTIE2WdtNqIrY/v0o2TFSYJM889ODvPtaX8rqaDWxUdRcfHHOFz8UYl
 uMkofZKSpM7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,271,1616482800"; 
   d="scan'208";a="449612913"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga008.jf.intel.com with ESMTP; 13 Jun 2021 05:50:34 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V5 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
Date:   Sun, 13 Jun 2021 18:20:07 +0530
Message-Id: <20210613125023.18945-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IOSM (IPC over Shared Memory) driver is a PCIe host driver implemented
for linux or chrome platform for data exchange over PCIe interface between
Host platform & Intel M.2 Modem. The driver exposes interface conforming to
the MBIM protocol. Any front end application ( eg: Modem Manager) could
easily manage the MBIM interface to enable data communication towards WWAN.

Intel M.2 modem uses 2 BAR regions. The first region is dedicated to Doorbell
register for IRQs and the second region is used as scratchpad area for book
keeping modem execution stage details along with host system shared memory
region context details. The upper edge of the driver exposes the control and
data channels for user space application interaction. At lower edge these data
and control channels are associated to pipes. The pipes are lowest level
interfaces used over PCIe as a logical channel for message exchange. A single
channel maps to UL and DL pipe and are initialized on device open.

On UL path, driver copies application sent data to SKBs associate it with
transfer descriptor and puts it on to ring buffer for DMA transfer. Once
information has been updated in shared memory region, host gives a Doorbell
to modem to perform DMA and modem uses MSI to communicate back to host.
For receiving data in DL path, SKBs are pre-allocated during pipe open and
transfer descriptors are given to modem for DMA transfer.

The driver exposes two types of ports, namely "wwan0mbim0", a char device node
which is used for MBIM control operation and "wwan0-x",(x = 0,1,2..7) network
interfaces for IP data communication.
1) MBIM Control Interface:
This node exposes an interface between modem and application using char device
exposed by "IOSM" driver to establish and manage the MBIM data communication
with PCIe based Intel M.2 Modems.

2) MBIM Data Interface:
The IOSM driver exposes IP link interface "wwan0-x" of type "wwan" for IP traffic.
Iproute network utility is used for creating "wwan0-x" network interface and for
associating it with MBIM IP session. The Driver supports upto 8 IP sessions for
simultaneous IP communication.


This applies on top of WWAN core rtnetlink series posted here:
https://lore.kernel.org/netdev/1623486057-13075-1-git-send-email-loic.poulain@linaro.org/

Also driver has been compiled and tested on top of netdev net-next tree.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

Changes since v4:
* PATCH4:
  * Use WWAN_PORT_UNKNOWN instead of WWAN_PORT_MAX.
* PATCH6:
  * Use WWAN_PORT_UNKNOWN instead of WWAN_PORT_MAX.
* PATCH15:
  * Fix kernel-doc warning.
* PATCH16:
  * Update mbim port name in doc to wwan0mbim0.

Changes since v3:
  * IOSM Driver adaptation to wwan core rtnet_link.

* PATCH1:
  * Clean-up rtnet_link changes.
* PATCH15:
  * Adapt to wwan subsystem rtnet_link ops.
  * Fix stats and RCU bugs in RX.
* PATCH16:
  * Adapt to wwan subsystem rtnet_link framework.

Changes since v2:
  * WWAN port adaptation.
  * Removed inline keyword in .c files.
  * Aligned ipc_ prefix for function name to be consistent across files.

* PATCH1:
  * Removed Module Author define.
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH2:
  * Removed inline keyword in .c file.
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH4:
  * WWAN port adaptation.
  * Removed inline keyword in .c file.
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH5:
  * WWAN port adaptation.
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH6:
  * WWAN port adaptation.
* PATCH7:
  * Renamed file to iosm_ipc_port.c
  * WWAN port adaptation for AT & MBIM protocol communication.
* PATCH9:
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH10:
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH11:
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH13:
  * Endianness type correction for transfer descriptor structure.
* PATCH15:
  * Clean-up DSS channel implementation.
  * Aligned ipc_ prefix for function name to be consistent across file.
* PATCH16:
  * Clean-up wwan Kconfig & Makefile (Changes available as part of
    wwan subsystem).
  * Removed NET dependency key word from iosm Kconfig.
  * Removed IOCTL section from documentation.

Changes since v1:
  * Removed Ethernet header & VLAN tag handling from wwan net driver.
  * Implement rtnet_link interface for IP traffic handling.
  * Strip off Modem FW flashing & CD collection code changes.
  * Moved driver documentation to RsT file.
  * Change copyright year.

* PATCH1:
  * Implement module_init() & exit() callbacks for rtnl_link.
  * Documentation correction for function signature.
  * Fix coverity warnings.
* PATCH2:
  * Streamline multiple returns using goto.
* PATCH3:
  * Removed space around the : for the bitfields.
  * Return proper error code instead of returning -1.
* PATCH4:
  * Clean-up vlan tag ids & removed FW flashing logic.
  * Function return type correction.
  * Return proper error code instead of returning -1.
* PATCH5:
  * Change vlan_id to ip link if_id & document correction.
  * Define new enums for IP & DSS session mapping.
  * Return proper error code instead of returning -1.
  * Clean-up vlan tag id & removed FW flashing logic.
* PATCH6:
  * Return proper error code instead of returning -1.
  * Define IPC channels in serial order.
* PATCH7:
  * Renamed iosm_sio struct to iosm_cdev.
  * Added memory barriers around atomic operations.
* PATCH8:
  * Moved task queue struct to header file.
  * Streamline multiple returns using goto.
* PATCH9:
  * Endianness type correction for Host-Device protocol structure.
  * Removed space around the : for the bitfields.
  * Change session from dynamic to static.
  * Streamline multiple returns using goto.
* PATCH10:
  * Endianness type correction for Host-Device protocol structure.
  * Function signature documentation correction.
  * Streamline multiple returns using goto.
  * Removed vlan tag id & replace it with ip link interface id.
* PATCH11:
  * Removed space around the : for the bitfields.
  * Moved pm module under static allocation.
  * Added memory barriers around atomic operations.
* PATCH12:
  * Endianness type correction for Host-Device protocol structure.
  * Function signature documentation correction.
  * Streamline multiple returns using goto.
* PATCH13:
  * Endianness type correction for Host-Device protocol structure.
  * Function signature documentation correction.
  * Streamline multiple returns using goto.
* PATCH14:
  * Removed no related header file inclusion.
* PATCH15:
  * Removed Ethernet header & VLAN tag handling from wwan net driver.
  * Implement rtnet_link interface for IP traffic handling.
* PATCH16:
  * Moved driver documentation to RsT file.
  * Modified if_link.h file to support link type iosm.

--
M Chetan Kumar (16):
  net: iosm: entry point
  net: iosm: irq handling
  net: iosm: mmio scratchpad
  net: iosm: shared memory IPC interface
  net: iosm: shared memory I/O operations
  net: iosm: channel configuration
  net: iosm: wwan port control device
  net: iosm: bottom half
  net: iosm: multiplex IP sessions
  net: iosm: encode or decode datagram
  net: iosm: power management
  net: iosm: shared memory protocol
  net: iosm: protocol operations
  net: iosm: uevent support
  net: iosm: net driver
  net: iosm: infrastructure

 .../networking/device_drivers/index.rst       |    1 +
 .../networking/device_drivers/wwan/index.rst  |   18 +
 .../networking/device_drivers/wwan/iosm.rst   |   96 ++
 MAINTAINERS                                   |    7 +
 drivers/net/wwan/Kconfig                      |   12 +
 drivers/net/wwan/Makefile                     |    1 +
 drivers/net/wwan/iosm/Makefile                |   26 +
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c     |   88 ++
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h     |   59 +
 drivers/net/wwan/iosm/iosm_ipc_imem.c         | 1363 +++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.h         |  579 +++++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c     |  346 +++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h     |   98 ++
 drivers/net/wwan/iosm/iosm_ipc_irq.c          |   90 ++
 drivers/net/wwan/iosm/iosm_ipc_irq.h          |   33 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c         |  223 +++
 drivers/net/wwan/iosm/iosm_ipc_mmio.h         |  193 +++
 drivers/net/wwan/iosm/iosm_ipc_mux.c          |  455 ++++++
 drivers/net/wwan/iosm/iosm_ipc_mux.h          |  343 +++++
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c    |  910 +++++++++++
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h    |  193 +++
 drivers/net/wwan/iosm/iosm_ipc_pcie.c         |  579 +++++++
 drivers/net/wwan/iosm/iosm_ipc_pcie.h         |  209 +++
 drivers/net/wwan/iosm/iosm_ipc_pm.c           |  333 ++++
 drivers/net/wwan/iosm/iosm_ipc_pm.h           |  207 +++
 drivers/net/wwan/iosm/iosm_ipc_port.c         |   85 +
 drivers/net/wwan/iosm/iosm_ipc_port.h         |   50 +
 drivers/net/wwan/iosm/iosm_ipc_protocol.c     |  283 ++++
 drivers/net/wwan/iosm/iosm_ipc_protocol.h     |  237 +++
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c |  552 +++++++
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h |  444 ++++++
 drivers/net/wwan/iosm/iosm_ipc_task_queue.c   |  202 +++
 drivers/net/wwan/iosm/iosm_ipc_task_queue.h   |   97 ++
 drivers/net/wwan/iosm/iosm_ipc_uevent.c       |   44 +
 drivers/net/wwan/iosm/iosm_ipc_uevent.h       |   41 +
 drivers/net/wwan/iosm/iosm_ipc_wwan.c         |  351 +++++
 drivers/net/wwan/iosm/iosm_ipc_wwan.h         |   55 +
 37 files changed, 8903 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/index.rst
 create mode 100644 Documentation/networking/device_drivers/wwan/iosm.rst
 create mode 100644 drivers/net/wwan/iosm/Makefile
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mmio.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mmio.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pm.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pm.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_port.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_port.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.h

-- 
2.25.1

