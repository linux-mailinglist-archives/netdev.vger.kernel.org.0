Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6698D193726
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCZDwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:29070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727585AbgCZDwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:09 -0400
IronPort-SDR: 8RcB/wgokpzKCD/2Z2v96dECnxYcOkk6gdYPbAcohTV+4s0Yq7J1qe596cqEQf56X222iGBDEa
 pob3gbHa1jTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:08 -0700
IronPort-SDR: fvPNL4wvMiaEqnf4Ic2KjhX4Oz5jnZMOOsW0LUP5QvV/ad2MaXzwC5TcfjAIiD1ObKfzNOpaXv
 02U2r9vodg/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028068"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:07 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
Date:   Wed, 25 Mar 2020 20:51:46 -0700
Message-Id: <20200326035157.2211090-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a second revision of the previous series to implement the
DEVLINK_CMD_REGION_NEW. The series can be viewed on lore.kernel.org at

https://lore.kernel.org/netdev/20200324223445.2077900-1-jacob.e.keller@intel.com/

This version includes the suggested cleanups from Jakub and Jiri on the
list, including the following changes, broken out by the v1 patch title.

Changes to patches since v1:

 * devlink: prepare to support region operations

   No changes

 * devlink: convert snapshot destructor callback to region op

   No changes

 * devlink: trivial: fix tab in function documentation

   No changes

 * devlink: add function to take snapshot while locked

   Added Jakub's Reviewed-by tag.

 * <NEW> devlink: use -ENOSPC to indicate no more room for snapshots

   New patch added to convert confusing -ENOMEM to -ENOSPC, as suggested by
   Jiri.

 * devlink: extract snapshot id allocation to helper function

   No changes

 * devlink: convert snapshot id getter to return an error

   Changed title to "devlink: report error once U32_MAX snapshot ids have
   been used".

   Refactored this patch to make devlink_region_snapshot_id_get take a
   pointer to u32, so that the error value and id value are separated. This
   means that we can remove the INT_MAX limitation on id values.

 * devlink: track snapshot id usage count using an xarray

   Fixed the xa_init to use xa_init_flags with XA_FLAGS_ALLOC, so that
   xa_alloc can properly be used.

   Changed devlink_region_snapshot_id_get to use an initial count of 1
   instead of 0. Added a new devlink_region_snapshot_id_put function, used
   to release this initial count. This closes the race condition and issues
   caused if the driver either doesn't create a snapshot, or if userspace
   deletes the first snapshot before others are created.

   Used WARN_ON in a few more checks that should not occur, such as if the
   xarray entry is not a value, or when the id isn't yet in the xarray.

   Removed an unnecessary if (err) { return err; } construction.

   Use xa_limit_32b instead of xa_limit_31b now that we don't return the
   snapshot id directly.

   Cleanup the label used in __devlink_region_snapshot_create to indicate the
   failure cause, rather than the cleanup step.

   Removed the unnecessary locking around xa_destroy

 * devlink: implement DEVLINK_CMD_REGION_NEW

   Added a WARN_ON to the check in snapshot_id_insert in case the id already
   exists.

   Removed an unnecessary "if (err) { return err; }" construction

   Use -ENOSPC instead of -ENOMEM when max_snapshots is reached.

   Cleanup label names to match style of the other labels in the file,
   naming after the failure cause rather than the cleanup step. Also fix a
   bug in the label ordering.

   Call the new devlink_region_snapshot_id_put function in the mlx4 and
   netdevsim drivers.

 * netdevsim: support taking immediate snapshot via devlink

   Create a local devlink pointer instead of calling priv_to_devlink
   multiple times.

   Removed previous selftest for devlink region new without a snapshot id,
   as this is no longer supported. Adjusted and verified that the tests pass
   now.

 * ice: add a devlink region for dumping NVM contents

   Use "dev_err" instead of "dev_warn" for a message about failure to create
   the devlink region.

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
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  99 +++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   4 +
 drivers/net/ethernet/mellanox/mlx4/crdump.c   |  36 +-
 drivers/net/netdevsim/dev.c                   |  46 ++-
 include/net/devlink.h                         |  33 +-
 net/core/devlink.c                            | 363 +++++++++++++++---
 .../drivers/net/netdevsim/devlink.sh          |  10 +
 11 files changed, 550 insertions(+), 80 deletions(-)

-- 
2.24.1

