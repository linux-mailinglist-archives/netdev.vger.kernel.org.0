Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C35D233C10
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgG3XUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:20:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:4791 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730735AbgG3XUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:20:30 -0400
IronPort-SDR: QqW0yFBNYuqP7wvjADvqMvv5x2uMh6qdWCjqLxs4Szelpgt3C0GCaJ+YKJSyR9UED9HFlWN0WQ
 uPfsx07lnLsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="216166657"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="216166657"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 16:20:25 -0700
IronPort-SDR: OdoBVtQ5bO1K42JCJBo8QXg7d2aWrYTOMvAO12WhSQWwMXaJZu6K69sh/DWbKcKJWEtKM3uzP6
 wNlIoUbd7NzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="395156794"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2020 16:20:25 -0700
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
Subject: [net-next 0/4] devlink flash update overwrite mask
Date:   Thu, 30 Jul 2020 16:20:04 -0700
Message-Id: <20200730232008.2648488-1-jacob.e.keller@intel.com>
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

I updated the .flash_update command to take a new parameters structure, and
pass the new overwrite mask through there. All existing drivers besides ice
and netdevsim are updated to always reject the overwrite mask. netdevsim
gains a new debugfs knob to set what overwrite values the flash update
command should accept. I added some simple tests to the devlink.sh test file
to help verify the interface works.

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

The first two patches are for net-next, and the latter two patches are for
iproute2-next. (Note I expect the first iproute2 patch to be replaced by the
usual update of headers after the new attribute is merged).

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Bin Luo <luobin9@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Danielle Ratson <danieller@mellanox.com>

Jacob Keller (2):
  devlink: convert flash_update to use params structure
  devlink: introduce flash update overwrite mask

 .../networking/devlink/devlink-flash.rst      | 29 ++++++++++++++++
 Documentation/networking/devlink/ice.rst      | 31 +++++++++++++++++
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 15 ++++----
 .../net/ethernet/huawei/hinic/hinic_devlink.c |  7 ++--
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 34 ++++++++++++++-----
 .../net/ethernet/intel/ice/ice_fw_update.c    | 16 +++++++--
 .../net/ethernet/intel/ice/ice_fw_update.h    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  7 ++--
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 ++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  6 ++--
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  9 ++---
 drivers/net/netdevsim/dev.c                   | 19 +++++++----
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         | 15 ++++++--
 include/uapi/linux/devlink.h                  | 24 +++++++++++++
 net/core/devlink.c                            | 23 +++++++++----
 .../drivers/net/netdevsim/devlink.sh          | 18 ++++++++++
 18 files changed, 210 insertions(+), 54 deletions(-)

Jacob Keller (2):
  Update devlink header for overwrite mask attribute
  devlink: support setting the overwrite mask

 devlink/devlink.c            | 37 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h | 24 +++++++++++++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

base-commit: 41d707b7332f1386642c47eb078110ca368a46f5
-- 
2.28.0.163.g6104cc2f0b60

