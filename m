Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51225581FF4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiG0GKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiG0GKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:10:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F211759B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:37 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND2If005053
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7MCOx1AoF1yOC0onMUZ2eDZTpIuAB22t2U/DWXwO2T8=;
 b=GyLb8544FimhC+z8G55qw4hBgAciRgu87L4ZKuKbT6Tldhaa8OprCnCtXk+EMTpEjfHI
 xelpDeYfsUTQOuD1LxZM31/L6zY9oc3nMULmADKc/4mi/hqGDFmcWRdPJMZLBG1uvmgF
 TWunkjlY0GzSrMkGnc/3XCDMwLQvIG/u5Q4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxaw380-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:36 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub203.TheFacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:10:35 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:10:35 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 24605757CFD4; Tue, 26 Jul 2022 23:10:25 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 14/14] selftests/bpf: bpf_setsockopt tests
Date:   Tue, 26 Jul 2022 23:10:25 -0700
Message-ID: <20220727061025.2380990-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 51hPcB9kagR_1SZTaPikLB1GdPrIoNdh
X-Proofpoint-GUID: 51hPcB9kagR_1SZTaPikLB1GdPrIoNdh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests to exercise optnames that are allowed
in bpf_setsockopt().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/setget_sockopt.c | 125 ++++
 .../selftests/bpf/progs/setget_sockopt.c      | 538 ++++++++++++++++++
 2 files changed, 663 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/setget_sockopt=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/setget_sockopt.c

