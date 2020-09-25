Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453CC277CAF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgIYAFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:05:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38918 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726932AbgIYAFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:05:04 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08P02n0U010929
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:05:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uLQOLqtndqv1+1tghZzjLIu6dnOLQ7B75QVc4BL9wIg=;
 b=ERQRSLC+0Y3TaUlT+eqMgH+IpmpaaUeOkfb55vOyHjoNh064mQg7qb9t4cV5DimjLffj
 iyiCiTaMNBH2N2O+1GLH9VKMAbJroNfEDAqjSui0u70XdkNEqC6vk7SEP4vRU+92hOcE
 sViCjtColGi6G4+kCwFhYxDlGP6gvdge7Xw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33qsp7mw6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:05:02 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:05:01 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 023782946606; Thu, 24 Sep 2020 17:04:58 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 13/13] bpf: selftest: Add test_btf_skc_cls_ingress
Date:   Thu, 24 Sep 2020 17:04:58 -0700
Message-ID: <20200925000458.3859627-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch attaches a classifier prog to the ingress filter.
It exercises the following helpers with different socket pointer
types in different logical branches:
1. bpf_sk_release()
2. bpf_sk_assign()
3. bpf_skc_to_tcp_request_sock(), bpf_skc_to_tcp_sock()
4. bpf_tcp_gen_syncookie, bpf_tcp_check_syncookie

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   5 +
 .../bpf/prog_tests/btf_skc_cls_ingress.c      | 234 ++++++++++++++++++
 .../bpf/progs/test_btf_skc_cls_ingress.c      | 174 +++++++++++++
 3 files changed, 413 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_in=
gress.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_skc_cls_in=
gress.c

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
index a0e8b3758bd7..2915664c335d 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -16,6 +16,7 @@ BPF_PROG(name, args)
=20
 struct sock_common {
 	unsigned char	skc_state;
+	__u16		skc_num;
 } __attribute__((preserve_access_index));
