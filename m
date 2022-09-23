Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6828F5E7F19
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiIWP4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiIWP43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CA814769F
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663948570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1rD50vdBgPCmvLBNPOPtby9Vrss+ZY8l15m1i9q/gc=;
        b=bUKtwjH4y4E7PGg6QpCYPHED1qP0zDy0n91RIBRub8RHGCANxBuBPSp/rJkxr4zSLWxMRL
        s1/vKVG88KGLY/75iVNfe4sU3lrZQFuCj9qUb3dkEy7lrlWVhJK3VYdYMZZWHBjHO38XlE
        so0tpop0DCPR7TQ9aKFEjsU3aK0lbTg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-56-DWQEiAxJNGmT1FCa04J23Q-1; Fri, 23 Sep 2022 11:56:00 -0400
X-MC-Unique: DWQEiAxJNGmT1FCa04J23Q-1
Received: by mail-wm1-f69.google.com with SMTP id i129-20020a1c3b87000000b003b33e6160bdso2906382wma.7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f1rD50vdBgPCmvLBNPOPtby9Vrss+ZY8l15m1i9q/gc=;
        b=ttcX9iEyhEvnSfhmdqjthc6pDc3L+No3OAwoCusqio7X78+vxuyfsl1L73yAaeCvKn
         szrzNftsqSswiegXLi6Te8QMZ9ewi31poGhuDssOK5OUu+5vB/XDsfJUfcYmB5vInkFg
         FDqUwndZgtbt7xIhSHErSGx9JmR/LfiCQ2wnz6fe0G+qLbW6DF1g7F1tmGFXzpL/59bQ
         y3PTm2mROMeXHafwSojxcM1/GaEuSWI4vp92Xarl62EyWjdzCaOiznFrYJSG3v6qSWKz
         EFe0ksnIZMp4eA22Jk3cfL4M5/iPF5Mm9RS6Q3k92QH0KdoEyP20nImW9+riC9C9IGu8
         NVWg==
X-Gm-Message-State: ACrzQf00WI5+GX45ePjk2Q0xw8vj2KN5fy49uKrXIfH7wI9PnNUS5RHC
        0DCrMuCgHW1MQAkMdb/giF9c9Lw0B9qm9ngt7y54zg6SkMLG9Oroa1P9hAMiQuCQUqobXRmSMhG
        UPk/g9zgfveY7EgmCoDCdLsv8UXY4d1KL21EAr0neuPwU+MOp2PDMK8Z014OBTQBiXvwc
X-Received: by 2002:a5d:610a:0:b0:22a:2a9d:880 with SMTP id v10-20020a5d610a000000b0022a2a9d0880mr5436971wrt.22.1663948558703;
        Fri, 23 Sep 2022 08:55:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7Qp9zZ4NuzIci/DpAgTQiB1AsWNZvgRAQooi24eczibkgAWqnA8TmIYsbQfk6ENbU93C431A==
X-Received: by 2002:a5d:610a:0:b0:22a:2a9d:880 with SMTP id v10-20020a5d610a000000b0022a2a9d0880mr5436937wrt.22.1663948558409;
        Fri, 23 Sep 2022 08:55:58 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5587000000b0021badf3cb26sm9055429wrv.63.2022.09.23.08.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:55:57 -0700 (PDT)
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
Subject: [PATCH v4 2/7] cpumask: Introduce for_each_cpu_andnot()
Date:   Fri, 23 Sep 2022 16:55:37 +0100
Message-Id: <20220923155542.1212814-1-vschneid@redhat.com>
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

for_each_cpu_and() is very convenient as it saves having to allocate a
temporary cpumask to store the result of cpumask_and(). The same issue
applies to cpumask_andnot() which doesn't actually need temporary storage
for iteration purposes.

Following what has been done for for_each_cpu_and(), introduce
for_each_cpu_andnot().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/cpumask.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 1b442fb2001f..4c69e338bb8c 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -238,6 +238,25 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
 		nr_cpumask_bits, n + 1);
 }
 
+/**
+ * cpumask_next_andnot - get the next cpu in *src1p & ~*src2p
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @src1p: the first cpumask pointer
+ * @src2p: the second cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus set in *src1p & ~*src2p
+ */
+static inline
+unsigned int cpumask_next_andnot(int n, const struct cpumask *src1p,
+				 const struct cpumask *src2p)
+{
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_andnot_bit(cpumask_bits(src1p), cpumask_bits(src2p),
+		nr_cpumask_bits, n + 1);
+}
+
 /**
  * for_each_cpu - iterate over every cpu in a mask
  * @cpu: the (optionally unsigned) integer iterator
@@ -317,6 +336,26 @@ unsigned int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int sta
 		(cpu) = cpumask_next_and((cpu), (mask1), (mask2)),	\
 		(cpu) < nr_cpu_ids;)
 
+/**
+ * for_each_cpu_andnot - iterate over every cpu present in one mask, excluding
+ *			 those present in another.
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask1: the first cpumask pointer
+ * @mask2: the second cpumask pointer
+ *
+ * This saves a temporary CPU mask in many places.  It is equivalent to:
+ *	struct cpumask tmp;
+ *	cpumask_andnot(&tmp, &mask1, &mask2);
+ *	for_each_cpu(cpu, &tmp)
+ *		...
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_andnot(cpu, mask1, mask2)				\
+	for ((cpu) = -1;						\
+		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
+		(cpu) < nr_cpu_ids;)
+
 /**
  * cpumask_any_but - return a "random" in a cpumask, but not this one.
  * @mask: the cpumask to search
-- 
2.31.1

