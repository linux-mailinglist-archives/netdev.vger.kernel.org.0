Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CDF1FEABE
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgFRFOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:64356 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgFRFOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:06 -0400
IronPort-SDR: SpQPDLfRpGBCxaNnVZFJSo4Y7ieZMbLzuxj3MbYE7kLTt16YJ2wRhFte0I6HzNZin4LshHTa6O
 0lG7CWY/H+tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="141516119"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="141516119"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:53 -0700
IronPort-SDR: gkEv4xDpk2/OJwjTQJA3Tjysmk8quO80krTqXmm15jm4U3mbhhp+KAAbwDEFK0/b+KkPfgLNnA
 kOov2fz71Ung==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495629"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:53 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] iecm: Add iecm to the kernel build system
Date:   Wed, 17 Jun 2020 22:13:43 -0700
Message-Id: <20200618051344.516587-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

This introduces iecm as a module to the kernel, and adds
relevant documentation.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../networking/device_drivers/intel/iecm.rst  | 93 +++++++++++++++++++
 MAINTAINERS                                   |  2 +
 drivers/net/ethernet/intel/Kconfig            |  7 ++
 drivers/net/ethernet/intel/Makefile           |  1 +
 drivers/net/ethernet/intel/iecm/Makefile      | 19 ++++
 5 files changed, 122 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/intel/iecm.rst
 create mode 100644 drivers/net/ethernet/intel/iecm/Makefile

diff --git a/Documentation/networking/device_drivers/intel/iecm.rst b/Documentation/networking/device_drivers/intel/iecm.rst
new file mode 100644
index 000000000000..5634e3e65c74
--- /dev/null
+++ b/Documentation/networking/device_drivers/intel/iecm.rst
@@ -0,0 +1,93 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================
+Intel Ethernet Common Module
+========================
+
+The Intel Ethernet Common Module is meant to serve as an abstraction layer
+between device specific implementation details and common net device driver
+flows. This library provides several function hooks which allow a device driver
+to specify register addresses, control queue communications, and other device
+specific functionality.  Some functions are required to be implemented while
+others have a default implementation that is used when none is supplied by the
+device driver.  Doing this, a device driver can be written to take advantage
+of existing code while also giving the flexibility to implement device specific
+features.
+
+The common use case for this library is for a network device driver that wants
+specify its own device specific details but also leverage the more common
+code flows found in network device drivers.
+
+Sections in this document:
+	Entry Point
+	Exit Point
+	Register Operations API
+	Virtchnl Operations API
+
+Entry Point
+~~~~~~~~~~~
+The primary entry point to the library is the iecm_probe function.  Prior to
+calling this, device drivers must have allocated an iecm_adapter struct and
+initialized it with the required API functions.  The adapter struct, along with
+the pci_dev struct and the pci_device_id struct, is provided to iecm_probe
+which finalizes device initialization and prepares the device for open.
+
+The iecm_dev_ops struct within the iecm_adapter struct is the primary vehicle
+for passing information from device drivers to the common module.  A dependent
+module must define and assign a reg_ops_init function which will assign the
+respective function pointers to initialize register values (see iecm_reg_ops
+struct).  These are required to be provided by the dependent device driver as
+no suitable default can be assumed for register addresses.
+
+The vc_ops_init function pointer and the related iecm_virtchnl_ops struct are
+optional and should only be necessary for device drivers which use a different
+method/timing for communicating across a mailbox to the hardware.  Within iecm
+is a default interface provided in the case where one is not provided by the
+device driver.
+
+Exit Point
+~~~~~~~~~~
+When the device driver is being prepared to be removed through the pci_driver
+remove callback, it is required for the device driver to call iecm_remove with
+the pci_dev struct provided.  This is required to ensure all resources are
+properly freed and returned to the operating system.
+
+Register Operations API
+~~~~~~~~~~~~~~~~~~~~~~~
+iecm_reg_ops contains three different function pointers relating to initializing
+registers for the specific net device using the library.
+
+ctlq_reg_init relates specifically to setting up registers related to control
+queue/mailbox communications.  Registers that should be defined include: head,
+tail, len, bah, bal, len_mask, len_ena_mask, and head_mask.
+
+vportq_reg_init relates to setting up queue registers.  The tail registers to
+be assigned to the iecm_queue struct for each RX/TX queue.
+
+intr_reg_init relates to any registers needed to setup interrupts.  These
+include registers needed to enable the interrupt and change ITR settings.
+
+If the initialization function finds that one or more required function
+pointers were not provided, an error will be issued and the device will be
+inoperable.
+
+
+Virtchnl Operations API
+~~~~~~~~~~~~~~~~~~~~~~~
+The virtchnl is a conduit between driver and hardware that allows device
+drivers to send and receive control messages to/from hardware.  This is
+optional to be specified as there is a general interface that can be assumed
+when using this library.  However, if a device deviates in some way to
+communicate across the mailbox correctly, this interface is provided to allow
+that.
+
+If vc_ops_init is set in the dev_ops field of the iecm_adapter struct, then it
+is assumed the device driver is using providing it's own interface to do
+virtchnl communications.  While providing vc_ops_init is optional, if it is
+provided, it is required that the device driver provide function pointers for
+those functions in vc_ops, with exception for the enable_vport, disable_vport,
+and destroy_vport functions which may not be required for all devices.
+
+If the initialization function finds that vc_ops_init was defined but one or
+more required function pointers were not provided, an error will be issued and
+the device will be inoperable.
diff --git a/MAINTAINERS b/MAINTAINERS
index 301330e02bca..102ee1e4aef0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8654,6 +8654,7 @@ F:	Documentation/networking/device_drivers/intel/fm10k.rst
 F:	Documentation/networking/device_drivers/intel/i40e.rst
 F:	Documentation/networking/device_drivers/intel/iavf.rst
 F:	Documentation/networking/device_drivers/intel/ice.rst
