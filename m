Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4BF4049F3
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhIILoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237468AbhIILnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F22D661205;
        Thu,  9 Sep 2021 11:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187715;
        bh=VIATtPJ0D92dbWg+eENiigWc7KCEyc/ZyJO/wyvcxVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhd6EXTFNGu66ve6n60xiwHOPAFHZXb4AfAKbvH4qqUYQqR1joA6YYSLawJ0TFcRN
         f+l3lUybcyHenNfaDZMXxtZVGvIA12s4VFpYrIla8zNLa61d0it47F/otE/xwJplyJ
         OpZ4FQPlMjApVSLfpjgmpqIYurdA1MHs3EYCLRcWFUfNoLrYvXPRrF6YgrDGX7mzjp
         xRTk2XY+DKoLXXnaADEMDCn6xPyc8eH6fumK4Djhaw7YGvhpFB1DFVI2+aKrqrlL99
         I4Lt1QS9Sk+q3IQuoeY1yJgldgaIT/NWl8ARRz+OMDS07B5YntjWxvB3KqhyDt5cPd
         BjEp23so8w51A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 038/252] igc: Check if num of q_vectors is smaller than max before array access
Date:   Thu,  9 Sep 2021 07:37:32 -0400
Message-Id: <20210909114106.141462-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 373e2829e7c2e1e606503cdb5c97749f512a4be9 ]

Ensure that the adapter->q_vector[MAX_Q_VECTORS] array isn't accessed
beyond its size. It was fixed by using a local variable num_q_vectors
as a limit for loop index, and ensure that num_q_vectors is not bigger
than MAX_Q_VECTORS.

Suggested-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ed2d66bc2d6c..f62982c4d933 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4817,6 +4817,7 @@ static irqreturn_t igc_msix_ring(int irq, void *data)
  */
 static int igc_request_msix(struct igc_adapter *adapter)
 {
+	unsigned int num_q_vectors = adapter->num_q_vectors;
 	int i = 0, err = 0, vector = 0, free_vector = 0;
 	struct net_device *netdev = adapter->netdev;
 
@@ -4825,7 +4826,13 @@ static int igc_request_msix(struct igc_adapter *adapter)
 	if (err)
 		goto err_out;
 
-	for (i = 0; i < adapter->num_q_vectors; i++) {
+	if (num_q_vectors > MAX_Q_VECTORS) {
+		num_q_vectors = MAX_Q_VECTORS;
+		dev_warn(&adapter->pdev->dev,
+			 "The number of queue vectors (%d) is higher than max allowed (%d)\n",
+			 adapter->num_q_vectors, MAX_Q_VECTORS);
+	}
+	for (i = 0; i < num_q_vectors; i++) {
 		struct igc_q_vector *q_vector = adapter->q_vector[i];
 
 		vector++;
-- 
2.30.2