diff --git a/tools/testing/selftests/bpf/prog_tests/setget_sockopt.c b/to=
ols/testing/selftests/bpf/prog_tests/setget_sockopt.c
new file mode 100644
index 000000000000..018611e6b248
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/setget_sockopt.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) Meta Platforms, Inc. and affiliates. */
+
+#define _GNU_SOURCE
+#include <sched.h>
+#include <linux/socket.h>
+#include <net/if.h>
+
+#include "test_progs.h"
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+#include "setget_sockopt.skel.h"
+
+#define CG_NAME "/setget-sockopt-test"
+
+static const char addr4_str[] =3D "127.0.0.1";
+static const char addr6_str[] =3D "::1";
+static struct setget_sockopt *skel;
+static int cg_fd;
+
+static int create_netns(void)
+{
+	if (!ASSERT_OK(unshare(CLONE_NEWNET), "create netns"))
+		return -1;
+
+	if (!ASSERT_OK(system("ip link set dev lo up"), "set lo up"))
+		return -1;
+
+	if (!ASSERT_OK(system("ip link add dev binddevtest1 type veth peer name=
 binddevtest2"),
+		       "add veth"))
+		return -1;
+
+	if (!ASSERT_OK(system("ip link set dev binddevtest1 up"),
+		       "bring veth up"))
+		return -1;
+
+	return 0;
+}
+
+static void test_tcp(int family)
+{
+	struct setget_sockopt__bss *bss =3D skel->bss;
+	int sfd, cfd;
+
+	memset(bss, 0, sizeof(*bss));
+
+	sfd =3D start_server(family, SOCK_STREAM,
+			   family =3D=3D AF_INET6 ? addr6_str : addr4_str, 0, 0);
+	if (!ASSERT_GE(sfd, 0, "start_server"))
+		return;
+
+	cfd =3D connect_to_fd(sfd, 0);
+	if (!ASSERT_GE(cfd, 0, "connect_to_fd_server")) {
+		close(sfd);
+		return;
+	}
+	close(sfd);
+	close(cfd);
+
+	ASSERT_EQ(bss->nr_listen, 1, "nr_listen");
+	ASSERT_EQ(bss->nr_connect, 1, "nr_connect");
+	ASSERT_EQ(bss->nr_active, 1, "nr_active");
+	ASSERT_EQ(bss->nr_passive, 1, "nr_passive");
+	ASSERT_EQ(bss->nr_socket_post_create, 2, "nr_socket_post_create");
+	ASSERT_EQ(bss->nr_binddev, 2, "nr_bind");
+}
+
+static void test_udp(int family)
+{
+	struct setget_sockopt__bss *bss =3D skel->bss;
+	int sfd;
+
+	memset(bss, 0, sizeof(*bss));
+
+	sfd =3D start_server(family, SOCK_DGRAM,
+			   family =3D=3D AF_INET6 ? addr6_str : addr4_str, 0, 0);
+	if (!ASSERT_GE(sfd, 0, "start_server"))
+		return;
+	close(sfd);
+
+	ASSERT_GE(bss->nr_socket_post_create, 1, "nr_socket_post_create");
+	ASSERT_EQ(bss->nr_binddev, 1, "nr_bind");
+}
+
+void test_setget_sockopt(void)
+{
+	cg_fd =3D test__join_cgroup(CG_NAME);
+	if (cg_fd < 0)
+		return;
+
+	if (create_netns())
+		goto done;
+
+	skel =3D setget_sockopt__open();
+	if (!ASSERT_OK_PTR(skel, "open skel"))
+		goto done;
+
+	strcpy(skel->rodata->veth, "binddevtest1");
+	skel->rodata->veth_ifindex =3D if_nametoindex("binddevtest1");
+	if (!ASSERT_GT(skel->rodata->veth_ifindex, 0, "if_nametoindex"))
+		goto done;
+
+	if (!ASSERT_OK(setget_sockopt__load(skel), "load skel"))
+		goto done;
+
+	skel->links.skops_sockopt =3D
+		bpf_program__attach_cgroup(skel->progs.skops_sockopt, cg_fd);
+	if (!ASSERT_OK_PTR(skel->links.skops_sockopt, "attach cgroup"))
+		goto done;
+
+	skel->links.socket_post_create =3D
+		bpf_program__attach_cgroup(skel->progs.socket_post_create, cg_fd);
+	if (!ASSERT_OK_PTR(skel->links.socket_post_create, "attach_cgroup"))
+		goto done;
+
+	test_tcp(AF_INET6);
+	test_tcp(AF_INET);
+	test_udp(AF_INET6);
+	test_udp(AF_INET);
+
+done:
+	setget_sockopt__destroy(skel);
+	close(cg_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/setget_sockopt.c b/tools/t=
esting/selftests/bpf/progs/setget_sockopt.c
new file mode 100644
index 000000000000..e52b96cf85fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/setget_sockopt.c
@@ -0,0 +1,538 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) Meta Platforms, Inc. and affiliates. */
+
+#include <stddef.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/in.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/socket.h>
+#include <linux/bpf.h>
+#include <linux/if.h>
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+
+#ifndef SO_TXREHASH
+#define SO_TXREHASH 74
+#endif
+
+#ifndef TCP_NAGLE_OFF
+#define TCP_NAGLE_OFF 1
+#endif
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
+extern unsigned long CONFIG_HZ __kconfig;
+
+const volatile char veth[IFNAMSIZ];
+const volatile int veth_ifindex;
+const char cubic_cc[] =3D "cubic";
+const char reno_cc[] =3D "reno";
+
+int nr_listen;
+int nr_passive;
+int nr_active;
+int nr_connect;
+int nr_binddev;
+int nr_socket_post_create;
+
+struct sockopt_test {
+	int opt;
+	int new;
+	int restore;
+	int expected;
+	int tcp_expected;
+	int toggle:1;
+};
+
+static const struct sockopt_test sol_socket_tests[] =3D {
+	{ .opt =3D SO_SNDBUF, .new =3D 8123, .expected =3D 8123 * 2, },
+	{ .opt =3D SO_RCVBUF, .new =3D 8123, .expected =3D 8123 * 2, },
+	{ .opt =3D SO_KEEPALIVE, .toggle =3D 1, },
+	{ .opt =3D SO_PRIORITY, .new =3D 0xeb9f, .expected =3D 0xeb9f, },
+	{ .opt =3D SO_REUSEPORT, .toggle =3D 1, },
+	{ .opt =3D SO_RCVLOWAT, .new =3D 8123, .expected =3D 8123, },
+	{ .opt =3D SO_MARK, .new =3D 0xeb9f, .expected =3D 0xeb9f, },
+	{ .opt =3D SO_MAX_PACING_RATE, .new =3D 0xeb9f, .expected =3D 0xeb9f, }=
,
+	{ .opt =3D SO_TXREHASH, .toggle =3D 1, },
+	{ .opt =3D 0, },
+};
+
+static const struct sockopt_test sol_tcp_tests[] =3D {
+	{ .opt =3D TCP_NODELAY, .toggle =3D 1, },
+	{ .opt =3D TCP_MAXSEG, .new =3D 1314, .expected =3D 1314, },
+	{ .opt =3D TCP_KEEPIDLE, .new =3D 123, .expected =3D 123, .restore =3D =
321, },
+	{ .opt =3D TCP_KEEPINTVL, .new =3D 123, .expected =3D 123, .restore =3D=
 321, },
+	{ .opt =3D TCP_KEEPCNT, .new =3D 123, .expected =3D 123, .restore =3D 1=
24, },
+	{ .opt =3D TCP_SYNCNT, .new =3D 123, .expected =3D 123, .restore =3D 12=
4, },
+	{ .opt =3D TCP_WINDOW_CLAMP, .new =3D 8123, .expected =3D 8123, .restor=
e =3D 8124, },
+	{ .opt =3D TCP_CONGESTION, },
+	{ .opt =3D TCP_THIN_LINEAR_TIMEOUTS, .toggle =3D 1, },
+	{ .opt =3D TCP_USER_TIMEOUT, .new =3D 123400, .expected =3D 123400, },
+	{ .opt =3D TCP_NOTSENT_LOWAT, .new =3D 1314, .expected =3D 1314, },
+	{ .opt =3D TCP_SAVE_SYN, .new =3D 1, .expected =3D 1, },
+	{ .opt =3D 0, },
+};
+
+static const struct sockopt_test sol_ip_tests[] =3D {
+	{ .opt =3D IP_TOS, .new =3D 0xe1, .expected =3D 0xe1, .tcp_expected =3D=
 0xe0, },
+	{ .opt =3D 0, },
+};
+
+static const struct sockopt_test sol_ipv6_tests[] =3D {
+	{ .opt =3D IPV6_TCLASS, .new =3D 0xe1, .expected =3D 0xe1, .tcp_expecte=
d =3D 0xe0, },
+	{ .opt =3D IPV6_AUTOFLOWLABEL, .toggle =3D 1, },
+	{ .opt =3D 0, },
+};
+
+struct sock_common {
+	unsigned short	skc_family;
+	unsigned long	skc_flags;
+} __attribute__((preserve_access_index));
+
+struct sock {
+	struct sock_common	__sk_common;
+	__u16			sk_type;
+	__u16			sk_protocol;
+	int			sk_rcvlowat;
+	__u32			sk_mark;
+	unsigned long		sk_max_pacing_rate;
+	unsigned int		keepalive_time;
+	unsigned int		keepalive_intvl;
+} __attribute__((preserve_access_index));
+
+struct tcp_options_received {
+	__u16 user_mss;
+} __attribute__((preserve_access_index));
+
+struct ipv6_pinfo {
+	__u16			recverr:1,
+				sndflow:1,
+				repflow:1,
+				pmtudisc:3,
+				padding:1,
+				srcprefs:3,
+				dontfrag:1,
+				autoflowlabel:1,
+				autoflowlabel_set:1,
+				mc_all:1,
+				recverr_rfc4884:1,
+				rtalert_isolate:1;
+}  __attribute__((preserve_access_index));
+
+struct inet_sock {
+	/* sk and pinet6 has to be the first two members of inet_sock */
+	struct sock		sk;
+	struct ipv6_pinfo	*pinet6;
+} __attribute__((preserve_access_index));
+
+struct inet_connection_sock {
+	__u32			  icsk_user_timeout;
+	__u8			  icsk_syn_retries;
+} __attribute__((preserve_access_index));
+
+struct tcp_sock {
+	struct inet_connection_sock	inet_conn;
+	struct tcp_options_received rx_opt;
+	__u8	save_syn:2,
+		syn_data:1,
+		syn_fastopen:1,
+		syn_fastopen_exp:1,
+		syn_fastopen_ch:1,
+		syn_data_acked:1,
+		is_cwnd_limited:1;
+	__u32	window_clamp;
+	__u8	nonagle     : 4,
+		thin_lto    : 1,
+		recvmsg_inq : 1,
+		repair      : 1,
+		frto        : 1;
+	__u32	notsent_lowat;
+	__u8	keepalive_probes;
+	unsigned int		keepalive_time;
+	unsigned int		keepalive_intvl;
+} __attribute__((preserve_access_index));
+
+struct socket {
+	struct sock *sk;
+} __attribute__((preserve_access_index));
+
+struct loop_ctx {
+	void *ctx;
+	struct sock *sk;
+};
+
+static int __bpf_getsockopt(void *ctx, struct sock *sk,
+			    int level, int opt, int *optval,
+			    int optlen)
+{
+	if (level =3D=3D SOL_SOCKET) {
+		switch (opt) {
+		case SO_KEEPALIVE:
+			*optval =3D !!(sk->__sk_common.skc_flags & (1UL << 3));
+			break;
+		case SO_RCVLOWAT:
+			*optval =3D sk->sk_rcvlowat;
+			break;
+		case SO_MARK:
+			*optval =3D sk->sk_mark;
+			break;
+		case SO_MAX_PACING_RATE:
+			*optval =3D sk->sk_max_pacing_rate;
+			break;
+		default:
+			return bpf_getsockopt(ctx, level, opt, optval, optlen);
+		}
+		return 0;
+	}
+
+	if (level =3D=3D IPPROTO_TCP) {
+		struct tcp_sock *tp =3D bpf_skc_to_tcp_sock(sk);
+
+		if (!tp)
+			return -1;
+
+		switch (opt) {
+		case TCP_NODELAY:
+			*optval =3D !!(tp->nonagle & TCP_NAGLE_OFF);
+			break;
+		case TCP_MAXSEG:
+			*optval =3D tp->rx_opt.user_mss;
+			break;
+		case TCP_KEEPIDLE:
+			*optval =3D tp->keepalive_time / CONFIG_HZ;
+			break;
+		case TCP_SYNCNT:
+			*optval =3D tp->inet_conn.icsk_syn_retries;
+			break;
+		case TCP_KEEPINTVL:
+			*optval =3D tp->keepalive_intvl / CONFIG_HZ;
+			break;
+		case TCP_KEEPCNT:
+			*optval =3D tp->keepalive_probes;
+			break;
+		case TCP_WINDOW_CLAMP:
+			*optval =3D tp->window_clamp;
+			break;
+		case TCP_THIN_LINEAR_TIMEOUTS:
+			*optval =3D tp->thin_lto;
+			break;
+		case TCP_USER_TIMEOUT:
+			*optval =3D tp->inet_conn.icsk_user_timeout;
+			break;
+		case TCP_NOTSENT_LOWAT:
+			*optval =3D tp->notsent_lowat;
+			break;
+		case TCP_SAVE_SYN:
+			*optval =3D tp->save_syn;
+			break;
+		default:
+			return bpf_getsockopt(ctx, level, opt, optval, optlen);
+		}
+		return 0;
+	}
+
+	if (level =3D=3D IPPROTO_IPV6) {
+		switch (opt) {
+		case IPV6_AUTOFLOWLABEL: {
+			__u16 proto =3D sk->sk_protocol;
+			struct inet_sock *inet_sk;
+
+			if (proto =3D=3D IPPROTO_TCP)
+				inet_sk =3D (struct inet_sock *)bpf_skc_to_tcp_sock(sk);
+			else
+				inet_sk =3D (struct inet_sock *)bpf_skc_to_udp6_sock(sk);
+
+			if (!inet_sk)
+				return -1;
+
+			*optval =3D !!inet_sk->pinet6->autoflowlabel;
+			break;
+		}
+		default:
+			return bpf_getsockopt(ctx, level, opt, optval, optlen);
+		}
+		return 0;
+	}
+
+	return bpf_getsockopt(ctx, level, opt, optval, optlen);
+}
+
+static int bpf_test_sockopt_flip(void *ctx, struct sock *sk,
+				 const struct sockopt_test *t,
+				 int level)
+{
+	int old, tmp, new, opt =3D t->opt;
+
+	opt =3D t->opt;
+
+	if (__bpf_getsockopt(ctx, sk, level, opt, &old, sizeof(old)))
+		return 1;
+	/* kernel initialized txrehash to 255 */
+	if (level =3D=3D SOL_SOCKET && opt =3D=3D SO_TXREHASH && old !=3D 0 && =
old !=3D 1)
+		old =3D 1;
+
+	new =3D !old;
+	if (bpf_setsockopt(ctx, level, opt, &new, sizeof(new)))
+		return 1;
+	if (__bpf_getsockopt(ctx, sk, level, opt, &tmp, sizeof(tmp)) ||
+	    tmp !=3D new)
+		return 1;
+
+	if (bpf_setsockopt(ctx, level, opt, &old, sizeof(old)))
+		return 1;
+
+	return 0;
+}
+
+static int bpf_test_sockopt_int(void *ctx, struct sock *sk,
+				const struct sockopt_test *t,
+				int level)
+{
+	int old, tmp, new, expected, opt;
+
+	opt =3D t->opt;
+	new =3D t->new;
+	if (sk->sk_type =3D=3D SOCK_STREAM && t->tcp_expected)
+		expected =3D t->tcp_expected;
+	else
+		expected =3D t->expected;
+
+	if (__bpf_getsockopt(ctx, sk, level, opt, &old, sizeof(old)) ||
+	    old =3D=3D new)
+		return 1;
+
+	if (bpf_setsockopt(ctx, level, opt, &new, sizeof(new)))
+		return 1;
+	if (__bpf_getsockopt(ctx, sk, level, opt, &tmp, sizeof(tmp)) ||
+	    tmp !=3D expected)
+		return 1;
+
+	if (t->restore)
+		old =3D t->restore;
+	if (bpf_setsockopt(ctx, level, opt, &old, sizeof(old)))
+		return 1;
+
+	return 0;
+}
+
+static int bpf_test_socket_sockopt(__u32 i, struct loop_ctx *lc)
+{
+	const struct sockopt_test *t;
+
+	if (i >=3D ARRAY_SIZE(sol_socket_tests))
+		return 1;
+
+	t =3D &sol_socket_tests[i];
+	if (!t->opt)
+		return 1;
+
+	if (t->toggle)
+		return bpf_test_sockopt_flip(lc->ctx, lc->sk, t, SOL_SOCKET);
+
+	return bpf_test_sockopt_int(lc->ctx, lc->sk, t, SOL_SOCKET);
+}
+
+static int bpf_test_ip_sockopt(__u32 i, struct loop_ctx *lc)
+{
+	const struct sockopt_test *t;
+
+	if (i >=3D ARRAY_SIZE(sol_ip_tests))
+		return 1;
+
+	t =3D &sol_ip_tests[i];
+	if (!t->opt)
+		return 1;
+
+	if (t->toggle)
+		return bpf_test_sockopt_flip(lc->ctx, lc->sk, t, IPPROTO_IP);
+
+	return bpf_test_sockopt_int(lc->ctx, lc->sk, t, IPPROTO_IP);
+}
+
+static int bpf_test_ipv6_sockopt(__u32 i, struct loop_ctx *lc)
+{
+	const struct sockopt_test *t;
+
+	if (i >=3D ARRAY_SIZE(sol_ipv6_tests))
+		return 1;
+
+	t =3D &sol_ipv6_tests[i];
+	if (!t->opt)
+		return 1;
+
+	if (t->toggle)
+		return bpf_test_sockopt_flip(lc->ctx, lc->sk, t, IPPROTO_IPV6);
+
+	return bpf_test_sockopt_int(lc->ctx, lc->sk, t, IPPROTO_IPV6);
+}
+
+static int bpf_test_tcp_sockopt(__u32 i, struct loop_ctx *lc)
+{
+	const struct sockopt_test *t;
+	struct sock *sk;
+	void *ctx;
+
+	if (i >=3D ARRAY_SIZE(sol_tcp_tests))
+		return 1;
+
+	t =3D &sol_tcp_tests[i];
+	if (!t->opt)
+		return 1;
+
+	ctx =3D lc->ctx;
+	sk =3D lc->sk;
+
+	if (t->opt =3D=3D TCP_CONGESTION) {
+		char old_cc[16], tmp_cc[16];
+		const char *new_cc;
+
+		if (bpf_getsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, old_cc, sizeof(ol=
d_cc)))
+			return 1;
+		if (!bpf_strncmp(old_cc, sizeof(old_cc), cubic_cc))
+			new_cc =3D reno_cc;
+		else
+			new_cc =3D cubic_cc;
+		if (bpf_setsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, (void *)new_cc,
+				   sizeof(new_cc)))
+			return 1;
+		if (bpf_getsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, tmp_cc, sizeof(tm=
p_cc)))
+			return 1;
+		if (bpf_strncmp(tmp_cc, sizeof(tmp_cc), new_cc))
+			return 1;
+		if (bpf_setsockopt(ctx, IPPROTO_TCP, TCP_CONGESTION, old_cc, sizeof(ol=
d_cc)))
+			return 1;
+		return 0;
+	}
+
+	if (t->toggle)
+		return bpf_test_sockopt_flip(ctx, sk, t, IPPROTO_TCP);
+
+	return bpf_test_sockopt_int(ctx, sk, t, IPPROTO_TCP);
+}
+
+static int bpf_test_sockopt(void *ctx, struct sock *sk)
+{
+	struct loop_ctx lc =3D { .ctx =3D ctx, .sk =3D sk, };
+	__u16 family, proto;
+	int n;
+
+	family =3D sk->__sk_common.skc_family;
+	proto =3D sk->sk_protocol;
+
+	n =3D bpf_loop(ARRAY_SIZE(sol_socket_tests), bpf_test_socket_sockopt, &=
lc, 0);
+	if (n !=3D ARRAY_SIZE(sol_socket_tests))
+		return -1;
+
+	if (proto =3D=3D IPPROTO_TCP) {
+		n =3D bpf_loop(ARRAY_SIZE(sol_tcp_tests), bpf_test_tcp_sockopt, &lc, 0=
);
+		if (n !=3D ARRAY_SIZE(sol_tcp_tests))
+			return -1;
+	}
+
+	if (family =3D=3D AF_INET) {
+		n =3D bpf_loop(ARRAY_SIZE(sol_ip_tests), bpf_test_ip_sockopt, &lc, 0);
+		if (n !=3D ARRAY_SIZE(sol_ip_tests))
+			return -1;
+	} else {
+		n =3D bpf_loop(ARRAY_SIZE(sol_ipv6_tests), bpf_test_ipv6_sockopt, &lc,=
 0);
+		if (n !=3D ARRAY_SIZE(sol_ipv6_tests))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int binddev_test(void *ctx)
+{
+	const char empty_ifname[] =3D "";
+	int ifindex, zero =3D 0;
+
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
+			   (void *)veth, sizeof(veth)))
+		return -1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &ifindex, sizeof(int)) ||
+	    ifindex !=3D veth_ifindex)
+		return -1;
+
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
+			   (void *)empty_ifname, sizeof(empty_ifname)))
+		return -1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &ifindex, sizeof(int)) ||
+	    ifindex !=3D 0)
+		return -1;
+
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   (void *)&veth_ifindex, sizeof(int)))
+		return -1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &ifindex, sizeof(int)) ||
+	    ifindex !=3D veth_ifindex)
+		return -1;
+
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &zero, sizeof(int)))
+		return -1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &ifindex, sizeof(int)) ||
+	    ifindex !=3D 0)
+		return -1;
+
+	return 0;
+}
+
+SEC("lsm_cgroup/socket_post_create")
+int BPF_PROG(socket_post_create, struct socket *sock, int family,
+	     int type, int protocol, int kern)
+{
+	struct sock *sk =3D sock->sk;
+
+	if (!sk)
+		return 1;
+
+	nr_socket_post_create +=3D !bpf_test_sockopt(sk, sk);
+	nr_binddev +=3D !binddev_test(sk);
+
+	return 1;
+}
+
+SEC("sockops")
+int skops_sockopt(struct bpf_sock_ops *skops)
+{
+	struct bpf_sock *bpf_sk =3D skops->sk;
+	struct sock *sk;
+
+	if (!bpf_sk)
+		return 1;
+
+	sk =3D (struct sock *)bpf_skc_to_tcp_sock(bpf_sk);
+	if (!sk)
+		return 1;
+
+	switch (skops->op) {
+	case BPF_SOCK_OPS_TCP_LISTEN_CB:
+		nr_listen +=3D !bpf_test_sockopt(skops, sk);
+		break;
+	case BPF_SOCK_OPS_TCP_CONNECT_CB:
+		nr_connect +=3D !bpf_test_sockopt(skops, sk);
+		break;
+	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
+		nr_active +=3D !bpf_test_sockopt(skops, sk);
+		break;
+	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
+		nr_passive +=3D !bpf_test_sockopt(skops, sk);
+		break;
+	}
+
+	return 1;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.30.2

