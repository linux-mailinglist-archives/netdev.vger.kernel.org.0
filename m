Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513D03A4659
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhFKQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:16322 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhFKQTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:39 -0400
IronPort-SDR: GymGEwo8BrAWlY9WzIGO6BiHZIkDJ7n9h6/+UVcPtxdpLrC/kCuk+h6HZM08Lc6gJo2TXVXysO
 4LUTxYIBhoeg==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404867"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404867"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:26 -0700
IronPort-SDR: oyqQnuwLKypu4fzUGxfg/FQE7QfPICa6J/Su48ujQrAAMWyH5/IVsU+BEJvQOvrunhSxCjzTZ1
 N55vgm2P9XaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423479"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, richardcochran@gmail.com,
        jacob.e.keller@intel.com
Subject: [PATCH net-next 0/8][pull request] 100GbE Intel Wired LAN Driver Updates 2021-06-11
Date:   Fri, 11 Jun 2021 09:19:52 -0700
Message-Id: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jake Keller says:

Extend the ice driver to support basic PTP clock functionality for E810
devices.

This includes some tangential work required to setup the sideband queue and
driver shared parameters as well.

This series only supports E810-based devices. This is because other devices
based on the E822 MAC use a different and more complex PHY.

The low level device functionality is kept within ice_ptp_hw.c and is
designed to be extensible for supporting E822 devices in a future series.

This series also only supports very basic functionality including the
ptp_clock device and timestamping. Support for configuring periodic outputs
and external input timestamps will be implemented in a future series.

There are a couple of potential "what? why?" bits in this series I want to
point out:

1) the PTP hardware functionality is shared between multiple functions. This
means that the same clock registers are shared across multiple PFs. In order
to avoid contention or clashing between PFs, firmware assigns "ownership" to
one PF, while other PFs are merely "associated" with the timer. Because we
share the hardware resource, only the clock owner will allocate and register
a PTP clock device. Other PFs determine the appropriate PTP clock index to
report by using a firmware interface to read a shared parameter that is set
by the owning PF.

2) the ice driver uses its own kthread instead of using do_aux_work. This is
because the periodic and asynchronous tasks are necessary for all PFs, but
only one PF will allocate the clock.

The series is broken up into functional pieces to allow easy review.

The following are changes since commit 76cf404c40ae8efcf8c6405535a3f6f69e6ba2a5:
  Merge branch 'ipa-mem-2'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (8):
  ice: add support for sideband messages
  ice: process 1588 PTP capabilities during initialization
  ice: add support for set/get of driver-stored firmware parameters
  ice: add low level PTP clock access functions
  ice: register 1588 PTP clock device object for E810 devices
  ice: report the PTP clock index in ethtool .get_ts_info
  ice: enable receive hardware timestamping
  ice: enable transmit timestamps for E810 devices

 drivers/net/ethernet/intel/Kconfig            |    1 +
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |    8 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   41 +
 drivers/net/ethernet/intel/ice/ice_base.c     |   14 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  243 ++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   10 +
 drivers/net/ethernet/intel/ice/ice_controlq.c |   62 +
 drivers/net/ethernet/intel/ice/ice_controlq.h |    2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   27 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   69 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   20 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    3 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   95 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 1269 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  161 +++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  653 +++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |   79 +
 drivers/net/ethernet/intel/ice/ice_sbq_cmd.h  |   92 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   37 +
 drivers/net/ethernet/intel/ice/ice_txrx.h     |    5 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |    3 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   62 +
 include/linux/kernel.h                        |   12 +
 24 files changed, 2962 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_hw.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_hw.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_sbq_cmd.h

-- 
2.26.2

