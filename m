Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545646D4EF0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 19:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjDCR2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 13:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjDCR2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 13:28:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3B7B4
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 10:28:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k199-20020a2524d0000000b00b7f3a027e50so14344762ybk.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 10:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680542894;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mtCNeCtBs7UaIl5+70u85lw9Be1OaqqUg6chJoHKI+U=;
        b=c4Op671og+fHhGokbUU+H+IcOF1nWf6Mp/KZhZRh6EdFFPsQbj67F2+UXjdruBI6b6
         0aoeG0n4BU5/pVUfoB0o81ofrb7xwcCzUQFUVLdR4fKMwfK+7U6Q7+JdIKLZ+Fnmk1Ug
         Q5zUk6pH0p4dLYfC2s/ewdomwG3WxF4cXUqC0ChCyiZJrPeI+3did9fJmKTnajXIhN79
         vTeHsJe8i9IqCWGkmmPff3nAHsFpoejvC4961/xMHR7kouF4SD8TWeEfkzWH967BHQDJ
         7LCuRQo3WkBlBb8wYCfsgtbWZWfKcWM1xeWDTLUkSSF14FLTW2Qv/uxKKrlyBCcfD6Ec
         inIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680542894;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mtCNeCtBs7UaIl5+70u85lw9Be1OaqqUg6chJoHKI+U=;
        b=ctK5bcpwv0/wHrsJfjNaRE4yQCST1P610eeOXlNmx5+1QyPeCYHRhJvjCgXrPzgqgn
         tHGCgJ74B5L9SfWD/8/0MNgZGZ6xypS35H7FgXgRs6wpMAXWwH7lEEEjPwHUpFWkU/4X
         PZR/OBqPsquD1xkkOzi1ptreee9IbG4ylhiXuCu0eVDssFGRxxJJXAfXrhZT+yccxydL
         y1Dy8yrBXaVtJh5XQ5ocUMmgsfN0PmS8voDCsd2LXWF3O2NJJOyqULUOlnrvhZNDjq7p
         CZKNlW8RjXKhiYHN2dAuueI6Roo0sb86WKDMY2GpPAi9qlAvn+UcsUH0AC+hp0ZXt5Jw
         eL2w==
X-Gm-Message-State: AAQBX9eAumO6MBeT06YMACFB01zsyH+wCBuPoonIdlw7SLMpwjv4gdB7
        vic6RhPs10o9uSy/e0U3ibPdzKIQCDmw0jyMm09vSlzyXqUjIWS4scAnba4e2LiWdMG3YZ8RC6y
        4xi+aJgKu+zAPMo2llHukbhgwWx9OsBGZjX2PWzkc2Vvpmk8bj6P5I2QqrOBopLDZt/E=
X-Google-Smtp-Source: AKy350a/0t+lsidB0V51gJNCsAIBjAo/Phpq48Po3d+nA2h0NO391cKhRJoxxTndvRQW2JuNFobqlPDAedvwjg==
X-Received: from shailend.sea.corp.google.com ([2620:15c:100:202:d95f:a589:633b:9560])
 (user=shailend job=sendgmr) by 2002:a25:cb12:0:b0:b2f:bdc9:2cdc with SMTP id
 b18-20020a25cb12000000b00b2fbdc92cdcmr6842ybg.7.1680542894708; Mon, 03 Apr
 2023 10:28:14 -0700 (PDT)
Date:   Mon,  3 Apr 2023 10:28:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403172809.2939306-1-shailend@google.com>
Subject: [PATCH net v2] gve: Secure enough bytes in the first TX desc for all
 TCP pkts
From:   Shailend Chand <shailend@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shailend Chand <shailend@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Non-GSO TCP packets whose SKBs' linear portion did not include the
entire TCP header were not populating the first Tx descriptor with
as many bytes as the vNIC expected. This change ensures that all
TCP packets populate the first descriptor with the correct number of
bytes.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Shailend Chand <shailend@google.com>
---
Changes in v2:
  - Clarify that the spec being mentioned is the gVNIC spec
  - Add a define for the "182" magic number

 drivers/net/ethernet/google/gve/gve.h    |  2 ++
 drivers/net/ethernet/google/gve/gve_tx.c | 12 +++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 64eb0442c82f..005cb9dfe078 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -47,6 +47,8 @@
 
 #define GVE_RX_BUFFER_SIZE_DQO 2048
 
+#define GVE_GQ_TX_MIN_PKT_DESC_BYTES 182
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 4888bf05fbed..5e11b8236754 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -284,8 +284,8 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 	int bytes;
 	int hlen;
 
-	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) +
-				 tcp_hdrlen(skb) : skb_headlen(skb);
+	hlen = skb_is_gso(skb) ? skb_checksum_start_offset(skb) + tcp_hdrlen(skb) :
+				 min_t(int, GVE_GQ_TX_MIN_PKT_DESC_BYTES, skb->len);
 
 	pad_bytes = gve_tx_fifo_pad_alloc_one_frag(&tx->tx_fifo,
 						   hlen);
@@ -454,13 +454,11 @@ static int gve_tx_add_skb_copy(struct gve_priv *priv, struct gve_tx_ring *tx, st
 	pkt_desc = &tx->desc[idx];
 
 	l4_hdr_offset = skb_checksum_start_offset(skb);
-	/* If the skb is gso, then we want the tcp header in the first segment
-	 * otherwise we want the linear portion of the skb (which will contain
-	 * the checksum because skb->csum_start and skb->csum_offset are given
-	 * relative to skb->head) in the first segment.
+	/* If the skb is gso, then we want the tcp header alone in the first segment
+	 * otherwise we want the minimum required by the gVNIC spec.
 	 */
 	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
-			skb_headlen(skb);
+			min_t(int, GVE_GQ_TX_MIN_PKT_DESC_BYTES, skb->len);
 
 	info->skb =  skb;
 	/* We don't want to split the header, so if necessary, pad to the end
-- 
2.40.0.348.gf938b09366-goog

