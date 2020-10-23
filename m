Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E64296B6E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460828AbgJWIvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:51:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:3681 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460809AbgJWIvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 04:51:33 -0400
IronPort-SDR: SBu8VFUwrjfVCnbIH4qcZzEVgl240wmoQTdvLwK/1LHblayoGzWQI/wBDxbKx+oXqQXwxJAOLS
 dsSQEGGpA0Ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="165055343"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="165055343"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 01:51:23 -0700
IronPort-SDR: ITN+aGUIW2EVSTVKvOM48cwwJmkNgnDak9ms1HVqLuSbPBHxvYUg2Hr7+wikSnMBGIup7Ux+SS
 Bb4Cf+0Hgq2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="523436275"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2020 01:51:20 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        yilun.xu@intel.com, hao.wu@intel.com
Subject: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether Group driver
Date:   Fri, 23 Oct 2020 16:45:40 +0800
Message-Id: <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the document for DFL Ether Group driver.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 .../networking/device_drivers/ethernet/index.rst   |   1 +
 .../ethernet/intel/dfl-eth-group.rst               | 102 +++++++++++++++++++++
 2 files changed, 103 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index cbb75a18..eb7c443 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -26,6 +26,7 @@ Contents:
    freescale/gianfar
    google/gve
    huawei/hinic
+   intel/dfl-eth-group
    intel/e100
    intel/e1000
    intel/e1000e
diff --git a/Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst b/Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst
new file mode 100644
index 0000000..525807e
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/intel/dfl-eth-group.rst
@@ -0,0 +1,102 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+=======================================================================
+DFL device driver for Ether Group private feature on Intel(R) PAC N3000
+=======================================================================
+
+This is the driver for Ether Group private feature on Intel(R)
+PAC (Programmable Acceleration Card) N3000.
+
+The Intel(R) PAC N3000 is a FPGA based SmartNIC platform for multi-workload
+networking application acceleration. A simple diagram below to for the board:
+
+                     +----------------------------------------+
+                     |                  FPGA                  |
++----+   +-------+   +-----------+  +----------+  +-----------+   +----------+
+|QSFP|---|retimer|---|Line Side  |--|User logic|--|Host Side  |---|XL710     |
++----+   +-------+   |Ether Group|  |          |  |Ether Group|   |Ethernet  |
+                     |(PHY + MAC)|  |wiring &  |  |(MAC + PHY)|   |Controller|
+                     +-----------+  |offloading|  +-----------+   +----------+
+                     |              +----------+              |
+                     |                                        |
+                     +----------------------------------------+
+
+The FPGA is composed of FPGA Interface Module (FIM) and Accelerated Function
+Unit (AFU). The FIM implements the basic functionalities for FPGA access,
+management and reprograming, while the AFU is the FPGA reprogramable region for
+users.
+
+The Line Side & Host Side Ether Groups are soft IP blocks embedded in FIM. They
+are internally wire connected to AFU and communicate with AFU with MAC packets.
+The user logic is developed by the FPGA users and re-programmed to AFU,
+providing the user defined wire connections between line side & host side data
+interfaces, as well as the MAC layer offloading.
+
+There are 2 types of interfaces for the Ether Groups:
+
+1. The data interfaces connects the Ether Groups and the AFU, host has no
+ability to control the data stream . So the FPGA is like a pipe between the
+host ethernet controller and the retimer chip.
+
+2. The management interfaces connects the Ether Groups to the host, so host
+could access the Ether Group registers for configuration and statistics
+reading.
+
+The Intel(R) PAC N3000 could be programmed to various configurations (with
+different link numbers and speeds, e.g. 8x10G, 4x25G ...). It is done by
+programing different variants of the Ether Group IP blocks, and doing
+corresponding configuration to the retimer chips.
+
+The DFL Ether Group driver registers netdev for each line side link. Users
+could use standard commands (ethtool, ip, ifconfig) for configuration and
+link state/statistics reading. For host side links, they are always connected
+to the host ethernet controller, so they should always have same features as
+the host ethernet controller. There is no need to register netdevs for them.
+The driver just enables these links on probe.
+
+The retimer chips are managed by onboard BMC (Board Management Controller)
+firmware, host driver is not capable to access them directly. So it is mostly
+like an external fixed PHY. However the link states detected by the retimer
+chips can not be propagated to the Ether Groups for hardware limitation, in
+order to manage the link state, a PHY driver (intel-m10-bmc-retimer) is
+introduced to query the BMC for the retimer's link state. The Ether Group
+driver would connect to the PHY devices and get the link states. The
+intel-m10-bmc-retimer driver creates a peseudo MDIO bus for each board, so
+that the Ether Group driver could find the PHY devices by their peseudo PHY
+addresses.
+
+
+2. Features supported
+=====================
+
+Data Path
+---------
+Since the driver can't control the data stream, the Ether Group driver
+doesn't implement the valid tx/rx functions. Any transmit attempt on these
+links from host will be dropped, and no data could be received to host from
+these links. Users should operate on the netdev of host ethernet controller
+for networking data traffic.
+
+
+Speed/Duplex
+------------
+The Ether Group doesn't support auto-negotiation. The link speed is fixed to
+10G, 25G or 40G full duplex according to which Ether Group IP is programmed.
+
+Statistics
+----------
+The Ether Group IP has the statistics counters for ethernet traffic and errors.
+The user can obtain these MAC-level statistics using "ethtool -S" option.
+
+MTU
+---
+The Ether Group IP is capable of detecting oversized packets. It will not drop
+the packet but pass it up and increment the tx/rx oversize counters. The MTU
+could be changed via ip or ifconfig commands.
+
+Flow Control
+------------
+Ethernet Flow Control (IEEE 802.3x) can be configured with ethtool to enable
+transmitting pause frames. Receiving pause request from outside to Ether Group
+MAC is not supported. The flow control auto-negotiation is not supported. The
+user can enable or disable Tx Flow Control using "ethtool -A eth? tx <on|off>"
-- 
2.7.4

