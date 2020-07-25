Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7583E22D2B2
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgGYAFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:05:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33600 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727951AbgGYAEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:50 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONnAoT013714
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=k5up57518CbpP2QOO6zKbZ5m59nic2rEjlF2Mue+fsI=;
 b=RiYT2yHVxBjQXDqz0txhNALuvZ5QjYsRHE+H2AdgbEyQtNG/etINw30OEGiU4YDdsrls
 ycrRAeaoDr6B5jAyyVt6ErTajOu23jhsW83c2wkVHVHS3FK1YZQk9eVqylA+pnYCksTP
 hcEhY2libntS7I7lA2qxK/VxszWWqLbD4Yc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embcegn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:49 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:48 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 583A11B35AAE; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 33/35] bpf: selftests: don't touch RLIMIT_MEMLOCK
Date:   Fri, 24 Jul 2020 17:04:08 -0700
Message-ID: <20200725000410.3566700-34-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=13
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since bpf is not using memlock rlimit for memory accounting,
there are no more reasons to bump the limit.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 tools/testing/selftests/bpf/bench.c           | 16 ---------------
 .../selftests/bpf/progs/bpf_iter_bpf_map.c    |  5 ++---
 tools/testing/selftests/bpf/xdping.c          |  6 ------
 tools/testing/selftests/net/reuseport_bpf.c   | 20 -------------------
 4 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftest=
s/bpf/bench.c
index 944ad4721c83..f66610541c8a 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -29,25 +29,9 @@ static int libbpf_print_fn(enum libbpf_print_level lev=
el,
 	return vfprintf(stderr, format, args);
 }
=20
-static int bump_memlock_rlimit(void)
-{
-	struct rlimit rlim_new =3D {
-		.rlim_cur	=3D RLIM_INFINITY,
-		.rlim_max	=3D RLIM_INFINITY,
-	};
-
-	return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-}
-
 void setup_libbpf()
 {
-	int err;
-
 	libbpf_set_print(libbpf_print_fn);
-
-	err =3D bump_memlock_rlimit();
-	if (err)
-		fprintf(stderr, "failed to increase RLIMIT_MEMLOCK: %d", err);
 }
=20
 void hits_drops_report_progress(int iter, struct bench_res *res, long de=
lta_ns)
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
index 08651b23edba..5fe76df58dd4 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
@@ -19,10 +19,9 @@ int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
 	}
=20
 	if (seq_num =3D=3D 0)
-		BPF_SEQ_PRINTF(seq, "      id   refcnt  usercnt  locked_vm\n");
+		BPF_SEQ_PRINTF(seq, "      id   refcnt  usercnt\n");
=20
 	BPF_SEQ_PRINTF(seq, "%8u %8ld %8ld %10lu\n", map->id, map->refcnt.count=
er,
-		       map->usercnt.counter,
-		       map->memory.user->locked_vm.counter);
+		       map->usercnt.counter);
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftes=
ts/bpf/xdping.c
index 842d9155d36c..488021169171 100644
--- a/tools/testing/selftests/bpf/xdping.c
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -88,7 +88,6 @@ int main(int argc, char **argv)
 {
 	__u32 mode_flags =3D XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
 	struct addrinfo *a, hints =3D { .ai_family =3D AF_INET };
-	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
 	__u16 count =3D XDPING_DEFAULT_COUNT;
 	struct pinginfo pinginfo =3D { 0 };
 	const char *optstr =3D "c:I:NsS";
@@ -166,11 +165,6 @@ int main(int argc, char **argv)
 		freeaddrinfo(a);
 	}
=20
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
=20
 	if (bpf_prog_load(filename, BPF_PROG_TYPE_XDP, &obj, &prog_fd)) {
diff --git a/tools/testing/selftests/net/reuseport_bpf.c b/tools/testing/=
selftests/net/reuseport_bpf.c
index b5277106df1f..88709898bae5 100644
--- a/tools/testing/selftests/net/reuseport_bpf.c
+++ b/tools/testing/selftests/net/reuseport_bpf.c
@@ -437,26 +437,6 @@ void enable_fastopen(void)
 	}
 }
=20
-static struct rlimit rlim_old;
-
-static  __attribute__((constructor)) void main_ctor(void)
-{
-	getrlimit(RLIMIT_MEMLOCK, &rlim_old);
-
-	if (rlim_old.rlim_cur !=3D RLIM_INFINITY) {
-		struct rlimit rlim_new;
-
-		rlim_new.rlim_cur =3D rlim_old.rlim_cur + (1UL << 20);
-		rlim_new.rlim_max =3D rlim_old.rlim_max + (1UL << 20);
-		setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-	}
-}
-
-static __attribute__((destructor)) void main_dtor(void)
-{
-	setrlimit(RLIMIT_MEMLOCK, &rlim_old);
-}
-
 int main(void)
 {
 	fprintf(stderr, "---- IPv4 UDP ----\n");
--=20
2.26.2

