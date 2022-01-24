Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38B0499624
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 22:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443870AbiAXU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 15:59:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42268 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391681AbiAXUsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 15:48:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A5760C3E;
        Mon, 24 Jan 2022 20:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623B1C340E5;
        Mon, 24 Jan 2022 20:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057301;
        bh=eipPTW4zUA2Y7C6/tT/Xx48Qu8AVSVvCdWRcAwJbjbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDdknbIGQysdIcgik43P379chCn2IYSxtxjZ/H+yf2L3x8UfDGw3662PxvrwaTwIn
         YsLCeGmwsPDraojRWxDj2WZ2Rv5A7UaQ2OuCuf28OylHrRyGCVjdo6Fr/hI9kwS950
         q3mY5ejd8JOElUJayRiepTn6t8AEXvva2dLQJNMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chase Conklin <chase.conklin@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 768/846] perf evsel: Override attr->sample_period for non-libpfm4 events
Date:   Mon, 24 Jan 2022 19:44:45 +0100
Message-Id: <20220124184127.452102489@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: German Gomez <german.gomez@arm.com>

commit 3606c0e1a1050d397ad759a62607e419fd8b0ccb upstream.

A previous patch preventing "attr->sample_period" values from being
overridden in pfm events changed a related behaviour in arm-spe.

Before said patch:

  perf record -c 10000 -e arm_spe_0// -- sleep 1

Would yield an SPE event with period=10000. After the patch, the period
in "-c 10000" was being ignored because the arm-spe code initializes
sample_period to a non-zero value.

This patch restores the previous behaviour for non-libpfm4 events.

Fixes: ae5dcc8abe31 (“perf record: Prevent override of attr->sample_period for libpfm4 events”)
Reported-by: Chase Conklin <chase.conklin@arm.com>
Signed-off-by: German Gomez <german.gomez@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220118144054.2541-1-german.gomez@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/evsel.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1047,6 +1047,17 @@ void __weak arch_evsel__set_sample_weigh
 	evsel__set_sample_bit(evsel, WEIGHT);
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
@@ -1113,14 +1124,12 @@ void evsel__config(struct evsel *evsel,
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


