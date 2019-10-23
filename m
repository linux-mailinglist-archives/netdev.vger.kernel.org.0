Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B156AE0F6D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732704AbfJWAyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:54:14 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:42387 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732669AbfJWAyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:54:12 -0400
Received: by mail-pg1-f202.google.com with SMTP id x203so7730884pgx.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98x/ZBLRTnMz91JDf+r9eCkgM4R/aoJz7oABA29poQw=;
        b=BL8dfNYwle/qgbtW7ADVHiEsSuwDsPLSjZoTlfXnyBE0oqkv1xRRcAwpwnjTG/UhRy
         ISsJthzTeEQUMS7g0lCGJbG93C5BRxPyP8lId+AdASqwo84DykO2wLDNuaAxqKA1IX/O
         iTR6Luj0jJI3JE5RMfuZvTBQdZTsfSyjj/FPLjdWOQKtb/rP4LSTf3FG61gkWGbAM1QQ
         uys3F9C2nkJ19ZClEX2bMBki9FW87OhkyJlk0k+bgKEzX+VdNwbnee3KVbObhucc/ZHO
         dwiV1/bRVl14YMNAKrWD7i9S/1x8sGDRth318qZKTokTijAHXJaIzF6W5tB20o9btapG
         N9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98x/ZBLRTnMz91JDf+r9eCkgM4R/aoJz7oABA29poQw=;
        b=OQm95uUEhzdOtCZflD1hzC3b489gaVi2pnxxoZWu8cauHu99kAVkaWJmcpYSw09I+0
         3JsRyjNAZN1wwUhR879xw5OSbWAqr0qbWBArIYcW3uTjbwBAPM8SRALBwyt45Ybv2+XB
         7h2vVXClkb7GMg8+8f8metm3lUHLU2ltkoq8psHmgn2lRqYkq5X7A/w1mZ/E/d1WXGk7
         Pkw3P9+ElQuTngCEqVfaGWsdXsuWjoZeuv+UrS81nQ+ioDP4ezdyasIFRxBTCmcDM8az
         tksXLlL+VVlIw8QMfl4nXUi18U52sVaWSD/mebL1mHBA+HpipH7D1FooU4/8F51wI/Sh
         zePg==
X-Gm-Message-State: APjAAAX1nzi/dRn41CqZAHCVUbP83P7GMaUHHoh6FyG8g4dsJGTYR3uN
        4qfkVW820Mri5p2RUt01hlxOtUF5xmxR
X-Google-Smtp-Source: APXvYqwtREz6g9G/rGR93rQsNY/2ZLedqbEtW+Xi7gR2wUD6zXu9bFlMVAC8iCLgsGQ/ldKSRBkh98pzxPJx
X-Received: by 2002:a63:1666:: with SMTP id 38mr2072471pgw.93.1571792051528;
 Tue, 22 Oct 2019 17:54:11 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:53:33 -0700
In-Reply-To: <20191023005337.196160-1-irogers@google.com>
Message-Id: <20191023005337.196160-6-irogers@google.com>
Mime-Version: 1.0
References: <20191017170531.171244-1-irogers@google.com> <20191023005337.196160-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v2 5/9] perf tools: avoid a malloc for array events
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

Use realloc rather than malloc+memcpy to possibly avoid a memory
allocation when appending array elements.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.y | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 26cb65798522..545ab7cefc20 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -691,14 +691,12 @@ array_terms ',' array_term
 	struct parse_events_array new_array;
 
 	new_array.nr_ranges = $1.nr_ranges + $3.nr_ranges;
-	new_array.ranges = malloc(sizeof(new_array.ranges[0]) *
-				  new_array.nr_ranges);
+	new_array.ranges = realloc($1.ranges,
+				sizeof(new_array.ranges[0]) *
+				new_array.nr_ranges);
 	ABORT_ON(!new_array.ranges);
-	memcpy(&new_array.ranges[0], $1.ranges,
-	       $1.nr_ranges * sizeof(new_array.ranges[0]));
 	memcpy(&new_array.ranges[$1.nr_ranges], $3.ranges,
 	       $3.nr_ranges * sizeof(new_array.ranges[0]));
-	free($1.ranges);
 	free($3.ranges);
 	$$ = new_array;
 }
-- 
2.23.0.866.gb869b98d4c-goog

