Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADCF9499D
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfHSQRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:17:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:22452 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfHSQRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:17:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 09:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="207052931"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 19 Aug 2019 09:17:14 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 02/14] ice: Assume that more than one Rx queue is rare in ice_napi_poll
Date:   Mon, 19 Aug 2019 09:16:56 -0700
Message-Id: <20190819161708.3763-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
References: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we divide budget by the number of Rx queues per Rx ring
container in ice_napi_poll even if there is only 1. This is an
unnecessary divide for the normal case of 1 Rx ring per Rx ring
container. Fix this by using an unlikely() call in the case where we
actually need to divide.

Also, we will always set budget_per_ring even if there are no Rx rings
in the Rx ring container so we don't need to initialize it to 0.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9234fd203929..837d6ae2f33b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1414,8 +1414,8 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 				container_of(napi, struct ice_q_vector, napi);
 	struct ice_vsi *vsi = q_vector->vsi;
 	bool clean_complete = true;
-	int budget_per_ring = 0;
 	struct ice_ring *ring;
+	int budget_per_ring;
 	int work_done = 0;
 
 	/* Since the actual Tx work is minimal, we can give the Tx a larger
@@ -1429,11 +1429,16 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	if (budget <= 0)
 		return budget;
 
-	/* We attempt to distribute budget to each Rx queue fairly, but don't
-	 * allow the budget to go below 1 because that would exit polling early.
-	 */
-	if (q_vector->num_ring_rx)
+	/* normally we have 1 Rx ring per q_vector */
+	if (unlikely(q_vector->num_ring_rx > 1))
+		/* We attempt to distribute budget to each Rx queue fairly, but
+		 * don't allow the budget to go below 1 because that would exit
+		 * polling early.
+		 */
 		budget_per_ring = max(budget / q_vector->num_ring_rx, 1);
+	else
+		/* Max of 1 Rx ring in this q_vector so give it the budget */
+		budget_per_ring = budget;
 
 	ice_for_each_ring(ring, q_vector->rx) {
 		int cleaned;
-- 
2.21.0

