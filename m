Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F3E58EAB5
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiHJKvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiHJKvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:51:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70EFCDF38
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660128699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQv4si4iinlbQRu6xS6GknH+Qg1JB3I9EHkZZqgX3n4=;
        b=ZyOQhKkG2E5Uu4Pm719O90t0F8rbmw6v4yZwaqt/ZsK1XPIRT/jJg2DVogIxZvRQ16hEGS
        Sv4UHEc+xKkrRLLDBarlA6tb/UKJ+5fXwSJ1PkLn7wgrsaHysJoojTaLIlqd/Xkz4TKj+6
        GYuZAQmIO2ljjc2BwUPw/XvqeHX/5G4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-7k_O8BUAP6uXR60siDFXqA-1; Wed, 10 Aug 2022 06:51:38 -0400
X-MC-Unique: 7k_O8BUAP6uXR60siDFXqA-1
Received: by mail-wm1-f71.google.com with SMTP id v11-20020a1cf70b000000b003a318238826so459704wmh.2
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=MQv4si4iinlbQRu6xS6GknH+Qg1JB3I9EHkZZqgX3n4=;
        b=GwDMGb36LjV731T60CFHkK6qKVmwVwmUe5CdClGKjYEzJskKRDvux71wkb2ElyjyIo
         UHo+6LjwIPBhnZU8rpOQncBXXYwqzerOHbjS0A4Dh9QvUD2iWTpxwONVOGsEisnWejZl
         Istk6MjUqh4dKU3qI4Ab/cP6G3cu9xOEMWHu8/tQiF6DETDMdSe2gDwDHA4nVgapdab5
         ykgwjAWjSgilk9Z94w73b+kDCib2+j25Afaxn0aR5XVMtPY+ZwVFM54/hfOUj63CFj4e
         mLljwGPXkmYwDmEdNMittQ4jIPB0J+tXczcmkb11azXaGPOQ+GDM3Xi9GY4khhVS5hhM
         SyVA==
X-Gm-Message-State: ACgBeo2vvqwIE1Bau15ssjEfMUTvkoCzDIzcMVY8p8sM4AQZUAd2VEx8
        IzvMt3dj0ZrpVRsWGyScVLDZcurCcQUtCu3DWKAzD9yLUDWdnzNp0GEFOpMkBFt94u0Yk/waPav
        q5/wzF5WkaFgzS0766d5YSreFxtgcBMsisPZDp0Ny/zTW72okI2GJOsFZ7auvqEAMdkaB
X-Received: by 2002:a5d:5a10:0:b0:221:7c17:abee with SMTP id bq16-20020a5d5a10000000b002217c17abeemr13504090wrb.698.1660128697155;
        Wed, 10 Aug 2022 03:51:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6aliMmCChoxMsmZYTSaLR+bJli/MBSTjuZvyXHArHGycG0JudiAhqIQ8qazm4dpTtVYs/4QA==
X-Received: by 2002:a5d:5a10:0:b0:221:7c17:abee with SMTP id bq16-20020a5d5a10000000b002217c17abeemr13504058wrb.698.1660128696856;
        Wed, 10 Aug 2022 03:51:36 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5406000000b0021e491fd250sm16138637wrv.89.2022.08.10.03.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 03:51:36 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 1/2] sched/topology: Introduce sched_numa_hop_mask()
Date:   Wed, 10 Aug 2022 11:51:18 +0100
Message-Id: <20220810105119.2684079-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
sched_numa_hop_mask() to export those cpumasks. Add in an iteration helper
to iterate over CPUs at an incremental distance from a given node.

Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/topology.h | 12 ++++++++++++
 kernel/sched/topology.c  | 28 ++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4564faafd0e1..d66e3cf40823 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -245,5 +245,17 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
 	return cpumask_of_node(cpu_to_node(cpu));
 }
 
+#ifdef CONFIG_NUMA
+extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
+#else
+static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
+{
+	return -ENOTSUPP;
+}
+#endif	/* CONFIG_NUMA */
+
+#define for_each_numa_hop_mask(node, hops, mask)			\
+	for (mask = sched_numa_hop_mask(node, hops); !IS_ERR_OR_NULL(mask); \
+	     mask = sched_numa_hop_mask(node, ++hops))
 
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

