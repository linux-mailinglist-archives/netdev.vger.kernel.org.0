Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D0142721
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgATJWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:22:11 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36539 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgATJWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:22:10 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so12947531plm.3;
        Mon, 20 Jan 2020 01:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2U8BCFqH7p7t9lGKEloYuR2Tk0skT6QfoLljk5teH2g=;
        b=ORq92HCW3W/1wiId9JaX3gJpoJhdTu8kozeY0GEFGZTFypLrTeqHBMKiPLKRLhRad4
         CeOcnS1Cu8oFg5w9QRhITqNXVo7ZJYYRuBunohDU0MViyW0Oi7Cu43SeEK3o5/Orxys6
         LIW+oeJqbLPWRaQ0aAvW4QKu3o9EnN4E3nDIZL3F6zm/x9D3aUXU0YZhPitA2hB0NoWj
         mhKYgEGjTd/HgtL8jE7QkMhqhZBCU6I7CgWvkXJS0OfqYyuAxU0gUUAoyEuPH/Dse23K
         7/3CqApWlD70tqOj3A4r4HZXeBTWZi1hzn9NwtVyb9A92SQ+kK6GDJR9UJRa6Tfv1sL+
         1/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2U8BCFqH7p7t9lGKEloYuR2Tk0skT6QfoLljk5teH2g=;
        b=avDyuNvO19PGWjueZFcOW7Ekl4DAtfWY08OzB6kdv87KzjniCUD0CTWbQR0dg/AZAr
         iEDD2lxvlGmVFb01GMbfGou/3uQwqjRvDGx/dJpzNClT2HNjlqa6pCygmeY0A3lH1rrb
         vOM+xig4nmEuj8TJzN/PIWxkKavV2g83g2y1JSNZIVXMyk+K6/2R5wfD1yJ7bCadJHjd
         pdb70N+8Kwt8rfz+C7DXIxAijt8zJVtCfuhhQpCuPtLCNUsau5ehtkbei2tMHlIhQPg2
         EI5xhjgCiJJmvoKfXPDZvMiwy8rwzouyWakItPDnB2RQ6upGk++YgwFx0A/0IrUlYeB4
         1TlA==
X-Gm-Message-State: APjAAAUbN5FHIExnBI6ixmxgLgeydxHA6I2wSuCF/Hp6Z2iHQB1f3RwJ
        umID2FFzwDJVdGVkqORTrQsSEGmNOGQ=
X-Google-Smtp-Source: APXvYqw7kSJkQRdbjuC1S4eR288xHi27yrWS4R7Mnc8zhQge1IyPeK28BG6nwVMmjsKS4Xho7HG6iw==
X-Received: by 2002:a17:902:b781:: with SMTP id e1mr14444603pls.128.1579512129391;
        Mon, 20 Jan 2020 01:22:09 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id r2sm36098475pgv.16.2020.01.20.01.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 01:22:08 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next] xsk: update rings for load-acquire/store-release semantics
Date:   Mon, 20 Jan 2020 10:21:48 +0100
Message-Id: <20200120092149.13775-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Currently, the AF_XDP rings uses fences for the kernel-side
produce/consume functions. By updating rings for
load-acquire/store-release semantics, the full barrier (smp_mb()) on
the consumer side can be replaced.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_queue.h | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index bec2af11853a..2fff80576ee1 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -39,19 +39,18 @@ struct xsk_queue {
 	u64 invalid_descs;
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
@@ -220,15 +219,14 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 
 static inline void __xskq_cons_release(struct xsk_queue *q)
 {
-	smp_mb(); /* D, matches A */
-	WRITE_ONCE(q->ring->consumer, q->cached_cons);
+	/* D, matches A */
+	smp_store_release(&q->ring->consumer, q->cached_cons);
 }
 
 static inline void __xskq_cons_peek(struct xsk_queue *q)
 {
-	/* Refresh the local pointer */
-	q->cached_prod = READ_ONCE(q->ring->producer);
-	smp_rmb(); /* C, matches B */
+	/* C, matches B */
+	q->cached_prod = smp_load_acquire(&q->ring->producer);
 }
 
 static inline void xskq_cons_get_entries(struct xsk_queue *q)
@@ -340,9 +338,8 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 
 static inline void __xskq_prod_submit(struct xsk_queue *q, u32 idx)
 {
-	smp_wmb(); /* B, matches C */
-
-	WRITE_ONCE(q->ring->producer, idx);
+	/* B, matches C */
+	smp_store_release(&q->ring->producer, idx);
 }
 
 static inline void xskq_prod_submit(struct xsk_queue *q)
-- 
2.20.1

