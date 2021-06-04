Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81E39BC9B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFDQMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:12:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:21972 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhFDQMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:12:15 -0400
IronPort-SDR: kcVMZDwMVhNG8W97HkAyKSUYKBwJSW6PN5LxPp+m+LqVoC9bdlc2UfHmBEhr1dg+L0vM2WPVVp
 DZ7BxAt3fjCQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="201299735"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="201299735"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:03 -0700
IronPort-SDR: LX5eHmbcVxXfYWFvQwBtFSOmUHHyid8Nb3fSfjGm+qasH2ViHGsKZ5Sxuapxxk7fgGWlTLWp2i
 yVzMP32UIGEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511685"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/6] ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared
Date:   Fri,  4 Jun 2021 09:08:12 -0700
Message-Id: <20210604160816.3391716-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Some AVF drivers expect the VF_MBX_ATQLEN register to be cleared for any
type of VFR/VFLR. Fix this by clearing the VF_MBX_ATQLEN register at the
same time as VF_MBX_ARQLEN.

Fixes: 82ba01282cf8 ("ice: clear VF ARQLEN register on reset")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h  |  1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index de38a0fc9665..9b8300d4a267 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -31,6 +31,7 @@
 #define PF_FW_ATQLEN_ATQOVFL_M			BIT(29)
 #define PF_FW_ATQLEN_ATQCRIT_M			BIT(30)
 #define VF_MBX_ARQLEN(_VF)			(0x0022BC00 + ((_VF) * 4))
+#define VF_MBX_ATQLEN(_VF)			(0x0022A800 + ((_VF) * 4))
 #define PF_FW_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_FW_ATQT				0x00080400
 #define PF_MBX_ARQBAH				0x0022E400
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a1d22d2aa0bd..944d861c8579 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -713,13 +713,15 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 	 */
 	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
 
-	/* VF_MBX_ARQLEN is cleared by PFR, so the driver needs to clear it
-	 * in the case of VFR. If this is done for PFR, it can mess up VF
-	 * resets because the VF driver may already have started cleanup
-	 * by the time we get here.
+	/* VF_MBX_ARQLEN and VF_MBX_ATQLEN are cleared by PFR, so the driver
+	 * needs to clear them in the case of VFR/VFLR. If this is done for
+	 * PFR, it can mess up VF resets because the VF driver may already
+	 * have started cleanup by the time we get here.
 	 */
-	if (!is_pfr)
+	if (!is_pfr) {
 		wr32(hw, VF_MBX_ARQLEN(vf->vf_id), 0);
+		wr32(hw, VF_MBX_ATQLEN(vf->vf_id), 0);
+	}
 
 	/* In the case of a VFLR, the HW has already reset the VF and we
 	 * just need to clean up, so don't hit the VFRTRIG register.
-- 
2.26.2

