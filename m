Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB788274
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407139AbfHISbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:31:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:55686 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfHISbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 14:31:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:31:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="175229879"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2019 11:31:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-08-09
Date:   Fri,  9 Aug 2019 11:31:24 -0700
Message-Id: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Henry adds support to query/add queues or channels on a VSI via ethtool
operations.

Brett fixes the detection of a hung transmit ring by checking the
software based tail (next_to_use) to determine if there is pending work.
Updates the driver to assume that using more than one receive queue per
receive ring container is a rare case, so use unlikely() in the case
were we actually need to divide our budget for multiple queues.  Fixed
an issue where the write back on ITR bit was not being set when
interrupts are disabled, which was causing only write backs when polling
only when a cache line is filled.  Cleans up unnecessary wait times
during VF bring up and reset paths.  Increased the mailbox size for
receive queues that are used to communicate with VFs to accommodate the
large number of VFs that the driver can support.

Akeem restructures the initialization flows for VFs, including how VFs
are configured and resources allocated to improve flows so that when we
clean up resources, we do not try to free resources that were never
allocated.  Organizes code to ensure that VF specific code is located in
the SR-IOV specific file.

Paul fixes an issue when setting the pause parameter which was
incorrectly blocking users from changing receive or transmit pause
settings.  Ensure register access for MSIX vector index is only done in
the PF space and not absolute device space.

Usha fixes a potential kernel hang in the DCB rebuild path when in CEE
mode, where the ETS recommended DCB configuration is not being set or
set correctly.

Mitch updates the driver to process all receive descriptors, regardless
of the size of the associated data.

Tony fixes and issue during the reset/rebuild path of a PF VSI where we
were assuming that the PF VSI was always to be enabled, which can
attempt to bring up a PF VSI on a downed interface which can lead to
various crashes.

Pawel fixes up variable definitions to match the type of data being
stored.

The following are changes since commit fcc32a21655e26d30c746b4828b33a5fd4ccfb11:
  liquidio: Use pcie_flr() instead of reimplementing it
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (2):
  ice: Restructure VFs initialization flows
  ice: Move VF resources definition to SR-IOV specific file

Brett Creeley (6):
  ice: Use the software based tail when checking for hung Tx ring
  ice: Assume that more than one Rx queue is rare in ice_napi_poll
  ice: Set WB_ON_ITR when we don't re-enable interrupts
  ice: Reduce wait times during VF bringup/reset
  ice: Increase size of Mailbox receive queue for many VFs
  ice: improve print for VF's when adding/deleting MAC filters

Henry Tieman (1):
  ice: Implement ethtool ops for channels

Mitch Williams (1):
  ice: allow empty Rx descriptors

Paul Greenwalt (2):
  ice: fix set pause param autoneg check
  ice: update GLINT_DYN_CTL and GLINT_VECT2FUNC register access

Pawel Kaminski (1):
  ice: Change type for queue counts

Tony Nguyen (1):
  ice: Do not always bring up PF VSI in ice_ena_vsi()

Usha Ketineni (1):
  ice: Fix kernel hang with DCB reset in CEE mode

 drivers/net/ethernet/intel/ice/ice.h          |  18 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 158 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 113 ++++++++++++-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  52 ++++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 103 +++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  84 +++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  13 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 148 +++++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  20 ++-
 12 files changed, 555 insertions(+), 161 deletions(-)

-- 
2.21.0

