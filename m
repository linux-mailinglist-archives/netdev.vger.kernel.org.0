Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC998559
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfHUUQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:16:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:58547 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbfHUUQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:16:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 13:16:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="203148173"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2019 13:16:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 40GbE Intel Wired LAN Driver Updates 2019-08-21
Date:   Wed, 21 Aug 2019 13:16:08 -0700
Message-Id: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Arnd Bergmann reduces the stack usage which was causing warnings on
32-bit architectures due to large structure sizes for 2 functions
getting inlined, so use noinline_for_stack to prevent the compilers from
combining the 2 functions.

Mauro S. M. Rodrigues fixes an issue when reading an EEPROM from SFP
modules that comply with SFF-8472 but do not implement the Digital
Diagnostic Monitoring (DDM) interface for i40e.

Huhai found we were not checking the return value for configuring the
transmit ring and continuing with XDP configuration of the transmit
ring.

Beilei fixes an issue of shifting signed 32-bit integers.

Sylwia adds support for "packet drop mode" to the MAC configuration for
admin queue command.  This bit controls the behavior when a no-drop
packet is blocking a TC queue.  Adds support for persistent LLDP by
checking the LLDP flag and reading the LLDP from the NVM when enabled.

Adrian fixes the "recovery mode" check to take into account which device
we are on, since x710 devices have 4 register values to check for status
and x722 devices only have 2 register values to check.

Piotr Azarewicz bumps the supported firmware API version to 1.9 which
extends the PHY access admin queue command support.

Jake makes sure the traffic class stats for a VEB are reset when the VEB
stats are reset.

Slawomir fixes a NULL pointer dereference where the VSI pointer was not
updated before passing it to the i40e_set_vf_mac() when the VF is in a
reset state, so wait for the reset to complete.

Grzegorz removes the i40e_update_dcb_config() which was not using the
correct NVM reads, so call i40e_init_dcb() in its place to correctly
update the DCB configuration.

Piotr Kwapulinski expands the scope of i40e_set_mac_type() since this is
needed during probe to determine if we are in recovery mode.  Fixed the
driver reset path when in recovery mode.

Marcin fixed an issue where we were breaking out of a loop too early
when trying to get the PHY capabilities.

The following are changes since commit 8c40f3b212a373be843a29db608b462af5c3ed5d:
  Merge tag 'mlx5-updates-2019-08-15' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Adrian Podlawski (1):
  i40e: check_recovery_mode had wrong if statement

Arnd Bergmann (1):
  i40e: reduce stack usage in i40e_set_fc

Beilei Xing (1):
  i40e: fix shifts of signed values

Grzegorz Siwik (1):
  i40e: Remove function i40e_update_dcb_config()

Jacob Keller (1):
  i40e: reset veb.tc_stats when resetting veb.stats

Marcin Formela (1):
  i40e: fix retrying in i40e_aq_get_phy_capabilities

Mauro S. M. Rodrigues (1):
  i40e: Check if transceiver implements DDM before access

Piotr Azarewicz (2):
  i40e: Update x710 FW API version to 1.9
  i40e: Update x722 FW API version to 1.9

Piotr Kwapulinski (2):
  i40e: make i40e_set_mac_type() public
  i40e: allow reset in recovery mode

Slawomir Laba (1):
  i40e: Fix crash caused by stress setting of VF MAC addresses

Sylwia Wnuczko (2):
  i40e: Add drop mode parameter to set mac config
  i40e: Persistent LLDP support

huhai (1):
  i40e: add check on i40e_configure_tx_ring() return value

 drivers/net/ethernet/intel/i40e/i40e_adminq.c |   4 +-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  33 ++---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 110 +++++++-------
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |  18 ++-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    |   2 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 136 ++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    | 101 +++++++++++++
 .../net/ethernet/intel/i40e/i40e_prototype.h  |   8 ++
 .../net/ethernet/intel/i40e/i40e_register.h   |  30 ++--
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   3 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   7 +-
 12 files changed, 323 insertions(+), 135 deletions(-)

-- 
2.21.0

