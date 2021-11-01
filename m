Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF9744127F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 04:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhKAD7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 23:59:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:6371 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhKAD7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 23:59:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="229669202"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="229669202"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2021 20:57:05 -0700
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="467133018"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2021 20:57:04 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH v2 00/14] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
Date:   Sun, 31 Oct 2021 20:56:21 -0700
Message-Id: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution which
is based on MediaTek's T700 modem to provide WWAN connectivity.
The driver uses the WWAN framework infrastructure to create the following
control ports and network interfaces:
* /dev/wwan0mbim0 - Interface conforming to the MBIM protocol.
  Applications like libmbim [1] or Modem Manager [2] from v1.16 onwards
  with [3][4] can use it to enable data communication towards WWAN.
* /dev/wwan0at0 - Interface that supports AT commands.
* wwan0 - Primary network interface for IP traffic.

The main blocks in t7xx driver are:
* PCIe layer - Implements probe, removal, and power management callbacks.
* Port-proxy - Provides a common interface to interact with different types
  of ports such as WWAN ports.
* Modem control & status monitor - Implements the entry point for modem
  initialization, reset and exit, as well as exception handling.
* CLDMA (Control Layer DMA) - Manages the HW used by the port layer to send
  control messages to the modem using MediaTek's CCCI (Cross-Core
  Communication Interface) protocol.
* DPMAIF (Data Plane Modem AP Interface) - Controls the HW that provides
  uplink and downlink queues for the data path. The data exchange takes
  place using circular buffers to share data buffer addresses and metadata
  to describe the packets.
* MHCCIF (Modem Host Cross-Core Interface) - Provides interrupt channels
  for bidirectional event notification such as handshake, exception, PM and
  port enumeration.

The compilation of the t7xx driver is enabled by the CONFIG_MTK_T7XX config
option which depends on CONFIG_WWAN.
This driver was originally developed by MediaTek. Intel adapted t7xx to
the WWAN framework, optimized and refactored the driver source in close
collaboration with MediaTek. This will enable getting the t7xx driver on
Approved Vendor List for interested OEM's and ODM's productization plans
with Intel 5G 5000 M.2 solution.

List of contributors:
Amir Hanania <amir.hanania@intel.com>
Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Dinesh Sharma <dinesh.sharma@intel.com>
Eliot Lee <eliot.lee@intel.com>
Haijun Liu <haijun.liu@mediatek.com>
M Chetan Kumar <m.chetan.kumar@intel.com>
Mika Westerberg <mika.westerberg@linux.intel.com>
Moises Veleta <moises.veleta@intel.com>
Pierre-louis Bossart <pierre-louis.bossart@intel.com>
Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Ricardo Martinez <ricardo.martinez@linux.intel.com>
Muralidharan Sethuraman <muralidharan.sethuraman@intel.com>
Soumya Prakash Mishra <Soumya.Prakash.Mishra@intel.com>
Sreehari Kancharla <sreehari.kancharla@intel.com>
Suresh Nagaraj <suresh.nagaraj@intel.com>

[1] https://www.freedesktop.org/software/libmbim/
[2] https://www.freedesktop.org/software/ModemManager/
[3] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/582
[4] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/523

v2:
- Replace pdev->driver->name with dev_driver_string(&pdev->dev).
- Replace random_ether_addr() with eth_random_addr().
- Update kernel-doc comment for enum data_policy.
- Indicate the driver is 'Supported' instead of 'Maintained'.
- Fix the Signed-of-by and Co-developed-by tags in the patches.
- Added authors and contributors in the top comment of the src files.

Chandrashekar Devegowda (1):
  net: wwan: t7xx: Add AT and MBIM WWAN ports

Haijun Lio (11):
  net: wwan: t7xx: Add control DMA interface
  net: wwan: t7xx: Add core components
  net: wwan: t7xx: Add port proxy infrastructure
  net: wwan: t7xx: Add control port
  net: wwan: t7xx: Data path HW layer
  net: wwan: t7xx: Add data path interface
  net: wwan: t7xx: Add WWAN network interface
  net: wwan: t7xx: Introduce power management support
  net: wwan: t7xx: Runtime PM
  net: wwan: t7xx: Device deep sleep lock/unlock
  net: wwan: t7xx: Add debug and test ports

Ricardo Martinez (2):
  net: wwan: Add default MTU size
  net: wwan: t7xx: Add maintainers and documentation

 .../networking/device_drivers/wwan/index.rst  |    1 +
 .../networking/device_drivers/wwan/t7xx.rst   |  120 ++
 MAINTAINERS                                   |   11 +
 drivers/net/wwan/Kconfig                      |   14 +
 drivers/net/wwan/Makefile                     |    1 +
 drivers/net/wwan/t7xx/Makefile                |   24 +
 drivers/net/wwan/t7xx/t7xx_cldma.c            |  277 +++
 drivers/net/wwan/t7xx/t7xx_cldma.h            |  168 ++
 drivers/net/wwan/t7xx/t7xx_common.h           |   76 +
 drivers/net/wwan/t7xx/t7xx_dpmaif.c           | 1524 +++++++++++++++
 drivers/net/wwan/t7xx/t7xx_dpmaif.h           |  168 ++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c        | 1663 +++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h        |  156 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c       |  638 +++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h       |  279 +++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c    | 1562 ++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h    |  117 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c    |  842 +++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h    |   82 +
 drivers/net/wwan/t7xx/t7xx_mhccif.c           |  124 ++
 drivers/net/wwan/t7xx/t7xx_mhccif.h           |   35 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c        |  747 ++++++++
 drivers/net/wwan/t7xx/t7xx_modem_ops.h        |   92 +
 drivers/net/wwan/t7xx/t7xx_monitor.h          |  147 ++
 drivers/net/wwan/t7xx/t7xx_netdev.c           |  545 ++++++
 drivers/net/wwan/t7xx/t7xx_netdev.h           |   63 +
 drivers/net/wwan/t7xx/t7xx_pci.c              |  789 ++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h              |  121 ++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.c         |  277 +++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.h         |   36 +
 drivers/net/wwan/t7xx/t7xx_port.h             |  163 ++
 drivers/net/wwan/t7xx/t7xx_port_char.c        |  424 +++++
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c    |  150 ++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c       |  829 ++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h       |  102 +
 drivers/net/wwan/t7xx/t7xx_port_tty.c         |  191 ++
 drivers/net/wwan/t7xx/t7xx_port_wwan.c        |  281 +++
 drivers/net/wwan/t7xx/t7xx_reg.h              |  398 ++++
 drivers/net/wwan/t7xx/t7xx_skb_util.c         |  362 ++++
 drivers/net/wwan/t7xx/t7xx_skb_util.h         |  110 ++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c    |  627 +++++++
 drivers/net/wwan/t7xx/t7xx_tty_ops.c          |  205 ++
 drivers/net/wwan/t7xx/t7xx_tty_ops.h          |   44 +
 include/linux/wwan.h                          |    5 +
 44 files changed, 14590 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/t7xx.rst
 create mode 100644 drivers/net/wwan/t7xx/Makefile
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_cldma.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_common.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_dpmaif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_cldma.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_monitor.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_char.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_tty.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_skb_util.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_skb_util.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_tty_ops.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_tty_ops.h

-- 
2.17.1

