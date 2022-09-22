Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48BB5E68E4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 18:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiIVQz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 12:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiIVQzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 12:55:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC0EEB6A;
        Thu, 22 Sep 2022 09:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 355A561174;
        Thu, 22 Sep 2022 16:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADD0C433C1;
        Thu, 22 Sep 2022 16:55:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fycoWGBA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663865745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N73clIXixeJ/JM4wCsOBXre5Rf6uhDiyb/I7sNh+v+4=;
        b=fycoWGBAAwuWPYDyBcastWyRZEkRPbxgxzUMeUh/nKVm6Q8TRp1kVyNV5HpFzFsaB147tR
        uAJxLDIAINR8BR9RxfbUbK0JAdvae1Vz1IN+IRFVVPjSnlEp/j/3lXIt7hd4HKrfGrzU+N
        +rKLeRG8Js2VhF6JhmY8L2N8XbdrZm4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f720e13b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 22 Sep 2022 16:55:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Tejun Heo <tj@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jack Vogel <jack.vogel@oracle.com>,
        sultan@kerneltoast.com, Sherry Yang <sherry.yang@oracle.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] random: use tasklet rather than workqueue for mixing fast pool
Date:   Thu, 22 Sep 2022 18:55:28 +0200
Message-Id: <20220922165528.3679479-1-Jason@zx2c4.com>
In-Reply-To: <YyyRMam6Eu8nmeCd@zx2c4.com>
References: <YyyRMam6Eu8nmeCd@zx2c4.com>
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
instead switch to a tasklet, which will run on the same core -- exactly
what we want -- and happen during context transition without additional
scheduling latency, and minimized logic in the enqueuing path.

Hopefully this restores performance from prior to the RT changes.

Reported-by: Sherry Yang <sherry.yang@oracle.com>
Suggested-by: Sultan Alsawaf <sultan@kerneltoast.com>
Fixes: 58340f8e952b ("random: defer fast pool mixing to worker")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/YyuREcGAXV9828w5@zx2c4.com/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Hi Sherry,

I'm not going to commit to this until I receive your `Tested-by:`, so
please let me know if this fixes the problem. If not, we'll try
something else.

Thanks,
Jason

 drivers/char/random.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 520a385c7dab..ad17b36cf977 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -918,13 +918,16 @@ EXPORT_SYMBOL_GPL(unregister_random_vmfork_notifier);
 #endif
 
 struct fast_pool {
-	struct work_struct mix;
+	struct tasklet_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
 };
 
+static void mix_interrupt_randomness(struct tasklet_struct *work);
+
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
+	.mix = { .use_callback = true, .callback = mix_interrupt_randomness },
 #ifdef CONFIG_64BIT
 #define FASTMIX_PERM SIPHASH_PERMUTATION
 	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 }
@@ -973,7 +976,7 @@ int __cold random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static void mix_interrupt_randomness(struct work_struct *work)
+static void mix_interrupt_randomness(struct tasklet_struct *work)
 {
 	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
 	/*
@@ -1027,10 +1030,8 @@ void add_interrupt_randomness(int irq)
 	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
-	if (unlikely(!fast_pool->mix.func))
-		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
 	fast_pool->count |= MIX_INFLIGHT;
-	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
+	tasklet_hi_schedule(&fast_pool->mix);
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
-- 
2.37.3

