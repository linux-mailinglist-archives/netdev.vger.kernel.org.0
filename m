Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D343E282
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhJ1NvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:51:17 -0400
Received: from foss.arm.com ([217.140.110.172]:55102 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhJ1NvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:51:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D65D106F;
        Thu, 28 Oct 2021 06:48:47 -0700 (PDT)
Received: from e121896.Emea.Arm.com (e121896.Emea.Arm.com [10.32.36.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 553DC3F70D;
        Thu, 28 Oct 2021 06:48:43 -0700 (PDT)
From:   James Clark <james.clark@arm.com>
To:     acme@kernel.org, linux-perf-users@vger.kernel.org,
        f.fainelli@gmail.com, irogers@google.com
Cc:     James Clark <james.clark@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 1/3] perf test: Remove bash construct from stat_bpf_counters.sh test
Date:   Thu, 28 Oct 2021 14:48:25 +0100
Message-Id: <20211028134828.65774-2-james.clark@arm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20211028134828.65774-1-james.clark@arm.com>
References: <20211028134828.65774-1-james.clark@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the test skips with an error because == only works in bash:

  $ ./perf test 91 -v
  Couldn't bump rlimit(MEMLOCK), failures may take place when creating BPF maps, etc
  91: perf stat --bpf-counters test                                   :
  --- start ---
  test child forked, pid 44586
  ./tests/shell/stat_bpf_counters.sh: 26: [: -v: unexpected operator
  test child finished with -2
  ---- end ----
  perf stat --bpf-counters test: Skip

Changing == to = does the same thing, but doesn't result in an error:

  ./perf test 91 -v
  Couldn't bump rlimit(MEMLOCK), failures may take place when creating BPF maps, etc
  91: perf stat --bpf-counters test                                   :
  --- start ---
  test child forked, pid 45833
  Skipping: --bpf-counters not supported
    Error: unknown option `bpf-counters'
  [...]
  test child finished with -2
  ---- end ----
  perf stat --bpf-counters test: Skip

Signed-off-by: James Clark <james.clark@arm.com>
---
 tools/perf/tests/shell/stat_bpf_counters.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat_bpf_counters.sh b/tools/perf/tests/shell/stat_bpf_counters.sh
index 2aed20dc2262..13473aeba489 100755
--- a/tools/perf/tests/shell/stat_bpf_counters.sh
+++ b/tools/perf/tests/shell/stat_bpf_counters.sh
@@ -23,7 +23,7 @@ compare_number()
 
 # skip if --bpf-counters is not supported
 if ! perf stat --bpf-counters true > /dev/null 2>&1; then
-	if [ "$1" == "-v" ]; then
+	if [ "$1" = "-v" ]; then
 		echo "Skipping: --bpf-counters not supported"
 		perf --no-pager stat --bpf-counters true || true
 	fi
-- 
2.28.0

