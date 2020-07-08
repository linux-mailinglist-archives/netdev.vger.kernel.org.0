Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3A6217CCE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgGHBxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:53:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728676AbgGHBxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:53:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0681rHGu020311
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:53:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TLNWPIme91e7Mqap1ihPz7mzVlHyaRyN80wpfKjAb5M=;
 b=mKFntW/ofAKw5lIrMUOgsODqQhYR5fgg0mlUjxfZExmYo8q7CW3nCcXs+SZDO5kYeytB
 gxpDqn43yRk2cXj42YKPj8tKDm9cKpEma1q5wQas4QcnRnNdyROcx5yxlw5cfn+FhXc4
 IQT2pw4mVgIy4T/CvLtdrMuPGdWmOEvVyZ0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 322nekqqqd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:53:37 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:35 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8D1A12EC39F5; Tue,  7 Jul 2020 18:53:33 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/6] selftests/bpf: switch perf_buffer test to tracepoint and skeleton
Date:   Tue, 7 Jul 2020 18:53:18 -0700
Message-ID: <20200708015318.3827358-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 cotscore=-2147483648
 malwarescore=0 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch perf_buffer test to use skeleton to avoid use of bpf_prog_load() a=
nd
make test a bit more succinct. Also switch BPF program to use tracepoint
instead of kprobe, as that allows to support older kernels, which had
tracepoint support before kprobe support in the form that libbpf expects
(i.e., libbpf expects /sys/bus/event_source/devices/kprobe/type, which do=
esn't
always exist on old kernels).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/perf_buffer.c    | 42 ++++++-------------
 .../selftests/bpf/progs/test_perf_buffer.c    |  4 +-
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools=
/testing/selftests/bpf/prog_tests/perf_buffer.c
index a122ce3b360e..c33ec180b3f2 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -4,6 +4,7 @@
 #include <sched.h>
 #include <sys/socket.h>
 #include <test_progs.h>
+#include "test_perf_buffer.skel.h"
 #include "bpf/libbpf_internal.h"
=20
 /* AddressSanitizer sometimes crashes due to data dereference below, due=
 to
@@ -25,16 +26,11 @@ static void on_sample(void *ctx, int cpu, void *data,=
 __u32 size)
=20
 void test_perf_buffer(void)
 {
-	int err, prog_fd, on_len, nr_on_cpus =3D 0,  nr_cpus, i, duration =3D 0=
;
-	const char *prog_name =3D "kprobe/sys_nanosleep";
-	const char *file =3D "./test_perf_buffer.o";
+	int err, on_len, nr_on_cpus =3D 0,  nr_cpus, i, duration =3D 0;
 	struct perf_buffer_opts pb_opts =3D {};
-	struct bpf_map *perf_buf_map;
+	struct test_perf_buffer *skel;
 	cpu_set_t cpu_set, cpu_seen;
-	struct bpf_program *prog;
-	struct bpf_object *obj;
 	struct perf_buffer *pb;
-	struct bpf_link *link;
 	bool *online;
=20
 	nr_cpus =3D libbpf_num_possible_cpus();
@@ -51,33 +47,21 @@ void test_perf_buffer(void)
 			nr_on_cpus++;
=20
 	/* load program */
-	err =3D bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
-	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno)) {
-		obj =3D NULL;
-		goto out_close;
-	}
-
-	prog =3D bpf_object__find_program_by_title(obj, prog_name);
-	if (CHECK(!prog, "find_probe", "prog '%s' not found\n", prog_name))
+	skel =3D test_perf_buffer__open_and_load();
+	if (CHECK(!skel, "skel_load", "skeleton open/load failed\n"))
 		goto out_close;
=20
-	/* load map */
-	perf_buf_map =3D bpf_object__find_map_by_name(obj, "perf_buf_map");
-	if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
-		goto out_close;
-
-	/* attach kprobe */
-	link =3D bpf_program__attach_kprobe(prog, false /* retprobe */,
-					  SYS_NANOSLEEP_KPROBE_NAME);
-	if (CHECK(IS_ERR(link), "attach_kprobe", "err %ld\n", PTR_ERR(link)))
+	/* attach probe */
+	err =3D test_perf_buffer__attach(skel);
+	if (CHECK(err, "attach_kprobe", "err %d\n", err))
 		goto out_close;
=20
 	/* set up perf buffer */
 	pb_opts.sample_cb =3D on_sample;
 	pb_opts.ctx =3D &cpu_seen;
-	pb =3D perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
+	pb =3D perf_buffer__new(bpf_map__fd(skel->maps.perf_buf_map), 1, &pb_op=
ts);
 	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
-		goto out_detach;
+		goto out_close;
=20
 	/* trigger kprobe on every CPU */
 	CPU_ZERO(&cpu_seen);
@@ -94,7 +78,7 @@ void test_perf_buffer(void)
 					     &cpu_set);
 		if (err && CHECK(err, "set_affinity", "cpu #%d, err %d\n",
 				 i, err))
-			goto out_detach;
+			goto out_close;
=20
 		usleep(1);
 	}
@@ -110,9 +94,7 @@ void test_perf_buffer(void)
=20
 out_free_pb:
 	perf_buffer__free(pb);
-out_detach:
-	bpf_link__destroy(link);
 out_close:
-	bpf_object__close(obj);
+	test_perf_buffer__destroy(skel);
 	free(online);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools=
/testing/selftests/bpf/progs/test_perf_buffer.c
index ad59c4c9aba8..8207a2dc2f9d 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_buffer.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
@@ -12,8 +12,8 @@ struct {
 	__uint(value_size, sizeof(int));
 } perf_buf_map SEC(".maps");
=20
-SEC("kprobe/sys_nanosleep")
-int BPF_KPROBE(handle_sys_nanosleep_entry)
+SEC("tp/raw_syscalls/sys_enter")
+int handle_sys_enter(void *ctx)
 {
 	int cpu =3D bpf_get_smp_processor_id();
=20
--=20
2.24.1

