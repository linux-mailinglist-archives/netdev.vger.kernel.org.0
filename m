Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7037059892E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344992AbiHRQpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344966AbiHRQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:45:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0412BC110
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ygl4bsiGppbXjaR+QFxwzenbyEWvTTquS8G3MYyuF5k=;
        b=GzcKuUPZqXmCm4F6x1IrPdfv2sF4A2KNLjqwjFkS4pPCRpoUFNsRv/AsOB3VOCJRpRsXLS
        x2PSCpRbk6S7ODKNI61/6q9ZSz6OJPMvCpqPVlEH69ruxi2sBh5FcgIcbhgkyjJVTEwMeL
        T4rLWvFPbKDUZOWVp1YYwRyTT+QvXVg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-81fzTA6SOjy4o4tGNb2Ciw-1; Thu, 18 Aug 2022 12:45:37 -0400
X-MC-Unique: 81fzTA6SOjy4o4tGNb2Ciw-1
Received: by mail-wr1-f70.google.com with SMTP id d11-20020adfc08b000000b002207555c1f6so296155wrf.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ygl4bsiGppbXjaR+QFxwzenbyEWvTTquS8G3MYyuF5k=;
        b=JYJjJE7rzSGoUfjG5EPpO4r8T2j/gQq96a8XKUdLBvYzzHdIhBjGk8JONlB+pUoHVE
         sMPTvXIsHioufgdSvhBqZKROl4bSXKTiMdGoCwbHeSosXY4zOmz1b9pmF800CAh+qMNt
         SGQ7FIJ7dz2BzQNPMpKDAw0Wk8zeS7gOafBkIpEPukLfftrCMCcTO1Ui7CGwQprHzs1q
         b0lTig463m8hajV0GojFZJH79kFl4WaDM8h2dRxA62t2Fjfah4NzWSgsLhKHr5Vc0gPK
         CEP4qiFDslbaGX+nKxkRQRfGtfDGACNlBiUUEoSYb5CkCqpHFbYFdl/mK6po7uO4sSux
         SHRQ==
X-Gm-Message-State: ACgBeo0qjWoy31fzrQcx3qssqKvUYd3avlea/F5064eAYcwh8dwYtW2c
        oG9rPcdLMrdxLZgbyQLu7EEmuWPVBRvdq84WxM44F0DGh5TrFB3jptCEwz+V8taDJTyHpOv29Vk
        dd49/SyLwNsKwyWMwdO2LzcQG6wTxTtn32NJLHMbVntjMpjz8bDay2YjcJlSvVIFawg2D
X-Received: by 2002:a5d:63cb:0:b0:21e:b81d:8b0d with SMTP id c11-20020a5d63cb000000b0021eb81d8b0dmr2101122wrw.526.1660841135402;
        Thu, 18 Aug 2022 09:45:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7i0NVijGHDSaLCCQYtUON7K5y9O7pv4DOZf3cy/HYjnD2P0jXlg2O08mjKG+P/oEyOridfcQ==
X-Received: by 2002:a5d:63cb:0:b0:21e:b81d:8b0d with SMTP id c11-20020a5d63cb000000b0021eb81d8b0dmr2101084wrw.526.1660841135139;
        Thu, 18 Aug 2022 09:45:35 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id d7-20020a05600c3ac700b003a5ad7f6de2sm2465458wms.15.2022.08.18.09.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:45:34 -0700 (PDT)
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
Subject: [PATCH v2 4/5] sched/topology: Introduce for_each_numa_hop_cpu()
Date:   Thu, 18 Aug 2022 17:45:21 +0100
Message-Id: <20220818164522.1087673-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818164522.1087673-1-vschneid@redhat.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220818164522.1087673-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

