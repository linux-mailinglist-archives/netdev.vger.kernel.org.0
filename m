Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F346959766C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbiHQTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241480AbiHQTab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:30:31 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C090A58DE3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 12:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oOT1uaV40B5mG7pR4HrHdTNR4UXdyRqLoUrp6UOyGMw=; b=sBYq3ziZPsgv/Rp1cH2vgmlx0S
        QHFAE3fRmE4RWGITKffkaCDG1rVxX1y+ntiIWNt4NOW68aetscSwkPGUOaVv2ISpgExV88XF1v617
        HxeM+o3dfyc9Ogi43LrilJx9WjpAws89vzbDAxACHwrXp8SimpnXFnAFwrx3GKpxPSlI=;
Received: from 88-117-52-3.adsl.highway.telekom.at ([88.117.52.3] helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oOOkE-0006Vi-Ol; Wed, 17 Aug 2022 21:30:26 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 5/5] tsnep: Record RX queue
Date:   Wed, 17 Aug 2022 21:30:17 +0200
Message-Id: <20220817193017.44063-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220817193017.44063-1-gerhard@engleder-embedded.com>
References: <20220817193017.44063-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other drivers record RX queue so it should make sense to do that also.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      | 1 +
 drivers/net/ethernet/engleder/tsnep_main.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 23bbece6b7de..147fe03ca979 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -87,6 +87,7 @@ struct tsnep_rx_entry {
 struct tsnep_rx {
 	struct tsnep_adapter *adapter;
 	void __iomem *addr;
+	int queue_index;
 
 	void *page[TSNEP_RING_PAGE_COUNT];
 	dma_addr_t page_dma[TSNEP_RING_PAGE_COUNT];
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 415ae6a4b32c..19db8b1dddc4 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -749,6 +749,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 				hwtstamps->netdev_data = rx_inline;
 			}
 			skb_pull(skb, TSNEP_RX_INLINE_METADATA_SIZE);
+			skb_record_rx_queue(skb, rx->queue_index);
 			skb->protocol = eth_type_trans(skb,
 						       rx->adapter->netdev);
 
@@ -783,7 +784,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 }
 
 static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
-			 struct tsnep_rx *rx)
+			 int queue_index, struct tsnep_rx *rx)
 {
 	dma_addr_t dma;
 	int i;
@@ -792,6 +793,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
 	memset(rx, 0, sizeof(*rx));
 	rx->adapter = adapter;
 	rx->addr = addr;
+	rx->queue_index = queue_index;
 
 	retval = tsnep_rx_ring_init(rx);
 	if (retval)
@@ -878,6 +880,7 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		if (adapter->queue[i].rx) {
 			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
 			retval = tsnep_rx_open(adapter, addr,
+					       rx_queue_index,
 					       adapter->queue[i].rx);
 			if (retval)
 				goto failed;
-- 
2.30.2

