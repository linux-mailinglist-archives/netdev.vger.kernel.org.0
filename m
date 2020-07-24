Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6434522BAF2
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgGXAWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:22:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:23101 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgGXAWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:22:20 -0400
IronPort-SDR: BSGUe0Nn6Hz8u6di0y91RiF58NzS9TmhyotaTAgKluNwL8gmeVJ276KMqwTZxYaMfnt8xyKRuf
 ROrr6cAgCydw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="215232502"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="215232502"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 17:22:18 -0700
IronPort-SDR: k0hJUNFp8YoZhTRkvvnJD8TYit/KhkYuX+Q04SjwUULHM7N6EPT2CaR80by2ShjXLmfN3W/XVn
 Jx/eK1W5o2Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="272441979"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jul 2020 17:22:18 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next v1 0/5] introduce PLDM firmware update library
Date:   Thu, 23 Jul 2020 17:21:58 -0700
Message-Id: <20200724002203.451621-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.rc1.139.gd6b33fda9dd1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series goal is to enable support for updating the ice hardware flash
using the devlink flash command.

The ice firmware update files are distributed using the file format
described by the "PLDM for Firmware Update" standard:

https://www.dmtf.org/documents/pmci/pldm-firmware-update-specification-100

Because this file format is standard, this series introduces a new library
that handles the generic logic for parsing the PLDM file header. The library
uses a design that is very similar to the Mellanox mlxfw module. That is, a
simple ops table is setup and device drivers instantiate an instance of the
pldmfw library with the device specific operations.

Doing so allows for each device to implement the low level behavior for how
to interact with its firmware.

This series includes the library and an implementation for the ice hardware.
I've removed all of the parameters, and the proposed changes to support
overwrite mode. I'll be working on the overwrite mask suggestion from Jakub
as a follow-up series.

Because the PLDM file format is a standard and not something that is
specific to the Intel hardware, I opted to place this update library in
lib/pldmfw. I should note that while I tried to make the library generic, it
does not attempt to mimic the complete "Update Agent" as defined in the
standard. This is mostly due to the fact that the actual interfaces exposed
to software for the ice hardware would not allow this.

This series depends on some work just recently and is based on top of the
patch series sent by Tony published at:

https://lore.kernel.org/netdev/20200723234720.1547308-1-anthony.l.nguyen@intel.com/T/#t

Changes since v2 RFC
* Removed overwrite mode patches, as this can become a follow up series with
  a separate discussion
* Fixed a minor bug in the pldm_timestamp structure not being packed.
* Dropped Cc for other driver maintainers, as this series no longer includes
  changes to the core flash update command.
* Re-ordered patches slightly.
Changes since v1 RFC
* Removed the "allow_downgrade_on_flash_update" parameter. Instead, the
  driver will always attempt to flash the device, even when firmware
  indicates that it would be a downgrade. A dev_warn is used to indicate
  when this occurs.
* Removed the "ignore_pending_flash_update". Instead, the driver will always
  check for and cancel any previous pending update. A devlink flash status
  message will be sent when this cancellation occurs.
* Removed the "reset_after_flash_update" parameter. This will instead be
  implemented as part of a devlink reset interface, work left for a future
  change.
* Replaced the "flash_update_preservation_level" parameter with a new
  "overwrite" mode attribute on the flash update command. For ice, this mode
  will select the preservation level. For all other drivers, I modified them
  to check that the mode is "OVERWRITE_NOTHING", and have Cc'd the
  maintainers to get their input.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>

Cudzilo, Szymon T (1):
  ice: Add AdminQ commands for FW update

Jacek Naczyk (1):
  ice: Add support for unified NVM update flow capability

Jacob Keller (3):
  Add pldmfw library for PLDM firmware update
  ice: add flags indicating pending update of firmware module
  ice: implement device flash update via devlink

 Documentation/driver-api/index.rst            |   1 +
 .../driver-api/pldmfw/driver-ops.rst          |  56 ++
 .../driver-api/pldmfw/file-format.rst         | 203 ++++
 Documentation/driver-api/pldmfw/index.rst     |  72 ++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   9 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  83 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  21 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  54 ++
 .../net/ethernet/intel/ice/ice_fw_update.c    | 773 +++++++++++++++
 .../net/ethernet/intel/ice/ice_fw_update.h    |  12 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 154 +++
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 186 ++++
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  16 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  12 +
 include/linux/pldmfw.h                        | 165 ++++
 lib/Kconfig                                   |   4 +
 lib/Makefile                                  |   3 +
 lib/pldmfw/Makefile                           |   2 +
 lib/pldmfw/pldmfw.c                           | 879 ++++++++++++++++++
 lib/pldmfw/pldmfw_private.h                   | 238 +++++
 24 files changed, 2953 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/driver-api/pldmfw/driver-ops.rst
 create mode 100644 Documentation/driver-api/pldmfw/file-format.rst
 create mode 100644 Documentation/driver-api/pldmfw/index.rst
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fw_update.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fw_update.h
 create mode 100644 include/linux/pldmfw.h
 create mode 100644 lib/pldmfw/Makefile
 create mode 100644 lib/pldmfw/pldmfw.c
 create mode 100644 lib/pldmfw/pldmfw_private.h


base-commit: 0d127fc31b70b1aa28f8bc3014c7e6d11a4dd1bc
-- 
2.28.0.rc1.139.gd6b33fda9dd1
