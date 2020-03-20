Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4539618D98A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgCTUgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:36:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10122 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727421AbgCTUgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:36:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KKNbft021812
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xb2zNQQ9s+9OAa5gQk3OMr9/2hfZTnETJ+AePiA2oeU=;
 b=EO4xqcfzoPfJAPa5hb74qsBtETfo3xQaXLHY7/7hcjuqn5FHmjBw0BNh+bUVz2VUUR+H
 Pd8BmfkBRJvTNCeJLc/UNDDQV7VwzIk9lbe/4NKxzB4I1nUDbsvy47lquqqm4VNvV630
 lEZ8/W9s4sfA20u6OIqpVEvgcfSzPZcAITQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yua0x7xn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:44 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 13:36:43 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A541E2EC2E57; Fri, 20 Mar 2020 13:36:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/6] selftests/bpf: test FD-based cgroup attachment
Date:   Fri, 20 Mar 2020 13:36:14 -0700
Message-ID: <20200320203615.1519013-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320203615.1519013-1-andriin@fb.com>
References: <20200320203615.1519013-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_07:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=869
 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015
 suspectscore=8 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200081
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests to exercise FD-based cgroup BPF program attachments and their
intermixing with legacy stateful cgroup BPF attachments. Auto-detachment and
program replacement (both unconditional and cmpxchng-like) are tested as well.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/cgroup_link.c    | 242 ++++++++++++++++++
 .../selftests/bpf/progs/test_cgroup_link.c    |  24 ++
 2 files changed, 266 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_link.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
