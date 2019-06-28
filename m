Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181855A731
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfF1WtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:51493 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF1WtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039119"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] Intel Wired LAN Driver Updates 2019-06-28
Date:   Fri, 28 Jun 2019 15:49:17 -0700
Message-Id: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a smorgasbord of updates to many of the Intel
drivers.

Gustavo A. R. Silva updates the ice and iavf drivers to use the
strcut_size() helper where possible.

Miguel increases the pause and refresh time for flow control in the
e1000e driver during reset for certain devices.

Dann Frazier fixes a potential NULL pointer dereference in ixgbe driver
when using non-IPSec enabled devices.

Colin Ian King fixes a potential overflow during a shift in the ixgbe
driver.  Also fixes a potential NULL pointer dereference in the iavf
driver by adding a check.

Venkatesh Srinivas converts the e1000 driver to use dma_wmb() instead of
wmb() for doorbell writes to avoid SFENCEs in the transmit and receive
paths.

Arjan updates the e1000e driver to improve boot time by over 100 msec by
reducing the usleep ranges suring system startup.

Artem updates the igb driver register dump in ethtool, first prepares
the register dump for future additions of registers in the dump, then
secondly, adds the RR2DCDELAY register to the dump.  When dealing with
time-sensitive networks, this register is helpful in determining your
latency from the device to the ring.

Alex fixes the ixgbevf driver to use the current cached link state,
rather than trying to re-check the value from the PF.

Harshitha adds support for MACVLAN offloads in i40e by using channels as
MACVLAN interfaces.

Detlev Casanova updates the e1000e driver to use delayed work instead of
timers to run the watchdog.

Vitaly fixes an issue in e1000e, where when disconnecting and
reconnecting the physical cable connection, the NIC enters a DMoff
state.  This state causes a mismatch in link and duplexing, so check the
PCIm function state and perform a PHY reset when in this state to
resolve the issue.

The following are changes since commit 5cdda5f1d6adde02da591ca2196f20289977dc56:
  ipv4: enable route flushing in network namespaces
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 10GbE

Alexander Duyck (1):
  ixgbevf: Use cached link state instead of re-reading the value for
    ethtool

Arjan van de Ven (1):
  e1000e: Reduce boot time by tightening sleep ranges

Artem Bityutskiy (2):
  igb: minor ethool regdump amendment
  igb: add RR2DCDELAY to ethtool registers dump

Colin Ian King (2):
  ixgbe: fix potential u32 overflow on shift
  iavf: fix dereference of null rx_buffer pointer

Dann Frazier (1):
  ixgbe: Avoid NULL pointer dereference with VF on non-IPsec hw

Detlev Casanova (1):
  e1000e: Make watchdog use delayed work

Gustavo A. R. Silva (2):
  ice: Use struct_size() helper
  iavf: use struct_size() helper

Harshitha Ramamurthy (1):
  i40e: Add macvlan support on i40e

Jeff Kirsher (1):
  iavf: Fix up debug print macro

Miguel Bernal Marin (1):
  e1000e: Increase pause and refresh time

Venkatesh Srinivas (1):
  e1000: Use dma_wmb() instead of wmb() before doorbell writes

Vitaly Lifshits (1):
  e1000e: PCIm function state support

 drivers/net/ethernet/intel/e1000/e1000_main.c |   6 +-
 .../net/ethernet/intel/e1000e/80003es2lan.c   |   2 +-
 drivers/net/ethernet/intel/e1000e/82571.c     |   2 +-
 drivers/net/ethernet/intel/e1000e/defines.h   |   3 +
 drivers/net/ethernet/intel/e1000e/e1000.h     |   5 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  14 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c   |  20 +-
 drivers/net/ethernet/intel/e1000e/mac.c       |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  90 ++--
 drivers/net/ethernet/intel/e1000e/nvm.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |  27 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 497 +++++++++++++++++-
 drivers/net/ethernet/intel/iavf/iavf_osdep.h  |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   6 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  37 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   4 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h   |   2 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  75 +--
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |  14 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  10 +-
 21 files changed, 686 insertions(+), 145 deletions(-)

-- 
2.21.0

