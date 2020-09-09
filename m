Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F64A2638F4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 00:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgIIW1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 18:27:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:30341 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIIW1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 18:27:48 -0400
IronPort-SDR: 7fUgIpdJUD4WteCMr37qqqCu3bHz9Fyfgz4zULox4iBvdrSoXEJkw5W+uwxlzF0RgSv93888lD
 4IvRMVPsmzQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="222627344"
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="222627344"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 15:27:48 -0700
IronPort-SDR: 6K0+/o7R/4iKljvM/O+yKqlY+7E/4zqqRd0JLcNHBd46Ju+YaUL9Q4gN8RkdOC/3isietJsINA
 NqOZXEQIo1fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,410,1592895600"; 
   d="scan'208";a="285017338"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga007.fm.intel.com with ESMTP; 09 Sep 2020 15:27:47 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [net-next v4 0/5] devlink flash update overwrite mask
Date:   Wed,  9 Sep 2020 15:26:48 -0700
Message-Id: <20200909222653.32994-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.218.ge27853923b9d.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces support for a new attribute to the flash update
command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.

This attribute is a bitfield which allows userspace to specify what set of
subfields to overwrite when performing a flash update for a device.

The intention is to support the ability to control the behavior of
overwriting the configuration and identifying fields in the Intel ice device
flash update process. This is necessary  as the firmware layout for the ice
device includes some settings and configuration within the same flash
section as the main firmware binary.

This series, and the accompanying iproute2 series, introduce support for the
attribute. Once applied, the overwrite support can be be invoked via
devlink:

  # overwrite settings
  devlink dev flash pci/0000:af:00.0 file firmware.bin overwrite settings

  # overwrite identifiers and settings
  devlink dev flash pci/0000:af:00.0 file firmware.bin overwrite settings overwrite identifiers

To aid in the safe addition of new parameters, first some refactoring is
done to the .flash_update function: its parameters are converted from a
series of function arguments into a structure. This makes it easier to add
the new parameter without changing the signature of the .flash_update
handler in the future. Additionally, a "supported_flash_update_params" field
is added to devlink_ops. This field is similar to the ethtool
"supported_coalesc_params" field. The devlink core will now check that the
DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT bit is set before forwarding the
component attribute. Similarly, the new overwrite attribute will also
require a supported bit.

Doing these refactors will aid in adding any other attributes in the future,
and creates a good pattern for other interfaces to use in the future. By
requiring drivers to opt-in, we reduce the risk of accidentally breaking
drivers when ever we add an additional parameter. We also reduce boiler
plate code in drivers which do not support the parameters.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Danielle Ratson <danieller@mellanox.com>

Changes since v3:
* split netdevsim changes to a new patch
* fixed a minor typo in the documentation
* sent iproute2 patches completely separately

Jacob Keller (5):
  devlink: check flash_update parameter support in net core
  devlink: convert flash_update to use params structure
  devlink: introduce flash update overwrite mask
  devlink: add support for overwrite mask to netdevsim
  ice: add support for flash update overwrite mask

 .../networking/devlink/devlink-flash.rst      | 28 +++++++++++++
 Documentation/networking/devlink/ice.rst      | 31 ++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 19 ++++-----
 .../net/ethernet/huawei/hinic/hinic_devlink.c |  8 +---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 34 ++++++++++-----
 .../net/ethernet/intel/ice/ice_fw_update.c    | 16 ++++++-
 .../net/ethernet/intel/ice/ice_fw_update.h    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  8 +---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 +--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  7 +---
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  9 ++--
 drivers/net/netdevsim/dev.c                   | 21 +++++++---
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         | 35 +++++++++++++++-
 include/uapi/linux/devlink.h                  | 25 +++++++++++
 net/core/devlink.c                            | 42 +++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          | 21 ++++++++++
 18 files changed, 247 insertions(+), 68 deletions(-)


base-commit: b599a5b9e16698424bced2429e935bee056dcf88
-- 
2.28.0.218.ge27853923b9d.dirty

