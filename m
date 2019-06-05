Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE536568
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFEUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:23:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:4309 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfFEUXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:23:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2019 13:23:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 10GbE Intel Wired LAN Driver Updates 2019-06-05
Date:   Wed,  5 Jun 2019 13:23:43 -0700
Message-Id: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to mainly ixgbe, with a few updates to
i40e, net, ice and hns2 driver.

Jan adds support for tracking each queue pair for whether or not AF_XDP
zero copy is enabled.  Also updated the ixgbe driver to use the
netdev-provided umems so that we do not need to contain these structures
in our own adapter structure.

William Tu provides two fixes for AF_XDP statistics which were causing
incorrect counts.

Jake reduces the PTP transmit timestamp timeout from 15 seconds to 1 second,
which is still well after the maximum expected delay.  Also fixes an
issues with the PTP SDP pin setup which was not properly aligning on a
full second, so updated the code to account for the cyclecounter
multiplier and simplify the code to make the intent of the calculations
more clear.  Updated the function header comments to help with the code
documentation.  Added support for SDP/PPS output for x550 devices, which
is slightly different than x540 devices that currently have this
support.

Anirudh adds a new define for Link Layer Discovery Protocol to the
networking core, so that drivers do not have to create and use their own
definitions.  In addition, update all the drivers currently defining
their own LLDP define to use the new networking core define.

The following are changes since commit 11694b03616b2a03cd7e3f0897d4d086c7fbc4b5:
  net: fec_ptp: Use dev_err() instead of pr_err()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 10GbE

Anirudh Venkataramanan (4):
  net: Add a define for LLDP ethertype
  i40e: Use LLDP ethertype define ETH_P_LLDP
  ixgbe: Use LLDP ethertype define ETH_P_LLDP
  net: hns3: Use LLDP ethertype define ETH_P_LLDP

Jacob Keller (5):
  ixgbe: reduce PTP Tx timestamp timeout to 1 second
  ixgbe: fix PTP SDP pin setup on X540 hardware
  ixgbe: use 'cc' instead of 'hw_cc' for local variable
  ixgbe: add a kernel documentation comment for ixgbe_ptp_get_ts_config
  ixgbe: implement support for SDP/PPS output on X550 hardware

Jan Sokolowski (2):
  ixgbe: add tracking of AF_XDP zero-copy state for each queue pair
  ixgbe: remove umem from adapter

Jeff Kirsher (1):
  ice: Use LLDP ethertype define ETH_P_LLDP

Kangjie Lu (1):
  net: ixgbevf: fix a missing check of ixgbevf_write_msg_read_ack

William Tu (2):
  ixgbe: fix AF_XDP tx byte count
  ixgbe: fix AF_XDP tx packet count

 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   1 -
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   2 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 -
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |   4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   6 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 187 ++++++++++++++----
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  82 ++------
 drivers/net/ethernet/intel/ixgbevf/vf.c       |   5 +-
 include/uapi/linux/if_ether.h                 |   1 +
 13 files changed, 200 insertions(+), 124 deletions(-)

-- 
2.21.0

