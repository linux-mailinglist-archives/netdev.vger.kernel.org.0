Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FB726EA23
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIRAq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:46:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:14361 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgIRAq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 20:46:29 -0400
IronPort-SDR: p8GEtUbXYmb+IonSHERIrHgVLxpTRtfsrCSLVz/irXQL5+pHQ+Sa1Ulgn1VeVzXkB0ZubI2mSn
 eJisNJDjrJWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147569973"
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="147569973"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 17:46:25 -0700
IronPort-SDR: IOiua5SGRL9EzmRXQC5mUG8TAj1RyY2yPrQEeImJmUoSPV6Llxg8xtnteVr3f7lvGwjPx5/UVa
 pZrp/oqhie4w==
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="scan'208";a="380728908"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 17:46:25 -0700
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
Subject: [net-next v6 0/5] devlink flash update overwrite mask
Date:   Thu, 17 Sep 2020 17:45:24 -0700
Message-Id: <20200918004529.533989-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Changes since v5
* Fix *all* of the BIT usage to use _BITUL() (thanks Jakub!)

Changes since v4
* Renamed nla_overwrite to nla_overwrite_mask at Jiri's suggestion
* Added "by this device" to the netlink error messages for unsupported
  attributes
* Removed use of BIT() in the uapi header
* Fixed the commit message for the netdevsim patch
* Picked up Jakub's reviewed tag.

Jacob Keller (5):
  devlink: check flash_update parameter support in net core
  devlink: convert flash_update to use params structure
  devlink: introduce flash update overwrite mask
  netdevsim: add support for flash_update overwrite mask
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

