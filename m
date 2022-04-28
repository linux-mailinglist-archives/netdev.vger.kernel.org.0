Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E416512E57
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344247AbiD1IbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344188AbiD1IbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:31:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84861A0BD1;
        Thu, 28 Apr 2022 01:27:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 213BC1F890;
        Thu, 28 Apr 2022 08:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651134471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVl00wdBYeWK59DNgpTl+klU3KYXSfeQcCWUD7CZHgs=;
        b=k881eTR02k8w1RYRfM94bVRQVC+/P1KxAKK9Vr1oaKX1zwBgry4GKvMMbwXVTKe5Vz9u53
        NzzI2WgN10PupMpUlvxc/YqIEqnJiuFBZzXUZpOWrtSvAndR0+LlKR61OsCyf7F7A5Xfen
        LBx/pgfQle9bOdS54vpk7CkRnFKHe3g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CE03013491;
        Thu, 28 Apr 2022 08:27:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qCMIMQZQamIBLgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 28 Apr 2022 08:27:50 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 12/19] xen/netfront: use xenbus_setup_ring() and xenbus_teardown_ring()
Date:   Thu, 28 Apr 2022 10:27:36 +0200
Message-Id: <20220428082743.16593-13-jgross@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428082743.16593-1-jgross@suse.com>
References: <20220428082743.16593-1-jgross@suse.com>
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
2.34.1

