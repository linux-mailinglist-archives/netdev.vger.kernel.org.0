Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19071E711A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438015AbgE2AIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:37096 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437980AbgE2AIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:36 -0400
IronPort-SDR: AYCPrRj4PXpkhNBXbv3WlqolcqQrgsCkzI+sJ4YhSE3p/wC/UdNzGZNZcFDTLNXUOM33vl7IDD
 bByTNEw+f4Uw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:35 -0700
IronPort-SDR: FyorhyFuiAwB6tXDORisU3t/hiD6NiysVuECqebSlOpNorVQ+7p6gmaOupJPmTyv+b819DxPwt
 gVNxlo4eby5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651657"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: remove VM/VF disable command on CORER/GLOBR reset
Date:   Thu, 28 May 2020 17:08:29 -0700
Message-Id: <20200529000831.2803870-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Remove VM/VF disable AQC (opcode 0x0C31) when resetting all VFs.
This is not required for CORER/GLOBR reset.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 3a714c81b5b2..245310a52e1b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1196,17 +1196,6 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	ice_for_each_vf(pf, v)
 		ice_trigger_vf_reset(&pf->vf[v], is_vflr, true);
 
-	ice_for_each_vf(pf, v) {
-		struct ice_vsi *vsi;
-
-		vf = &pf->vf[v];
-		vsi = pf->vsi[vf->lan_vsi_idx];
-		if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
-			ice_dis_vf_qs(vf);
-		ice_dis_vsi_txq(vsi->port_info, vsi->idx, 0, 0, NULL, NULL,
-				NULL, ICE_VF_RESET, vf->vf_id, NULL);
-	}
-
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
 	 * sequence to make sure that it has completed. We'll keep track of
-- 
2.26.2

