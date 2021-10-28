Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4792143E285
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJ1Nve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:51:34 -0400
Received: from foss.arm.com ([217.140.110.172]:55122 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhJ1NvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:51:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11A5B11FB;
        Thu, 28 Oct 2021 06:48:52 -0700 (PDT)
Received: from e121896.Emea.Arm.com (e121896.Emea.Arm.com [10.32.36.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0E9F53F70D;
        Thu, 28 Oct 2021 06:48:47 -0700 (PDT)
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
Subject: [PATCH 2/3] perf tests: Remove bash construct from record+zstd_comp_decomp.sh
Date:   Thu, 28 Oct 2021 14:48:26 +0100
Message-Id: <20211028134828.65774-3-james.clark@arm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20211028134828.65774-1-james.clark@arm.com>
References: <20211028134828.65774-1-james.clark@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 463538a383a2 ("perf tests: Fix test 68 zstd compression for
s390") inadvertently removed the -g flag from all platforms rather than
just s390, because the [[ ]] construct fails in sh. Changing to single
brackets restores testing of call graphs and removes the following error
from the output:

  $ ./perf test -v 85
  85: Zstd perf.data compression/decompression                        :
  --- start ---
  test child forked, pid 50643
  Collecting compressed record file:
  ./tests/shell/record+zstd_comp_decomp.sh: 15: [[: not found

Fixes: 463538a383a2 ("perf tests: Fix test 68 zstd compression for s390")
Signed-off-by: James Clark <james.clark@arm.com>
---
 tools/perf/tests/shell/record+zstd_comp_decomp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record+zstd_comp_decomp.sh b/tools/perf/tests/shell/record+zstd_comp_decomp.sh
index 8a168cf8bacc..49bd875d5122 100755
--- a/tools/perf/tests/shell/record+zstd_comp_decomp.sh
+++ b/tools/perf/tests/shell/record+zstd_comp_decomp.sh
@@ -12,7 +12,7 @@ skip_if_no_z_record() {
 
 collect_z_record() {
 	echo "Collecting compressed record file:"
-	[[ "$(uname -m)" != s390x ]] && gflag='-g'
+	[ "$(uname -m)" != s390x ] && gflag='-g'
 	$perf_tool record -o $trace_file $gflag -z -F 5000 -- \
 		dd count=500 if=/dev/urandom of=/dev/null
 }
-- 
2.28.0

