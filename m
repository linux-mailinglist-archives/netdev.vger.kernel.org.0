Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872E4277CA3
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgIYAEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726889AbgIYAEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08ONx61U013593
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1PmNQuc7tfks/kXQadrEfWm30HCxLS/Tz+EMcNtrV8w=;
 b=noU1BVld+4sabVaRKahoKgmCm/aekyQ+cBw7iHUlMPMOz3wTYosT63OLaVjabxIkYaf4
 D+47aepMhvdxp+uW3et/3x1g0m+Fp9pTnHzxiaHklOiDxggNg1m39HWLQhozjICQtPu7
 OTU0CfG/2wW/EM02S30pLe9LZ48dp020Ni0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33qsp54u82-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:39 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:35 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1374F2946606; Thu, 24 Sep 2020 17:04:34 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 09/13] bpf: selftest: Adapt sock_fields test to use skel and global variables
Date:   Thu, 24 Sep 2020 17:04:34 -0700
Message-ID: <20200925000434.3858204-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=15
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skel is used.

Global variables are used to store the result from bpf prog.
addr_map, sock_result_map, and tcp_sock_result_map are gone.
Instead, global variables listen_tp, srv_sa6, cli_tp,, srv_tp,
listen_sk, srv_sk, and cli_sk are added.
Because of that, bpf_addr_array_idx and bpf_result_array_idx are also
no longer needed.

CHECK() macro from test_progs.h is reused and bail as soon as
a CHECK failure.

shutdown() is used to ensure the previous data-ack is received.
The bytes_acked, bytes_received, and the pkt_out_cnt checks are
using "<" to accommodate the final ack may not have been received/sent.
It is enough since it is not the focus of this test.

The sk local storage is all initialized to 0xeB9F now, so the
check_sk_pkt_out_cnt() always checks with the 0xeB9F base.  It is to
keep things simple.

The next patch will reuse helpers from network_helpers.h to simplify
things further.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/sock_fields.c    | 380 ++++++++----------
 .../selftests/bpf/progs/test_sock_fields.c    | 154 +++----
 2 files changed, 229 insertions(+), 305 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools=
/testing/selftests/bpf/prog_tests/sock_fields.c
index 1138223780fc..d96b718639fb 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -14,20 +14,9 @@
 #include <bpf/libbpf.h>
=20
 #include "cgroup_helpers.h"
+#include "test_progs.h"
 #include "bpf_rlimit.h"
-
-enum bpf_addr_array_idx {
-	ADDR_SRV_IDX,
-	ADDR_CLI_IDX,
-	__NR_BPF_ADDR_ARRAY_IDX,
-};
-
-enum bpf_result_array_idx {
-	EGRESS_SRV_IDX,
-	EGRESS_CLI_IDX,
-	INGRESS_LISTEN_IDX,
-	__NR_BPF_RESULT_ARRAY_IDX,
-};
+#include "test_sock_fields.skel.h"
=20
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
@@ -40,34 +29,16 @@ struct bpf_spinlock_cnt {
 	__u32 cnt;
 };
=20
-#define CHECK(condition, tag, format...) ({				\
-	int __ret =3D !!(condition);					\
-	if (__ret) {							\
-		printf("%s(%d):FAIL:%s ", __func__, __LINE__, tag);	\
-		printf(format);						\
-		printf("\n");						\
-		exit(-1);						\
-	}								\
-})
-
 #define TEST_CGROUP "/test-bpf-sock-fields"
 #define DATA "Hello BPF!"
 #define DATA_LEN sizeof(DATA)
=20
 static struct sockaddr_in6 srv_sa6, cli_sa6;
 static int sk_pkt_out_cnt10_fd;
+struct test_sock_fields *skel;
 static int sk_pkt_out_cnt_fd;
 static int linum_map_fd;
-static int addr_map_fd;
-static int tp_map_fd;
-static int sk_map_fd;
-
-static __u32 addr_srv_idx =3D ADDR_SRV_IDX;
-static __u32 addr_cli_idx =3D ADDR_CLI_IDX;
-
-static __u32 egress_srv_idx =3D EGRESS_SRV_IDX;
-static __u32 egress_cli_idx =3D EGRESS_CLI_IDX;
-static __u32 ingress_listen_idx =3D INGRESS_LISTEN_IDX;
+static __u32 duration;
=20
 static __u32 egress_linum_idx =3D EGRESS_LINUM_IDX;
 static __u32 ingress_linum_idx =3D INGRESS_LINUM_IDX;
@@ -79,7 +50,7 @@ static void init_loopback6(struct sockaddr_in6 *sa6)
 	sa6->sin6_addr =3D in6addr_loopback;
 }
