Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71471136364
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgAIWql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbgAIWqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926824"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:39 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 04/17] devlink: rename devlink-info-versions.rst and add a header
Date:   Thu,  9 Jan 2020 14:46:12 -0800
Message-Id: <20200109224625.1470433-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the devlink-info-versions.rst file to a plain devlink-info.rst
file. Add additional paragraphs explaining what devlink-info is for,
and the expectation that drivers use the generic names where plausible.

Note that drivers which use non-standard info version names ought to
document these in a driver-specific info-versions.rst file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../devlink/devlink-info-versions.rst         | 64 -------------
 .../networking/devlink/devlink-info.rst       | 94 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  2 +-
 3 files changed, 95 insertions(+), 65 deletions(-)
 delete mode 100644 Documentation/networking/devlink/devlink-info-versions.rst
 create mode 100644 Documentation/networking/devlink/devlink-info.rst

diff --git a/Documentation/networking/devlink/devlink-info-versions.rst b/Documentation/networking/devlink/devlink-info-versions.rst
deleted file mode 100644
index 4914f581b1fd..000000000000
--- a/Documentation/networking/devlink/devlink-info-versions.rst
+++ /dev/null
@@ -1,64 +0,0 @@
-.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-
-=====================
-Devlink info versions
-=====================
-
-board.id
-========
-
-Unique identifier of the board design.
-
-board.rev
-=========
-
-Board design revision.
-
-asic.id
-=======
-
-ASIC design identifier.
-
-asic.rev
-========
-
-ASIC design revision.
-
-board.manufacture
-=================
-
-An identifier of the company or the facility which produced the part.
-
-fw
-==
-
-Overall firmware version, often representing the collection of
-fw.mgmt, fw.app, etc.
-
-fw.mgmt
-=======
-
-Control unit firmware version. This firmware is responsible for house
-keeping tasks, PHY control etc. but not the packet-by-packet data path
-operation.
-
-fw.app
-======
-
-Data path microcode controlling high-speed packet processing.
-
-fw.undi
-=======
-
-UNDI software, may include the UEFI driver, firmware or both.
-
-fw.ncsi
-=======
-
-Version of the software responsible for supporting/handling the
-Network Controller Sideband Interface.
-
-fw.psid
-=======
-
-Unique identifier of the firmware parameter set.
diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
new file mode 100644
index 000000000000..0385f15028b1
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -0,0 +1,94 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+============
+Devlink Info
+============
+
+The ``devlink-info`` mechanism enables device drivers to report device
+information in a generic fashion. It is extensible, and enables exporting
+even device or driver specific information.
+
+devlink supports representing the following types of versions
+
+.. list-table:: List of version types
+   :widths: 5 95
+
+   * - Type
+     - Description
+   * - ``fixed``
+     - Represents fixed versions, which cannot change. For example,
+       component identifiers or the board version reported in the PCI VPD.
+   * - ``running``
+     - Represents the version of the currently running component. For
+       example the running version of firmware. These versions generally
+       only update after a reboot.
+   * - ``stored``
+     - Represents the version of a component as stored, such as after a
+       flash update. Stored values should update to reflect changes in the
+       flash even if a reboot has not yet occurred.
+
+Generic Versions
+================
+
+It is expected that drivers use the following generic names for exporting
+version information. Other information may be exposed using driver-specific
+names, but these should be documented in the driver-specific file.
+
+board.id
+--------
+
+Unique identifier of the board design.
+
+board.rev
+---------
+
+Board design revision.
+
+asic.id
+-------
+
+ASIC design identifier.
+
+asic.rev
+--------
+
+ASIC design revision.
+
+board.manufacture
+-----------------
+
+An identifier of the company or the facility which produced the part.
+
+fw
+--
+
+Overall firmware version, often representing the collection of
+fw.mgmt, fw.app, etc.
+
+fw.mgmt
+-------
+
+Control unit firmware version. This firmware is responsible for house
+keeping tasks, PHY control etc. but not the packet-by-packet data path
+operation.
+
+fw.app
+------
+
+Data path microcode controlling high-speed packet processing.
+
+fw.undi
+-------
+
+UNDI software, may include the UEFI driver, firmware or both.
+
+fw.ncsi
+-------
+
+Version of the software responsible for supporting/handling the
+Network Controller Sideband Interface.
+
+fw.psid
+-------
+
+Unique identifier of the firmware parameter set.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 71d9d0e859eb..687bb6e51fca 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -10,6 +10,6 @@ Contents:
    :maxdepth: 1
 
    devlink-health
-   devlink-info-versions
+   devlink-info
    devlink-trap
    devlink-trap-netdevsim
-- 
2.25.0.rc1

