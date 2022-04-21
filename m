Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3B150A647
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389718AbiDUQza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357961AbiDUQzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:55:18 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DA0549C82;
        Thu, 21 Apr 2022 09:52:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAB861576;
        Thu, 21 Apr 2022 09:52:27 -0700 (PDT)
Received: from ip-10-252-15-9.eu-west-1.compute.internal (unknown [10.252.15.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F16203F73B;
        Thu, 21 Apr 2022 09:52:24 -0700 (PDT)
From:   Timothy Hayes <timothy.hayes@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Timothy Hayes <timothy.hayes@arm.com>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 2/3] perf: arm-spe: Fix SPE events with phys addresses
Date:   Thu, 21 Apr 2022 17:52:04 +0100
Message-Id: <20220421165205.117662-3-timothy.hayes@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421165205.117662-1-timothy.hayes@arm.com>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects a bug whereby SPE collection is invoked with
pa_enable=1 but synthesized events fail to show physical addresses.

Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
---
 tools/perf/arch/arm64/util/arm-spe.c | 10 ++++++++++
 tools/perf/util/arm-spe.c            |  3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/arm64/util/arm-spe.c b/tools/perf/arch/arm64/util/arm-spe.c
index af4d63af8072..e8b577d33e53 100644
--- a/tools/perf/arch/arm64/util/arm-spe.c
+++ b/tools/perf/arch/arm64/util/arm-spe.c
@@ -148,6 +148,7 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
 	bool privileged = perf_event_paranoid_check(-1);
 	struct evsel *tracking_evsel;
 	int err;
+	u64 bit;
 
 	sper->evlist = evlist;
 
@@ -245,6 +246,15 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
 	 */
 	evsel__set_sample_bit(arm_spe_evsel, DATA_SRC);
 
+	/*
+	 * The PHYS_ADDR flag does not affect the driver behaviour, it is used to
+	 * inform that the resulting output's SPE samples contain physical addresses
+	 * where applicable.
+	 */
+	bit = perf_pmu__format_bits(&arm_spe_pmu->format, "pa_enable");
+	if (arm_spe_evsel->core.attr.config & bit)
+		evsel__set_sample_bit(arm_spe_evsel, PHYS_ADDR);
+
 	/* Add dummy event to keep tracking */
 	err = parse_events(evlist, "dummy:u", NULL);
 	if (err)
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 151cc38a171c..1a80151baed9 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -1033,7 +1033,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.size = sizeof(struct perf_event_attr);
 	attr.type = PERF_TYPE_HARDWARE;
-	attr.sample_type = evsel->core.attr.sample_type & PERF_SAMPLE_MASK;
+	attr.sample_type = evsel->core.attr.sample_type &
+				(PERF_SAMPLE_MASK | PERF_SAMPLE_PHYS_ADDR);
 	attr.sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
 			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
 			    PERF_SAMPLE_WEIGHT | PERF_SAMPLE_ADDR;
-- 
2.25.1

