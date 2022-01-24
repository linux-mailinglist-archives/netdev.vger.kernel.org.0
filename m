Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C63499193
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 21:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379662AbiAXUMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 15:12:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49662 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378266AbiAXUGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 15:06:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E42CB8124F;
        Mon, 24 Jan 2022 20:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C61C340E5;
        Mon, 24 Jan 2022 20:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054800;
        bh=8qphzB9DIKFYeekh22vyIkpyTJNnlON5enOGNgmM+ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHtu7o+AGXFMas5iaCTdivZ6VNdOZPxB8S64VaEPBQIKfmyQ+rFC/PL1eUSeOQ3bO
         kcvu10d05oBhQJqCEgJVxbVy42gUbBOH6pc3/bHGfWbfQXPZBlt0vqN+UP/WSGnQnl
         NYxhXv70r36mAvNN4PdTOgsFJkVVn6O5y6t8gvRo=
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
Subject: [PATCH 5.10 508/563] perf evsel: Override attr->sample_period for non-libpfm4 events
Date:   Mon, 24 Jan 2022 19:44:33 +0100
Message-Id: <20220124184042.036113932@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -1014,6 +1014,17 @@ struct evsel_config_term *__evsel__get_c
 	return found_term;
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
@@ -1080,14 +1091,12 @@ void evsel__config(struct evsel *evsel,
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


