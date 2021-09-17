Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E755C40FF6A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbhIQSbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:31:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21998 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242322AbhIQSbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:31:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 18H9qOPX022750
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:30:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PSnITEFHB7sS7hN+a0eYatcDYpSntdcRfTXmjmiubmY=;
 b=N+1aAYldJ0jnypce7Fi81bFjVBK+uln7YAjBSfGfeOE7RdNENd8/OnzsvIYU4/SGR6l8
 D2uiwF3X58uSDW3T0WDUDaEc5in4k7acx7EdLsVD9xEMgYRi2qr+/WQZySoOYh4p1HBi
 QxI1dq0vUErW1FyXcEtmq17y+zHlgeBhrE0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3b4rrnkaa2-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:29:59 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 17 Sep 2021 11:29:58 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 2F6F66BF322D; Fri, 17 Sep 2021 11:29:21 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v6 bpf-next 8/9] selftests/bpf: add trace_vprintk test prog
Date:   Fri, 17 Sep 2021 11:29:10 -0700
Message-ID: <20210917182911.2426606-9-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917182911.2426606-1-davemarchevsky@fb.com>
References: <20210917182911.2426606-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: Fyiy2j8tFNuM6SghqhBsUG4ncoTBwAWF
X-Proofpoint-GUID: Fyiy2j8tFNuM6SghqhBsUG4ncoTBwAWF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a test prog for vprintk which confirms that:
  * bpf_trace_vprintk is writing to /sys/kernel/debug/tracing/trace_pipe
  * __bpf_vprintk macro works as expected
  * >3 args are printed
  * bpf_printk w/ 0 format args compiles
  * bpf_trace_vprintk call w/ a fmt specifier but NULL fmt data fails

Approach and code are borrowed from trace_printk test.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c  | 68 +++++++++++++++++++
 .../selftests/bpf/progs/trace_vprintk.c       | 33 +++++++++
 3 files changed, 103 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 1a4d30ff3275..326ea75ce99e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -315,7 +315,8 @@ LINKED_SKELS :=3D test_static_linked.skel.h linked_fu=
ncs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
=20
 LSKELS :=3D kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
-	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
+	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
+	trace_vprintk.c
 SKEL_BLACKLIST +=3D $$(LSKELS)
=20
 test_static_linked.skel.h-deps :=3D test_static_linked1.o test_static_li=
nked2.o
diff --git a/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c b/too=
ls/testing/selftests/bpf/prog_tests/trace_vprintk.c
new file mode 100644
index 000000000000..61a24e62e1a0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <test_progs.h>
+
+#include "trace_vprintk.lskel.h"
+
+#define TRACEBUF	"/sys/kernel/debug/tracing/trace_pipe"
+#define SEARCHMSG	"1,2,3,4,5,6,7,8,9,10"
+
+void test_trace_vprintk(void)
+{
+	int err =3D 0, iter =3D 0, found =3D 0;
+	struct trace_vprintk__bss *bss;
+	struct trace_vprintk *skel;
+	char *buf =3D NULL;
+	FILE *fp =3D NULL;
+	size_t buflen;
+
+	skel =3D trace_vprintk__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "trace_vprintk__open_and_load"))
+		goto cleanup;
+
+	bss =3D skel->bss;
+
+	err =3D trace_vprintk__attach(skel);
+	if (!ASSERT_OK(err, "trace_vprintk__attach"))
+		goto cleanup;
+
+	fp =3D fopen(TRACEBUF, "r");
+	if (!ASSERT_OK_PTR(fp, "fopen(TRACEBUF)"))
+		goto cleanup;
+
+	/* We do not want to wait forever if this test fails... */
+	fcntl(fileno(fp), F_SETFL, O_NONBLOCK);
+
+	/* wait for tracepoint to trigger */
+	usleep(1);
+	trace_vprintk__detach(skel);
+
+	if (!ASSERT_GT(bss->trace_vprintk_ran, 0, "bss->trace_vprintk_ran"))
+		goto cleanup;
+
+	if (!ASSERT_GT(bss->trace_vprintk_ret, 0, "bss->trace_vprintk_ret"))
+		goto cleanup;
+
+	/* verify our search string is in the trace buffer */
+	while (getline(&buf, &buflen, fp) >=3D 0 || errno =3D=3D EAGAIN) {
+		if (strstr(buf, SEARCHMSG) !=3D NULL)
+			found++;
+		if (found =3D=3D bss->trace_vprintk_ran)
+			break;
+		if (++iter > 1000)
+			break;
+	}
+
+	if (!ASSERT_EQ(found, bss->trace_vprintk_ran, "found"))
+		goto cleanup;
+
+	if (!ASSERT_LT(bss->null_data_vprintk_ret, 0, "bss->null_data_vprintk_r=
et"))
+		goto cleanup;
+
+cleanup:
+	trace_vprintk__destroy(skel);
+	free(buf);
+	if (fp)
+		fclose(fp);
+}
diff --git a/tools/testing/selftests/bpf/progs/trace_vprintk.c b/tools/te=
sting/selftests/bpf/progs/trace_vprintk.c
new file mode 100644
index 000000000000..d327241ba047
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/trace_vprintk.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+int null_data_vprintk_ret =3D 0;
+int trace_vprintk_ret =3D 0;
+int trace_vprintk_ran =3D 0;
+
+SEC("fentry/__x64_sys_nanosleep")
+int sys_enter(void *ctx)
+{
+	static const char one[] =3D "1";
+	static const char three[] =3D "3";
+	static const char five[] =3D "5";
+	static const char seven[] =3D "7";
+	static const char nine[] =3D "9";
+	static const char f[] =3D "%pS\n";
+
+	/* runner doesn't search for \t, just ensure it compiles */
+	bpf_printk("\t");
+
+	trace_vprintk_ret =3D __bpf_vprintk("%s,%d,%s,%d,%s,%d,%s,%d,%s,%d %d\n=
",
+		one, 2, three, 4, five, 6, seven, 8, nine, 10, ++trace_vprintk_ran);
+
+	/* non-NULL fmt w/ NULL data should result in error */
+	null_data_vprintk_ret =3D bpf_trace_vprintk(f, sizeof(f), NULL, 0);
+	return 0;
+}
--=20
2.30.2

