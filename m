Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA826C284F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 03:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCUCpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 22:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCUCps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 22:45:48 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Mar 2023 19:45:46 PDT
Received: from mail-m3169.qiye.163.com (mail-m3169.qiye.163.com [103.74.31.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A0B21A15
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 19:45:46 -0700 (PDT)
Received: from localhost.localdomain (unknown [106.75.220.2])
        by mail-m3169.qiye.163.com (Hmail) with ESMTPA id 9DDE47A01DC;
        Tue, 21 Mar 2023 10:30:34 +0800 (CST)
From:   Faicker Mo <faicker.mo@ucloud.cn>
To:     faicker.mo@ucloud.cn
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/net_failover: fix queue exceeding warning
Date:   Tue, 21 Mar 2023 10:29:52 +0800
Message-Id: <20230321022952.1118770-1-faicker.mo@ucloud.cn>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDThgfVhoZH01DQx5ISBhMHVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUpLTVVMTlVJSUtVSVlXWRYaDxIVHRRZQVlPS0hVSkpLSEpDVUpLS1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRw6Phw*MjJOHhgTCzw*TDgU
        GlFPCyhVSlVKTUxCSE1OQ0hOSElMVTMWGhIXVR0aEhgQHglVFhQ7DhgXFA4fVRgVRVlXWRILWUFZ
        SktNVUxOVUlJS1VJWVdZCAFZQUlKSU03Bg++
X-HM-Tid: 0a870201089100a9kurm9dde47a01dc
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the primary device queue number is bigger than the default 16,
there is a warning about the queue exceeding when tx from the
net_failover device.

Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>
---
 drivers/net/net_failover.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 7a28e082436e..d0c916a53d7c 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_device *dev,
 			txq = ops->ndo_select_queue(primary_dev, skb, sb_dev);
 		else
 			txq = netdev_pick_tx(primary_dev, skb, NULL);
-
-		qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
-
-		return txq;
+	} else {
+		txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
 	}
 
-	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
-
 	/* Save the original txq to restore before passing to the driver */
 	qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
 
-- 
2.39.1

