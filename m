Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6DB59892A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344924AbiHRQpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344952AbiHRQph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:45:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2F5B99FF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZr7gdCnQUFeKt5ugQdZLofQqTfC3GDipKWYJIctC0o=;
        b=Ekk/B4iNHZTtWvl2QIn2oWZJqPLvn2yJIwFqS4GE3TUnPcMgUcUN8V+D96wGOy2hCOKhTK
        KkPQKBGx84Tc+Og0l2fVvdNq76enYSh5tr83XT2qoeBZiKANefcWVhod65f7vveYY+MMw8
        OsTbbe+9GPCGOgCCED8Xzxwj4eDrL+U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-502-pAiVdPXaM4Wp0M5bE8JDYA-1; Thu, 18 Aug 2022 12:45:34 -0400
X-MC-Unique: pAiVdPXaM4Wp0M5bE8JDYA-1
Received: by mail-wm1-f69.google.com with SMTP id v24-20020a7bcb58000000b003a37681b861so811293wmj.9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qZr7gdCnQUFeKt5ugQdZLofQqTfC3GDipKWYJIctC0o=;
        b=aA1Nh/XGZaOZ80zltSiIxQfuMpmArBcL3SfT2bAdDZF/t2Iuncb/iqXKojx/fY0f6V
         cqnPXKSBn71EIpH4oOg1YtERtB3lIQzDU/AU7566mh36ePNIZ4TNujMRQ/dE9Vvf8KS9
         YUTR0p5+BFLpl4lB9VJiDW88SbWg0x3XKadkGlTJG8FQb/XjxIYGzXGke0IXu33Xy7xd
         rq1klqiSmv8Y6StftdHAFfNfsU1k+G/3HuqPI/H7E2hISJ8QmQhU7l31BdtX+6lBp2Dl
         WbQhQgZE1rfg+pHvVepqqt6T74qs+usgjpX1pnDClSO2+GfdKITIY+Fcy/4oDczhOQNs
         CsBA==
X-Gm-Message-State: ACgBeo2/YVqOR6Ix6jZFbDxr/kA52EFQmI/TV6py6ya9mBoiaUB0U7Xw
        uJ2ndhBNrRaHIvhdSW4F9kqMiHyVNL/GbDdwT0CIxjIppXbY551055CPyHiLO2nOAYei0b8cDU6
        J8xegrN/qtI7ir+JToS55LYySduKLANKb5NkO0yQ33ZjjcStSIRitnjBGxHG5ewBXg5SM
X-Received: by 2002:a5d:5408:0:b0:220:63d5:d9f3 with SMTP id g8-20020a5d5408000000b0022063d5d9f3mr2077562wrv.249.1660841132715;
        Thu, 18 Aug 2022 09:45:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6gxwdIXrKECZW5GHwGnYxvYL4c65/BszpFIuTjU6CiGZ3DNUbfNM6q7fEaB9mFStW46VURNA==
X-Received: by 2002:a5d:5408:0:b0:220:63d5:d9f3 with SMTP id g8-20020a5d5408000000b0022063d5d9f3mr2077533wrv.249.1660841132508;
        Thu, 18 Aug 2022 09:45:32 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id d7-20020a05600c3ac700b003a5ad7f6de2sm2465458wms.15.2022.08.18.09.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:45:32 -0700 (PDT)
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
Subject: [PATCH v2 3/5] sched/topology: Introduce sched_numa_hop_mask()
Date:   Thu, 18 Aug 2022 17:45:20 +0100
Message-Id: <20220818164522.1087673-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220817175812.671843-1-vschneid@redhat.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

