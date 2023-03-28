Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4E36CC054
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjC1NNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjC1NNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:13:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0225FF9;
        Tue, 28 Mar 2023 06:12:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A0B271FD68;
        Tue, 28 Mar 2023 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680009176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRtiw58QBwYt1y2vIyrV4Ht9sSLlbTNKn/D5VG5kP7Q=;
        b=T8dWjekjuCeQuXPswXPubpp/ASd5SY0NYnRBczh42+aTdCelOiFWCymfpmrRbED+E+Tc08
        j1Juj+Ph6kGm1D58BaiYC5r8FLnV8X8Yp2pRbjEy91XLbE6A84OfTp95bz/xioUXHglBy9
        ivSyG2ZAVS4xp+CvmysQeiDShu/Nnfo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 465211390D;
        Tue, 28 Mar 2023 13:12:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1mr0D9jnImQvTgAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 28 Mar 2023 13:12:56 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH v2 1/3] xen/netback: don't do grant copy across page boundary
Date:   Tue, 28 Mar 2023 15:12:31 +0200
Message-Id: <20230328131233.2534-2-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230328131047.2440-1-jgross@suse.com>
References: <20230328131047.2440-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix xenvif_get_requests() not to do grant copy operations across local
page boundaries. This requires to double the maximum number of copy
operations per queue, as each copy could now be split into 2.

Make sure that struct xenvif_tx_cb doesn't grow too large.

Cc: stable@vger.kernel.org
Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---
V2:
- add another BUILD_BUG_ON() (Jan Beulich)
---
 drivers/net/xen-netback/common.h  |  2 +-
 drivers/net/xen-netback/netback.c | 27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 3dbfc8a6924e..1fcbd83f7ff2 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -166,7 +166,7 @@ struct xenvif_queue { /* Per-queue data for xenvif */
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
 	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
 
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	struct gnttab_copy tx_copy_ops[2 * MAX_PENDING_REQS];
 	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
 	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
 	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1b42676ca141..54c76af90233 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -334,6 +334,7 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 struct xenvif_tx_cb {
 	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
 	u8 copy_count;
+	u32 split_mask;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
@@ -361,6 +362,10 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	struct sk_buff *skb =
 		alloc_skb(size + NET_SKB_PAD + NET_IP_ALIGN,
 			  GFP_ATOMIC | __GFP_NOWARN);
+
+	BUILD_BUG_ON(sizeof(*XENVIF_TX_CB(skb)) > sizeof(skb->cb));
+	BUILD_BUG_ON(sizeof(XENVIF_TX_CB(skb)->split_mask) * 8 <
+		     ARRAY_SIZE(XENVIF_TX_CB(skb)->copy_pending_idx));
 	if (unlikely(skb == NULL))
 		return NULL;
 
@@ -396,11 +401,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 	nr_slots = shinfo->nr_frags + 1;
 
 	copy_count(skb) = 0;
+	XENVIF_TX_CB(skb)->split_mask = 0;
 
 	/* Create copy ops for exactly data_len bytes into the skb head. */
 	__skb_put(skb, data_len);
 	while (data_len > 0) {
 		int amount = data_len > txp->size ? txp->size : data_len;
+		bool split = false;
 
 		cop->source.u.ref = txp->gref;
 		cop->source.domid = queue->vif->domid;
@@ -413,6 +420,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
 				               - data_len);
 
+		/* Don't cross local page boundary! */
+		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
+			amount = XEN_PAGE_SIZE - cop->dest.offset;
+			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);
+			split = true;
+		}
+
 		cop->len = amount;
 		cop->flags = GNTCOPY_source_gref;
 
@@ -420,7 +434,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		pending_idx = queue->pending_ring[index];
 		callback_param(queue, pending_idx).ctx = NULL;
 		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
-		copy_count(skb)++;
+		if (!split)
+			copy_count(skb)++;
 
 		cop++;
 		data_len -= amount;
@@ -441,7 +456,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 			nr_slots--;
 		} else {
 			/* The copy op partially covered the tx_request.
-			 * The remainder will be mapped.
+			 * The remainder will be mapped or copied in the next
+			 * iteration.
 			 */
 			txp->offset += amount;
 			txp->size -= amount;
@@ -539,6 +555,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		pending_idx = copy_pending_idx(skb, i);
 
 		newerr = (*gopp_copy)->status;
+
+		/* Split copies need to be handled together. */
+		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
+			(*gopp_copy)++;
+			if (!newerr)
+				newerr = (*gopp_copy)->status;
+		}
 		if (likely(!newerr)) {
 			/* The first frag might still have this slot mapped */
 			if (i < copy_count(skb) - 1 || !sharedslot)
-- 
2.35.3

