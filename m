Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC84251BA0F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347842AbiEEIVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347056AbiEEIUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:20:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AD044A13;
        Thu,  5 May 2022 01:16:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DDDEC1F855;
        Thu,  5 May 2022 08:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651738604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wb0uPnKVxH6X1fgBon9Xmych7JExQqCQIYQDdDvAVlQ=;
        b=k1MwMA6LVKHn4L9RbGeodLm/ou5drbiC+/MbupQdZY0wZom9Er4mw5atok2+PHFm4+7p5o
        pe7ibN48YJRZ4BpfaAyM4qGPRz6VZ3mDCKlIU2/4/HGucH1zu9hjHWvMmeidZ0WHufVZCh
        LzZlGjtJFZCHchL/8oPj8rkEjUasN8Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 945B313B12;
        Thu,  5 May 2022 08:16:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cF3JIuyHc2K1BwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 05 May 2022 08:16:44 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v3 04/21] xen/netfront: switch netfront to use INVALID_GRANT_REF
Date:   Thu,  5 May 2022 10:16:23 +0200
Message-Id: <20220505081640.17425-5-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220505081640.17425-1-jgross@suse.com>
References: <20220505081640.17425-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using a private macro for an invalid grant reference use
the common one.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/net/xen-netfront.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e2b4a1893a13..af3d3de7d9fa 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -78,8 +78,6 @@ struct netfront_cb {
 
 #define RX_COPY_THRESHOLD 256
 
-#define GRANT_INVALID_REF	0
-
 #define NET_TX_RING_SIZE __CONST_RING_SIZE(xen_netif_tx, XEN_PAGE_SIZE)
 #define NET_RX_RING_SIZE __CONST_RING_SIZE(xen_netif_rx, XEN_PAGE_SIZE)
 
@@ -224,7 +222,7 @@ static grant_ref_t xennet_get_rx_ref(struct netfront_queue *queue,
 {
 	int i = xennet_rxidx(ri);
 	grant_ref_t ref = queue->grant_rx_ref[i];
-	queue->grant_rx_ref[i] = GRANT_INVALID_REF;
+	queue->grant_rx_ref[i] = INVALID_GRANT_REF;
 	return ref;
 }
 
@@ -432,7 +430,7 @@ static bool xennet_tx_buf_gc(struct netfront_queue *queue)
 			}
 			gnttab_release_grant_reference(
 				&queue->gref_tx_head, queue->grant_tx_ref[id]);
-			queue->grant_tx_ref[id] = GRANT_INVALID_REF;
+			queue->grant_tx_ref[id] = INVALID_GRANT_REF;
 			queue->grant_tx_page[id] = NULL;
 			add_id_to_list(&queue->tx_skb_freelist, queue->tx_link, id);
 			dev_kfree_skb_irq(skb);
@@ -1021,7 +1019,7 @@ static int xennet_get_responses(struct netfront_queue *queue,
 		 * the backend driver. In future this should flag the bad
 		 * situation to the system controller to reboot the backend.
 		 */
-		if (ref == GRANT_INVALID_REF) {
+		if (ref == INVALID_GRANT_REF) {
 			if (net_ratelimit())
 				dev_warn(dev, "Bad rx response id %d.\n",
 					 rx->id);
@@ -1390,7 +1388,7 @@ static void xennet_release_tx_bufs(struct netfront_queue *queue)
 		gnttab_end_foreign_access(queue->grant_tx_ref[i],
 					  (unsigned long)page_address(queue->grant_tx_page[i]));
 		queue->grant_tx_page[i] = NULL;
-		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
+		queue->grant_tx_ref[i] = INVALID_GRANT_REF;
 		add_id_to_list(&queue->tx_skb_freelist, queue->tx_link, i);
 		dev_kfree_skb_irq(skb);
 	}
@@ -1411,7 +1409,7 @@ static void xennet_release_rx_bufs(struct netfront_queue *queue)
 			continue;
 
 		ref = queue->grant_rx_ref[id];
-		if (ref == GRANT_INVALID_REF)
+		if (ref == INVALID_GRANT_REF)
 			continue;
 
 		page = skb_frag_page(&skb_shinfo(skb)->frags[0]);
@@ -1422,7 +1420,7 @@ static void xennet_release_rx_bufs(struct netfront_queue *queue)
 		get_page(page);
 		gnttab_end_foreign_access(ref,
 					  (unsigned long)page_address(page));
-		queue->grant_rx_ref[id] = GRANT_INVALID_REF;
+		queue->grant_rx_ref[id] = INVALID_GRANT_REF;
 
 		kfree_skb(skb);
 	}
@@ -1761,7 +1759,7 @@ static int netfront_probe(struct xenbus_device *dev,
 static void xennet_end_access(int ref, void *page)
 {
 	/* This frees the page as a side-effect */
-	if (ref != GRANT_INVALID_REF)
+	if (ref != INVALID_GRANT_REF)
 		gnttab_end_foreign_access(ref, (unsigned long)page);
 }
 
@@ -1798,8 +1796,8 @@ static void xennet_disconnect_backend(struct netfront_info *info)
 		xennet_end_access(queue->tx_ring_ref, queue->tx.sring);
 		xennet_end_access(queue->rx_ring_ref, queue->rx.sring);
 
-		queue->tx_ring_ref = GRANT_INVALID_REF;
-		queue->rx_ring_ref = GRANT_INVALID_REF;
+		queue->tx_ring_ref = INVALID_GRANT_REF;
+		queue->rx_ring_ref = INVALID_GRANT_REF;
 		queue->tx.sring = NULL;
 		queue->rx.sring = NULL;
 
@@ -1927,8 +1925,8 @@ static int setup_netfront(struct xenbus_device *dev,
 	grant_ref_t gref;
 	int err;
 
-	queue->tx_ring_ref = GRANT_INVALID_REF;
-	queue->rx_ring_ref = GRANT_INVALID_REF;
+	queue->tx_ring_ref = INVALID_GRANT_REF;
+	queue->rx_ring_ref = INVALID_GRANT_REF;
 	queue->rx.sring = NULL;
 	queue->tx.sring = NULL;
 
@@ -1978,17 +1976,17 @@ static int setup_netfront(struct xenbus_device *dev,
 	 * granted pages because backend is not accessing it at this point.
 	 */
  fail:
-	if (queue->rx_ring_ref != GRANT_INVALID_REF) {
+	if (queue->rx_ring_ref != INVALID_GRANT_REF) {
 		gnttab_end_foreign_access(queue->rx_ring_ref,
 					  (unsigned long)rxs);
-		queue->rx_ring_ref = GRANT_INVALID_REF;
+		queue->rx_ring_ref = INVALID_GRANT_REF;
 	} else {
 		free_page((unsigned long)rxs);
 	}
-	if (queue->tx_ring_ref != GRANT_INVALID_REF) {
+	if (queue->tx_ring_ref != INVALID_GRANT_REF) {
 		gnttab_end_foreign_access(queue->tx_ring_ref,
 					  (unsigned long)txs);
-		queue->tx_ring_ref = GRANT_INVALID_REF;
+		queue->tx_ring_ref = INVALID_GRANT_REF;
 	} else {
 		free_page((unsigned long)txs);
 	}
@@ -2020,7 +2018,7 @@ static int xennet_init_queue(struct netfront_queue *queue)
 	queue->tx_pend_queue = TX_LINK_NONE;
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
 		queue->tx_link[i] = i + 1;
-		queue->grant_tx_ref[i] = GRANT_INVALID_REF;
+		queue->grant_tx_ref[i] = INVALID_GRANT_REF;
 		queue->grant_tx_page[i] = NULL;
 	}
 	queue->tx_link[NET_TX_RING_SIZE - 1] = TX_LINK_NONE;
@@ -2028,7 +2026,7 @@ static int xennet_init_queue(struct netfront_queue *queue)
 	/* Clear out rx_skbs */
 	for (i = 0; i < NET_RX_RING_SIZE; i++) {
 		queue->rx_skbs[i] = NULL;
-		queue->grant_rx_ref[i] = GRANT_INVALID_REF;
+		queue->grant_rx_ref[i] = INVALID_GRANT_REF;
 	}
 
 	/* A grant for every tx ring slot */
-- 
2.35.3

