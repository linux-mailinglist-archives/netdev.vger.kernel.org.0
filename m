Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A181DF546
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgEWGsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:48:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387466AbgEWGst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:48:49 -0400
IronPort-SDR: oEFMIqBWXUMShlEWx+B4XaYsICZStxZGNkHu23pGl5/YtcR0chWxXznckoH2NIJdIUaM00hqak
 XB25tguhpGkw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:48 -0700
IronPort-SDR: mV+dhCg/q3qHu/NlH1HfULRbl4LdlPHVKH0ZgPjw7O0t6HY2Xv27i7SMObAelXnqVZTMcIa6fb
 wa1hSIHiFJ0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966869"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/16][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-22
Date:   Fri, 22 May 2020 23:48:31 -0700
Message-Id: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to virtchnl and the ice driver.

Geert Uytterhoeven fixes a data structure alignment issue in the
virtchnl structures.

Henry adds Flow Director support which allows for the redirection on
ntuple rules over six patches.  Initially Henry adds the initial
infrastructure for Flow Director, and then later adds IPv4 and IPv6
support, as well as being able to display the ntuple rules.

Bret add Accelerated Receive Flow Steering (aRFS) support which is used
to steer receive flows to a specific queue.  Fixes a transmit timeout
when the VF link transitions from up/down/up because the transmit and
receive queue interrupts are not enabled as part of VF's link up.  Fixed
an issue when the default VF LAN address is changed and after reset the
PF will attempt to add the new MAC, which fails because it already
exists. This causes the VF to be disabled completely until it is removed
and enabled via sysfs.

Anirudh (Ani) makes a fix where the ice driver needs to call set_mac_cfg
to enable jumbo frames, so ensure it gets called during initialization
and after reset.  Fix bad register reads during a register dump in
ethtool by removing the bad registers.

Paul fixes an issue where the receive Malicious Driver Detection (MDD)
auto reset message was not being logged because it occurred after the VF
reset.

Victor adds a check for compatibility between the Dynamic Device
Personalization (DDP) package and the NIC firmware to ensure that
everything aligns.

Jesse fixes a administrative queue string call with the appropriate
error reporting variable.  Also fixed the loop variables that are
comparing or assigning signed against unsigned values.

The following are changes since commit 593532668f635d19d207510e0fbb5c2250f56b6f:
  Revert "net: mvneta: speed down the PHY, if WoL used, to save energy"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (2):
  ice: Call ice_aq_set_mac_cfg
  ice: Fix bad register reads

Brett Creeley (3):
  ice: Implement aRFS
  ice: Fix Tx timeout when link is toggled on a VF's interface
  ice: Check if unicast MAC exists before setting VF MAC

Geert Uytterhoeven (1):
  virtchnl: Add missing explicit padding to structures

Henry Tieman (6):
  ice: Initialize Flow Director resources
  ice: Support displaying ntuple rules
  ice: Support IPv4 Flow Director filters
  ice: Support IPv6 Flow Director filters
  ice: Enable flex-bytes support
  ice: Restore filters following reset

Jesse Brandeburg (2):
  ice: fix usage of incorrect variable
  ice: cleanup unsigned loops

Paul Greenwalt (1):
  ice: print Rx MDD auto reset message before VF reset

Victor Raj (1):
  ice: check for compatibility between DDP package and firmware

 drivers/net/ethernet/intel/ice/Makefile       |    3 +
 drivers/net/ethernet/intel/ice/ice.h          |   53 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   34 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c     |  663 +++++++
 drivers/net/ethernet/intel/ice/ice_arfs.h     |   82 +
 drivers/net/ethernet/intel/ice/ice_base.c     |    1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  105 ++
 drivers/net/ethernet/intel/ice/ice_common.h   |    2 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |    9 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   47 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 1672 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  840 +++++++++
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  166 ++
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  376 +++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |    3 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |    8 +-
 drivers/net/ethernet/intel/ice/ice_flow.c     |  319 +++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   44 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   26 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  101 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  228 ++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  272 ++-
 .../ethernet/intel/ice/ice_protocol_type.h    |    2 +
 drivers/net/ethernet/intel/ice/ice_status.h   |    2 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |   75 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |    7 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  182 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   10 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   59 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  120 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |    2 +
 include/linux/avf/virtchnl.h                  |    5 +
 33 files changed, 5407 insertions(+), 113 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_arfs.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_arfs.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fdir.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fdir.h

-- 
2.26.2

