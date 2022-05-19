Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21B052CA39
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiESDUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiESDUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:20:13 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4626654BF7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:20:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2ff40ee8109so33555807b3.14
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LuxVni4aHwzoBwXpBkpdF8i7m2uNy0PLkWHwBcKxQ00=;
        b=CCKtd7GR8nSvO6PQYhltu3h/jGWY/Y8WgaHPFGIar1fsm8WFvHmlZ0ipzwvPm3DWKC
         NSlOLAJ62X7PsFEYEtcdlaB4Z5rUBdR/sFiebQA3VN8/cEXtjINVhzPsVo10qoRtC+BO
         Y3oeM5c/vtsngEFrpCFJUILd43x2CdCOybSn5Wvi3hgKSy9CLgtbG5ywEJACY1rLJoR0
         dEi2EVtz4lOrC3s2MG6Joh1qutsBpdwj5GZaQm57tHmxPJJYT6T2kJYIKbP6Zzvh3cQk
         sLtId9YpMX4I8w7xhLE7CckWwGWjv/cvopWJMGTRtbAgowx+3eqyH2WpFhy9oW68f3Jz
         xVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LuxVni4aHwzoBwXpBkpdF8i7m2uNy0PLkWHwBcKxQ00=;
        b=zeEWIGNJAqaA98I/7c5RSetyEXVE/YwQOotPqqG7yYeF+VMAG8II2v0ChfitUeivSl
         JQy8sOn1oNF69ebx35jqZE0htRUkLwI9kg9VOnp0rkEYmH+5uMI0ISJ4IYGmRRPPF5KK
         7wjVwsvZU8NIynnmnG7UwHapBfykS/MMS8nnzG/STVE9vgDS/QaDFwoQkUWW/DbqothV
         Khh/uWi+FP7Pmr0ipuXrJWHslPYx+8YVIBnTgDlZVxJDY9l96bsCldTJVblO3qn9Iu6R
         P2WChJQiqDKweGInp45Qv3a4p5bzVnunSvwvgmdW2+mpkyBdKrfiTh0Re27dFmhWO07f
         pFSA==
X-Gm-Message-State: AOAM5333TBRiA4g+0Qc7C+KxSgCfwh2UvdyIpYPLC6MvNOS4lgZUBbO0
        BxDtiZ/Jhl3FOpYQaEJVXyLf8LPfPhYa
X-Google-Smtp-Source: ABdhPJzG1oTOx2/i021ptIUrHFpfkP7ts5RITI/ZnnYmmrugR/Rhh79It43/VBwAMEbVyobDpdUWt238HZS7
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:a233:bf3c:6ac:2a98])
 (user=irogers job=sendgmr) by 2002:a05:6902:1002:b0:649:70c2:db58 with SMTP
 id w2-20020a056902100200b0064970c2db58mr2518912ybt.68.1652930411395; Wed, 18
 May 2022 20:20:11 -0700 (PDT)
Date:   Wed, 18 May 2022 20:20:00 -0700
Message-Id: <20220519032005.1273691-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 0/5] perf_counts clean up and perf stat report bug fix
From:   Ian Rogers <irogers@google.com>
To:     Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        James Clark <james.clark@arm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
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

perf_counts takes a CPU map index as an argument, however, there were
a few places where this hadn't been cleaned up and the index was
called cpu. In part this led to the bug discovered by Michael Petlan in:
https://lore.kernel.org/linux-perf-users/CAP-5=fWQR=sCuiSMktvUtcbOLidEpUJLCybVF6=BRvORcDOq+g@mail.gmail.com/

Fix the bug, tidy up more of the arguments passed to perf_counts, add
a test to ensure the bug isn't reintroduced and add a helper macro to
iterate over just CPU map indices.

Ian Rogers (5):
  perf stat: Fix and validate inputs in stat events
  perf stat: Add stat record+report test
  perf cpumap: Add perf_cpu_map__for_each_idx
  perf bpf_counter: Tidy use of CPU map index
  perf stat: Make use of index clearer with perf_counts

 tools/lib/perf/include/perf/cpumap.h |  3 ++
 tools/perf/tests/shell/stat.sh       | 13 ++++++
 tools/perf/util/bpf_counter.c        | 61 ++++++++++++++++------------
 tools/perf/util/stat-display.c       | 22 +++++-----
 tools/perf/util/stat.c               | 27 ++++++++----
 5 files changed, 81 insertions(+), 45 deletions(-)

-- 
2.36.1.124.g0e6072fb45-goog

