Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BC02CF456
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgLDSuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:50:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730277AbgLDSue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:50:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4IdRT6080674;
        Fri, 4 Dec 2020 18:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=LodmyqwDjSlhRwAL2+FQ9VMhHLbsi9nNb2DqAz9Jwck=;
 b=QsnK8LlyaOdGMqWdxHVY4obElKLM6cakDDAQplT+ZM5ZBgnjoha/JODZwqEYsULNp1Td
 diMR/jGPXf71djv6WdV1P81KLaVU/yui8DFy9C7ZToU2IH+6OjvtrsPCY1rpQJFuZXDI
 guZGVy8GbhwufwcJL7wmw78EgiFCaFlPXqCTg+y5Dx34PcZjmuFqMehi6oT3/Ra9y8EG
 T7qP7JmgS7B8O5ajWqaReMNA1zfWcwJ9Hv3wknFqySaekYa4CAx2pEAHyBpqpLQRY6PG
 Z6jiDoDSFLu6d4bPsWHHUfNNHaBNQ3nSwcI4wBN1Hj6ol1rjy+6YFbI89FBN+6uA6dAn Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2bcpvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 18:49:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4IaGEk044262;
        Fri, 4 Dec 2020 18:49:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f3pnxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 18:49:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4In5vA025494;
        Fri, 4 Dec 2020 18:49:05 GMT
