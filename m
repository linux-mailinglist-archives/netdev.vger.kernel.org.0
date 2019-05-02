Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1308611603
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEBJGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:47594 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615377"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Use dev_err when ice_cfg_vsi_lan fails
Date:   Thu,  2 May 2019 02:06:20 -0700
Message-Id: <20190502090620.21281-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

dev_err makes more sense than dev_info when this call fails.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 399905396134..49c75371af08 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2368,7 +2368,9 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 			      max_txqs);
 	if (ret) {
-		dev_info(&pf->pdev->dev, "Failed VSI lan queue config\n");
+		dev_err(&pf->pdev->dev,
+			"VSI %d failed lan queue config, error %d\n",
+			vsi->vsi_num, ret);
 		goto unroll_vector_base;
 	}
 
@@ -2869,8 +2871,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 			      max_txqs);
 	if (ret) {
-		dev_info(&vsi->back->pdev->dev,
-			 "Failed VSI lan queue config\n");
+		dev_err(&pf->pdev->dev,
+			"VSI %d failed lan queue config, error %d\n",
+			vsi->vsi_num, ret);
 		goto err_vectors;
 	}
 	return 0;
-- 
2.20.1

