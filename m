Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7EB6F29F0
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjD3RSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjD3RS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6148B3C1E;
        Sun, 30 Apr 2023 10:18:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b62d2f729so1280804b3a.1;
        Sun, 30 Apr 2023 10:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875099; x=1685467099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jGbFVuum+KtcabYGT3vt7OtFUyPnxnlWHN0/8h9s/o=;
        b=G94aeKvLvroKF6lcT983KCdgd7rZcBLC06Z9bBz+UyNrXSo2eiQjSWpnQCQF4NHp8Q
         wM4DxZvuu/uFuRDAaKOJqmNG9zxzD8/ULWCdudSfZdFbAJuI3TIBsmenceBgHI+3T044
         IDtBYP5WGCp+bbfKKlTM0GMeLXfAqvG2Ee6ofJRQsoIW2wVXBMMOu2kn12TYYFCn/LkI
         4Nya8atDxP3m7BTQT/zdhRgY/wNxjYNg2M/XMLKZBjJ0STKX/Cc3NRzGut08M/8uJIy5
         /YK3eX6pDh1h2LZmFbnEpmQnWr1YTZfx80Q/bNuAF3TndKOxt0323pM5e6DewS2GHUEh
         ZNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875100; x=1685467100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jGbFVuum+KtcabYGT3vt7OtFUyPnxnlWHN0/8h9s/o=;
        b=ls2rQznUz+98PmxV54tms9G01w/9KbgJWVuVcWioUzJb4XU4hVUHvqBd/fGWJFBeLr
         xxip6lUDUXUG3gkf66bYolLKEDEYMaWN3Ekf7UrbKmEroQ2ED/I/JcEIfB7B1LQsTluC
         NWN0xlnJZK+AntYY/nxDdQ6uiLuYbbm7ovxZVD889EEpCsb2w738Sr9LGvI2KD940gab
         h3xuoRZedP0HPZD7MU6tjgRWQsUv2AeiOWLyzHSvxJYuhrjZWC39hQkdiqhViRo9zfgi
         6t2+LohJSo4qd0EjqIgmcBaxnq12cLiciPDANjYlSUTgmQ2w88NUx4KrRqcSdXFc+zc0
         QNsw==
X-Gm-Message-State: AC+VfDzN7kiqHm8R1SqOUBeEtXJvb1HAce+ORKlherhdBnw54CWcdfOe
        M+nS87WMg4eZhD6UzFtIaBY=
X-Google-Smtp-Source: ACHHUZ7+J94TmMbJxTjh+YH/l81cpVyK4Si/E3roU3XQjqn065SMbwM7W5CXxf3HvL3yNTv/E/5N/g==
X-Received: by 2002:a05:6a00:1402:b0:63d:2343:f9b with SMTP id l2-20020a056a00140200b0063d23430f9bmr15918991pfu.19.1682875099546;
        Sun, 30 Apr 2023 10:18:19 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id i21-20020a056a00225500b0063b8f33cb81sm19040360pfu.93.2023.04.30.10.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:19 -0700 (PDT)
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
Subject: [PATCH v3 5/8] net: mlx5: switch comp_irqs_request() to using for_each_numa_cpu
Date:   Sun, 30 Apr 2023 10:18:06 -0700
Message-Id: <20230430171809.124686-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230430171809.124686-1-yury.norov@gmail.com>
References: <20230430171809.124686-1-yury.norov@gmail.com>
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

for_each_numa_online_cpu() is a more straightforward alternative to
for_each_numa_hop_mask() + for_each_cpu_andnot().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 38b32e98f3bd..d3511e45f121 100644
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
+	for_each_numa_online_cpu(cpu, hop, dev->priv.numa_node) {
+		cpus[i] = cpu;
+		if (++i == ncomp_eqs)
+			break;
 	}
-spread_done:
 	rcu_read_unlock();
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
-- 
2.37.2

