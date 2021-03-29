Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284D234D8EF
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhC2USM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:19969 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhC2UR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:28 -0400
IronPort-SDR: 4odjlPYYxL9k8M65WYZRXYJ+9A3z78DAyE2irDVLSwgpwFwwdRAl9JimXUD3t73btJamq2sTQO
 yy3JuN849kkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160821"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160821"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: EG8L6fj/NL802IIlA/GpuicVevCNjhvBmnWtEDestlisXmH0BExris/mdEYgJl1eehYwKDSwz1
 tZet0FmOLp/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700548"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 6/9] ice: remove DCBNL_DEVRESET bit from PF state
Date:   Mon, 29 Mar 2021 13:18:54 -0700
Message-Id: <20210329201857.3509461-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The original purpose of the ICE_DCBNL_DEVRESET was to protect
the driver during DCBNL device resets.  But, the flow for
DCBNL device resets now consists of only calls up the stack
such as dev_close() and dev_open() that will result in NDO calls
to the driver.  These will be handled with state changes from the
stack.  Also, there is a problem of the dev_close and dev_open
being blocked by checks for reset in progress also using the
ICE_DCBNL_DEVRESET bit.

Since the ICE_DCBNL_DEVRESET bit is not necessary for protecting
the driver from DCBNL device resets and it is actually blocking
changes coming from the DCBNL interface, remove the bit from the
PF state and don't block driver function based on DCBNL reset in
progress.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h        | 1 -
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 2 --
 drivers/net/ethernet/intel/ice/ice_lib.c    | 1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1d4518638215..7934f0d17277 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -196,7 +196,6 @@ enum ice_state {
 	__ICE_NEEDS_RESTART,
 	__ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
 	__ICE_RESET_OICR_RECV,		/* set by driver after rcv reset OICR */
-	__ICE_DCBNL_DEVRESET,		/* set by dcbnl devreset */
 	__ICE_PFR_REQ,			/* set by driver and peers */
 	__ICE_CORER_REQ,		/* set by driver and peers */
 	__ICE_GLOBR_REQ,		/* set by driver and peers */
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 468a63f7eff9..4180f1f35fb8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -18,12 +18,10 @@ static void ice_dcbnl_devreset(struct net_device *netdev)
 	while (ice_is_reset_in_progress(pf->state))
 		usleep_range(1000, 2000);
 
-	set_bit(__ICE_DCBNL_DEVRESET, pf->state);
 	dev_close(netdev);
 	netdev_state_change(netdev);
 	dev_open(netdev, NULL);
 	netdev_state_change(netdev);
-	clear_bit(__ICE_DCBNL_DEVRESET, pf->state);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7ac2beaed95c..d13c7fc8fb0a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3078,7 +3078,6 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 bool ice_is_reset_in_progress(unsigned long *state)
 {
 	return test_bit(__ICE_RESET_OICR_RECV, state) ||
-	       test_bit(__ICE_DCBNL_DEVRESET, state) ||
 	       test_bit(__ICE_PFR_REQ, state) ||
 	       test_bit(__ICE_CORER_REQ, state) ||
 	       test_bit(__ICE_GLOBR_REQ, state);
-- 
2.26.2

