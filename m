Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47602037D4
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgFVNVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:21:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:27253 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgFVNVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:21:36 -0400
IronPort-SDR: E+TzF6ptoA31tgIrkcvCPM/e4tagpBPDMUpo/EQ9W/0vLvSoTU7zkoZwu2vyObb9ocySEO45qp
 gzzjIKLGqtSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="145265645"
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="145265645"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 06:21:36 -0700
IronPort-SDR: Y6DeN6G1KbLRqCzY2W/zor7KlrobA64xDCrmyRGysBggyOEV8tR2Zl5PARvl2KU5+cpQdpL+EE
 r7Qp3OduHbfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="422628535"
Received: from juergenr-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.33.83])
  by orsmga004.jf.intel.com with ESMTP; 22 Jun 2020 06:21:34 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] i40e: eliminate division in napi_poll data path
Date:   Mon, 22 Jun 2020 15:21:23 +0200
Message-Id: <1592832083-23249-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592832083-23249-1-git-send-email-magnus.karlsson@intel.com>
References: <1592832083-23249-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate a division in the napi_poll data path. This division is
executed even though it is only needed in the rare case when there are
not enough interrupt lines so they have to be shared between queue
pairs. Instead, just test for this case and only execute the division
if needed. The code has been lifted from the ice driver.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 0ce9d1e..da73a7d 100644
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
2.7.4

