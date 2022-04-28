Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03986512E54
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344239AbiD1IbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344173AbiD1IbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:31:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1942A0BC7;
        Thu, 28 Apr 2022 01:27:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 464531F8AC;
        Thu, 28 Apr 2022 08:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651134470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8veqePX7rdlWDFOqgS78jUbLrgjtOmHQWA4ds9ys4IE=;
        b=rlIU5c4XpDDC7FrePn4vUJzKDyXHqwBA/KrdUbuegUL/GMk4CbeRxuLFKYzRcV4h6uEH0R
        L0jIaXxjVS2Dr3TW9oriwnhhCWoUjTrAD4Ua6LmdjKnMAEecMlj3qMU8neAALFcwsCaTww
        qTn2D9U/CoxHhFQs9ltdPwvn5qwcNqw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 038BE13491;
        Thu, 28 Apr 2022 08:27:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kIMQOwVQamIBLgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 28 Apr 2022 08:27:49 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 09/19] xen: update ring.h
Date:   Thu, 28 Apr 2022 10:27:33 +0200
Message-Id: <20220428082743.16593-10-jgross@suse.com>
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

Update include/xen/interface/io/ring.h to its newest version.

Switch the two improper use cases of RING_HAS_UNCONSUMED_RESPONSES() to
XEN_RING_NR_UNCONSUMED_RESPONSES() in order to avoid the nasty
XEN_RING_HAS_UNCONSUMED_IS_BOOL #define.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- new patch
---
 drivers/net/xen-netfront.c      |  4 ++--
 include/xen/interface/io/ring.h | 19 ++++++++++++++-----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index af3d3de7d9fa..966bee2a6902 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -866,7 +866,7 @@ static void xennet_set_rx_rsp_cons(struct netfront_queue *queue, RING_IDX val)
 
 	spin_lock_irqsave(&queue->rx_cons_lock, flags);
 	queue->rx.rsp_cons = val;
-	queue->rx_rsp_unconsumed = RING_HAS_UNCONSUMED_RESPONSES(&queue->rx);
+	queue->rx_rsp_unconsumed = XEN_RING_NR_UNCONSUMED_RESPONSES(&queue->rx);
 	spin_unlock_irqrestore(&queue->rx_cons_lock, flags);
 }
 
@@ -1498,7 +1498,7 @@ static bool xennet_handle_rx(struct netfront_queue *queue, unsigned int *eoi)
 		return false;
 
 	spin_lock_irqsave(&queue->rx_cons_lock, flags);
-	work_queued = RING_HAS_UNCONSUMED_RESPONSES(&queue->rx);
+	work_queued = XEN_RING_NR_UNCONSUMED_RESPONSES(&queue->rx);
 	if (work_queued > queue->rx_rsp_unconsumed) {
 		queue->rx_rsp_unconsumed = work_queued;
 		*eoi = 0;
diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
index 2470ec45ebb2..ba4c4274b714 100644
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -72,9 +72,8 @@ typedef unsigned int RING_IDX;
  * of the shared memory area (PAGE_SIZE, for instance). To initialise
  * the front half:
  *
- *     mytag_front_ring_t front_ring;
- *     SHARED_RING_INIT((mytag_sring_t *)shared_page);
- *     FRONT_RING_INIT(&front_ring, (mytag_sring_t *)shared_page, PAGE_SIZE);
+ *     mytag_front_ring_t ring;
+ *     XEN_FRONT_RING_INIT(&ring, (mytag_sring_t *)shared_page, PAGE_SIZE);
  *
  * Initializing the back follows similarly (note that only the front
  * initializes the shared ring):
@@ -146,6 +145,11 @@ struct __name##_back_ring {                                             \
 
 #define FRONT_RING_INIT(_r, _s, __size) FRONT_RING_ATTACH(_r, _s, 0, __size)
 
+#define XEN_FRONT_RING_INIT(r, s, size) do {                            \
+    SHARED_RING_INIT(s);                                                \
+    FRONT_RING_INIT(r, s, size);                                        \
+} while (0)
+
 #define BACK_RING_ATTACH(_r, _s, _i, __size) do {                       \
     (_r)->rsp_prod_pvt = (_i);                                          \
     (_r)->req_cons = (_i);                                              \
@@ -170,16 +174,21 @@ struct __name##_back_ring {                                             \
     (RING_FREE_REQUESTS(_r) == 0)
 
 /* Test if there are outstanding messages to be processed on a ring. */
-#define RING_HAS_UNCONSUMED_RESPONSES(_r)                               \
+#define XEN_RING_NR_UNCONSUMED_RESPONSES(_r)                            \
     ((_r)->sring->rsp_prod - (_r)->rsp_cons)
 
-#define RING_HAS_UNCONSUMED_REQUESTS(_r) ({                             \
+#define XEN_RING_NR_UNCONSUMED_REQUESTS(_r) ({                          \
     unsigned int req = (_r)->sring->req_prod - (_r)->req_cons;          \
     unsigned int rsp = RING_SIZE(_r) -                                  \
         ((_r)->req_cons - (_r)->rsp_prod_pvt);                          \
     req < rsp ? req : rsp;                                              \
 })
 
+#define RING_HAS_UNCONSUMED_RESPONSES(_r) \
+    (!!XEN_RING_NR_UNCONSUMED_RESPONSES(_r))
+#define RING_HAS_UNCONSUMED_REQUESTS(_r)  \
+    (!!XEN_RING_NR_UNCONSUMED_REQUESTS(_r))
+
 /* Direct access to individual ring elements, by index. */
 #define RING_GET_REQUEST(_r, _idx)                                      \
     (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].req))
-- 
2.34.1

