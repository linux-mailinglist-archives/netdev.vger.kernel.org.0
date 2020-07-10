Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F3621B882
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgGJOYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:24:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58426 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgGJOYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 10:24:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AELumT028561;
        Fri, 10 Jul 2020 14:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=VC3kOgFikop4jtNAHQvE25/L4vJ4XvWGd6htnn5j8jE=;
 b=DpcBSikVSvhoG5rFISMuyhcGInAvBWV/IOOWLx909J3x26RI2wrvLndtydCxKHERdryX
 aRYsaXjLGURL0/zwpzL7KTymiOTourc6FWjpKKHM1WnsUYoE2T+EQUfQEkn28pnEXLlK
 CrRKgjwPOaprtH+nvRKQjGZvf7gjj8iwUSXj4Y0qKB4vznyeNzwwKRaXM/S6uwW/OxA+
 zyyS92UPvOy2HnYh1ZVJaf/ApCDFT24ThsmXonoCuFCI0JSpsiHv15XtlEGjNbtcvihB
 zbZN30RFFM/Qod6bUj76qLnScKw1YzeosrlVLzqRbLxy7pW16zT9DAYA1M3Hs3UMnYeK EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 325y0aqrpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 14:23:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AENOj2115128;
        Fri, 10 Jul 2020 14:23:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 325k3kdsuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 14:23:26 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06AENOgZ002545;
        Fri, 10 Jul 2020 14:23:24 GMT
Received: from localhost.uk.oracle.com (/10.175.190.31)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 07:23:24 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: add selftests verifying bpf_trace_printk() behaviour
Date:   Fri, 10 Jul 2020 15:22:33 +0100
Message-Id: <1594390953-31757-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594390953-31757-1-git-send-email-alan.maguire@oracle.com>
References: <1594390953-31757-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple selftests that verifies bpf_trace_printk() returns a sensible
value and tracing messages appear.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/trace_printk.c        | 74 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/trace_printk.c   | 21 ++++++
 2 files changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_printk.c b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
new file mode 100644
index 0000000..25dd0f47
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_printk.c
@@ -0,0 +1,74 @@
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
+	int err, iter = 0, duration = 0, found = 0, fd = -1;
+	struct trace_printk__bss *bss;
+	struct trace_printk *skel;
+	char buf[1024];
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
+	while (read(fd, buf, sizeof(buf)) >= 0 || errno == EAGAIN) {
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
+	printf("ran %d times; last return value %d, with %d instances of msg\n",
+	       bss->trace_printk_ran, bss->trace_printk_ret, found);
+cleanup:
+	trace_printk__destroy(skel);
+	if (fd != -1)
+		close(fd);
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