=20
-static void print_sk(const struct bpf_sock *sk)
+static void print_sk(const struct bpf_sock *sk, const char *prefix)
 {
 	char src_ip4[24], dst_ip4[24];
 	char src_ip6[64], dst_ip6[64];
@@ -89,9 +60,10 @@ static void print_sk(const struct bpf_sock *sk)
 	inet_ntop(AF_INET, &sk->dst_ip4, dst_ip4, sizeof(dst_ip4));
 	inet_ntop(AF_INET6, &sk->dst_ip6, dst_ip6, sizeof(dst_ip6));
=20
-	printf("state:%u bound_dev_if:%u family:%u type:%u protocol:%u mark:%u =
priority:%u "
+	printf("%s: state:%u bound_dev_if:%u family:%u type:%u protocol:%u mark=
:%u priority:%u "
 	       "src_ip4:%x(%s) src_ip6:%x:%x:%x:%x(%s) src_port:%u "
 	       "dst_ip4:%x(%s) dst_ip6:%x:%x:%x:%x(%s) dst_port:%u\n",
+	       prefix,
 	       sk->state, sk->bound_dev_if, sk->family, sk->type, sk->protocol,
 	       sk->mark, sk->priority,
 	       sk->src_ip4, src_ip4,
@@ -102,14 +74,15 @@ static void print_sk(const struct bpf_sock *sk)
 	       dst_ip6, ntohs(sk->dst_port));
 }
=20
-static void print_tp(const struct bpf_tcp_sock *tp)
+static void print_tp(const struct bpf_tcp_sock *tp, const char *prefix)
 {
-	printf("snd_cwnd:%u srtt_us:%u rtt_min:%u snd_ssthresh:%u rcv_nxt:%u "
+	printf("%s: snd_cwnd:%u srtt_us:%u rtt_min:%u snd_ssthresh:%u rcv_nxt:%=
u "
 	       "snd_nxt:%u snd:una:%u mss_cache:%u ecn_flags:%u "
 	       "rate_delivered:%u rate_interval_us:%u packets_out:%u "
 	       "retrans_out:%u total_retrans:%u segs_in:%u data_segs_in:%u "
 	       "segs_out:%u data_segs_out:%u lost_out:%u sacked_out:%u "
 	       "bytes_received:%llu bytes_acked:%llu\n",
+	       prefix,
 	       tp->snd_cwnd, tp->srtt_us, tp->rtt_min, tp->snd_ssthresh,
 	       tp->rcv_nxt, tp->snd_nxt, tp->snd_una, tp->mss_cache,
 	       tp->ecn_flags, tp->rate_delivered, tp->rate_interval_us,
@@ -129,57 +102,26 @@ static void check_result(void)
 	err =3D bpf_map_lookup_elem(linum_map_fd, &egress_linum_idx,
 				  &egress_linum);
 	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(linum_map_fd)",
-	      "err:%d errno:%d", err, errno);
+	      "err:%d errno:%d\n", err, errno);
=20
 	err =3D bpf_map_lookup_elem(linum_map_fd, &ingress_linum_idx,
 				  &ingress_linum);
 	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(linum_map_fd)",
-	      "err:%d errno:%d", err, errno);
-
-	err =3D bpf_map_lookup_elem(sk_map_fd, &egress_srv_idx, &srv_sk);
-	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(sk_map_fd, &egress_srv_idx)",
-	      "err:%d errno:%d", err, errno);
-	err =3D bpf_map_lookup_elem(tp_map_fd, &egress_srv_idx, &srv_tp);
-	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(tp_map_fd, &egress_srv_idx)",
-	      "err:%d errno:%d", err, errno);
-
-	err =3D bpf_map_lookup_elem(sk_map_fd, &egress_cli_idx, &cli_sk);
-	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(sk_map_fd, &egress_cli_idx)",
-	      "err:%d errno:%d", err, errno);
-	err =3D bpf_map_lookup_elem(tp_map_fd, &egress_cli_idx, &cli_tp);
-	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(tp_map_fd, &egress_cli_idx)",
-	      "err:%d errno:%d", err, errno);
-
-	err =3D bpf_map_lookup_elem(sk_map_fd, &ingress_listen_idx, &listen_sk)=
;
-	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(sk_map_fd, &ingress_listen_id=
x)",
-	      "err:%d errno:%d", err, errno);
-	err =3D bpf_map_lookup_elem(tp_map_fd, &ingress_listen_idx, &listen_tp)=
;
-	CHECK(err =3D=3D -1, "bpf_map_lookup_elem(tp_map_fd, &ingress_listen_id=
x)",
-	      "err:%d errno:%d", err, errno);
-
-	printf("listen_sk: ");
-	print_sk(&listen_sk);
-	printf("\n");
-
-	printf("srv_sk: ");
-	print_sk(&srv_sk);
-	printf("\n");
-
-	printf("cli_sk: ");
-	print_sk(&cli_sk);
-	printf("\n");
-
-	printf("listen_tp: ");
-	print_tp(&listen_tp);
-	printf("\n");
-
-	printf("srv_tp: ");
-	print_tp(&srv_tp);
-	printf("\n");
-
-	printf("cli_tp: ");
-	print_tp(&cli_tp);
-	printf("\n");
+	      "err:%d errno:%d\n", err, errno);
+
+	memcpy(&srv_sk, &skel->bss->srv_sk, sizeof(srv_sk));
+	memcpy(&srv_tp, &skel->bss->srv_tp, sizeof(srv_tp));
+	memcpy(&cli_sk, &skel->bss->cli_sk, sizeof(cli_sk));
+	memcpy(&cli_tp, &skel->bss->cli_tp, sizeof(cli_tp));
+	memcpy(&listen_sk, &skel->bss->listen_sk, sizeof(listen_sk));
+	memcpy(&listen_tp, &skel->bss->listen_tp, sizeof(listen_tp));
+
+	print_sk(&listen_sk, "listen_sk");
+	print_sk(&srv_sk, "srv_sk");
+	print_sk(&cli_sk, "cli_sk");
+	print_tp(&listen_tp, "listen_tp");
+	print_tp(&srv_tp, "srv_tp");
+	print_tp(&cli_tp, "cli_tp");
=20
 	CHECK(listen_sk.state !=3D 10 ||
 	      listen_sk.family !=3D AF_INET6 ||
@@ -190,8 +132,8 @@ static void check_result(void)
 	      listen_sk.dst_ip6[2] || listen_sk.dst_ip6[3] ||
 	      listen_sk.src_port !=3D ntohs(srv_sa6.sin6_port) ||
 	      listen_sk.dst_port,
-	      "Unexpected listen_sk",
-	      "Check listen_sk output. ingress_linum:%u",
+	      "listen_sk",
+	      "Unexpected. Check listen_sk output. ingress_linum:%u\n",
 	      ingress_linum);
