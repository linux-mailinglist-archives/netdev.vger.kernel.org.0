Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1394EE3BA6
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504341AbfJXTCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:02:32 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56409 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504321AbfJXTC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:02:29 -0400
Received: by mail-pg1-f201.google.com with SMTP id u4so18499013pgp.23
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gqjRA7utK84t0hFtqZlJ+wiNMJ2M/V0XD0ZpglWruVc=;
        b=RZGqh51Qr/eWD2Ooq6wVLu6f0biQN82V1VKy9W2BZxH4mFtmaGguwbDzL6ASOr8xT0
         kpm5dGrgpSbAXJyHi2AK5dsT2RSUZvNBpUHeQfE0p65tbNO9YLAAthglkEhNgGUmwS3D
         ajS+ObEUqHGU1UTuFVrEvLz/C0UQa5KTomDJLGzXtQHLQwjaZdAZIzWO5HXjVSTu2cbO
         uuOHwmfy7tyuyVcFImLp6DdgiihTUu/PRU515Fltr2E5ZOLmzZeElnNcoQfCtuoAEaR/
         D1gBF9eJKZ3ghG8Qp0mtzRiHfRVJs3srLMA4tfGXmIFKDSqnTUGcItXvVqB47SMwvzFF
         laaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gqjRA7utK84t0hFtqZlJ+wiNMJ2M/V0XD0ZpglWruVc=;
        b=jbJbGgg04c63Q/tGAMwjVRBPZhYe6mj0qZj3vkEWgSEQQSpOIu2Dj80pynbbVHjzlO
         wOM9NufeZi/2jAgkdHImx5U8yrJZ+oM2KCHwnc+B8uaZhxQSQMgkOIIA0GSfQi1pQWoj
         4d745IiOvTjSOXlt9S7G6mgwie/NeNd6sGTNX97aYwNzM4hX54XtugpgYCzuSy00I0uT
         dUBMq4ESEEkT4yeNQjSJ+1SXDa7jk4wohwPRjhapkSaZSgMcyTKE814pWw1w5UlI0/wx
         L4RmX8LPyfXgSYer8W4nHnVns3hMSR4TTNGWHKYTG80VCMjSeUNa7bMtneuBbCYkCIv+
         zg1w==
X-Gm-Message-State: APjAAAVA8ca93sy+TgPUQb5PxlwuWre+5Bv6QxK+qzthiUuOVgoZnXwV
        50Af+3BZ46Y3CEEZBIZkuV6OtAftKLgC
X-Google-Smtp-Source: APXvYqzeLxsYQVas8b+zU1CkaGEpstfT3CvicPP4VxCdhsprBo7j8Yyn0uInHBBGQhogEKKbU4FZn9lMfk+k
X-Received: by 2002:a65:498c:: with SMTP id r12mr16268812pgs.280.1571943748421;
 Thu, 24 Oct 2019 12:02:28 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:02:01 -0700
In-Reply-To: <20191024190202.109403-1-irogers@google.com>
Message-Id: <20191024190202.109403-9-irogers@google.com>
Mime-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 8/9] perf tools: if pmu configuration fails free terms
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
index dc5862a663b5..999ea7378969 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1406,8 +1406,15 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
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
2.23.0.866.gb869b98d4c-goog

