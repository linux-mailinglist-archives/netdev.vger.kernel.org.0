Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF27C59B6F1
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 02:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiHVARr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 20:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiHVARq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 20:17:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29541A062
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:17:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f5960500bso160685507b3.14
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=eVYfwZxwoaftgj4urkXWqJfl1yf2BkP0ai3v6afDBzY=;
        b=M1l5wTrPM/Bn69v9qPWUy2ze89j/C2QhgC3uGWDIOLN0WzyTcSLHJG+RMJMatiXqzX
         27XcKNJabca81sRVdeO2CT1uL6V3eUrxJu8cAS5kLO6npO5tc6V6+FSswOr5rvF6RaE5
         NnZaglMI2t5Fcdxoo3js4AEbpcjU5+NawpoYbCoq0mblDVlFiOzpAKZf/doM3EvCHCLx
         4Q3+m22Td0kDdin0LFVj23XqtyJX1saMxHUxHMwrnzPDoQvY1ZsDuHKa9Kh07T/Mylwk
         qX7Y7PhcDJVc31z1kgWb/ztxtLAbJS62kPbXsESgW/3GkZHCTfqGGUoWHVPWeD15A1hl
         kqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=eVYfwZxwoaftgj4urkXWqJfl1yf2BkP0ai3v6afDBzY=;
        b=Ramq7L8WMlzzsK5/9VKYVTCvMOpXmjNo5F48bIETSaM7f88nPLbZIDGVQjq8t6LsML
         quNVyEjxoq9vOJMYx6f71lTgob1yZYcj3aIaq7zGaiv8hrdxj8YtF4986wS+67H/1pvZ
         H4i+PLR9LiY23T4h59NFeiKLHCsZWwSyXvCLX2L+x234FVWBjQTDthskQeVLFq/2Ut5s
         Ao++xZqZCgUNOOppNaumN/Y2TykArJ9mTsXOr3sKZKzlIaWhCIo90wK90+7b3cs64pGF
         siWNEegGFjDOYi/gW6f2NIBOIVZfuN7MTgUot1wZj2LLRXMqg7Ypx08gTUOCc+77Ejky
         x+ug==
X-Gm-Message-State: ACgBeo29V+QlvTzycfdE+1tuUFwvN5iS1GjBbiLh4WyQDZxEJu30j3UF
        wNTRgvWbil0JFRn3A8/LQw/LwlFwlAazJA==
X-Google-Smtp-Source: AA6agR78v4wOfPY4ftnsexAz/OZtv9vS4y8enZfqi9EG/iRXLt8jDPrzlVln+ZDLQBU87YcB+TpOeVGaN3NjPA==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a25:7304:0:b0:693:bc0d:fc6c with SMTP id
 o4-20020a257304000000b00693bc0dfc6cmr15772624ybc.375.1661127464253; Sun, 21
 Aug 2022 17:17:44 -0700 (PDT)
Date:   Mon, 22 Aug 2022 00:17:34 +0000
Message-Id: <20220822001737.4120417-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 0/3] memcg: optimizatize charge codepath
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

Recently Linux networking stack has moved from a very old per socket
pre-charge caching to per-cpu caching to avoid pre-charge fragmentation
and unwarranted OOMs. One impact of this change is that for network
traffic workloads, memcg charging codepath can become a bottleneck. The
kernel test robot has also reported this regression. This patch series
tries to improve the memcg charging for such workloads.

This patch series implement three optimizations:
(A) Reduce atomic ops in page counter update path.
(B) Change layout of struct page_counter to eliminate false sharing
    between usage and high.
(C) Increase the memcg charge batch to 64.

To evaluate the impact of these optimizations, on a 72 CPUs machine, we
ran the following workload in root memcg and then compared with scenario
where the workload is run in a three level of cgroup hierarchy with top
level having min and low setup appropriately.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
1. root memcg		21694.8
2. 6.0-rc1		10482.7 (-51.6%)
3. 6.0-rc1 + (A)	14542.5 (-32.9%)
4. 6.0-rc1 + (B)	12413.7 (-42.7%)
5. 6.0-rc1 + (C)	17063.7 (-21.3%)
6. 6.0-rc1 + (A+B+C)	20120.3 (-7.2%)

With all three optimizations, the memcg overhead of this workload has
been reduced from 51.6% to just 7.2%.

Shakeel Butt (3):
  mm: page_counter: remove unneeded atomic ops for low/min
  mm: page_counter: rearrange struct page_counter fields
  memcg: increase MEMCG_CHARGE_BATCH to 64

 include/linux/memcontrol.h   |  7 ++++---
 include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
 mm/page_counter.c            | 13 ++++++-------
 3 files changed, 33 insertions(+), 21 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

