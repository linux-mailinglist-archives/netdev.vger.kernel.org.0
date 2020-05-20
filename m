Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737B91DAC10
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgETH2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgETH2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:28:22 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E94CC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:21 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x30so2752673qte.14
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cdxaRZ8/bLJ0hiCQFa/mZ4i8RBkML1CDuxtDfYtoS7E=;
        b=KsJp4HgOm1YR3buC+GlraWqwPMQb539hDABZ/Nfwz8yv31xFdfQjzzivTD6XDX3Vmt
         nAwono7Ocu56A8vywCzt3qTioDy//Obgjs3oSL5JKWQyyBZ1NMsc/sJCUbBhqMSGBkaA
         +lvXpxMzJzxZXBpgmoRcCBw/oAeoRASXh9/owLwtjugNYiOoeTy9lBzPQwtR4zHWKIiw
         6PWF4iGlsRE8VlP32j2e/eTWxbSg8/9TMNfR9Eih0SgThNOkk8t4iSABgQXLDNnkV4cg
         GEaQqeA7jAlgBLpZ+r0NTJhBJFgjeBJAJYXKb8PQZp2qbVSpaV7VUBV+jN0IFbxq88ro
         uzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cdxaRZ8/bLJ0hiCQFa/mZ4i8RBkML1CDuxtDfYtoS7E=;
        b=uQrzOyCBRDeMsqlfyioHY0t71HQV/080pn0XByeXZbPqgHk8CIdFdgt2KhMmay6MUq
         5o6dF2Gl+mZvC+NrYSThKGugQkyX71SCatkz8Tsbbye8e+jtkmlvfK3f/4oHhfbMJ2E2
         Qq5VxrC5Ba4ZnhTvQ0TeTKxwUDRKepTGMR0nMoHUtFmd04T8LWuzPQXc6XAl6L85ugSc
         CskJSTQdmuawqi83io+uokLmHGvEf4u40it7Dp2lGNHVSpBpU1QVDpDpIAODAtdhoMAP
         Y4n4xpkTaswnRRLKm4ZqU9u5+Oa26W08LnylUDgebnYfIFczemClPWnj4GA47kOwC44o
         aCYQ==
X-Gm-Message-State: AOAM531rZvQI3TNsbTXSK5Q+f8cq4pWIspDebUoJAYD1qARrdMk/GNWG
        3+wbElNTtTl8zVqYjkHsnucCIMOyPQbu
X-Google-Smtp-Source: ABdhPJznDrW41cQ4bY7/vsXD+gG1rnELqi+iRCkeb8YVsQEpxgZJCekqGg1Xr6ttcOHRCfkIYgKOEPoI27co
X-Received: by 2002:a0c:e806:: with SMTP id y6mr3647862qvn.177.1589959700511;
 Wed, 20 May 2020 00:28:20 -0700 (PDT)
Date:   Wed, 20 May 2020 00:28:07 -0700
Message-Id: <20200520072814.128267-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 0/7] Share events between metrics
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Metric groups contain metrics. Metrics create groups of events to
ideally be scheduled together. Often metrics refer to the same events,
for example, a cache hit and cache miss rate. Using separate event
groups means these metrics are multiplexed at different times and the
counts don't sum to 100%. More multiplexing also decreases the
accuracy of the measurement.

This change orders metrics from groups or the command line, so that
the ones with the most events are set up first. Later metrics see if
groups already provide their events, and reuse them if
possible. Unnecessary events and groups are eliminated.

The option --metric-no-group is added so that metrics aren't placed in
groups. This affects multiplexing and may increase sharing.

The option --metric-mo-merge is added and with this option the
existing grouping behavior is preserved.

Using skylakex metrics I ran the following shell code to count the
number of events for each metric group (this ignores metric groups
with a single metric, and one of the duplicated TopdownL1 and
TopDownL1 groups):

for i in all Branches BrMispredicts Cache_Misses FLOPS Instruction_Type Memory_BW Pipeline Power SMT Summary TopdownL1 TopdownL1_SMT
do
  echo Metric group: $i
  echo -n " - No merging (old default, now --metric-no-merge): "
  /tmp/perf/perf stat -a --metric-no-merge -M $i sleep 1 2>&1 | grep -v "^ *#" | egrep " +[0-9,.]+ [^s]" | wc -l
  echo -n " - Merging over metrics (new default)             : "
  /tmp/perf/perf stat -a -M $i sleep 1 2>&1 | grep -v "^ *#" | egrep " +[0-9,.]+ [^s]"|wc -l
  echo -n " - No event groups and merging (--metric-no-group): "
  /tmp/perf/perf stat -a --metric-no-group -M $i sleep 1 2>&1 | grep -v "^ *#" | egrep " +[0-9,.]+ [^s]"|wc -l
