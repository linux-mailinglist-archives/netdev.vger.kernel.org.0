Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC7A15B2C3
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgBLVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:42951 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727564AbgBLVeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911676"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:33:59 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 00/15][pull request] Intel Wired LAN Driver Updates 2020-02-12
Date:   Wed, 12 Feb 2020 13:33:42 -0800
Message-Id: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to only the ice driver.

Dave fixes logic flaws in the DCB rebuild function which is used after a
reset.  Also fixed a configuration issue when switching between firmware
and software LLDP mode where the number of TLV's configured was getting
out of sync with what lldpad thinks is configured.

Paul fixes how the driver displayed all the supported and advertised
link modes by basing it on the PHY capabilities, and in the process
cleaned up a lot of code.

Brett fixes duplicate receive tail bumps by comparing the value we are
writing to tail with the previously written tail value.  Also cleaned up
workarounds that are no longer needed with the latest NVM images.

Anirudh cleaned up unnecessary CONFIG_PCI_IOV wrappers.  Updated the
driver to use ice_pf_to_dev() instead of &pf->pdev->dev or
&vsi->back->pdev->dev.  Cleaned up the string format in print function
calls to remove newlines where applicable.

Akeem updates the link message logging to include "Full Duplex" and
"Negotiated", to help distinguish from "Requested" for FEC.

Bruce fixes and consolidates the logging of firmware/NVM information
during driver load, since the information is duplicate of what is
available via ethtool.  Fixed the checking of the Unit Load Status bits
after reset to ensure they are 0x7FF before continuing, by updating the
mask.  Cleanup up possible NULL dereferences that were created by a
previous commit.

Ben fixes the driver to use the correct netif_msg_tx/rx_error() to
determine whether to print the MDD event type.

Tony provides several trivial fixes, which include whitespace, typos,
function header comments, reverse Christmas tree issues.

The following are changes since commit b9287f2ac321ecac56eb51e6231f6579683dcdae:
  net: ethernet: ave: Add capability of rgmii-id mode
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 100GbE

Akeem G Abodunrin (1):
  ice: Modify link message logging

Anirudh Venkataramanan (4):
  ice: Remove CONFIG_PCI_IOV wrap in ice_set_pf_caps
  ice: Use ice_pf_to_dev
  ice: Make print statements more compact
  ice: Cleanup ice_vsi_alloc_q_vectors

Ben Shelton (1):
  ice: Use correct netif error function

Brett Creeley (2):
  ice: Don't allow same value for Rx tail to be written twice
  ice: Remove ice_dev_onetime_setup()

Bruce Allan (2):
  ice: fix and consolidate logging of NVM/firmware version information
  ice: update Unit Load Status bitmask to check after reset

Dave Ertman (2):
  ice: Fix DCB rebuild after reset
  ice: Fix switch between FW and SW LLDP

Paul Greenwalt (1):
  ice: display supported and advertised link modes

Tony Nguyen (2):
  ice: Remove possible null dereference
  ice: Trivial fixes

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_base.c     |  35 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  37 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   2 -
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  99 ++---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  20 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 355 ++----------------
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   7 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  71 +---
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 -
 drivers/net/ethernet/intel/ice/ice_main.c     | 195 ++++------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  11 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  67 ++--
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   4 +-
 18 files changed, 247 insertions(+), 675 deletions(-)

-- 
2.24.1

