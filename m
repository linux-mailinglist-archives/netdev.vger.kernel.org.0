Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE940EA658
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfJ3WfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:35:18 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:39966 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfJ3WfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:35:16 -0400
Received: by mail-pl1-f201.google.com with SMTP id f10so2530292plr.7
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=n/kunXFB8a17/1SeufduY2AZP1in+T/Iq/GsFxRYzfY=;
        b=l05WTTftzkwYenk8bVJ16EaTRciLaUtMqRbwlXpBBRfNqUlrXbXG4d2kZVDod0qRT1
         QemSRI2R6pFqjC4xssA9CHv+kG/6uajvIMIsjgW+UAtcEE4Igy3skTCMlF98kAlD8Izb
         aQFaGZAijkQJNO1Kct0mO3IvLAquBqnGS9p01Ule3gft9yLkTaoAXn/+i9HLvlrXiDXI
         u3Z04Nw2FArAfEpqco3sOzW8OPJQt/OzNTRjyUjfjB/x4IQDvX3Z3QhuwAQ6TGeM6klG
         cFo5rdzhOyrSoDwt6GgcM3h6jfLO92wn/vckvlNJab9Bx1/4qg41pEkmJkobejSh+9hE
         xzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n/kunXFB8a17/1SeufduY2AZP1in+T/Iq/GsFxRYzfY=;
        b=gH3tIcpGNiCvGmH8Y7MtKjqVLcDqRoODM985gmBasNWelETkIWb0nSbDfb/RhFI+mg
         2cPAYVRkEnuN88I/IsvOaWMen5MA/BOZT2YIW0+d8Vbbp+jE776oxfegpyY/dzQ3OATY
         6VguTazXcTmLXtaxnQwfdDdAMYKo5eDxKTXlde+KAD6FROQN2FKxPkXm0kNF75vXy7Um
         3jQAu5rpWVQK45b9nw8fsYGO0raP/oDt89wco78c+JIh15enCGZpfUNfxhVR1zkA+ULF
         dsUYOqhtfFp+W/S1me8N6+rEErR5/6nk8ZKya1KF9AdMr8pmARhDpW/QTJG+3CWY9SFa
         jr+w==
X-Gm-Message-State: APjAAAUy959qCUSYauGlbtoMUJnuTkEYvaL9XIHAwIvnzprvRzMhna04
        ZjV1rG9LEj82V86EO1Taik+PGvNW1lH4
X-Google-Smtp-Source: APXvYqyUXDTP+AZ2NyPn5itLqJLExzhTopKCQLn1yYFozbb1JDl/bquUPF6RFStOo1v+cOvusy5TPWMDPE6z
X-Received: by 2002:a63:4b52:: with SMTP id k18mr1971001pgl.394.1572474914325;
 Wed, 30 Oct 2019 15:35:14 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:34:46 -0700
In-Reply-To: <20191030223448.12930-1-irogers@google.com>
Message-Id: <20191030223448.12930-9-irogers@google.com>
Mime-Version: 1.0
References: <20191025180827.191916-1-irogers@google.com> <20191030223448.12930-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 08/10] perf tools: if pmu configuration fails free terms
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a memory leak when the configuration fails.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 578288c94d2a..a0a80f4e7038 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1388,8 +1388,15 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 	if (get_config_terms(head_config, &config_terms))
 		return -ENOMEM;
 
-	if (perf_pmu__config(pmu, &attr, head_config, parse_state->error))
+	if (perf_pmu__config(pmu, &attr, head_config, parse_state->error)) {
+		struct perf_evsel_config_term *pos, *tmp;
+
+		list_for_each_entry_safe(pos, tmp, &config_terms, list) {
+			list_del_init(&pos->list);
+			free(pos);
+		}
 		return -EINVAL;
+	}
 
 	evsel = __add_event(list, &parse_state->idx, &attr,
 			    get_config_name(head_config), pmu,
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

