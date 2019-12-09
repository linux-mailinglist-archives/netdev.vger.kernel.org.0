Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DFD116442
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 01:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfLIABY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Dec 2019 19:01:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49682 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbfLIABX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 19:01:23 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB8Nw01F031006
        for <netdev@vger.kernel.org>; Sun, 8 Dec 2019 16:01:22 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrc265vcv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 16:01:22 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Dec 2019 16:01:21 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 9F59B760CCB; Sun,  8 Dec 2019 16:01:20 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <rostedt@goodmis.org>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 3/3] selftests/bpf: test function_graph tracer and bpf trampoline together
Date:   Sun, 8 Dec 2019 16:01:14 -0800
Message-ID: <20191209000114.1876138-4-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209000114.1876138-1-ast@kernel.org>
References: <20191209000114.1876138-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-08_07:2019-12-05,2019-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=401
 suspectscore=1 mlxscore=0 phishscore=0 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912080207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add simple test script to execute funciton graph tracer while BPF trampoline
attaches and detaches from the functions being graph traced.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/test_ftrace.sh | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100755 tools/testing/selftests/bpf/test_ftrace.sh

diff --git a/tools/testing/selftests/bpf/test_ftrace.sh b/tools/testing/selftests/bpf/test_ftrace.sh
new file mode 100755
index 000000000000..20de7bb873bc
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_ftrace.sh
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+TR=/sys/kernel/debug/tracing/
+clear_trace() { # reset trace output
+    echo > $TR/trace
+}
+
+disable_tracing() { # stop trace recording
+    echo 0 > $TR/tracing_on
+}
+
+enable_tracing() { # start trace recording
+    echo 1 > $TR/tracing_on
+}
+
+reset_tracer() { # reset the current tracer
+    echo nop > $TR/current_tracer
+}
+
+disable_tracing
+clear_trace
+
+echo "" > $TR/set_ftrace_filter
+echo '*printk* *console* *wake* *serial* *lock*' > $TR/set_ftrace_notrace
+
+echo "bpf_prog_test*" > $TR/set_graph_function
+echo "" > $TR/set_graph_notrace
+
+echo function_graph > $TR/current_tracer
+
+enable_tracing
+./test_progs -t fentry
+./test_progs -t fexit
+disable_tracing
+clear_trace
+
+reset_tracer
+
+exit 0
-- 
2.23.0

