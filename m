Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E3613C4B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEDXte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:49:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:20569 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbfEDXtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:49:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994682"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Disable sniffing VF traffic on PF
Date:   Sat,  4 May 2019 16:49:29 -0700
Message-Id: <20190504234929.3005-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Delete code that add default Tx rule on PF. With this rule PF can see
Tx VF traffic that should go outside. For traffic from VF to another
VF default Tx rule on PF doesn't apply because of lower priority than
VF mac rule.

With this change on PF in promisc mode we can see only Rx traffic that
doesn't match any other rule (mac etc.). We can't see Tx traffic from
other VSI.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 24 ++---------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index aa832d9b2458..7843abf4d44d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -317,42 +317,22 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	    test_bit(ICE_VSI_FLAG_PROMISC_CHANGED, vsi->flags)) {
 		clear_bit(ICE_VSI_FLAG_PROMISC_CHANGED, vsi->flags);
 		if (vsi->current_netdev_flags & IFF_PROMISC) {
-			/* Apply Tx filter rule to get traffic from VMs */
-			status = ice_cfg_dflt_vsi(hw, vsi->idx, true,
-						  ICE_FLTR_TX);
-			if (status) {
-				netdev_err(netdev, "Error setting default VSI %i tx rule\n",
-					   vsi->vsi_num);
-				vsi->current_netdev_flags &= ~IFF_PROMISC;
-				err = -EIO;
-				goto out_promisc;
-			}
 			/* Apply Rx filter rule to get traffic from wire */
 			status = ice_cfg_dflt_vsi(hw, vsi->idx, true,
 						  ICE_FLTR_RX);
 			if (status) {
-				netdev_err(netdev, "Error setting default VSI %i rx rule\n",
+				netdev_err(netdev, "Error setting default VSI %i Rx rule\n",
 					   vsi->vsi_num);
 				vsi->current_netdev_flags &= ~IFF_PROMISC;
 				err = -EIO;
 				goto out_promisc;
 			}
 		} else {
-			/* Clear Tx filter rule to stop traffic from VMs */
-			status = ice_cfg_dflt_vsi(hw, vsi->idx, false,
-						  ICE_FLTR_TX);
-			if (status) {
-				netdev_err(netdev, "Error clearing default VSI %i tx rule\n",
-					   vsi->vsi_num);
-				vsi->current_netdev_flags |= IFF_PROMISC;
-				err = -EIO;
-				goto out_promisc;
-			}
 			/* Clear Rx filter to remove traffic from wire */
 			status = ice_cfg_dflt_vsi(hw, vsi->idx, false,
 						  ICE_FLTR_RX);
 			if (status) {
-				netdev_err(netdev, "Error clearing default VSI %i rx rule\n",
+				netdev_err(netdev, "Error clearing default VSI %i Rx rule\n",
 					   vsi->vsi_num);
 				vsi->current_netdev_flags |= IFF_PROMISC;
 				err = -EIO;
-- 
2.20.1

