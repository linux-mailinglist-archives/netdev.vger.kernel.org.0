Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034176EF0F4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 11:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbjDZJT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 05:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbjDZJT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 05:19:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFF84EE4
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682500650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fyxo9X49FJOFaiRGnal9ZnS5FLek6M+ko6PrXrYgFok=;
        b=fhItSkiq8a84EmiEwms94TrIMQkZLVnAASsSsUK22aqdqS35KxiFfmnBMnQbzAxAQxLwGw
        ttyaFyRhRKS4jrx2dh/+rkXb9Z7KQ0OMyZkS0//KAVgZ+XBbGiU7bTPQUgUdVwjvLZ17FY
        Ce1Xr/GimC/pwz+rv5TL3I0NZe+LdXU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-MOgMQ4LGMkGNX5Ud0eTK3A-1; Wed, 26 Apr 2023 05:17:28 -0400
X-MC-Unique: MOgMQ4LGMkGNX5Ud0eTK3A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f171d38db3so39802675e9.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682500647; x=1685092647;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fyxo9X49FJOFaiRGnal9ZnS5FLek6M+ko6PrXrYgFok=;
        b=AsLK+gITQCO+seOeGVjW3yj65hrUzGeHJocb2Off5VhvxVzCxWq7wOyO2sMvJcNzYy
         sqj55fmHt9RZvGn5GHUzTZsqQjzIWEGQEc/vX94cVIylGr93sSQXiW3b3gQU0txupUxm
         1ryoCXy0zkHwoIBh1CllLfWghVOvGDKT28FVJUUaTHB992E/eqSw5+PQh9NevOLgIy+k
         hfJo3PP3gEoMdnbu5IqCTU2XgSB9AeYw0PyHznCJge75b0B1l3DWYCJpDVdcvapQGxvS
         VQaSPJTBXRVEdzbi6ZUhrCv8r8gqBiHfJCm0ZCT8/jS8xeS55z26MiIiRRg+aHo2qJq8
         sHuw==
X-Gm-Message-State: AAQBX9eCtzD+qGxF/hzqtUAIbjmMTrB1+aI6lF8CqCdr685EzX0y3Cym
        +OvgpxKQnoTRQEr6O4Z/amMmPDrG6FEDRIfGEQpyYi+uK1/kWAkwzqmF8Mvv/H5HtfSbnd2d1vz
        f98UOX0rSblWWvxWE
X-Received: by 2002:a7b:cc98:0:b0:3f1:6ebe:d598 with SMTP id p24-20020a7bcc98000000b003f16ebed598mr12093515wma.7.1682500647494;
        Wed, 26 Apr 2023 02:17:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y1cqYlbWoC4PRl3Cjxhzhb92t9R7b55XlDEdK1Iyg/nOK5imWM0UbQf5LWtbMyf2ijZy/Qog==
X-Received: by 2002:a7b:cc98:0:b0:3f1:6ebe:d598 with SMTP id p24-20020a7bcc98000000b003f16ebed598mr12093489wma.7.1682500647247;
        Wed, 26 Apr 2023 02:17:27 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d5950000000b0030490c8ccafsm3246491wri.52.2023.04.26.02.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 02:17:26 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 7/8] lib: add test for for_each_numa_{cpu,hop_mask}()
In-Reply-To: <ZEi7n4ZJgF2o8Ps9@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-8-yury.norov@gmail.com>
 <xhsmh8rehkxzz.mognet@vschneid.remote.csb>
 <ZEi7n4ZJgF2o8Ps9@yury-ThinkPad>
Date:   Wed, 26 Apr 2023 10:17:25 +0100
Message-ID: <xhsmhttx3j93u.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/23 22:50, Yury Norov wrote:
> Hi Valentin,
>
> Thanks for review!
>
> On Mon, Apr 24, 2023 at 06:09:52PM +0100, Valentin Schneider wrote:
>> On 19/04/23 22:19, Yury Norov wrote:
>> > +	for (node = 0; node < sched_domains_numa_levels; node++) {
>> > +		unsigned int hop, c = 0;
>> > +
>> > +		rcu_read_lock();
>> > +		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
>> > +			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
>> > +		rcu_read_unlock();
>> > +	}
>> 
>> I'm not fond of the export of sched_domains_numa_levels, especially
>> considering it's just there for tests.
>> 
>> Furthermore, is there any value is testing parity with
>> cpumask_local_spread()?
>
> I wanted to emphasize that new NUMA-aware functions are coherent with
> each other, just like find_nth_bit() is coherent with find_next_bit().
>
> But all that coherence looks important only in non-NUMA case, because
> client code may depend on fact that next CPU is never less than current.
> This doesn't hold for NUMA iterators anyways...
>