=20
 	CHECK(srv_sk.state =3D=3D 10 ||
@@ -204,7 +146,7 @@ static void check_result(void)
 		     sizeof(srv_sk.dst_ip6)) ||
 	      srv_sk.src_port !=3D ntohs(srv_sa6.sin6_port) ||
 	      srv_sk.dst_port !=3D cli_sa6.sin6_port,
-	      "Unexpected srv_sk", "Check srv_sk output. egress_linum:%u",
+	      "srv_sk", "Unexpected. Check srv_sk output. egress_linum:%u\n",
 	      egress_linum);
=20
 	CHECK(cli_sk.state =3D=3D 10 ||
@@ -217,30 +159,31 @@ static void check_result(void)
 		     sizeof(cli_sk.dst_ip6)) ||
 	      cli_sk.src_port !=3D ntohs(cli_sa6.sin6_port) ||
 	      cli_sk.dst_port !=3D srv_sa6.sin6_port,
-	      "Unexpected cli_sk", "Check cli_sk output. egress_linum:%u",
+	      "cli_sk", "Unexpected. Check cli_sk output. egress_linum:%u\n",
 	      egress_linum);
=20
 	CHECK(listen_tp.data_segs_out ||
 	      listen_tp.data_segs_in ||
 	      listen_tp.total_retrans ||
 	      listen_tp.bytes_acked,
-	      "Unexpected listen_tp", "Check listen_tp output. ingress_linum:%u=
",
+	      "listen_tp",
+	      "Unexpected. Check listen_tp output. ingress_linum:%u\n",
 	      ingress_linum);
=20
 	CHECK(srv_tp.data_segs_out !=3D 2 ||
 	      srv_tp.data_segs_in ||
 	      srv_tp.snd_cwnd !=3D 10 ||
 	      srv_tp.total_retrans ||
-	      srv_tp.bytes_acked !=3D 2 * DATA_LEN,
-	      "Unexpected srv_tp", "Check srv_tp output. egress_linum:%u",
+	      srv_tp.bytes_acked < 2 * DATA_LEN,
+	      "srv_tp", "Unexpected. Check srv_tp output. egress_linum:%u\n",
 	      egress_linum);
=20
 	CHECK(cli_tp.data_segs_out ||
 	      cli_tp.data_segs_in !=3D 2 ||
 	      cli_tp.snd_cwnd !=3D 10 ||
 	      cli_tp.total_retrans ||
-	      cli_tp.bytes_received !=3D 2 * DATA_LEN,
-	      "Unexpected cli_tp", "Check cli_tp output. egress_linum:%u",
+	      cli_tp.bytes_received < 2 * DATA_LEN,
+	      "cli_tp", "Unexpected. Check cli_tp output. egress_linum:%u\n",
 	      egress_linum);
 }
=20
@@ -257,15 +200,14 @@ static void check_sk_pkt_out_cnt(int accept_fd, int=
 cli_fd)
 					  &pkt_out_cnt10);
=20
 	/* The bpf prog only counts for fullsock and
-	 * passive conneciton did not become fullsock until 3WHS
-	 * had been finished.
-	 * The bpf prog only counted two data packet out but we
-	 * specially init accept_fd's pkt_out_cnt by 2 in
-	 * init_sk_storage().  Hence, 4 here.
+	 * passive connection did not become fullsock until 3WHS
+	 * had been finished, so the bpf prog only counted two data
+	 * packet out.
 	 */
