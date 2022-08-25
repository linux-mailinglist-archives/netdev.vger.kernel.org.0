Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB4A5A188B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbiHYSNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242777AbiHYSNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:13:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440AEBD284
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661451171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrW3KirCN30zCt1W75Xnts+OcNfMj70LF3woTfJkL5o=;
        b=YaEHJTE5zhxkklq2PBI4J5qDh4EJVaTTjPIZHhm1N+vyHas/2+Kz5BkkirDRjPIrB4+rdl
        1iGIQFHPPNcZ+G8e296zEU1SpyL8gwxJ8oPNay2bDcgRiO7+Trhha2SvLvVDs1rRGpuOAH
        aj7mORh5IG7hya5qL6zc6xZDYSSx3WU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-u1E7guKtNGuZI_-XtfJ-4w-1; Thu, 25 Aug 2022 14:12:48 -0400
X-MC-Unique: u1E7guKtNGuZI_-XtfJ-4w-1
Received: by mail-wm1-f72.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso2774455wmq.4
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=MrW3KirCN30zCt1W75Xnts+OcNfMj70LF3woTfJkL5o=;
        b=4MDXeMKl69XdQ4UzDIZSupPrjMnia/t/lVcyn41Ey95aeyfv1xG7z24lYwu7FuwSjb
         ZYsiQlcPPf8rgdVz5SaWBGOWKllgkWgkNyJ+xpFRws47LOTQRLEnWnLtoKdxelCfI56q
         zoJGLMX4a3C/AjPIDaPE9kugpJAyVM23rm2vK782bqfmvkNZy+l++ahEiq65uzkA2Fh/
         MOeutd9M2wJHXIuCZJ207GZkkIfoOvwhsVKQLuKagEf9Bd0TSlftLMKcViy4/e0+Luih
         0R7ssNkXPlte5qVAFUfZ8IeUVLpWjZKbFWvGHFt5ayljE5EZQcS9j1I0ii7sH9mVyiWa
         gAcg==
X-Gm-Message-State: ACgBeo1Qt+tKA4BATx4WV6py7tfyOibUDgOtkVkPYQjUfQjgYEtbAalt
        0dp8zVf4Q2qc9WnGnCU6bPHRQwyV0+m3EoVBy/dgR/D3aRCNT25jebNCjo97OX/ueUqIT1yWbXx
        4LTGEyqWBBhGtbE3nlYNmYhcN+3ITB7WdQCr9yeaZ+5/AI0AeV66JjpFrdBW74SQLBH0w
X-Received: by 2002:a5d:68c9:0:b0:225:330b:2d0 with SMTP id p9-20020a5d68c9000000b00225330b02d0mr2795033wrw.243.1661451165200;
        Thu, 25 Aug 2022 11:12:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ao2h70S57Mc6QfTHW3PBLSxOg2mVt1GMZpIHsupvErIGsFwcjS67fyxkj1o1xP3reb4xMcw==
X-Received: by 2002:a5d:68c9:0:b0:225:330b:2d0 with SMTP id p9-20020a5d68c9000000b00225330b02d0mr2794999wrw.243.1661451164866;
        Thu, 25 Aug 2022 11:12:44 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id w1-20020a05600018c100b00225250f2d1bsm20371622wrq.94.2022.08.25.11.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 11:12:44 -0700 (PDT)
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
Subject: [PATCH v3 4/9] cpumask: Introduce for_each_cpu_andnot()
Date:   Thu, 25 Aug 2022 19:12:05 +0100
Message-Id: <20220825181210.284283-5-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220825181210.284283-1-vschneid@redhat.com>
References: <20220825181210.284283-1-vschneid@redhat.com>
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
index 1414ce8cd003..372a642bf9ba 100644
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

