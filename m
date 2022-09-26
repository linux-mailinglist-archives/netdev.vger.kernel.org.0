Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1705D5EB422
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiIZWGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiIZWFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEB1AE6E;
        Mon, 26 Sep 2022 15:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05E73B811CC;
        Mon, 26 Sep 2022 22:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAC0C433D6;
        Mon, 26 Sep 2022 22:05:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="p0x5YAy1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664229906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2d/KOy5STZq6TUCEdm7KBWJkEx7SxOt3t2eUWdbSRI=;
        b=p0x5YAy1mEx2xJjfX+VSErZwLHrStA1Juk9J5QpcQQO5r8wY7qogwegXWpSfqsaT/RiS+s
        6zDkny+4w5BphpnveXg1qt/SJrfvpdg5Mh7RhjN/dQ+SEu0dXV4lK3aziUlKczpn5JIh7F
        V8oQwxJAsdeICvGewJ3cqxDBrogweYw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5cfdcae2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 26 Sep 2022 22:05:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sherry Yang <sherry.yang@oracle.com>,
        Paul Webb <paul.x.webb@oracle.com>,
        Phillip Goerl <phillip.goerl@oracle.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Nicky Veitch <nicky.veitch@oracle.com>,
        Colm Harrington <colm.harrington@oracle.com>,
        Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tejun Heo <tj@kernel.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org
Subject: [PATCH v2] random: use immediate per-cpu timer rather than workqueue for mixing fast pool
Date:   Tue, 27 Sep 2022 00:04:57 +0200
Message-Id: <20220926220457.1517120-1-Jason@zx2c4.com>
In-Reply-To: <20220922165528.3679479-1-Jason@zx2c4.com>
References: <20220922165528.3679479-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the fast pool was dumped into the main pool peroidically in
the fast pool's hard IRQ handler. This worked fine and there weren't
problems with it, until RT came around. Since RT converts spinlocks into
sleeping locks, problems cropped up. Rather than switching to raw
spinlocks, the RT developers preferred we make the transformation from
originally doing:

    do_some_stuff()
    spin_lock()
    do_some_other_stuff()
    spin_unlock()

to doing:

    do_some_stuff()
    queue_work_on(some_other_stuff_worker)

This is an ordinary pattern done all over the kernel. However, Sherry
noticed a 10% performance regression in qperf TCP over a 40gbps
InfiniBand card. Quoting her message:

> MT27500 Family [ConnectX-3] cards:
> Infiniband device 'mlx4_0' port 1 status:
> default gid: fe80:0000:0000:0000:0010:e000:0178:9eb1
> base lid: 0x6
> sm lid: 0x1
> state: 4: ACTIVE
> phys state: 5: LinkUp
> rate: 40 Gb/sec (4X QDR)
> link_layer: InfiniBand
>
> Cards are configured with IP addresses on private subnet for IPoIB
> performance testing.
> Regression identified in this bug is in TCP latency in this stack as reported
> by qperf tcp_lat metric:
>
> We have one system listen as a qperf server:
> [root@yourQperfServer ~]# qperf
>
> Have the other system connect to qperf server as a client (in this
> case, it’s X7 server with Mellanox card):
> [root@yourQperfClient ~]# numactl -m0 -N0 qperf 20.20.20.101 -v -uu -ub --time 60 --wait_server 20 -oo msg_size:4K:1024K:*2 tcp_lat

Rather than incur the scheduling latency from queue_work_on, we can
instead switch to running on the next timer tick, on the same core,
deferrably so. This also batches things a bit more -- once per jiffy --
which is probably okay now that mix_interrupt_randomness() can credit
multiple bits at once. It still puts a bit of pressure on fast_mix(),
but hopefully that's acceptable.

Hopefully this restores performance from prior to the RT changes.

Reported-by: Sherry Yang <sherry.yang@oracle.com>
Reported-by: Paul Webb <paul.x.webb@oracle.com>
Cc: Sherry Yang <sherry.yang@oracle.com>
Cc: Phillip Goerl <phillip.goerl@oracle.com>
Cc: Jack Vogel <jack.vogel@oracle.com>
Cc: Nicky Veitch <nicky.veitch@oracle.com>
Cc: Colm Harrington <colm.harrington@oracle.com>
Cc: Ramanan Govindarajan <ramanan.govindarajan@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: stable@vger.kernel.org
Fixes: 58340f8e952b ("random: defer fast pool mixing to worker")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1cb53495e8f7..08bb46a50802 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -928,17 +928,20 @@ struct fast_pool {
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
-	struct work_struct mix;
+	struct timer_list mix;
 };
 
+static void mix_interrupt_randomness(struct timer_list *work);
+
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
 #ifdef CONFIG_64BIT
 #define FASTMIX_PERM SIPHASH_PERMUTATION
-	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 }
+	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 },
 #else
 #define FASTMIX_PERM HSIPHASH_PERMUTATION
-	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 }
+	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 },
 #endif
+	.mix = __TIMER_INITIALIZER(mix_interrupt_randomness, TIMER_DEFERRABLE)
 };
 
 /*
@@ -980,7 +983,7 @@ int __cold random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static void mix_interrupt_randomness(struct work_struct *work)
+static void mix_interrupt_randomness(struct timer_list *work)
 {
 	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
 	/*
@@ -1034,10 +1037,11 @@ void add_interrupt_randomness(int irq)
 	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
-	if (unlikely(!fast_pool->mix.func))
-		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
 	fast_pool->count |= MIX_INFLIGHT;
-	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
+	if (!timer_pending(&fast_pool->mix)) {
+		fast_pool->mix.expires = jiffies;
+		add_timer_on(&fast_pool->mix, raw_smp_processor_id());
+	}
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
-- 
2.37.3

