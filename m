Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C8EA79E7
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfIDEfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfIDEfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804387"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-09-03
Date:   Tue,  3 Sep 2019 21:34:57 -0700
Message-Id: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Anirudh adds the ability for the driver to handle EMP resets correctly
by adding the logic to the existing ice_reset_subtask().

Jeb fixes up the logic to properly free up the resources for a switch
rule whether or not it was successful in the removal.

Brett fixes up the reporting of ITR values to let the user know odd ITR
values are not allowed.  Fixes the driver to only disable VLAN pruning
on VLAN deletion when the VLAN being deleted is the last VLAN on the VF
VSI.

Chinh updates the driver to determine the TSA value from the priority
value when in CEE mode.

Bruce aligns the driver with the hardware specification by ensuring that
a PF reset is done as part of the unload logic.  Also update the driver
unloading field, based on the latest hardware specification, which
allows us to remove an unnecessary endian conversion.  Moves #defines
based on their need in the code.

Jesse adds the current state of auto-negotiation in the link up message.
In addition, adds additional information to inform the user of an issue
with the topology/configuration of the link.

Usha updates the driver to allow the maximum TCs that the firmware
supports, rather than hard coding to a set value.

Dave updates the DCB initialization flow to handle the case of an actual
error during DCB init.  Updated the driver to report the current stats,
even when the netdev is down, which aligns with our other drivers.

Mitch fixes the VF reset code flows to ensure that it properly calls
ice_dis_vsi_txq() to notify the firmware that the VF is being reset.

Michal fixes the driver so the DCB is not enabled when the SW LLDP is
activated, which was causing a communication issue with other NICs.  The
problem lies in that DCB was being enabled without checking the number
of TCs.

The following are changes since commit 67538eb5c00f08d7fe27f1bb703098b17302bdc0:
  Merge branch 'mvpp2-per-cpu-buffers'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Fix EMP reset handling

Brett Creeley (2):
  ice: Report what the user set for coalesce [tx|rx]-usecs
  ice: Only disable VLAN pruning for the VF when all VLANs are removed

Bruce Allan (2):
  ice: add needed PFR during driver unload
  ice: update driver unloading field for Queue Shutdown AQ command

Chinh T Cao (1):
  ice: Deduce TSA value from the priority value in the CEE mode

Dave Ertman (2):
  ice: Correctly handle return values for init DCB
  ice: Report stats when VSI is down

Jeb Cramer (1):
  ice: Fix resource leak in ice_remove_rule_internal()

Jesse Brandeburg (2):
  ice: add print of autoneg state to link message
  ice: print extra message if topology issue

Michal Swiatkowski (1):
  ice: Remove enable DCB when SW LLDP is activated

Mitch Williams (1):
  ice: Always notify FW of VF reset

Tony Nguyen (1):
  ice: Cleanup defines in ice_type.h

Usha Ketineni (1):
  ice: Limit Max TCs on devices with more than 4 ports

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  5 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 14 ++-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  8 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 16 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 88 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_main.c     | 43 ++++++++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  5 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  9 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 30 ++++---
 9 files changed, 144 insertions(+), 74 deletions(-)

-- 
2.21.0

