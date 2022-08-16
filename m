Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF6F596209
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiHPSIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiHPSHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A481A844F5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660673263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZr7gdCnQUFeKt5ugQdZLofQqTfC3GDipKWYJIctC0o=;
        b=jKnJQR33+s/6djtpNYFD/kCjbCq9xCemF1A9eLB/d61NRYajO2bQtUbhkO0Lb0alT3tP1L
        ADVrTSO/eJ8votp94E0OE1PdflPYVwzTh7B9Rne1sP51ervXLLLmHtYl0yH7d8KrJYqTzq
        rIJBn3eHgGa7nYfvR0K3t0As3OdfDI0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-SU_akirANwC8OFj2U7xTcg-1; Tue, 16 Aug 2022 14:07:42 -0400
X-MC-Unique: SU_akirANwC8OFj2U7xTcg-1
Received: by mail-wm1-f72.google.com with SMTP id x16-20020a1c7c10000000b003a5cefa5578so2199720wmc.7
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qZr7gdCnQUFeKt5ugQdZLofQqTfC3GDipKWYJIctC0o=;
        b=0cgCB2gIJpwcYTPn/gQCdQl4WZjDu6uph07kHTQ7wQBOqqZGmQ3gfgs1Z28eioboHv
         UFSDGMsMYLT+uxZOIZX8uUmLlzaWVR0uH/eYt80IqUUe0Q9f6e+BUdM0XJ9T/TJgeaFg
         x2GKCgy4ZH3TGW3cM/uVCgtJ8rt39IIDuuH8UPM5CAGfvV9vrXhKOBhNsbwo4ozvLNt2
         W4bqBAhHl+WU5CRHASpPA2xCtiCs0ILFo/e+MJKgYBs6ejjPoVVmeaNlxCuBxDq9/Ktl
         SqbSNuV2+fU69UO2qKPUEQImQ9lfS73utdH1xLFqNCpTZtlNamuKURdlwTIAK8oaK3r5
         2qgg==
X-Gm-Message-State: ACgBeo1lgGe6nquIIIcL+1983apf8wLW7V83hZfTinskOyHiOaVM5y/t
        PV1mfVwtaOfh9pusDeMHeZXp3ICszbL0VMKTEs5WQSPBXzYIMX2PSUL0hWi07g7Xd2VBHhUH3vW
        aWp4wLrtUElzXr/7zpAo9LZknLAZscRtaA3HvLUXD3s+7rJQh6rYvJdH5TAs8Pc1bySFl
X-Received: by 2002:a7b:c852:0:b0:3a5:407a:76df with SMTP id c18-20020a7bc852000000b003a5407a76dfmr13708361wml.101.1660673260970;
        Tue, 16 Aug 2022 11:07:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7UPXSQNMLUdzm2OIU4YmRzUCveA1esyoYO7MxQEQacoH/hwrHSpxGq4VehHXhVW3FIbjDgTw==
X-Received: by 2002:a7b:c852:0:b0:3a5:407a:76df with SMTP id c18-20020a7bc852000000b003a5407a76dfmr13708328wml.101.1660673260684;
        Tue, 16 Aug 2022 11:07:40 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c4fc800b003a319bd3278sm14694961wmq.40.2022.08.16.11.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:07:40 -0700 (PDT)
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH 3/5] sched/topology: Introduce sched_numa_hop_mask()
Date:   Tue, 16 Aug 2022 19:07:25 +0100
Message-Id: <20220816180727.387807-4-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220816180727.387807-1-vschneid@redhat.com>
References: <20220816180727.387807-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq has pointed out that drivers allocating IRQ vectors would benefit
from having smarter NUMA-awareness - cpumask_local_spread() only knows
about the local node and everything outside is in the same bucket.

sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
of CPUs reachable within a given distance budget), introduce
sched_numa_hop_mask() to export those cpumasks.

Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/topology.h |  9 +++++++++
 kernel/sched/topology.c  | 28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..13b82b83e547 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,14 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
+#else
+static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif	/* CONFIG_NUMA */
+
 
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8739c2a5a54e..f0236a0ae65c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,6 +2067,34 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
+/**
+ * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
+ * @node: The node to count hops from.
+ * @hops: Include CPUs up to that many hops away. 0 means local node.
+ *
+ * Requires rcu_lock to be held. Returned cpumask is only valid within that
+ * read-side section, copy it if required beyond that.
+ *
+ * Note that not all hops are equal in size; see sched_init_numa() for how
+ * distances and masks are handled.
+ *
+ * Also note that this is a reflection of sched_domains_numa_masks, which may change
+ * during the lifetime of the system (offline nodes are taken out of the masks).
+ */
+const struct cpumask *sched_numa_hop_mask(int node, int hops)
+{
+	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
+
+	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
+		return ERR_PTR(-EINVAL);
+
+	if (!masks)
+		return NULL;
+
+	return masks[hops][node];
+}
+EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
+
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
-- 
2.31.1

