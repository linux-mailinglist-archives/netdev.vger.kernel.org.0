Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352FB32E515
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhCEJlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCEJl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 04:41:27 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B404C061574;
        Fri,  5 Mar 2021 01:41:27 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m22so2546052lfg.5;
        Fri, 05 Mar 2021 01:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JqE6TIRp2/AqgsOZAIl3odFyNGpL8rPzlIEYa94KCC0=;
        b=lJWCa5wxkyfNDTN9qkh1LxKwhahrbmoQRfGF9fPlpR9EUx9Ak7O8zPM9qBPVnyRYpx
         fEG6PLU5Av42rHLQ9UHDE22MiirDTsFgsQGZpjpAPMUULCjsZE4ypn4Tb1F6mp1NQHxQ
         e5rAL9uxoVGBLvZCAGudWAG7PhBhYf8dg2J0vm9fCu6dlxHTvbdShEncstNpedn2UGsj
         3kz2UPuDM4EiR9/xymARoHpxrarhAZ1++NT3U6F6uGAvKmLF6lL2SyuUUt7sSgTT/T+r
         mafkLB7C9TfFQG2VXptcdCuu326jxXjjo0iTUcYOMpbK/POYltIEpCqBvEVRMqf1eLBm
         tIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JqE6TIRp2/AqgsOZAIl3odFyNGpL8rPzlIEYa94KCC0=;
        b=FTFqSw9ySS/qzwjQbX1ZSbtdh1kBAzuFH5pKTUeQBf8IsKmafu5Ocf4zopTgZtanNk
         DslTcFcyI572b71XwH+WNo7zvFuWLBzIlaMcT8aPHSyd0uLbGBpwUWZbyL+Hagiypuu+
         EG41z4O2peR3MfoHGHhYltU+80TYkCISjCXLnmULdhvHy9IrIORC075Ije/WvFLh3oPj
         /yBRPAjl1efDLL0aOlLy2HF9RGlBhXV3hRHKvyb8mlEFJp/UHTmlYkkAK1yZs5brMXsw
         My9HBfejCspwgrt/VsKH/VAgcSqrqvyCKf6s0dJqCWxW+C3d6YGP3uW8pd4NMQYEPi7N
         NuBA==
X-Gm-Message-State: AOAM530ReCWNEaPkpup+esyzxIh4f1N5J4H7GC0sX/iywWQbquLkXsRw
        ofNFWWXeveYotYShnIvNUn8=
X-Google-Smtp-Source: ABdhPJxYoNdaodqx+CQVV92y7RCaeGcsgh7wEWbr+rh5NMWOeOViH1SpHXYf5kfvIXb0RjtwcHxIuw==
X-Received: by 2002:a05:6512:3ac:: with SMTP id v12mr4751207lfp.285.1614937285898;
        Fri, 05 Mar 2021 01:41:25 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id v80sm235371lfa.229.2021.03.05.01.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:41:25 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, toke@redhat.com,
        will@kernel.org, paulmck@kernel.org, stern@rowland.harvard.edu
Subject: [PATCH bpf-next v2 1/2] xsk: update rings for load-acquire/store-release barriers
Date:   Fri,  5 Mar 2021 10:41:12 +0100
Message-Id: <20210305094113.413544-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305094113.413544-1-bjorn.topel@gmail.com>
References: <20210305094113.413544-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Currently, the AF_XDP rings uses general smp_{r,w,}mb() barriers on
the kernel-side. On most modern architectures
load-acquire/store-release barriers perform better, and results in
simpler code for circular ring buffers.

This change updates the XDP socket rings to use
load-acquire/store-release barriers.

It is important to note that changing from the old smp_{r,w,}mb()
barriers, to load-acquire/store-release barriers does not break
compatibility. The old semantics work with the new one, and vice
versa.

As pointed out by "Documentation/memory-barriers.txt" in the "SMP
BARRIER PAIRING" section:

  "General barriers pair with each other, though they also pair with
  most other types of barriers, albeit without multicopy atomicity.
  An acquire barrier pairs with a release barrier, but both may also
  pair with other barriers, including of course general barriers."

How different barriers behaves and pairs is outlined in
"tools/memory-model/Documentation/cheatsheet.txt".

In order to make sure that compatibility is not broken, LKMM herd7
based litmus tests can be constructed and verified.

