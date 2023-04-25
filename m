Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE8D6EDFCA
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjDYJzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjDYJzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960D77680
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682416501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dXJzPS+ePXRUuevqx+bM8cqSxNYtGQViXtw1IEUktqU=;
        b=U/FyvZtYarwUmPi1qpYs0ZSp9iHHdEUXnZb5EqHrFl1Bpo4RIPFECKeSDHyQCPMwldbM/M
        GoLacOgWTYNWTSZYWtB04lip3yD0ZoqANuPHfLHSA1PE9jUo9y8yLh2BgPRL/wzddXSHfF
        NPEH4klaA9dPnxyl2iMrMdhk42d2n5A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-r4-uxi9tMf2eGHR3gZp6MQ-1; Tue, 25 Apr 2023 05:54:59 -0400
X-MC-Unique: r4-uxi9tMf2eGHR3gZp6MQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f080f534acso34795565e9.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682416498; x=1685008498;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXJzPS+ePXRUuevqx+bM8cqSxNYtGQViXtw1IEUktqU=;
        b=P5oJrB7u9Epwn1UiwjsaYGaHRe5Yb5wNCIXors57P3FZWZmiew74MplFPNfFTdfx3S
         TsxI9Uuy+laXFIlpmezM+Ii4+05+EmG1KfJ6YgbpoeTqhkmkcX4SIv5USJLsH+GQn17+
         H+JLObwcmbJVYySGgBhd28QLepFUNn+0iV26+dP5ajBDASR+6Z+Q2BFRfNK4QK6HY65o
         yQh2QUOSrVKObujd9jOdZBLPA/add6v+a1JmBcqWr0AihXhHYbWvzOphqCbdVrV5O60/
         LnUZz9YOYOi86JMYD3+ScMhHSAbAkz1M6UlgIAH39DQHg933PANfDIUhgD3iLORnI49u
         vYLQ==
X-Gm-Message-State: AAQBX9cU8vbhkcs0Q7pNf8utSxl8P2ojsZP+jfy3TGU5cEMcZg6BnbHa
        jpQ5Stu74973ag51iJ88ADaDmVRaT84HcvXku4ZbCwNSs73nAyf3Psc6eqlNEQr7nG7wmOfH0CX
        ustIinDXXCUI+b+Xd
X-Received: by 2002:a05:6000:1b8b:b0:304:71e8:d506 with SMTP id r11-20020a0560001b8b00b0030471e8d506mr6085487wru.48.1682416498709;
        Tue, 25 Apr 2023 02:54:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZriQ6P2dwNQFo6Oi30r2hS8OGVkxKIxXv5H8U+rjk+60PRHJR1tm39sP/p2szoL5/lAG/tOw==
X-Received: by 2002:a05:6000:1b8b:b0:304:71e8:d506 with SMTP id r11-20020a0560001b8b00b0030471e8d506mr6085471wru.48.1682416498425;
        Tue, 25 Apr 2023 02:54:58 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003f199662956sm8665688wmc.47.2023.04.25.02.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 02:54:58 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
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
Subject: Re: [PATCH v2 2/8] sched/topology: introduce
 sched_numa_find_next_cpu()
In-Reply-To: <20230420051946.7463-3-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-3-yury.norov@gmail.com>
Date:   Tue, 25 Apr 2023 10:54:56 +0100
Message-ID: <xhsmh354ol21b.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/23 22:19, Yury Norov wrote:
> +/*
> + * sched_numa_find_next_cpu() - given the NUMA topology, find the next cpu
> + * cpumask: cpumask to find a cpu from
> + * cpu: current cpu
> + * node: local node
> + * hop: (in/out) indicates distance order of current CPU to a local node
> + *
> + * The function searches for next cpu at a given NUMA distance, indicated
> + * by hop, and if nothing found, tries to find CPUs at a greater distance,
> + * starting from the beginning.
> + *
> + * Return: cpu, or >= nr_cpu_ids when nothing found.
> + */
> +int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
> +{
> +	unsigned long *cur, *prev;
> +	struct cpumask ***masks;
> +	unsigned int ret;
> +
> +	if (*hop >= sched_domains_numa_levels)
> +		return nr_cpu_ids;
> +
> +	masks = rcu_dereference(sched_domains_numa_masks);
> +	cur = cpumask_bits(masks[*hop][node]);
> +	if (*hop == 0)
> +		ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
> +	else {
> +		prev = cpumask_bits(masks[*hop - 1][node]);
> +		ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
> +	}
> +
> +	if (ret < nr_cpu_ids)
> +		return ret;
> +
> +	*hop += 1;
> +	return sched_numa_find_next_cpu(cpus, 0, node, hop);

sched_domains_numa_levels is a fairly small number, so the recursion depth
isn't something we really need to worry about - still, the iterative
variant of this is fairly straightforward to get to:

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index e850f16c003ae..4c9a9e48fef6d 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2151,23 +2151,27 @@ int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsi
 	struct cpumask ***masks;
 	unsigned int ret;
 
-	if (*hop >= sched_domains_numa_levels)
-		return nr_cpu_ids;
+	/*
+	 * Reset @cpu to 0 when increasing @hop, since CPU numbering has no
+	 * relationship with NUMA distance: a search at @hop+1 may yield CPUs
+	 * of lower ID than previously seen!
+	 */
+	for (; *hop >= sched_domains_numa_levels; *hop += 1, cpu = 0) {
+		masks = rcu_dereference(sched_domains_numa_masks);
+		cur = cpumask_bits(masks[*hop][node]);
+
+		if (*hop == 0) {
+			ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
+		} else {
+			prev = cpumask_bits(masks[*hop - 1][node]);
+			ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
+		}
 
-	masks = rcu_dereference(sched_domains_numa_masks);
-	cur = cpumask_bits(masks[*hop][node]);
-	if (*hop == 0)
-		ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
-	else {
-		prev = cpumask_bits(masks[*hop - 1][node]);
-		ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
+		if (ret < nr_cpu_ids)
+			return ret;
 	}
 
-	if (ret < nr_cpu_ids)
-		return ret;
-
-	*hop += 1;
-	return sched_numa_find_next_cpu(cpus, 0, node, hop);
+	return nr_cpu_ids;
 }
 EXPORT_SYMBOL_GPL(sched_numa_find_next_cpu);
 

