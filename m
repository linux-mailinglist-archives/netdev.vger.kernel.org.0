Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DDC48E1E9
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbiANBGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:06:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:27438 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235825AbiANBGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122413; x=1673658413;
  h=from:to:cc:subject:date:message-id;
  bh=1Tj0X2ijuj7VUI7qq9U+wUuMtkQsGv+i7Gt6u/lS3KE=;
  b=MniNUXPK6r3Sf86fy8elbArOUP3OM+tjbdx4MaVIXqMoHd45Cz+teJ9M
   GAiQPW41IOFFguWzdSBhZ3HW3pInUQXy9AUZz6fOz2OKrgYKprZo9MRcc
   QSCGm3+Y/oZva+hhL4aUrQs0k9abHE0CRhFzMuKmPCN+7tdBp0/dzP5+j
   S+n9Q7WzG4dwX+OomXpJNi3GmU+DvIgb1kSJZFlBY+w88WbJEgvyBcv/K
   QVTKfVqC8b0yyv89LtnP1/rM96MtIeTS+AZBlcvh6E0hIfriu8xEeEopA
   Kaa1QWhqzmeKP1Y96zVN/4yiOYH/d7mulKHHy/TOjHMy7CjNQVUfApx39
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="242970842"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="242970842"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014180"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:52 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v4 00/13] net: wwan: t7xx: PCIe driver for MediaTek M.2 modem
Date:   Thu, 13 Jan 2022 18:06:14 -0700
Message-Id: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
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

v4:
- Implement list_prev_entry_circular() and list_next_entry_circular() macros.
- Remove inline from all c files.
- Define ioread32_poll_timeout_atomic() helper macro.
- Fix return code for WWAN port tx op.
- Allow AT commands fragmentation same as MBIM commands.
- Introduce t7xx_common.h file in the first patch.
- Rename functions and variables as suggested in v3.
- Reduce code duplication by creating fsm_wait_for_event() helper function.
- Remove unneeded dev_err in t7xx_fsm_clr_event().
- Remove unused variable last_state from struct t7xx_fsm_ctl.
- Remove unused variable txq_select_times from struct dpmaif_ctrl.
- Replace ETXTBSY with EBUSY.
- Refactor t7xx_dpmaif_rx_buf_alloc() to remove an unneeded allocation.
- Fix potential leak at t7xx_dpmaif_rx_frag_alloc().
- Simplify return value handling at t7xx_dpmaif_rx_start().
- Add a helper to handle the common part of CCCI header initialization.
- Make sure interrupts are enabled during PM resume.
- Add a parameter to t7xx_fsm_append_cmd() to tell if it is in interrupt context.

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

Ricardo Martinez (13):
  list: Add list_next_entry_circular() and list_prev_entry_circular()
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
 drivers/net/wwan/t7xx/t7xx_cldma.c            |  282 ++++
 drivers/net/wwan/t7xx/t7xx_cldma.h            |  177 ++
 drivers/net/wwan/t7xx/t7xx_common.h           |   95 ++
 drivers/net/wwan/t7xx/t7xx_dpmaif.c           | 1372 ++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_dpmaif.h           |  146 ++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c        | 1439 +++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_cldma.h        |  139 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c       |  577 +++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h       |  252 +++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c    | 1251 ++++++++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h    |  115 ++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.c    |  754 +++++++++
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_tx.h    |   89 +
 drivers/net/wwan/t7xx/t7xx_mhccif.c           |  118 ++
 drivers/net/wwan/t7xx/t7xx_mhccif.h           |   37 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c        |  703 ++++++++
 drivers/net/wwan/t7xx/t7xx_modem_ops.h        |   87 +
 drivers/net/wwan/t7xx/t7xx_netdev.c           |  433 +++++
 drivers/net/wwan/t7xx/t7xx_netdev.h           |   61 +
 drivers/net/wwan/t7xx/t7xx_pci.c              |  767 +++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h              |  123 ++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.c         |  277 ++++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.h         |   37 +
 drivers/net/wwan/t7xx/t7xx_port.h             |  151 ++
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c    |  190 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c       |  642 ++++++++
 drivers/net/wwan/t7xx/t7xx_port_proxy.h       |   87 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c        |  225 +++
 drivers/net/wwan/t7xx/t7xx_reg.h              |  379 +++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c    |  548 +++++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.h    |  126 ++
 include/linux/list.h                          |   26 +
 38 files changed, 11872 insertions(+)
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

