Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7AD311B0A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhBFEnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:43:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:21611 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231529AbhBFEky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:40:54 -0500
IronPort-SDR: NdCyZylKwH9B938ZCu5tK+5IgiJcTMrlOe5NjZIBTMQu6TIPi9sQUslZmtjWbwk2gUeMGNZBLT
 6xTkjsoG6EBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194687"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194687"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:11 -0800
IronPort-SDR: jtu+hLIfwA1RHfN6Ry44mpSzM6PI8SW+XqCp5DbpL1vDpPl5zVfklecjQjtPRIdeb+ceNV813P
 lxB2lux/0/Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751037"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next v2 00/11][pull request] 100GbE Intel Wired LAN Driver Updates 2021-02-05
Date:   Fri,  5 Feb 2021 20:40:50 -0800
Message-Id: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jake adds adds reporting of timeout length during devlink flash and
implements support to report devlink info regarding the version of
firmware that is stored (downloaded) to the device, but is not yet active.
ice_devlink_info_get will report "stored" versions when there is no
pending flash update. Version info includes the UNDI Option ROM, the
Netlist module, and the fw.bundle_id.

Gustavo A. R. Silva replaces a one-element array to flexible-array
member.

Bruce utilizes flex_array_size() helper and removes dead code on a check
for a condition that can't occur.

v2:
* removed security revision implementation, and re-ordered patches to
account for this removal
* squashed patches implementing ice_read_flash_module to avoid patches
refactoring the implementation of a previous patch in the series
* modify ice_devlink_info_get to always report "stored" versions instead
of only reporting them when a pending flash update is ready.

The following are changes since commit 4d469ec8ec05e1fa4792415de1a95b28871ff2fa:
  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Bruce Allan (2):
  ice: use flex_array_size where possible
  ice: remove dead code

Gustavo A. R. Silva (1):
  ice: Replace one-element array with flexible-array member

Jacob Keller (8):
  ice: report timeout length for erasing during devlink flash
  ice: create flash_info structure and separate NVM version
  ice: introduce context struct for info report
  ice: cache NVM module bank information
  ice: introduce function for reading from flash modules
  ice: display some stored NVM versions via devlink info
  ice: display stored netlist versions via devlink info
  ice: display stored UNDI firmware version via devlink info

 drivers/net/ethernet/intel/ice/ice.h          |   2 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  27 -
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 273 ++++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   8 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   2 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  16 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 662 ++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  14 +
 drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_type.h     | 131 +++-
 12 files changed, 906 insertions(+), 242 deletions(-)

-- 
2.26.2

