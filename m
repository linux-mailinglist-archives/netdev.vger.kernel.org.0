Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5D06C9049
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjCYS4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjCYSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:46 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B07DAF28;
        Sat, 25 Mar 2023 11:55:34 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-17ec8963db8so5181768fac.8;
        Sat, 25 Mar 2023 11:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80EoVBEKXGhEC7DVbLvz7+NhEf3OhSH5JGMlSI/ra5A=;
        b=c8WsDxlz69yIcMrnWmunFeF8il5WqHtJorGM/XyYJMs70iYPpv46nPF3dBqd99BpdJ
         W0tVNf8ydUgVClyx+RzGKWpnA6plQ0v92jsxCYGYKtfurnBrzy5HIx8GTebIM5UvKc8K
         cPEj5R/aDqPk8/ipAO563cTqT+9eZa2AkYCykRNQ681RoYk+C+rB35p4Jo+fP5r3/gkk
         Yu8YNxArGyyOn5B92nmuhn4yeTOIWzghjpMJhbhxZudr9uE/XLR7rBrEWZ5zOdic6DEi
         OV6kMH1AZMifMfTcdPIObyunInhhcxBJrgGmzTkzlNB/LQ8CSTi+uLeLh89tAle6fdf7
         n6rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80EoVBEKXGhEC7DVbLvz7+NhEf3OhSH5JGMlSI/ra5A=;
        b=qkzIjblQ7V0ns/lACgQ9p19HeUQG8NDYdtxP1zqu37VRNvr922pzNQ3YOvyOx/t5eO
         3ladYl2JVUCA4RQXsdZB0iK29bjg4qwVam9LbxG79kaoAkdDDM3imQaDbJak6HWwEmtw
         /yo8NNh3mQcmvNG1svQhEv43j5IR2bfOtsqpro8PYWuRgI9q/PQrHdhsyO0zRH/88cFU
         LMxnRQzvq64Lpm2LqTx+nR0d7vR0mD6Xr3vLfD2XlCEpPcly8tOVecjdPp3Q18SW8JLn
         /GD04BHMrTp0jv3MdK8wbxpXuwl49sAul2LtnlgRdLgiyylsVfhOIWchTFjyHqjGeota
         1hnQ==
X-Gm-Message-State: AAQBX9eN7BeMU5p/KpXaPfIxPI3au3GqqfGhFQHaowedlyT7Wyq4fhVk
        Nsq/LZGbyV3dfqMw3v5VOJ0=
X-Google-Smtp-Source: AK7set+O8JFz+domrA0SIlDcc8yGfcVInje+7s5pfnwITfnb0uJTS8w6y359YhsEL4fO176jhWxetw==
X-Received: by 2002:a05:6870:9a14:b0:17e:e1ac:2f09 with SMTP id fo20-20020a0568709a1400b0017ee1ac2f09mr3772222oab.47.1679770533215;
        Sat, 25 Mar 2023 11:55:33 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id q132-20020acac08a000000b0037fa035f4f3sm9542212oif.53.2023.03.25.11.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:32 -0700 (PDT)
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
Subject: [PATCH 6/8] sched/topology: export sched_domains_numa_levels
Date:   Sat, 25 Mar 2023 11:55:12 -0700
Message-Id: <20230325185514.425745-7-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch adds a test for NUMA-aware CPU enumerators, and it
requires an access to sched_domains_numa_levels.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h |  7 +++++++
 kernel/sched/topology.c  | 10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 62a9dd8edd77..3d8d486c817d 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -43,6 +43,13 @@
 	for_each_online_node(node)			\
 		if (nr_cpus_node(node))
 
+#ifdef CONFIG_NUMA
+extern int __sched_domains_numa_levels;
+#define sched_domains_numa_levels ((const int)__sched_domains_numa_levels)
+#else
+#define sched_domains_numa_levels (1)
+#endif
+
 int arch_update_cpu_topology(void);
 
 /* Conform to ACPI 2.0 SLIT distance definitions */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 1860d9487fe1..5f5f994a56da 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1508,7 +1508,9 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 #ifdef CONFIG_NUMA
 enum numa_topology_type sched_numa_topology_type;
 
-static int			sched_domains_numa_levels;
+int				__sched_domains_numa_levels;
+EXPORT_SYMBOL_GPL(__sched_domains_numa_levels);
+
 static int			sched_domains_curr_level;
 
 int				sched_max_numa_distance;
@@ -1872,7 +1874,7 @@ void sched_init_numa(int offline_node)
 	 *
 	 * We reset it to 'nr_levels' at the end of this function.
 	 */
-	sched_domains_numa_levels = 0;
+	__sched_domains_numa_levels = 0;
 
 	masks = kzalloc(sizeof(void *) * nr_levels, GFP_KERNEL);
 	if (!masks)
@@ -1948,7 +1950,7 @@ void sched_init_numa(int offline_node)
 	sched_domain_topology_saved = sched_domain_topology;
 	sched_domain_topology = tl;
 
-	sched_domains_numa_levels = nr_levels;
+	__sched_domains_numa_levels = nr_levels;
 	WRITE_ONCE(sched_max_numa_distance, sched_domains_numa_distance[nr_levels - 1]);
 
 	init_numa_topology_type(offline_node);
@@ -1961,7 +1963,7 @@ static void sched_reset_numa(void)
 	struct cpumask ***masks;
 
 	nr_levels = sched_domains_numa_levels;
-	sched_domains_numa_levels = 0;
+	__sched_domains_numa_levels = 0;
 	sched_max_numa_distance = 0;
 	sched_numa_topology_type = NUMA_DIRECT;
 	distances = sched_domains_numa_distance;
-- 
2.34.1

