Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DC946B0D3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhLGCvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:51:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:27266 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhLGCvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 21:51:41 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300860551"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="300860551"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:44 -0800
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="748524119"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:47:43 -0800
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
Subject: [PATCH net-next v3 00/12] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
Date:   Mon,  6 Dec 2021 19:46:59 -0700
Message-Id: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
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

v3:
- Avoid unneeded ping-pong changes between patches.
- Use t7xx_ prefix in functions.
- Use t7xx_ prefix in generic structs where mtk_ or ccci prefix was used.
- Update Authors/Contributors header.
- Remove skb pools used for control path.
- Remove skb pools used for RX data path.
- Do not use dedicated TX queue for ACK-only packets.
- Remove __packed attribute from GPD structs.
- Remove the infrastructure for test and debug ports.
- Use the skb control buffer to store metadata.
- Get the IP packet type from RX PIT.
- Merge variable declaration and simple assignments.
- Use preferred coding patterns.
- Remove global variables.
- Declare HW facing structure members as little endian.
- Rename goto tags to describe what is going to be done.
- Do not use variable length arrays.
- Remove unneeded blank lines source code and kdoc headers.
- Use C99 initialization format for port-proxy ports.
- Clean up comments.
- Review included headers.
- Better use of 100 column limit.
- Remove unneeded mb() in CLDMA.
- Remove unneeded spin locks and atomics.
- Handle read_poll_timeout error.
- Use dev_err_ratelimited() where required.
- Fix resource leak when requesting IRQs.
- Use generic DEFAULT_TX_QUEUE_LEN instead custom macro.
- Use ETH_DATA_LEN instead of defining WWAN_DEFAULT_MTU.
- Use sizeof() instead of defines when the size of structures is required.
- Remove unneeded code from netdev:
    No need to configure HW address length
    No need to implement .ndo_change_mtu
    Remove random address generation
- Code simplifications by using kernel provided functions and macros such as:
    module_pci_driver
    PTR_ERR_OR_ZERO
    for_each_set_bit
    pci_device_is_present
    skb_queue_purge
    list_prev_entry
    __ffs64

v2:
- Replace pdev->driver->name with dev_driver_string(&pdev->dev).
- Replace random_ether_addr() with eth_random_addr().
- Update kernel-doc comment for enum data_policy.
- Indicate the driver is 'Supported' instead of 'Maintained'.
- Fix the Signed-of-by and Co-developed-by tags in the patches.
- Added authors and contributors in the top comment of the src files.


Ricardo Martinez (12):
  net: wwan: t7xx: Add control DMA interface
  net: wwan: t7xx: Add core components
  net: wwan: t7xx: Add port proxy infrastructure
  net: wwan: t7xx: Add control port
  net: wwan: t7xx: Add AT and MBIM WWAN ports
  net: wwan: t7xx: Data path HW layer
  net: wwan: t7xx: Add data path interface
  net: wwan: t7xx: Add WWAN network interface
  net: wwan: t7xx: Introduce power management support
  net: wwan: t7xx: Runtime PM
  net: wwan: t7xx: Device deep sleep lock/unlock
  net: wwan: t7xx: Add maintainers and documentation

 .../networking/device_drivers/wwan/index.rst  |    1 +
 .../networking/device_drivers/wwan/t7xx.rst   |  120 ++
 MAINTAINERS                                   |   11 +
 drivers/net/wwan/Kconfig                      |   14 +
 drivers/net/wwan/Makefile                     |    1 +
 drivers/net/wwan/t7xx/Makefile                |   20 +
 drivers/net/wwan/t7xx/t7xx_cldma.c            |  290 ++++
 drivers/net/wwan/t7xx/t7xx_cldma.h            |  177 ++
 drivers/net/wwan/t7xx/t7xx_common.h           |   95 ++
 drivers/net/wwan/t7xx/t7xx_dpmaif.c           | 1424 ++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_dpmaif.h           |  146 ++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c        | 1471 +++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h        |  140 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c       |  577 +++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h       |  260 +++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c    | 1275 ++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h    |  115 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c    |  760 +++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h    |   89 +
 drivers/net/wwan/t7xx/t7xx_mhccif.c           |  118 ++
 drivers/net/wwan/t7xx/t7xx_mhccif.h           |   37 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c        |  714 ++++++++
 drivers/net/wwan/t7xx/t7xx_modem_ops.h        |   87 +
 drivers/net/wwan/t7xx/t7xx_netdev.c           |  433 +++++
 drivers/net/wwan/t7xx/t7xx_netdev.h           |   61 +
 drivers/net/wwan/t7xx/t7xx_pci.c              |  767 +++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h              |  123 ++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.c         |  277 ++++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.h         |   37 +
 drivers/net/wwan/t7xx/t7xx_port.h             |  153 ++
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c    |  161 ++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c       |  677 ++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h       |   83 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c        |  258 +++
 drivers/net/wwan/t7xx/t7xx_reg.h              |  379 +++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c    |  578 +++++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.h    |  127 ++
 37 files changed, 12056 insertions(+)
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
 create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_netdev.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_proxy.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_wwan.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.h

-- 
2.17.1

