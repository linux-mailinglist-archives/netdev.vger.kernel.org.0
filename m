Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9588C21D54E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgGMLxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:53:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbgGMLxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:53:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBqoYZ053984;
        Mon, 13 Jul 2020 11:52:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=z/1QPWqbNyssbqBldMP+d1+QFcSjoQ7OXySDQDNPWcc=;
 b=nMuqAZb1fl7VT6hBcuSqplj5RvdkimFGmNkOOo04qXrpBVDfEhxxm9kO4Q3winHDZFA0
 jG7KAXmpxDa6wTPcX5sYxm6EuBfPiWSEd3Q0FDc1WuDMwoQbJ3qoElBmYab3EO1nuFUD
 xVEW7ebQvOVNZmTB8Uc+yUhOHpKFjwQnJYjjxgwW7yxv2a9A8ail3i2HOr605MencrWY
 yc5sAPInTV8NyGoWHklMcOLvIpAiIiH9Z5sYjGgzV7KVp8aYYs0XIlvC+cJXT531T14d
 frZdcjlJO76eGkLYxY/on25SbvqI97ZPlxuR+60fvBmexZKJIMADXBNZqB/TfyoCbC0u Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32762n6dke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 11:52:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBhlpf106797;
        Mon, 13 Jul 2020 11:52:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0m7usr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 11:52:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DBqsvG020305;
        Mon, 13 Jul 2020 11:52:54 GMT
Received: from localhost.uk.oracle.com (/10.175.215.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 04:52:53 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v3 bpf-next 2/2] selftests/bpf: add selftests verifying bpf_trace_printk() behaviour
Date:   Mon, 13 Jul 2020 12:52:34 +0100
Message-Id: <1594641154-18897-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
References: <1594641154-18897-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=2 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple selftests that verifies bpf_trace_printk() returns a sensible
value and tracing messages appear.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/trace_printk.c        | 75 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/trace_printk.c   | 21 ++++++
 2 files changed, 96 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk.c b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
new file mode 100644
index 0000000..39b0dec
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+
+#include <test_progs.h>
+
+#include "trace_printk.skel.h"
+
+#define TRACEBUF	"/sys/kernel/debug/tracing/trace_pipe"
+#define SEARCHMSG	"testing,testing"
+
+void test_trace_printk(void)
+{
+	int err, iter = 0, duration = 0, found = 0;
+	struct trace_printk__bss *bss;
+	struct trace_printk *skel;
+	char *buf = NULL;
+	FILE *fp = NULL;
+	size_t buflen;
+
+	skel = trace_printk__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err = trace_printk__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = trace_printk__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	fp = fopen(TRACEBUF, "r");
+	if (CHECK(fp == NULL, "could not open trace buffer",
+		  "error %d opening %s", errno, TRACEBUF))
+		goto cleanup;
+
+	/* We do not want to wait forever if this test fails... */
+	fcntl(fileno(fp), F_SETFL, O_NONBLOCK);
+
+	/* wait for tracepoint to trigger */
+	usleep(1);
+	trace_printk__detach(skel);
+
+	if (CHECK(bss->trace_printk_ran == 0,
+		  "bpf_trace_printk never ran",
+		  "ran == %d", bss->trace_printk_ran))
+		goto cleanup;
+
+	if (CHECK(bss->trace_printk_ret <= 0,
+		  "bpf_trace_printk returned <= 0 value",
+		  "got %d", bss->trace_printk_ret))
+		goto cleanup;
+
+	/* verify our search string is in the trace buffer */
+	while (getline(&buf, &buflen, fp) >= 0 || errno == EAGAIN) {
+		if (strstr(buf, SEARCHMSG) != NULL)
+			found++;
+		if (found == bss->trace_printk_ran)
+			break;
+		if (++iter > 1000)
+			break;
+	}
+
+	if (CHECK(!found, "message from bpf_trace_printk not found",
+		  "no instance of %s in %s", SEARCHMSG, TRACEBUF))
+		goto cleanup;
+
+cleanup:
+	trace_printk__destroy(skel);
+	free(buf);
+	if (fp)
+		fclose(fp);
+}
diff --git a/tools/testing/selftests/bpf/progs/trace_printk.c b/tools/testing/selftests/bpf/progs/trace_printk.c
new file mode 100644
index 0000000..8ca7f39
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/trace_printk.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020, Oracle and/or its affiliates.
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int trace_printk_ret = 0;
+int trace_printk_ran = 0;
+
+SEC("tp/raw_syscalls/sys_enter")
+int sys_enter(void *ctx)
+{
+	static const char fmt[] = "testing,testing %d\n";
+
+	trace_printk_ret = bpf_trace_printk(fmt, sizeof(fmt),
+					    ++trace_printk_ran);
+	return 0;
+}
-- 
1.8.3.1

