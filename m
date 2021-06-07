Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918A439E47E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFGQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:57113 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhFGQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:46 -0400
IronPort-SDR: xZ36wEq0FfxjN7DK8u0NG7lkGBLZKmzFtSUmFp3EoNPPjJ2xFjTtjZG12z4h2s0o1Z6fvQEJT2
 cJ6t9YS+nAqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474554"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474554"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:54 -0700
IronPort-SDR: W5hjySMyy/98lhAPQ661SY86ThiA2wmWWTokld7Z1OSwkf5+PEsCVf3QI02s26j5rsBNHlby0t
 IkLcSIgY8Kcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841243"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Salil Mehta <salil.mehta@huawei.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 07/15] ice: Re-organizes reqstd/avail {R, T}XQ check/code for efficiency
Date:   Mon,  7 Jun 2021 09:53:17 -0700
Message-Id: <20210607165325.182087-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>

If user has explicitly requested the number of {R,T}XQs, then it is
unnecessary to get the count of already available {R,T}XQs from the
PF avail_{r,t}xqs bitmap. This value will get overridden by user specified
value in any case.

Re-organize this code for improving the flow, readability and efficiency.
This scope of improvement was found during the review of the ICE driver
code.

Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 135c4d9fd01c..357c5d39913d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -163,12 +163,13 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-		vsi->alloc_txq = min3(pf->num_lan_msix,
-				      ice_get_avail_txq_count(pf),
-				      (u16)num_online_cpus());
 		if (vsi->req_txq) {
 			vsi->alloc_txq = vsi->req_txq;
 			vsi->num_txq = vsi->req_txq;
+		} else {
+			vsi->alloc_txq = min3(pf->num_lan_msix,
+					      ice_get_avail_txq_count(pf),
+					      (u16)num_online_cpus());
 		}
 
 		pf->num_lan_tx = vsi->alloc_txq;
@@ -177,12 +178,13 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 			vsi->alloc_rxq = 1;
 		} else {
-			vsi->alloc_rxq = min3(pf->num_lan_msix,
-					      ice_get_avail_rxq_count(pf),
-					      (u16)num_online_cpus());
 			if (vsi->req_rxq) {
 				vsi->alloc_rxq = vsi->req_rxq;
 				vsi->num_rxq = vsi->req_rxq;
+			} else {
+				vsi->alloc_rxq = min3(pf->num_lan_msix,
+						      ice_get_avail_rxq_count(pf),
+						      (u16)num_online_cpus());
 			}
 		}
 
-- 
2.26.2