=20
 enum sk_pacing {
@@ -45,6 +46,10 @@ struct inet_connection_sock {
 	__u64			  icsk_ca_priv[104 / sizeof(__u64)];
 } __attribute__((preserve_access_index));
=20
+struct request_sock {
+	struct sock_common		__req_common;
+} __attribute__((preserve_access_index));
+
 struct tcp_sock {
 	struct inet_connection_sock	inet_conn;
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c=
 b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
new file mode 100644
index 000000000000..4ce0e8a25bc5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#define _GNU_SOURCE
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <sched.h>
+#include <linux/compiler.h>
+#include <bpf/libbpf.h>
+
+#include "network_helpers.h"
+#include "test_progs.h"
+#include "test_btf_skc_cls_ingress.skel.h"
+
+struct test_btf_skc_cls_ingress *skel;
+struct sockaddr_in6 srv_sa6;
+static __u32 duration;
+
+#define PROG_PIN_FILE "/sys/fs/bpf/btf_skc_cls_ingress"
+
+static int write_sysctl(const char *sysctl, const char *value)
+{
+	int fd, err, len;
+
+	fd =3D open(sysctl, O_WRONLY);
+	if (CHECK(fd =3D=3D -1, "open sysctl", "open(%s): %s (%d)\n",
+		  sysctl, strerror(errno), errno))
+		return -1;
+
+	len =3D strlen(value);
+	err =3D write(fd, value, len);
+	close(fd);
+	if (CHECK(err !=3D len, "write sysctl",
+		  "write(%s, %s, %d): err:%d %s (%d)\n",
+		  sysctl, value, len, err, strerror(errno), errno))
+		return -1;
+
+	return 0;
+}
+
+static int prepare_netns(void)
+{
+	if (CHECK(unshare(CLONE_NEWNET), "create netns",
+		  "unshare(CLONE_NEWNET): %s (%d)",
+		  strerror(errno), errno))
+		return -1;
+
+	if (CHECK(system("ip link set dev lo up"),
+		  "ip link set dev lo up", "failed\n"))
+		return -1;
+
+	if (CHECK(system("tc qdisc add dev lo clsact"),
+		  "tc qdisc add dev lo clsact", "failed\n"))
+		return -1;
+
+	if (CHECK(system("tc filter add dev lo ingress bpf direct-action object=
-pinned " PROG_PIN_FILE),
+		  "install tc cls-prog at ingress", "failed\n"))
+		return -1;
+
+	/* Ensure 20 bytes options (i.e. in total 40 bytes tcp header) for the
+	 * bpf_tcp_gen_syncookie() helper.
+	 */
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_window_scaling", "1") ||
+	    write_sysctl("/proc/sys/net/ipv4/tcp_timestamps", "1") ||
+	    write_sysctl("/proc/sys/net/ipv4/tcp_sack", "1"))
+		return -1;
+
+	return 0;
+}
+
+static void reset_test(void)
+{
+	memset(&skel->bss->srv_sa6, 0, sizeof(skel->bss->srv_sa6));
+	skel->bss->listen_tp_sport =3D 0;
+	skel->bss->req_sk_sport =3D 0;
+	skel->bss->recv_cookie =3D 0;
+	skel->bss->gen_cookie =3D 0;
+	skel->bss->linum =3D 0;
+}
+
+static void print_err_line(void)
+{
+	if (skel->bss->linum)
+		printf("bpf prog error at line %u\n", skel->bss->linum);
+}
+
+static void test_conn(void)
+{
+	int listen_fd =3D -1, cli_fd =3D -1, err;
+	socklen_t addrlen =3D sizeof(srv_sa6);
+	int srv_port;
+
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "1"))
+		return;
+
+	listen_fd =3D start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	if (CHECK_FAIL(listen_fd =3D=3D -1))
+		return;
+
+	err =3D getsockname(listen_fd, (struct sockaddr *)&srv_sa6, &addrlen);
+	if (CHECK(err, "getsockname(listen_fd)", "err:%d errno:%d\n", err,
+		  errno))
+		goto done;
+	memcpy(&skel->bss->srv_sa6, &srv_sa6, sizeof(srv_sa6));
+	srv_port =3D ntohs(srv_sa6.sin6_port);
+
+	cli_fd =3D connect_to_fd(listen_fd, 0);
+	if (CHECK_FAIL(cli_fd =3D=3D -1))
+		goto done;
+
+	if (CHECK(skel->bss->listen_tp_sport !=3D srv_port ||
+		  skel->bss->req_sk_sport !=3D srv_port,
+		  "Unexpected sk src port",
+		  "listen_tp_sport:%u req_sk_sport:%u expected:%u\n",
+		  skel->bss->listen_tp_sport, skel->bss->req_sk_sport,
+		  srv_port))
+		goto done;
+
+	if (CHECK(skel->bss->gen_cookie || skel->bss->recv_cookie,
+		  "Unexpected syncookie states",
+		  "gen_cookie:%u recv_cookie:%u\n",
+		  skel->bss->gen_cookie, skel->bss->recv_cookie))
+		goto done;
+
+	CHECK(skel->bss->linum, "bpf prog detected error", "at line %u\n",
+	      skel->bss->linum);
+
+done:
+	if (listen_fd !=3D -1)
+		close(listen_fd);
+	if (cli_fd !=3D -1)
+		close(cli_fd);
+}
+
+static void test_syncookie(void)
+{
+	int listen_fd =3D -1, cli_fd =3D -1, err;
+	socklen_t addrlen =3D sizeof(srv_sa6);
+	int srv_port;
+
+	/* Enforce syncookie mode */
+	if (write_sysctl("/proc/sys/net/ipv4/tcp_syncookies", "2"))
+		return;
+
+	listen_fd =3D start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	if (CHECK_FAIL(listen_fd =3D=3D -1))
+		return;
+
+	err =3D getsockname(listen_fd, (struct sockaddr *)&srv_sa6, &addrlen);
+	if (CHECK(err, "getsockname(listen_fd)", "err:%d errno:%d\n", err,
+		  errno))
+		goto done;
+	memcpy(&skel->bss->srv_sa6, &srv_sa6, sizeof(srv_sa6));
+	srv_port =3D ntohs(srv_sa6.sin6_port);
+
+	cli_fd =3D connect_to_fd(listen_fd, 0);
+	if (CHECK_FAIL(cli_fd =3D=3D -1))
+		goto done;
+
+	if (CHECK(skel->bss->listen_tp_sport !=3D srv_port,
+		  "Unexpected tp src port",
+		  "listen_tp_sport:%u expected:%u\n",
+		  skel->bss->listen_tp_sport, srv_port))
+		goto done;
+
+	if (CHECK(skel->bss->req_sk_sport,
+		  "Unexpected req_sk src port",
+		  "req_sk_sport:%u expected:0\n",
+		   skel->bss->req_sk_sport))
+		goto done;
+
+	if (CHECK(!skel->bss->gen_cookie ||
+		  skel->bss->gen_cookie !=3D skel->bss->recv_cookie,
+		  "Unexpected syncookie states",
+		  "gen_cookie:%u recv_cookie:%u\n",
+		  skel->bss->gen_cookie, skel->bss->recv_cookie))
+		goto done;
+
+	CHECK(skel->bss->linum, "bpf prog detected error", "at line %u\n",
+	      skel->bss->linum);
+
+done:
+	if (listen_fd !=3D -1)
+		close(listen_fd);
+	if (cli_fd !=3D -1)
+		close(cli_fd);
+}
+
+struct test {
+	const char *desc;
+	void (*run)(void);
+};
+
+#define DEF_TEST(name) { #name, test_##name }
+static struct test tests[] =3D {
+	DEF_TEST(conn),
+	DEF_TEST(syncookie),
+};
+
+void test_btf_skc_cls_ingress(void)
+{
+	int i, err;
+
+	skel =3D test_btf_skc_cls_ingress__open_and_load();
+	if (CHECK(!skel, "test_btf_skc_cls_ingress__open_and_load", "failed\n")=
)
+		return;
+
+	err =3D bpf_program__pin(skel->progs.cls_ingress, PROG_PIN_FILE);
+	if (CHECK(err, "bpf_program__pin",
+		  "cannot pin bpf prog to %s. err:%d\n", PROG_PIN_FILE, err)) {
+		test_btf_skc_cls_ingress__destroy(skel);
+		return;
+	}
+
+	for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
+		if (!test__start_subtest(tests[i].desc))
+			continue;
+
+		if (prepare_netns())
+			break;
+
+		tests[i].run();
+
+		print_err_line();
+		reset_test();
+	}
+
+	bpf_program__unpin(skel->progs.cls_ingress, PROG_PIN_FILE);
+	test_btf_skc_cls_ingress__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c=
 b/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
