Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C8459B6FD
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 02:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiHVASX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 20:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiHVAST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 20:18:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991CD20199
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:18:10 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-336c3b72da5so156804097b3.6
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=DTW77A/Vjl+d5bcQDIprq1tGD6UgniZYOTpaR8iNZIc=;
        b=Dg9yytO9IkPtQr0hKr1opAsmaHFl6Ti0qmk9dgNkQKa6EeZnhuamJ8wFuDDpvnSucO
         3jnI66hn0RZluaprAxAC9vZCxkQXXdYA0KwOtMgEey7a9lQkqmoQ767sSys3ES+TUduk
         8r9futG6QW922rVpAUoBuyvHCBDkXpj6Z6uIr5bt4pi4JjwABrXPfF7E2R9JF1EvrU3W
         3HTuZx9jrCVbRGBo1EjBv/Hu+VbfEktqbj+TpV4cjusZQtsDY5OAzcQ1W3tgUYcjFPCH
         ebqBDDU8/54Qiztpi0pJPbzqNXn5hxGVXBNshftViCKjFt6eCv7LnIrPsIrM9eVLCdKl
         WwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=DTW77A/Vjl+d5bcQDIprq1tGD6UgniZYOTpaR8iNZIc=;
        b=OVRK5SiHAv6ddFucIRhi6mWD5Btrpkqwda5fjtzl0himYIe+a4xieQPS46ERWgGi7B
         Ht3YpeH6aqK5NCXbLa3CWZbj0cUTtsFEhGuTgIzu9NzqYQT3avfXZJAbnNuH7WCYVa6g
         3grF5LGYx6TnZsE2HrKcnlqbAD7ON7FkzslQLYEAhoZYNiAUXVcrmhCb5zfBNZ6SQNhm
         kIj8q4GGu1fScIiMYbiMr9nE6SzbGApIKpUvgCVnCqkq1Tk/Ihhlb8RNwzekSFY07e+Q
         4m0QSJ7Rfpa/cdrR8FJVdayoBvSJ75Ve3zY/TKybGQv4Jz83nr5ZcImFLIjLdFzIkpxh
         cT2g==
X-Gm-Message-State: ACgBeo1AYjWjKcpu84925eHX9oWHAinV2X2NklulGdr+Gy1t1GjGGCKS
        qp0vOXikjGiQog5UPNhtlfj1FbmHecbm1Q==
X-Google-Smtp-Source: AA6agR6tW1MO8bdpOOCAdPjlI2KgLdp2empQdKN2rFu+N7JEzRBKSYp9P+zG59MACSGNvPbZ7uCstsPP+839Yw==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a25:9f8d:0:b0:686:9a3d:6f85 with SMTP id
 u13-20020a259f8d000000b006869a3d6f85mr16587811ybq.400.1661127489865; Sun, 21
 Aug 2022 17:18:09 -0700 (PDT)
Date:   Mon, 22 Aug 2022 00:17:37 +0000
In-Reply-To: <20220822001737.4120417-1-shakeelb@google.com>
Message-Id: <20220822001737.4120417-4-shakeelb@google.com>
Mime-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
From:   Shakeel Butt <shakeelb@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
machines and the network intensive workloads requiring througput in
Gbps, 32 is too small and makes the memcg charging path a bottleneck.
For now, increase it to 64 for easy acceptance to 6.0. We will need to
revisit this in future for ever increasing demand of higher performance.

Please note that the memcg charge path drain the per-cpu memcg charge
stock, so there should not be any oom behavior change.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy with top
level having min and low setup appropriately. More specifically
memory.min equal to size of netperf binary and memory.low double of
that.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)       10482.7 Mbps
With patch              17064.7 Mbps (62.7% improvement)

With the patch, the throughput improved by 62.7%.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
---
 include/linux/memcontrol.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d31ce55b1c0..70ae91188e16 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -354,10 +354,11 @@ struct mem_cgroup {
 };
 
 /*
- * size of first charge trial. "32" comes from vmscan.c's magic value.
- * TODO: maybe necessary to use big numbers in big irons.
+ * size of first charge trial.
+ * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
+ * workload.
  */
-#define MEMCG_CHARGE_BATCH 32U
+#define MEMCG_CHARGE_BATCH 64U
 
 extern struct mem_cgroup *root_mem_cgroup;
 
-- 
2.37.1.595.g718a3a8f04-goog

