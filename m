Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8184A191CE6
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgCXWex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:34:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728282AbgCXWew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:34:52 -0400
IronPort-SDR: X9riMiWpvEdNszTrje8a4y9Ld/sJGvULEO+21EWrg6HJjPk7c5fHZY0Zjj7HJH7vhOutRWLLhS
 mSyDIf/KN/Kw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:34:52 -0700
IronPort-SDR: hDUhYLsjE9tTqjQdq/dGEal0El1zCIItIxVU1KTNGTlRyQF208YaMjpn7YP6fAu/sba9WTa+pL
 2nFI3M43v/Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363111"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:34:51 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 00/10] implement DEVLINK_CMD_REGION_NEW
Date:   Tue, 24 Mar 2020 15:34:35 -0700
Message-Id: <20200324223445.2077900-1-jacob.e.keller@intel.com>
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

General changes since the v2 RFC:
* Use an xarray instead of IDRs
* Rebase onto net-next now that the initial ice devlink patches landed.

Patch specific changes:
* devlink: add functions to take snapshot while locked

  Split this into two patches, so that an explanation of why the
  devlink_region_snapshot_id_get is still extracted, even though only one
  caller will remain.

* devlink: track snapshot ids using an IDR and refcounts

  Convert to using an xarray storing the total number of snapshots directly,
  rather than an IDR with a refcount structure. This significantly
  simplifies the code, and avoids the complication of a NULL refcount.

* devlink: implement DEVLINK_CMD_REGION_NEW

  As suggested by Jiri, remove the ability for DEVLINK_CMD_REGION_NEW to
  dynamically generate IDs. Instead, always require a snapshot id. This
  aligns with DEVLINK_CMD_REGION_DEL, and helps reduce confusion.

  Refactor this patch to use the xarray instead of the IDR, as in the
  previous patch.

  Clean up and remove unnecessary new lines on NL_SET_ERR_MSG_MOD

* ice: add a devlink region to dump shadow RAM contents

  Remove the code for immediate region read, as this will be worked on in a
  separate series following this one.

Jacob Keller (10):
  devlink: prepare to support region operations
  devlink: convert snapshot destructor callback to region op
  devlink: trivial: fix tab in function documentation
  devlink: add function to take snapshot while locked
  devlink: extract snapshot id allocation to helper function
  devlink: convert snapshot id getter to return an error
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
 drivers/net/ethernet/mellanox/mlx4/crdump.c   |  32 +-
 drivers/net/netdevsim/dev.c                   |  41 +-
 include/net/devlink.h                         |  31 +-
 net/core/devlink.c                            | 354 +++++++++++++++---
 .../drivers/net/netdevsim/devlink.sh          |  15 +
 11 files changed, 538 insertions(+), 77 deletions(-)

-- 
2.24.1