new file mode 100644
index 000000000000..9a6b85dd52d2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingress.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <string.h>
+#include <errno.h>
+#include <netinet/in.h>
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/if_ether.h>
+#include <linux/pkt_cls.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include "bpf_tcp_helpers.h"
+
+struct sockaddr_in6 srv_sa6 =3D {};
+__u16 listen_tp_sport =3D 0;
+__u16 req_sk_sport =3D 0;
+__u32 recv_cookie =3D 0;
+__u32 gen_cookie =3D 0;
+__u32 linum =3D 0;
+
+#define LOG() ({ if (!linum) linum =3D __LINE__; })
+
+static void test_syncookie_helper(struct ipv6hdr *ip6h, struct tcphdr *t=
h,
+				  struct tcp_sock *tp,
+				  struct __sk_buff *skb)
+{
+	if (th->syn) {
+		__s64 mss_cookie;
+		void *data_end;
+
+		data_end =3D (void *)(long)(skb->data_end);
+
+		if (th->doff * 4 !=3D 40) {
+			LOG();
+			return;
+		}
+
+		if ((void *)th + 40 > data_end) {
+			LOG();
+			return;
+		}
+
+		mss_cookie =3D bpf_tcp_gen_syncookie(tp, ip6h, sizeof(*ip6h),
+						   th, 40);
+		if (mss_cookie < 0) {
+			if (mss_cookie !=3D -ENOENT)
+				LOG();
+		} else {
+			gen_cookie =3D (__u32)mss_cookie;
+		}
+	} else if (gen_cookie) {
+		/* It was in cookie mode */
+		int ret =3D bpf_tcp_check_syncookie(tp, ip6h, sizeof(*ip6h),
+						  th, sizeof(*th));
+
+		if (ret < 0) {
+			if (ret !=3D -ENOENT)
+				LOG();
+		} else {
+			recv_cookie =3D bpf_ntohl(th->ack_seq) - 1;
+		}
+	}
+}
+
+static int handle_ip6_tcp(struct ipv6hdr *ip6h, struct __sk_buff *skb)
+{
+	struct bpf_sock_tuple *tuple;
+	struct bpf_sock *bpf_skc;
+	unsigned int tuple_len;
+	struct tcphdr *th;
+	void *data_end;
+
+	data_end =3D (void *)(long)(skb->data_end);
+
+	th =3D (struct tcphdr *)(ip6h + 1);
+	if (th + 1 > data_end)
+		return TC_ACT_OK;
+
+	/* Is it the testing traffic? */
+	if (th->dest !=3D srv_sa6.sin6_port)
+		return TC_ACT_OK;
+
+	tuple_len =3D sizeof(tuple->ipv6);
+	tuple =3D (struct bpf_sock_tuple *)&ip6h->saddr;
+	if ((void *)tuple + tuple_len > data_end) {
+		LOG();
+		return TC_ACT_OK;
+	}
+
+	bpf_skc =3D bpf_skc_lookup_tcp(skb, tuple, tuple_len,
+				     BPF_F_CURRENT_NETNS, 0);
+	if (!bpf_skc) {
+		LOG();
+		return TC_ACT_OK;
+	}
+
+	if (bpf_skc->state =3D=3D BPF_TCP_NEW_SYN_RECV) {
+		struct request_sock *req_sk;
+
+		req_sk =3D (struct request_sock *)bpf_skc_to_tcp_request_sock(bpf_skc)=
;
+		if (!req_sk) {
+			LOG();
+			goto release;
+		}
+
+		if (bpf_sk_assign(skb, req_sk, 0)) {
+			LOG();
+			goto release;
+		}
+
+		req_sk_sport =3D req_sk->__req_common.skc_num;
+
+		bpf_sk_release(req_sk);
+		return TC_ACT_OK;
+	} else if (bpf_skc->state =3D=3D BPF_TCP_LISTEN) {
+		struct tcp_sock *tp;
+
+		tp =3D bpf_skc_to_tcp_sock(bpf_skc);
+		if (!tp) {
+			LOG();
+			goto release;
+		}
+
+		if (bpf_sk_assign(skb, tp, 0)) {
+			LOG();
+			goto release;
+		}
+
+		listen_tp_sport =3D tp->inet_conn.icsk_inet.sk.__sk_common.skc_num;
+
+		test_syncookie_helper(ip6h, th, tp, skb);
+		bpf_sk_release(tp);
+		return TC_ACT_OK;
+	}
+
+	if (bpf_sk_assign(skb, bpf_skc, 0))
+		LOG();
+
+release:
+	bpf_sk_release(bpf_skc);
+	return TC_ACT_OK;
+}
+
+SEC("classifier/ingress")
+int cls_ingress(struct __sk_buff *skb)
+{
+	struct ipv6hdr *ip6h;
+	struct ethhdr *eth;
+	void *data_end;
+
+	data_end =3D (void *)(long)(skb->data_end);
+
+	eth =3D (struct ethhdr *)(long)(skb->data);
+	if (eth + 1 > data_end)
+		return TC_ACT_OK;
+
+	if (eth->h_proto !=3D bpf_htons(ETH_P_IPV6))
+		return TC_ACT_OK;
+
+	ip6h =3D (struct ipv6hdr *)(eth + 1);
+	if (ip6h + 1 > data_end)
+		return TC_ACT_OK;
+
+	if (ip6h->nexthdr =3D=3D IPPROTO_TCP)
+		return handle_ip6_tcp(ip6h, skb);
+
+	return TC_ACT_OK;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

