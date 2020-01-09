Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2EF136370
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgAIWrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:47:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729265AbgAIWqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926866"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:48 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 12/17] devlink: add a file documenting devlink regions
Date:   Thu,  9 Jan 2020 14:46:20 -0800
Message-Id: <20200109224625.1470433-13-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also document the regions created by the mlx4 driver. This is currently
the only in-tree driver that creates devlink region snapshots.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
---
 .../networking/devlink/devlink-region.rst     | 54 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  1 +
 Documentation/networking/devlink/mlx4.rst     | 13 +++++
 3 files changed, 68 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-region.rst

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
new file mode 100644
index 000000000000..efa11b9a20da
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -0,0 +1,54 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Region
+==============
+
+``devlink`` regions enable access to driver defined address regions using
+devlink.
+
+Each device can create and register its own supported address regions. The
+region can then be accessed via the devlink region interface.
+
+Region snapshots are collected by the driver, and can be accessed via read
+or dump commands. This allows future analysis on the created snapshots.
+
+The major benefit to creating a region is to provide access to internal
+address regions that are otherwise inaccessible to the user. They can be
+used to provide an additional way to debug complex error states.
+
+example usage
+-------------
+
+.. code:: shell
+
+    $ devlink region help
+    $ devlink region show [ DEV/REGION ]
+    $ devlink region del DEV/REGION snapshot SNAPSHOT_ID
+    $ devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]
+    $ devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ]
+            address ADDRESS length length
+
+    # Show all of the exposed regions with region sizes:
+    $ devlink region show
+    pci/0000:00:05.0/cr-space: size 1048576 snapshot [1 2]
+    pci/0000:00:05.0/fw-health: size 64 snapshot [1 2]
+
+    # Delete a snapshot using:
+    $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
+
+    # Dump a snapshot:
+    $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
+    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
+    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
+
+    # Read a specific part of a snapshot:
+    $ devlink region read pci/0000:00:05.0/fw-health snapshot 1 address 0
+            length 16
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
+
+As regions are likely very device or driver specific, no generic regions are
+defined. See the driver-specific documentation files for information on the
+specific regions a driver supports.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 2007e257fd8a..3d351beedb0a 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -16,6 +16,7 @@ general.
    devlink-health
    devlink-info
    devlink-params
+   devlink-region
    devlink-trap
    devlink-trap-netdevsim
 
diff --git a/Documentation/networking/devlink/mlx4.rst b/Documentation/networking/devlink/mlx4.rst
index 4fa5c2b51c52..7b2d17ea5471 100644
--- a/Documentation/networking/devlink/mlx4.rst
+++ b/Documentation/networking/devlink/mlx4.rst
@@ -41,3 +41,16 @@ parameters.
      - Enable using the 4k UAR.
 
 The ``mlx4`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
+
+Regions
+=======
+
+The ``mlx4`` driver supports dumping the firmware PCI crspace and health
+buffer during a critical firmware issue.
+
+In case a firmware command times out, firmware getting stuck, or a non zero
+value on the catastrophic buffer, a snapshot will be taken by the driver.
+
+The ``cr-space`` region will contain the firmware PCI crspace contents. The
+``fw-health`` region will contain the device firmware's health buffer.
+Snapshots for both of these regions are taken on the same event triggers.
-- 
2.25.0.rc1

