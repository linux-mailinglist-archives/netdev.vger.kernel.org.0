Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37821596204
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbiHPSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbiHPSHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:07:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FABE85FE1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660673264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ygl4bsiGppbXjaR+QFxwzenbyEWvTTquS8G3MYyuF5k=;
        b=J2EZDDOzoQmAGaAOY2K/XyZ904+hprlQYeJVL2Rzf2lYBDktnGRqr225XJNn8rWlS8WikF
        hC7MgZWnTtA1eUSRGq1PDE03pTzZJoZSghlqT96F/+eFHYnSG5bA4WH/004mw59xjNNvdK
        v2FIpXGYDe6VFQBEcEKXTcoA8MbreIU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-p-2ksqwgP7-DFVdedrQe1g-1; Tue, 16 Aug 2022 14:07:43 -0400
X-MC-Unique: p-2ksqwgP7-DFVdedrQe1g-1
Received: by mail-wm1-f69.google.com with SMTP id f7-20020a1c6a07000000b003a60ede816cso318494wmc.0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ygl4bsiGppbXjaR+QFxwzenbyEWvTTquS8G3MYyuF5k=;
        b=hxTgr5wTsSyGUnE4CMDg2eRAR4Cnd626ESlRGlVXqob3SX0vstguuZ2pDipa3C/1Dt
         d9ay7rm27Zf3LMVOpo//0dXySi5yfFAnlkhCV5/HCdrVjiIABuq/6wM4ErzXm9nWXXXg
         JEmO8iKhHAplqPDnjldtE5SQ/QDhbwFoQzrwyUqH+JsibuXRbmochBF1f+h0Zl68S2nz
         T4fd1SpN51NHGY3HBf18hFoy9/iE524rgxysS4D6F9F12qutYgm5IUXGoB/LXn2LoI68
         EYEks2PuKKo6FqRBSj0jhc31fGes5+X5rLWosVMORqP1/a/ywnsQT+KZxeCB+gbTzHoa
         0Fmg==
X-Gm-Message-State: ACgBeo2y4W9+wLu6v+29FKmdxOuIG6UwSnpcR4KZ2QYymGTW/qsFtikp
        PDNa/ZKgXn/nGU1gl1gTSMDvMyg6cBmWwghWbiUIzSQhsqbHE3TZHRdo+qBUtPb4IfL2P7DQ+aW
        tiFVT+4jKlTH1Qnxcq62hFdXaj48M7hEp6dbNrkUmpVtklOrrSve4qmFdkolWpfk9P1jp
X-Received: by 2002:a05:600c:3ac9:b0:3a5:f114:1f8 with SMTP id d9-20020a05600c3ac900b003a5f11401f8mr7308813wms.204.1660673262326;
        Tue, 16 Aug 2022 11:07:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR48CFk/soei7QbfayAzQBKnIM/T9VknX41x2JuU6hM+hzmZxgjXWFEqwx3WheqBotPeya0UKg==
X-Received: by 2002:a05:600c:3ac9:b0:3a5:f114:1f8 with SMTP id d9-20020a05600c3ac900b003a5f11401f8mr7308780wms.204.1660673262069;
        Tue, 16 Aug 2022 11:07:42 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c4fc800b003a319bd3278sm14694961wmq.40.2022.08.16.11.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:07:41 -0700 (PDT)
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
Subject: [PATCH 4/5] sched/topology: Introduce for_each_numa_hop_cpu()
Date:   Tue, 16 Aug 2022 19:07:26 +0100
Message-Id: <20220816180727.387807-5-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220816180727.387807-1-vschneid@redhat.com>
References: <20220816180727.387807-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 13b82b83e547..6c671dc3252c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -254,5 +254,42 @@ static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
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

