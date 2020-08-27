Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22918253ADD
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgH0AGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:06:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39988 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgH0AGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:06:31 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R051Cg000821
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dste37kOoRMfRa0kpK6WbpiioQNAoXy9XpJkYx45WO4=;
 b=e0tfi6EIkmu6m8Lu23OD3FuZ6P0Y0m2urc2GhNLHNm6LBRyEsUVXUPhELQcGRW4NPH6a
 KxJ5E5CItjdhT9dwfUXu1av7KEMWOyVafrno4VS7zuhuOAxsbjcngj2An+oQfnvzlov+
 svg+OsK+QNzPNFhaw13GoYH9nulXuehKOuk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up629pe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:31 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 17:06:29 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4498E37052E0; Wed, 26 Aug 2020 17:06:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/5] selftests/bpf: test task_file iterator with main_thread_only
Date:   Wed, 26 Aug 2020 17:06:24 -0700
Message-ID: <20200827000624.2712244-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200827000618.2711826-1-yhs@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 spamscore=0
 clxscore=1015 impostorscore=0 suspectscore=8 phishscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008260187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modified existing bpf_iter_test_file program to check
whether all accessed files from the main thread or not.
  $ ./test_progs -n 4
  ...
  #4/7 task_file:OK
  ...
  #4 bpf_iter:OK
  Summary: 1/24 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 50 ++++++++++++++-----
 .../selftests/bpf/progs/bpf_iter_task_file.c  |  9 +++-
 2 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 7375d9a6d242..235580801372 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -37,13 +37,14 @@ static void test_btf_id_or_null(void)
 	}
 }
=20
-static void do_dummy_read(struct bpf_program *prog)
+static void do_dummy_read(struct bpf_program *prog,
+			  struct bpf_iter_attach_opts *opts)
 {
 	struct bpf_link *link;
 	char buf[16] =3D {};
 	int iter_fd, len;
=20
-	link =3D bpf_program__attach_iter(prog, NULL);
+	link =3D bpf_program__attach_iter(prog, opts);
 	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
 		return;
=20
@@ -71,7 +72,7 @@ static void test_ipv6_route(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_ipv6_route);
+	do_dummy_read(skel->progs.dump_ipv6_route, NULL);
=20
 	bpf_iter_ipv6_route__destroy(skel);
 }
@@ -85,7 +86,7 @@ static void test_netlink(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_netlink);
+	do_dummy_read(skel->progs.dump_netlink, NULL);
=20
 	bpf_iter_netlink__destroy(skel);
 }
@@ -99,7 +100,7 @@ static void test_bpf_map(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_bpf_map);
+	do_dummy_read(skel->progs.dump_bpf_map, NULL);
=20
 	bpf_iter_bpf_map__destroy(skel);
 }
@@ -113,7 +114,7 @@ static void test_task(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_task);
+	do_dummy_read(skel->progs.dump_task, NULL);
=20
 	bpf_iter_task__destroy(skel);
 }
@@ -127,22 +128,47 @@ static void test_task_stack(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_task_stack);
+	do_dummy_read(skel->progs.dump_task_stack, NULL);
=20
 	bpf_iter_task_stack__destroy(skel);
 }
=20
+static void *do_nothing(void *arg)
+{
+	pthread_exit(arg);
+}
+
 static void test_task_file(void)
 {
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	struct bpf_iter_task_file *skel;
+	union bpf_iter_link_info linfo;
+	pthread_t thread_id;
+	void *ret;
=20
 	skel =3D bpf_iter_task_file__open_and_load();
 	if (CHECK(!skel, "bpf_iter_task_file__open_and_load",
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_task_file);
+	if (CHECK(pthread_create(&thread_id, NULL, &do_nothing, NULL),
+		  "pthread_create", "pthread_create failed\n"))
+		goto done;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.task.main_thread_only =3D true;
+	opts.link_info =3D &linfo;
+	opts.link_info_len =3D sizeof(linfo);
+	do_dummy_read(skel->progs.dump_task_file, &opts);
+
+	if (CHECK(pthread_join(thread_id, &ret) || ret !=3D NULL,
+		  "pthread_join", "pthread_join failed\n"))
+		goto done;
+
+	CHECK(skel->bss->count !=3D 0, "",
+	      "invalid non main-thread file visit %d\n", skel->bss->count);
=20
+done:
 	bpf_iter_task_file__destroy(skel);
 }
=20
@@ -155,7 +181,7 @@ static void test_tcp4(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_tcp4);
+	do_dummy_read(skel->progs.dump_tcp4, NULL);
=20
 	bpf_iter_tcp4__destroy(skel);
 }
@@ -169,7 +195,7 @@ static void test_tcp6(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_tcp6);
+	do_dummy_read(skel->progs.dump_tcp6, NULL);
=20
 	bpf_iter_tcp6__destroy(skel);
 }
@@ -183,7 +209,7 @@ static void test_udp4(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_udp4);
+	do_dummy_read(skel->progs.dump_udp4, NULL);
=20
 	bpf_iter_udp4__destroy(skel);
 }
@@ -197,7 +223,7 @@ static void test_udp6(void)
 		  "skeleton open_and_load failed\n"))
 		return;
=20
-	do_dummy_read(skel->progs.dump_udp6);
+	do_dummy_read(skel->progs.dump_udp6, NULL);
=20
 	bpf_iter_udp6__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c b/too=
ls/testing/selftests/bpf/progs/bpf_iter_task_file.c
index 8b787baa2654..880f6c9db8fb 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
@@ -6,6 +6,8 @@
=20
 char _license[] SEC("license") =3D "GPL";
=20
+int count =3D 0;
+
 SEC("iter/task_file")
 int dump_task_file(struct bpf_iter__task_file *ctx)
 {
@@ -17,8 +19,13 @@ int dump_task_file(struct bpf_iter__task_file *ctx)
 	if (task =3D=3D (void *)0 || file =3D=3D (void *)0)
 		return 0;
=20
-	if (ctx->meta->seq_num =3D=3D 0)
+	if (ctx->meta->seq_num =3D=3D 0) {
+		count =3D 0; /* reset the counter for this seq_file session */
 		BPF_SEQ_PRINTF(seq, "    tgid      gid       fd      file\n");
+	}
+
+	if (task->tgid !=3D task->pid)
+		count++;
=20
 	BPF_SEQ_PRINTF(seq, "%8d %8d %8d %lx\n", task->tgid, task->pid, fd,
 		       (long)file->f_op);
--=20
2.24.1

