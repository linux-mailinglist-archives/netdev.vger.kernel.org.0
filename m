Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78FE204382
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbgFVWXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:23:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:12158 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbgFVWXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:23:35 -0400
IronPort-SDR: t7qIknlRtz9GOaVSn1Ys/7X2L2CHvvZLkLjPMwJsTUSWAo3kBIM5EFmu7w5NI1ob/s958bNltt
 2nlLAHJSyXaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="145393912"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="145393912"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:18:20 -0700
IronPort-SDR: kb2hZt6eIOJSo4N4Akzt8sNPKjJEd+JAAHGXIzy35ao2d92lzyzxNvJxw7GxTqkgZyJNZRosgk
 sshkpDI7j0dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="311075793"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2020 15:18:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/9][pull request] 40GbE Intel Wired LAN Driver Updates 2020-06-22
Date:   Mon, 22 Jun 2020 15:18:08 -0700
Message-Id: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver and removes the individual
driver versions from all of the Intel wired LAN drivers.

Shiraz moves the client header so that it can easily be shared between
the i40e LAN driver and i40iw RDMA driver.

Jesse cleans up the unused defines, since they are just dead weight.

Alek reduces the unreasonably long wait time for a PF reset after reboot
by using jiffies to limit the maximum wait time for the PF reset to
succeed.  Added additional logging to let the user know when the driver
transitions into recovery mode.  Adds new device support for our 5 Gbps
NICs.

Todd adds a check to see if MFS is set after warm reboot and notifies
the user when MFS is set to anything lower than the default value.

Arkadiusz fixes a possible race condition, where were holding a
spin-lock while in atomic context.

Qian Cai resolves a UBSAN false positive about an array index that is
out of bounds.

The following are changes since commit 29a720c1042f469c8fea317cb5e7f496b116e07d:
  Merge branch 'Marvell-mvpp2-improvements'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Aleksandr Loktionov (2):
  i40e: Add support for 5Gbps cards
  i40e: Remove scheduling while atomic possibility

Jeff Kirsher (1):
  net/intel: remove driver versions from Intel drivers

Jesse Brandeburg (1):
  i40e: remove unused defines

Piotr Kwapulinski (2):
  i40e: make PF wait reset loop reliable
  i40e: detect and log info about pre-recovery mode

Qian Cai (1):
  i40e: silence an UBSAN false positive

Shiraz Saleem (1):
  i40e: Move client header location

Todd Fujinaka (1):
  i40e: Add a check to see if MFS is set

 drivers/infiniband/hw/i40iw/Makefile          |    1 -
 drivers/infiniband/hw/i40iw/i40iw.h           |    2 +-
 drivers/net/ethernet/intel/e100.c             |    6 +-
 drivers/net/ethernet/intel/e1000/e1000.h      |    1 -
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |    2 -
 drivers/net/ethernet/intel/e1000/e1000_main.c |    5 +-
 drivers/net/ethernet/intel/e1000e/e1000.h     |    1 -
 drivers/net/ethernet/intel/e1000e/ethtool.c   |    2 -
 drivers/net/ethernet/intel/e1000e/netdev.c    |    8 +-
 drivers/net/ethernet/intel/fm10k/fm10k.h      |    1 -
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |    2 -
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |    5 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |   23 +-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  482 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |    7 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    |    5 -
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |    1 -
 drivers/net/ethernet/intel/i40e/i40e_devids.h |    7 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |    2 -
 drivers/net/ethernet/intel/i40e/i40e_hmc.h    |    1 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  125 +-
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  |    1 -
 .../net/ethernet/intel/i40e/i40e_register.h   | 4658 +----------------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   25 -
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   81 -
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  226 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |    1 -
 drivers/net/ethernet/intel/iavf/iavf.h        |    1 -
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |    1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   14 +-
 drivers/net/ethernet/intel/iavf/iavf_type.h   |    8 -
 drivers/net/ethernet/intel/ice/ice.h          |    1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |    1 -
 drivers/net/ethernet/intel/ice/ice_main.c     |   22 +-
 drivers/net/ethernet/intel/igb/igb.h          |    1 -
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |    1 -
 drivers/net/ethernet/intel/igb/igb_main.c     |   11 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c    |    2 -
 drivers/net/ethernet/intel/igbvf/igbvf.h      |    1 -
 drivers/net/ethernet/intel/igbvf/netdev.c     |    5 +-
 drivers/net/ethernet/intel/igc/igc.h          |    1 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |    1 -
 drivers/net/ethernet/intel/igc/igc_main.c     |    7 +-
 drivers/net/ethernet/intel/ixgb/ixgb.h        |    1 -
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |    2 -
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |    1 -
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |    2 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |    1 -
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |    7 +-
 .../linux/net/intel}/i40e_client.h            |    5 -
 55 files changed, 245 insertions(+), 5556 deletions(-)
 rename {drivers/net/ethernet/intel/i40e => include/linux/net/intel}/i40e_client.h (96%)

-- 
2.26.2

