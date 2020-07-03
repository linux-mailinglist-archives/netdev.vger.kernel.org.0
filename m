Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1E213C00
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGCOpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 10:45:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgGCOp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 10:45:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063Egmca010573;
        Fri, 3 Jul 2020 14:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=TkYOCaQ92FrXOw0/1NjMuLX7ItnHP73SNldBIYcl4S0=;
 b=camBN+NiVanMOp9DQ+Xxtw3ctxYhQ28H2aTZ3Ie9bnFW8iBHieXkhh1SYkXKHz9oyLdc
 Jw9Y5GCXjV2N0ghTL35EXX6kUEPN2foSuttJplP6dZMI8Y30Ns98BS3g7X19C86v7ubZ
 4t/qxyX/z/mD1zIubu+8663XeCjRQCt7I24IhJFS8GzGHtitnYvsZ6pI38h0GCwBsTx1
 JZ6ULBfvETLc+Zl2tbZhNLbz9Hb2+p2HG4b3xlp49HP6UHbCnPM6lQBjARGRaacSXZER
 cPPmvIaecDfJZznb0HfseQPNtXnWwTUM89ogIWjdFfaRjBqTOchfXxCpnzbIZv0eTXmR lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1eawy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 14:44:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063EhwYj034788;
        Fri, 3 Jul 2020 14:44:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg22sjua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 14:44:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 063Eij6S013246;
        Fri, 3 Jul 2020 14:44:45 GMT
Received: from localhost.uk.oracle.com (/10.175.204.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 14:44:45 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: add selftests verifying bpf_trace_printk() behaviour
Date:   Fri,  3 Jul 2020 15:44:28 +0100
Message-Id: <1593787468-29931-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com>
References: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple selftest that verifies bpf_trace_printk() returns a sensible
value and tracing messages appear.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/trace_printk.c        | 71 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/trace_printk.c   | 21 +++++++
 2 files changed, 92 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk.c b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
new file mode 100644
index 0000000..a850cba
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
@@ -0,0 +1,71 @@
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
+	int err, duration = 0, found = 0;
+	struct trace_printk *skel;
+	struct trace_printk__bss *bss;
+	char buf[1024];
+	int fd = -1;
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
+	fd = open(TRACEBUF, O_RDONLY);
+	if (CHECK(fd < 0, "could not open trace buffer",
+		  "error %d opening %s", errno, TRACEBUF))
+		goto cleanup;
+
+	/* We do not want to wait forever if this test fails... */
+	fcntl(fd, F_SETFL, O_NONBLOCK);
+
+	/* wait for tracepoint to trigger */
+	sleep(1);
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
+	while (read(fd, buf, sizeof(buf)) >= 0) {
+		if (strstr(buf, SEARCHMSG) != NULL)
+			found++;
+	}
+
+	if (CHECK(!found, "message from bpf_trace_printk not found",
+		  "no instance of %s in %s", SEARCHMSG, TRACEBUF))
+		goto cleanup;
+
+	printf("ran %d times; last return value %d, with %d instances of msg\n",
+	       bss->trace_printk_ran, bss->trace_printk_ret, found);
+cleanup:
+	trace_printk__destroy(skel);
+	if (fd != -1)
+		close(fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/trace_printk.c b/tools/testing/selftests/bpf/progs/trace_printk.c
new file mode 100644
index 0000000..8ff6d49
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
+SEC("tracepoint/sched/sched_switch")
+int sched_switch(void *ctx)
+{
+	static const char fmt[] = "testing,testing %d\n";
+
+	trace_printk_ret = bpf_trace_printk(fmt, sizeof(fmt),
+					    ++trace_printk_ran);
+	return 0;
+}
-- 
1.8.3.1

