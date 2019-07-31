Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895AF7CEDF
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfGaUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:41:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:16005 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfGaUlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901005"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/16][pull request] 100GbE Intel Wired LAN Driver Updates 2019-07-31
Date:   Wed, 31 Jul 2019 13:41:31 -0700
Message-Id: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Paul adds support for reporting what the link partner is advertising for
flow control settings.

Jake fixes the hardware statistics register which is prone to rollover
since the statistic registers are either 32 or 40 bits wide, depending
on which register is being read.  So use a 64 bit software statistic to
store off the hardware statistics to track past when it rolls over.
Fixes an issue with the locking of the control queue, where locks were
being destroyed at run time.

Tony fixes an issue that was created when interrupt tracking was
refactored and the call to ice_vsi_setup_vector_base() was removed from
the PF VSI instead of the VF VSI.  Adds a check before trying to
configure a port to ensure that media is attached.

Brett fixes an issue in the receive queue configuration where prefena
(Prefetch Enable) was being set to 0 which caused the hardware to only
fetch descriptors when there are none free in the cache for a received
packet.  Updates the driver to only bump the receive tail once per
napi_poll call, instead of the current model of bumping the tail up to 4
times per napi_poll call.  Adds statistics for receive drops at the port
level to ethtool/netlink.  Cleans up duplicate code in the allocation of
receive buffer code.

Akeem updates the driver to ensure that VFs stay disabled until the
setup or reset is completed.  Modifies the driver to use the allocated
number of transmit queues per VSI to set up the scheduling tree versus
using the total number of available transmit queues.  Also fix the
driver to update the total number of configured queues, after a
successful VF request to change its number of queues before updating the
corresponding VSI for that VF.  Cleaned up unnecessary flags that are no
longer needed.

The following are changes since commit 6a7ce95d752efa86a1a383385d4f8035c224dc3d:
  staging/octeon: Fix build error without CONFIG_NETDEVICES
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (5):
  ice: Disable VFs until reset is completed
  ice: Set up Tx scheduling tree based on alloc VSI Tx queues
  ice: Update number of VF queue before setting VSI resources
  ice: Don't return error for disabling LAN Tx queue that does exist
  ice: Remove flag to track VF interrupt status

Brett Creeley (5):
  ice: Always set prefena when configuring an Rx queue
  ice: Only bump Rx tail and release buffers once per napi_poll
  ice: Add stats for Rx drops at the port level
  ice: Remove duplicate code in ice_alloc_rx_bufs
  ice: Remove unnecessary flag ICE_FLAG_MSIX_ENA

Jacob Keller (2):
  ice: track hardware stat registers past rollover
  ice: separate out control queue lock creation

Paul Greenwalt (1):
  ice: add lp_advertising flow control support

Tony Nguyen (3):
  ice: Move vector base setup to PF VSI
  ice: Do not configure port with no media
  ice: Bump version number

 drivers/net/ethernet/intel/ice/ice.h          |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  72 +--
 drivers/net/ethernet/intel/ice/ice_common.h   |   6 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c | 112 +++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 104 +++--
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  31 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 128 +++---
 drivers/net/ethernet/intel/ice/ice_main.c     | 416 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  60 +--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  21 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   5 -
 12 files changed, 527 insertions(+), 431 deletions(-)

-- 
2.21.0

