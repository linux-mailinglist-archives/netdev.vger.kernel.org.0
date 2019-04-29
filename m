Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C77EAAF
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfD2TOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:61541 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbfD2TOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867016"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:06 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/12][pull request] 40GbE Intel Wired LAN Driver Updates 2019-04-29
Date:   Mon, 29 Apr 2019 12:16:16 -0700
Message-Id: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the i40e driver only.

Björn improves retpoline enabled builds by replacing the expensive switch
statements with 'if' statements that acts on the XDP program result.

Carolyn changes the driver behavior to now disable the VF after one MDD
event instead of allowing a couple of MDD events before doing the reset.

Aleksandr changes the driver to only report an error when a VF tries to
remove VLAN when a port VLAN is configured, unless it is VLAN 0.  Also
extends the LLDP support to be able to keep the current LLDP state
persistent across a power cycle.

Maciej fixes the checksum calculation due to firmware changes, which
requires the driver to perform a double shadow RAM dump in some cases.

Adam adds advertising support for 40GBase_LR4, 40GBase_CR4 and fibre in
the driver.

Jake cleans up a check that is not needed and was producing a warning in
GCC 8.

Harshitha fixes a misleading message by ensuring that a success message
is only printed on the host side when the promiscuous mode change has
been successful.

Stefan Assmann adds the vendor id and device id to the dmesg log entry
during probe to help with bug reports when lspci output may not be
available.

Alice and Piotr add recovery mode support in the i40e driver, which is
needed for migrating from a structured to a flat firmware image.

The following are changes since commit 88d6272acaaa4bfb03da0a87a8754ec431471680:
  net: phy: avoid unneeded MDIO reads in genphy_read_status
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Adam Ludkiewicz (1):
  i40e: Report advertised link modes on 40GBase_LR4, CR4 and fibre

Aleksandr Loktionov (2):
  i40e: remove error msg when vf with port vlan tries to remove vlan 0
  i40e: Further implementation of LLDP

Alice Michael (2):
  i40e: update version number
  i40e: Introduce recovery mode support

Björn Töpel (1):
  i40e: replace switch-statement to speed-up retpoline-enabled builds

Carolyn Wyborny (2):
  i40e: Fix for allowing too many MDD events on VF
  i40e: change behavior on PF in response to MDD event

Harshitha Ramamurthy (1):
  i40e: fix misleading message about promisc setting on un-trusted VF

Jacob Keller (1):
  i40e: remove out-of-range comparisons in i40e_validate_cloud_filter

Maciej Paczkowski (1):
  i40e: ShadowRAM checksum calculation change

Stefan Assmann (1):
  i40e: print PCI vendor and device ID during probe

 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |   5 +
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  20 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |  62 ++-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |   4 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  28 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 352 +++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  29 +-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  32 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  27 ++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   1 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  35 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  24 +-
 14 files changed, 498 insertions(+), 130 deletions(-)

-- 
2.20.1

