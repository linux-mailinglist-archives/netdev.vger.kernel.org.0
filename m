Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1016763C3
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjAUEZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjAUEYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:24:48 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1CB518D6;
        Fri, 20 Jan 2023 20:24:47 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id o5so5796684qtr.11;
        Fri, 20 Jan 2023 20:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwdL6i5RDIaOTjKHDRQpPnyPsA8RatFMsU5WrNy3SA0=;
        b=lOKIeoFZ2XmWttrm+5mhAr+EoKXQrXKDkyPM0i9zjpJ7oEZ7xf20CcBTFzpC7sbxpP
         HYGr+UfCS7Y6l0DcfL0vfyfshN+LQYevRg6KS5hazTyVvRIfZ1zOP8onArDxsjjx8szU
         1Hi8MUAbBTPnxKBkZ/ri41lTBruU6fn35huesBk939D+g/+bJxbXsov3j2O3od+KvYPW
         qkJjJmYKbWoMLYP/WnEu3Yl+5uWM/ixSGDHJ28Wj9E/laWGUAySoIIq+Ug+0ONRY4Dlq
         Gdi129W9RHo8gvEFNm3Bye67FtlnI1xoGS9Zd2kKnJsTpOEJG17fDNPvCNJSSRlyiOW1
         BqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GwdL6i5RDIaOTjKHDRQpPnyPsA8RatFMsU5WrNy3SA0=;
        b=si/SsffpTv9+J57PbXFX82yptkZ0wmcSpiS2O8SaBzyqNbV7UiCgb1tlDjVZxrfuM7
         ossxus4MNqDWDAceX5hitbZuvVg+bG/g7N4fgIloYGJ+dl4CA3LTZGUxiWgRZ5uVLpWV
         AAeliZ504Cf9Q6LMwxjFB0F1bGFMvk24I2F8TLEi5KjyN5hfVajWn9za5TIj57DAXGP7
         AcjEQPhRAJRRFiYIc25W+03SkQNIjVXuj+eh4bp8fx0yRChxZkhWxrp+Fwm19qFmh3hN
         RYlJVqd2xlKhswzrJ4fgnktchm02IPzq19ER4pcxDjGJGj8CDM/ABNfgHJZ7XgMlu6sW
         MD6A==
X-Gm-Message-State: AFqh2krMWxWG+SnLiNOyeinOB9KeHNpVM9EVUtk10oQNNe8XbTK/LqXw
        woK4YwCL1NW68e4XUXIiV2gOaovAgOs=
X-Google-Smtp-Source: AMrXdXuYwxMNLnOQv9EHAW1DEMQekgeg5cpr/1IW0U76wYcvE4khZw2ZPqraMAe5yRGaUjwiDDnhzw==
X-Received: by 2002:ac8:604d:0:b0:39c:da20:f7ac with SMTP id k13-20020ac8604d000000b0039cda20f7acmr23825028qtm.9.1674275086283;
        Fri, 20 Jan 2023 20:24:46 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id jt14-20020a05622aa00e00b003adc7f652a0sm17772522qtb.66.2023.01.20.20.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:45 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 5/9] lib/cpumask: reorganize cpumask_local_spread() logic
Date:   Fri, 20 Jan 2023 20:24:32 -0800
Message-Id: <20230121042436.2661843-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now after moving all NUMA logic into sched_numa_find_nth_cpu(),
else-branch of cpumask_local_spread() is just a function call, and
we can simplify logic by using ternary operator.

While here, replace BUG() with WARN_ON().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
---
 lib/cpumask.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 255974cd6734..10aa15715c0d 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -127,16 +127,12 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
 	/* Wrap: we always want a cpu. */
 	i %= num_online_cpus();
 
-	if (node == NUMA_NO_NODE) {
-		cpu = cpumask_nth(i, cpu_online_mask);
-		if (cpu < nr_cpu_ids)
-			return cpu;
-	} else {
-		cpu = sched_numa_find_nth_cpu(cpu_online_mask, i, node);
-		if (cpu < nr_cpu_ids)
-			return cpu;
-	}
-	BUG();
+	cpu = (node == NUMA_NO_NODE) ?
+		cpumask_nth(i, cpu_online_mask) :
+		sched_numa_find_nth_cpu(cpu_online_mask, i, node);
+
+	WARN_ON(cpu >= nr_cpu_ids);
+	return cpu;
 }
 EXPORT_SYMBOL(cpumask_local_spread);
 
-- 
2.34.1

