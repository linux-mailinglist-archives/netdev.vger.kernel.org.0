Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB3950A64A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390435AbiDUQzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387208AbiDUQza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:55:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A94FE49CA0;
        Thu, 21 Apr 2022 09:52:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66D8C153B;
        Thu, 21 Apr 2022 09:52:31 -0700 (PDT)
Received: from ip-10-252-15-9.eu-west-1.compute.internal (unknown [10.252.15.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8CFBD3F73B;
        Thu, 21 Apr 2022 09:52:28 -0700 (PDT)
From:   Timothy Hayes <timothy.hayes@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Timothy Hayes <timothy.hayes@arm.com>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 3/3] perf test: Add perf_event_attr test for Arm SPE
Date:   Thu, 21 Apr 2022 17:52:05 +0100
Message-Id: <20220421165205.117662-4-timothy.hayes@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421165205.117662-1-timothy.hayes@arm.com>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a perf_event_attr test for Arm SPE in which the presence of
physical addresses are checked when SPE unit is run with pa_enable=1.

Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
---
 tools/perf/tests/attr/README                         |  1 +
 .../perf/tests/attr/test-record-spe-physical-address | 12 ++++++++++++
 2 files changed, 13 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-spe-physical-address

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
index 454505d343fa..eb3f7d4bb324 100644
--- a/tools/perf/tests/attr/README
+++ b/tools/perf/tests/attr/README
@@ -60,6 +60,7 @@ Following tests are defined (with perf commands):
   perf record -R kill                           (test-record-raw)
   perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
   perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
+  perf record -e arm_spe_0/pa_enable=1/ -- kill (test-record-spe-physical-address)
   perf stat -e cycles kill                      (test-stat-basic)
   perf stat kill                                (test-stat-default)
   perf stat -d kill                             (test-stat-detailed-1)
diff --git a/tools/perf/tests/attr/test-record-spe-physical-address b/tools/perf/tests/attr/test-record-spe-physical-address
new file mode 100644
index 000000000000..7ebcf5012ce3
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-spe-physical-address
@@ -0,0 +1,12 @@
+[config]
+command = record
+args    = --no-bpf-event -e arm_spe_0/pa_enable=1/ -- kill >/dev/null 2>&1
+ret     = 1
+arch    = aarch64
+
+[event-10:base-record-spe]
+# 622727 is the decimal of IP|TID|TIME|CPU|IDENTIFIER|DATA_SRC|PHYS_ADDR
+sample_type=622727
+
+# dummy event
+[event-1:base-record-spe]
\ No newline at end of file
-- 
2.25.1

