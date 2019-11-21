Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70282104CCC
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKUHqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:4522 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfKUHqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077518"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:13 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-11-20
Date:   Wed, 20 Nov 2019 23:45:57 -0800
Message-Id: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Bruce updates the driver to store the number of functions the device has
so that it won't have to compute it when setting safe mode capabilities.
Adds a check to adjust the reporting of capabilities for devices with
more than 4 ports, which differ for devices with less than 4 ports.

Brett adds a helper function to determine if the VF is allowed to do
VLAN operations based on the host's VF configuration.  Also adds a new
function that initializes VLAN stripping (enabled/disabled) for the VF
based on the device supported capabilities.  Adds a check if the vector
index is valid with the respect to the number of transmit and receive
queues configured when we set coalesce settings for DCB.  Adds a check
if the promisc_mask contains ICE_PROMISC_VLAN_RX or ICE_PROMISC_VLAN_TX
so that VLAN 0 promiscuous rules to be removed.  Add a helper macro for
a commonly used de-reference of a pointer to &pf->dev->pdev.

Jesse fixes an issue where if an invalid virtchnl request from the VF,
the driver would return uninitialized data to the VF from the PF stack,
so ensure the stack variable is initialized earlier.  Add helpers to the
virtchnl interface make the reporting of strings consistent and help
reduce stack space.  Implements VF statistics gathering via the kernel
ndo_get_vf_stats().

Akeem ensures we disable the state flag for each VF when its resources
are returned to the device.

Tony does additional cleanup in the driver to ensure the when we
allocate and free memory within the same function, we should not be
using devm_* variants; use regular alloc and free functions.

Henry implements code to query and set the number of channels on the
primary VSI for a PF via ethtool.

Jake cleans up needless NULL checks in ice_sched_cleanup_all().

Kevin updates the firmware API version to align with current NVM images.

The following are changes since commit f3c9a666b28572b1a0ae691a47d9a7de4d9cefb3:
  net: sfp: soft status and control support
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (1):
  ice: Only disable VF state when freeing each VF resources

Brett Creeley (5):
  ice: Disallow VF VLAN opcodes if VLAN offloads disabled
  ice: Don't modify stripping for add/del VLANs on VF
  ice: Fix setting coalesce to handle DCB configuration
  ice: Refactor removal of VLAN promiscuous rules
  ice: Add ice_pf_to_dev(pf) macro

Bruce Allan (2):
  ice: Store number of functions for the device
  ice: Correct capabilities reporting of max TCs

Henry Tieman (1):
  ice: Implement ethtool ops for channels

Jacob Keller (1):
  ice: remove pointless NULL check of port_info

Jesse Brandeburg (3):
  ice: fix stack leakage
  ice: add helpers for virtchnl
  ice: implement VF stats NDO

Kevin Scott (1):
  ice: Update FW API minor version

Tony Nguyen (1):
  ice: Do not use devm* functions for local uses

 drivers/net/ethernet/intel/ice/ice.h          |   6 +
 drivers/net/ethernet/intel/ice/ice_base.c     |  22 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  33 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 141 +++---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  14 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 314 ++++++++++---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 273 ++++++-----
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 283 +++++++----
 drivers/net/ethernet/intel/ice/ice_sched.c    |   3 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  13 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 444 +++++++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  11 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   4 +-
 17 files changed, 1031 insertions(+), 539 deletions(-)

-- 
2.23.0

