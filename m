Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA15508BB9
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380043AbiDTPNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380096AbiDTPMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:12:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759EB13DE6;
        Wed, 20 Apr 2022 08:10:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F1572215FE;
        Wed, 20 Apr 2022 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650467400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZCkP4ZTIz8L3n5icXJW44l5GxuZEDRnsAjAP0WhQbc=;
        b=ltchNwiSpdyVnlwL94VdMGg3q9XkNrTd8PU8GecHmmKA2xueh8TSnLik9ju2nQgFdU7jAI
        fouQD9Ufzdt2SX7rghRnRK21cspyfWJSePo4SMHeff6MNuZopRUi8C1YLrbQaWkDstD8fp
        lKCwbxP0tpg7NCPGqZst22fehTkYZ20=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B560113AD5;
        Wed, 20 Apr 2022 15:10:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kMInK0giYGJILQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 20 Apr 2022 15:10:00 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 11/18] xen/netfront: use xenbus_setup_ring() and xenbus_teardown_ring()
Date:   Wed, 20 Apr 2022 17:09:35 +0200
Message-Id: <20220420150942.31235-12-jgross@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220420150942.31235-1-jgross@suse.com>
References: <20220420150942.31235-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify netfront's ring creation and removal via xenbus_setup_ring()
and xenbus_teardown_ring().

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/net/xen-netfront.c | 49 +++++++++-----------------------------
 1 file changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index af3d3de7d9fa..880b10d435d9 100644
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
@@ -1930,34 +1929,22 @@ static int setup_netfront(struct xenbus_device *dev,
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
+
 	SHARED_RING_INIT(txs);
 	FRONT_RING_INIT(&queue->tx, txs, XEN_PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, txs, 1, &gref);
-	if (err < 0)
+	err = xenbus_setup_ring(dev, GFP_NOIO | __GFP_HIGH, (void **)&rxs,
+				1, &queue->rx_ring_ref);
+	if (err)
 		goto fail;
-	queue->tx_ring_ref = gref;
 
-	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_NOIO | __GFP_HIGH);
-	if (!rxs) {
-		err = -ENOMEM;
-		xenbus_dev_fatal(dev, err, "allocating rx ring page");
-		goto fail;
-	}
 	SHARED_RING_INIT(rxs);
 	FRONT_RING_INIT(&queue->rx, rxs, XEN_PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, rxs, 1, &gref);
-	if (err < 0)
-		goto fail;
-	queue->rx_ring_ref = gref;
-
 	if (feature_split_evtchn)
 		err = setup_netfront_split(queue);
 	/* setup single event channel if
@@ -1972,24 +1959,10 @@ static int setup_netfront(struct xenbus_device *dev,
 
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
2.34.1

