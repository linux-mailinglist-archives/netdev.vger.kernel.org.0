Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1974111EF65
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLNAsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:48:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbfLNAsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:48:13 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE0UVQf009129
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=PAGJ4yDo5B7Ns9C9nuZQq82ivUiRt+F9LvjZhaOJrhg=;
 b=NsZ+2TJH3UAn3DaD4RIPeWpvzwpuj2HIWP5I1UserQDBD2Tat4ZOTw4ZaYH8qt6d/zWU
 pA/uNovEMtYkkJQPQxSFpyvQJZu6TnkUHbDKxnwT4zTXi4VfIQBS63I53IoAz0s+oME/
 fiRxgh1/MOlnLsKj2U+reFSjKZtNxCIhV4E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvkm20g2d-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:48:12 -0800
Received: from intmgw003.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 16:48:09 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 062F72943AB4; Fri, 13 Dec 2019 16:48:07 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 13/13] bpf: Add bpf_cubic example
Date:   Fri, 13 Dec 2019 16:48:07 -0800
Message-ID: <20191214004807.1653955-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214004737.1652076-1-kafai@fb.com>
References: <20191214004737.1652076-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 clxscore=1015 suspectscore=13 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the bpf_cubic tcp sample.
The CONFIG_HZ=1000 requirement will go away when
the libbpf extern-var support is ready.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  22 +
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 502 ++++++++++++++++++
 2 files changed, 524 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_cubic.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 035de76bf8ed..3d787ecafa4a 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -178,6 +178,26 @@ static struct bpf_object *load(const char *filename)
 	return obj;
 }
 