+F:	Documentation/networking/device_drivers/intel/iecm.rst
 F:	Documentation/networking/device_drivers/intel/igb.rst
 F:	Documentation/networking/device_drivers/intel/igbvf.rst
 F:	Documentation/networking/device_drivers/intel/ixgb.rst
@@ -8662,6 +8663,7 @@ F:	Documentation/networking/device_drivers/intel/ixgbevf.rst
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
+F:	include/linux/net/intel/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 48a8f9aa1dd0..6dd985cbdb6d 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -342,4 +342,11 @@ config IGC
 	  To compile this driver as a module, choose M here. The module
 	  will be called igc.
 
+config IECM
+	tristate "Intel(R) Ethernet Common Module Support"
+	default n
+	depends on PCI
+	help
+	 To compile this driver as a module, choose M here. The module
+	 will be called iecm.  MSI-X interrupt support is required
 endif # NET_VENDOR_INTEL
diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
index 3075290063f6..c9eba9cc5087 100644
--- a/drivers/net/ethernet/intel/Makefile
+++ b/drivers/net/ethernet/intel/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_IXGB) += ixgb/
 obj-$(CONFIG_IAVF) += iavf/
 obj-$(CONFIG_FM10K) += fm10k/
 obj-$(CONFIG_ICE) += ice/
+obj-$(CONFIG_IECM) += iecm/
diff --git a/drivers/net/ethernet/intel/iecm/Makefile b/drivers/net/ethernet/intel/iecm/Makefile
new file mode 100644
index 000000000000..61c814013582
--- /dev/null
+++ b/drivers/net/ethernet/intel/iecm/Makefile
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright (C) 2020 Intel Corporation
+
+#
+# Makefile for the Intel(R) Ethernet Common Module
+#
+
+obj-$(CONFIG_IECM) += iecm.o
+
+iecm-y := \
+	iecm_lib.o \
+	iecm_virtchnl.o \
+	iecm_txrx.o \
+	iecm_singleq_txrx.o \
+	iecm_ethtool.o \
+	iecm_controlq.o \
+	iecm_osdep.o \
+	iecm_controlq_setup.o \
+	iecm_main.o
-- 
2.26.2

