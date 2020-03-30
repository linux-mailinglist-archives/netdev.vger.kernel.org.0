Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAE51972B9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 05:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgC3DAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 23:00:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11126 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729062AbgC3DAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 23:00:32 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U30UIV017815
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5iTq5IScFnRyRJGb3Rb6zMgKbF04ryz5uhGGr00u074=;
 b=fVrv8Wmgtd+k1g+3XdivPv7G8ZRDF038DUmbBMn5OuIkuOkV4kapCY1lD6qnq9H412Uu
 wp9IKz05YsOLa8h3VBoyo2XrWY78JceVZ4ip+VRhO1Ih8u3Qb0SJRTsAyVyKoSkBLfzG
 msNtF2XShquT/d8MQkpdKLDGKcPdFVWBQ1Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3031m8hsxv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:31 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 29 Mar 2020 20:00:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A449B2EC3214; Sun, 29 Mar 2020 20:00:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 4/4] selftests/bpf: test FD-based cgroup attachment
Date:   Sun, 29 Mar 2020 20:00:01 -0700
Message-ID: <20200330030001.2312810-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330030001.2312810-1-andriin@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_10:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=8 spamscore=0 adultscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=904 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests to exercise FD-based cgroup BPF program attachments and their
intermixing with legacy cgroup BPF attachments. Auto-detachment and program
replacement (both unconditional and cmpxchng-like) are tested as well.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/cgroup_link.c    | 244 ++++++++++++++++++
 .../selftests/bpf/progs/test_cgroup_link.c    |  24 ++
 2 files changed, 268 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_link.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
