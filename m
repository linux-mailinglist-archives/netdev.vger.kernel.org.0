Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECB21E5883
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgE1HZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:14688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgE1HZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:42 -0400
IronPort-SDR: qRpRkhym743TmYT4nLTu3mlsLRjbrWz9EKSSmrh89vtQN3ss7jbcs0R+lWNrp5rU/8wSpHIBhj
 fJtVrn49VUyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:40 -0700
IronPort-SDR: 4+MMjqQhsa9Vr/06/FirMi0Dzz0CHsizXu0KoMAr3+P9Vrd9ip9LEueWsXF4SrBOsITp2GuZi8
 ZnuzSBlwklCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831093"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:39 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-27
Date:   Thu, 28 May 2020 00:25:23 -0700
Message-Id: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Jesse fixes a number of issues, starting with fixing the remaining
signed versus unsigned comparison issues.  Cleaned up an unused code
define.  Fixed the implementation of the manage MAC write command, to
simplify it by using a simple array to represent the MAC address when
writing it.

Paul fixes the setting of the VF default LAN address, by removing a
check that assumed that the address had been deleted and zeroed.

Surabhi prevents a memory leak on filter management initialization
failures and during queue initialization and buffer allocation failures.

Brett adds additional receive error counters that are reported by
ethtool.  Fixed the enabling and disabling of VLAN stripping when the
PVID has been set.

Evan fixes a race condition between the firmware and software, which can
occur between the admin queue setup and the first command sent.

Marta fixes the driver when XDP transmit rings are destroyed, also make
sure the XDP transmit queues are also destroyed.  Update the statistics
when XDP transmit programs are loaded and packets are sent.  Changed the
number of XDP transmit queues to match the number of receive queues,
instead of matching the number of transmit queues.

Bruce avoids undefined behavior by not writing the 8-bit element
init_q_state with the associated internal-to-hardware field which is
122-bits.

Anirudh (Ani) refactors the receive checksum checks.

Krzysztof notifies the user if the fill queue is not long enough to
prepare all buffers before packet processing starts and allocates the
buffers during the NAPI poll.

The following are changes since commit 50ce4c099bebf56be86c9448f7f4bcd34f33663c:
  sctp: fix typo sctp_ulpevent_nofity_peer_addr_change
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Refactor Rx checksum checks

Brett Creeley (2):
  ice: Add more Rx errors to netdev's rx_error counter
  ice: Don't allow VLAN stripping change when pvid set

Bruce Allan (1):
  ice: avoid undefined behavior

Evan Swanson (1):
  ice: Handle critical FW error during admin queue initialization

Jesse Brandeburg (3):
  ice: fix signed vs unsigned comparisons
  ice: remove unused macro
  ice: fix MAC write command

Krzysztof Kazimierczak (1):
  ice: Check UMEM FQ size when allocating bufs

Marta Plantykow (3):
  ice: Change number of XDP TxQ to 0 when destroying rings
  ice: Add XDP Tx to VSI ring stats
  ice: Change number of XDP Tx queues to match number of Rx queues

Paul Greenwalt (1):
  ice: set VF default LAN address

Surabhi Boob (2):
  ice: Fix memory leak
  ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  10 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  39 ++--
 drivers/net/ethernet/intel/ice/ice_common.c   |  25 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   3 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c | 175 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_controlq.h |   3 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |   2 -
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  65 +++++--
 drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   7 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  27 ++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   8 +-
 15 files changed, 234 insertions(+), 143 deletions(-)

-- 
2.26.2

