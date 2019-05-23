Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C190828D2C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbfEWWdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:19068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbfEWWdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:35 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-05-23
Date:   Thu, 23 May 2019 15:33:25 -0700
Message-Id: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Anirudh cleans up white space issues and other code formatting issues in the
driver.  Also implemented LLDP persistence across reboots and start/stop of the
LLDP agent.  Updated print statements for driver capabilities to include
if it is a device or function capability.

Bruce cleaned up variable declarations by removing unneeded assignment.

Dave fixes a potential hang due to a couple of flows that recursively
acquire the RTNL lock which results in a deadlock.

Tony updates the driver to advertise what link modes we are capable of
when the user does not request a specific link mode.

Usha fixes up the LLDP MIB change event handling by cleaning up
workarounds and print the DCB configuration changes detected.

Brett fixes the driver to handle failures in the VF reset path, which
was failing to free resources upon an error.

Richard fixed the reported of stats via ethtool to align with our other
Intel drivers.

Jesse optimizes the transmit buffer and ring structures to have more
efficient ordering to get hot cache lines to have packed data.  Also
optimized the VF structure to use less memory, since it is used hundreds
of times throughout the driver.

The following are changes since commit 16fa1cf1ed2a652a483cf8f1ea65c703693292e8:
  Revert "dpaa2-eth: configure the cache stashing amount on a queue"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (4):
  ice: Fix double spacing
  ice: Implement LLDP persistence
  ice: Remove braces for single statement blocks
  ice: Call out dev/func caps when printing

Brett Creeley (2):
  ice: Gracefully handle reset failure in ice_alloc_vfs()
  ice: Fix couple of issues in ice_vsi_release

Bruce Allan (2):
  ice: Cleanup an unnecessary variable initialization
  ice: Silence semantic parser warnings

Dave Ertman (1):
  ice: Fix hang when ethtool disables FW LLDP

Jesse Brandeburg (3):
  ice: Reorganize tx_buf and ring structs
  ice: Use bitfields when possible
  ice: Reorganize ice_vf struct

Richard Rodriguez (1):
  ice: Format ethtool reported stats

Tony Nguyen (1):
  ice: Advertise supported link modes if none requested

Usha Ketineni (1):
  ice: Refactor the LLDP MIB change event handling

 drivers/net/ethernet/intel/ice/ice.h          |  13 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  56 ++---
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  21 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h      |  12 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 212 +++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   5 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 197 +++++++++-------
 drivers/net/ethernet/intel/ice/ice_lib.c      |  24 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  35 +--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  20 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  25 ++-
 14 files changed, 400 insertions(+), 234 deletions(-)

-- 
2.21.0

