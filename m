Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2030246
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfE3SvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:51:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfE3Suh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Use right type for ice_cfg_vsi_lan return
Date:   Thu, 30 May 2019 11:50:35 -0700
Message-Id: <20190530185045.3886-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

ice_cfg_vsi_lan returns a value of type enum ice_status. So
use a local of the same type to capture the return value.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a21b817642ad..d0410c686ef4 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2365,6 +2365,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct device *dev = &pf->pdev->dev;
+	enum ice_status status;
 	struct ice_vsi *vsi;
 	int ret, i;
 
@@ -2472,12 +2473,12 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	for (i = 0; i < vsi->tc_cfg.numtc; i++)
 		max_txqs[i] = pf->num_lan_tx;
 
-	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
-			      max_txqs);
-	if (ret) {
+	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+				 max_txqs);
+	if (status) {
 		dev_err(&pf->pdev->dev,
 			"VSI %d failed lan queue config, error %d\n",
-			vsi->vsi_num, ret);
+			vsi->vsi_num, status);
 		goto unroll_vector_base;
 	}
 
@@ -2868,6 +2869,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_vf *vf = NULL;
+	enum ice_status status;
 	struct ice_pf *pf;
 	int ret, i;
 
@@ -2961,12 +2963,12 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	for (i = 0; i < vsi->tc_cfg.numtc; i++)
 		max_txqs[i] = pf->num_lan_tx;
 
-	ret = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
-			      max_txqs);
-	if (ret) {
+	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+				 max_txqs);
+	if (status) {
 		dev_err(&pf->pdev->dev,
 			"VSI %d failed lan queue config, error %d\n",
-			vsi->vsi_num, ret);
+			vsi->vsi_num, status);
 		goto err_vectors;
 	}
 	return 0;
-- 
2.21.0

