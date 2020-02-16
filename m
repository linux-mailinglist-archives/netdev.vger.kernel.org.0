Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80E616018C
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBPDoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:33359 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBPDoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916571"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-02-15
Date:   Sat, 15 Feb 2020 19:44:37 -0800
Message-Id: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett adds support for "Queue in Queue" (QinQ) support, by supporting
S-tag & C-tag VLAN traffic by disabling pruning when there are no 0x8100
VLAN interfaces currently on top of the PF.  Also refactored the port
VLAN configuration to re-use the common code for enabling and disabling
a port VLAN in single function.  Added a helper function to determine if
the VF link is up.  Fixed how the port VLAN configures the priority bits
for a VF interface.  Fixed the port VLAN to only see its own broadcast
and multicast traffic.  Added support to enable and disable all receive
queues, by refactoring adding a new function to do the necessary steps
to enable/disable a queue with the necessary read flush.  Fixed how we
set the mapping mode for transmit and receive queues.  Added support for
VF queues to handle LAN overflow events.  Fixed and refactored how
receive queues get disabled for VFs, which was being handled one queue
at at time, so improve it to handle when the VF is requesting more than
one queue to be disabled.  Fixed how the virtchnl_queue_select bitmap is
validated.

Finally a patch not authored by Brett, Bruce cleans up "fallthrough"
comments which are unnecessary.  Also replaces the "fallthough" comments
with the GCC reserved word fallthrough, along with other GCC compiler
fixes.  Add missing function header comment regarding a function
argument that was missing.

The following are changes since commit 2019fc96af228b412bdb2e8e0ad4b1fc12046a51:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Brett Creeley (10):
  ice: Add initial support for QinQ
  ice: Refactor port vlan configuration for the VF
  ice: Add helper to determine if VF link is up
  ice: Fix Port VLAN priority bits
  ice: Only allow tagged bcast/mcast traffic for VF in port VLAN
  ice: Add support to enable/disable all Rx queues before waiting
  ice: Fix implicit queue mapping mode in ice_vsi_get_qs
  ice: Handle LAN overflow event for VF queues
  ice: Fix and refactor Rx queue disable for VFs
  ice: Fix virtchnl_queue_select bitmap validation

Bruce Allan (5):
  ice: remove unnecessary fallthrough comments
  ice: replace "fallthrough" comments with fallthrough reserved word
  ice: use proper format for function pointer as a function parameter
  ice: add function argument description to function header comment
  ice: use true/false for bool types

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  11 +
 drivers/net/ethernet/intel/ice/ice_base.c     |  43 ++-
 drivers/net/ethernet/intel/ice/ice_base.h     |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   6 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  98 +++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  33 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    |   2 -
 drivers/net/ethernet/intel/ice/ice_switch.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   5 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 341 ++++++++++++------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  12 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  12 +-
 15 files changed, 385 insertions(+), 198 deletions(-)

-- 
2.24.1

