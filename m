Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679DB145F31
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAVXhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:37:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38040 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgAVXhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:37:09 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MNZuc2008183
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:37:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=byQ5foPb0AbnmpgQSvw+oedw/7jFrrDzbR15ZZXze9M=;
 b=MbgFo0YN+nzcg3vLRlk7Af1+NiAlXN8Q8VG6RVUb7urMBdAXcIyYq+HmCO6K92Okqth4
 BfXwU7hV0f2H9IynzVMDabXl8r21fpsDhH2ofQmTPxzt9DONb5A58w1YcELUCetN8CW9
 2lrQhicUr0dhlgXea1rX+eVUjc0CdnMvVx4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpyher5wn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:37:08 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 15:37:03 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 92E722944F6C; Wed, 22 Jan 2020 15:36:58 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/3] bpf: tcp: Add bpf_cubic example
Date:   Wed, 22 Jan 2020 15:36:58 -0800
Message-ID: <20200122233658.903774-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122233639.903041-1-kafai@fb.com>
References: <20200122233639.903041-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220196
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a bpf_cubic example.  Some highlights:
1. CONFIG_HZ .kconfig map is used.
2. In bictcp_update(), calculation is changed to use usec
   resolution (i.e. USEC_PER_JIFFY) instead of using jiffies.
   Thus, usecs_to_jiffies() is not used in the bpf_cubic.c.
3. In bitctcp_update() [under tcp_friendliness], the original
   "while (ca->ack_cnt > delta)" loop is changed to the equivalent
   "ca->ack_cnt / delta" operation.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  16 +
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  25 +
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 544 ++++++++++++++++++
 3 files changed, 585 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_cubic.c

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
index 6fee732f0297..8f21965ffc6c 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -6,13 +6,28 @@
 #include <linux/types.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_core_read.h>
