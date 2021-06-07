Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE1839E486
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFGQxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:57119 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231158AbhFGQws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:48 -0400
IronPort-SDR: 9mRXYsLdXzuoBotCuXOo2DkOlzbBzf3LTWbui32eFcJhkXrxeiehErZ119TlB8dm3ioacQLKtS
 3CNx5NC6P3zw==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474567"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474567"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:56 -0700
IronPort-SDR: ipG47RqAlJEHo7zQggITI1xGoSPlCsON+oJb/uwBn/5luSkASMjKbYPBSczQjz7hjSQRsmvaSa
 NzumsH9oyGIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841276"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 15/15] ice: fix clang warning regarding deadcode.DeadStores
Date:   Mon,  7 Jun 2021 09:53:25 -0700
Message-Id: <20210607165325.182087-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

clang generates deadcode.DeadStores warnings when a variable
is used to read a value, but then that value isn't used later
in the code. Fix this warning.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d9ddd0bcf65f..f60bf2f5af13 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3501,13 +3501,9 @@ static int
 ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		    struct ice_ring_container *rc)
 {
-	struct ice_pf *pf;
-
 	if (!rc->ring)
 		return -EINVAL;
 
-	pf = rc->ring->vsi->back;
-
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc);
@@ -3519,7 +3515,7 @@ ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		ec->tx_coalesce_usecs = rc->itr_setting;
 		break;
 	default:
-		dev_dbg(ice_pf_to_dev(pf), "Invalid c_type %d\n", c_type);
+		dev_dbg(ice_pf_to_dev(rc->ring->vsi->back), "Invalid c_type %d\n", c_type);
 		return -EINVAL;
 	}
 
-- 
2.26.2

