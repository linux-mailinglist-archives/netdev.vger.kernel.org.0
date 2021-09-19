Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95073410CA8
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhISRaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:30:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:46256 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhISRaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:30:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10112"; a="223065107"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="223065107"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2021 10:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="612241074"
Received: from ccgwwan-adlp2.iind.intel.com ([10.224.174.127])
  by fmsmga001.fm.intel.com with ESMTP; 19 Sep 2021 10:28:42 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 net-next 5/6] net: wwan: iosm: devlink fw flashing & cd collection documentation
Date:   Sun, 19 Sep 2021 22:58:18 +0530
Message-Id: <20210919172818.26326-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documents devlink params, fw update & cd collection commands
and its usage.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
v2: devlink documentation.
---
 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/iosm.rst  | 182 +++++++++++++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 Documentation/networking/devlink/iosm.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 45b5f8b341df..19ffd561cf4f 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -47,3 +47,4 @@ parameters, info versions, and other features it supports.
    ti-cpsw-switch
    am65-nuss-cpsw-switch
    prestera
+   iosm
diff --git a/Documentation/networking/devlink/iosm.rst b/Documentation/networking/devlink/iosm.rst
new file mode 100644
index 000000000000..b0407319a3ef
--- /dev/null
+++ b/Documentation/networking/devlink/iosm.rst
@@ -0,0 +1,182 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+iosm devlink support
+====================
+
+This document describes the devlink features implemented by the ``iosm``
+device driver.
+
+Parameters
+==========
+
+The ``iosm`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``erase_full_flash``
+     - u8
+     - runtime
+     - erase_full_flash parameter is used to check if full erase is required for
+       the device during firmware flashing.
+       If set, Full nand erase command will be sent to the device. By default,
+       only conditional erase support is enabled.
+   * - ``download_region``
+     - u8
+     - runtime
+     - download_region parameter is used to identify if we are flashing the
+       loadmap/region file during the firmware flashing.
+   * - ``address``
+     - u32
+     - runtime
+     - address parameter is used to send the address information of the
+       loadmap/region file which is required during the firmware flashing
+       process. Each region file has be flashed to its respective flash address.
+   * - ``region_count``
+     - u8
+     - runtime
+     - region_count parameter is used to inform the driver on how many total
+       loadmap/region files are present in modem firmware image that has to be
+       flashed.
+
+
+Flash Update
+============
+
+The ``iosm`` driver implements support for flash update using the
+``devlink-flash`` interface.
+
+It supports updating the device flash using a combined flash image which contains
+the Bootloader images and other modem software images.
+
+The driver uses DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT to identify type of
+firmware image that need to be flashed as requested by user space application.
+Supported firmware image types.
+
+.. list-table:: Firmware Image types
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``PSI RAM``
+      - Primary Signed Image
+    * - ``EBL``
+      - External Bootloader
+    * - ``FLS``
+      - Modem Software Image
+
+PSI RAM and EBL are the RAM images which are injected to the device when the
+device is in BOOT ROM stage. Once this is successful, the actual modem firmware
+image is flashed to the device. The modem software image contains multiple files
+each having one secure bin file and at least one Loadmap/Region file. For flashing
+these files, appropriate commands are sent to the modem device along with the
+data required for flashing. The data like region count and address of each region
+has to be passed to the driver using the devlink param command.
+
+If the device has to be fully erased before firmware flashing, user application
+need to set the erase_full_flash parameter using devlink param command.
+By default, conditional erase feature is supported.
+
+Flash Commands:
+===============
+1) When modem is in Boot ROM stage, user can use below command to inject PSI RAM
+image using devlink flash command.
+
+$ devlink dev flash pci/0000:02:00.0 file <PSI_RAM_File_name> component PSI
+
+2) If user want to do a full erase, below command need to be issued to set the
+erase full flash param (To be set only if full erase required).
+
+$ devlink dev param set pci/0000:02:00.0 name erase_full_flash value true cmode runtime
+
+3) Inject EBL after the modem is in PSI stage.
+$ devlink dev flash pci/0000:02:00.0 file <EBL_File_name> component EBL
+
+4) Once EBL is injected successfully, then the actual firmware flashing takes
+place. Below is the sequence of commands used for each of the firmware images.
+
+a) Flash secure bin file.
+$ devlink dev flash pci/0000:02:00.0 file <Secure_bin_file_name> component FLS
+
+b) Flashing the Loadmap/Region file
+$ devlink dev param set pci/0000:02:00.0 name region_count value 1 cmode runtime
+
+$ devlink dev param set pci/0000:02:00.0 name download_region value true cmode runtime
+
+$ devlink dev param set pci/0000:02:00.0 name address value <Nand_address> cmode runtime
+
+$ devlink dev flash pci/0000:02:00.0 file <Load_map_file_name> component FLS
+
+Regions
+=======
+
+The ``iosm`` driver supports dumping the coredump logs.
+
+In case a firmware encounters an exception, a snapshot will be taken by the
+driver. Following regions are accessed for device internal data.
+
+.. list-table:: Regions implemented
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``report.json``
+      - The summary of exception details logged as part of this region.
+    * - ``coredump.fcd``
+      - This region contains the details related to the exception occurred in the
+        device (RAM dump).
+    * - ``cdd.log``
+      - This region contains the logs related to the modem CDD driver.
+    * - ``eeprom.bin``
+      - This region contains the eeprom logs.
+    * - ``bootcore_trace.bin``
+      -  This region contains the current instance of bootloader logs.
+    * - ``bootcore_prev_trace.bin``
+      - This region contains the previous instance of bootloader logs.
+
+
+Region commands
+===============
+
+$ devlink region show
+
+$ devlink region new pci/0000:02:00.0/report.json
+
+$ devlink region dump pci/0000:02:00.0/report.json snapshot 0
+
+$ devlink region del pci/0000:02:00.0/report.json snapshot 0
+
+$ devlink region new pci/0000:02:00.0/coredump.fcd
+
+$ devlink region dump pci/0000:02:00.0/coredump.fcd snapshot 1
+
+$ devlink region del pci/0000:02:00.0/coredump.fcd snapshot 1
+
+$ devlink region new pci/0000:02:00.0/cdd.log
+
+$ devlink region dump pci/0000:02:00.0/cdd.log snapshot 2
+
+$ devlink region del pci/0000:02:00.0/cdd.log snapshot 2
+
+$ devlink region new pci/0000:02:00.0/eeprom.bin
+
+$ devlink region dump pci/0000:02:00.0/eeprom.bin snapshot 3
+
+$ devlink region del pci/0000:02:00.0/eeprom.bin snapshot 3
+
+$ devlink region new pci/0000:02:00.0/bootcore_trace.bin
+
+$ devlink region dump pci/0000:02:00.0/bootcore_trace.bin snapshot 4
+
+$ devlink region del pci/0000:02:00.0/bootcore_trace.bin snapshot 4
+
+$ devlink region new pci/0000:02:00.0/bootcore_prev_trace.bin
+
+$ devlink region dump pci/0000:02:00.0/bootcore_prev_trace.bin snapshot 5
+
+$ devlink region del pci/0000:02:00.0/bootcore_prev_trace.bin snapshot 5
-- 
2.25.1