+#include "bpf_trace_helpers.h"
+
+#define BPF_STRUCT_OPS(name, args...) \
+SEC("struct_ops/"#name) \
+BPF_PROG(name, args)
+
+#define tcp_jiffies32 ((__u32)bpf_jiffies64())
 
 struct sock_common {
 	unsigned char	skc_state;
 } __attribute__((preserve_access_index));
 
+enum sk_pacing {
+	SK_PACING_NONE		= 0,
+	SK_PACING_NEEDED	= 1,
+	SK_PACING_FQ		= 2,
+};
+
 struct sock {
 	struct sock_common	__sk_common;
+	unsigned long		sk_pacing_rate;
+	__u32			sk_pacing_status; /* see enum sk_pacing */
 } __attribute__((preserve_access_index));
 
 struct inet_sock {
@@ -54,6 +69,7 @@ struct tcp_sock {
 	__u32	max_packets_out;
 	__u32	lsndtime;
 	__u32	prior_cwnd;
+	__u64	tcp_mstamp;	/* most recent packet received/sent */
 } __attribute__((preserve_access_index));
 
 static __always_inline struct inet_connection_sock *inet_csk(const struct sock *sk)
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 517318f05b1d..8482bbc67eec 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -4,6 +4,7 @@
 #include <linux/err.h>
 #include <test_progs.h>
 #include "bpf_dctcp.skel.h"
+#include "bpf_cubic.skel.h"
 
 #define min(a, b) ((a) < (b) ? (a) : (b))
 
@@ -158,6 +159,28 @@ static void do_test(const char *tcp_ca)
 	close(fd);
 }
 
+static void test_cubic(void)
+{
+	struct bpf_cubic *cubic_skel;
+	struct bpf_link *link;
+
+	cubic_skel = bpf_cubic__open_and_load();
+	if (CHECK(!cubic_skel, "bpf_cubic__open_and_load", "failed\n"))
+		return;
+
+	link = bpf_map__attach_struct_ops(cubic_skel->maps.cubic);
+	if (CHECK(IS_ERR(link), "bpf_map__attach_struct_ops", "err:%ld\n",
+		  PTR_ERR(link))) {
+		bpf_cubic__destroy(cubic_skel);
+		return;
+	}
+
+	do_test("bpf_cubic");
+
+	bpf_link__destroy(link);
+	bpf_cubic__destroy(cubic_skel);
+}
+
 static void test_dctcp(void)
 {
 	struct bpf_dctcp *dctcp_skel;
@@ -184,4 +207,6 @@ void test_bpf_tcp_ca(void)
 {
 	if (test__start_subtest("dctcp"))
 		test_dctcp();
+	if (test__start_subtest("cubic"))
+		test_cubic();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_cubic.c b/tools/testing/selftests/bpf/progs/bpf_cubic.c
new file mode 100644
index 000000000000..7897c8f4d363
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_cubic.c
@@ -0,0 +1,544 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* WARNING: This implemenation is not necessarily the same
+ * as the tcp_cubic.c.  The purpose is mainly for testing
+ * the kernel BPF logic.
+ *
+ * Highlights:
+ * 1. CONFIG_HZ .kconfig map is used.
+ * 2. In bictcp_update(), calculation is changed to use usec
+ *    resolution (i.e. USEC_PER_JIFFY) instead of using jiffies.
+ *    Thus, usecs_to_jiffies() is not used in the bpf_cubic.c.
+ * 3. In bitctcp_update() [under tcp_friendliness], the original
+ *    "while (ca->ack_cnt > delta)" loop is changed to the equivalent
+ *    "ca->ack_cnt / delta" operation.
+ */
+
+#include <linux/bpf.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
+
+#define BICTCP_BETA_SCALE    1024	/* Scale factor beta calculation
+					 * max_cwnd = snd_cwnd * beta
+					 */
+#define	BICTCP_HZ		10	/* BIC HZ 2^10 = 1024 */
+
+/* Two methods of hybrid slow start */
+#define HYSTART_ACK_TRAIN	0x1
+#define HYSTART_DELAY		0x2
+
+/* Number of delay samples for detecting the increase of delay */
+#define HYSTART_MIN_SAMPLES	8
+#define HYSTART_DELAY_MIN	(4000U)	/* 4ms */
+#define HYSTART_DELAY_MAX	(16000U)	/* 16 ms */
+#define HYSTART_DELAY_THRESH(x)	clamp(x, HYSTART_DELAY_MIN, HYSTART_DELAY_MAX)
+
+static int fast_convergence = 1;
+static const int beta = 717;	/* = 717/1024 (BICTCP_BETA_SCALE) */
+static int initial_ssthresh;
+static const int bic_scale = 41;
+static int tcp_friendliness = 1;
+
+static int hystart = 1;
+static int hystart_detect = HYSTART_ACK_TRAIN | HYSTART_DELAY;
+static int hystart_low_window = 16;
+static int hystart_ack_delta_us = 2000;
+
+static const __u32 cube_rtt_scale = (bic_scale * 10);	/* 1024*c/rtt */
+static const __u32 beta_scale = 8*(BICTCP_BETA_SCALE+beta) / 3
+				/ (BICTCP_BETA_SCALE - beta);
+/* calculate the "K" for (wmax-cwnd) = c/rtt * K^3
+ *  so K = cubic_root( (wmax-cwnd)*rtt/c )
+ * the unit of K is bictcp_HZ=2^10, not HZ
+ *
+ *  c = bic_scale >> 10
+ *  rtt = 100ms
+ *
+ * the following code has been designed and tested for
+ * cwnd < 1 million packets
+ * RTT < 100 seconds
+ * HZ < 1,000,00  (corresponding to 10 nano-second)
+ */
+
+/* 1/c * 2^2*bictcp_HZ * srtt, 2^40 */
+static const __u64 cube_factor = (__u64)(1ull << (10+3*BICTCP_HZ))
+				/ (bic_scale * 10);
+
+/* BIC TCP Parameters */
+struct bictcp {
+	__u32	cnt;		/* increase cwnd by 1 after ACKs */
+	__u32	last_max_cwnd;	/* last maximum snd_cwnd */
+	__u32	last_cwnd;	/* the last snd_cwnd */
+	__u32	last_time;	/* time when updated last_cwnd */
+	__u32	bic_origin_point;/* origin point of bic function */
+	__u32	bic_K;		/* time to origin point
+				   from the beginning of the current epoch */
+	__u32	delay_min;	/* min delay (usec) */
+	__u32	epoch_start;	/* beginning of an epoch */
+	__u32	ack_cnt;	/* number of acks */
+	__u32	tcp_cwnd;	/* estimated tcp cwnd */
+	__u16	unused;
+	__u8	sample_cnt;	/* number of samples to decide curr_rtt */
+	__u8	found;		/* the exit point is found? */
+	__u32	round_start;	/* beginning of each round */
+	__u32	end_seq;	/* end_seq of the round */
+	__u32	last_ack;	/* last time when the ACK spacing is close */
+	__u32	curr_rtt;	/* the minimum rtt of current round */
+};
+
+static inline void bictcp_reset(struct bictcp *ca)
+{
+	ca->cnt = 0;
+	ca->last_max_cwnd = 0;
+	ca->last_cwnd = 0;
+	ca->last_time = 0;
+	ca->bic_origin_point = 0;
+	ca->bic_K = 0;
+	ca->delay_min = 0;
+	ca->epoch_start = 0;
+	ca->ack_cnt = 0;
+	ca->tcp_cwnd = 0;
+	ca->found = 0;
+}
+
+extern unsigned long CONFIG_HZ __kconfig;
+#define HZ CONFIG_HZ
+#define USEC_PER_MSEC	1000UL
+#define USEC_PER_SEC	1000000UL
+#define USEC_PER_JIFFY	(USEC_PER_SEC / HZ)
+
+static __always_inline __u64 div64_u64(__u64 dividend, __u64 divisor)
+{
+	return dividend / divisor;
+}
+
+#define div64_ul div64_u64
+
+#define BITS_PER_U64 (sizeof(__u64) * 8)
+static __always_inline int fls64(__u64 x)
+{
+	int num = BITS_PER_U64 - 1;
+
+	if (x == 0)
+		return 0;
+
+	if (!(x & (~0ull << (BITS_PER_U64-32)))) {
+		num -= 32;
+		x <<= 32;
+	}
+	if (!(x & (~0ull << (BITS_PER_U64-16)))) {
+		num -= 16;
+		x <<= 16;
+	}
+	if (!(x & (~0ull << (BITS_PER_U64-8)))) {
+		num -= 8;
+		x <<= 8;
+	}
+	if (!(x & (~0ull << (BITS_PER_U64-4)))) {
+		num -= 4;
+		x <<= 4;
+	}
+	if (!(x & (~0ull << (BITS_PER_U64-2)))) {
+		num -= 2;
+		x <<= 2;
+	}
+	if (!(x & (~0ull << (BITS_PER_U64-1))))
+		num -= 1;
+
+	return num + 1;
+}
+
+static __always_inline __u32 bictcp_clock_us(const struct sock *sk)
+{
+	return tcp_sk(sk)->tcp_mstamp;
+}
+
+static __always_inline void bictcp_hystart_reset(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+
+	ca->round_start = ca->last_ack = bictcp_clock_us(sk);
+	ca->end_seq = tp->snd_nxt;
+	ca->curr_rtt = ~0U;
+	ca->sample_cnt = 0;
+}
+
+/* "struct_ops/" prefix is not a requirement
+ * It will be recognized as BPF_PROG_TYPE_STRUCT_OPS
+ * as long as it is used in one of the func ptr
+ * under SEC(".struct_ops").
+ */
+SEC("struct_ops/bictcp_init")
+void BPF_PROG(bictcp_init, struct sock *sk)
+{
+	struct bictcp *ca = inet_csk_ca(sk);
+
+	bictcp_reset(ca);
+
+	if (hystart)
+		bictcp_hystart_reset(sk);
+
+	if (!hystart && initial_ssthresh)
+		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
+}
+
+/* No prefix in SEC will also work.
+ * The remaining tcp-cubic functions have an easier way.
+ */
+SEC("no-sec-prefix-bictcp_cwnd_event")
+void BPF_PROG(bictcp_cwnd_event, struct sock *sk, enum tcp_ca_event event)
+{
+	if (event == CA_EVENT_TX_START) {
+		struct bictcp *ca = inet_csk_ca(sk);
+		__u32 now = tcp_jiffies32;
+		__s32 delta;
+
+		delta = now - tcp_sk(sk)->lsndtime;
+
+		/* We were application limited (idle) for a while.
+		 * Shift epoch_start to keep cwnd growth to cubic curve.
+		 */
+		if (ca->epoch_start && delta > 0) {
+			ca->epoch_start += delta;
+			if (after(ca->epoch_start, now))
+				ca->epoch_start = now;
+		}
+		return;
+	}
+}
+
+/*
+ * cbrt(x) MSB values for x MSB values in [0..63].
+ * Precomputed then refined by hand - Willy Tarreau
+ *
+ * For x in [0..63],
+ *   v = cbrt(x << 18) - 1
+ *   cbrt(x) = (v[x] + 10) >> 6
+ */
+static const __u8 v[] = {
+	/* 0x00 */    0,   54,   54,   54,  118,  118,  118,  118,
+	/* 0x08 */  123,  129,  134,  138,  143,  147,  151,  156,
+	/* 0x10 */  157,  161,  164,  168,  170,  173,  176,  179,
+	/* 0x18 */  181,  185,  187,  190,  192,  194,  197,  199,
+	/* 0x20 */  200,  202,  204,  206,  209,  211,  213,  215,
+	/* 0x28 */  217,  219,  221,  222,  224,  225,  227,  229,
+	/* 0x30 */  231,  232,  234,  236,  237,  239,  240,  242,
+	/* 0x38 */  244,  245,  246,  248,  250,  251,  252,  254,
+};
+
+/* calculate the cubic root of x using a table lookup followed by one
+ * Newton-Raphson iteration.
+ * Avg err ~= 0.195%
+ */
+static __always_inline __u32 cubic_root(__u64 a)
+{
+	__u32 x, b, shift;
+
+	if (a < 64) {
+		/* a in [0..63] */
+		return ((__u32)v[(__u32)a] + 35) >> 6;
+	}
+
+	b = fls64(a);
+	b = ((b * 84) >> 8) - 1;
+	shift = (a >> (b * 3));
+
+	/* it is needed for verifier's bound check on v */
+	if (shift >= 64)
+		return 0;
+
+	x = ((__u32)(((__u32)v[shift] + 10) << b)) >> 6;
+
+	/*
+	 * Newton-Raphson iteration
+	 *                         2
+	 * x    = ( 2 * x  +  a / x  ) / 3
+	 *  k+1          k         k
+	 */
+	x = (2 * x + (__u32)div64_u64(a, (__u64)x * (__u64)(x - 1)));
+	x = ((x * 341) >> 10);
+	return x;
+}
+
+/*
+ * Compute congestion window to use.
+ */
+static __always_inline void bictcp_update(struct bictcp *ca, __u32 cwnd,
+					  __u32 acked)
+{
+	__u32 delta, bic_target, max_cnt;
+	__u64 offs, t;
+
+	ca->ack_cnt += acked;	/* count the number of ACKed packets */
+
+	if (ca->last_cwnd == cwnd &&
+	    (__s32)(tcp_jiffies32 - ca->last_time) <= HZ / 32)
+		return;
+
+	/* The CUBIC function can update ca->cnt at most once per jiffy.
+	 * On all cwnd reduction events, ca->epoch_start is set to 0,
+	 * which will force a recalculation of ca->cnt.
+	 */
+	if (ca->epoch_start && tcp_jiffies32 == ca->last_time)
+		goto tcp_friendliness;
+
+	ca->last_cwnd = cwnd;
+	ca->last_time = tcp_jiffies32;
+
+	if (ca->epoch_start == 0) {
+		ca->epoch_start = tcp_jiffies32;	/* record beginning */
+		ca->ack_cnt = acked;			/* start counting */
+		ca->tcp_cwnd = cwnd;			/* syn with cubic */
+
+		if (ca->last_max_cwnd <= cwnd) {
+			ca->bic_K = 0;
+			ca->bic_origin_point = cwnd;
+		} else {
+			/* Compute new K based on
+			 * (wmax-cwnd) * (srtt>>3 / HZ) / c * 2^(3*bictcp_HZ)
+			 */
+			ca->bic_K = cubic_root(cube_factor
+					       * (ca->last_max_cwnd - cwnd));
+			ca->bic_origin_point = ca->last_max_cwnd;
+		}
+	}
+
+	/* cubic function - calc*/
+	/* calculate c * time^3 / rtt,
+	 *  while considering overflow in calculation of time^3
+	 * (so time^3 is done by using 64 bit)
+	 * and without the support of division of 64bit numbers
+	 * (so all divisions are done by using 32 bit)
+	 *  also NOTE the unit of those veriables
+	 *	  time  = (t - K) / 2^bictcp_HZ
+	 *	  c = bic_scale >> 10
+	 * rtt  = (srtt >> 3) / HZ
+	 * !!! The following code does not have overflow problems,
+	 * if the cwnd < 1 million packets !!!
+	 */
+
+	t = (__s32)(tcp_jiffies32 - ca->epoch_start) * USEC_PER_JIFFY;
+	t += ca->delay_min;
+	/* change the unit from usec to bictcp_HZ */
+	t <<= BICTCP_HZ;
+	t /= USEC_PER_SEC;
+
+	if (t < ca->bic_K)		/* t - K */
+		offs = ca->bic_K - t;
+	else
+		offs = t - ca->bic_K;
+
+	/* c/rtt * (t-K)^3 */
+	delta = (cube_rtt_scale * offs * offs * offs) >> (10+3*BICTCP_HZ);
+	if (t < ca->bic_K)                            /* below origin*/
+		bic_target = ca->bic_origin_point - delta;
+	else                                          /* above origin*/
+		bic_target = ca->bic_origin_point + delta;
+
+	/* cubic function - calc bictcp_cnt*/
+	if (bic_target > cwnd) {
+		ca->cnt = cwnd / (bic_target - cwnd);
+	} else {
+		ca->cnt = 100 * cwnd;              /* very small increment*/
+	}
+
+	/*
+	 * The initial growth of cubic function may be too conservative
+	 * when the available bandwidth is still unknown.
+	 */
+	if (ca->last_max_cwnd == 0 && ca->cnt > 20)
+		ca->cnt = 20;	/* increase cwnd 5% per RTT */
+
+tcp_friendliness:
+	/* TCP Friendly */
+	if (tcp_friendliness) {
+		__u32 scale = beta_scale;
+		__u32 n;
+
+		/* update tcp cwnd */
+		delta = (cwnd * scale) >> 3;
+		if (ca->ack_cnt > delta && delta) {
+			n = ca->ack_cnt / delta;
+			ca->ack_cnt -= n * delta;
+			ca->tcp_cwnd += n;
+		}
+
+		if (ca->tcp_cwnd > cwnd) {	/* if bic is slower than tcp */
+			delta = ca->tcp_cwnd - cwnd;
+			max_cnt = cwnd / delta;
+			if (ca->cnt > max_cnt)
+				ca->cnt = max_cnt;
+		}
+	}
+
+	/* The maximum rate of cwnd increase CUBIC allows is 1 packet per
+	 * 2 packets ACKed, meaning cwnd grows at 1.5x per RTT.
+	 */
+	ca->cnt = max(ca->cnt, 2U);
+}
+
+/* Or simply use the BPF_STRUCT_OPS to avoid the SEC boiler plate. */
+void BPF_STRUCT_OPS(bictcp_cong_avoid, struct sock *sk, __u32 ack, __u32 acked)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+
+	if (!tcp_is_cwnd_limited(sk))
+		return;
+
+	if (tcp_in_slow_start(tp)) {
+		if (hystart && after(ack, ca->end_seq))
+			bictcp_hystart_reset(sk);
+		acked = tcp_slow_start(tp, acked);
+		if (!acked)
+			return;
+	}
+	bictcp_update(ca, tp->snd_cwnd, acked);
+	tcp_cong_avoid_ai(tp, ca->cnt, acked);
+}
+
+__u32 BPF_STRUCT_OPS(bictcp_recalc_ssthresh, struct sock *sk)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+
+	ca->epoch_start = 0;	/* end of epoch */
+
+	/* Wmax and fast convergence */
+	if (tp->snd_cwnd < ca->last_max_cwnd && fast_convergence)
+		ca->last_max_cwnd = (tp->snd_cwnd * (BICTCP_BETA_SCALE + beta))
+			/ (2 * BICTCP_BETA_SCALE);
+	else
+		ca->last_max_cwnd = tp->snd_cwnd;
+
+	return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
+}
+
+void BPF_STRUCT_OPS(bictcp_state, struct sock *sk, __u8 new_state)
+{
+	if (new_state == TCP_CA_Loss) {
+		bictcp_reset(inet_csk_ca(sk));
+		bictcp_hystart_reset(sk);
+	}
+}
+
+#define GSO_MAX_SIZE		65536
+
+/* Account for TSO/GRO delays.
+ * Otherwise short RTT flows could get too small ssthresh, since during
+ * slow start we begin with small TSO packets and ca->delay_min would
+ * not account for long aggregation delay when TSO packets get bigger.
+ * Ideally even with a very small RTT we would like to have at least one
+ * TSO packet being sent and received by GRO, and another one in qdisc layer.
+ * We apply another 100% factor because @rate is doubled at this point.
+ * We cap the cushion to 1ms.
+ */
+static __always_inline __u32 hystart_ack_delay(struct sock *sk)
+{
+	unsigned long rate;
+
+	rate = sk->sk_pacing_rate;
+	if (!rate)
+		return 0;
+	return min((__u64)USEC_PER_MSEC,
+		   div64_ul((__u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+}
+
+static __always_inline void hystart_update(struct sock *sk, __u32 delay)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+	__u32 threshold;
+
+	if (hystart_detect & HYSTART_ACK_TRAIN) {
+		__u32 now = bictcp_clock_us(sk);
+
+		/* first detection parameter - ack-train detection */
+		if ((__s32)(now - ca->last_ack) <= hystart_ack_delta_us) {
+			ca->last_ack = now;
+
+			threshold = ca->delay_min + hystart_ack_delay(sk);
+
+			/* Hystart ack train triggers if we get ack past
+			 * ca->delay_min/2.
+			 * Pacing might have delayed packets up to RTT/2
+			 * during slow start.
+			 */
+			if (sk->sk_pacing_status == SK_PACING_NONE)
+				threshold >>= 1;
+
+			if ((__s32)(now - ca->round_start) > threshold) {
+				ca->found = 1;
+				tp->snd_ssthresh = tp->snd_cwnd;
+			}
+		}
+	}
+
+	if (hystart_detect & HYSTART_DELAY) {
+		/* obtain the minimum delay of more than sampling packets */
+		if (ca->sample_cnt < HYSTART_MIN_SAMPLES) {
+			if (ca->curr_rtt > delay)
+				ca->curr_rtt = delay;
+
+			ca->sample_cnt++;
+		} else {
+			if (ca->curr_rtt > ca->delay_min +
+			    HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
+				ca->found = 1;
+				tp->snd_ssthresh = tp->snd_cwnd;
+			}
+		}
+	}
+}
+
+void BPF_STRUCT_OPS(bictcp_acked, struct sock *sk,
+		    const struct ack_sample *sample)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+	__u32 delay;
+
+	/* Some calls are for duplicates without timetamps */
+	if (sample->rtt_us < 0)
+		return;
+
+	/* Discard delay samples right after fast recovery */
+	if (ca->epoch_start && (__s32)(tcp_jiffies32 - ca->epoch_start) < HZ)
+		return;
+
+	delay = sample->rtt_us;
+	if (delay == 0)
+		delay = 1;
+
+	/* first time call or link delay decreases */
+	if (ca->delay_min == 0 || ca->delay_min > delay)
+		ca->delay_min = delay;
+
+	/* hystart triggers when cwnd is larger than some threshold */
+	if (!ca->found && tcp_in_slow_start(tp) && hystart &&
+	    tp->snd_cwnd >= hystart_low_window)
+		hystart_update(sk, delay);
+}
+
+__u32 BPF_STRUCT_OPS(tcp_reno_undo_cwnd, struct sock *sk)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+
+	return max(tp->snd_cwnd, tp->prior_cwnd);
+}
+
+SEC(".struct_ops")
+struct tcp_congestion_ops cubic = {
+	.init		= (void *)bictcp_init,
+	.ssthresh	= (void *)bictcp_recalc_ssthresh,
+	.cong_avoid	= (void *)bictcp_cong_avoid,
+	.set_state	= (void *)bictcp_state,
+	.undo_cwnd	= (void *)tcp_reno_undo_cwnd,
+	.cwnd_event	= (void *)bictcp_cwnd_event,
+	.pkts_acked     = (void *)bictcp_acked,
+	.name		= "bpf_cubic",
+};
-- 
2.17.1

