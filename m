Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D56E772
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 16:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfGSOe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 10:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbfGSOe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 10:34:27 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9C422186A;
        Fri, 19 Jul 2019 14:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563546866;
        bh=jaIHQ3Dooj577x1k4DwEyufNscVOorFgbQk7CMgV4lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXA/U/Vts3rvsT0vLIeMsX9trKX67WeYGwBsg/jgUHmyQfcNRwys/TdExL+ZZ5mZr
         pClOQplDAzJ3Oowz3CchmqKJ+VFv8uIAmsmk66B1FOscFhlnVgYUmpOzZ3wkoZMtsS
         AaB/a/FT8KCwV1vFvYBUAeUB8ayNLs8O/FbBWLP0=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/2] libbpf: Avoid designated initializers for unnamed union members
Date:   Fri, 19 Jul 2019 11:34:07 -0300
Message-Id: <20190719143407.20847-3-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719143407.20847-1-acme@kernel.org>
References: <20190719143407.20847-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As it fails to build in some systems with:

  libbpf.c: In function 'perf_buffer__new':
  libbpf.c:4515: error: unknown field 'sample_period' specified in initializer
  libbpf.c:4516: error: unknown field 'wakeup_events' specified in initializer

Doing as:

    attr.sample_period = 1;

I.e. not as a designated initializer makes it build everywhere.

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: fb84b8224655 ("libbpf: add perf buffer API")
Link: https://lkml.kernel.org/n/tip-hnlmch8qit1ieksfppmr32si@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/bpf/libbpf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b1dec5b1de54..aaca132def74 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4508,13 +4508,13 @@ struct perf_buffer *perf_buffer__new(int map_fd, size_t page_cnt,
 				     const struct perf_buffer_opts *opts)
 {
 	struct perf_buffer_params p = {};
-	struct perf_event_attr attr = {
-		.config = PERF_COUNT_SW_BPF_OUTPUT,
-		.type = PERF_TYPE_SOFTWARE,
-		.sample_type = PERF_SAMPLE_RAW,
-		.sample_period = 1,
-		.wakeup_events = 1,
-	};
+	struct perf_event_attr attr = { 0, };
+
+	attr.config = PERF_COUNT_SW_BPF_OUTPUT,
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
 
 	p.attr = &attr;
 	p.sample_cb = opts ? opts->sample_cb : NULL;
-- 
2.21.0

