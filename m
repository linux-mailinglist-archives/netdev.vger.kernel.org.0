Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB43327C7C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhCAKoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhCAKoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:44:06 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09A7C061786;
        Mon,  1 Mar 2021 02:43:25 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id y12so5897306ljj.12;
        Mon, 01 Mar 2021 02:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B6SlJ4/ky0MsdaBEbpjdDrtUEiElqT+bG5Rim5ZFqvk=;
        b=lfBRksQwxi13/AC5x4+OrTvaAy8PvHgvhDzTe0bww+envJ7th3Hz+4TGkzdbY14cWj
         uoXy4X9diQE387+orGRgLQUBUXM1/uIN4O40tei1u6FHBFA9kX+/BhiJcIO16Wd3kkC8
         e2NuxtsnSDKA2TiWOzOn4uLeQh3GXbzcGRoryQm7i8RE5U4lG4STFQ1/pLHKf8C3cUaJ
         KGt8mK2f1+YY52tjDf3UmuA4LNj9r6AU1Y/scj3w2Mx6+LOojGE1nDg7MxGwEO7nipZR
         RI/bNE5NNpl5uH2wcqdMW6gtQftYkP39uL/OFERU+Oxbc3EY6BaDrkhjw1C1cvLZDrMG
         u4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B6SlJ4/ky0MsdaBEbpjdDrtUEiElqT+bG5Rim5ZFqvk=;
        b=rAnPT3b1nRD7vg0Phbvh1pVqzQVTaDoIGWkYe073Ow/oMtGn3JnRWWP8zUN7WzH/Tl
         K82HdRyME/wKf2n6/Tedtp/yzJVXpFGeQI7P2zxw3N/GOlgx2Q0flcf8EX4QLNynDW6C
         +Y1fbjHcXSGHxUdmwkMusxEAGXEMuPVM6rMRgW6oi+w3sWc8xeR8zOId7LIRNkLyz1rX
         +B+H8rqqChAFm+pWGOj/dLU9qNBSvQwEDg19Q/oiGFKcgx65Uiu1dTe427c8K0MBtZUw
         AsYxoC6NR9i3/53jaR8Hlkyr1UzAguXxvWdOHF/I7QAPmgQop6E73pbuPod3mt/la0Ap
         buIQ==
X-Gm-Message-State: AOAM530hJmY/YWiGlO6mLQm/SDg28iAfQuxFQlrBodeuSkIyKFdfzTru
        DmoagbNLOtKUXiH4mGAh3io=
X-Google-Smtp-Source: ABdhPJx+90rbVIFWq6OAnvEGS1xAzQsvY3n40seyB1rdotcOJXT/pGFTtmakFjcQSa4C3toOLExA3g==
X-Received: by 2002:a2e:b522:: with SMTP id z2mr8848226ljm.416.1614595404363;
        Mon, 01 Mar 2021 02:43:24 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w26sm2247492lfr.186.2021.03.01.02.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:43:23 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org
Subject: [PATCH bpf-next 1/2] xsk: update rings for load-acquire/store-release semantics
Date:   Mon,  1 Mar 2021 11:43:17 +0100
Message-Id: <20210301104318.263262-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210301104318.263262-1-bjorn.topel@gmail.com>
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Currently, the AF_XDP rings uses smp_{r,w,}mb() fences on the
kernel-side. By updating the rings for load-acquire/store-release
semantics, the full barrier on the consumer side can be replaced with
improved performance as a nice side-effect.

Note that this change does *not* require similar changes on the
libbpf/userland side, however it is recommended [1].

On x86-64 systems, by removing the smp_mb() on the Rx and Tx side, the
l2fwd AF_XDP xdpsock sample performance increases by
1%. Weakly-ordered platforms, such as ARM64 might benefit even more.

[1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-truck/

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_queue.h | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 2823b7c3302d..e24279d8d845 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -47,19 +47,18 @@ struct xsk_queue {
 	u64 queue_empty_descs;
 };
 
-/* The structure of the shared state of the rings are the same as the
- * ring buffer in kernel/events/ring_buffer.c. For the Rx and completion
- * ring, the kernel is the producer and user space is the consumer. For
- * the Tx and fill rings, the kernel is the consumer and user space is
- * the producer.
+/* The structure of the shared state of the rings are a simple
+ * circular buffer, as outlined in
+ * Documentation/core-api/circular-buffers.rst. For the Rx and
+ * completion ring, the kernel is the producer and user space is the
+ * consumer. For the Tx and fill rings, the kernel is the consumer and
+ * user space is the producer.
  *
  * producer                         consumer
  *
- * if (LOAD ->consumer) {           LOAD ->producer
- *                    (A)           smp_rmb()       (C)
+ * if (LOAD ->consumer) {  (A)      LOAD.acq ->producer  (C)
  *    STORE $data                   LOAD $data
- *    smp_wmb()       (B)           smp_mb()        (D)
- *    STORE ->producer              STORE ->consumer
+ *    STORE.rel ->producer (B)      STORE.rel ->consumer (D)
  * }
  *
  * (A) pairs with (D), and (B) pairs with (C).
@@ -227,15 +226,13 @@ static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q,
 
 static inline void __xskq_cons_release(struct xsk_queue *q)
 {
-	smp_mb(); /* D, matches A */
-	WRITE_ONCE(q->ring->consumer, q->cached_cons);
+	smp_store_release(&q->ring->consumer, q->cached_cons); /* D, matchees A */
 }
 
 static inline void __xskq_cons_peek(struct xsk_queue *q)
 {
 	/* Refresh the local pointer */
-	q->cached_prod = READ_ONCE(q->ring->producer);
-	smp_rmb(); /* C, matches B */
+	q->cached_prod = smp_load_acquire(&q->ring->producer);  /* C, matches B */
 }
 
 static inline void xskq_cons_get_entries(struct xsk_queue *q)
@@ -397,9 +394,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 
 static inline void __xskq_prod_submit(struct xsk_queue *q, u32 idx)
 {
-	smp_wmb(); /* B, matches C */
-
-	WRITE_ONCE(q->ring->producer, idx);
+	smp_store_release(&q->ring->producer, idx); /* B, matches C */
 }
 
 static inline void xskq_prod_submit(struct xsk_queue *q)
-- 
2.27.0

