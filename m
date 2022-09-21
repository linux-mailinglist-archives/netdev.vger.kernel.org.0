Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1195E56C7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 01:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiIUXgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 19:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIUXgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 19:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A01A1A72;
        Wed, 21 Sep 2022 16:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2085D62DF6;
        Wed, 21 Sep 2022 23:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A973C433C1;
        Wed, 21 Sep 2022 23:35:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ijKVoCKw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663803356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S/n8TJNSRzdFdOsY5cyk0+HSK5arZ9DdVtB31KuuOXM=;
        b=ijKVoCKweZnyiZ3Wu+h804zCQJcUcpRaPjO8yQKTRFTwqXl0jjDqaHNkDsNLdJQHoHaNAK
        IrhuwrGKq9pqJkQVzAxSqnJBv8prKkbMJaFaoeIOiprzxh3fsqgNvHJe2Kyt5pHd6nW2F+
        xjdgYFxFcRmg6q1egiMIA/OqBdZgxXQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 123ba1c6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 21 Sep 2022 23:35:56 +0000 (UTC)
Date:   Thu, 22 Sep 2022 01:35:53 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sherry Yang <sherry.yang@oracle.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        sultan@kerneltoast.com
Cc:     Jack Vogel <jack.vogel@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: 10% regression in qperf tcp latency after introducing commit
 "4a61bf7f9b18 random: defer fast pool mixing to worker"
Message-ID: <Yyuf2aXlLdCu9pi1@zx2c4.com>
References: <B1BC4DB8-8F40-4975-B8E7-9ED9BFF1D50E@oracle.com>
 <CAHmME9rUn0b5FKNFYkxyrn5cLiuW_nOxUZi3mRpPaBkUo9JWEQ@mail.gmail.com>
 <04044E39-B150-4147-A090-3D942AF643DF@oracle.com>
 <CAHmME9oKcqceoFpKkooCp5wriLLptpN=+WrrG0KcDWjBahM0bQ@mail.gmail.com>
 <BD03BFF6-C369-4D34-A38B-49653F1CBC53@oracle.com>
 <YyuREcGAXV9828w5@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YyuREcGAXV9828w5@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey again Sherry,

On Thu, Sep 22, 2022 at 12:32:49AM +0200, Jason A. Donenfeld wrote:
> That leads me to suspect that queue_work_on() might actually not be as
> cheap as I assumed? If so, is that surprising to anybody else? And what
> should we do about this?

Sultan (CC'd) suggested I look at the much less expensive softirq
tasklet for this, which matches the use case pretty much entirely as
well. Can you try out this patch below and see if it resolves the
performance regression?

Thanks,
Jason

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

