Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7297D58EAB6
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiHJKvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiHJKvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:51:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D225E089
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660128701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QKswYb/p0TG7A62JGLMqklr1fmwHxQqVazk8yHSBgY=;
        b=Uhr2TQZ53Up2F3qnTgWFd6yJ2s5x5SSFjTCmjK9sDuleIFRX6rWspuIqZMvVzv0DqidRUL
        dE0lHpVUTopdCYOyu0dSmOqG8u9OTSpEbMt+xHtl4FSsXohEjmktFGBjg4zFzjnHOxlwSh
        Krks5Hhp91wlAvclJ1dUKx33P4EelKw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-1PZwv9H6Nt-K4z6NRCTJig-1; Wed, 10 Aug 2022 06:51:40 -0400
X-MC-Unique: 1PZwv9H6Nt-K4z6NRCTJig-1
Received: by mail-wm1-f71.google.com with SMTP id n1-20020a7bcbc1000000b003a4e8c818f5so458039wmi.6
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=+QKswYb/p0TG7A62JGLMqklr1fmwHxQqVazk8yHSBgY=;
        b=y3kKOG6UMlkFUMxQWckeZwFeqqzH4XRRI52X7KJlSAFCpTjgTKQevPREd7MRX6QZQJ
         BAahX1Dh9BTdEs/1fysm9HDiiBQGfP/QxzSuP+AjegaKXVqYKPJgQB6SEhsC8XXbJ1sC
         XwANfI/qQPaiiiGBcHiOEgHx6PyCeiU2CRbpDGc39CchkLw2W0Mi80rXDTwkUA6GVmlV
         ZOYBFnw6WrGOOl0AAoVJOAW50ru+tQC5dyYuqthT7xVC/8+ae2CIoHq7nKZNpEz1G9Re
         8hRAE0gvG7C1y/9Zw4nUv1N6RDqNUC8Goafk7uITgNa7P9gjBxYysNvCLfC5AgUDfnHJ
         8qdw==
X-Gm-Message-State: ACgBeo2GZYXNw2oscusnBXoNm0O3X6gKVHeXTTvbcgY/v4q67eUjCWxH
        Ac02XCjgwwvs0eX9P3Zm0myQkYMmR9nJmzs/uazaNPeuANia7TkJOIjqvTp9zzTJaUMlqcnsIaF
        SYU49NZWWnz0DEbUdcdmrlWEXGOShCDo7axknl7aDbX0qm+JzCtUANQ7U3MFS/wa8+g0L
X-Received: by 2002:a05:6000:1a88:b0:222:ca4d:f0d2 with SMTP id f8-20020a0560001a8800b00222ca4df0d2mr9771179wry.610.1660128698827;
        Wed, 10 Aug 2022 03:51:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6s8knuL4j1oq3Fzd8so/k3D+RKPKqXDCFBb2MFvV+e9VEEggyzQfUdfbVef77LJNUZXnar9w==
X-Received: by 2002:a05:6000:1a88:b0:222:ca4d:f0d2 with SMTP id f8-20020a0560001a8800b00222ca4df0d2mr9771155wry.610.1660128698644;
        Wed, 10 Aug 2022 03:51:38 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5406000000b0021e491fd250sm16138637wrv.89.2022.08.10.03.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 03:51:38 -0700 (PDT)
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
Subject: [PATCH 2/2] net/mlx5e: Leverage sched_numa_hop_mask()
Date:   Wed, 10 Aug 2022 11:51:19 +0100
Message-Id: <20220810105119.2684079-2-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810105119.2684079-1-vschneid@redhat.com>
References: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
 <20220810105119.2684079-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 229728c80233..2eb4ffd96a95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -809,9 +809,12 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
 static int comp_irqs_request(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
+	const struct cpumask *mask;
 	int ncomp_eqs = table->num_comp_eqs;
+	int hops = 0;
 	u16 *cpus;
 	int ret;
+	int cpu;
 	int i;
 
 	ncomp_eqs = table->num_comp_eqs;
@@ -830,8 +833,17 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 		ret = -ENOMEM;
 		goto free_irqs;
 	}
-	for (i = 0; i < ncomp_eqs; i++)
-		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
+
+	rcu_read_lock();
+	for_each_numa_hop_mask(dev->priv.numa_node, hops, mask) {
+		for_each_cpu(cpu, mask) {
+			cpus[i] = cpu;
+			if (++i == ncomp_eqs)
+				goto spread_done;
+		}
+	}
+spread_done:
+	rcu_read_unlock();
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
 	if (ret < 0)
-- 
2.31.1

