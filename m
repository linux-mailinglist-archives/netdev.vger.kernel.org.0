Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0CE5A04EF
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiHYAFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiHYAFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:05:45 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1778696FF
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:05:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i3-20020aa78b43000000b005320ac5b724so8087942pfd.4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 17:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=3ANOEI0BBXDszhHsMjNjVkJxW2dSCbobxCznkiQMg0M=;
        b=M8tSmqMgyZLVy2Ldt7OEwatTGNnYnfDpQ69BuMQNcXOyVDB1zOG1S5rA/96I/PJKxE
         4+npbWP3pWJ08Qbrxcia+8i6j7Gu69xnnOJNpGf1qEh/CTh6F27WQ4nVQLW4A9J5Lhh9
         wZHGTsioVx7toZiUJ8cHixmiZOFP7E6zdyNZLONxSLuMdImMycE2Fyt+XuqZ+8IhLHsR
         C6dFsjW4r02bqFmtyRS3Kq6G3VP5sgtlfNBMT7ztQEx6AL13xu9pwUVXfdMd6YEAnByA
         YGozttZzHIvY64hF0IBSZ5RbI4tZvRxI5hd9vrRa+K0+Wr8X++i6Jrnvoe/mNBWb+0ko
         v09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=3ANOEI0BBXDszhHsMjNjVkJxW2dSCbobxCznkiQMg0M=;
        b=r+W+igIKEcobZs0ep92fUzmwAqE3iLOy3IYq4sIFhDsRFz6CRFVlQMkG0hfKdKPj+7
         rNtKVHg/40x6VNyCQmEIbdr7J/YaJ/WBHr28m9baCyxbG6nVLH47WWbtWV3o7X1x8R3C
         d/NcQuu+j/YlqNVx4+cPOtnzDj6c9qDnlo+aA4NGblcMXMqHD0DOOpD5srSZoXpE5H7Q
         o9++dC6YP1QrzN85tBk3+NfzgAHzxBGtHJW9u/yvJf+gxTG/biZR6xR0dhfIYJH+c12j
         qLYLlNSTEWvkrv7+XWV/9Jf16urfOTgx5vPSdwr5RNtkLrIi2Q5N+U60fFTowT0HvjHu
         Ge2A==
X-Gm-Message-State: ACgBeo3GeB+lWiYii00qgTdIm/YTjwAWfXyWXvNpy63EoZ1Y3D3xHGC+
        90NS2/KMw0icpME5AssOwkMwbTHsrFrT0Q==
X-Google-Smtp-Source: AA6agR4pbPM00Y2dhBDzDYXIyyPDDsgaDbSO1VcMlYVbQBY5g87vni0ByGdo33smXqzxyN0vznInx5Zn2YarNQ==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a05:6a00:1803:b0:536:e9a4:89d4 with SMTP
 id y3-20020a056a00180300b00536e9a489d4mr1451224pfa.28.1661385939060; Wed, 24
 Aug 2022 17:05:39 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:05:06 +0000
In-Reply-To: <20220825000506.239406-1-shakeelb@google.com>
Message-Id: <20220825000506.239406-4-shakeelb@google.com>
Mime-Version: 1.0
References: <20220825000506.239406-1-shakeelb@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
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
        autolearn=ham autolearn_force=no version=3.4.6
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
stock, so there should not be any oom behavior change. Though it does
have impact on rstat flushing and high limit reclaim backoff.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)       10482.7 Mbps
With patch              17064.7 Mbps (62.7% improvement)

With the patch, the throughput improved by 62.7%.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
Changes since v1:
- Updated commit message

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

