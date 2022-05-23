Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1548530FC5
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiEWMzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiEWMzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:55:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1B152E7E;
        Mon, 23 May 2022 05:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109B2B810AC;
        Mon, 23 May 2022 12:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912AFC385A9;
        Mon, 23 May 2022 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653310499;
        bh=VL29GRANyhn2Yf22h7xWxr8NCXCPQBgciy3yLY8dyEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gwou/P4SObZx4pE88EhIO5qDrF33vuU9h8oEaYoy1v1ypY3KKQsuPfCxmZR2LozP6
         zp1T7rXjl8BVJX7MlMhJbd7P8MSN7O6QlIQs9Ph4fTWlkLApN/sARmBjqDc+JJbJLw
         a6P3ZkGIbAX7S5JzX8N23PEaYoaphq0KS92U4EhyzwrdZhxFdDYdwYeZgjycMx5tKG
         PjH9V+cpX93p6BhPwLLE0C+DP62k4+q6EToukbzs9KchPGqynaI9NmPjcdr/HftN5a
         eQI/rqDnr2pltEfmjMt+gHtV7tNJJVaRlC72fYpA+4p2hrTcmuepey7JTx5da/Sg58
         pGv7t5MWhFjog==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1250C400B1; Mon, 23 May 2022 09:54:57 -0300 (-03)
Date:   Mon, 23 May 2022 09:54:57 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf_counts clean up and perf stat report bug fix
Message-ID: <YouEIfLIaQjKK08q@kernel.org>
References: <20220519032005.1273691-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519032005.1273691-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, May 18, 2022 at 08:20:00PM -0700, Ian Rogers escreveu:
> perf_counts takes a CPU map index as an argument, however, there were
> a few places where this hadn't been cleaned up and the index was
> called cpu. In part this led to the bug discovered by Michael Petlan in:
> https://lore.kernel.org/linux-perf-users/CAP-5=fWQR=sCuiSMktvUtcbOLidEpUJLCybVF6=BRvORcDOq+g@mail.gmail.com/
> 
> Fix the bug, tidy up more of the arguments passed to perf_counts, add
> a test to ensure the bug isn't reintroduced and add a helper macro to
> iterate over just CPU map indices.

Applied 2-5 to perf/core. The first is already in 5.18


Thanks,

- Arnaldo
 
> Ian Rogers (5):
>   perf stat: Fix and validate inputs in stat events
>   perf stat: Add stat record+report test
>   perf cpumap: Add perf_cpu_map__for_each_idx
>   perf bpf_counter: Tidy use of CPU map index
>   perf stat: Make use of index clearer with perf_counts
> 
>  tools/lib/perf/include/perf/cpumap.h |  3 ++
>  tools/perf/tests/shell/stat.sh       | 13 ++++++
>  tools/perf/util/bpf_counter.c        | 61 ++++++++++++++++------------
>  tools/perf/util/stat-display.c       | 22 +++++-----
>  tools/perf/util/stat.c               | 27 ++++++++----
>  5 files changed, 81 insertions(+), 45 deletions(-)
> 
> -- 
> 2.36.1.124.g0e6072fb45-goog

-- 

- Arnaldo
