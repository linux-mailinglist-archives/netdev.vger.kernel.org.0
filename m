Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2946F29ED
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjD3RSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjD3RS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:18:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2713590;
        Sun, 30 Apr 2023 10:18:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-24ba5c1be6dso1196937a91.2;
        Sun, 30 Apr 2023 10:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682875101; x=1685467101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCv69uJohA5AlkXqweJAXFHwc6wg8xE3bGvGWZBwPj0=;
        b=p0+sIZD1gwanjZp7Rv1P3JIxKXXOQJXNctd57ehfGs3eiauZenLX6GOGDWaeHMCfAM
         bphrWH3UFdeD340P/7p3OQC2hl1aiM6PnP/TmpuUBSr8JfJLkyTUdjkYYN+RKtmJMxQ+
         pVhEeq+UzMOiQJX1Stax4ON1bMZIKWbT1w8sfXjHX9ZLbmNA4X5OWButls3Hhpxi2l/2
         R20DX7ji8g1JfmZT7NCX+M47SztTkGYFEQEj+ynynAbEQU3zFLH4I+OCvSutig8djd/F
         C6ULc7jKHvFqNoZSGbXpygNeLaIYu6j1gAdVoMb4T1r1nv3mqiftyH6GjmN+Ds5i+dUQ
         bn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682875101; x=1685467101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCv69uJohA5AlkXqweJAXFHwc6wg8xE3bGvGWZBwPj0=;
        b=cCVFmDzmRu8BoajIq40pABlD7rD9AChF3LVJKx9SppkbOC0H/1jbnI3sbv5+pAkmn6
         lOSqNBUyLTe1pYsIjyh9i+ABaCJ1gmTieD7Veb/eB7D4XUNrOvNghC+2HvARsalorqLa
         Z3qgk5jI3nxIDeM/6nzNJdXfHo24yq9dljGV98N/zatXGhRGLuLndOf503T3lD280TZD
         Xg5aW59iMpeV1lrG7gcya7BoqtPKZMIa2z/ToQLhW5r41N8Wsv0h6yikQmzcpm/0QjF5
         5GZSCw7l/XlUGJFRQB6d3aw52cxx2Xl63ASZvMbMBXj4TtOCboMX0IhBJUvtpRPJL14j
         uY4g==
X-Gm-Message-State: AC+VfDydjRJ/A0JOgfML2FXxMInna0I4XVqiMbxIr4zX6A7TlbBUFnqJ
        Ulv/Lg3HbxLZRAeFw3t5jyo=
X-Google-Smtp-Source: ACHHUZ5OCSlIbGQl91MvYWZXxbjDU93snOKgTVhUU3jokqYRdZJT+YCdTmHX0+qn1HSV74QgWqWQMQ==
X-Received: by 2002:a17:90b:17c3:b0:247:bab1:d901 with SMTP id me3-20020a17090b17c300b00247bab1d901mr11307062pjb.17.1682875101345;
        Sun, 30 Apr 2023 10:18:21 -0700 (PDT)
Received: from localhost ([4.1.102.3])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a5d8900b002465ff5d829sm4625861pji.13.2023.04.30.10.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 10:18:20 -0700 (PDT)
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
Subject: [PATCH v3 6/8] lib/cpumask: update comment to cpumask_local_spread()
Date:   Sun, 30 Apr 2023 10:18:07 -0700
Message-Id: <20230430171809.124686-7-yury.norov@gmail.com>
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

Now that we have a for_each_numa_online_cpu(), which is a more
straightforward replacement to the cpumask_local_spread() when it comes to
enumeration of CPUs with respect to NUMA topology, it's worth to update the
comment.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/cpumask.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index e7258836b60b..774966483ca9 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -127,11 +127,8 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
  *
  * There's a better alternative based on for_each()-like iterators:
  *
- *	for_each_numa_hop_mask(mask, node) {
- *		for_each_cpu_andnot(cpu, mask, prev)
- *			do_something(cpu);
- *		prev = mask;
- *	}
+ *	for_each_numa_online_cpu(cpu, hop, node)
+ *		do_something(cpu);
  *
  * It's simpler and more verbose than above. Complexity of iterator-based
  * enumeration is O(sched_domains_numa_levels * nr_cpu_ids), while
-- 
2.37.2

