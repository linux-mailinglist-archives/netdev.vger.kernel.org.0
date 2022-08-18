Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF8598929
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344973AbiHRQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344977AbiHRQpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:45:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01EABC110
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywTMuS9huvM7zHWOxR6GjSmCdhb3SJi0oS2399XlZwU=;
        b=D79UzXcHA7YAvj+O6XmGbxReWxL3xzxKhKp4R1Otbgv3Vk0hzPNBMuqN31CGYRJP7yuA9O
        zACkadpB8NGMmU2zR7QR0IApc5W0tZbfu3v6BDDLCUWTp3UGei2Qd8UTT6lkE1pcgti59t
        XKspMVZbLvwgjoOvQnlIZWpgNZ86klM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-bVmOFi1XN6qJSLPlKK-RcA-1; Thu, 18 Aug 2022 12:45:38 -0400
X-MC-Unique: bVmOFi1XN6qJSLPlKK-RcA-1
Received: by mail-wm1-f72.google.com with SMTP id az42-20020a05600c602a00b003a552086ba9so2942680wmb.6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ywTMuS9huvM7zHWOxR6GjSmCdhb3SJi0oS2399XlZwU=;
        b=OU6AYwgHvUUB9WwGC3TBfIOPrVJk3SMcVw8+h+NwV2a0yMb7owB5+k4NjkH/nlK9ZO
         aRxu+E+Ucz5CaRL+3d3GBeDtLZlZ7K/ZjJumv0nmYuBLovKJIVE9fxdL8rkgI14OEMFL
         FTRynOb8Xt25YKg9ncBoM/pcuHBPQT+9rgIkeLeQZx4m8A19Xx8NmH2azPy78f/3xoMQ
         z4cnSDbp5EIsv1RE5G0i3U83eioOrpUKWF200pl4UO/3CGE5yqn+bdoLSAI7pP7O/U47
         XLLlhjTKyxaYPa12g21G8kAQK7RN9B/433e3ZJ7qG6kn1c5PCx551ReWe1HBcj6rhVus
         YJxw==
X-Gm-Message-State: ACgBeo2ISHWvxV9ET22y9Ey43tac5P3fwt5hofh/9cp6gNOOJtzx+8Wd
        0XLNhpu2hcUwSDBWXgVGZDX2D27P2wnVMy6sUIshLT7BVSwYn3RCvayGWMIcv2LA+kFsTLuzIYP
        v1eUKlXJesa9ORlstvjJWXzzn/I00m+ztETp3b4zF8gSOlSCTbMzKlp+ypgjWsYfqSZgY
X-Received: by 2002:a05:6000:1f08:b0:21f:bbe:252c with SMTP id bv8-20020a0560001f0800b0021f0bbe252cmr2104362wrb.340.1660841137416;
        Thu, 18 Aug 2022 09:45:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5V5LqD6L/uZK5MQwaiVfgT2IX7c0E6MzpdjvY5DMfJ6PdmT5prIm5y5OBYNyJ1oo+5n3JYqw==
X-Received: by 2002:a05:6000:1f08:b0:21f:bbe:252c with SMTP id bv8-20020a0560001f0800b0021f0bbe252cmr2104328wrb.340.1660841137167;
        Thu, 18 Aug 2022 09:45:37 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id d7-20020a05600c3ac700b003a5ad7f6de2sm2465458wms.15.2022.08.18.09.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:45:36 -0700 (PDT)
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
Subject: [PATCH v2 5/5] SHOWCASE: net/mlx5e: Leverage for_each_numa_hop_cpu()
Date:   Thu, 18 Aug 2022 17:45:22 +0100
Message-Id: <20220818164522.1087673-3-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818164522.1087673-1-vschneid@redhat.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220818164522.1087673-1-vschneid@redhat.com>
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

Not-signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 229728c80233..0a5432903edd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -812,6 +812,7 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 	int ncomp_eqs = table->num_comp_eqs;
 	u16 *cpus;
 	int ret;
+	int cpu;
 	int i;
 
 	ncomp_eqs = table->num_comp_eqs;
@@ -830,8 +831,15 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 		ret = -ENOMEM;
 		goto free_irqs;
 	}
-	for (i = 0; i < ncomp_eqs; i++)
-		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
+
+	rcu_read_lock();
+	for_each_numa_hop_cpus(cpu, dev->priv.numa_node) {
+		cpus[i] = cpu;
+		if (++i == ncomp_eqs)
+			goto spread_done;
+	}
+spread_done:
+	rcu_read_unlock();
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
 	if (ret < 0)
-- 
2.31.1