+static void test_cubic(void)
+{
+	struct bpf_object *obj;
+	int err;
+
+	err = system("zgrep 'CONFIG_HZ=1000$' /proc/config.gz >& /dev/null");
+	if (err) {
+		test__skip();
+		return;
+	}
+
+	obj = load("bpf_cubic.o");
+	if (IS_ERR(obj))
+		return;
+
+	do_test("bpf_cubic");
+
+	bpf_object__close(obj);
+}
+
 static void test_dctcp(void)
 {
 	struct bpf_object *obj;
@@ -195,4 +215,6 @@ void test_bpf_tcp_ca(void)
 {
 	if (test__start_subtest("dctcp"))
 		test_dctcp();
+	if (test__start_subtest("cubic"))
+		test_cubic();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_cubic.c b/tools/testing/selftests/bpf/progs/bpf_cubic.c
new file mode 100644
index 000000000000..ca77d6a34406
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_cubic.c
@@ -0,0 +1,502 @@
+// SPDX-License-Identifier: GPL-2.0-only
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
+#define HYSTART_DELAY_MIN	(4U<<3)
+#define HYSTART_DELAY_MAX	(16U<<3)
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
+static int hystart_ack_delta = 2;
+
+static __u32 cube_rtt_scale = (bic_scale * 10);	/* 1024*c/rtt */
+static __u32 beta_scale = 8*(BICTCP_BETA_SCALE+beta) / 3
+		/ (BICTCP_BETA_SCALE - beta);
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
+static __u64 cube_factor = (__u64)(1ull << (10+3*BICTCP_HZ)) / (bic_scale * 10);
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
+	__u32	delay_min;	/* min delay (msec << 3) */
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
+static __always_inline void bictcp_reset(struct bictcp *ca)
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
+#define HZ 1000UL
+#define NSEC_PER_MSEC	1000000UL
+#define USEC_PER_MSEC	1000UL
+
+static __always_inline __u64 msecs_to_jiffies(__u32 m)
+{
+	return bpf_jiffies((__u64)m * NSEC_PER_MSEC, BPF_F_NS_TO_JIFFIES);
+}
+
+static __always_inline __u32 bictcp_clock(void)
+{
+	return bpf_jiffies(0, BPF_F_JIFFIES_TO_NS) / NSEC_PER_MSEC;
+}
+
+#define tcp_jiffies32 ((__u32)bpf_jiffies(0, 0))
+
+static __always_inline void bictcp_hystart_reset(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+
+	ca->round_start = ca->last_ack = bictcp_clock();
+	ca->end_seq = tp->snd_nxt;
+	ca->curr_rtt = 0;
+	ca->sample_cnt = 0;
+}
+
+BPF_TCP_OPS_1(bictcp_init, void, struct sock *, sk)
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
+BPF_TCP_OPS_2(bictcp_cwnd_event, void, struct sock *, sk,
+	      enum tcp_ca_event, event)
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
+#define BITS_PER_LONG (sizeof(long) * 8)
+static __always_inline unsigned long __fls(unsigned long word)
+{
+	int num = BITS_PER_LONG - 1;
+
+	if (!(word & (~0ul << 32))) {
+		num -= 32;
+		word <<= 32;
+	}
+
+	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
+		num -= 16;
+		word <<= 16;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-8)))) {
+		num -= 8;
+		word <<= 8;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-4)))) {
+		num -= 4;
+		word <<= 4;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-2)))) {
+		num -= 2;
+		word <<= 2;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-1))))
+		num -= 1;
+	return num;
+}
+
+static __always_inline int fls64(__u64 x)
+{
+	if (x == 0)
+		return 0;
+	return __fls(x) + 1;
+}
+
+static __always_inline __u64 div64_u64(__u64 dividend, __u64 divisor)
+{
+	return dividend / divisor;
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
+	b = fls64(a);
+	if (a < 64) {
+		/* a in [0..63] */
+		return ((__u32)v[(__u32)a] + 35) >> 6;
+	}
+
+	/* b >= 7 */
+
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
+	t = (__s32)(tcp_jiffies32 - ca->epoch_start);
+	t += msecs_to_jiffies(ca->delay_min >> 3);
+	/* change the unit from HZ to bictcp_HZ */
+	t <<= BICTCP_HZ;
+	t /= HZ;
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
+		if (delta) {
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
+BPF_TCP_OPS_3(bictcp_cong_avoid, void, struct sock *, sk,
+	      __u32, ack, __u32, acked)
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
+BPF_TCP_OPS_1(bictcp_recalc_ssthresh, __u32,
+	      struct sock *, sk)
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
+BPF_TCP_OPS_2(bictcp_state, void, struct sock *, sk,
+	      __u8, new_state)
+{
+	if (new_state == TCP_CA_Loss) {
+		bictcp_reset(inet_csk_ca(sk));
+		bictcp_hystart_reset(sk);
+	}
+}
+
+static __always_inline void hystart_update(struct sock *sk, __u32 delay)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct bictcp *ca = inet_csk_ca(sk);
+
+	if (ca->found & hystart_detect)
+		return;
+
+	if (hystart_detect & HYSTART_ACK_TRAIN) {
+		__u32 now = bictcp_clock();
+
+		/* first detection parameter - ack-train detection */
+		if ((__s32)(now - ca->last_ack) <= hystart_ack_delta) {
+			ca->last_ack = now;
+			if ((__s32)(now - ca->round_start) > ca->delay_min >> 4) {
+				ca->found |= HYSTART_ACK_TRAIN;
+				tp->snd_ssthresh = tp->snd_cwnd;
+			}
+		}
+	}
+
+	if (hystart_detect & HYSTART_DELAY) {
+		/* obtain the minimum delay of more than sampling packets */
+		if (ca->sample_cnt < HYSTART_MIN_SAMPLES) {
+			if (ca->curr_rtt == 0 || ca->curr_rtt > delay)
+				ca->curr_rtt = delay;
+
+			ca->sample_cnt++;
+		} else {
+			if (ca->curr_rtt > ca->delay_min +
+			    HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
+				ca->found |= HYSTART_DELAY;
+				tp->snd_ssthresh = tp->snd_cwnd;
+			}
+		}
+	}
+}
+
+/* Track delayed acknowledgment ratio using sliding window
+ * ratio = (15*ratio + sample) / 16
+ */
+BPF_TCP_OPS_2(bictcp_acked, void, struct sock *, sk,
+	      const struct ack_sample *, sample)
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
+	delay = (sample->rtt_us << 3) / USEC_PER_MSEC;
+	if (delay == 0)
+		delay = 1;
+
+	/* first time call or link delay decreases */
+	if (ca->delay_min == 0 || ca->delay_min > delay)
+		ca->delay_min = delay;
+
+	/* hystart triggers when cwnd is larger than some threshold */
+	if (hystart && tcp_in_slow_start(tp) &&
+	    tp->snd_cwnd >= hystart_low_window)
+		hystart_update(sk, delay);
+}
+
+BPF_TCP_OPS_1(tcp_reno_undo_cwnd, __u32, struct sock *, sk)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+
+	return max(tp->snd_cwnd, tp->prior_cwnd);
+}
+
+SEC("struct_ops")
+struct tcp_congestion_ops cubictcp = {
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

