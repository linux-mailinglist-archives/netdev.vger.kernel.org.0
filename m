Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6536E65215
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 08:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfGKGx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 02:53:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728119AbfGKGx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 02:53:28 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B6o3tK032277
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:53:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xW6SG4k1Rs+ZlCTlxu2pIGDqZC+9KjbDSxg/KmhEDu4=;
 b=gANpk55hdoPbwrt4OxO3JQOtH/rUubUFIQcGQkGVr3clJ8wCsA/R5t7Y/mNUIPmkaMtl
 KY153iDcFyrz8SA9DPVIzYXuiRgwej4EqQUwzNYom452DfTtdG5tdsHmeALYykzOb+Tu
 J3aj4LeKiG0A7hu9sxc7hlShnOb/KwtQEn8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnva10kuj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:53:26 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 10 Jul 2019 23:53:25 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 26F1C861661; Wed, 10 Jul 2019 23:53:25 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: use typedef'ed arrays as map values
Date:   Wed, 10 Jul 2019 23:53:07 -0700
Message-ID: <20190711065307.2425636-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190711065307.2425636-1-andriin@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110079
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert few tests that couldn't use typedef'ed arrays due to kernel bug.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c     | 3 ++-
 tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c | 3 +--
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index d06b47a09097..33254b771384 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -47,11 +47,12 @@ struct {
  * issue and avoid complicated C programming massaging.
  * This is an acceptable workaround since there is one entry here.
  */
+typedef __u64 raw_stack_trace_t[2 * MAX_STACK_RAWTP];
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__uint(max_entries, 1);
 	__type(key, __u32);
-	__u64 (*value)[2 * MAX_STACK_RAWTP];
+	__type(value, raw_stack_trace_t);
 } rawdata_map SEC(".maps");
 
 SEC("tracepoint/raw_syscalls/sys_enter")
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index bbfc8337b6f0..f5638e26865d 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -36,8 +36,7 @@ struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 128);
 	__type(key, __u32);
-	/* there seems to be a bug in kernel not handling typedef properly */
-	struct bpf_stack_build_id (*value)[PERF_MAX_STACK_DEPTH];
+	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
 /* taken from /sys/kernel/debug/tracing/events/random/urandom_read/format */
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index 803c15dc109d..fa0be3e10a10 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -35,7 +35,7 @@ struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 16384);
 	__type(key, __u32);
-	__u64 (*value)[PERF_MAX_STACK_DEPTH];
+	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
-- 
2.17.1

