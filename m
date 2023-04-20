Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E646E8985
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjDTFUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbjDTFT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:19:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05374C35;
        Wed, 19 Apr 2023 22:19:56 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b4dfead1bso586496b3a.3;
        Wed, 19 Apr 2023 22:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681967996; x=1684559996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLNvrPFQliITteAo9upC56iHsY6zcpqba+MUcf3ofEM=;
        b=WlZAMdBLHMCaLqFR3I2eFzdqPm59UWfz+KGYXtcOW/MO0//QoQQ5CLKqZQGme5y8RS
         53dlSb7LGcn/VoNs8WkLSWPCB3/u/6oBfLi/MGnAm9YvmGDNx28w4G8tzrAjIXrWSCtw
         DLpslLzfClllUH2eWmXwFJOsMioWZrE6R9n7xoYYXsLXY9dsSZN3sygetKxh37nrQIU/
         jHCVy0QTeoyzGNSZYL4gkOTMD0nT9IjHqtqCk9FleBvx95L1q6bCbmhM4bTi7YHRid0z
         4dVm4gwPeqBbCVt/VoOKd7wCAJzk8OQ/aF3RxEge04XngcGu7Wc6sqYnnP4xmwabZV2x
         OIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681967996; x=1684559996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kLNvrPFQliITteAo9upC56iHsY6zcpqba+MUcf3ofEM=;
        b=RUS/kMblVIhFT7JVFyhH1WCsHcjVD/7jgJYOray3xAX++5a68MHtUmXEGNnn3ohZMi
         YlcCin1MWPJjsXgdPrR5OeQK/7yVnhR4wpVzPEt+s1BbRurFkt0XjbnTEKejg50K0CsK
         Rm2XACvgNybHXIV4yYnaOT/w935xktVvtrZ1boQ7q+vpvv2bCDgjnLxgitYD5BXWZ6IF
         Lv+VK+K72XaBAm+qNuQSxbac7jUz/URYn+2FFErnSJ3LiQxUU31pxMNhTr+o0rWZGncG
         Y5ET+Xwo14VZcGLrB9Y7edbaG56WItOfKykZJCdctQrUKvQHCoLcdCBhcBp98+/yeOY9
         D+Gw==
X-Gm-Message-State: AAQBX9f3yOA+9hh9RZe5NIJN4TNylqxGiXoeIqASzv5GWC8j0C1GdAav
        I8eBk33nZ7nt+VFKWHOGGMc=
X-Google-Smtp-Source: AKy350aU0t2+JZiJO+n5013tFnzCTP6dgs7dJGV+W237jVDegu4iHwv7ULjmis6CnBXcEsK5GfzooQ==
X-Received: by 2002:a05:6a00:1255:b0:63b:2102:a1d4 with SMTP id u21-20020a056a00125500b0063b2102a1d4mr7203200pfi.13.1681967996230;
        Wed, 19 Apr 2023 22:19:56 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id d17-20020a056a0024d100b0063d47bfcdd5sm306160pfv.111.2023.04.19.22.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:19:55 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH v2 3/8] sched/topology: add for_each_numa_cpu() macro
Date:   Wed, 19 Apr 2023 22:19:41 -0700
Message-Id: <20230420051946.7463-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230420051946.7463-1-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

for_each_cpu() is widely used in the kernel, and it's beneficial to
create a NUMA-aware version of the macro.

Recently added for_each_numa_hop_mask() works, but switching existing
codebase to using it is not an easy process.

New for_each_numa_cpu() is designed to be similar to the for_each_cpu().
It allows to convert existing code to NUMA-aware as simple as adding a
hop iterator variable and passing it inside new macro. for_each_numa_cpu()
takes care of the rest.

At the moment, we have 2 users of NUMA-aware enumerators. One is
Melanox's in-tree driver, and another is Intel's in-review driver:

https://lore.kernel.org/lkml/20230216145455.661709-1-pawel.chmielewski@intel.com/

Both real-life examples follow the same pattern:

	for_each_numa_hop_mask(cpus, prev, node) {
 		for_each_cpu_andnot(cpu, cpus, prev) {
 			if (cnt++ == max_num)
 				goto out;
 			do_something(cpu);
 		}
		prev = cpus;
 	}

With the new macro, it would look like this:

	for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

Straight conversion of existing for_each_cpu() codebase to NUMA-aware
version with for_each_numa_hop_mask() is difficult because it doesn't
take a user-provided cpu mask, and eventually ends up with open-coded
double loop. With for_each_numa_cpu() it shouldn't be a brainteaser.
Consider the NUMA-ignorant example:

	cpumask_t cpus = get_mask();
	int cnt = 0, cpu;

	for_each_cpu(cpu, cpus) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

Converting it to NUMA-aware version would be as simple as:

	cpumask_t cpus = get_mask();
	int node = get_node();
	int cnt = 0, hop, cpu;

	for_each_numa_cpu(cpu, hop, node, cpus) {
		if (cnt++ == max_num)
			break;
		do_something(cpu);
 	}

The latter looks more verbose and avoids from open-coding that annoying
double loop. Another advantage is that it works with a 'hop' parameter with
the clear meaning of NUMA distance, and doesn't make people not familiar
to enumerator internals bothering with current and previous masks machinery.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 13209095d6e2..01fb3a55d7ce 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -286,4 +286,20 @@ sched_numa_hop_mask(unsigned int node, unsigned int hops)
 	     !IS_ERR_OR_NULL(mask);					       \
 	     __hops++)
 
+/**
+ * for_each_numa_cpu - iterate over cpus in increasing order taking into account
+ *		       NUMA distances from a given node.
+ * @cpu: the (optionally unsigned) integer iterator
+ * @hop: the iterator variable, must be initialized to a desired minimal hop.
+ * @node: the NUMA node to start the search from.
+ * @mask: the cpumask pointer
+ *
+ * Requires rcu_lock to be held.
+ */
+#define for_each_numa_cpu(cpu, hop, node, mask)					\
+	for ((cpu) = 0, (hop) = 0;						\
+		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
+		(cpu) < nr_cpu_ids;						\
+		(cpu)++)
+
 #endif /* _LINUX_TOPOLOGY_H */
-- 
2.34.1

