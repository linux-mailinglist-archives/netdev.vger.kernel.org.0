Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1746651B9EF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347444AbiEEIUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347313AbiEEIU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:20:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE894990E;
        Thu,  5 May 2022 01:16:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 887BE1F8A4;
        Thu,  5 May 2022 08:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651738607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6eg+rFc1MumAtFExaebcTMQjlP8JRCZ6MaTwnyhXTA=;
        b=PRWXK75Iy6glOCFP+BRMxBlVtN2eHikrFDyCXtCZLSYh/NlKtBEhjsX7rYe7cPq6dpCFly
        qvF85uuWPEVq+aRqbBWAp2SNiiVWB76NOqlqkde8eV21BTItvL14AtMhA40lzTs2DmU8P+
        I7XPM8jeaQbxgQQTxLE8bS2JFHwffU0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 404C813B11;
        Thu,  5 May 2022 08:16:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wBleDu+Hc2K1BwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 05 May 2022 08:16:47 +0000
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
Subject: [PATCH v3 14/21] xen/netfront: use xenbus_setup_ring() and xenbus_teardown_ring()
Date:   Thu,  5 May 2022 10:16:33 +0200
Message-Id: <20220505081640.17425-15-jgross@suse.com>
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

Simplify netfront's ring creation and removal via xenbus_setup_ring()
and xenbus_teardown_ring().

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/net/xen-netfront.c | 53 +++++++++-----------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 966bee2a6902..65ab907aca5a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1921,8 +1921,7 @@ static int setup_netfront(struct xenbus_device *dev,
 			struct netfront_queue *queue, unsigned int feature_split_evtchn)
 {
 	struct xen_netif_tx_sring *txs;
-	struct xen_netif_rx_sring *rxs = NULL;
-	grant_ref_t gref;
+	struct xen_netif_rx_sring *rxs;
 	int err;
 
 	queue->tx_ring_ref = INVALID_GRANT_REF;
@@ -1930,33 +1929,19 @@ static int setup_netfront(struct xenbus_device *dev,
 	queue->rx.sring = NULL;
 	queue->tx.sring = NULL;
 
-	txs = (struct xen_netif_tx_sring *)get_zeroed_page(GFP_NOIO | __GFP_HIGH);
-	if (!txs) {
-		err = -ENOMEM;
-		xenbus_dev_fatal(dev, err, "allocating tx ring page");
+	err = xenbus_setup_ring(dev, GFP_NOIO | __GFP_HIGH, (void **)&txs,
+				1, &queue->tx_ring_ref);
+	if (err)
 		goto fail;
-	}
-	SHARED_RING_INIT(txs);
-	FRONT_RING_INIT(&queue->tx, txs, XEN_PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, txs, 1, &gref);
-	if (err < 0)
-		goto fail;
-	queue->tx_ring_ref = gref;
+	XEN_FRONT_RING_INIT(&queue->tx, txs, XEN_PAGE_SIZE);
 
-	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_NOIO | __GFP_HIGH);
-	if (!rxs) {
-		err = -ENOMEM;
-		xenbus_dev_fatal(dev, err, "allocating rx ring page");
+	err = xenbus_setup_ring(dev, GFP_NOIO | __GFP_HIGH, (void **)&rxs,
+				1, &queue->rx_ring_ref);
+	if (err)
 		goto fail;
-	}
-	SHARED_RING_INIT(rxs);
-	FRONT_RING_INIT(&queue->rx, rxs, XEN_PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, rxs, 1, &gref);
-	if (err < 0)
-		goto fail;
-	queue->rx_ring_ref = gref;
+	XEN_FRONT_RING_INIT(&queue->rx, rxs, XEN_PAGE_SIZE);
 
 	if (feature_split_evtchn)
 		err = setup_netfront_split(queue);
@@ -1972,24 +1957,10 @@ static int setup_netfront(struct xenbus_device *dev,
 
 	return 0;
 
-	/* If we fail to setup netfront, it is safe to just revoke access to
-	 * granted pages because backend is not accessing it at this point.
-	 */
  fail:
-	if (queue->rx_ring_ref != INVALID_GRANT_REF) {
-		gnttab_end_foreign_access(queue->rx_ring_ref,
-					  (unsigned long)rxs);
-		queue->rx_ring_ref = INVALID_GRANT_REF;
-	} else {
-		free_page((unsigned long)rxs);
-	}
-	if (queue->tx_ring_ref != INVALID_GRANT_REF) {
-		gnttab_end_foreign_access(queue->tx_ring_ref,
-					  (unsigned long)txs);
-		queue->tx_ring_ref = INVALID_GRANT_REF;
-	} else {
-		free_page((unsigned long)txs);
-	}
+	xenbus_teardown_ring((void **)&queue->rx.sring, 1, &queue->rx_ring_ref);
+	xenbus_teardown_ring((void **)&queue->tx.sring, 1, &queue->tx_ring_ref);
+
 	return err;
 }
 
-- 
2.35.3

