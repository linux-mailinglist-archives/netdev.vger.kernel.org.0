Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E885B23E398
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 23:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHFVoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 17:44:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgHFVoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 17:44:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076EgE5q153796;
        Thu, 6 Aug 2020 14:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=obaVmbgBXXm2urNWlyNH2OLW5Z9/AQRdX/v3/ftgK3I=;
 b=s1LhiUzq1dgyKH3qyoMLnYz3ie+BDgWEI4dISFmv/s8DaVMMcGuguvxcwBu7siJ+L6FX
 zgSpw1/o5BGY1SW2MQOmRwMf7+iBZp2/LIP72VAY+adyjZaooootLFHUudgSbWlooXyo
 hy7uvsRMJ4w1aTjyl/M48sHkjXxMDBJh+8/u00/1qMPlqYP7hDpN7c9lxYrpAhUW9Ro2
 x/Y1KMqqYEIydrEN8fR983yRhCpKJ5SA33vbdc2M1sOwncxDq57xtxUNmfhtlLvbOzZK
 CaV/2gNf1zktGy1jAaGaqJScVALXs0V2lwznAchVKkNhEm+1FZZ69j/HKMWJ0pHeOg34 hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32r6ep3dj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 14:45:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076EbpDM077357;
        Thu, 6 Aug 2020 14:43:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32r6cvhq5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 14:43:04 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076Eh3fK006113;
        Thu, 6 Aug 2020 14:43:03 GMT
Received: from localhost.uk.oracle.com (/10.175.182.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 07:43:03 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com
Cc:     linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC PATCH bpf-next 4/4] selftests/bpf: add bpf_trace_btf helper tests
Date:   Thu,  6 Aug 2020 15:42:25 +0100
Message-Id: <1596724945-22859-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basic tests verifying various flag combinations for bpf_trace_btf()
using a tp_btf program to trace skb data.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/trace_btf.c | 45 ++++++++++++++++++++++
 .../selftests/bpf/progs/netif_receive_skb.c        | 43 +++++++++++++++++++++
 2 files changed, 88 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_btf.c b/tools/testing/selftests/bpf/prog_tests/trace_btf.c
new file mode 100644
index 0000000..e64b69d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_btf.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+#include "netif_receive_skb.skel.h"
+
+void test_trace_btf(void)
+{
+	struct netif_receive_skb *skel;
+	struct netif_receive_skb__bss *bss;
+	int err, duration = 0;
+
+	skel = netif_receive_skb__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err = netif_receive_skb__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = netif_receive_skb__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* generate receive event */
+	system("ping -c 10 127.0.0.1");
+
+	/*
+	 * Make sure netif_receive_skb program was triggered
+	 * and it set expected return values from bpf_trace_printk()s
+	 * and all tests ran.
+	 */
+	if (CHECK(bss->ret <= 0,
+		  "bpf_trace_btf: got return value",
+		  "ret <= 0 %ld test %d\n", bss->ret, bss->num_subtests))
+		goto cleanup;
+
+	CHECK(bss->num_subtests != bss->ran_subtests, "check all subtests ran",
+	      "only ran %d of %d tests\n", bss->num_subtests,
+	      bss->ran_subtests);
+
+cleanup:
+	netif_receive_skb__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
new file mode 100644
index 0000000..cab764e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+long ret = 0;
+int num_subtests = 0;
+int ran_subtests = 0;
+
+#define CHECK_TRACE(_p, flags)						 \
+	do {								 \
+		++num_subtests;						 \
+		if (ret >= 0) {						 \
+			++ran_subtests;					 \
+			ret = bpf_trace_btf(_p, sizeof(*(_p)), 0, flags);\
+		}							 \
+	} while (0)
+
+/* TRACE_EVENT(netif_receive_skb,
+ *	TP_PROTO(struct sk_buff *skb),
+ */
+SEC("tp_btf/netif_receive_skb")
+int BPF_PROG(trace_netif_receive_skb, struct sk_buff *skb)
+{
+	static const char skb_type[] = "struct sk_buff";
+	static struct btf_ptr p = { };
+
+	p.ptr = skb;
+	p.type = skb_type;
+
+	CHECK_TRACE(&p, 0);
+	CHECK_TRACE(&p, BTF_TRACE_F_COMPACT);
+	CHECK_TRACE(&p, BTF_TRACE_F_NONAME);
+	CHECK_TRACE(&p, BTF_TRACE_F_PTR_RAW);
+	CHECK_TRACE(&p, BTF_TRACE_F_ZERO);
+	CHECK_TRACE(&p, BTF_TRACE_F_COMPACT | BTF_TRACE_F_NONAME |
+		    BTF_TRACE_F_PTR_RAW | BTF_TRACE_F_ZERO);
+
+	return 0;
+}
-- 
1.8.3.1

