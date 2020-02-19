Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48133165219
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBSWG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:06:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:51315 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgBSWG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:06:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824799"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/13][pull request] 100GbE Intel Wired LAN Driver Updates 2020-02-19
Date:   Wed, 19 Feb 2020 14:06:39 -0800
Message-Id: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Avinash adds input validation for software DCB configurations received
via lldptool or pcap to ensure bad bandwidth inputs are not inputted
which could cause the loss of link.

Paul update the malicious driver detection event messages to rate limit
once per second and to include the total number of receive|transmit MDD
event count.

Dan updates how TCAM entries are managed to ensure when overriding
pre-existing TCAM entries, properly delete the existing entry and remove
it from the change/update list.

Brett ensures we clear the relevant values in the QRXFLXP_CNTXT register
for VF queues to ensure the receive queue data is not stale.

Avinash adds required DCBNL operations for configuring ETS in software
DCB CEE mode.  Also added code to detect if DCB is in IEEE or CEE mode
to properly report what mode we are in.

Dave fixes the driver to properly report the current maximum TC, not the
maximum allowed number of TCs.

Krzysztof adds support for AF_XDP feature in the ice driver.

Jake increases the maximum time that the driver will wait for a PR reset
to account for possibility of a slightly longer than expected PD reset.

Jesse fixes a number of strings which did not have line feeds, so add
line feeds so that messages do not rum together, creating a jumbled
mess.

Bruce adds support for additional E810 and E823 device ids.  Also
updated the product name change for E822 devices.

The following are changes since commit 7d51a01599d5285fc94fa4fcea10afabfa9ca5a4:
  net: mvneta: align xdp stats naming scheme to mlx5 driver
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Avinash Dayanand (2):
  ice: Validate config for SW DCB map
  ice: Report correct DCB mode

Avinash JD (1):
  ice: Add DCBNL ops required to configure ETS in CEE for SW DCB

Brett Creeley (1):
  ice: Always clear the QRXFLXP_CNTXT register for VF Rx queues

Bruce Allan (3):
  ice: add additional E810 device id
  ice: add support for E823 devices
  ice: fix define for E822 backplane device

Dan Nowlin (1):
  ice: Fix for TCAM entry management

Dave Ertman (1):
  ice: SW DCB, report correct max TC value

Jacob Keller (1):
  ice: increase PF reset wait timeout to 300 milliseconds

Jesse Brandeburg (1):
  ice: add backslash-n to strings

Krzysztof Kazimierczak (1):
  ice: Support XDP UMEM wake up mechanism

Paul Greenwalt (1):
  ice: update malicious driver detection event handling

 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_base.c     |  11 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  67 +++++++-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  58 ++++++-
 drivers/net/ethernet/intel/ice/ice_devids.h   |  26 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   9 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  65 ++++++--
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 151 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  32 ++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  58 ++++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  20 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  24 ++-
 15 files changed, 414 insertions(+), 117 deletions(-)

-- 
2.24.1

