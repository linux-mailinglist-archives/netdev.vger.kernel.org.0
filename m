Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54356EB278
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 21:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjDUTrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjDUTrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 15:47:04 -0400
Received: from mx16lb.world4you.com (mx16lb.world4you.com [81.19.149.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8811C19A1;
        Fri, 21 Apr 2023 12:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LXPw+LvXzo5BUGOsHJn27bI1TyQdZVrsMR8LA1HTySQ=; b=ubTkblDVaS9D8o5HKEjHIzTVMd
        T1me198gG4EB9OhNzy3nnPtwhTrWKKnrYOUxTEnlWz6jFsET8KBw3cDTCcq1SeUJvNjxxuV8Zf0pi
        w+sYk+m9M+X/r/v0Lyjsove0GRLcJqnW/MidkKBn7KElIM+lpjrnKbD+f5FBwMFM7Ymw=;
Received: from 88-117-57-231.adsl.highway.telekom.at ([88.117.57.231] helo=hornet.engleder.at)
        by mx16lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ppwii-0006HW-MU; Fri, 21 Apr 2023 21:47:00 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 4/6] tsnep: Move skb receive action to separate function
Date:   Fri, 21 Apr 2023 21:46:54 +0200
Message-Id: <20230421194656.48063-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421194656.48063-1-gerhard@engleder-embedded.com>
References: <20230421194656.48063-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function tsnep_rx_poll() is already pretty long and the skb receive
action can be reused for XSK zero-copy support. Move page based skb
receive to separate function.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 39 +++++++++++++---------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 039629af6a43..2db94b96a1f0 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1076,6 +1076,28 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 	return skb;
 }
 
+static void tsnep_rx_page(struct tsnep_rx *rx, struct napi_struct *napi,
+			  struct page *page, int length)
+{
+	struct sk_buff *skb;
+
+	skb = tsnep_build_skb(rx, page, length);
+	if (skb) {
+		page_pool_release_page(rx->page_pool, page);
+
+		rx->packets++;
+		rx->bytes += length;
+		if (skb->pkt_type == PACKET_MULTICAST)
+			rx->multicast++;
+
+		napi_gro_receive(napi, skb);
+	} else {
+		page_pool_recycle_direct(rx->page_pool, page);
+
+		rx->dropped++;
+	}
+}
+
 static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 int budget)
 {
@@ -1085,7 +1107,6 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 	struct netdev_queue *tx_nq;
 	struct bpf_prog *prog;
 	struct xdp_buff xdp;
-	struct sk_buff *skb;
 	struct tsnep_tx *tx;
 	int desc_available;
 	int xdp_status = 0;
@@ -1170,21 +1191,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			}
 		}
 
-		skb = tsnep_build_skb(rx, entry->page, length);
-		if (skb) {
-			page_pool_release_page(rx->page_pool, entry->page);
-
-			rx->packets++;
-			rx->bytes += length;
-			if (skb->pkt_type == PACKET_MULTICAST)
-				rx->multicast++;
-
-			napi_gro_receive(napi, skb);
-		} else {
-			page_pool_recycle_direct(rx->page_pool, entry->page);
-
-			rx->dropped++;
-		}
+		tsnep_rx_page(rx, napi, entry->page, length);
 		entry->page = NULL;
 	}
 
-- 
2.30.2