We generalize the XDP socket ring to a one entry ring, and create two
scenarios; One where the ring is full, where only the consumer can
proceed, followed by the producer. One where the ring is empty, where
only the producer can proceed, followed by the consumer. Each scenario
is then expanded to four different tests: general producer/general
consumer, general producer/acqrel consumer, acqrel producer/general
consumer, acqrel producer/acqrel consumer. In total eight tests.

The empty ring test:
  C spsc-rb+empty

  // Simple one entry ring:
  // prod cons     allowed action       prod cons
  //    0    0 =>       prod          =>   1    0
  //    0    1 =>       cons          =>   0    0
  //    1    0 =>       cons          =>   1    1
  //    1    1 =>       prod          =>   0    1

  {}

  // We start at prod==0, cons==0, data==0, i.e. nothing has been
  // written to the ring. From here only the producer can start, and
  // should write 1. Afterwards, consumer can continue and read 1 to
  // data. Can we enter state prod==1, cons==1, but consumer observed
  // the incorrect value of 0?

  P0(int *prod, int *cons, int *data)
  {
     ... producer
  }

  P1(int *prod, int *cons, int *data)
  {
     ... consumer
  }

  exists( 1:d=0 /\ prod=1 /\ cons=1 );

The full ring test:
  C spsc-rb+full

  // Simple one entry ring:
  // prod cons     allowed action       prod cons
  //    0    0 =>       prod          =>   1    0
  //    0    1 =>       cons          =>   0    0
  //    1    0 =>       cons          =>   1    1
  //    1    1 =>       prod          =>   0    1

  { prod = 1; }

  // We start at prod==1, cons==0, data==1, i.e. producer has
  // written 0, so from here only the consumer can start, and should
  // consume 0. Afterwards, producer can continue and write 1 to
  // data. Can we enter state prod==0, cons==1, but consumer observed
  // the write of 1?

  P0(int *prod, int *cons, int *data)
  {
    ... producer
  }

  P1(int *prod, int *cons, int *data)
  {
    ... consumer
  }

  exists( 1:d=1 /\ prod=0 /\ cons=1 );

where P0 and P1 are:

  P0(int *prod, int *cons, int *data)
  {
  	int p;

  	p = READ_ONCE(*prod);
  	if (READ_ONCE(*cons) == p) {
  		WRITE_ONCE(*data, 1);
  		smp_wmb();
  		WRITE_ONCE(*prod, p ^ 1);
  	}
  }

  P0(int *prod, int *cons, int *data)
  {
  	int p;

  	p = READ_ONCE(*prod);
  	if (READ_ONCE(*cons) == p) {
  		WRITE_ONCE(*data, 1);
  		smp_store_release(prod, p ^ 1);
  	}
  }

  P1(int *prod, int *cons, int *data)
  {
  	int c;
  	int d = -1;

  	c = READ_ONCE(*cons);
  	if (READ_ONCE(*prod) != c) {
  		smp_rmb();
  		d = READ_ONCE(*data);
  		smp_mb();
  		WRITE_ONCE(*cons, c ^ 1);
  	}
  }

  P1(int *prod, int *cons, int *data)
  {
  	int c;
  	int d = -1;

  	c = READ_ONCE(*cons);
  	if (smp_load_acquire(prod) != c) {
  		d = READ_ONCE(*data);
  		smp_store_release(cons, c ^ 1);
  	}
  }

The full LKMM litmus tests are found at [1].

On x86-64 systems the l2fwd AF_XDP xdpsock sample performance
increases by 1%. This is mostly due to that the smp_mb() is removed,
which is a relatively expensive operation on these
platforms. Weakly-ordered platforms, such as ARM64 might benefit even
more.

[1] https://github.com/bjoto/litmus-xsk

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_queue.h | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 2823b7c3302d..2ac3802c2cd7 100644
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
@@ -78,7 +77,8 @@ struct xsk_queue {
  *
  * (A) is a control dependency that separates the load of ->consumer
  * from the stores of $data. In case ->consumer indicates there is no
- * room in the buffer to store $data we do not. So no barrier is needed.
+ * room in the buffer to store $data we do not. The dependency will
+ * order both of the stores after the loads. So no barrier is needed.
  *
  * (D) protects the load of the data to be observed to happen after the
  * store of the consumer pointer. If we did not have this memory
@@ -227,15 +227,13 @@ static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q,
 
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
@@ -397,9 +395,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 
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

