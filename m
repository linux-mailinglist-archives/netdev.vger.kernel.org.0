Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4112BA6F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfL0SO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfL0SOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:14:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B675208C4;
        Fri, 27 Dec 2019 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470492;
        bh=9EID52D7e5jdDMIxVggjeOppsxxQ4OeaDCj5xbY+c7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=le8sKo134EwGqP1oRJSuoiDogzs7a3/4/0aVITapZ/hLK0LulyTJ5d0HyXGWOaJst
         y1JcHBukbFQm2jjcyKkQY7EvojrrKVAkeE/atBeuD4SuslU7r2OKS2/6J3T84oWga8
         FOj0O4mCjkPysxXbHiCcRSMNnsbsmxEz9yvxpe78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Netanel Belgazal <netanel@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/38] net: ena: fix napi handler misbehavior when the napi budget is zero
Date:   Fri, 27 Dec 2019 13:14:10 -0500
Message-Id: <20191227181435.7644-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Netanel Belgazal <netanel@amazon.com>

[ Upstream commit 24dee0c7478d1a1e00abdf5625b7f921467325dc ]

In netpoll the napi handler could be called with budget equal to zero.
Current ENA napi handler doesn't take that into consideration.

The napi handler handles Rx packets in a do-while loop.
Currently, the budget check happens only after decrementing the
budget, therefore the napi handler, in rare cases, could run over
MAX_INT packets.

In addition to that, this moves all budget related variables to int
calculation and stop mixing u32 to avoid ambiguity

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0780900b37c7..961f31c8356b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1105,8 +1105,8 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	struct ena_ring *tx_ring, *rx_ring;
 	struct ena_eth_io_intr_reg intr_reg;
 
-	u32 tx_work_done;
-	u32 rx_work_done;
+	int tx_work_done;
+	int rx_work_done = 0;
 	int tx_budget;
 	int napi_comp_call = 0;
 	int ret;
@@ -1122,7 +1122,11 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 	}
 
 	tx_work_done = ena_clean_tx_irq(tx_ring, tx_budget);
-	rx_work_done = ena_clean_rx_irq(rx_ring, napi, budget);
+	/* On netpoll the budget is zero and the handler should only clean the
+	 * tx completions.
+	 */
+	if (likely(budget))
+		rx_work_done = ena_clean_rx_irq(rx_ring, napi, budget);
 
 	if ((budget > rx_work_done) && (tx_budget > tx_work_done)) {
 		napi_complete_done(napi, rx_work_done);
-- 
2.20.1

