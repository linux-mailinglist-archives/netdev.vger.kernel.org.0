Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C575BBD2A
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiIRJv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiIRJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:24 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEB7186FF
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:59 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfF26PjzHnnQ;
        Sun, 18 Sep 2022 17:47:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 52/55] net: gve: adjust the prototype of gve_rx(), gve_clean_rx_done() and gve_rx_complete_skb()
Date:   Sun, 18 Sep 2022 09:43:33 +0000
Message-ID: <20220918094336.28958-53-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function  gve_rx(), gve_clean_rx_done() and
gve_rx_complete_skb() using netdev_features_t as parameters.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of the function,
change the prototype of input features to 'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c     | 10 +++++-----
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 5f479566011c..ce46739b6826 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -534,7 +534,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 	return skb;
 }
 
-static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
+static bool gve_rx(struct gve_rx_ring *rx, const netdev_features_t *feat,
 		   u64 *packet_size_bytes, u32 *work_done)
 {
 	struct gve_rx_slot_page_info *page_info;
@@ -592,7 +592,7 @@ static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 		desc = &rx->desc.desc_ring[idx];
 	}
 
-	if (likely(netdev_feature_test(NETIF_F_RXCSUM_BIT, feat))) {
+	if (likely(netdev_feature_test(NETIF_F_RXCSUM_BIT, *feat))) {
 		/* NIC passes up the partial sum */
 		if (first_desc->csum)
 			skb->ip_summed = CHECKSUM_COMPLETE;
@@ -602,7 +602,7 @@ static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 	}
 
 	/* parse flags & pass relevant info up */
-	if (likely(netdev_feature_test(NETIF_F_RXHASH_BIT, feat)) &&
+	if (likely(netdev_feature_test(NETIF_F_RXHASH_BIT, *feat)) &&
 	    gve_needs_rss(first_desc->flags_seq))
 		skb_set_hash(skb, be32_to_cpu(first_desc->rss_hash),
 			     gve_rss_type(first_desc->flags_seq));
@@ -702,7 +702,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 }
 
 static int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
-			     netdev_features_t feat)
+			     const netdev_features_t *feat)
 {
 	u32 work_done = 0, total_packet_cnt = 0, ok_packet_cnt = 0;
 	struct gve_priv *priv = rx->gve;
@@ -783,7 +783,7 @@ int gve_rx_poll(struct gve_notify_block *block, int budget)
 		budget = INT_MAX;
 
 	if (budget > 0)
-		work_done = gve_clean_rx_done(rx, budget, feat);
+		work_done = gve_clean_rx_done(rx, budget, &feat);
 
 	return work_done;
 }
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index edff4d162236..e5ce1d261b03 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -629,7 +629,7 @@ static int gve_rx_complete_rsc(struct sk_buff *skb,
 /* Returns 0 if skb is completed successfully, -1 otherwise. */
 static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 			       const struct gve_rx_compl_desc_dqo *desc,
-			       netdev_features_t feat)
+			       const netdev_features_t *feat)
 {
 	struct gve_ptype ptype =
 		rx->gve->ptype_lut_dqo->ptypes[desc->packet_type];
@@ -637,10 +637,10 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 
 	skb_record_rx_queue(rx->ctx.skb_head, rx->q_num);
 
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, feat))
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *feat))
 		gve_rx_skb_hash(rx->ctx.skb_head, desc, ptype);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, feat))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *feat))
 		gve_rx_skb_csum(rx->ctx.skb_head, desc, ptype);
 
 	/* RSC packets must set gso_size otherwise the TCP stack will complain
@@ -732,7 +732,7 @@ int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 			pkt_bytes += ETH_HLEN;
 
 		/* gve_rx_complete_skb() will consume skb if successful */
-		if (gve_rx_complete_skb(rx, napi, compl_desc, feat) != 0) {
+		if (gve_rx_complete_skb(rx, napi, compl_desc, &feat) != 0) {
 			gve_rx_free_skb(rx);
 			u64_stats_update_begin(&rx->statss);
 			rx->rx_desc_err_dropped_pkt++;
-- 
2.33.0