new file mode 100644
index 000000000000..9596aa5f2c07
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_cgroup_link.skel.h"
+
+static __u32 duration = 0;
+#define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
+
+void test_cgroup_link(void)
+{
+	struct test_cgroup_link *skel;
+	struct {
+		const char *path;
+		int fd;
+	} cgs[] = {
+		{ "/cg1" },
+		{ "/cg1/cg2" },
+		{ "/cg1/cg2/cg3" },
+	};
+	int last_cg = ARRAY_SIZE(cgs) - 1, cg_nr = ARRAY_SIZE(cgs);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
+	struct bpf_link *links[ARRAY_SIZE(cgs)] = {};
+	__u32 prog_ids[5], prog_cnt = 0, attach_flags;
+	int i = 0, err, prog_fd;
+	bool detach_legacy = false;
+
+	skel = test_cgroup_link__open_and_load();
+	if (CHECK(!skel, "skel_open_load", "failed to open/load skeleton\n"))
+		return;
+	prog_fd = bpf_program__fd(skel->progs.egress);
+
+	err = setup_cgroup_environment();
+	if (CHECK(err, "cg_init", "failed: %d\n", err))
+		goto cleanup;
+
+	for (i = 0; i < cg_nr; i++) {
+		cgs[i].fd = create_and_get_cgroup(cgs[i].path);
+		if (CHECK(cgs[i].fd < 0, "cg_create", "fail: %d\n", cgs[i].fd))
+			goto cleanup;
+	}
+
+	err = join_cgroup(cgs[last_cg].path);
+	if (CHECK(err, "cg_join", "fail: %d\n", err))
+		goto cleanup;
+
+	for (i = 0; i < cg_nr; i++) {
+		links[i] = bpf_program__attach_cgroup(skel->progs.egress,
+						      cgs[i].fd);
+		if (CHECK(IS_ERR(links[i]), "cg_attach", "i: %d, err: %ld\n",
+				 i, PTR_ERR(links[i])))
+			goto cleanup;
+	}
+
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->calls != cg_nr, "call_cnt", "exp %d, got %d\n",
+		  cg_nr, skel->bss->calls))
+		goto cleanup;
+
+	/* query the number of effective progs in last cg */
+	CHECK_FAIL(bpf_prog_query(cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS,
+				  BPF_F_QUERY_EFFECTIVE, NULL, NULL,
+				  &prog_cnt));
+	if (CHECK(prog_cnt != cg_nr, "effect_cnt", "exp %d, got %d\n",
+		  cg_nr, prog_cnt))
+		goto cleanup;
+	/* query the effective prog IDs in last cg */
+	CHECK_FAIL(bpf_prog_query(cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS,
+				  BPF_F_QUERY_EFFECTIVE, &attach_flags,
+				  prog_ids, &prog_cnt));
+	if (CHECK(prog_cnt != cg_nr, "effect_cnt", "exp %d, got %d\n",
+		  cg_nr, prog_cnt))
+		goto cleanup;
+	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
+	for (i = 1; i < prog_cnt; i++)
+		CHECK(prog_ids[i - 1] != prog_ids[i], "prod_id_check",
+		      "idx %d, prev id %d, cur id %d\n",
+		      i, prog_ids[i - 1], prog_ids[i]);
+
+	/* detach bottom program and ping again */
+	bpf_link__destroy(links[last_cg]);
+	links[last_cg] = NULL;
+
+	skel->bss->calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->calls != cg_nr - 1, "call_cnt", "exp %d, got %d\n",
+		  cg_nr - 1, skel->bss->calls))
+		goto cleanup;
+
+	/* mix in with non link-based multi-attachments */
+	err = bpf_prog_attach(prog_fd, cgs[last_cg].fd,
+			      BPF_CGROUP_INET_EGRESS, BPF_F_ALLOW_MULTI);
+	if (CHECK(err, "cg_attach_legacy", "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = true;
+
+	links[last_cg] = bpf_program__attach_cgroup(skel->progs.egress,
+						    cgs[last_cg].fd);
+	if (CHECK(IS_ERR(links[last_cg]), "cg_attach", "err: %ld\n",
+		  PTR_ERR(links[last_cg])))
+		goto cleanup;
+
+	skel->bss->calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	CHECK(skel->bss->calls != cg_nr + 1, "call_cnt", "exp %d, got %d\n",
+	      cg_nr + 1, skel->bss->calls);
+
+	bpf_link__destroy(links[last_cg]);
+	links[last_cg] = NULL;
+
+	if (CHECK(bpf_prog_detach2(prog_fd, cgs[last_cg].fd,
+		  BPF_CGROUP_INET_EGRESS), "cg_detach_legacy",
+		  "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = false;
+
+	/* attempt to mix in with legacy exclusive prog attachment */
+	err = bpf_prog_attach(prog_fd, cgs[last_cg].fd,
+			      BPF_CGROUP_INET_EGRESS, 0);
+	if (CHECK(err, "cg_attach_exclusive", "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = true;
+
+	links[last_cg] = bpf_program__attach_cgroup(skel->progs.egress,
+						    cgs[last_cg].fd);
+	if (CHECK(!IS_ERR(links[last_cg]), "cg_attach_fail", "unexpected success\n"))
+		goto cleanup;
+
+	skel->bss->calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	CHECK(skel->bss->calls != cg_nr, "call_cnt", "exp %d, got %d\n",
+	      cg_nr, skel->bss->calls);
+
+	if (CHECK(bpf_prog_detach2(prog_fd, cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS),
+		  "cg_detach_exclusive", "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = false;
+
+	/* re-attach last bpf_link to finish off test */
+	links[last_cg] = bpf_program__attach_cgroup(skel->progs.egress,
+						    cgs[last_cg].fd);
+	if (CHECK(IS_ERR(links[last_cg]), "cg_attach", "err: %ld\n",
+		  PTR_ERR(links[last_cg])))
+		goto cleanup;
+
+	skel->bss->calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->calls != cg_nr, "call_cnt", "exp %d, got %d\n",
+		  cg_nr, skel->bss->calls))
+		goto cleanup;
+	if (CHECK(skel->bss->alt_calls != 0, "alt_call_cnt", "exp %d, got %d\n",
+		  0, skel->bss->alt_calls))
+		goto cleanup;
+
+	/* replace BPF programs inside their links for all but first link */
+	for (i = 1; i < cg_nr; i++) {
+		err = bpf_link__update_program(links[i], skel->progs.egress_alt);
+		if (CHECK(err, "prog_upd", "link #%d\n", i))
+			goto cleanup;
+	}
+
+	skel->bss->calls = 0;
+	skel->bss->alt_calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->calls != 1, "call_cnt",
+		  "exp %d, got %d\n", 1, skel->bss->calls))
+		goto cleanup;
+	if (CHECK(skel->bss->alt_calls != cg_nr - 1, "alt_call_cnt",
+		  "exp %d, got %d\n", cg_nr - 1, skel->bss->alt_calls))
+		goto cleanup;
+
+	/* Attempt program update with wrong expected BPF program */
+	link_upd_opts.old_prog_fd = bpf_program__fd(skel->progs.egress_alt);
+	link_upd_opts.flags = BPF_F_REPLACE;
+	err = bpf_link_update(bpf_link__fd(links[0]),
+			      bpf_program__fd(skel->progs.egress_alt),
+			      &link_upd_opts);
+	if (CHECK(err == 0 || errno != EPERM, "prog_cmpxchg1",
+		  "unexpectedly succeeded, err %d, errno %d\n", err, -errno))
+		goto cleanup;
+
+	/* Compare-exchange single link program from egress to egress_alt */
+	link_upd_opts.old_prog_fd = bpf_program__fd(skel->progs.egress);
+	link_upd_opts.flags = BPF_F_REPLACE;
+	err = bpf_link_update(bpf_link__fd(links[0]),
+			      bpf_program__fd(skel->progs.egress_alt),
+			      &link_upd_opts);
+	if (CHECK(err, "prog_cmpxchg2", "errno %d\n", -errno))
+		goto cleanup;
+
+	skel->bss->calls = 0;
+	skel->bss->alt_calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->calls != 0, "call_cnt",
+		  "exp %d, got %d\n", 0, skel->bss->calls))
+		goto cleanup;
+	if (CHECK(skel->bss->alt_calls != cg_nr, "alt_call_cnt",
+		  "exp %d, got %d\n", cg_nr, skel->bss->alt_calls))
+		goto cleanup;
+
+	/* close cgroup FDs before detaching links */
+	for (i = 0; i < cg_nr; i++) {
+		if (cgs[i].fd > 0) {
+			close(cgs[i].fd);
+			cgs[i].fd = -1;
+		}
+	}
+
+	/* BPF programs should still get called */
+	skel->bss->alt_calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->alt_calls != cg_nr, "alt_all_cnt",
+		  "exp %d, got %d\n", cg_nr, skel->bss->alt_calls))
+		goto cleanup;
+
+	/* leave cgroup and remove them, don't detach programs */
+	cleanup_cgroup_environment();
+
+	/* BPF programs should have been auto-detached */
+	skel->bss->alt_calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->alt_calls, "alt_call_cnt", "exp %d, got %d\n",
+		  cg_nr, skel->bss->alt_calls))
+		goto cleanup;
+
+cleanup:
+	if (detach_legacy)
+		bpf_prog_detach2(prog_fd, cgs[last_cg].fd,
+				 BPF_CGROUP_INET_EGRESS);
+
+	for (i = 0; i < cg_nr; i++) {
+		if (!IS_ERR(links[i]))
+			bpf_link__destroy(links[i]);
+	}
+	test_cgroup_link__destroy(skel);
+
+	for (i = 0; i < cg_nr; i++) {
+		if (cgs[i].fd > 0)
+			close(cgs[i].fd);
+	}
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_cgroup_link.c b/tools/testing/selftests/bpf/progs/test_cgroup_link.c
new file mode 100644
index 000000000000..77e47b9e4446
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_cgroup_link.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+int calls = 0;
+int alt_calls = 0;
+
+SEC("cgroup_skb/egress1")
+int egress(struct __sk_buff *skb)
+{
+	__sync_fetch_and_add(&calls, 1);
+	return 1;
+}
+
+SEC("cgroup_skb/egress2")
+int egress_alt(struct __sk_buff *skb)
+{
+	__sync_fetch_and_add(&alt_calls, 1);
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
+
-- 
2.17.1