new file mode 100644
index 000000000000..6e04f8d1d15b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_cgroup_link.skel.h"
+
+static __u32 duration = 0;
+#define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
+
+static struct test_cgroup_link *skel = NULL;
+
+int ping_and_check(int exp_calls, int exp_alt_calls)
+{
+	skel->bss->calls = 0;
+	skel->bss->alt_calls = 0;
+	CHECK_FAIL(system(PING_CMD));
+	if (CHECK(skel->bss->calls != exp_calls, "call_cnt",
+		  "exp %d, got %d\n", exp_calls, skel->bss->calls))
+		return -EINVAL;
+	if (CHECK(skel->bss->alt_calls != exp_alt_calls, "alt_call_cnt",
+		  "exp %d, got %d\n", exp_alt_calls, skel->bss->alt_calls))
+		return -EINVAL;
+	return 0;
+}
+
+void test_cgroup_link(void)
+{
+	struct {
+		const char *path;
+		int fd;
+	} cgs[] = {
+		{ "/cg1" },
+		{ "/cg1/cg2" },
+		{ "/cg1/cg2/cg3" },
+		{ "/cg1/cg2/cg3/cg4" },
+	};
+	int last_cg = ARRAY_SIZE(cgs) - 1, cg_nr = ARRAY_SIZE(cgs);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
+	struct bpf_link *links[ARRAY_SIZE(cgs)] = {}, *tmp_link;
+	__u32 prog_ids[ARRAY_SIZE(cgs)], prog_cnt = 0, attach_flags;
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
+	ping_and_check(cg_nr, 0);
+
+	/* query the number of effective progs and attach flags in root cg */
+	err = bpf_prog_query(cgs[0].fd, BPF_CGROUP_INET_EGRESS,
+			     BPF_F_QUERY_EFFECTIVE, &attach_flags, NULL,
+			     &prog_cnt);
+	CHECK_FAIL(err);
+	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
+	if (CHECK(prog_cnt != 1, "effect_cnt", "exp %d, got %d\n", 1, prog_cnt))
+		goto cleanup;
+
+	/* query the number of effective progs in last cg */
+	err = bpf_prog_query(cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS,
+			     BPF_F_QUERY_EFFECTIVE, NULL, NULL,
+			     &prog_cnt);
+	CHECK_FAIL(err);
+	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
+	if (CHECK(prog_cnt != cg_nr, "effect_cnt", "exp %d, got %d\n",
+		  cg_nr, prog_cnt))
+		goto cleanup;
+
+	/* query the effective prog IDs in last cg */
+	err = bpf_prog_query(cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS,
+			     BPF_F_QUERY_EFFECTIVE, &attach_flags,
+			     prog_ids, &prog_cnt);
+	CHECK_FAIL(err);
+	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
+	if (CHECK(prog_cnt != cg_nr, "effect_cnt", "exp %d, got %d\n",
+		  cg_nr, prog_cnt))
+		goto cleanup;
+	for (i = 1; i < prog_cnt; i++) {
+		CHECK(prog_ids[i - 1] != prog_ids[i], "prog_id_check",
+		      "idx %d, prev id %d, cur id %d\n",
+		      i, prog_ids[i - 1], prog_ids[i]);
+	}
+
+	/* detach bottom program and ping again */
+	bpf_link__destroy(links[last_cg]);
+	links[last_cg] = NULL;
+
+	ping_and_check(cg_nr - 1, 0);
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
+	ping_and_check(cg_nr + 1, 0);
+
+	/* detach link */
+	bpf_link__destroy(links[last_cg]);
+	links[last_cg] = NULL;
+
+	/* detach legacy */
+	err = bpf_prog_detach2(prog_fd, cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS);
+	if (CHECK(err, "cg_detach_legacy", "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = false;
+
+	/* attach legacy exclusive prog attachment */
+	err = bpf_prog_attach(prog_fd, cgs[last_cg].fd,
+			      BPF_CGROUP_INET_EGRESS, 0);
+	if (CHECK(err, "cg_attach_exclusive", "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = true;
+
+	/* attempt to mix in with multi-attach bpf_link */
+	tmp_link = bpf_program__attach_cgroup(skel->progs.egress,
+					      cgs[last_cg].fd);
+	if (CHECK(!IS_ERR(tmp_link), "cg_attach_fail", "unexpected success!\n")) {
+		bpf_link__destroy(tmp_link);
+		goto cleanup;
+	}
+
+	ping_and_check(cg_nr, 0);
+
+	/* detach */
+	err = bpf_prog_detach2(prog_fd, cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS);
+	if (CHECK(err, "cg_detach_legacy", "errno=%d\n", errno))
+		goto cleanup;
+	detach_legacy = false;
+
+	ping_and_check(cg_nr - 1, 0);
+
+	/* attach back link-based one */
+	links[last_cg] = bpf_program__attach_cgroup(skel->progs.egress,
+						    cgs[last_cg].fd);
+	if (CHECK(IS_ERR(links[last_cg]), "cg_attach", "err: %ld\n",
+		  PTR_ERR(links[last_cg])))
+		goto cleanup;
+
+	ping_and_check(cg_nr, 0);
+
+	/* check legacy exclusive prog can't be attached */
+	err = bpf_prog_attach(prog_fd, cgs[last_cg].fd,
+			      BPF_CGROUP_INET_EGRESS, 0);
+	if (CHECK(!err, "cg_attach_exclusive", "unexpected success")) {
+		bpf_prog_detach2(prog_fd, cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS);
+		goto cleanup;
+	}
+
+	/* replace BPF programs inside their links for all but first link */
+	for (i = 1; i < cg_nr; i++) {
+		err = bpf_link__update_program(links[i], skel->progs.egress_alt);
+		if (CHECK(err, "prog_upd", "link #%d\n", i))
+			goto cleanup;
+	}
+
+	ping_and_check(1, cg_nr - 1);
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
+	/* ping */
+	ping_and_check(0, cg_nr);
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
+	ping_and_check(0, cg_nr);
+
+	/* leave cgroup and remove them, don't detach programs */
+	cleanup_cgroup_environment();
+
+	/* BPF programs should have been auto-detached */
+	ping_and_check(0, 0);
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

