Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE0D308294
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhA2Ane (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:43:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:27154 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhA2Anc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:43:32 -0500
IronPort-SDR: lQxJbMqSzByAf3dqnHNPOKTSWXvyKc1griu9qICxmooaWkFCNR+tk1W7j6ZJBT/cmHr4IT+8gK
 n8Fl4h+U2f3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438959"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438959"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:51 -0800
IronPort-SDR: HZtNsJkua+sXCUOxDFpqUiRVuFU+r/rWPL0SFc6DAQBhvGzoQ/Ss0hYPUDdw3uXF1r/bS5MZWi
 PVx+bPfRaceQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778679"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:50 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2021-01-28
Date:   Thu, 28 Jan 2021 16:43:17 -0800
Message-Id: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake adds devlink reporting of security revision fields associated with
'fw.undi' and 'fw.mgmt'. Also implements support for displaying and
updating the minimum security revision fields for the device as
driver-specific devlink parameters. And adds reporting of timeout length
during devlink flash.

He also implements support to report devlink info regarding the version of
firmware that is stored (downloaded) to the device, but is not yet active.
This includes the UNDI Option ROM, the Netlist module, and the
fw.bundle_id.

Changes include:
   Refactoring version reporting to allow for a context structure.

   ice_read_flash_module is further abstracted to think in terms of
   "active" and "inactive" banks, rather than focusing on "read from
   the 1st or 2nd bank". Further, the function is extended to allow
   reading arbitrary sizes beyond just one word at a time.

   Extend the version function to allow requesting the flash bank to read
   from (active or inactive).

Gustavo A. R. Silva replaces a one-element array to flexible-array
member.

Bruce utilizes flex_array_size() helper and removes dead code on a check
for a condition that can't occur.

The following are changes since commit 32e31b78272ba0905c751a0f6ff6ab4c275a780e:
  Merge branch 'net-sfp-add-support-for-gpon-rtl8672-rtl9601c-and-ubiquiti-u-fiber'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Bruce Allan (2):
  ice: use flex_array_size where possible
  ice: remove dead code

Gustavo A. R. Silva (1):
  ice: Replace one-element array with flexible-array member

Jacob Keller (12):
  ice: create flash_info structure and separate NVM version
  ice: cache NVM module bank information
  ice: read security revision to ice_nvm_info and ice_orom_info
  ice: add devlink parameters to read and write minimum security
    revision
  ice: report timeout length for erasing during devlink flash
  ice: introduce context struct for info report
  ice: refactor interface for ice_read_flash_module
  ice: allow reading inactive flash security revision
  ice: allow reading arbitrary size data with read_flash_module
  ice: display some stored NVM versions via devlink info
  ice: display stored netlist versions via devlink info
  ice: display stored UNDI firmware version via devlink info

 Documentation/networking/devlink/ice.rst      |  43 +
 drivers/net/ethernet/intel/ice/ice.h          |   2 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  40 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 496 +++++++++-
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   8 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   2 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  19 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 876 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  18 +
 drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_type.h     | 141 ++-
 14 files changed, 1427 insertions(+), 233 deletions(-)

-- 
2.26.2

