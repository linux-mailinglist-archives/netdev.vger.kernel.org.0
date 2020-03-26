Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE91946A2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgCZShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:43770 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgCZShX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:23 -0400
IronPort-SDR: PrwaWhi35iR93jRzL8L6CCE0/E/GxPVUHf7oESJl/Iaa7c0LOqBRICvT7cDdT3WrXQv7wSSfej
 gCg20OqDwGXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:22 -0700
IronPort-SDR: S/YcW0QBiA505H2ZHrJsaeNhkIK4NdS0AvMEGmGs76TWo+gF+RL7Q8T4VHW4ntcW3GAbSidHqe
 Y7AISjaMwzCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241603"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:21 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v3 00/11] implement DEVLINK_CMD_REGION_NEW
Date:   Thu, 26 Mar 2020 11:37:07 -0700
Message-Id: <20200326183718.2384349-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the DEVLINK_CMD_REGION_NEW operation, used to
enable userspace requesting a snapshot of a region on demand.

This can be useful to enable adding regions for a driver for which there is
no trigger to create snapshots. By making this a core part of devlink, there
is no need for the drivers to use a separate channel such as debugfs.

The primary intent for this kind of region is to expose device information
that might be useful for diagnostics and information gathering.

The first few patches refactor regions to support a new ops structure for
extending the available operations that regions can perform. This includes
converting the destructor into an op from a function argument.

Next, patches refactor the snapshot id allocation to use an xarray which
tracks the number of current snapshots using a given id. This is done so
that id lifetime can be determined, and ids can be released when no longer
in use.

Without this change, snapshot ids remain used forever, until the snapshot_id
count rolled over UINT_MAX.

Finally, code to enable the previously unused DEVLINK_CMD_REGION_NEW is
added. This code enforces that the snapshot id is always provided, unlike
previous revisions of this series.

Finally, a patch is added to enable using this new command via the .snapshot
callback in both netdevsim and the ice driver.

For the ice driver, a new "nvm-flash" region is added, which will enable
read access to the NVM flash contents. The intention for this is to allow
diagnostics tools to gather information about the device. By using a
snapshot and gathering the NVM contents all at once, the contents can be
atomic.

Links to previous discussions:
1st RFC - https://lore.kernel.org/netdev/20200130225913.1671982-1-jacob.e.keller@intel.com/
2nd RFC - https://lore.kernel.org/netdev/20200214232223.3442651-1-jacob.e.keller@intel.com/
v1 - https://lore.kernel.org/netdev/20200324223445.2077900-1-jacob.e.keller@intel.com/
v2 - https://lore.kernel.org/netdev/20200326035157.2211090-1-jacob.e.keller@intel.com/

Major changes since RFC:
* use an xarray for tracking snapshot ids, rather than an IDR
* remove support for auto-generated snapshot ids in DEVLINK_CMD_REGION_NEW

See each patch for an individual changelog per-patch

Jacob Keller (11):
  devlink: prepare to support region operations
  devlink: convert snapshot destructor callback to region op
  devlink: trivial: fix tab in function documentation
  devlink: add function to take snapshot while locked
  devlink: use -ENOSPC to indicate no more room for snapshots
  devlink: extract snapshot id allocation to helper function
  devlink: report error once U32_MAX snapshot ids have been used
  devlink: track snapshot id usage count using an xarray
  devlink: implement DEVLINK_CMD_REGION_NEW
  netdevsim: support taking immediate snapshot via devlink
  ice: add a devlink region for dumping NVM contents

 .../networking/devlink/devlink-region.rst     |   8 +
 Documentation/networking/devlink/ice.rst      |  26 ++
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  96 +++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   4 +
 drivers/net/ethernet/mellanox/mlx4/crdump.c   |  36 +-
 drivers/net/netdevsim/dev.c                   |  45 ++-
 include/net/devlink.h                         |  33 +-
 net/core/devlink.c                            | 362 +++++++++++++++---
 .../drivers/net/netdevsim/devlink.sh          |  10 +
 11 files changed, 546 insertions(+), 79 deletions(-)

-- 
2.24.1

