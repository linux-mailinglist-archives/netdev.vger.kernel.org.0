Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF802A9FC4
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgKFWIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:08:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728520AbgKFWIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 17:08:48 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6M8m0S031932
        for <netdev@vger.kernel.org>; Fri, 6 Nov 2020 14:08:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4Pkd3lybjZrd+kVwUXNRCqAAvs8XiDzCOrlrsgPu7Ss=;
 b=hoMVSkB9ZBzHFptxeOUQVe74cnSx7QSq2dQxbZRUyAsiqPv3Mztextsid+LPnDedD3n4
 pEWU9vDfx7eN2UCR/eQI8Ow1Fzkc1Lnu/KW2LUoWsrSIxd5i+K013r3YWHVDxbipQUHe
 dSBBulaygC9Qwc7yk6iifLtjFTw1hjzozeY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34mr9bena6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 14:08:47 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 14:08:11 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id BC1B729463F7; Fri,  6 Nov 2020 14:08:09 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 3/3] bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP
Date:   Fri, 6 Nov 2020 14:08:09 -0800
Message-ID: <20201106220809.3950951-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201106220750.3949423-1-kafai@fb.com>
References: <20201106220750.3949423-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=809
 suspectscore=43 mlxscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060152
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tests storing the task's related info into the
bpf_sk_storage by fentry/fexit tracing at listen, accept,
and connect.  It also tests the raw_tp at inet_sock_set_state.

A negative test is done by tracing the bpf_sk_storage_free()
and using bpf_sk_storage_get() at the same time.  It ensures
this bpf program cannot load.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../bpf/prog_tests/sk_storage_tracing.c       | 135 ++++++++++++++++++
 .../bpf/progs/test_sk_storage_trace_itself.c  |  29 ++++
 .../bpf/progs/test_sk_storage_tracing.c       |  95 ++++++++++++
 3 files changed, 259 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_storage_tra=
