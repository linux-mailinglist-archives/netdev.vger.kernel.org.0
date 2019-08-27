Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625489F060
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfH0Qin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:7296 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbfH0Qig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876339"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Introduce a local variable for a VSI in the rebuild path
Date:   Tue, 27 Aug 2019 09:38:22 -0700
Message-Id: <20190827163832.8362-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

When a VSI is accessed inside the ice_for_each_vsi macro in the rebuild
path (ice_vsi_rebuild_all() and ice_vsi_replay_all()), it is referred to
as pf->vsi[i]. Introduce local variables to improve readability.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2f6125bfd991..2c6b2bc4e30e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3704,22 +3704,23 @@ static int ice_vsi_rebuild_all(struct ice_pf *pf)
 
 	/* loop through pf->vsi array and reinit the VSI if found */
 	ice_for_each_vsi(pf, i) {
+		struct ice_vsi *vsi = pf->vsi[i];
 		int err;
 
-		if (!pf->vsi[i])
+		if (!vsi)
 			continue;
 
-		err = ice_vsi_rebuild(pf->vsi[i]);
+		err = ice_vsi_rebuild(vsi);
 		if (err) {
 			dev_err(&pf->pdev->dev,
 				"VSI at index %d rebuild failed\n",
-				pf->vsi[i]->idx);
+				vsi->idx);
 			return err;
 		}
 
 		dev_info(&pf->pdev->dev,
 			 "VSI at index %d rebuilt. vsi_num = 0x%x\n",
-			 pf->vsi[i]->idx, pf->vsi[i]->vsi_num);
+			 vsi->idx, vsi->vsi_num);
 	}
 
 	return 0;
@@ -3737,25 +3738,27 @@ static int ice_vsi_replay_all(struct ice_pf *pf)
 
 	/* loop through pf->vsi array and replay the VSI if found */
 	ice_for_each_vsi(pf, i) {
-		if (!pf->vsi[i])
+		struct ice_vsi *vsi = pf->vsi[i];
+
+		if (!vsi)
 			continue;
 
-		ret = ice_replay_vsi(hw, pf->vsi[i]->idx);
+		ret = ice_replay_vsi(hw, vsi->idx);
 		if (ret) {
 			dev_err(&pf->pdev->dev,
 				"VSI at index %d replay failed %d\n",
-				pf->vsi[i]->idx, ret);
+				vsi->idx, ret);
 			return -EIO;
 		}
 
 		/* Re-map HW VSI number, using VSI handle that has been
 		 * previously validated in ice_replay_vsi() call above
 		 */
-		pf->vsi[i]->vsi_num = ice_get_hw_vsi_num(hw, pf->vsi[i]->idx);
+		vsi->vsi_num = ice_get_hw_vsi_num(hw, vsi->idx);
 
 		dev_info(&pf->pdev->dev,
 			 "VSI at index %d filter replayed successfully - vsi_num %i\n",
-			 pf->vsi[i]->idx, pf->vsi[i]->vsi_num);
+			 vsi->idx, vsi->vsi_num);
 	}
 
 	/* Clean up replay filter after successful re-configuration */
-- 
2.21.0

