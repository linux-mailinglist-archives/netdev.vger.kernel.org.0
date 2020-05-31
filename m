Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37A61E979C
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgEaMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:12463 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgEaMg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:26 -0400
IronPort-SDR: Rh/PsxkLAhmRxDNNp6Ihq5ykFSbjOQfUc9Ywft6PZQsqVGBfLTCjlnEsk2icOZllWotcFZ2ME7
 Y86XBbv2B6dQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:24 -0700
IronPort-SDR: 5SM2myMo21Kw5PO0kcAFSu4RPvHVgSGUjCJfmkfndMV/qzriyJDqpzzuREUHqh6Fy3cFChHQN+
 EtbqveWF6r3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345451"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/14] ice: Use coalesce values from q_vector 0 when increasing q_vectors
Date:   Sun, 31 May 2020 05:36:17 -0700
Message-Id: <20200531123619.2887469-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when a VSI is built (i.e. reset, set channels, etc.)
the coalesce settings will be preserved in most cases. However, when the
number of q_vectors are increased the settings for the new q_vectors
will be set to the driver defaults of AIM on, Rx/Tx ITR 50, and INTRL 0.
This is causing issues with how the ethtool layer gets the current
coalesce settings since it only uses q_vector 0. So, assume that the user
set the coalesce settings globally (i.e. ethtool -C eth0) and use q_vector
0's settings for all of the new q_vectors.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index ecc04a696e50..28b46cc9f5cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2707,15 +2707,13 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		ice_vsi_rebuild_update_coalesce(vsi->q_vectors[i],
 						&coalesce[i]);
 
-	for (; i < vsi->num_q_vectors; i++) {
-		struct ice_coalesce_stored coalesce_dflt = {
-			.itr_tx = ICE_DFLT_TX_ITR,
-			.itr_rx = ICE_DFLT_RX_ITR,
-			.intrl = 0
-		};
+	/* number of q_vectors increased, so assume coalesce settings were
+	 * changed globally (i.e. ethtool -C eth0 instead of per-queue) and use
+	 * the previous settings from q_vector 0 for all of the new q_vectors
+	 */
+	for (; i < vsi->num_q_vectors; i++)
 		ice_vsi_rebuild_update_coalesce(vsi->q_vectors[i],
-						&coalesce_dflt);
-	}
+						&coalesce[0]);
 }
 
 /**
-- 
2.26.2

