Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795181E97A0
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgEaMgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:12463 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgEaMgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:21 -0400
IronPort-SDR: dBH0rBuo9GZ1Tm9sNGZ/njDk/JNwLMDziHYi0wbLqHONP/Wle+0+Ma2ctcmOGHoNvq91R9OWUA
 RHQfvEfi/65g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:21 -0700
IronPort-SDR: BFQf2XI1uePWRZl95njq7Asw+VVraWPtAqYSYmPsekupRvMC2fhehGBU23060hVzCJS+NcGrQ8
 dv3odiMg3Lqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345413"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-31
Date:   Sun, 31 May 2020 05:36:05 -0700
Message-Id: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Brett modifies the driver to allow users to clear a VF's
administratively set MAC address on the PF.  Fixes the driver to
recognize an existing VLAN tag when DMAC/SMAC is enabled in a packet.
Fixes an issue, so that VF's are reset after any VF port VLAN
modifications are made on the PF.  Made sure the register QRXFLXP_CNTXT
is cleared before writing a new value to ensure the previous value is
not passed forward.  Updates the PF to allow the VF to request a reset
as soon as it has been initialized.  Fixes an issue to ensure when a VSI
is created, it uses the current coalesce value, not the default value.

Paul allows untrusted VF's to add 16 filters.

Dan increases the timeout needed after a PFR to allow ample time for
package download.

Chinh adjust the define value for the number of PHY speeds we currently
support.  Changes the driver to ignore EMODE error when configuring the
PHY.

Jesse fixes an issue which was preventing a user from configuring the
interface before bringing it up.

Henry fixes the logic for adding back perfect flows after flow director
filter does a deletion.

Bruce fixes line wrappings to make it more consistent.

The following are changes since commit 39884604b11692158ce0c559fc603510b96f8c2e:
  mptcp: fix NULL ptr dereference in MP_JOIN error path
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Brett Creeley (6):
  ice: allow host to clear administratively set VF MAC
  ice: Fix transmit for all software offloaded VLANs
  ice: Reset VF for all port VLAN changes from host
  ice: Always clear QRXFLXP_CNTXT before writing new value
  ice: Allow VF to request reset as soon as it's initialized
  ice: Use coalesce values from q_vector 0 when increasing q_vectors

Bruce Allan (1):
  ice: fix function signature style format

Chinh T Cao (2):
  ice: Update ICE_PHY_TYPE_HIGH_MAX_INDEX value
  ice: Ignore EMODE when setting PHY config

Dan Nowlin (1):
  ice: Increase timeout after PFR

Henry Tieman (1):
  ice: fix aRFS after flow director delete

Jesse Brandeburg (1):
  ice: Fix inability to set channels when down

Paul Greenwalt (1):
  ice: support adding 16 unicast/multicast filter on untrusted VF

Paul M Stillwell Jr (1):
  ice: fix PCI device serial number to be lowercase values

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  3 +-
 drivers/net/ethernet/intel/ice/ice_base.c     | 33 ++++------
 drivers/net/ethernet/intel/ice/ice_common.c   | 14 +++-
 drivers/net/ethernet/intel/ice/ice_controlq.c |  3 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 28 +++-----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  4 --
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 27 +++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 40 ++++++++---
 drivers/net/ethernet/intel/ice/ice_lib.h      |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    | 12 ++--
 drivers/net/ethernet/intel/ice/ice_switch.c   |  9 +--
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 45 +++----------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 66 ++++++-------------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  5 +-
 16 files changed, 142 insertions(+), 156 deletions(-)

-- 
2.26.2

