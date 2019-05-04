Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9A13C58
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfEDXyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:32555 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfEDXyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994650"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: Don't remove VLAN filters that were never programmed
Date:   Sat,  4 May 2019 16:49:18 -0700
Message-Id: <20190504234929.3005-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

In case of non-trusted VFs, it is possible to program VLAN filter far
less than what is requested by the VF originally, thereby makes number of
VLAN elements being tracked by VF different from actual VLAN tags. This
patch makes sure that we are not attempting to remove VLAN filter that
does not exist.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c         |  6 +++++-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 12 +++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 947730d74612..83d0aef7f77e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1616,7 +1616,11 @@ int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid)
 	list_add(&list->list_entry, &tmp_add_list);
 
 	status = ice_remove_vlan(&pf->hw, &tmp_add_list);
-	if (status) {
+	if (status == ICE_ERR_DOES_NOT_EXIST) {
+		dev_dbg(&pf->pdev->dev,
+			"Failed to remove VLAN %d on VSI %i, it does not exist, status: %d\n",
+			vid, vsi->vsi_num, status);
+	} else if (status) {
 		dev_err(&pf->pdev->dev,
 			"Error removing VLAN %d on vsi %i error: %d\n",
 			vid, vsi->vsi_num, status);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index abc958788267..f4b466cd4b7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2402,7 +2402,17 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			}
 		}
 	} else {
-		for (i = 0; i < vfl->num_elements; i++) {
+		/* In case of non_trusted VF, number of VLAN elements passed
+		 * to PF for removal might be greater than number of VLANs
+		 * filter programmed for that VF - So, use actual number of
+		 * VLANS added earlier with add VLAN opcode. In order to avoid
+		 * removing VLAN that doesn't exist, which result to sending
+		 * erroneous failed message back to the VF
+		 */
+		int num_vf_vlan;
+
+		num_vf_vlan = vf->num_vlan;
+		for (i = 0; i < vfl->num_elements && i < num_vf_vlan; i++) {
 			u16 vid = vfl->vlan_id[i];
 
 			/* Make sure ice_vsi_kill_vlan is successful before
-- 
2.20.1

