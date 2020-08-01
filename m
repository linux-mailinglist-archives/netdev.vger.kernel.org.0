Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07F3234EE6
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgHAAWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:22:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:49844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgHAAWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 20:22:17 -0400
IronPort-SDR: ZuylfKqokOu+xcW+WURz/Z907sN2ht5ZZ5c8uzXTKbESZCdtCbvH8ZmZDViObeBL4k+AeAS5v6
 mItVqXxKR0tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="153106653"
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="153106653"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 17:22:14 -0700
IronPort-SDR: yuYqD8KPAhpmZIfNd/7e/KRXOn3IpXREl/zVqGn4adfYj4y9uipS6dC9NCzM33iQ4fcSSjynBE
 NXlI3+OHGZBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="435594760"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2020 17:22:14 -0700
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
Subject: [net-next v2 0/5] devlink flash update overwrite mask
Date:   Fri, 31 Jul 2020 17:21:54 -0700
Message-Id: <20200801002159.3300425-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b60
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces support for a new attribute to the flash update
command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK. This attribute is a u32
value that represents a bitmask of which subsections of flash to
request/allow overwriting when performing a flash update.

The intent is to support the ability to control overwriting options of the
ice hardware flash update. Specifically, the ice flash components combine
settings and identifiers within the firmware flash section. This series
introduces the two subsections, "identifiers" and "settings". With the new
attribute, users can request to overwrite these subsections when performing
a flash update. By existing convention, it is assumed that flash program
binaries are always updated (and thus overwritten), and no mask bit is
provided to control this.

First, the .flash_update command is modified to take a parameter structure.
A new supported_flash_update_params field is also provided to allow drivers
to opt-in to the parameters they support rather than opting out. This is
similar to the recently added supported_coalesc_params field in ethtool.

Following this, the new overwrite mask parameter is added, along with the
associated supported bit. The netdevsim driver is updated to support this
parameter, along with a few self tests to help verify the interface is
working as expected.

Finally, the ice driver is modified to support the parameter, converting it
into the firmware preservation level request.

Patches to enable support for specifying the overwrite sections are also
provided for iproute2-next. This is done primarily in order to enable the
tests for netdevsim. As discussed previously on the list, the primary
motivations for the overwrite mode are two-fold.

First, supporting update with a customized image that has pre-configured
settings and identifiers, used with overwrite of both settings and
identifiers. This enables an initial update to overwrite default values and
customize the adapter with a new serial ID and fresh settings. Second, it
may sometimes be useful to allow overwriting of settings when updating in
order to guarantee that the settings in the flash section are "known good".

Changes since v1
* Added supported_flash_update_params field, removing some boilerplate in
  each driver. This also makes it easier to add new parameters in the future
  without fear of accidentally breaking an existing driver, due to opt-in
  behavior instead of forcing drivers to opt-out.
* Split the ice changes to a separate patch.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Danielle Ratson <danieller@mellanox.com>

Jacob Keller (3):
  devlink: convert flash_update to use params structure
  devlink: introduce flash update overwrite mask
  ice: add support for flash update overwrite mask

 .../networking/devlink/devlink-flash.rst      | 29 ++++++++++++++
 Documentation/networking/devlink/ice.rst      | 31 +++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 19 ++++-----
 .../net/ethernet/huawei/hinic/hinic_devlink.c |  8 +---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 33 +++++++++++-----
 .../net/ethernet/intel/ice/ice_fw_update.c    | 16 +++++++-
 .../net/ethernet/intel/ice/ice_fw_update.h    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  8 +---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 +--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  7 +---
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  9 ++---
 drivers/net/netdevsim/dev.c                   | 21 +++++++---
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         | 35 ++++++++++++++++-
 include/uapi/linux/devlink.h                  | 24 ++++++++++++
 net/core/devlink.c                            | 39 +++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          | 21 ++++++++++
 18 files changed, 244 insertions(+), 67 deletions(-)

Jacob Keller (2):
  Update devlink header for overwrite mask attribute
  devlink: support setting the overwrite mask

 devlink/devlink.c            | 37 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h | 24 +++++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

base-commit: bd69058f50d5ffa659423bcfa6fe6280ce9c760a
-- 
2.28.0.163.g6104cc2f0b60

