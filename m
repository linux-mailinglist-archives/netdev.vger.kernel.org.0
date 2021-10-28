Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB4F43E288
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhJ1Nvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:51:41 -0400
Received: from foss.arm.com ([217.140.110.172]:55144 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhJ1NvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:51:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEC811396;
        Thu, 28 Oct 2021 06:48:56 -0700 (PDT)
Received: from e121896.Emea.Arm.com (e121896.Emea.Arm.com [10.32.36.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B141D3F70D;
        Thu, 28 Oct 2021 06:48:52 -0700 (PDT)
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
        Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 3/3] perf tests: Remove bash constructs from stat_all_pmu.sh
Date:   Thu, 28 Oct 2021 14:48:27 +0100
Message-Id: <20211028134828.65774-4-james.clark@arm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20211028134828.65774-1-james.clark@arm.com>
References: <20211028134828.65774-1-james.clark@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tests were passing but without testing and were printing the
following:

  $ ./perf test -v 90
  90: perf all PMU test                                               :
  --- start ---
  test child forked, pid 51650
  Testing cpu/branch-instructions/
  ./tests/shell/stat_all_pmu.sh: 10: [:
   Performance counter stats for 'true':

             137,307      cpu/branch-instructions/

         0.001686672 seconds time elapsed

         0.001376000 seconds user
         0.000000000 seconds sys: unexpected operator

Changing the regexes to a grep works in sh and prints this:

  $ ./perf test -v 90
  90: perf all PMU test                                               :
  --- start ---
  test child forked, pid 60186
  [...]
  Testing tlb_flush.stlb_any
  test child finished with 0
  ---- end ----
  perf all PMU test: Ok

Signed-off-by: James Clark <james.clark@arm.com>
---
 tools/perf/tests/shell/stat_all_pmu.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/shell/stat_all_pmu.sh b/tools/perf/tests/shell/stat_all_pmu.sh
index 2de7fd0394fd..b30dba455f36 100755
--- a/tools/perf/tests/shell/stat_all_pmu.sh
+++ b/tools/perf/tests/shell/stat_all_pmu.sh
@@ -7,11 +7,11 @@ set -e
 for p in $(perf list --raw-dump pmu); do
   echo "Testing $p"
   result=$(perf stat -e "$p" true 2>&1)
-  if [[ ! "$result" =~ "$p" ]] && [[ ! "$result" =~ "<not supported>" ]]; then
+  if ! echo "$result" | grep -q "$p" && ! echo "$result" | grep -q "<not supported>" ; then
     # We failed to see the event and it is supported. Possibly the workload was
     # too small so retry with something longer.
     result=$(perf stat -e "$p" perf bench internals synthesize 2>&1)
-    if [[ ! "$result" =~ "$p" ]]; then
+    if ! echo "$result" | grep -q "$p" ; then
       echo "Event '$p' not printed in:"
       echo "$result"
       exit 1
-- 
2.28.0

