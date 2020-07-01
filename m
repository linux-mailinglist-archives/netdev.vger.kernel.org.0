Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C89211622
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgGAWes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:25461 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728003AbgGAWe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:27 -0400
IronPort-SDR: xt+0bTOe6vejW+fdt0HepK8keDJR4us9FqD3o7v312LfcJMjJrXuvEcGG0yTIC7BndzmwdGECt
 1Kpp4OCQeryQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178603"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178603"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: VS0n/YJJd0BuJMWHiiXRFXrHy2DqIJNyTrp/Mio9Xtdt/wHVDeSXrqX0dw2D9xHwykVvgWdSGV
 UFo9XQKFzHOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276114"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 05/12] i40e: eliminate division in napi_poll data path
Date:   Wed,  1 Jul 2020 15:34:05 -0700
Message-Id: <20200701223412.2675606-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Eliminate a division in the napi_poll data path. This division is
executed even though it is only needed in the rare case when there are
not enough interrupt lines so they have to be shared between queue
pairs. Instead, just test for this case and only execute the division
if needed. The code has been lifted from the ice driver.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index aad4326ab0c9..3e5c566ceb01 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2595,10 +2595,16 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	if (budget <= 0)
 		goto tx_only;
 
-	/* We attempt to distribute budget to each Rx queue fairly, but don't
-	 * allow the budget to go below 1 because that would exit polling early.
-	 */
-	budget_per_ring = max(budget/q_vector->num_ringpairs, 1);
+	/* normally we have 1 Rx ring per q_vector */
+	if (unlikely(q_vector->num_ringpairs > 1))
+		/* We attempt to distribute budget to each Rx queue fairly, but
+		 * don't allow the budget to go below 1 because that would exit
+		 * polling early.
+		 */
+		budget_per_ring = max_t(int, budget / q_vector->num_ringpairs, 1);
+	else
+		/* Max of 1 Rx ring in this q_vector so give it the budget */
+		budget_per_ring = budget;
 
 	i40e_for_each_ring(ring, q_vector->rx) {
 		int cleaned = ring->xsk_umem ?
-- 
2.26.2

