Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2241A9A11D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389188AbfHVUam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:30:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:17464 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732319AbfHVUal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:30:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 13:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="169907257"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 13:30:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/13][pull request] 40GbE Intel Wired LAN Driver Updates 2019-08-22
Date:   Thu, 22 Aug 2019 13:30:26 -0700
Message-Id: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
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

v2: Combined patch 7 & 9 in the original series, since both patches
    bumped firmware API version.  Also combined patches 12 & 13 in the
    original series, since one increased the scope of checking for MAC
    and the follow-on patch made use of function within the new scope.

The following are changes since commit c76c992525245ec1c7b6738bf887c42099abab02:
  nexthops: remove redundant assignment to variable err
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

Piotr Azarewicz (1):
  i40e: Update FW API version to 1.9

Piotr Kwapulinski (1):
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

