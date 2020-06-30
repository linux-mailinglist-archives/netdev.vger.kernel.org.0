Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B5520EADF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgF3B1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:27:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:52168 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgF3B1u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:50 -0400
IronPort-SDR: Mg2yqgbuWUff2E5hu1l2OdSUfc3hXuVxdJEqN8/XE4RcNfvUbs1Lxw3AIrOimhdqDAfbFjQIYt
 xx7L/nlNjjOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144305919"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144305919"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:50 -0700
IronPort-SDR: vrLQSUiLXyXbKMTelOQ04ea2yjBA+HIp24qZaPGm+ZduDZx6ZES0mZTO93PTK3/086UvPClVXv
 LwClA/72Hc8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017689"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/13][pull request] 1GbE Intel Wired LAN Driver Updates 2020-06-29
Date:   Mon, 29 Jun 2020 18:27:35 -0700
Message-Id: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to only the igc driver.

Sasha added Energy Efficient Ethernet (EEE) support and Latency Tolerance
Reporting (LTR) support for the igc driver. Added Low Power Idle (LPI)
counters and cleaned up unused TCP segmentation counters. Removed
igc_power_down_link() and call igc_power_down_phy_copper_base()
directly. Removed unneeded copper media check. 

Andre cleaned up timestamping by removing un-supported features and
duplicate code for i225. Fixed the timestamp check on the proper flag
instead of the skb for pending transmit timestamps. Refactored
igc_ptp_set_timestamp_mode() to simply the flow.

v2: Removed the log message in patch 1 as suggested by David Miller.
    Note: The locking issue Jakub Kicinski saw in patch 5, currently
    exists in the current net-next tree, so Andre will resolve the
    locking issue in a follow-on patch.

The following are changes since commit b8483ecaf72ee9059dcca5de969781028a550f89:
  liquidio: use list_empty_careful in lio_list_delete_head
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (6):
  igc: Clean up Rx timestamping logic
  igc: Remove duplicate code in Tx timestamp handling
  igc: Check __IGC_PTP_TX_IN_PROGRESS instead of ptp_tx_skb
  igc: Remove UDP filter setup in PTP code
  igc: Refactor igc_ptp_set_timestamp_mode()
  igc: Fix Rx timestamp disabling

Sasha Neftin (7):
  igc: Add initial EEE support
  igc: Add initial LTR support
  igc: Add LPI counters
  igc: Remove TCP segmentation TX fail counter
  igc: Refactor the igc_power_down_link()
  igc: Remove unneeded check for copper media type
  igc: Remove checking media type during MAC initialization

 drivers/net/ethernet/intel/igc/igc.h         |   7 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  39 ++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  95 +++++++
 drivers/net/ethernet/intel/igc/igc_hw.h      |   1 +
 drivers/net/ethernet/intel/igc/igc_i225.c    | 156 +++++++++++
 drivers/net/ethernet/intel/igc/igc_i225.h    |   3 +
 drivers/net/ethernet/intel/igc/igc_mac.c     |  16 +-
 drivers/net/ethernet/intel/igc/igc_main.c    |  48 ++--
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 256 +++++--------------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  16 +-
 10 files changed, 414 insertions(+), 223 deletions(-)

-- 
2.26.2

