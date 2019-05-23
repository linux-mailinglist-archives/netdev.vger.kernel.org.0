Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191E828D30
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbfEWWdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:19075 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388577AbfEWWdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] ice: Gracefully handle reset failure in ice_alloc_vfs()
Date:   Thu, 23 May 2019 15:33:34 -0700
Message-Id: <20190523223340.13449-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if ice_reset_all_vfs() fails in ice_alloc_vfs() we fail to
free some resources, reset variables, and return an error value.
Fix this by adding another unroll case to free the pf->vf array, set
the pf->num_alloc_vfs to 0, and return an error code.

Without this, if ice_reset_all_vfs() fails in ice_alloc_vfs() we will
not be able to do SRIOV without hard rebooting the system because
rmmod'ing the driver does not work.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 80d01ee2e967..fd19ab53653d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1134,7 +1134,7 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 			   GFP_KERNEL);
 	if (!vfs) {
 		ret = -ENOMEM;
-		goto err_unroll_sriov;
+		goto err_pci_disable_sriov;
 	}
 	pf->vf = vfs;
 
@@ -1154,12 +1154,19 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 	pf->num_alloc_vfs = num_alloc_vfs;
 
 	/* VF resources get allocated during reset */
-	if (!ice_reset_all_vfs(pf, true))
+	if (!ice_reset_all_vfs(pf, true)) {
+		ret = -EIO;
 		goto err_unroll_sriov;
+	}
 
 	goto err_unroll_intr;
 
 err_unroll_sriov:
+	pf->vf = NULL;
+	devm_kfree(&pf->pdev->dev, vfs);
+	vfs = NULL;
+	pf->num_alloc_vfs = 0;
+err_pci_disable_sriov:
 	pci_disable_sriov(pf->pdev);
 err_unroll_intr:
 	/* rearm interrupts here */
-- 
2.21.0

