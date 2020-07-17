Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3559B224331
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGQSfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:35:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:34689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgGQSfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:35:45 -0400
IronPort-SDR: ab4s/CWnVGyHJ299t3G/1+i2JlRiKDRwfrACYcP5dyv93B5IF7g6LeSRAeYU+9BTZZMZyPYrBb
 YNna2rCCcr2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="129736656"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="129736656"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 11:35:45 -0700
IronPort-SDR: XhhcANsKPpyhJ8lOplshwQx7JB/kupzYMJd9PiqoIlk1lPXu5mZypbP7Go21rbn7LXRsG+2ekQ
 NoCYRHG58r5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="486542495"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 11:35:44 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next v2 0/6] introduce PLDM firmware update library
Date:   Fri, 17 Jul 2020 11:35:35 -0700
Message-Id: <20200717183541.797878-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
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
Additionally, it includes a final patch which introduces a new attribute to
the devlink flash command.

Because the PLDM file format is a standard and not something that is
specific to the Intel hardware, I opted to place this update library in
lib/pldmfw. I should note that while I tried to make the library generic, it
does not attempt to mimic the complete "Update Agent" as defined in the
standard. This is mostly due to the fact that the actual interfaces exposed
to software for the ice hardware would not allow this.

This series is currently based on top of Jeff Kirsher's dev-queue, as it
relies on some cleanup of the device capabilities code that was recently
published. For non-Intel drivers, this tree matches net-next. Once this
series has left RFC status, I will be submitting it via net-next directly.

The Intel Wired LAN dev-queue can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue.git/log/?h=dev-queue

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
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Danielle Ratson <danieller@mellanox.com>

Cudzilo, Szymon T (1):
  ice: Add AdminQ commands for FW update

Jacek Naczyk (1):
  ice: Add support for unified NVM update flow capability

Jacob Keller (4):
  ice: add flags indicating pending update of firmware module
  Add pldmfw library for PLDM firmware update
  ice: implement device flash update via devlink
  devlink: add overwrite mode to flash update

 Documentation/driver-api/index.rst            |   1 +
 .../driver-api/pldmfw/driver-ops.rst          |  56 ++
 .../driver-api/pldmfw/file-format.rst         | 203 ++++
 Documentation/driver-api/pldmfw/index.rst     |  72 ++
 .../networking/devlink/devlink-flash.rst      |  31 +
 Documentation/networking/devlink/ice.rst      |  27 +
 MAINTAINERS                                   |   7 +
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   7 +-
 .../net/ethernet/huawei/hinic/hinic_devlink.c |   3 +
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   9 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  83 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  21 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  56 ++
 .../net/ethernet/intel/ice/ice_fw_update.c    | 805 ++++++++++++++++
 .../net/ethernet/intel/ice/ice_fw_update.h    |  12 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 154 +++
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 186 ++++
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  16 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  12 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |   6 +-
 drivers/net/netdevsim/dev.c                   |   1 +
 include/linux/pldmfw.h                        | 165 ++++
 include/net/devlink.h                         |   1 +
 include/uapi/linux/devlink.h                  |  16 +
 lib/Kconfig                                   |   4 +
 lib/Makefile                                  |   3 +
 lib/pldmfw/Makefile                           |   2 +
 lib/pldmfw/pldmfw.c                           | 879 ++++++++++++++++++
 lib/pldmfw/pldmfw_private.h                   | 238 +++++
 net/core/devlink.c                            |  16 +-
 37 files changed, 3101 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/driver-api/pldmfw/driver-ops.rst
 create mode 100644 Documentation/driver-api/pldmfw/file-format.rst
 create mode 100644 Documentation/driver-api/pldmfw/index.rst
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fw_update.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fw_update.h
 create mode 100644 include/linux/pldmfw.h
 create mode 100644 lib/pldmfw/Makefile
 create mode 100644 lib/pldmfw/pldmfw.c
 create mode 100644 lib/pldmfw/pldmfw_private.h

-- 
2.27.0.353.gb9a2d1a0207f

