Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D50476133
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344084AbhLOSzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:23972 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344071AbhLOSzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594513; x=1671130513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VtJLLd7GLaeGs4+dAalUo4ReM9Mw/fYgR0PmNYX0QH4=;
  b=IczkTAl66bDujQLoPztHUWWd6PQ3qKTrxVjrXbv3Dd7H5s7n4RM/R2gV
   VujgQjmKKj44NRdxcE6s0tOq4DXJEXS+n3mKYZqF9K1kIFcj7+VloiUlI
   6KO+fSY3+jly7YBnjmgqil0k8sTcPSTdOFUOsqGzDt8KHWGTURP2T2v9x
   hc/x7RcHTN4Jfn5iW0NVweHhOi0QadAED9PZjIL1HVeZ28i3seJrJ327U
   afN2OGYQt4h/hQe/axlrSvYWgXWlT7ZlC1+HEEKzcmnxLhw27McsxirXZ
   avvq6VyucA5rl+EFJ7+UvbMtjCSTVAflyCUzo6fbKuXkXjLogvOCvgXqU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226169615"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="226169615"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729955"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 8/9] ice: tighter control over VSI_DOWN state
Date:   Wed, 15 Dec 2021 10:53:54 -0800
Message-Id: <20211215185355.3249738-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver had comments to the effect of: This flag should be set before
calling this function. While reviewing code it was found that there were
several violations of this policy, which could introduce hard to find
bugs or races.

Fix the violations of the "VSI DOWN state must be set before calling
ice_down" and make checking the state into code with a WARN_ON.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Testing Hints: legacy-rx private flag disable/enable forgot to set this
previously and is a way to trigger the down/up path.

 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c    | 7 ++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index aefd9c3d450b..e2e3ef7fba7f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1280,8 +1280,10 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 	}
 	if (test_bit(ICE_FLAG_LEGACY_RX, change_flags)) {
 		/* down and up VSI so that changes of Rx cfg are reflected. */
-		ice_down(vsi);
-		ice_up(vsi);
+		if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
+			ice_down(vsi);
+			ice_up(vsi);
+		}
 	}
 	/* don't allow modification of this flag when a single VF is in
 	 * promiscuous mode because it's not supported
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 452fa28f8967..865f2231bb24 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6229,14 +6229,15 @@ static void ice_napi_disable_all(struct ice_vsi *vsi)
 /**
  * ice_down - Shutdown the connection
  * @vsi: The VSI being stopped
+ *
+ * Caller of this function is expected to set the vsi->state ICE_DOWN bit
  */
 int ice_down(struct ice_vsi *vsi)
 {
 	int i, tx_err, rx_err, link_err = 0;
 
-	/* Caller of this function is expected to set the
-	 * vsi->state ICE_DOWN bit
-	 */
+	WARN_ON(!test_bit(ICE_VSI_DOWN, vsi->state));
+
 	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		netif_carrier_off(vsi->netdev);
 		netif_tx_disable(vsi->netdev);
-- 
2.31.1