done

Metric group: all
 - No merging (old default, now --metric-no-merge): 193
 - Merging over metrics (new default)             : 142
 - No event groups and merging (--metric-no-group): 84
Metric group: Branches
 - No merging (old default, now --metric-no-merge): 8
 - Merging over metrics (new default)             : 8
 - No event groups and merging (--metric-no-group): 4
Metric group: BrMispredicts
 - No merging (old default, now --metric-no-merge): 11
 - Merging over metrics (new default)             : 11
 - No event groups and merging (--metric-no-group): 10
Metric group: Cache_Misses
 - No merging (old default, now --metric-no-merge): 11
 - Merging over metrics (new default)             : 9
 - No event groups and merging (--metric-no-group): 6
Metric group: FLOPS
 - No merging (old default, now --metric-no-merge): 18
 - Merging over metrics (new default)             : 10
 - No event groups and merging (--metric-no-group): 10
Metric group: Instruction_Type
 - No merging (old default, now --metric-no-merge): 6
 - Merging over metrics (new default)             : 6
 - No event groups and merging (--metric-no-group): 4
Metric group: Pipeline
 - No merging (old default, now --metric-no-merge): 6
 - Merging over metrics (new default)             : 6
 - No event groups and merging (--metric-no-group): 5
Metric group: Power
 - No merging (old default, now --metric-no-merge): 16
 - Merging over metrics (new default)             : 16
 - No event groups and merging (--metric-no-group): 10
Metric group: SMT
 - No merging (old default, now --metric-no-merge): 11
 - Merging over metrics (new default)             : 8
 - No event groups and merging (--metric-no-group): 7
Metric group: Summary
 - No merging (old default, now --metric-no-merge): 19
 - Merging over metrics (new default)             : 17
 - No event groups and merging (--metric-no-group): 17
Metric group: TopdownL1
 - No merging (old default, now --metric-no-merge): 16
 - Merging over metrics (new default)             : 7
 - No event groups and merging (--metric-no-group): 7
Metric group: TopdownL1_SMT
 - No merging (old default, now --metric-no-merge): 24
 - Merging over metrics (new default)             : 7
 - No event groups and merging (--metric-no-group): 7

There are 5 out of 12 metric groups where no events are shared, such
as Power, however, disabling grouping of events always reduces the
number of events.

The result for Memory_BW needs explanation:

Metric group: Memory_BW
 - No merging (old default, now --metric-no-merge): 9
 - Merging over metrics (new default)             : 5
 - No event groups and merging (--metric-no-group): 11

Both with and without merging the groups fail to be set up and so the
event counts here are for broken metrics. The --metric-no-group number
is accurate as all the events are scheduled. Ideally a constraint
would be added for these metrics in the json code to avoid grouping.

v1. was prepared on kernel/git/acme/linux.git branch tmp.perf/core

Compared to RFC v3: fix a bug where unnecessary commas were passed to
parse-events and were echoed. Fix a bug where the same event could be
matched more than once with --metric-no-group, causing there to be
events missing.
https://lore.kernel.org/lkml/20200508053629.210324-1-irogers@google.com/

Ian Rogers (7):
  perf metricgroup: Change evlist_used to a bitmap
  perf metricgroup: Always place duration_time last
  perf metricgroup: Delay events string creation
  perf metricgroup: Order event groups by size
  perf metricgroup: Remove duped metric group events
  perf metricgroup: Add options to not group or merge
  perf metricgroup: Remove unnecessary ',' from events

 tools/perf/Documentation/perf-stat.txt |  19 ++
 tools/perf/builtin-stat.c              |  11 +-
 tools/perf/util/metricgroup.c          | 241 ++++++++++++++++++-------
 tools/perf/util/metricgroup.h          |   6 +-
 tools/perf/util/stat.h                 |   2 +
 5 files changed, 206 insertions(+), 73 deletions(-)

-- 
2.26.2.761.g0e0b3e54be-goog

