Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2816E8989
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjDTFUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbjDTFUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:20:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3FA55AB;
        Wed, 19 Apr 2023 22:19:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b50a02bffso570009b3a.2;
        Wed, 19 Apr 2023 22:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681967998; x=1684559998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owQqtMurqm2qI+24ndEGs/qWEaDzKKQeglmv6UMu1sw=;
        b=A5ITtIQzxLED1qZR1Mnw5hskw9J9pA2fHW1Fz6EgknrldXSQkt2U8nJXiJr8zWJ55U
         S60jhKV/oq8I8Z24Zq0fMc8GY7jFnfUTm/OK+ezJl8BVHZ1NIB+XN7soOgU6/Hn15dOQ
         156MqX8nV+QIvo9dzrQs27d2xJ9+P3gUgClScF1ggfnrr9MecT9/C4Yfw96+r0imq+Fn
         66lEzr9Pn98efMggd6jrxylqd2TuocFEtCv9qWNaT3+8VVeTcuAeNEjFRengib8pyjna
         bfCCsRuZRqwbbupmhDOOnn4AJih22+wiKuy1sVZtJKsQIMpamaAEYdS7dApF5cw3LdJh
         09EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681967998; x=1684559998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owQqtMurqm2qI+24ndEGs/qWEaDzKKQeglmv6UMu1sw=;
        b=Kzefz/6xvMAA1y1ac8EXKZJkOYqRot6XzvZjIEaHalyZSyca79vabTv8LEtWjTFPkf
         Ct7C58t3videeU3E5fnVESoIs6bu2/0yD0CqDqi7GqbQ1SzNqLLThEAsY4E2QUSbZaqx
         3cdCajqKIVbqwzYxvLAHaK2cAp7h7crskBqeRToOjN9uUvARSZEVXqHGM5R4udPPzYUQ
         svg0NnUDiqYb6rTjO+W2jGKcUcB9ciqdpGvv95a0RS42x06JF3pwLlkgIk3mnzgzMp2W
         2wkXAXHhddJ2pOeNakHAgGPpeomVmoyO1T6u9soIqnPs4S6i6Bp7br9w31WyDg3F282D
         2NWg==
X-Gm-Message-State: AAQBX9d2xpBROYf9P4z3bNiTKDW2ytkK50AzW4CO1Cle2OgfR9g5Z3jl
        KtUODxS1GndZbRmG3F90Fok=
X-Google-Smtp-Source: AKy350b2TrJbqRKwQBXYvaIQBVuSaGrUUKe1brGFiJALP+1j6B7HK9k+M/FG34jQ7dhbD3XRQwH4aQ==
X-Received: by 2002:a05:6a00:18a2:b0:639:c88b:c3e0 with SMTP id x34-20020a056a0018a200b00639c88bc3e0mr7518672pfh.22.1681967998283;
        Wed, 19 Apr 2023 22:19:58 -0700 (PDT)
Received: from localhost ([2603:3024:e02:8500:653b:861d:e1ca:16ac])
        by smtp.gmail.com with ESMTPSA id fa9-20020a056a002d0900b0062622ae3648sm309878pfb.78.2023.04.19.22.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:19:57 -0700 (PDT)
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
Subject: [PATCH v2 4/8] net: mlx5: switch comp_irqs_request() to using for_each_numa_cpu
Date:   Wed, 19 Apr 2023 22:19:42 -0700
Message-Id: <20230420051946.7463-5-yury.norov@gmail.com>
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

for_each_numa_cpu() is a more straightforward alternative to
for_each_numa_hop_mask() + for_each_cpu_andnot().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 38b32e98f3bd..80368952e9b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -817,12 +817,10 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
 static int comp_irqs_request(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	const struct cpumask *prev = cpu_none_mask;
-	const struct cpumask *mask;
 	int ncomp_eqs = table->num_comp_eqs;
 	u16 *cpus;
 	int ret;
-	int cpu;
+	int cpu, hop;
 	int i;
 
 	ncomp_eqs = table->num_comp_eqs;
@@ -844,15 +842,11 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 
 	i = 0;
 	rcu_read_lock();
-	for_each_numa_hop_mask(mask, dev->priv.numa_node) {
-		for_each_cpu_andnot(cpu, mask, prev) {
-			cpus[i] = cpu;
-			if (++i == ncomp_eqs)
-				goto spread_done;
-		}
-		prev = mask;
+	for_each_numa_cpu(cpu, hop, dev->priv.numa_node, cpu_possible_mask) {
+		cpus[i] = cpu;
+		if (++i == ncomp_eqs)
+			break;
 	}
-spread_done:
 	rcu_read_unlock();
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
-- 
2.34.1

