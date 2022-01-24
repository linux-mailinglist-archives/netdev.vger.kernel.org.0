Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E7449A4A7
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375358AbiAYAT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364073AbiAXXqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 18:46:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C400C0613B2;
        Mon, 24 Jan 2022 13:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C15F6150E;
        Mon, 24 Jan 2022 21:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0449C340E4;
        Mon, 24 Jan 2022 21:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060520;
        bh=bZB8LXzuRpRqd1OdmxiHwhFIwlaujiAsLxkUGVGfxqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nymYwyfvy6p62pEdV4oxB9yEl7aA72qMZTqyki7Vu8K9OL9yk8q8tieh5cGHg+hLD
         apqBqd6b25oesLzGaR9TW4ExBYCPIjDM/5xPaRWN1ZHyFAxMr09Xqm5Ym8AYzwvil3
         +HdgwuNVxgtlVT6o4+0h3h9S3oxbsvBVRgJ5dFho=
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
Subject: [PATCH 5.16 0943/1039] perf evsel: Override attr->sample_period for non-libpfm4 events
Date:   Mon, 24 Jan 2022 19:45:32 +0100
Message-Id: <20220124184156.987692281@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -1064,6 +1064,17 @@ void __weak arch_evsel__fixup_new_cycles
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
@@ -1130,14 +1141,12 @@ void evsel__config(struct evsel *evsel,
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


