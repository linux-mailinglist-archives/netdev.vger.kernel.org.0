Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FFFA79ED
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfIDEfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbfIDEfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804431"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Only disable VLAN pruning for the VF when all VLANs are removed
Date:   Tue,  3 Sep 2019 21:35:12 -0700
Message-Id: <20190904043512.28066-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if the VF adds a VLAN, VLAN pruning will be enabled for that VSI.
Also, when a VLAN gets deleted it will disable VLAN pruning even if other
VLAN(s) exists for the VF. Fix this by only disabling VLAN pruning on the
VF VSI when removing the last VF (i.e. vf->num_vlan == 0).

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c58e3e3212df..c38939b1d496 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2767,8 +2767,9 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			}
 
 			vf->num_vlan--;
-			/* Disable VLAN pruning when removing VLAN */
-			ice_cfg_vlan_pruning(vsi, false, false);
+			/* Disable VLAN pruning when the last VLAN is removed */
+			if (!vf->num_vlan)
+				ice_cfg_vlan_pruning(vsi, false, false);
 
 			/* Disable Unicast/Multicast VLAN promiscuous mode */
 			if (vlan_promisc) {
-- 
2.21.0

