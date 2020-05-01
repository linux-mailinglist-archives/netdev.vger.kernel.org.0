Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A741C1852
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgEAOq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgEAOpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:10 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA642499B;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=zye3w0+bBHDbYAfggdapQ1VOTj27wEtBgshSU5GQVG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xP3FawV1193TIdgfoaoQVg/t2Q7sTTo01O1wvnLNOurpYt0yYi6yHZqhpAlFEerMz
         WwiadHENSnW7CyXmfHu/x/MV5VLwmuSYfGodOPCuyHw95QJYC4E6tgB9rAHfjsLg3v
         sUaNnevlkbnUxJzYhF2B2t/vYqgFLnSxrxcx5c7k=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCeg-U7; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        netdev@vger.kernel.org
Subject: [PATCH 27/37] docs: networking: device drivers: convert neterion/s2io.txt to ReST
Date:   Fri,  1 May 2020 16:44:49 +0200
Message-Id: <bda8a022bee4e7aead15c32728aca47a35291c2e.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- comment out text-only TOC from html/pdf output;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |   1 +
 .../device_drivers/neterion/s2io.rst          | 196 ++++++++++++++++++
 .../device_drivers/neterion/s2io.txt          | 141 -------------
 MAINTAINERS                                   |   2 +-
 drivers/net/ethernet/neterion/Kconfig         |   2 +-
 5 files changed, 199 insertions(+), 143 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/neterion/s2io.rst
 delete mode 100644 Documentation/networking/device_drivers/neterion/s2io.txt

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 575f0043b03e..da1f8438d4ea 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -42,6 +42,7 @@ Contents:
    intel/ipw2100
    intel/ipw2200
    microsoft/netvsc
