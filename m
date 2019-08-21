Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCAA98558
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbfHUUQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:16:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:19353 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbfHUUQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 16:16:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 13:16:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="203148206"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2019 13:16:27 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] i40e: Fix crash caused by stress setting of VF MAC addresses
Date:   Wed, 21 Aug 2019 13:16:18 -0700
Message-Id: <20190821201623.5506-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
References: <20190821201623.5506-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

Add update to the VSI pointer passed to the i40e_set_vf_mac function.
If VF is in reset state the driver waits in i40e_set_vf_mac function
for the reset to be complete, yet after reset the vsi pointer
that was passed into this function is no longer valid.

The patch updates local VSI pointer directly from pf->vsi array,
by using the id stored in VF pointer (lan_vsi_idx).

Without this commit the driver might occasionally invoke general
protection fault in kernel and disable the OS entirely.

Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 4601f9e4e998..f8aa4deceb5e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3967,10 +3967,15 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	/* When the VF is resetting wait until it is done.
 	 * It can take up to 200 milliseconds,
 	 * but wait for up to 300 milliseconds to be safe.
+	 * If the VF is indeed in reset, the vsi pointer has
+	 * to show on the newly loaded vsi under pf->vsi[id].
 	 */
 	for (i = 0; i < 15; i++) {
-		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states))
+		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
+			if (i > 0)
+				vsi = pf->vsi[vf->lan_vsi_idx];
 			break;
+		}
 		msleep(20);
 	}
 	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
-- 
2.21.0