Received: from localhost.uk.oracle.com (/10.175.205.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 10:49:04 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, shuah@kernel.org, lmb@cloudflare.com,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: verify module-specific types can be shown via bpf_snprintf_btf
Date:   Fri,  4 Dec 2020 18:48:36 +0000
Message-Id: <1607107716-14135-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that specifying a module object id in "struct btf_ptr *" along
with a type id of a module-specific type will succeed.

veth_stats_rx() is chosen because its function signature consists
of a module-specific type "struct veth_stats" and a kernel-specific
one "struct net_device".

Currently the tests take the messy approach of determining object
and type ids for the relevant module/function; __builtin_btf_type_id()
supports object ids by returning a 64-bit value, but need to find a good
way to determine if that support is present.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 124 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   2 +-
 tools/testing/selftests/bpf/progs/btf_ptr.h        |   2 +-
 tools/testing/selftests/bpf/progs/veth_stats_rx.c  |  72 ++++++++++++
 4 files changed, 198 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
 create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
new file mode 100644
index 0000000..89805d7
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <linux/btf.h>
+#include <bpf/btf.h>
+#include "veth_stats_rx.skel.h"
+
+#define VETH_NAME	"bpfveth0"
+
+/* Demonstrate that bpf_snprintf_btf succeeds for both module-specific
+ * and kernel-defined data structures; veth_stats_rx() is used as
+ * it has both module-specific and kernel-defined data as arguments.
+ * This test assumes that veth is built as a module and will skip if not.
+ */
+void test_snprintf_btf_mod(void)
+{
+	struct btf *vmlinux_btf = NULL, *veth_btf = NULL;
+	struct veth_stats_rx *skel = NULL;
+	struct veth_stats_rx__bss *bss;
+	int err, duration = 0;
+	__u32 id;
+
+	err = system("ip link add name " VETH_NAME " type veth");
+	if (CHECK(err, "system", "ip link add veth failed: %d\n", err))
+		return;
+
+	vmlinux_btf = btf__parse_raw("/sys/kernel/btf/vmlinux");
+	err = libbpf_get_error(vmlinux_btf);
+	if (CHECK(err, "parse vmlinux BTF", "failed parsing vmlinux BTF: %d\n",
+		  err))
+		goto cleanup;
+	veth_btf = btf__parse_raw_split("/sys/kernel/btf/veth", vmlinux_btf);
+	err = libbpf_get_error(veth_btf);
+	if (err == -ENOENT) {
+		printf("%s:SKIP:no BTF info for veth\n", __func__);
+		test__skip();
+		goto cleanup;
+	}
+
+	if (CHECK(err, "parse veth BTF", "failed parsing veth BTF: %d\n", err))
+		goto cleanup;
+
+	skel = veth_stats_rx__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		goto cleanup;
+
+	err = veth_stats_rx__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	/* This could all be replaced by __builtin_btf_type_id(); but need
+	 * a way to determine if it supports object and type id.  In the
+	 * meantime, look up type id for veth_stats and object id for veth.
+	 */
+	bss->veth_stats_btf_id = btf__find_by_name(veth_btf, "veth_stats");
+
+	if (CHECK(bss->veth_stats_btf_id <= 0, "find 'struct veth_stats'",
+		  "could not find 'struct veth_stats' in veth BTF: %d",
+		  bss->veth_stats_btf_id))
+		goto cleanup;
+
+	bss->veth_obj_id = 0;
+
+	for (id = 1; bpf_btf_get_next_id(id, &id) == 0; ) {
+		struct bpf_btf_info info;
+		__u32 len = sizeof(info);
+		char name[64];
+		int fd;
+
+		fd = bpf_btf_get_fd_by_id(id);
+		if (fd < 0)
+			continue;
+
+		memset(&info, 0, sizeof(info));
+		info.name_len = sizeof(name);
+		info.name = (__u64)name;
+		if (bpf_obj_get_info_by_fd(fd, &info, &len) ||
+		    strcmp((char *)info.name, "veth") != 0)
+			continue;
+		bss->veth_obj_id = info.id;
+	}
+
+	if (CHECK(bss->veth_obj_id == 0, "get obj id for veth module",
+		  "could not get veth module id"))
+		goto cleanup;
+
+	err = veth_stats_rx__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* generate stats event, then delete; this ensures the program
+	 * triggers prior to reading status.
+	 */
+	err = system("ethtool -S " VETH_NAME " > /dev/null");
+	if (CHECK(err, "system", "ethtool -S failed: %d\n", err))
+		goto cleanup;
+
+	system("ip link delete " VETH_NAME);
+
+	/* Make sure veth_stats_rx program was triggered and it set
+	 * expected return values from bpf_trace_printk()s and all
+	 * tests ran.
+	 */
+	if (CHECK(bss->ret <= 0,
+		  "bpf_snprintf_btf: got return value",
+		  "ret <= 0 %ld test %d\n", bss->ret, bss->ran_subtests))
+		goto cleanup;
+
+	if (CHECK(bss->ran_subtests == 0, "check if subtests ran",
+		  "no subtests ran, did BPF program run?"))
+		goto cleanup;
+
+	if (CHECK(bss->num_subtests != bss->ran_subtests,
+		  "check all subtests ran",
+		  "only ran %d of %d tests\n", bss->num_subtests,
+		  bss->ran_subtests))
+		goto cleanup;
+
+cleanup:
+	system("ip link delete " VETH_NAME ">/dev/null 2>&1");
+	if (skel)
+		veth_stats_rx__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index 6a12554..d6d9838 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -119,7 +119,7 @@ struct bpf_iter__sockmap {
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
-	__u32 flags;
+	__u32 obj_id;
 };
 
 enum {
diff --git a/tools/testing/selftests/bpf/progs/btf_ptr.h b/tools/testing/selftests/bpf/progs/btf_ptr.h
index c3c9797..4f84034 100644
--- a/tools/testing/selftests/bpf/progs/btf_ptr.h
+++ b/tools/testing/selftests/bpf/progs/btf_ptr.h
@@ -16,7 +16,7 @@
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
-	__u32 flags;
+	__u32 obj_id;
 };
 
 enum {
diff --git a/tools/testing/selftests/bpf/progs/veth_stats_rx.c b/tools/testing/selftests/bpf/progs/veth_stats_rx.c
new file mode 100644
index 0000000..f04fb55
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/veth_stats_rx.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+
+#include "btf_ptr.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+#include <errno.h>
+
+long ret = 0;
+int num_subtests = 0;
+int ran_subtests = 0;
+s32 veth_stats_btf_id = 0;
+s32 veth_obj_id = 0;
+
+#define STRSIZE			2048
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
+#endif
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, char[STRSIZE]);
+} strdata SEC(".maps");
+
+SEC("kprobe/veth_stats_rx")
+int veth_stats_rx(struct pt_regs *ctx)
+{
+	static __u64 flags[] = { 0, BTF_F_COMPACT, BTF_F_ZERO, BTF_F_PTR_RAW,
+				 BTF_F_NONAME, BTF_F_COMPACT | BTF_F_ZERO |
+				 BTF_F_PTR_RAW | BTF_F_NONAME };
+	static struct btf_ptr p = { };
+	__u32 btf_ids[] = { 0, 0 };
+	__u32 obj_ids[] = { 0, 0 };
+	void *ptrs[] = { 0, 0 };
+	__u32 key = 0;
+	int i, j;
+	char *str;
+
+	btf_ids[0] = veth_stats_btf_id;
+	obj_ids[0] = veth_obj_id;
+	ptrs[0] = (void *)PT_REGS_PARM1_CORE(ctx);
+
+	btf_ids[1] = bpf_core_type_id_kernel(struct net_device);
+	ptrs[1] = (void *)PT_REGS_PARM2_CORE(ctx);
+
+	str = bpf_map_lookup_elem(&strdata, &key);
+	if (!str)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(btf_ids); i++) {
+		p.type_id = btf_ids[i];
+		p.obj_id = obj_ids[i];
+		p.ptr = ptrs[i];
+		for (j = 0; j < ARRAY_SIZE(flags); j++) {
+			++num_subtests;
+			ret = bpf_snprintf_btf(str, STRSIZE, &p, sizeof(p), 0);
+			if (ret < 0)
+				bpf_printk("returned %d when writing id %d",
+					   ret, p.type_id);
+			++ran_subtests;
+		}
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