cing.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tra=
ce_itself.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tra=
cing.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c =
b/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
new file mode 100644
index 000000000000..2b392590e8ca
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <sys/types.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "test_sk_storage_trace_itself.skel.h"
+#include "test_sk_storage_tracing.skel.h"
+
+#define LO_ADDR6 "::1"
+#define TEST_COMM "test_progs"
+
+struct sk_stg {
+	__u32 pid;
+	__u32 last_notclose_state;
+	char comm[16];
+};
+
+static struct test_sk_storage_tracing *skel;
+static __u32 duration;
+static pid_t my_pid;
+
+static int check_sk_stg(int sk_fd, __u32 expected_state)
+{
+	struct sk_stg sk_stg;
+	int err;
+
+	err =3D bpf_map_lookup_elem(bpf_map__fd(skel->maps.sk_stg_map), &sk_fd,
+				  &sk_stg);
+	if (!ASSERT_OK(err, "map_lookup(sk_stg_map)"))
+		return -1;
+
+	if (!ASSERT_EQ(sk_stg.last_notclose_state, expected_state,
+		       "last_notclose_state"))
+		return -1;
+
+	if (!ASSERT_EQ(sk_stg.pid, my_pid, "pid"))
+		return -1;
+
+	if (!ASSERT_STREQ(sk_stg.comm, skel->bss->task_comm, "task_comm"))
+		return -1;
+
+	return 0;
+}
+
+static void do_test(void)
+{
+	int listen_fd =3D -1, passive_fd =3D -1, active_fd =3D -1, value =3D 1,=
 err;
+	char abyte;
+
+	listen_fd =3D start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
+	if (CHECK(listen_fd =3D=3D -1, "start_server",
+		  "listen_fd:%d errno:%d\n", listen_fd, errno))
+		return;
+
+	active_fd =3D connect_to_fd(listen_fd, 0);
+	if (CHECK(active_fd =3D=3D -1, "connect_to_fd", "active_fd:%d errno:%d\=
n",
+		  active_fd, errno))
+		goto out;
+
+	err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.del_sk_stg_map),
+				  &active_fd, &value, 0);
+	if (!ASSERT_OK(err, "map_update(del_sk_stg_map)"))
+		goto out;
+
+	passive_fd =3D accept(listen_fd, NULL, 0);
+	if (CHECK(passive_fd =3D=3D -1, "accept", "passive_fd:%d errno:%d\n",
+		  passive_fd, errno))
+		goto out;
+
+	shutdown(active_fd, SHUT_WR);
+	err =3D read(passive_fd, &abyte, 1);
+	if (!ASSERT_OK(err, "read(passive_fd)"))
+		goto out;
+
+	shutdown(passive_fd, SHUT_WR);
+	err =3D read(active_fd, &abyte, 1);
+	if (!ASSERT_OK(err, "read(active_fd)"))
+		goto out;
+
+	err =3D bpf_map_lookup_elem(bpf_map__fd(skel->maps.del_sk_stg_map),
+				  &active_fd, &value);
+	if (!ASSERT_ERR(err, "map_lookup(del_sk_stg_map)"))
+		goto out;
+
+	err =3D check_sk_stg(listen_fd, BPF_TCP_LISTEN);
+	if (!ASSERT_OK(err, "listen_fd sk_stg"))
+		goto out;
+
+	err =3D check_sk_stg(active_fd, BPF_TCP_FIN_WAIT2);
+	if (!ASSERT_OK(err, "active_fd sk_stg"))
+		goto out;
+
+	err =3D check_sk_stg(passive_fd, BPF_TCP_LAST_ACK);
+	ASSERT_OK(err, "passive_fd sk_stg");
+
+out:
+	if (active_fd !=3D -1)
+		close(active_fd);
+	if (passive_fd !=3D -1)
+		close(passive_fd);
+	if (listen_fd !=3D -1)
+		close(listen_fd);
+}
+
+void test_sk_storage_tracing(void)
+{
+	struct test_sk_storage_trace_itself *skel_itself;
+	int err;
+
+	my_pid =3D getpid();
+
+	skel_itself =3D test_sk_storage_trace_itself__open_and_load();
+
+	if (!ASSERT_NULL(skel_itself, "test_sk_storage_trace_itself")) {
+		test_sk_storage_trace_itself__destroy(skel_itself);
+		return;
+	}
+
+	skel =3D test_sk_storage_tracing__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_sk_storage_tracing"))
+		return;
+
+	err =3D test_sk_storage_tracing__attach(skel);
+	if (!ASSERT_OK(err, "test_sk_storage_tracing__attach")) {
+		test_sk_storage_tracing__destroy(skel);
+		return;
+	}
+
+	do_test();
+
+	test_sk_storage_tracing__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_sk_storage_trace_itse=
lf.c b/tools/testing/selftests/bpf/progs/test_sk_storage_trace_itself.c
new file mode 100644
index 000000000000..59ef72d02a61
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_storage_trace_itself.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} sk_stg_map SEC(".maps");
+
+SEC("fentry/bpf_sk_storage_free")
+int BPF_PROG(trace_bpf_sk_storage_free, struct sock *sk)
+{
+	int *value;
+
+	value =3D bpf_sk_storage_get(&sk_stg_map, sk, 0,
+				   BPF_SK_STORAGE_GET_F_CREATE);
+
+	if (value)
+		*value =3D 1;
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c =
b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
new file mode 100644
index 000000000000..8e94e5c080aa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+struct sk_stg {
+	__u32 pid;
+	__u32 last_notclose_state;
+	char comm[16];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct sk_stg);
+} sk_stg_map SEC(".maps");
+
+/* Testing delete */
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} del_sk_stg_map SEC(".maps");
+
+char task_comm[16] =3D "";
+
+SEC("tp_btf/inet_sock_set_state")
+int BPF_PROG(trace_inet_sock_set_state, struct sock *sk, int oldstate,
+	     int newstate)
+{
+	struct sk_stg *stg;
+
+	if (newstate =3D=3D BPF_TCP_CLOSE)
+		return 0;
+
+	stg =3D bpf_sk_storage_get(&sk_stg_map, sk, 0,
+				 BPF_SK_STORAGE_GET_F_CREATE);
+	if (!stg)
+		return 0;
+
+	stg->last_notclose_state =3D newstate;
+
+	bpf_sk_storage_delete(&del_sk_stg_map, sk);
+
+	return 0;
+}
+
+static void set_task_info(struct sock *sk)
+{
+	struct task_struct *task;
+	struct sk_stg *stg;
+
+	stg =3D bpf_sk_storage_get(&sk_stg_map, sk, 0,
+				 BPF_SK_STORAGE_GET_F_CREATE);
+	if (!stg)
+		return;
+
+	stg->pid =3D bpf_get_current_pid_tgid();
+
+	task =3D (struct task_struct *)bpf_get_current_task();
+	bpf_core_read_str(&stg->comm, sizeof(stg->comm), &task->comm);
+	bpf_core_read_str(&task_comm, sizeof(task_comm), &task->comm);
+}
+
+SEC("fentry/inet_csk_listen_start")
+int BPF_PROG(trace_inet_csk_listen_start, struct sock *sk, int backlog)
+{
+	set_task_info(sk);
+
+	return 0;
+}
+
+SEC("fentry/tcp_connect")
+int BPF_PROG(trace_tcp_connect, struct sock *sk)
+{
+	set_task_info(sk);
+
+	return 0;
+}
+
+SEC("fexit/inet_csk_accept")
+int BPF_PROG(inet_csk_accept, struct sock *sk, int flags, int *err, bool=
 kern,
+	     struct sock *accepted_sk)
+{
+	set_task_info(accepted_sk);
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

