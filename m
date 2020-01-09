Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD73613508A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgAIAf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:35:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52570 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727237AbgAIAf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:35:28 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0090VxU5004565
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 16:35:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=AS8Kv+6G8pnvet/Y+c5TO3Qo+KSaQQLTwAP48M2SgWo=;
 b=m+BY2v/OJmlP7EAw5rLXv+X/30s0rPnuCLLCrskq/Nv0QPdlxX1Wq46fE79xoXvMgzkK
 ujYZZkc1TJJ0j+SNQc9cz1rVok2xvKz2SFkztpIOn0IdzR/wsCLHiyfHoMe2JjBknYc4
 6kxMzwGdkG2Tdt4KLgXlyiFn0SNZ03lrhxA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd3ep6gxn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 16:35:25 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 16:35:24 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3BBFC2942576; Wed,  8 Jan 2020 16:35:17 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 11/11] bpf: Add bpf_dctcp example
Date:   Wed, 8 Jan 2020 16:35:17 -0800
Message-ID: <20200109003517.3856825-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a bpf_dctcp example.  It currently does not do
no-ECN fallback but the same could be done through the cgrp2-bpf.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 187 ++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
 3 files changed, 625 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
new file mode 100644
index 000000000000..7da3e8db3adf
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -0,0 +1,228 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BPF_TCP_HELPERS_H
+#define __BPF_TCP_HELPERS_H
+
+#include <stdbool.h>
+#include <linux/types.h>
+#include <bpf_helpers.h>
+#include <bpf_core_read.h>
+#include "bpf_trace_helpers.h"
+
+/* "struct_ops/" is only a convention.  not a requirement. */
+#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, "struct_ops/"#fname, fname, ret_type, __VA_ARGS__)
+#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, "struct_ops/"#fname, fname, ret_type, __VA_ARGS__)
+#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, "struct_ops/"#fname, fname, ret_type, __VA_ARGS__)
+#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, "struct_ops/"#fname, fname, ret_type, __VA_ARGS__)
+#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, "struct_ops/"#fname, fname, ret_type, __VA_ARGS__)
+#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, "struct_ops/"#fname, fname, ret_type, __VA_ARGS__)
+
+struct sock_common {
+	unsigned char	skc_state;
+} __attribute__((preserve_access_index));
+
+struct sock {
+	struct sock_common	__sk_common;
+} __attribute__((preserve_access_index));
+
+struct inet_sock {
+	struct sock		sk;
+} __attribute__((preserve_access_index));
+
+struct inet_connection_sock {
+	struct inet_sock	  icsk_inet;
+	__u8			  icsk_ca_state:6,
+				  icsk_ca_setsockopt:1,
+				  icsk_ca_dst_locked:1;
+	struct {
+		__u8		  pending;
+	} icsk_ack;
+	__u64			  icsk_ca_priv[104 / sizeof(__u64)];
+} __attribute__((preserve_access_index));
+
+struct tcp_sock {
+	struct inet_connection_sock	inet_conn;
+
+	__u32	rcv_nxt;
+	__u32	snd_nxt;
+	__u32	snd_una;
+	__u8	ecn_flags;
+	__u32	delivered;
+	__u32	delivered_ce;
+	__u32	snd_cwnd;
+	__u32	snd_cwnd_cnt;
+	__u32	snd_cwnd_clamp;
+	__u32	snd_ssthresh;
+	__u8	syn_data:1,	/* SYN includes data */
+		syn_fastopen:1,	/* SYN includes Fast Open option */
+		syn_fastopen_exp:1,/* SYN includes Fast Open exp. option */
+		syn_fastopen_ch:1, /* Active TFO re-enabling probe */
+		syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
+		save_syn:1,	/* Save headers of SYN packet */
+		is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
+		syn_smc:1;	/* SYN includes SMC */
+	__u32	max_packets_out;
+	__u32	lsndtime;
+	__u32	prior_cwnd;
+} __attribute__((preserve_access_index));
+
+static __always_inline struct inet_connection_sock *inet_csk(const struct sock *sk)
+{
+	return (struct inet_connection_sock *)sk;
+}
+
+static __always_inline void *inet_csk_ca(const struct sock *sk)
+{
+	return (void *)inet_csk(sk)->icsk_ca_priv;
+}
+
+static __always_inline struct tcp_sock *tcp_sk(const struct sock *sk)
+{
+	return (struct tcp_sock *)sk;
+}
+
+static __always_inline bool before(__u32 seq1, __u32 seq2)
+{
+	return (__s32)(seq1-seq2) < 0;
+}
+#define after(seq2, seq1) 	before(seq1, seq2)
+
+#define	TCP_ECN_OK		1
+#define	TCP_ECN_QUEUE_CWR	2
+#define	TCP_ECN_DEMAND_CWR	4
+#define	TCP_ECN_SEEN		8
+
+enum inet_csk_ack_state_t {
+	ICSK_ACK_SCHED	= 1,
+	ICSK_ACK_TIMER  = 2,
+	ICSK_ACK_PUSHED = 4,
+	ICSK_ACK_PUSHED2 = 8,
+	ICSK_ACK_NOW = 16	/* Send the next ACK immediately (once) */
+};
+
+enum tcp_ca_event {
+	CA_EVENT_TX_START = 0,
+	CA_EVENT_CWND_RESTART = 1,
+	CA_EVENT_COMPLETE_CWR = 2,
+	CA_EVENT_LOSS = 3,
+	CA_EVENT_ECN_NO_CE = 4,
+	CA_EVENT_ECN_IS_CE = 5,
+};
+
+enum tcp_ca_state {
+	TCP_CA_Open = 0,
+	TCP_CA_Disorder = 1,
+	TCP_CA_CWR = 2,
+	TCP_CA_Recovery = 3,
+	TCP_CA_Loss = 4
+};
+
+struct ack_sample {
+	__u32 pkts_acked;
+	__s32 rtt_us;
+	__u32 in_flight;
+} __attribute__((preserve_access_index));
+
+struct rate_sample {
+	__u64  prior_mstamp; /* starting timestamp for interval */
+	__u32  prior_delivered;	/* tp->delivered at "prior_mstamp" */
+	__s32  delivered;		/* number of packets delivered over interval */
+	long interval_us;	/* time for tp->delivered to incr "delivered" */
+	__u32 snd_interval_us;	/* snd interval for delivered packets */
+	__u32 rcv_interval_us;	/* rcv interval for delivered packets */
+	long rtt_us;		/* RTT of last (S)ACKed packet (or -1) */
+	int  losses;		/* number of packets marked lost upon ACK */
+	__u32  acked_sacked;	/* number of packets newly (S)ACKed upon ACK */
+	__u32  prior_in_flight;	/* in flight before this ACK */
+	bool is_app_limited;	/* is sample from packet with bubble in pipe? */
+	bool is_retrans;	/* is sample from retransmission? */
+	bool is_ack_delayed;	/* is this (likely) a delayed ACK? */
+} __attribute__((preserve_access_index));
+
+#define TCP_CA_NAME_MAX		16
+#define TCP_CONG_NEEDS_ECN	0x2
+
+struct tcp_congestion_ops {
+	char name[TCP_CA_NAME_MAX];
+	__u32 flags;
+
+	/* initialize private data (optional) */
+	void (*init)(struct sock *sk);
+	/* cleanup private data  (optional) */
+	void (*release)(struct sock *sk);
+
+	/* return slow start threshold (required) */
+	__u32 (*ssthresh)(struct sock *sk);
+	/* do new cwnd calculation (required) */
+	void (*cong_avoid)(struct sock *sk, __u32 ack, __u32 acked);
+	/* call before changing ca_state (optional) */
+	void (*set_state)(struct sock *sk, __u8 new_state);
+	/* call when cwnd event occurs (optional) */
+	void (*cwnd_event)(struct sock *sk, enum tcp_ca_event ev);
+	/* call when ack arrives (optional) */
+	void (*in_ack_event)(struct sock *sk, __u32 flags);
+	/* new value of cwnd after loss (required) */
+	__u32  (*undo_cwnd)(struct sock *sk);
+	/* hook for packet ack accounting (optional) */
+	void (*pkts_acked)(struct sock *sk, const struct ack_sample *sample);
+	/* override sysctl_tcp_min_tso_segs */
+	__u32 (*min_tso_segs)(struct sock *sk);
+	/* returns the multiplier used in tcp_sndbuf_expand (optional) */
+	__u32 (*sndbuf_expand)(struct sock *sk);
+	/* call when packets are delivered to update cwnd and pacing rate,
+	 * after all the ca_state processing. (optional)
+	 */
+	void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
+};
+
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#define max(a, b) ((a) > (b) ? (a) : (b))
+#define min_not_zero(x, y) ({			\
+	typeof(x) __x = (x);			\
+	typeof(y) __y = (y);			\
+	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
+
+static __always_inline __u32 tcp_slow_start(struct tcp_sock *tp, __u32 acked)
+{
+	__u32 cwnd = min(tp->snd_cwnd + acked, tp->snd_ssthresh);
+
+	acked -= cwnd - tp->snd_cwnd;
+	tp->snd_cwnd = min(cwnd, tp->snd_cwnd_clamp);
+
+	return acked;
+}
+
+static __always_inline bool tcp_in_slow_start(const struct tcp_sock *tp)
+{
+	return tp->snd_cwnd < tp->snd_ssthresh;
+}
+
+static __always_inline bool tcp_is_cwnd_limited(const struct sock *sk)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+
+	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
+	if (tcp_in_slow_start(tp))
+		return tp->snd_cwnd < 2 * tp->max_packets_out;
+
+	return !!BPF_CORE_READ_BITFIELD(tp, is_cwnd_limited);
+}
+
+static __always_inline void tcp_cong_avoid_ai(struct tcp_sock *tp, __u32 w, __u32 acked)
+{
+	/* If credits accumulated at a higher w, apply them gently now. */
+	if (tp->snd_cwnd_cnt >= w) {
+		tp->snd_cwnd_cnt = 0;
+		tp->snd_cwnd++;
+	}
+
+	tp->snd_cwnd_cnt += acked;
+	if (tp->snd_cwnd_cnt >= w) {
+		__u32 delta = tp->snd_cwnd_cnt / w;
+
+		tp->snd_cwnd_cnt -= delta * w;
+		tp->snd_cwnd += delta;
+	}
+	tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_cwnd_clamp);
+}
+
+#endif
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
new file mode 100644
index 000000000000..517318f05b1d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+
+#include <linux/err.h>
+#include <test_progs.h>
+#include "bpf_dctcp.skel.h"
+
+#define min(a, b) ((a) < (b) ? (a) : (b))
+
+static const unsigned int total_bytes = 10 * 1024 * 1024;
+static const struct timeval timeo_sec = { .tv_sec = 10 };
+static const size_t timeo_optlen = sizeof(timeo_sec);
+static int stop, duration;
+
+static int settimeo(int fd)
+{
+	int err;
+
+	err = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo_sec,
+			 timeo_optlen);
+	if (CHECK(err == -1, "setsockopt(fd, SO_RCVTIMEO)", "errno:%d\n",
+		  errno))
+		return -1;
+
+	err = setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo_sec,
+			 timeo_optlen);
+	if (CHECK(err == -1, "setsockopt(fd, SO_SNDTIMEO)", "errno:%d\n",
+		  errno))
+		return -1;
+
+	return 0;
+}
+
+static int settcpca(int fd, const char *tcp_ca)
+{
+	int err;
+
+	err = setsockopt(fd, IPPROTO_TCP, TCP_CONGESTION, tcp_ca, strlen(tcp_ca));
+	if (CHECK(err == -1, "setsockopt(fd, TCP_CONGESTION)", "errno:%d\n",
+		  errno))
+		return -1;
+
+	return 0;
+}
+
+static void *server(void *arg)
+{
+	int lfd = (int)(long)arg, err = 0, fd;
+	ssize_t nr_sent = 0, bytes = 0;
+	char batch[1500];
+
+	fd = accept(lfd, NULL, NULL);
+	while (fd == -1) {
+		if (errno == EINTR)
+			continue;
+		err = -errno;
+		goto done;
+	}
+
+	if (settimeo(fd)) {
+		err = -errno;
+		goto done;
+	}
+
+	while (bytes < total_bytes && !READ_ONCE(stop)) {
+		nr_sent = send(fd, &batch,
+			       min(total_bytes - bytes, sizeof(batch)), 0);
+		if (nr_sent == -1 && errno == EINTR)
+			continue;
+		if (nr_sent == -1) {
+			err = -errno;
+			break;
+		}
+		bytes += nr_sent;
+	}
+
+	CHECK(bytes != total_bytes, "send", "%zd != %u nr_sent:%zd errno:%d\n",
+	      bytes, total_bytes, nr_sent, errno);
+
+done:
+	if (fd != -1)
+		close(fd);
+	if (err) {
+		WRITE_ONCE(stop, 1);
+		return ERR_PTR(err);
+	}
+	return NULL;
+}
+
+static void do_test(const char *tcp_ca)
+{
+	struct sockaddr_in6 sa6 = {};
+	ssize_t nr_recv = 0, bytes = 0;
+	int lfd = -1, fd = -1;
+	pthread_t srv_thread;
+	socklen_t addrlen = sizeof(sa6);
+	void *thread_ret;
+	char batch[1500];
+	int err;
+
+	WRITE_ONCE(stop, 0);
+
+	lfd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (CHECK(lfd == -1, "socket", "errno:%d\n", errno))
+		return;
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (CHECK(fd == -1, "socket", "errno:%d\n", errno)) {
+		close(lfd);
+		return;
+	}
+
+	if (settcpca(lfd, tcp_ca) || settcpca(fd, tcp_ca) ||
+	    settimeo(lfd) || settimeo(fd))
+		goto done;
+
+	/* bind, listen and start server thread to accept */
+	sa6.sin6_family = AF_INET6;
+	sa6.sin6_addr = in6addr_loopback;
+	err = bind(lfd, (struct sockaddr *)&sa6, addrlen);
+	if (CHECK(err == -1, "bind", "errno:%d\n", errno))
+		goto done;
+	err = getsockname(lfd, (struct sockaddr *)&sa6, &addrlen);
+	if (CHECK(err == -1, "getsockname", "errno:%d\n", errno))
+		goto done;
+	err = listen(lfd, 1);
+	if (CHECK(err == -1, "listen", "errno:%d\n", errno))
+		goto done;
+	err = pthread_create(&srv_thread, NULL, server, (void *)(long)lfd);
+	if (CHECK(err != 0, "pthread_create", "err:%d\n", err))
+		goto done;
+
+	/* connect to server */
+	err = connect(fd, (struct sockaddr *)&sa6, addrlen);
+	if (CHECK(err == -1, "connect", "errno:%d\n", errno))
+		goto wait_thread;
+
+	/* recv total_bytes */
+	while (bytes < total_bytes && !READ_ONCE(stop)) {
+		nr_recv = recv(fd, &batch,
+			       min(total_bytes - bytes, sizeof(batch)), 0);
+		if (nr_recv == -1 && errno == EINTR)
+			continue;
+		if (nr_recv == -1)
+			break;
+		bytes += nr_recv;
+	}
+
+	CHECK(bytes != total_bytes, "recv", "%zd != %u nr_recv:%zd errno:%d\n",
+	      bytes, total_bytes, nr_recv, errno);
+
+wait_thread:
+	WRITE_ONCE(stop, 1);
+	pthread_join(srv_thread, &thread_ret);
+	CHECK(IS_ERR(thread_ret), "pthread_join", "thread_ret:%ld",
+	      PTR_ERR(thread_ret));
+done:
+	close(lfd);
+	close(fd);
+}
+
+static void test_dctcp(void)
+{
+	struct bpf_dctcp *dctcp_skel;
+	struct bpf_link *link;
+
+	dctcp_skel = bpf_dctcp__open_and_load();
+	if (CHECK(!dctcp_skel, "bpf_dctcp__open_and_load", "failed\n"))
+		return;
+
+	link = bpf_map__attach_struct_ops(dctcp_skel->maps.dctcp);
+	if (CHECK(IS_ERR(link), "bpf_map__attach_struct_ops", "err:%ld\n",
+		  PTR_ERR(link))) {
+		bpf_dctcp__destroy(dctcp_skel);
+		return;
+	}
+
+	do_test("bpf_dctcp");
+
+	bpf_link__destroy(link);
+	bpf_dctcp__destroy(dctcp_skel);
+}
+
+void test_bpf_tcp_ca(void)
+{
+	if (test__start_subtest("dctcp"))
+		test_dctcp();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
new file mode 100644
index 000000000000..5f9b613663e5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook */
+
+/* WARNING: This implemenation is not necessarily the same
+ * as the tcp_dctcp.c.  The purpose is mainly for testing
+ * the kernel BPF logic.
+ */
+
+#include <linux/bpf.h>
+#include <linux/types.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+#define DCTCP_MAX_ALPHA	1024U
+
+struct dctcp {
+	__u32 old_delivered;
+	__u32 old_delivered_ce;
+	__u32 prior_rcv_nxt;
+	__u32 dctcp_alpha;
+	__u32 next_seq;
+	__u32 ce_state;
+	__u32 loss_cwnd;
+};
+
+static unsigned int dctcp_shift_g = 4; /* g = 1/2^4 */
+static unsigned int dctcp_alpha_on_init = DCTCP_MAX_ALPHA;
+
+static __always_inline void dctcp_reset(const struct tcp_sock *tp,
+					struct dctcp *ca)
+{
+	ca->next_seq = tp->snd_nxt;
+
+	ca->old_delivered = tp->delivered;
+	ca->old_delivered_ce = tp->delivered_ce;
+}
+
+BPF_TCP_OPS_1(dctcp_init, void, struct sock *, sk)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	struct dctcp *ca = inet_csk_ca(sk);
+
+	ca->prior_rcv_nxt = tp->rcv_nxt;
+	ca->dctcp_alpha = min(dctcp_alpha_on_init, DCTCP_MAX_ALPHA);
+	ca->loss_cwnd = 0;
+	ca->ce_state = 0;
+
+	dctcp_reset(tp, ca);
+}
+
+BPF_TCP_OPS_1(dctcp_ssthresh, __u32, struct sock *, sk)
+{
+	struct dctcp *ca = inet_csk_ca(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	ca->loss_cwnd = tp->snd_cwnd;
+	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->dctcp_alpha) >> 11U), 2U);
+}
+
+BPF_TCP_OPS_2(dctcp_update_alpha, void,
+	      struct sock *, sk, __u32, flags)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	struct dctcp *ca = inet_csk_ca(sk);
+
+	/* Expired RTT */
+	if (!before(tp->snd_una, ca->next_seq)) {
+		__u32 delivered_ce = tp->delivered_ce - ca->old_delivered_ce;
+		__u32 alpha = ca->dctcp_alpha;
+
+		/* alpha = (1 - g) * alpha + g * F */
+
+		alpha -= min_not_zero(alpha, alpha >> dctcp_shift_g);
+		if (delivered_ce) {
+			__u32 delivered = tp->delivered - ca->old_delivered;
+
+			/* If dctcp_shift_g == 1, a 32bit value would overflow
+			 * after 8 M packets.
+			 */
+			delivered_ce <<= (10 - dctcp_shift_g);
+			delivered_ce /= max(1U, delivered);
+
+			alpha = min(alpha + delivered_ce, DCTCP_MAX_ALPHA);
+		}
+		ca->dctcp_alpha = alpha;
+		dctcp_reset(tp, ca);
+	}
+}
+
+static __always_inline void dctcp_react_to_loss(struct sock *sk)
+{
+	struct dctcp *ca = inet_csk_ca(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	ca->loss_cwnd = tp->snd_cwnd;
+	tp->snd_ssthresh = max(tp->snd_cwnd >> 1U, 2U);
+}
+
+BPF_TCP_OPS_2(dctcp_state, void, struct sock *, sk, __u8, new_state)
+{
+	if (new_state == TCP_CA_Recovery &&
+	    new_state != BPF_CORE_READ_BITFIELD(inet_csk(sk), icsk_ca_state))
+		dctcp_react_to_loss(sk);
+	/* We handle RTO in dctcp_cwnd_event to ensure that we perform only
+	 * one loss-adjustment per RTT.
+	 */
+}
+
+static __always_inline void dctcp_ece_ack_cwr(struct sock *sk, __u32 ce_state)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (ce_state == 1)
+		tp->ecn_flags |= TCP_ECN_DEMAND_CWR;
+	else
+		tp->ecn_flags &= ~TCP_ECN_DEMAND_CWR;
+}
+
+/* Minimal DCTP CE state machine:
+ *
+ * S:	0 <- last pkt was non-CE
+ *	1 <- last pkt was CE
+ */
+static __always_inline
+void dctcp_ece_ack_update(struct sock *sk, enum tcp_ca_event evt,
+			  __u32 *prior_rcv_nxt, __u32 *ce_state)
+{
+	__u32 new_ce_state = (evt == CA_EVENT_ECN_IS_CE) ? 1 : 0;
+
+	if (*ce_state != new_ce_state) {
+		/* CE state has changed, force an immediate ACK to
+		 * reflect the new CE state. If an ACK was delayed,
+		 * send that first to reflect the prior CE state.
+		 */
+		if (inet_csk(sk)->icsk_ack.pending & ICSK_ACK_TIMER) {
+			dctcp_ece_ack_cwr(sk, *ce_state);
+			bpf_tcp_send_ack(sk, *prior_rcv_nxt);
+		}
+		inet_csk(sk)->icsk_ack.pending |= ICSK_ACK_NOW;
+	}
+	*prior_rcv_nxt = tcp_sk(sk)->rcv_nxt;
+	*ce_state = new_ce_state;
+	dctcp_ece_ack_cwr(sk, new_ce_state);
+}
+
+BPF_TCP_OPS_2(dctcp_cwnd_event, void,
+	      struct sock *, sk, enum tcp_ca_event, ev)
+{
+	struct dctcp *ca = inet_csk_ca(sk);
+
+	switch (ev) {
+	case CA_EVENT_ECN_IS_CE:
+	case CA_EVENT_ECN_NO_CE:
+		dctcp_ece_ack_update(sk, ev, &ca->prior_rcv_nxt, &ca->ce_state);
+		break;
+	case CA_EVENT_LOSS:
+		dctcp_react_to_loss(sk);
+		break;
+	default:
+		/* Don't care for the rest. */
+		break;
+	}
+}
+
+BPF_TCP_OPS_1(dctcp_cwnd_undo, __u32, struct sock *, sk)
+{
+	const struct dctcp *ca = inet_csk_ca(sk);
+
+	return max(tcp_sk(sk)->snd_cwnd, ca->loss_cwnd);
+}
+
+BPF_TCP_OPS_3(tcp_reno_cong_avoid, void,
+	      struct sock *, sk, __u32, ack, __u32, acked)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!tcp_is_cwnd_limited(sk))
+		return;
+
+	/* In "safe" area, increase. */
+	if (tcp_in_slow_start(tp)) {
+		acked = tcp_slow_start(tp, acked);
+		if (!acked)
+			return;
+	}
+	/* In dangerous area, increase slowly. */
+	tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+}
+
+SEC(".struct_ops")
+struct tcp_congestion_ops dctcp_nouse = {
+	.init		= (void *)dctcp_init,
+	.set_state	= (void *)dctcp_state,
+	.flags		= TCP_CONG_NEEDS_ECN,
+	.name		= "bpf_dctcp_nouse",
+};
+
+SEC(".struct_ops")
+struct tcp_congestion_ops dctcp = {
+	.init		= (void *)dctcp_init,
+	.in_ack_event   = (void *)dctcp_update_alpha,
+	.cwnd_event	= (void *)dctcp_cwnd_event,
+	.ssthresh	= (void *)dctcp_ssthresh,
+	.cong_avoid	= (void *)tcp_reno_cong_avoid,
+	.undo_cwnd	= (void *)dctcp_cwnd_undo,
+	.set_state	= (void *)dctcp_state,
+	.flags		= TCP_CONG_NEEDS_ECN,
+	.name		= "bpf_dctcp",
+};
-- 
2.17.1

