Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB735E7F17
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiIWP4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiIWP4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FB147699
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663948570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+vdqLCntBqaxf8FADpHkJLlOi77ldZqexu1XSAK/G7U=;
        b=EO02cRJbiKwJT3lx5jsk+s5c/hcXE1NAee615cy0D6W0MqgkX0b+KRhB0y95EaunBK+8nf
        PxOltZcWmpd7ysShhCTK4Yuq0bB4BcromGe5qGHES4LQ1TdNVVjHVrrloCoKALlFrzAK/d
        DTLH7seLTMNq4yagpCTXQa5JD/X3kQc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-1k4lCtnWMJGugKmFDTxLXQ-1; Fri, 23 Sep 2022 11:56:08 -0400
X-MC-Unique: 1k4lCtnWMJGugKmFDTxLXQ-1
Received: by mail-wm1-f70.google.com with SMTP id n32-20020a05600c3ba000b003b5054c71faso2448997wms.9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+vdqLCntBqaxf8FADpHkJLlOi77ldZqexu1XSAK/G7U=;
        b=aPMOY78HHkZ05Buqh1EnrwUrepeCAiYRxaCRplqUO6Dc8p/rApqA4PaUmpHZKbqXtC
         h0E57nq0s/uhacbkSXfJwRVC5cBYbkozR4IxK+sMefG4otrxxAOujE1yaPiqw9j+mIlJ
         qKwSdgNlj/828+G+D/kmJgjGuLxypgidjlVk/8WUUA2eAwPs8VlVMGCW6pswTUUvN8GR
         OdOp8qXwWZ/KYHS2IpglJ/nPlxxTX2y2IHClYASPz619bqmg0AGC/ZzA8Fq69rag495k
         p2YRIjqj3G4GzQJBdpC4FHfabubXv+c4387HSmDBqQ+mAsZWryc5Hot4XCtOI7SvKjnB
         bnyw==
X-Gm-Message-State: ACrzQf1CzG9R/6NoqbpfNmsKE5pIODFr018KPAHXI0tjw7ffR7YeHbkS
        ev1ttznNqYKX+1utnEr4XXZHWgo/araZl5F9YRUR/sGMvspIo8lrFD5IA2ATpppUNdTPq7M8mts
        aF7JVE/I4yWgSYVYSdpf+8+9ODqpq0tBHSTzoXy/ZrYl1EJkMLjbBr60umRfiyBfMMgiK
X-Received: by 2002:a7b:c457:0:b0:3b4:689d:b408 with SMTP id l23-20020a7bc457000000b003b4689db408mr13584487wmi.22.1663948566684;
        Fri, 23 Sep 2022 08:56:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7tQjllyoAjaE0hgO29ZvO5RUX4Pw8HfukZFiwY7GUlODEt13p9thEkh19Yx2eyohjKDv4MTg==
X-Received: by 2002:a7b:c457:0:b0:3b4:689d:b408 with SMTP id l23-20020a7bc457000000b003b4689db408mr13584449wmi.22.1663948566427;
        Fri, 23 Sep 2022 08:56:06 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b0021badf3cb26sm9055429wrv.63.2022.09.23.08.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:56:05 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v4 6/7] sched/topology: Introduce for_each_numa_hop_cpu()
Date:   Fri, 23 Sep 2022 16:55:41 +0100
Message-Id: <20220923155542.1212814-5-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220923132527.1001870-1-vschneid@redhat.com>
References: <20220923132527.1001870-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recently introduced sched_numa_hop_mask() exposes cpumasks of CPUs
reachable within a given distance budget, but this means each successive
cpumask is a superset of the previous one.

Code wanting to allocate one item per CPU (e.g. IRQs) at increasing
distances would thus need to allocate a temporary cpumask to note which
CPUs have already been visited. This can be prevented by leveraging
for_each_cpu_andnot() - package all that logic into one ugl^D fancy macro.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/topology.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 3e91ae6d0ad5..7aa7e6a4c739 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -257,5 +257,42 @@ static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
 }
 #endif	/* CONFIG_NUMA */
 
+/**
+ * for_each_numa_hop_cpu - iterate over CPUs by increasing NUMA distance,
+ *                         starting from a given node.
+ * @cpu: the iteration variable.
+ * @node: the NUMA node to start the search from.
+ *
+ * Requires rcu_lock to be held.
+ * Careful: this is a double loop, 'break' won't work as expected.
+ *
+ *
+ * Implementation notes:
+ *
+ * Providing it is valid, the mask returned by
+ *  sched_numa_hop_mask(node, hops+1)
+ * is a superset of the one returned by
+ *   sched_numa_hop_mask(node, hops)
+ * which may not be that useful for drivers that try to spread things out and
+ * want to visit a CPU not more than once.
+ *
+ * To accommodate for that, we use for_each_cpu_andnot() to iterate over the cpus
+ * of sched_numa_hop_mask(node, hops+1) with the CPUs of
+ * sched_numa_hop_mask(node, hops) removed, IOW we only iterate over CPUs
+ * a given distance away (rather than *up to* a given distance).
+ *
+ * hops=0 forces us to play silly games: we pass cpu_none_mask to
+ * for_each_cpu_andnot(), which turns it into for_each_cpu().
+ */
+#define for_each_numa_hop_cpu(cpu, node)				       \
+	for (struct { const struct cpumask *curr, *prev; int hops; } __v =     \
+		     { sched_numa_hop_mask(node, 0), NULL, 0 };		       \
+	     !IS_ERR_OR_NULL(__v.curr);					       \
+	     __v.hops++,                                                       \
+	     __v.prev = __v.curr,					       \
+	     __v.curr = sched_numa_hop_mask(node, __v.hops))                   \
+		for_each_cpu_andnot(cpu,				       \
+				    __v.curr,				       \
+				    __v.hops ? __v.prev : cpu_none_mask)
 
 #endif /* _LINUX_TOPOLOGY_H */
-- 
2.31.1

