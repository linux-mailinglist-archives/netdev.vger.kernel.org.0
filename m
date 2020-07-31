Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37841234C7F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgGaUui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:50:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15760 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727964AbgGaUuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 16:50:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VKnWvN019676
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:50:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=1kA/f5+h7cCPaASqCb4FTNJhl1XdpmguYU7sgmGcbpU=;
 b=T4p8KH/f98OpcX4MHpdST8dIZ/GIm05+1c1BI6HW+F3q7u4bDXyQynQQsRVc5JznZV9S
 1KVaJHYQdQ0g33o24U1FLblPFzPyfHLNQYaeKFYDDe5ivFrGnZMiSm+AihIKduN9dznU
 eG5pkpJIWrH2fjdzDiZQwJov69Wn6bwXmz4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32k7hwdhkd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:50:36 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 13:50:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7992C2EC4E9D; Fri, 31 Jul 2020 13:50:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: fix spurious test failures in core_retro selftest
Date:   Fri, 31 Jul 2020 13:49:57 -0700
Message-ID: <20200731204957.2047119-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_09:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 priorityscore=1501 mlxlogscore=902 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

core_retro selftest uses BPF program that's triggered on sys_enter
system-wide, but has no protection from some unrelated process doing sysc=
all
while selftest is running. This leads to occasional test failures with
unexpected PIDs being returned. Fix that by filtering out all processes t=
hat
are not test_progs process.

Fixes: fcda189a5133 ("selftests/bpf: Add test relying only on CO-RE and n=
o recent kernel features")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/core_retro.c |  8 ++++++--
 tools/testing/selftests/bpf/progs/test_core_retro.c | 13 +++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_retro.c b/tools/=
testing/selftests/bpf/prog_tests/core_retro.c
index 78e30d3a23d5..6acb0e94d4d7 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_retro.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_retro.c
@@ -6,7 +6,7 @@
=20
 void test_core_retro(void)
 {
-	int err, zero =3D 0, res, duration =3D 0;
+	int err, zero =3D 0, res, duration =3D 0, my_pid =3D getpid();
 	struct test_core_retro *skel;
=20
 	/* load program */
@@ -14,6 +14,10 @@ void test_core_retro(void)
 	if (CHECK(!skel, "skel_load", "skeleton open/load failed\n"))
 		goto out_close;
=20
+	err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.exp_tgid_map), &zero=
, &my_pid, 0);
+	if (CHECK(err, "map_update", "failed to set expected PID: %d\n", errno)=
)
+		goto out_close;
+
 	/* attach probe */
 	err =3D test_core_retro__attach(skel);
 	if (CHECK(err, "attach_kprobe", "err %d\n", err))
@@ -26,7 +30,7 @@ void test_core_retro(void)
 	if (CHECK(err, "map_lookup", "failed to lookup result: %d\n", errno))
 		goto out_close;
=20
-	CHECK(res !=3D getpid(), "pid_check", "got %d !=3D exp %d\n", res, getp=
id());
+	CHECK(res !=3D my_pid, "pid_check", "got %d !=3D exp %d\n", res, my_pid=
);
=20
 out_close:
 	test_core_retro__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_core_retro.c b/tools/=
testing/selftests/bpf/progs/test_core_retro.c
index 75c60c3c29cf..20861ec2f674 100644
--- a/tools/testing/selftests/bpf/progs/test_core_retro.c
+++ b/tools/testing/selftests/bpf/progs/test_core_retro.c
@@ -8,6 +8,13 @@ struct task_struct {
 	int tgid;
 } __attribute__((preserve_access_index));
=20
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, int);
+} exp_tgid_map SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, 1);
@@ -21,6 +28,12 @@ int handle_sys_enter(void *ctx)
 	struct task_struct *task =3D (void *)bpf_get_current_task();
 	int tgid =3D BPF_CORE_READ(task, tgid);
 	int zero =3D 0;
+	int real_tgid =3D bpf_get_current_pid_tgid() >> 32;
+	int *exp_tgid =3D bpf_map_lookup_elem(&exp_tgid_map, &zero);
+
+	/* only pass through sys_enters from test process */
+	if (!exp_tgid || *exp_tgid !=3D real_tgid)
+		return 0;
=20
 	bpf_map_update_elem(&results, &zero, &tgid, 0);
=20
--=20
2.24.1

