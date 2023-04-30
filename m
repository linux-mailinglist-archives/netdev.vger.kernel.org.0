Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2056F29E2
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjD3RSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjD3RSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95102D48;
        Sun, 30 Apr 2023 10:18:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-24df4ef05d4so517161a91.2;
        Sun, 30 Apr 2023 10:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875093; x=1685467093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWZ/FM9Xy42k8TQIEAYaaEoBZGiiKDahHvzomhIyOWo=;
        b=DfGc4B6u50hjxfbXwokfigtvybIagJSpgF1k7vXk3oK29QxTRG7GYATE4MFjrmVdG/
         J5c6Dy6piJTDC3ByETGQyRxvWRL5FEywm8uWBVIA3bXWCobrYb7tFtLGsHzSgxaYmIsy
         0DaUFwWeniLqoFWx8bPR4xf2Z4vQDUwOO67UG1iuMv7BhkA7coitPbK0Qo/Uhxp3w09X
         tEUlw4Yq+Hoc92NM2QyEVe+N7a6CVJdsUuBuhh4M8MIaLqFXNlh/yuwjB0y+q37zct6M
         +s8Nn7Ek179r1DUNnx/Zd5mjKrbQ39Alm6h9+BTD9KwEdhlZYgWyV2JrENAYa1I8s7Dv
         1Sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875093; x=1685467093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWZ/FM9Xy42k8TQIEAYaaEoBZGiiKDahHvzomhIyOWo=;
        b=IWd/mPIlOwL917fXchHUqYzsAyT4vurCEYG0LgoNABBOk6Sg8zivlrYG+K7d4wNsZ0
         M3YWJ8fNEU7d90vDl0+jSX7FmInGd+pyB00PTtDL1RXRrVgzc4Q+NMZFZ73AvAju8cPo
         9b8oDZqo44GAAGQMMEqpdJgJYVWM4eVGCUgTtKuSEUuXZYQOvHkE9sIGxwYh9/lLD2o/
         4sqMpJu9ZH3LrzsaiBZqMI2k6nDZKjdT06BbQGLuHymQ1YZEIoMDF/Iz24i2ujI9r+ZW
         YD+3dXpcmwV6jqFZgRQ413vjSHv88sQgvmO5K5DLhuFCX4+4JvvgyfqIEnLaDNOFEEFZ
         Bl+Q==
X-Gm-Message-State: AC+VfDwRrIPSp6D9qwOFZsCurs/Mr2S62dhowKTzYzzIoQnEDWpXTm9J
        Ceqg0D0vOXr5NYMdMmT2qIg=
X-Google-Smtp-Source: ACHHUZ4QxoittMxV8zbCIJSrLlRIt/RmzZr/yg+px1T1B035hDcTBgtdFUy65HhCICOy4EAMXasQwQ==
X-Received: by 2002:a17:90b:4a01:b0:246:8a27:d42d with SMTP id kk1-20020a17090b4a0100b002468a27d42dmr11382564pjb.48.1682875093288;
        Sun, 30 Apr 2023 10:18:13 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090a9f0c00b0024e05b7ba8bsm68533pjp.25.2023.04.30.10.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:12 -0700 (PDT)
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
Subject: [PATCH v3 1/8] sched: fix sched_numa_find_nth_cpu() in non-NUMA case
Date:   Sun, 30 Apr 2023 10:18:02 -0700
Message-Id: <20230430171809.124686-2-yury.norov@gmail.com>
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

When CONFIG_NUMA is enabled, sched_numa_find_nth_cpu() searches for a
CPU in sched_domains_numa_masks. The masks includes only online CPUs,
so effectively offline CPUs are skipped.

When CONFIG_NUMA is disabled, the fallback function should be consistent.

Fixes: cd7f55359c90 ("sched: add sched_numa_find_nth_cpu()")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index fea32377f7c7..52f5850730b3 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -251,7 +251,7 @@ extern const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int
 #else
 static __always_inline int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
 {
-	return cpumask_nth(cpu, cpus);
+	return cpumask_nth_and(cpu, cpus, cpu_online_mask);
 }
 
 static inline const struct cpumask *
-- 
2.37.2

