Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA85136363
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgAIWqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbgAIWqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926816"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:38 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 03/17] devlink: convert devlink-health.txt to rst format
Date:   Thu,  9 Jan 2020 14:46:11 -0800
Message-Id: <20200109224625.1470433-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the devlink-health documentation to use the newer
ReStructuredText format.

Note that it's unclear what OOB stood for, and it has been left as-is
without a proper first-use expansion of the acronym.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-health.rst     | 114 ++++++++++++++++++
 .../networking/devlink/devlink-health.txt     |  86 -------------
 Documentation/networking/devlink/index.rst    |   1 +
 3 files changed, 115 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-health.rst
 delete mode 100644 Documentation/networking/devlink/devlink-health.txt

diff --git a/Documentation/networking/devlink/devlink-health.rst b/Documentation/networking/devlink/devlink-health.rst
new file mode 100644
index 000000000000..0c99b11f05f9
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-health.rst
@@ -0,0 +1,114 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Health
+==============
+
+Background
+==========
+
+The ``devlink`` health mechanism is targeted for Real Time Alerting, in
+order to know when something bad happened to a PCI device.
+
+  * Provide alert debug information.
+  * Self healing.
+  * If problem needs vendor support, provide a way to gather all needed
+    debugging information.
+
+Overview
+========
+
+The main idea is to unify and centralize driver health reports in the
+generic ``devlink`` instance and allow the user to set different
+attributes of the health reporting and recovery procedures.
+
+The ``devlink`` health reporter:
+Device driver creates a "health reporter" per each error/health type.
+Error/Health type can be a known/generic (eg pci error, fw error, rx/tx error)
+or unknown (driver specific).
+For each registered health reporter a driver can issue error/health reports
+asynchronously. All health reports handling is done by ``devlink``.
+Device driver can provide specific callbacks for each "health reporter", e.g.:
+
+  * Recovery procedures
+  * Diagnostics procedures
+  * Object dump procedures
+  * OOB initial parameters
+
+Different parts of the driver can register different types of health reporters
+with different handlers.
+
+Actions
+=======
+
+Once an error is reported, devlink health will perform the following actions:
+
+  * A log is being send to the kernel trace events buffer
+  * Health status and statistics are being updated for the reporter instance
+  * Object dump is being taken and saved at the reporter instance (as long as
+    there is no other dump which is already stored)
+  * Auto recovery attempt is being done. Depends on:
+    - Auto-recovery configuration
+    - Grace period vs. time passed since last recover
+
+User Interface
+==============
+
+User can access/change each reporter's parameters and driver specific callbacks
+via ``devlink``, e.g per error type (per health reporter):
+
+  * Configure reporter's generic parameters (like: disable/enable auto recovery)
+  * Invoke recovery procedure
+  * Run diagnostics
+  * Object dump
+
+.. list-table:: List of devlink health interfaces
+   :widths: 10 90
+
+   * - Name
+     - Description
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_GET``
+     - Retrieves status and configuration info per DEV and reporter.
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_SET``
+     - Allows reporter-related configuration setting.
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_RECOVER``
+     - Triggers a reporter's recovery procedure.
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE``
+     - Retrieves diagnostics data from a reporter on a device.
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET``
+     - Retrieves the last stored dump. Devlink health
+       saves a single dump. If an dump is not already stored by the devlink
+       for this reporter, devlink generates a new dump.
+       dump output is defined by the reporter.
+   * - ``DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR``
+     - Clears the last saved dump file for the specified reporter.
+
+The following diagram provides a general overview of ``devlink-health``::
+
+                                                   netlink
+                                          +--------------------------+
+                                          |                          |
+                                          |            +             |
+                                          |            |             |
+                                          +--------------------------+
+                                                       |request for ops
+                                                       |(diagnose,
+     mlx5_core                             devlink     |recover,
+                                                       |dump)
+    +--------+                            +--------------------------+
+    |        |                            |    reporter|             |
+    |        |                            |  +---------v----------+  |
+    |        |   ops execution            |  |                    |  |
+    |     <----------------------------------+                    |  |
+    |        |                            |  |                    |  |
+    |        |                            |  + ^------------------+  |
+    |        |                            |    | request for ops     |
+    |        |                            |    | (recover, dump)     |
+    |        |                            |    |                     |
+    |        |                            |  +-+------------------+  |
+    |        |     health report          |  | health handler     |  |
+    |        +------------------------------->                    |  |
+    |        |                            |  +--------------------+  |
+    |        |     health reporter create |                          |
+    |        +---------------------------->                          |
+    +--------+                            +--------------------------+
diff --git a/Documentation/networking/devlink/devlink-health.txt b/Documentation/networking/devlink/devlink-health.txt
deleted file mode 100644
index 1db3fbea0831..000000000000
--- a/Documentation/networking/devlink/devlink-health.txt
+++ /dev/null
@@ -1,86 +0,0 @@
-The health mechanism is targeted for Real Time Alerting, in order to know when
-something bad had happened to a PCI device
-- Provide alert debug information
-- Self healing
-- If problem needs vendor support, provide a way to gather all needed debugging
-  information.
-
-The main idea is to unify and centralize driver health reports in the
-generic devlink instance and allow the user to set different
-attributes of the health reporting and recovery procedures.
-
-The devlink health reporter:
-Device driver creates a "health reporter" per each error/health type.
-Error/Health type can be a known/generic (eg pci error, fw error, rx/tx error)
-or unknown (driver specific).
-For each registered health reporter a driver can issue error/health reports
-asynchronously. All health reports handling is done by devlink.
-Device driver can provide specific callbacks for each "health reporter", e.g.
- - Recovery procedures
- - Diagnostics and object dump procedures
- - OOB initial parameters
-Different parts of the driver can register different types of health reporters
-with different handlers.
-
-Once an error is reported, devlink health will do the following actions:
-  * A log is being send to the kernel trace events buffer
-  * Health status and statistics are being updated for the reporter instance
-  * Object dump is being taken and saved at the reporter instance (as long as
-    there is no other dump which is already stored)
-  * Auto recovery attempt is being done. Depends on:
-    - Auto-recovery configuration
-    - Grace period vs. time passed since last recover
-
-The user interface:
-User can access/change each reporter's parameters and driver specific callbacks
-via devlink, e.g per error type (per health reporter)
- - Configure reporter's generic parameters (like: disable/enable auto recovery)
- - Invoke recovery procedure
- - Run diagnostics
- - Object dump
-
-The devlink health interface (via netlink):
-DEVLINK_CMD_HEALTH_REPORTER_GET
-  Retrieves status and configuration info per DEV and reporter.
-DEVLINK_CMD_HEALTH_REPORTER_SET
-  Allows reporter-related configuration setting.
-DEVLINK_CMD_HEALTH_REPORTER_RECOVER
-  Triggers a reporter's recovery procedure.
-DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE
-  Retrieves diagnostics data from a reporter on a device.
-DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET
-  Retrieves the last stored dump. Devlink health
-  saves a single dump. If an dump is not already stored by the devlink
-  for this reporter, devlink generates a new dump.
-  dump output is defined by the reporter.
-DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR
-  Clears the last saved dump file for the specified reporter.
-
-
-                                               netlink
-                                      +--------------------------+
-                                      |                          |
-                                      |            +             |
-                                      |            |             |
-                                      +--------------------------+
-                                                   |request for ops
-                                                   |(diagnose,
- mlx5_core                             devlink     |recover,
-                                                   |dump)
-+--------+                            +--------------------------+
-|        |                            |    reporter|             |
-|        |                            |  +---------v----------+  |
-|        |   ops execution            |  |                    |  |
-|     <----------------------------------+                    |  |
-|        |                            |  |                    |  |
-|        |                            |  + ^------------------+  |
-|        |                            |    | request for ops     |
-|        |                            |    | (recover, dump)     |
-|        |                            |    |                     |
-|        |                            |  +-+------------------+  |
-|        |     health report          |  | health handler     |  |
-|        +------------------------------->                    |  |
-|        |                            |  +--------------------+  |
-|        |     health reporter create |                          |
-|        +---------------------------->                          |
-+--------+                            +--------------------------+
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 1252c2a1b680..71d9d0e859eb 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -9,6 +9,7 @@ Contents:
 .. toctree::
    :maxdepth: 1
 
+   devlink-health
    devlink-info-versions
    devlink-trap
    devlink-trap-netdevsim
-- 
2.25.0.rc1

