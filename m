Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2E1E7121
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437934AbgE2AIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:2081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437671AbgE2AId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:33 -0400
IronPort-SDR: kIk3lE1IqPk3ZxfsWdysqL4hm5qPetGvE28bY1h4hF0Yihp6sKLbXMtka2mm4HY6Bm436x2d4j
 uwtep64C9sVw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:32 -0700
IronPort-SDR: n0z5Im1zLAkzqmTyWu3IS8glBo8veEtqMA86mq79YP6x9PYxNDf655dLe8z7xIkoNl+TxplY8U
 VGD5b+PsWv1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651608"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:32 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-05-28
Date:   Thu, 28 May 2020 17:08:16 -0700
Message-Id: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Anirudh (Ani) adds a poll for reset completion before proceeding with
driver initialization when the DDP package fails to load and the firmware
issues a core reset.

Jake cleans up unnecessary code, since ice_set_dflt_vsi_ctx() performs a
memset to clear the info from the context structures.  Fixed a potential
double free during probe unrolling after a failure.  Also fixed a
potential NULL pointer dereference upon register_netdev() failure.

Tony makes two functions static which are not called outside of their
file.

Brett refactors the ice_ena_vf_mappings(), which was doing the VF's MSIx
and queue mapping in one function which was hard to digest.  So create a
new function to handle the enabling MSIx mappings and another function
to handle the enabling of queue mappings.  Simplify the code flow in
ice_sriov_configure().  Created a helper function for clearing
VPGEN_VFRTRIG register, as this needs to be done on reset to notify the
VF that we are done resetting it.  Fixed the initialization/creation and
reset flows, which was unnecessarily complicated, so separate the two
flows into their own functions.  Renamed VF initialization functions to
make it more clear what they do and why.  Added functionality to set the
VF trust mode bit on reset.  Added helper functions to rebuild the VLAN
and MAC configurations when resetting a VF.  Refactored how the VF reset
is handled to prevent VF reset timeouts.

Paul cleaned up code not needed during a CORER/GLOBR reset.

The following are changes since commit b113cabd4378ddd98dccdd7748a16f9f1f094ef0:
  sfc: avoid an unused-variable warning
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Poll for reset completion when DDP load fails

Brett Creeley (9):
  ice: Refactor ice_ena_vf_mappings to split MSIX and queue mappings
  ice: Simplify ice_sriov_configure
  ice: Add helper function for clearing VPGEN_VFRTRIG
  ice: Separate VF VSI initialization/creation from reset flow
  ice: Renaming and simplification in VF init path
  ice: Add function to set trust mode bit on reset
  ice: Add functions to rebuild host VLAN/MAC config for a VF
  ice: Refactor VF reset
  ice: Refactor VF VSI release and setup functions

Jacob Keller (3):
  ice: cleanup VSI context initialization
  ice: fix potential double free in probe unrolling
  ice: fix kernel BUG if register_netdev fails

Paul Greenwalt (1):
  ice: remove VM/VF disable command on CORER/GLOBR reset

Tony Nguyen (1):
  ice: Declare functions static

 drivers/net/ethernet/intel/ice/ice_lib.c      |   1 -
 drivers/net/ethernet/intel/ice/ice_main.c     |  25 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   5 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   4 -
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 768 +++++++++++-------
 5 files changed, 507 insertions(+), 296 deletions(-)

-- 
2.26.2

