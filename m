Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9D6BA8A3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCOHEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjCOHEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:04:41 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30BB36A42;
        Wed, 15 Mar 2023 00:04:40 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.98,262,1673881200"; 
   d="scan'208";a="152643869"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 15 Mar 2023 16:04:39 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 7E369418A971;
        Wed, 15 Mar 2023 16:04:39 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Subject: [PATCH net 1/2] net: renesas: rswitch: Fix the output value of quote from rswitch_rx()
Date:   Wed, 15 Mar 2023 16:04:23 +0900
Message-Id: <20230315070424.1088877-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the RX descriptor doesn't have any data, the output value of quote
from rswitch_rx() will be increased unexpectedily. So, fix it.

Reported-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 853394e5bb8b..46d8d9c8fc19 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -702,13 +702,14 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 	u16 pkt_len;
 	u32 get_ts;
 
+	if (*quota <= 0)
+		return true;
+
 	boguscnt = min_t(int, gq->ring_size, *quota);
 	limit = boguscnt;
 
 	desc = &gq->rx_ring[gq->cur];
 	while ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY) {
-		if (--boguscnt < 0)
-			break;
 		dma_rmb();
 		pkt_len = le16_to_cpu(desc->desc.info_ds) & RX_DS;
 		skb = gq->skbs[gq->cur];
@@ -734,6 +735,9 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 
 		gq->cur = rswitch_next_queue_index(gq, true, 1);
 		desc = &gq->rx_ring[gq->cur];
+
+		if (--boguscnt <= 0)
+			break;
 	}
 
 	num = rswitch_get_num_cur_queues(gq);
@@ -745,7 +749,7 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 		goto err;
 	gq->dirty = rswitch_next_queue_index(gq, false, num);
 
-	*quota -= limit - (++boguscnt);
+	*quota -= limit - boguscnt;
 
 	return boguscnt <= 0;
 
-- 
2.25.1

