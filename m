Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EC330239
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfE3Suf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfE3Suf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:35 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-05-30
Date:   Thu, 30 May 2019 11:50:30 -0700
Message-Id: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett continues his work with interrupt handling by fixing an issue
where were writing to the incorrect register to disable all VF
interrupts.

Tony consolidates the unicast and multicast MAC filters into a single
new function.

Anirudh adds support for virtual channel vector mapping to receive and
transmit queues.  This uses a bitmap to associate indicated queues with
the specified vector.  Makes several cosmetic code cleanups, as well as
update the driver to align with the current specification for managing
MAC operation codes (opcodes).

Paul adds support for Forward Error Correction (FEC) and also adds the
ethtool get and set handlers to modify FEC parameters.

Bruce cleans up the driver code to fix a number of issues, such as,
reducing the scope of some local variables, reduce the number of
de-references by changing a local variable and reorder the code to
remove unnecessary "goto's".

Dave adds switch rules to be able to handle LLDP packets and in the
process, fix a couple of issues found, like stop treating DCBx state of
"not started" as an error and stop hard coding the filter information
flag to transmit.

Jacob updates the driver to allow for more granular debugging by
developers by using a distinct separate bit for dumping firmware logs.

The following are changes since commit 517f4c49aafce3d2c3ac54ae0bb36f2c76e57fe8:
  net: phy: tja11xx: Switch to HWMON_CHANNEL_INFO()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (1):
  ice: Use right type for ice_cfg_vsi_lan return

Anirudh Venkataramanan (7):
  ice: Add support for virtchnl_vector_map.[rxq|txq]_map
  ice: Use continue instead of an else block
  ice: Align to updated AQ command formats
  ice: Move define for ICE_AQC_DRIVER_UNLOADING
  ice: Update function header
  ice: Recognize higher speeds
  ice: Trivial cosmetic changes

Brett Creeley (1):
  ice: Use GLINT_DYN_CTL to disable VF's interrupts

Bruce Allan (1):
  ice: Cleanup ice_update_link_info

Dave Ertman (1):
  ice: Add switch rules to handle LLDP packets

Jacob Keller (1):
  ice: Use a different ICE_DBG bit for firmware log messages

Paul Greenwalt (1):
  ice: Add support for Forward Error Correction (FEC)

Preethi Banala (1):
  ice: Change minimum descriptor count value for Tx/Rx rings

Tony Nguyen (1):
  ice: Introduce ice_init_mac_fltr and move ice_napi_del

 drivers/net/ethernet/intel/ice/ice.h          |   2 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  25 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 121 +++++++--
 drivers/net/ethernet/intel/ice/ice_common.h   |   6 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  14 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  24 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 229 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 216 +++++++++++++----
 drivers/net/ethernet/intel/ice/ice_lib.h      |  12 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 199 ++++++++++-----
 drivers/net/ethernet/intel/ice/ice_switch.c   |   5 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   8 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  12 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  95 ++++----
 16 files changed, 754 insertions(+), 218 deletions(-)

-- 
2.21.0

