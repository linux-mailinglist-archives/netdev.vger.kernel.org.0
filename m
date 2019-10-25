Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80834E5547
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 22:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfJYUmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 16:42:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:63953 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfJYUmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 16:42:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 13:42:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="202713953"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 13:42:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/9][pull request] 40GbE Intel Wired LAN Driver Updates 2019-10-25
Date:   Fri, 25 Oct 2019 13:42:33 -0700
Message-Id: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e only.  Several are fixes that could
go to 'net', but were intended for 'net-next'.

Sylwia changes how the driver function to read the NVM module data, so
that it is able to read the LLDP agent configuration to allow for
persistent LLDP.

Jaroslaw resolves an issue where the incorrect FEC settings were being
displayed in ethtool, by setting the proper FEC bits.

Piotr moves the hardware flags detection into a separate function, so
that the specific flags can be set based on the MAC and NVM.  Also
extends the PHY access function to include a command flag to let the
firmware know it should not change the page while accessing a OSFP module.
Updates the driver to display the driver and firmware version when in
recovery mode.

Aleksandr refactored the VF MAC filters accounting since an untrusted
VF was able to delete but not add a MAC filter, so refactor the code to
have more consistency and improved logging.

Nicholas updates the driver to use a default interval of 50 usecs,
instead of the current 100 usecs which was causing some regression
performance issues.

Damian resolved LED blinking issues for X710T*L devices by adding
specific flows for these devices in the LED operations.

Navid Emamdoost found where allocated memory is not being properly freed
upon a failure in setting up MAC VLANs, so added the missing kfree().

v2: Dropped patches 2 & 6 from the original series while we wait for the
    author to respond to community feedback.

The following are changes since commit 503a64635d5ef7351657c78ad77f8b5ff658d5fc:
  Merge branch 'DPAA-Ethernet-changes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Aleksandr Loktionov (1):
  i40e: Refactoring VF MAC filters counting to make more reliable

Damian Milosek (1):
  i40e: Fix LED blinking flow for X710T*L devices

Jaroslaw Gawin (1):
  i40e: Wrong 'Advertised FEC modes' after set FEC to AUTO

Navid Emamdoost (1):
  i40e: prevent memory leak in i40e_setup_macvlans

Nicholas Nunley (1):
  i40e: initialize ITRN registers with correct values

Piotr Azarewicz (2):
  i40e: Extract detection of HW flags into a function
  i40e: Extend PHY access with page change flag

Piotr Kwapulinski (1):
  i40e: allow ethtool to report SW and FW versions in recovery mode

Sylwia Wnuczko (1):
  i40e: Fix for persistent lldp support

 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  71 +++++++++--
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 116 ++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    |   3 +
 drivers/net/ethernet/intel/i40e/i40e_devids.h |   2 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  41 ++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  30 ++++-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  61 ++++-----
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  36 ++++--
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   1 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  45 +++----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |   1 -
 14 files changed, 289 insertions(+), 131 deletions(-)

-- 
2.21.0

