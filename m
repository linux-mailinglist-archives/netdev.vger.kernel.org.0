Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A191358951
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhDHQLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:15195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231655AbhDHQLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:50 -0400
IronPort-SDR: 5BIX8+SDMFUdxvdslHk6B81MGWHzqJrGpLUP+cfjhtM7cf2GyMLT7zsCShN4lLLlWJiJrjN3B3
 TJvXfL1a2oWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257557975"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="257557975"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:38 -0700
IronPort-SDR: nUbGLxT3STwLMAsZ0H+/fOcfy2Zw1w0EuraNmv/xNlL8a6Jf6xWN58rpo6b+yON5wYDSGVWwGP
 KAaA3LV10xwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841382"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:37 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2021-04-08
Date:   Thu,  8 Apr 2021 09:13:06 -0700
Message-Id: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Chinh adds retrying of sending some AQ commands when receiving EBUSY
error.

Victor modifies how nodes are added to reduce stack usage.

Ani renames some variables to either follow spec naming or to be inline
with naming in the rest of the driver. Ignores EMODE error as there are
cases where this error is expected. Performs some cleanup such as
removing unnecessary checks, doing variable assignments over copies, and
removing unneeded variables. Revises some error codes returned in link
settings to be more appropriate. He also implements support for new
firmware option to get default link configuration which accounts for
any needed NVM based overrides for PHY configuration. He also removes
the rx_gro_dropped stat as the value no longer changes.

Jeb removes setting specific link modes on firmwares that no longer
require it.

Brett removes unnecessary checks when adding and removing VLANs.

Tony fixes a checkpatch warning for unnecessary blank line.

The following are changes since commit 3cd52c1e32fe7dfee09815ced702db9ee9f84ec9:
  net: fealnx: use module_pci_driver to simplify the code
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (10):
  ice: Align macro names to the specification
  ice: Ignore EMODE return for opcode 0x0605
  ice: Remove unnecessary checker loop
  ice: Rename a couple of variables
  ice: Fix error return codes in ice_set_link_ksettings
  ice: Replace some memsets and memcpys with assignment
  ice: Use default configuration mode for PHY configuration
  ice: Remove unnecessary variable
  ice: Use local variable instead of pointer derefs
  ice: Remove rx_gro_dropped stat

Brett Creeley (1):
  ice: Remove unnecessary checks in add/kill_vid ndo ops

Chinh T Cao (1):
  ice: Re-send some AQ commands, as result of EBUSY AQ error

Jeb Cramer (1):
  ice: Limit forced overrides based on FW version

Tony Nguyen (1):
  ice: Remove unnecessary blank line

Victor Raj (1):
  ice: Modify recursive way of adding nodes

 drivers/net/ethernet/intel/ice/ice.h          |   1 -
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  20 ++-
 drivers/net/ethernet/intel/ice/ice_common.c   | 139 ++++++++++++---
 drivers/net/ethernet/intel/ice/ice_common.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_controlq.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 165 ++++++++----------
 drivers/net/ethernet/intel/ice/ice_lib.c      |  37 ++++
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 135 ++++++--------
 drivers/net/ethernet/intel/ice/ice_sched.c    | 130 ++++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   1 -
 drivers/net/ethernet/intel/ice/ice_type.h     |   5 +
 12 files changed, 391 insertions(+), 250 deletions(-)

-- 
2.26.2

