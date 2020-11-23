Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BA2C0C2E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgKWNvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:51:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:1467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgKWNvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:51:50 -0500
IronPort-SDR: Yy5UwHzCTponsSYuDwclmwPtFRGclmIlowsgNaoHrzbyzjcq8Fce0+mn6k65J4sErEhIyHVlFn
 6sIQui4g953g==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981395"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981395"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:51:47 -0800
IronPort-SDR: btlGRgNNLrNmYqFKECYXdkbgieNZHk1m52p6Nv5YfgtPC2+0PT2q2vAUMak6YmwM2fTabnhT9/
 XMso/5yaZGiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035449"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:51:45 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 00/18] net: iosm: PCIe Driver for Intel M.2 Modem
Date:   Mon, 23 Nov 2020 19:21:05 +0530
Message-Id: <20201123135123.48892-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IOSM (IPC over Shared Memory) driver is a PCIe host driver implemented
for linux or chrome platform for data exchange over PCIe interface between
Host platform & Intel M.2 Modem. The driver exposes interface conforming to the
MBIM protocol [1]. Any front end application ( eg: Modem Manager) could easily
manage the MBIM interface to enable data communication towards WWAN.

This is the driver we are still working on & below are the known things that
need to be addressed by driver.
1. Usage of completion() inside deinit()
2. Clean-up wrappers around hr_timer
3. Usage of net stats inside driver struct

Kindly request to review and give your suggestions.

Below is the technical detail:-
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

The driver exposes two types of ports, namely "wwanctrl", a char device node
which is used for MBIM control operation and "INMx",(x = 0,1,2..7) network
interfaces for IP data communication.
1) MBIM Control Interface:
This node exposes an interface between modem and application using char device
exposed by "IOSM" driver to establish and manage the MBIM data communication
with PCIe based Intel M.2 Modems.

It also support an IOCTL command, apart from read and write methods. The IOCTL
command, "IOCTL_WDM_MAX_COMMAND" could be used by applications to fetch the
Maximum Command buffer length supported by the driver which is restricted to
4096 bytes.

2) MBIM Data Interface:
The IOSM driver represents the MBIM data channel as a single root network
device of the "wwan0" type which is mapped as default IP session 0. Several IP
sessions(INMx) could be multiplexed over the single data channel using
sub devices of master wwanY devices. The driver models such IP sessions as
802.1q VLAN devices which are mapped to a unique VLAN ID.

M Chetan Kumar (18):
  net: iosm: entry point
  net: iosm: irq handling
  net: iosm: mmio scratchpad
  net: iosm: shared memory IPC interface
  net: iosm: shared memory I/O operations
  net: iosm: channel configuration
  net: iosm: char device for FW flash & coredump
  net: iosm: MBIM control device
  net: iosm: bottom half
  net: iosm: multiplex IP sessions
  net: iosm: encode or decode datagram
  net: iosm: power management
  net: iosm: shared memory protocol
  net: iosm: protocol operations
  net: iosm: uevent support
  net: iosm: net driver
  net: iosm: readme file
  net: iosm: infrastructure

 MAINTAINERS                                   |    7 +
 drivers/net/Kconfig                           |    1 +
 drivers/net/Makefile                          |    1 +
 drivers/net/wwan/Kconfig                      |   13 +
 drivers/net/wwan/Makefile                     |    5 +
 drivers/net/wwan/iosm/Kconfig                 |   10 +
 drivers/net/wwan/iosm/Makefile                |   27 +
 drivers/net/wwan/iosm/README                  |  126 +++
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c     |   87 ++
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h     |   57 +
 drivers/net/wwan/iosm/iosm_ipc_imem.c         | 1466 +++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.h         |  606 ++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c     |  779 +++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h     |  102 ++
 drivers/net/wwan/iosm/iosm_ipc_irq.c          |   95 ++
 drivers/net/wwan/iosm/iosm_ipc_irq.h          |   35 +
 drivers/net/wwan/iosm/iosm_ipc_mbim.c         |  205 ++++
 drivers/net/wwan/iosm/iosm_ipc_mbim.h         |   24 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c         |  222 ++++
 drivers/net/wwan/iosm/iosm_ipc_mmio.h         |  192 ++++
 drivers/net/wwan/iosm/iosm_ipc_mux.c          |  455 ++++++++
 drivers/net/wwan/iosm/iosm_ipc_mux.h          |  344 ++++++
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c    |  902 +++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h    |  194 ++++
 drivers/net/wwan/iosm/iosm_ipc_pcie.c         |  494 +++++++++
 drivers/net/wwan/iosm/iosm_ipc_pcie.h         |  205 ++++
 drivers/net/wwan/iosm/iosm_ipc_pm.c           |  334 ++++++
 drivers/net/wwan/iosm/iosm_ipc_pm.h           |  216 ++++
 drivers/net/wwan/iosm/iosm_ipc_protocol.c     |  287 +++++
 drivers/net/wwan/iosm/iosm_ipc_protocol.h     |  219 ++++
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c |  563 ++++++++++
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h |  358 ++++++
 drivers/net/wwan/iosm/iosm_ipc_sio.c          |  188 ++++
 drivers/net/wwan/iosm/iosm_ipc_sio.h          |   72 ++
 drivers/net/wwan/iosm/iosm_ipc_task_queue.c   |  258 +++++
 drivers/net/wwan/iosm/iosm_ipc_task_queue.h   |   46 +
 drivers/net/wwan/iosm/iosm_ipc_uevent.c       |   47 +
 drivers/net/wwan/iosm/iosm_ipc_uevent.h       |   41 +
 drivers/net/wwan/iosm/iosm_ipc_wwan.c         |  674 ++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_wwan.h         |   72 ++
 40 files changed, 10029 insertions(+)
 create mode 100644 drivers/net/wwan/Kconfig
 create mode 100644 drivers/net/wwan/Makefile
 create mode 100644 drivers/net/wwan/iosm/Kconfig
 create mode 100644 drivers/net/wwan/iosm/Makefile
 create mode 100644 drivers/net/wwan/iosm/README
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mbim.h
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
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_sio.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_sio.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.h

-- 
2.12.3