-	CHECK(err || pkt_out_cnt.cnt !=3D 4 || pkt_out_cnt10.cnt !=3D 40,
+	CHECK(err || pkt_out_cnt.cnt < 0xeB9F + 2 ||
+	      pkt_out_cnt10.cnt < 0xeB9F + 20,
 	      "bpf_map_lookup_elem(sk_pkt_out_cnt, &accept_fd)",
-	      "err:%d errno:%d pkt_out_cnt:%u pkt_out_cnt10:%u",
+	      "err:%d errno:%d pkt_out_cnt:%u pkt_out_cnt10:%u\n",
 	      err, errno, pkt_out_cnt.cnt, pkt_out_cnt10.cnt);
=20
 	pkt_out_cnt.cnt =3D ~0;
@@ -280,14 +222,14 @@ static void check_sk_pkt_out_cnt(int accept_fd, int=
 cli_fd)
 	 *
 	 * The bpf_prog initialized it to 0xeB9F.
 	 */
-	CHECK(err || pkt_out_cnt.cnt !=3D 0xeB9F + 4 ||
-	      pkt_out_cnt10.cnt !=3D 0xeB9F + 40,
+	CHECK(err || pkt_out_cnt.cnt < 0xeB9F + 4 ||
+	      pkt_out_cnt10.cnt < 0xeB9F + 40,
 	      "bpf_map_lookup_elem(sk_pkt_out_cnt, &cli_fd)",
-	      "err:%d errno:%d pkt_out_cnt:%u pkt_out_cnt10:%u",
+	      "err:%d errno:%d pkt_out_cnt:%u pkt_out_cnt10:%u\n",
 	      err, errno, pkt_out_cnt.cnt, pkt_out_cnt10.cnt);
 }
=20
-static void init_sk_storage(int sk_fd, __u32 pkt_out_cnt)
+static int init_sk_storage(int sk_fd, __u32 pkt_out_cnt)
 {
 	struct bpf_spinlock_cnt scnt =3D {};
 	int err;
@@ -295,186 +237,190 @@ static void init_sk_storage(int sk_fd, __u32 pkt_=
out_cnt)
 	scnt.cnt =3D pkt_out_cnt;
 	err =3D bpf_map_update_elem(sk_pkt_out_cnt_fd, &sk_fd, &scnt,
 				  BPF_NOEXIST);
-	CHECK(err, "bpf_map_update_elem(sk_pkt_out_cnt_fd)",
-	      "err:%d errno:%d", err, errno);
+	if (CHECK(err, "bpf_map_update_elem(sk_pkt_out_cnt_fd)",
+		  "err:%d errno:%d\n", err, errno))
+		return err;
=20
-	scnt.cnt *=3D 10;
 	err =3D bpf_map_update_elem(sk_pkt_out_cnt10_fd, &sk_fd, &scnt,
 				  BPF_NOEXIST);
-	CHECK(err, "bpf_map_update_elem(sk_pkt_out_cnt10_fd)",
-	      "err:%d errno:%d", err, errno);
+	if (CHECK(err, "bpf_map_update_elem(sk_pkt_out_cnt10_fd)",
+		  "err:%d errno:%d\n", err, errno))
+		return err;
+
+	return 0;
 }
=20
 static void test(void)
 {
-	int listen_fd, cli_fd, accept_fd, epfd, err;
+	int listen_fd =3D -1, cli_fd =3D -1, accept_fd =3D -1, epfd, err, i;
 	struct epoll_event ev;
 	socklen_t addrlen;
-	int i;
+	char buf[DATA_LEN];
=20
 	addrlen =3D sizeof(struct sockaddr_in6);
 	ev.events =3D EPOLLIN;
=20
 	epfd =3D epoll_create(1);
-	CHECK(epfd =3D=3D -1, "epoll_create()", "epfd:%d errno:%d", epfd, errno=
);
+	if (CHECK(epfd =3D=3D -1, "epoll_create()", "epfd:%d errno:%d\n",
+		  epfd, errno))
+		return;
=20
 	/* Prepare listen_fd */
 	listen_fd =3D socket(AF_INET6, SOCK_STREAM | SOCK_NONBLOCK, 0);
-	CHECK(listen_fd =3D=3D -1, "socket()", "listen_fd:%d errno:%d",
-	      listen_fd, errno);
+	if (CHECK(listen_fd =3D=3D -1, "socket()", "listen_fd:%d errno:%d\n",
+		  listen_fd, errno))
+		goto done;
=20
 	init_loopback6(&srv_sa6);
 	err =3D bind(listen_fd, (struct sockaddr *)&srv_sa6, sizeof(srv_sa6));
-	CHECK(err, "bind(listen_fd)", "err:%d errno:%d", err, errno);
+	if (CHECK(err, "bind(listen_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
=20
 	err =3D getsockname(listen_fd, (struct sockaddr *)&srv_sa6, &addrlen);
-	CHECK(err, "getsockname(listen_fd)", "err:%d errno:%d", err, errno);
+	if (CHECK(err, "getsockname(listen_fd)", "err:%d errno:%d\n", err,
+		  errno))
+		goto done;
+	memcpy(&skel->bss->srv_sa6, &srv_sa6, sizeof(srv_sa6));
=20
 	err =3D listen(listen_fd, 1);
-	CHECK(err, "listen(listen_fd)", "err:%d errno:%d", err, errno);
+	if (CHECK(err, "listen(listen_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
=20
 	/* Prepare cli_fd */
 	cli_fd =3D socket(AF_INET6, SOCK_STREAM | SOCK_NONBLOCK, 0);
-	CHECK(cli_fd =3D=3D -1, "socket()", "cli_fd:%d errno:%d", cli_fd, errno=
);
+	if (CHECK(cli_fd =3D=3D -1, "socket()", "cli_fd:%d errno:%d\n", cli_fd,
+		  errno))
+		goto done;
=20
 	init_loopback6(&cli_sa6);
 	err =3D bind(cli_fd, (struct sockaddr *)&cli_sa6, sizeof(cli_sa6));
-	CHECK(err, "bind(cli_fd)", "err:%d errno:%d", err, errno);
+	if (CHECK(err, "bind(cli_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
=20
 	err =3D getsockname(cli_fd, (struct sockaddr *)&cli_sa6, &addrlen);
-	CHECK(err, "getsockname(cli_fd)", "err:%d errno:%d",
-	      err, errno);
-
-	/* Update addr_map with srv_sa6 and cli_sa6 */
-	err =3D bpf_map_update_elem(addr_map_fd, &addr_srv_idx, &srv_sa6, 0);
-	CHECK(err, "map_update", "err:%d errno:%d", err, errno);
-
-	err =3D bpf_map_update_elem(addr_map_fd, &addr_cli_idx, &cli_sa6, 0);
-	CHECK(err, "map_update", "err:%d errno:%d", err, errno);
+	if (CHECK(err, "getsockname(cli_fd)", "err:%d errno:%d\n",
+		  err, errno))
+		goto done;
=20
 	/* Connect from cli_sa6 to srv_sa6 */
 	err =3D connect(cli_fd, (struct sockaddr *)&srv_sa6, addrlen);
 	printf("srv_sa6.sin6_port:%u cli_sa6.sin6_port:%u\n\n",
 	       ntohs(srv_sa6.sin6_port), ntohs(cli_sa6.sin6_port));
-	CHECK(err && errno !=3D EINPROGRESS,
-	      "connect(cli_fd)", "err:%d errno:%d", err, errno);
+	if (CHECK(err && errno !=3D EINPROGRESS,
+		  "connect(cli_fd)", "err:%d errno:%d\n", err, errno))
+		goto done;
=20
 	ev.data.fd =3D listen_fd;
 	err =3D epoll_ctl(epfd, EPOLL_CTL_ADD, listen_fd, &ev);
-	CHECK(err, "epoll_ctl(EPOLL_CTL_ADD, listen_fd)", "err:%d errno:%d",
-	      err, errno);
+	if (CHECK(err, "epoll_ctl(EPOLL_CTL_ADD, listen_fd)",
+		  "err:%d errno:%d\n", err, errno))
+		goto done;
=20
 	/* Accept the connection */
 	/* Have some timeout in accept(listen_fd). Just in case. */
 	err =3D epoll_wait(epfd, &ev, 1, 1000);
-	CHECK(err !=3D 1 || ev.data.fd !=3D listen_fd,
-	      "epoll_wait(listen_fd)",
-	      "err:%d errno:%d ev.data.fd:%d listen_fd:%d",
-	      err, errno, ev.data.fd, listen_fd);
+	if (CHECK(err !=3D 1 || ev.data.fd !=3D listen_fd,
+		  "epoll_wait(listen_fd)",
+		  "err:%d errno:%d ev.data.fd:%d listen_fd:%d\n",
+		  err, errno, ev.data.fd, listen_fd))
+		goto done;
=20
 	accept_fd =3D accept(listen_fd, NULL, NULL);
-	CHECK(accept_fd =3D=3D -1, "accept(listen_fd)", "accept_fd:%d errno:%d"=
,
-	      accept_fd, errno);
-	close(listen_fd);
+	if (CHECK(accept_fd =3D=3D -1, "accept(listen_fd)",
+		  "accept_fd:%d errno:%d\n",
+		  accept_fd, errno))
+		goto done;
=20
 	ev.data.fd =3D cli_fd;
 	err =3D epoll_ctl(epfd, EPOLL_CTL_ADD, cli_fd, &ev);
-	CHECK(err, "epoll_ctl(EPOLL_CTL_ADD, cli_fd)", "err:%d errno:%d",
-	      err, errno);
+	if (CHECK(err, "epoll_ctl(EPOLL_CTL_ADD, cli_fd)",
+		  "err:%d errno:%d\n", err, errno))
+		goto done;
=20
-	init_sk_storage(accept_fd, 2);
+	if (init_sk_storage(accept_fd, 0xeB9F))
+		goto done;
=20
 	for (i =3D 0; i < 2; i++) {
-		/* Send some data from accept_fd to cli_fd */
-		err =3D send(accept_fd, DATA, DATA_LEN, 0);
-		CHECK(err !=3D DATA_LEN, "send(accept_fd)", "err:%d errno:%d",
-		      err, errno);
+		/* Send some data from accept_fd to cli_fd.
+		 * MSG_EOR to stop kernel from coalescing two pkts.
+		 */
+		err =3D send(accept_fd, DATA, DATA_LEN, MSG_EOR);
+		if (CHECK(err !=3D DATA_LEN, "send(accept_fd)",
+			  "err:%d errno:%d\n", err, errno))
+			goto done;
=20
 		/* Have some timeout in recv(cli_fd). Just in case. */
 		err =3D epoll_wait(epfd, &ev, 1, 1000);
-		CHECK(err !=3D 1 || ev.data.fd !=3D cli_fd,
-		      "epoll_wait(cli_fd)", "err:%d errno:%d ev.data.fd:%d cli_fd:%d",
-		      err, errno, ev.data.fd, cli_fd);
-
-		err =3D recv(cli_fd, NULL, 0, MSG_TRUNC);
-		CHECK(err, "recv(cli_fd)", "err:%d errno:%d", err, errno);
+		if (CHECK(err !=3D 1 || ev.data.fd !=3D cli_fd,
+			  "epoll_wait(cli_fd)",
+			  "err:%d errno:%d ev.data.fd:%d cli_fd:%d\n",
+			  err, errno, ev.data.fd, cli_fd))
+			goto done;
+
+		err =3D recv(cli_fd, buf, DATA_LEN, 0);
+		if (CHECK(err !=3D DATA_LEN, "recv(cli_fd)", "err:%d errno:%d\n",
+			  err, errno))
+			goto done;
 	}
=20
+	shutdown(cli_fd, SHUT_WR);
+	err =3D recv(accept_fd, buf, 1, 0);
+	if (CHECK(err, "recv(accept_fd) for fin", "err:%d errno:%d\n",
+		  err, errno))
+		goto done;
+	shutdown(accept_fd, SHUT_WR);
+	err =3D recv(cli_fd, buf, 1, 0);
+	if (CHECK(err, "recv(cli_fd) for fin", "err:%d errno:%d\n",
+		  err, errno))
+		goto done;
 	check_sk_pkt_out_cnt(accept_fd, cli_fd);
+	check_result();
=20
+done:
+	if (accept_fd !=3D -1)
+		close(accept_fd);
+	if (cli_fd !=3D -1)
+		close(cli_fd);
+	if (listen_fd !=3D -1)
+		close(listen_fd);
 	close(epfd);
-	close(accept_fd);
-	close(cli_fd);
-
-	check_result();
 }
=20
 void test_sock_fields(void)
 {
-	struct bpf_prog_load_attr attr =3D {
-		.file =3D "test_sock_fields.o",
-		.prog_type =3D BPF_PROG_TYPE_CGROUP_SKB,
-		.prog_flags =3D BPF_F_TEST_RND_HI32,
-	};
-	int cgroup_fd, egress_fd, ingress_fd, err;
-	struct bpf_program *ingress_prog;
-	struct bpf_object *obj;
-	struct bpf_map *map;
+	struct bpf_link *egress_link =3D NULL, *ingress_link =3D NULL;
+	int cgroup_fd;
=20
 	/* Create a cgroup, get fd, and join it */
-	cgroup_fd =3D cgroup_setup_and_join(TEST_CGROUP);
-	CHECK(cgroup_fd < 0, "cgroup_setup_and_join()",
-	      "cgroup_fd:%d errno:%d", cgroup_fd, errno);
-	atexit(cleanup_cgroup_environment);
-
-	err =3D bpf_prog_load_xattr(&attr, &obj, &egress_fd);
-	CHECK(err, "bpf_prog_load_xattr()", "err:%d", err);
-
-	ingress_prog =3D bpf_object__find_program_by_title(obj,
-							 "cgroup_skb/ingress");
-	CHECK(!ingress_prog,
-	      "bpf_object__find_program_by_title(cgroup_skb/ingress)",
-	      "not found");
-	ingress_fd =3D bpf_program__fd(ingress_prog);
-
-	err =3D bpf_prog_attach(egress_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS, 0=
);
-	CHECK(err =3D=3D -1, "bpf_prog_attach(CPF_CGROUP_INET_EGRESS)",
-	      "err:%d errno%d", err, errno);
-
-	err =3D bpf_prog_attach(ingress_fd, cgroup_fd,
-			      BPF_CGROUP_INET_INGRESS, 0);
-	CHECK(err =3D=3D -1, "bpf_prog_attach(CPF_CGROUP_INET_INGRESS)",
-	      "err:%d errno%d", err, errno);
-	close(cgroup_fd);
-
-	map =3D bpf_object__find_map_by_name(obj, "addr_map");
-	CHECK(!map, "cannot find addr_map", "(null)");
-	addr_map_fd =3D bpf_map__fd(map);
-
-	map =3D bpf_object__find_map_by_name(obj, "sock_result_map");
-	CHECK(!map, "cannot find sock_result_map", "(null)");
-	sk_map_fd =3D bpf_map__fd(map);
-
-	map =3D bpf_object__find_map_by_name(obj, "tcp_sock_result_map");
-	CHECK(!map, "cannot find tcp_sock_result_map", "(null)");
-	tp_map_fd =3D bpf_map__fd(map);
-
-	map =3D bpf_object__find_map_by_name(obj, "linum_map");
-	CHECK(!map, "cannot find linum_map", "(null)");
-	linum_map_fd =3D bpf_map__fd(map);
-
-	map =3D bpf_object__find_map_by_name(obj, "sk_pkt_out_cnt");
-	CHECK(!map, "cannot find sk_pkt_out_cnt", "(null)");
-	sk_pkt_out_cnt_fd =3D bpf_map__fd(map);
-
-	map =3D bpf_object__find_map_by_name(obj, "sk_pkt_out_cnt10");
-	CHECK(!map, "cannot find sk_pkt_out_cnt10", "(null)");
-	sk_pkt_out_cnt10_fd =3D bpf_map__fd(map);
+	cgroup_fd =3D test__join_cgroup(TEST_CGROUP);
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	skel =3D test_sock_fields__open_and_load();
+	if (CHECK(!skel, "test_sock_fields__open_and_load", "failed\n"))
+		goto done;
+
+	egress_link =3D bpf_program__attach_cgroup(skel->progs.egress_read_sock=
_fields,
+						 cgroup_fd);
+	if (CHECK(IS_ERR(egress_link), "attach_cgroup(egress)", "err:%ld\n",
+		  PTR_ERR(egress_link)))
+		goto done;
+
+	ingress_link =3D bpf_program__attach_cgroup(skel->progs.ingress_read_so=
ck_fields,
+						  cgroup_fd);
+	if (CHECK(IS_ERR(ingress_link), "attach_cgroup(ingress)", "err:%ld\n",
+		  PTR_ERR(ingress_link)))
+		goto done;
+
+	linum_map_fd =3D bpf_map__fd(skel->maps.linum_map);
+	sk_pkt_out_cnt_fd =3D bpf_map__fd(skel->maps.sk_pkt_out_cnt);
+	sk_pkt_out_cnt10_fd =3D bpf_map__fd(skel->maps.sk_pkt_out_cnt10);
=20
 	test();
=20
-	bpf_object__close(obj);
-	cleanup_cgroup_environment();
-
-	printf("PASS\n");
+done:
+	bpf_link__destroy(egress_link);
+	bpf_link__destroy(ingress_link);
+	test_sock_fields__destroy(skel);
+	close(cgroup_fd);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools=
/testing/selftests/bpf/progs/test_sock_fields.c
index 9bcaa37f476a..370e33a858db 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -8,46 +8,12 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
=20
-enum bpf_addr_array_idx {
-	ADDR_SRV_IDX,
-	ADDR_CLI_IDX,
-	__NR_BPF_ADDR_ARRAY_IDX,
-};
-
-enum bpf_result_array_idx {
-	EGRESS_SRV_IDX,
-	EGRESS_CLI_IDX,
-	INGRESS_LISTEN_IDX,
-	__NR_BPF_RESULT_ARRAY_IDX,
-};
-
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
 	INGRESS_LINUM_IDX,
 	__NR_BPF_LINUM_ARRAY_IDX,
 };
=20
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, __NR_BPF_ADDR_ARRAY_IDX);
-	__type(key, __u32);
-	__type(value, struct sockaddr_in6);
-} addr_map SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, __NR_BPF_RESULT_ARRAY_IDX);
-	__type(key, __u32);
-	__type(value, struct bpf_sock);
-} sock_result_map SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, __NR_BPF_RESULT_ARRAY_IDX);
-	__type(key, __u32);
-	__type(value, struct bpf_tcp_sock);
-} tcp_sock_result_map SEC(".maps");
-
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__uint(max_entries, __NR_BPF_LINUM_ARRAY_IDX);
@@ -74,6 +40,14 @@ struct {
 	__type(value, struct bpf_spinlock_cnt);
 } sk_pkt_out_cnt10 SEC(".maps");
=20
+struct bpf_tcp_sock listen_tp =3D {};
+struct sockaddr_in6 srv_sa6 =3D {};
+struct bpf_tcp_sock cli_tp =3D {};
+struct bpf_tcp_sock srv_tp =3D {};
+struct bpf_sock listen_sk =3D {};
+struct bpf_sock srv_sk =3D {};
+struct bpf_sock cli_sk =3D {};
+
 static bool is_loopback6(__u32 *a6)
 {
 	return !a6[0] && !a6[1] && !a6[2] && a6[3] =3D=3D bpf_htonl(1);
@@ -130,19 +104,20 @@ static void tpcpy(struct bpf_tcp_sock *dst,
 	dst->bytes_acked =3D src->bytes_acked;
 }
=20
-#define RETURN {						\
+/* Always return CG_OK so that no pkt will be filtered out */
+#define CG_OK 1
+
+#define RET_LOG() ({						\
 	linum =3D __LINE__;					\
-	bpf_map_update_elem(&linum_map, &linum_idx, &linum, 0);	\
-	return 1;						\
-}
+	bpf_map_update_elem(&linum_map, &linum_idx, &linum, BPF_NOEXIST);	\
+	return CG_OK;						\
+})
=20
 SEC("cgroup_skb/egress")
 int egress_read_sock_fields(struct __sk_buff *skb)
 {
 	struct bpf_spinlock_cnt cli_cnt_init =3D { .lock =3D 0, .cnt =3D 0xeB9F=
 };
-	__u32 srv_idx =3D ADDR_SRV_IDX, cli_idx =3D ADDR_CLI_IDX, result_idx;
 	struct bpf_spinlock_cnt *pkt_out_cnt, *pkt_out_cnt10;
-	struct sockaddr_in6 *srv_sa6, *cli_sa6;
 	struct bpf_tcp_sock *tp, *tp_ret;
 	struct bpf_sock *sk, *sk_ret;
 	__u32 linum, linum_idx;
@@ -150,39 +125,46 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	linum_idx =3D EGRESS_LINUM_IDX;
=20
 	sk =3D skb->sk;
-	if (!sk || sk->state =3D=3D 10)
-		RETURN;
+	if (!sk)
+		RET_LOG();
=20
+	/* Not the testing egress traffic or
+	 * TCP_LISTEN (10) socket will be copied at the ingress side.
+	 */
+	if (sk->family !=3D AF_INET6 || !is_loopback6(sk->src_ip6) ||
+	    sk->state =3D=3D 10)
+		return CG_OK;
+
+	if (sk->src_port =3D=3D bpf_ntohs(srv_sa6.sin6_port)) {
+		/* Server socket */
+		sk_ret =3D &srv_sk;
+		tp_ret =3D &srv_tp;
+	} else if (sk->dst_port =3D=3D srv_sa6.sin6_port) {
+		/* Client socket */
+		sk_ret =3D &cli_sk;
+		tp_ret =3D &cli_tp;
+	} else {
+		/* Not the testing egress traffic */
+		return CG_OK;
+	}
+
+	/* It must be a fullsock for cgroup_skb/egress prog */
 	sk =3D bpf_sk_fullsock(sk);
-	if (!sk || sk->family !=3D AF_INET6 || sk->protocol !=3D IPPROTO_TCP ||
-	    !is_loopback6(sk->src_ip6))
-		RETURN;
+	if (!sk)
+		RET_LOG();
+
+	/* Not the testing egress traffic */
+	if (sk->protocol !=3D IPPROTO_TCP)
+		return CG_OK;
=20
 	tp =3D bpf_tcp_sock(sk);
 	if (!tp)
-		RETURN;
-
-	srv_sa6 =3D bpf_map_lookup_elem(&addr_map, &srv_idx);
-	cli_sa6 =3D bpf_map_lookup_elem(&addr_map, &cli_idx);
-	if (!srv_sa6 || !cli_sa6)
-		RETURN;
-
-	if (sk->src_port =3D=3D bpf_ntohs(srv_sa6->sin6_port))
-		result_idx =3D EGRESS_SRV_IDX;
-	else if (sk->src_port =3D=3D bpf_ntohs(cli_sa6->sin6_port))
-		result_idx =3D EGRESS_CLI_IDX;
-	else
-		RETURN;
-
-	sk_ret =3D bpf_map_lookup_elem(&sock_result_map, &result_idx);
-	tp_ret =3D bpf_map_lookup_elem(&tcp_sock_result_map, &result_idx);
-	if (!sk_ret || !tp_ret)
-		RETURN;
+		RET_LOG();
=20
 	skcpy(sk_ret, sk);
 	tpcpy(tp_ret, tp);
=20
-	if (result_idx =3D=3D EGRESS_SRV_IDX) {
+	if (sk_ret =3D=3D &srv_sk) {
 		/* The userspace has created it for srv sk */
 		pkt_out_cnt =3D bpf_sk_storage_get(&sk_pkt_out_cnt, sk, 0, 0);
 		pkt_out_cnt10 =3D bpf_sk_storage_get(&sk_pkt_out_cnt10, sk,
@@ -197,7 +179,7 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	}
=20
 	if (!pkt_out_cnt || !pkt_out_cnt10)
-		RETURN;
+		RET_LOG();
=20
 	/* Even both cnt and cnt10 have lock defined in their BTF,
 	 * intentionally one cnt takes lock while one does not
@@ -208,48 +190,44 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	pkt_out_cnt10->cnt +=3D 10;
 	bpf_spin_unlock(&pkt_out_cnt10->lock);
=20
-	RETURN;
+	return CG_OK;
 }
=20
 SEC("cgroup_skb/ingress")
 int ingress_read_sock_fields(struct __sk_buff *skb)
 {
-	__u32 srv_idx =3D ADDR_SRV_IDX, result_idx =3D INGRESS_LISTEN_IDX;
-	struct bpf_tcp_sock *tp, *tp_ret;
-	struct bpf_sock *sk, *sk_ret;
-	struct sockaddr_in6 *srv_sa6;
+	struct bpf_tcp_sock *tp;
 	__u32 linum, linum_idx;
+	struct bpf_sock *sk;
=20
 	linum_idx =3D INGRESS_LINUM_IDX;
=20
 	sk =3D skb->sk;
-	if (!sk || sk->family !=3D AF_INET6 || !is_loopback6(sk->src_ip6))
-		RETURN;
+	if (!sk)
+		RET_LOG();
=20
-	srv_sa6 =3D bpf_map_lookup_elem(&addr_map, &srv_idx);
-	if (!srv_sa6 || sk->src_port !=3D bpf_ntohs(srv_sa6->sin6_port))
-		RETURN;
+	/* Not the testing ingress traffic to the server */
+	if (sk->family !=3D AF_INET6 || !is_loopback6(sk->src_ip6) ||
+	    sk->src_port !=3D bpf_ntohs(srv_sa6.sin6_port))
+		return CG_OK;
=20
-	if (sk->state !=3D 10 && sk->state !=3D 12)
-		RETURN;
+	/* Only interested in TCP_LISTEN */
+	if (sk->state !=3D 10)
+		return CG_OK;
=20
-	sk =3D bpf_get_listener_sock(sk);
+	/* It must be a fullsock for cgroup_skb/ingress prog */
+	sk =3D bpf_sk_fullsock(sk);
 	if (!sk)
-		RETURN;
+		RET_LOG();
=20
 	tp =3D bpf_tcp_sock(sk);
 	if (!tp)
-		RETURN;
-
-	sk_ret =3D bpf_map_lookup_elem(&sock_result_map, &result_idx);
-	tp_ret =3D bpf_map_lookup_elem(&tcp_sock_result_map, &result_idx);
-	if (!sk_ret || !tp_ret)
-		RETURN;
+		RET_LOG();
=20
-	skcpy(sk_ret, sk);
-	tpcpy(tp_ret, tp);
+	skcpy(&listen_sk, sk);
+	tpcpy(&listen_tp, tp);
=20
-	RETURN;
+	return CG_OK;
 }
=20
 char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

