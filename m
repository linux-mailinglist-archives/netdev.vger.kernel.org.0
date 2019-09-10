Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6FBAEFAC
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436802AbfIJQeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:34:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:21105 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbfIJQeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 12:34:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 09:34:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="184223722"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 10 Sep 2019 09:34:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/14][pull request] Intel Wired LAN Driver Updates 2019-09-10
Date:   Tue, 10 Sep 2019 09:34:20 -0700
Message-Id: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e, ixgbe/vf and iavf.

Wenwen Wang fixes a potential memory leak where 3 allocated variables
are not properly cleaned up on failure for ixgbe.

Stefan Assmann fixes a potential kernel panic found when repeatedly
spawning and destroying VFs in i40e when a NULL pointer is dereferenced
due to a race condition.  Fixed up the i40e driver to clear the
__I40E_VIRTCHNL_OP_PENDING bit before returning after an invalid
minimum transmit rate is requested.  Updates the iavf driver to only
apply the MAC address change when the PF ACK's the requested change.

Tonghao Zhang updates ixgbe to use the skb_get_queue_mapping() API call
instead of the driver accessing the queue mapping directly.

Jake updates i40e to use ktime_get_real_ts64() instead of
ktime_to_timespec64().  Removes the define for bit 0x0001 for cloud
filters, since it is a reserved bit and not a valid type.  Also added
code comments to clearly state which bits are reserved and should not be
used or defined for cloud filter adminq command.  Clarify the macros
used to specify the cloud filter fields are individual bits, so use the
BIT() macro.

Aleksandr fixes up the print_link_message() to include the "negotiated"
FEC status for i40e.

Czeslaw also adds additional log message for devices without FEC in the
print_link_message() for i40e.

Alex fixes up the adaptive ITR scheme for ixgbe which could result in a
value that was either 0 or something less than 10 which was causing
issues with hardware features, like RSC, that do not function well with
ITR values that low.

Colin Ian King reduces the object code size by making the array API
static constant.

Magnus fixes a potential receive buffer starvation issue for AF_XDP by
kicking the NAPI context of any queue with an attached AF_XDP zero-copy
socket.

The following are changes since commit c21815f1c199a2ffb77aa862206b0f8d94263d14:
  net/mlx4_en: ethtool: make array modes static const, makes object smaller
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Aleksandr Loktionov (1):
  i40e: fix missed "Negotiated" string in i40e_print_link_message()

Alexander Duyck (1):
  ixgbe: Prevent u8 wrapping of ITR value to something less than 10us

Colin Ian King (1):
  net/ixgbevf: make array api static const, makes object smaller

Czeslaw Zagorski (1):
  i40e: Fix message for other card without FEC.

Jacob Keller (4):
  i40e: use ktime_get_real_ts64 instead of ktime_to_timespec64
  i40e: remove I40E_AQC_ADD_CLOUD_FILTER_OIP
  i40e: mark additional missing bits as reserved
  i40e: use BIT macro to specify the cloud filter field flags

Magnus Karlsson (1):
  i40e: fix potential RX buffer starvation for AF_XDP

Stefan Assmann (3):
  i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask
  i40e: clear __I40E_VIRTCHNL_OP_PENDING on invalid min Tx rate
  iavf: fix MAC address setting for VFs when filter is rejected

Tonghao Zhang (1):
  ixgbe: use skb_get_queue_mapping in tx path

Wenwen Wang (1):
  ixgbe: fix memory leaks

 drivers/net/ethernet/intel/i40e/i40e.h        | 10 +++----
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  5 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 30 ++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  2 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  5 ++++
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 -
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  7 +++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 +++++--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 14 +++++----
 10 files changed, 60 insertions(+), 27 deletions(-)

-- 
2.21.0

