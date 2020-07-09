Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B098D21A9B8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgGIV06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:26:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:49958 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIV0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 17:26:54 -0400
IronPort-SDR: IVVB3Elq8icGsBP+zJNZnx+pkONM9YOMxIu6s8LKsS2QQtCZAd6ITMY/7YaF/9anMNEP93EOvn
 1/N5Gucj0FHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="147202444"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="147202444"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 14:26:54 -0700
IronPort-SDR: OFJbKccOVgepaBMkQL3RyN7jeLOlWeWV7fFUsIKBrb6k/kPSDSHuXbVq5Z5KUCYZ5Jw3j96Sp2
 mDb6G6cGrdyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="284293637"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga006.jf.intel.com with ESMTP; 09 Jul 2020 14:26:53 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 0/6] introduce PLDM firmware update library
Date:   Thu,  9 Jul 2020 14:26:46 -0700
Message-Id: <20200709212652.2785924-1-jacob.e.keller@intel.com>
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
In addition, it includes a following patch with additional device parameters
for controlling specific aspects of the update. I suspect that there is a
better way to handle these parameters overall. Perhaps extensions to
DEVLINK_CMD_FLASH_UPDATE? The main purpose of these parameters is to give
additional control over the update choices. Specifically, Intel has flash
update tools which provide similar functionality for other operating
systems. Without these controls, we would not be able to replicate this
functionality within Linux using the devlink interface.

Because the PLDM file format is a standard and not something that is
specific to the Intel hardware, I opted to place this update library in
lib/pldmfw. I should note that while I tried to make the library generic, it
does not attempt to mimic the complete "Update Agent" as defined in the
standard. This is mostly due to the fact that the actual interfaces exposed
to software for the ice hardware would not allow this.

This series is currently based on top of Jeff Kirsher's dev-queue, as it
relies on some cleanup of the device capabilities code that was recently
published.

https://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue.git/log/?h=dev-queue

Cudzilo, Szymon T (1):
  ice: Add AdminQ commands for FW update

Jacek Naczyk (1):
  ice: Add support for unified NVM update flow capability

Jacob Keller (4):
  ice: add flags indicating pending update of firmware module
  Add pldmfw library for PLDM firmware update
  ice: implement device flash update via devlink
  ice: implement devlink parameters to control flash update

 Documentation/driver-api/index.rst            |   1 +
 .../driver-api/pldmfw/driver-ops.rst          |  56 ++
 .../driver-api/pldmfw/file-format.rst         | 203 ++++
 Documentation/driver-api/pldmfw/index.rst     |  72 ++
 Documentation/networking/devlink/ice.rst      |  46 +
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  29 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  83 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  21 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 229 ++++-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 817 ++++++++++++++++
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
 25 files changed, 3237 insertions(+), 4 deletions(-)
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

