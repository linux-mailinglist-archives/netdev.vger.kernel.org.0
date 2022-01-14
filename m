Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3292B48F1FF
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 22:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiANVVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 16:21:22 -0500
Received: from foss.arm.com ([217.140.110.172]:38020 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbiANVVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 16:21:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8035C6D;
        Fri, 14 Jan 2022 13:21:21 -0800 (PST)
Received: from ip-10-252-15-108.eu-west-1.compute.internal (unknown [10.252.15.108])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A20393F774;
        Fri, 14 Jan 2022 13:21:18 -0800 (PST)
From:   German Gomez <german.gomez@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     German Gomez <german.gomez@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] perf record/arm-spe: Override attr->sample_period for non-libpfm4 events
Date:   Fri, 14 Jan 2022 21:21:02 +0000
Message-Id: <20220114212102.179209-1-german.gomez@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous commit preventing attr->sample_period values from being
overridden in pfm events changed a related behaviour in arm_spe.

Before this patch:
perf record -c 10000 -e arm_spe_0// -- sleep 1

Would not yield an SPE event with period=10000, because the arm-spe code
initializes sample_period to a non-0 value, so the "-c 10000" is ignored.

This patch restores the previous behaviour for non-libpfm4 events.

Reported-by: Chase Conklin <chase.conklin@arm.com>
Fixes: ae5dcc8abe31 (“perf record: Prevent override of attr->sample_period for libpfm4 events”)
Signed-off-by: German Gomez <german.gomez@arm.com>
---
 tools/perf/util/evsel.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a59fb2ecb84e..86ab038f020f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1065,6 +1065,17 @@ void __weak arch_evsel__fixup_new_cycles(struct perf_event_attr *attr __maybe_un
 {
 }
 
+static void evsel__set_default_freq_period(struct record_opts *opts,
+					   struct perf_event_attr *attr)
+{
+	if (opts->freq) {
+		attr->freq = 1;
+		attr->sample_freq = opts->freq;
+	} else {
+		attr->sample_period = opts->default_interval;
+	}
+}
+
 /*
  * The enable_on_exec/disabled value strategy:
  *
@@ -1131,14 +1142,12 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
 	 * We default some events to have a default interval. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period) {
-		if (opts->freq) {
-			attr->freq		= 1;
-			attr->sample_freq	= opts->freq;
-		} else {
-			attr->sample_period = opts->default_interval;
-		}
-	}
+	if ((evsel->is_libpfm_event && !attr->sample_period) ||
+	    (!evsel->is_libpfm_event && (!attr->sample_period ||
+					 opts->user_freq != UINT_MAX ||
+					 opts->user_interval != ULLONG_MAX)))
+		evsel__set_default_freq_period(opts, attr);
+
 	/*
 	 * If attr->freq was set (here or earlier), ask for period
 	 * to be sampled.
-- 
2.25.1

