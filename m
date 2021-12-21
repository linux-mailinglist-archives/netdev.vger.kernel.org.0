Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511FF47C5D5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhLUSJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:9404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236990AbhLUSJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110143; x=1671646143;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3cPi1KAh3T7NJbD1mUxn1C80VNeFN9OZ23XXYJ7EJ5E=;
  b=Q62NLDG1QEPYXd2offvNm0QJUNCKJU1EyCliETaC2ohFhVhU8cy5riGR
   UoAGCM7bmIqD6y2wtw4V+9T2mVOiJju2nnc0gO1ShSCJxwj0dN0Vemd7q
   yIfNubudyFLJ1BwgSoGVHvsiwnv/sFbzXksK2xjyYfoU+hCC15s6Nt4wM
   t3AwnCa1zQUd4jULtBOaQoBniUH4pz6UHgcfN5L2dn+Vg2IoxzAS6UciR
   GPo6evGLwAAdXm9ULaVm7UVqyabn+mkPpRrcdARVwhRVchcPYM5JZ0jRK
   +qfq+tzPig9dj/KvHLnxA50fPU5ZoE00oJ30MncrWyc6mR9eRC4o1gaSR
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264831"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264831"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342474"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com
Subject: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN Driver Updates 2021-12-21
Date:   Tue, 21 Dec 2021 09:48:35 -0800
Message-Id: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Karol modifies the reset flow to correct issues with PTP reset.

Jake extends PTP support for E822 based devices. This includes a few
cleanup patches, that fix some minor issues. In addition, there are some
slight refactors to ease the addition of E822 support, followed by adding
the new hardware implementation ice_ptp_hw.c.

There are a few major differences with E822 support compared to E810
support:

*) The E822 device has a Clock Generation Unit which must be initialized in
order to generate proper clock frequencies on the output that drives the PTP
hardware clock registers

*) The E822 PHY is a bit different and requires a more complex
initialization procedure which must be rerun any time the link configuration
changes.

*) The E822 devices support enhanced timestamp calibration by making use of
a process called Vernier offset measurement. This allows the hardware to
measure phase offset related to the PHY clocks for Serdes and FEC, reducing
the inaccuracy of the timestamp relative to the actual packet transmission
and receipt. Making use of this requires data gathered from the first
transmitted and received packets, and waiting for the PHY to complete the
calibration measurements. This is done as part of a new kthread, ov_work.
Note that to avoid delay in enabling timestamps, we start the PHY in
'bypass' mode which allows timestamps to be captured without the Vernier
calibration measurement. Once the first packets have been sent and received,
we then complete the calibration setup and exit bypass mode and begin using
the more precise timestamps. According to the datasheet, timestamps without
calibration data can be incorrect relative to actual receipt or transmission
by up to 1 clock cycle (~1.25 nanoseconds), while calibrated timestamps
should be correct to within 1/8th of a clock cycle (~0.15 nanoseconds).

*) E822 devices support crosstimestamping via PCIe PTM, which we enable when
available on the platform.

There is a fair amount of logic required to perform PHY and CGU
initialization, which is the vast majority of the new code, but it is fairly
self contained within ice_ptp_hw.c, with the exception of monitoring for
offset validity being handled by a kthread.

The following are changes since commit 294e70c952b494918f139670cf5a89839a2e03e6:
  Merge tag 'mac80211-next-for-net-next-2021-12-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Jacob Keller (9):
  ice: introduce ice_base_incval function
  ice: PTP: move setting of tstamp_config
  ice: use 'int err' instead of 'int status' in ice_ptp_hw.c
  ice: introduce ice_ptp_init_phc function
  ice: convert clk_freq capability into time_ref
  ice: implement basic E822 PTP support
  ice: ensure the hardware Clock Generation Unit is configured
  ice: exit bypass mode once hardware finishes timestamp calibration
  ice: support crosstimestamping on E822 devices if supported

Karol Kolacinski (1):
  ice: Fix E810 PTP reset flow

 drivers/net/ethernet/intel/Kconfig            |   10 +
 drivers/net/ethernet/intel/ice/ice_cgu_regs.h |  116 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   12 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    9 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   15 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  854 ++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |   38 +-
 .../net/ethernet/intel/ice/ice_ptp_consts.h   |  374 +++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 2814 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  345 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   23 +-
 11 files changed, 4367 insertions(+), 243 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_cgu_regs.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_consts.h

-- 
2.31.1