Ah right, I see your point. But yes, distance-ordered walks break this
assumption.

>> Rather, shouldn't we check that using this API does
>> yield CPUs of increasing NUMA distance?
>> 
>> Something like
>> 
>>         for_each_node(node) {
>>                 unsigned int prev_cpu, hop = 0;
>> 
>>                 cpu = cpumask_first(cpumask_of_node(node));
>>                 prev_cpu = cpu;
>> 
>>                 rcu_read_lock();
>> 
>>                 /* Assert distance is monotonically increasing */
>>                 for_each_numa_cpu(cpu, hop, node, cpu_online_mask) {
>>                         expect_ge_uint(cpu_to_node(cpu), cpu_to_node(prev_cpu));
>>                         prev_cpu = cpu;
>>                 }
>> 
>>                 rcu_read_unlock();
>>         }
>
> Your version of the test looks more straightforward. I need to think
> for more, but it looks like I can take it in v3.
>

I realized I only wrote half the relevant code - comparing node IDs is
meaningless, I meant to compare distances as we walk through the
CPUs... I tested the below against a few NUMA topologies and it seems to be
sane:

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 6becb044a66f0..8f8512d139d58 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -174,11 +174,23 @@ __check_eq_str(const char *srcfile, unsigned int line,
 	return eq;
 }
 
-#define __expect_eq(suffix, ...)					\
+static bool __init
+__check_ge_uint(const char *srcfile, unsigned int line,
+		const unsigned int a, unsigned int b)
+{
+	if (a < b) {
+		pr_err("[%s:%u] expected a(%u) >= b(%u)\n",
+			srcfile, line, a, b);
+		return false;
+	}
+	return true;
+}
+
+#define __expect_op(op, suffix, ...)					\
 	({								\
 		int result = 0;						\
 		total_tests++;						\
-		if (!__check_eq_ ## suffix(__FILE__, __LINE__,		\
+		if (!__check_## op ## _ ## suffix(__FILE__, __LINE__,	\
 					   ##__VA_ARGS__)) {		\
 			failed_tests++;					\
 			result = 1;					\
@@ -186,6 +198,9 @@ __check_eq_str(const char *srcfile, unsigned int line,
 		result;							\
 	})
 
+#define __expect_eq(suffix, ...) __expect_op(eq, suffix, ##__VA_ARGS__)
+#define __expect_ge(suffix, ...) __expect_op(ge, suffix, ##__VA_ARGS__)
+
 #define expect_eq_uint(...)		__expect_eq(uint, ##__VA_ARGS__)
 #define expect_eq_bitmap(...)		__expect_eq(bitmap, ##__VA_ARGS__)
 #define expect_eq_pbl(...)		__expect_eq(pbl, ##__VA_ARGS__)
@@ -193,6 +208,8 @@ __check_eq_str(const char *srcfile, unsigned int line,
 #define expect_eq_clump8(...)		__expect_eq(clump8, ##__VA_ARGS__)
 #define expect_eq_str(...)		__expect_eq(str, ##__VA_ARGS__)
 
+#define expect_ge_uint(...)		__expect_ge(uint, ##__VA_ARGS__)
+
 static void __init test_zero_clear(void)
 {
 	DECLARE_BITMAP(bmap, 1024);
@@ -756,12 +773,23 @@ static void __init test_for_each_numa(void)
 {
 	unsigned int cpu, node;
 
-	for (node = 0; node < sched_domains_numa_levels; node++) {
-		unsigned int hop, c = 0;
+	for_each_node(node) {
+		unsigned int start_cpu, prev_dist, hop = 0;
+
+		cpu = cpumask_first(cpumask_of_node(node));
+		prev_dist = node_distance(node, node);
+		start_cpu = cpu;
 
 		rcu_read_lock();
-		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
-			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
+
+		/* Assert distance is monotonically increasing */
+		for_each_numa_cpu(cpu, hop, node, cpu_online_mask) {
+			unsigned int dist = node_distance(cpu_to_node(cpu), cpu_to_node(start_cpu));
+
+			expect_ge_uint(dist, prev_dist);
+			prev_dist = dist;
+		}
+
 		rcu_read_unlock();
 	}
 }