+   neterion/s2io
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/neterion/s2io.rst b/Documentation/networking/device_drivers/neterion/s2io.rst
new file mode 100644
index 000000000000..c5673ec4559b
--- /dev/null
+++ b/Documentation/networking/device_drivers/neterion/s2io.rst
@@ -0,0 +1,196 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================================
+Neterion's (Formerly S2io) Xframe I/II PCI-X 10GbE driver
+=========================================================
+
+Release notes for Neterion's (Formerly S2io) Xframe I/II PCI-X 10GbE driver.
+
+.. Contents
+  - 1.  Introduction
+  - 2.  Identifying the adapter/interface
+  - 3.  Features supported
+  - 4.  Command line parameters
+  - 5.  Performance suggestions
+  - 6.  Available Downloads
+
+
+1. Introduction
+===============
+This Linux driver supports Neterion's Xframe I PCI-X 1.0 and
+Xframe II PCI-X 2.0 adapters. It supports several features
+such as jumbo frames, MSI/MSI-X, checksum offloads, TSO, UFO and so on.
+See below for complete list of features.
+
+All features are supported for both IPv4 and IPv6.
+
+2. Identifying the adapter/interface
+====================================
+
+a. Insert the adapter(s) in your system.
+b. Build and load driver::
+
+	# insmod s2io.ko
+
+c. View log messages::
+
+	# dmesg | tail -40
+
+You will see messages similar to::
+
+	eth3: Neterion Xframe I 10GbE adapter (rev 3), Version 2.0.9.1, Intr type INTA
+	eth4: Neterion Xframe II 10GbE adapter (rev 2), Version 2.0.9.1, Intr type INTA
+	eth4: Device is on 64 bit 133MHz PCIX(M1) bus
+
+The above messages identify the adapter type(Xframe I/II), adapter revision,
+driver version, interface name(eth3, eth4), Interrupt type(INTA, MSI, MSI-X).
+In case of Xframe II, the PCI/PCI-X bus width and frequency are displayed
+as well.
+
+To associate an interface with a physical adapter use "ethtool -p <ethX>".
+The corresponding adapter's LED will blink multiple times.
+
+3. Features supported
+=====================
+a. Jumbo frames. Xframe I/II supports MTU up to 9600 bytes,
+   modifiable using ip command.
+
+b. Offloads. Supports checksum offload(TCP/UDP/IP) on transmit
+   and receive, TSO.
+
+c. Multi-buffer receive mode. Scattering of packet across multiple
+   buffers. Currently driver supports 2-buffer mode which yields
+   significant performance improvement on certain platforms(SGI Altix,
+   IBM xSeries).
+
+d. MSI/MSI-X. Can be enabled on platforms which support this feature
+   (IA64, Xeon) resulting in noticeable performance improvement(up to 7%
+   on certain platforms).
+
+e. Statistics. Comprehensive MAC-level and software statistics displayed
+   using "ethtool -S" option.
+
+f. Multi-FIFO/Ring. Supports up to 8 transmit queues and receive rings,
+   with multiple steering options.
+
+4. Command line parameters
+==========================
+
+a. tx_fifo_num
+	Number of transmit queues
+
+Valid range: 1-8
+
+Default: 1
+
+b. rx_ring_num
+	Number of receive rings
+
+Valid range: 1-8
+
+Default: 1
+
+c. tx_fifo_len
+	Size of each transmit queue
+
+Valid range: Total length of all queues should not exceed 8192
+
+Default: 4096
+
+d. rx_ring_sz
+	Size of each receive ring(in 4K blocks)
+
+Valid range: Limited by memory on system
+
+Default: 30
+
+e. intr_type
+	Specifies interrupt type. Possible values 0(INTA), 2(MSI-X)
+
+Valid values: 0, 2
+
+Default: 2
+
+5. Performance suggestions
+==========================
+
+General:
+
+a. Set MTU to maximum(9000 for switch setup, 9600 in back-to-back configuration)
+b. Set TCP windows size to optimal value.
+
+For instance, for MTU=1500 a value of 210K has been observed to result in
+good performance::
+
+	# sysctl -w net.ipv4.tcp_rmem="210000 210000 210000"
+	# sysctl -w net.ipv4.tcp_wmem="210000 210000 210000"
+
+For MTU=9000, TCP window size of 10 MB is recommended::
+
+	# sysctl -w net.ipv4.tcp_rmem="10000000 10000000 10000000"
+	# sysctl -w net.ipv4.tcp_wmem="10000000 10000000 10000000"
+
+Transmit performance:
+
+a. By default, the driver respects BIOS settings for PCI bus parameters.
+   However, you may want to experiment with PCI bus parameters
+   max-split-transactions(MOST) and MMRBC (use setpci command).
+
+   A MOST value of 2 has been found optimal for Opterons and 3 for Itanium.
+
+   It could be different for your hardware.
+
+   Set MMRBC to 4K**.
+
+   For example you can set
+
+   For opteron::
+
+	#setpci -d 17d5:* 62=1d
+
+   For Itanium::
+
+	#setpci -d 17d5:* 62=3d
+
+   For detailed description of the PCI registers, please see Xframe User Guide.
+
+b. Ensure Transmit Checksum offload is enabled. Use ethtool to set/verify this
+   parameter.
+
+c. Turn on TSO(using "ethtool -K")::
+
+	# ethtool -K <ethX> tso on
+
+Receive performance:
+
+a. By default, the driver respects BIOS settings for PCI bus parameters.
+   However, you may want to set PCI latency timer to 248::
+
+	#setpci -d 17d5:* LATENCY_TIMER=f8
+
+   For detailed description of the PCI registers, please see Xframe User Guide.
+
+b. Use 2-buffer mode. This results in large performance boost on
+   certain platforms(eg. SGI Altix, IBM xSeries).
+
+c. Ensure Receive Checksum offload is enabled. Use "ethtool -K ethX" command to
+   set/verify this option.
+
+d. Enable NAPI feature(in kernel configuration Device Drivers ---> Network
+   device support --->  Ethernet (10000 Mbit) ---> S2IO 10Gbe Xframe NIC) to
+   bring down CPU utilization.
+
+.. note::
+
+   For AMD opteron platforms with 8131 chipset, MMRBC=1 and MOST=1 are
+   recommended as safe parameters.
+
+For more information, please review the AMD8131 errata at
+http://vip.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/
+26310_AMD-8131_HyperTransport_PCI-X_Tunnel_Revision_Guide_rev_3_18.pdf
+
+6. Support
+==========
+
+For further support please contact either your 10GbE Xframe NIC vendor (IBM,
+HP, SGI etc.)
diff --git a/Documentation/networking/device_drivers/neterion/s2io.txt b/Documentation/networking/device_drivers/neterion/s2io.txt
deleted file mode 100644
index 0362a42f7cf4..000000000000
--- a/Documentation/networking/device_drivers/neterion/s2io.txt
+++ /dev/null
@@ -1,141 +0,0 @@
-Release notes for Neterion's (Formerly S2io) Xframe I/II PCI-X 10GbE driver.
-
-Contents
-=======
-- 1.  Introduction
-- 2.  Identifying the adapter/interface
-- 3.  Features supported
-- 4.  Command line parameters
-- 5.  Performance suggestions
-- 6.  Available Downloads 
-
-
-1.	Introduction:
-This Linux driver supports Neterion's Xframe I PCI-X 1.0 and
-Xframe II PCI-X 2.0 adapters. It supports several features 
-such as jumbo frames, MSI/MSI-X, checksum offloads, TSO, UFO and so on.
-See below for complete list of features.
-All features are supported for both IPv4 and IPv6.
-
-2.	Identifying the adapter/interface:
-a. Insert the adapter(s) in your system.
-b. Build and load driver 
-# insmod s2io.ko
-c. View log messages
-# dmesg | tail -40
-You will see messages similar to:
-eth3: Neterion Xframe I 10GbE adapter (rev 3), Version 2.0.9.1, Intr type INTA
-eth4: Neterion Xframe II 10GbE adapter (rev 2), Version 2.0.9.1, Intr type INTA
-eth4: Device is on 64 bit 133MHz PCIX(M1) bus
-
-The above messages identify the adapter type(Xframe I/II), adapter revision,
-driver version, interface name(eth3, eth4), Interrupt type(INTA, MSI, MSI-X).
-In case of Xframe II, the PCI/PCI-X bus width and frequency are displayed
-as well.
-
-To associate an interface with a physical adapter use "ethtool -p <ethX>".
-The corresponding adapter's LED will blink multiple times.
-
-3.	Features supported:
-a. Jumbo frames. Xframe I/II supports MTU up to 9600 bytes,
-modifiable using ip command.
-
-b. Offloads. Supports checksum offload(TCP/UDP/IP) on transmit
-and receive, TSO.
-
-c. Multi-buffer receive mode. Scattering of packet across multiple
-buffers. Currently driver supports 2-buffer mode which yields
-significant performance improvement on certain platforms(SGI Altix,
-IBM xSeries).
-
-d. MSI/MSI-X. Can be enabled on platforms which support this feature
-(IA64, Xeon) resulting in noticeable performance improvement(up to 7%
-on certain platforms).
-
-e. Statistics. Comprehensive MAC-level and software statistics displayed
-using "ethtool -S" option.
-
-f. Multi-FIFO/Ring. Supports up to 8 transmit queues and receive rings,
-with multiple steering options.
-
-4.  Command line parameters
-a. tx_fifo_num
-Number of transmit queues
-Valid range: 1-8
-Default: 1
-
-b. rx_ring_num
-Number of receive rings
-Valid range: 1-8
-Default: 1
-
-c. tx_fifo_len
-Size of each transmit queue
-Valid range: Total length of all queues should not exceed 8192
-Default: 4096
-
-d. rx_ring_sz 
-Size of each receive ring(in 4K blocks)
-Valid range: Limited by memory on system
-Default: 30 
-
-e. intr_type
-Specifies interrupt type. Possible values 0(INTA), 2(MSI-X)
-Valid values: 0, 2
-Default: 2
-
-5.  Performance suggestions
-General:
-a. Set MTU to maximum(9000 for switch setup, 9600 in back-to-back configuration)
-b. Set TCP windows size to optimal value. 
-For instance, for MTU=1500 a value of 210K has been observed to result in 
-good performance.
-# sysctl -w net.ipv4.tcp_rmem="210000 210000 210000"
-# sysctl -w net.ipv4.tcp_wmem="210000 210000 210000"
-For MTU=9000, TCP window size of 10 MB is recommended.
-# sysctl -w net.ipv4.tcp_rmem="10000000 10000000 10000000"
-# sysctl -w net.ipv4.tcp_wmem="10000000 10000000 10000000"
-
-Transmit performance:
-a. By default, the driver respects BIOS settings for PCI bus parameters. 
-However, you may want to experiment with PCI bus parameters 
-max-split-transactions(MOST) and MMRBC (use setpci command). 
-A MOST value of 2 has been found optimal for Opterons and 3 for Itanium.  
-It could be different for your hardware.  
-Set MMRBC to 4K**.
-
-For example you can set 
-For opteron
-#setpci -d 17d5:* 62=1d 
-For Itanium
-#setpci -d 17d5:* 62=3d 
-
-For detailed description of the PCI registers, please see Xframe User Guide.
-
-b. Ensure Transmit Checksum offload is enabled. Use ethtool to set/verify this 
-parameter.
-c. Turn on TSO(using "ethtool -K")
-# ethtool -K <ethX> tso on
-
-Receive performance:
-a. By default, the driver respects BIOS settings for PCI bus parameters. 
-However, you may want to set PCI latency timer to 248.
-#setpci -d 17d5:* LATENCY_TIMER=f8
-For detailed description of the PCI registers, please see Xframe User Guide.
-b. Use 2-buffer mode. This results in large performance boost on
-certain platforms(eg. SGI Altix, IBM xSeries).
-c. Ensure Receive Checksum offload is enabled. Use "ethtool -K ethX" command to 
-set/verify this option.
-d. Enable NAPI feature(in kernel configuration Device Drivers ---> Network 
-device support --->  Ethernet (10000 Mbit) ---> S2IO 10Gbe Xframe NIC) to 
-bring down CPU utilization.
-
-** For AMD opteron platforms with 8131 chipset, MMRBC=1 and MOST=1 are 
-recommended as safe parameters.
-For more information, please review the AMD8131 errata at
-http://vip.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/
-26310_AMD-8131_HyperTransport_PCI-X_Tunnel_Revision_Guide_rev_3_18.pdf
-
-6. Support
-For further support please contact either your 10GbE Xframe NIC vendor (IBM, 
-HP, SGI etc.)
diff --git a/MAINTAINERS b/MAINTAINERS
index ef6bd3be1bb5..122a684d522b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11691,7 +11691,7 @@ NETERION 10GbE DRIVERS (s2io/vxge)
 M:	Jon Mason <jdmason@kudzu.us>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/device_drivers/neterion/s2io.txt
+F:	Documentation/networking/device_drivers/neterion/s2io.rst
 F:	Documentation/networking/device_drivers/neterion/vxge.txt
 F:	drivers/net/ethernet/neterion/
 
diff --git a/drivers/net/ethernet/neterion/Kconfig b/drivers/net/ethernet/neterion/Kconfig
index 5e630f3a0189..c375ee08f6ea 100644
--- a/drivers/net/ethernet/neterion/Kconfig
+++ b/drivers/net/ethernet/neterion/Kconfig
@@ -27,7 +27,7 @@ config S2IO
 	  on its age.
 
 	  More specific information on configuring the driver is in
-	  <file:Documentation/networking/device_drivers/neterion/s2io.txt>.
+	  <file:Documentation/networking/device_drivers/neterion/s2io.rst>.
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called s2io.
-- 
2.25.4

