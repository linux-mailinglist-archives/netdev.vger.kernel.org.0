Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA32F1F14
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbfKFTiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:38:12 -0500
Received: from mga04.intel.com ([192.55.52.120]:25889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732203AbfKFTiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:38:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 11:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="402473292"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 11:38:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 09/14] ice: write register with correct offset
Date:   Wed,  6 Nov 2019 11:37:51 -0800
Message-Id: <20191106193756.23819-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
References: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

The VF_MBX_ARQLEN register array is per-PF, not global, so we should not
use the absolute VF ID as an index. Instead, use the per-PF VF ID.

This fixes an issue with VFs on PFs other than 0 not seeing reset.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ad757412bb04..3d8c231b0614 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -390,7 +390,7 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 	 * by the time we get here.
 	 */
 	if (!is_pfr)
-		wr32(hw, VF_MBX_ARQLEN(vf_abs_id), 0);
+		wr32(hw, VF_MBX_ARQLEN(vf->vf_id), 0);
 
 	/* In the case of a VFLR, the HW has already reset the VF and we
 	 * just need to clean up, so don't hit the VFRTRIG register.
-- 
2.21.0

