Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC7596207
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbiHPSIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiHPSIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF484EED
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660673266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywTMuS9huvM7zHWOxR6GjSmCdhb3SJi0oS2399XlZwU=;
        b=H55HsjHjXNDwMXB/Yolv98wJNCbTIIABO8ZxsklxyRRhAXcVP3XSJYqEDh4+CE5MaxZX8h
        UvPT8id9/Im/v7THeWFZEO522KvEbn4H6AR1UWYtDhC8FcPs4ZG+jffiIKfFdmezXOByxf
        nErxk7dAyK8lCpBV/pTSHP4p1XUpmxY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-FKgRwz5ePAmUQ63fpCcAWA-1; Tue, 16 Aug 2022 14:07:45 -0400
X-MC-Unique: FKgRwz5ePAmUQ63fpCcAWA-1
Received: by mail-wm1-f70.google.com with SMTP id c66-20020a1c3545000000b003a5f6dd6a25so2848739wma.1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ywTMuS9huvM7zHWOxR6GjSmCdhb3SJi0oS2399XlZwU=;
        b=t/1II+lSlGe2UoBBng3PTdbwKaMfYma/UEujxoAi2CkA4/YIf9CN3GGrAK6GzHbEMd
         g0OJneDJ2RE24Tc5GZYO1nvPiqnL/M1WMjdw+KHMIcDR+ukO1tUdOQ4DaL8HQrBwQNw8
         hItzrOColU58A3WR1DmvBeBsUNLc8Y3HS7r5i33NFG/qPzp7rqlcGMcrDv+sCqLSNWf4
         cPpJ+XLw1wC3qDmWZftTRVkrTLEoJADmiAORl/tbS/oXH3K3HFe66voSRuzf0zfvXS4A
         o+XfH7JtGrQFqqJila3xjCplwMMdN7scR6mi1M+/2in/7MhOXxD6CYDy3tiUVlUjluha
         vMWQ==
X-Gm-Message-State: ACgBeo3BzYOSnCGD9PLLcbpDaZuhlfw4vMhRC/VcurXESuEkyT94BqRa
        DQGN4ey3cZzvyq7dnpg8+tzrkk68kL1YLvuUdszr1Hboh5tymB3nQFNhBSlSN6DrcBoRjYjqMsO
        7lnu1zKgBY8WO4tHIbCdasmUy7W53TJtPtzd0xGYlJZuS6DYxrwayugExreZtQF1G/7hc
X-Received: by 2002:a1c:19c2:0:b0:3a5:168e:a918 with SMTP id 185-20020a1c19c2000000b003a5168ea918mr20414235wmz.31.1660673264094;
        Tue, 16 Aug 2022 11:07:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6iJQtE2obeMLeeSvqbOGp+G+UtYBLaHlthMqMKBF8/l32gDnIQKks/dY9pNYiEbkt1Ewqs4Q==
X-Received: by 2002:a1c:19c2:0:b0:3a5:168e:a918 with SMTP id 185-20020a1c19c2000000b003a5168ea918mr20414203wmz.31.1660673263847;
        Tue, 16 Aug 2022 11:07:43 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c4fc800b003a319bd3278sm14694961wmq.40.2022.08.16.11.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 11:07:43 -0700 (PDT)
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
Subject: [PATCH 5/5] SHOWCASE: net/mlx5e: Leverage for_each_numa_hop_cpu()
Date:   Tue, 16 Aug 2022 19:07:27 +0100
Message-Id: <20220816180727.387807-6-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220816180727.387807-1-vschneid@redhat.com>
References: <20220816180727.387807-1-vschneid@redhat.com>
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

