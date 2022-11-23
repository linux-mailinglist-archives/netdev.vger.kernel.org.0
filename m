Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D7363507C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiKWGbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiKWGbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:31:10 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2B15C74E;
        Tue, 22 Nov 2022 22:31:09 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NHB8F43Wpz15Mlp;
        Wed, 23 Nov 2022 14:30:37 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 14:31:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <arvid.brodin@alten.se>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] net: hsr: Fix potential use-after-free
Date:   Wed, 23 Nov 2022 14:30:57 +0800
Message-ID: <20221123063057.25952-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb is delivered to netif_rx() which may free it, after calling this,
dereferencing skb may trigger use-after-free.

Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/hsr/hsr_forward.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index a50429a62f74..56bb27d67a2e 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -351,17 +351,18 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 			       struct hsr_node *node_src)
 {
 	bool was_multicast_frame;
-	int res;
+	int res, recv_len;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
 	hsr_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
+	recv_len = skb->len;
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
 		dev->stats.rx_dropped++;
 	} else {
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += recv_len;
 		if (was_multicast_frame)
 			dev->stats.multicast++;
 	}
-- 
2.17.1

