Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD80BF6FF
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfIZQp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:45:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:46257 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727597AbfIZQpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 12:45:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 09:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="219465175"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2019 09:45:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [RFC 19/20] RDMA/irdma: Add Kconfig and Makefile
Date:   Thu, 26 Sep 2019 09:45:18 -0700
Message-Id: <20190926164519.10471-20-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add Kconfig and Makefile to build irdma driver

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/Kconfig           |  1 +
 drivers/infiniband/hw/Makefile       |  1 +
 drivers/infiniband/hw/irdma/Kconfig  | 11 +++++++++++
 drivers/infiniband/hw/irdma/Makefile | 28 ++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 85e103b147cc..ffd9d2bbd745 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -86,6 +86,7 @@ source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/efa/Kconfig"
 source "drivers/infiniband/hw/i40iw/Kconfig"
+source "drivers/infiniband/hw/irdma/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 433fca59febd..d61d690ec0d4 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_INFINIBAND_EFA)		+= efa/
 obj-$(CONFIG_INFINIBAND_I40IW)		+= i40iw/
+obj-$(CONFIG_INFINIBAND_IRDMA)		+= irdma/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
new file mode 100644
index 000000000000..652f5f978ce2
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -0,0 +1,11 @@
+config INFINIBAND_IRDMA
+       tristate "Intel(R) Ethernet Connection RDMA Driver"
+       depends on INET && (I40E || ICE)
+       depends on IPV6 || !IPV6
+       depends on PCI
+       select GENERIC_ALLOCATOR
+       ---help---
+       This is an Ethernet RDMA driver that supports E810 (iWARP/RoCE)
+       and X722 (iWARP) network devices.
+       To compile this driver as a module, choose M here. The module
+       will be called irdma.
diff --git a/drivers/infiniband/hw/irdma/Makefile b/drivers/infiniband/hw/irdma/Makefile
new file mode 100644
index 000000000000..160fafe4ff0c
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Makefile
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2019, Intel Corporation.
+
+#
+# Makefile for the Intel(R) Ethernet Connection RDMA Linux Driver
+#
+
+obj-$(CONFIG_INFINIBAND_IRDMA) += irdma.o
+
+irdma-objs := cm.o        \
+              ctrl.o      \
+              hmc.o       \
+              hw.o        \
+              i40iw_hw.o  \
+              i40iw_if.o  \
+              icrdma_hw.o \
+              irdma_if.o  \
+              main.o      \
+              pble.o      \
+              puda.o      \
+              trace.o     \
+              uda.o       \
+              uk.o        \
+              utils.o     \
+              verbs.o     \
+              ws.o        \
+
+CFLAGS_trace.o = -I$(src)
-- 
2.21.0

