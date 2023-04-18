Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD326E5E94
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjDRKU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDRKTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:19:52 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3743C7EE5;
        Tue, 18 Apr 2023 03:19:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0VgQLRQ._1681813175;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VgQLRQ._1681813175)
          by smtp.aliyun-inc.com;
          Tue, 18 Apr 2023 18:19:36 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, pabeni@redhat.com, song@kernel.org,
        sdf@google.com, haoluo@google.com, yhs@fb.com, edumazet@google.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next v2 5/5] bpf/selftests: add selftest for SMC bpf capability
Date:   Tue, 18 Apr 2023 18:19:20 +0800
Message-Id: <1681813160-120214-6-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1681813160-120214-1-git-send-email-alibuda@linux.alibaba.com>
References: <1681813160-120214-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This PATCH adds a tiny selftest for SMC bpf capability,
making decisions on whether to use SMC by collecting
certain information from kernel smc sock.

Follow the steps below to run this test.

make -C tools/testing/selftests/bpf
cd tools/testing/selftests/bpf
sudo ./test_progs -t smc

Results shows:
18/1    bpf_smc/load:OK
18/2    bpf_smc/update:OK
18/3    bpf_smc/ref:OK
18      bpf_smc:OK
Summary: 1/3 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_smc.c | 107 +++++++++
 tools/testing/selftests/bpf/progs/bpf_smc.c      | 265 +++++++++++++++++++++++
 2 files changed, 372 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_smc.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_smc.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_smc.c b/tools/testing/selftests/bpf/prog_tests/bpf_smc.c
new file mode 100644
index 0000000..e668857
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_smc.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/err.h>
+#include <netinet/tcp.h>
+#include <test_progs.h>
+#include "network_helpers.h"
+#include "bpf_smc.skel.h"
+
+#define SOL_SMC 286
+#define SMC_NEGOTIATOR 2
+static const char name[] = "apps";
+
+void run_smc(void)
+{
+	int fd, err;
+
+	fd = socket(AF_SMC, SOCK_STREAM, 0);
+	ASSERT_GT(fd, 0, "create smc socket");
+
+	err = setsockopt(fd, SOL_SMC, SMC_NEGOTIATOR, name, sizeof(name) / sizeof(char));
+	ASSERT_EQ(err, 0, "setsockopt");
+
+	close(fd);
+}
+
+void test_load(void)
+{
+	struct bpf_smc *smc_skel;
+	struct bpf_link *link;
+
+	smc_skel = bpf_smc__open_and_load();
+	if (!ASSERT_OK_PTR(smc_skel, "skel_open"))
+		return;
+
+	link = bpf_map__attach_struct_ops(smc_skel->maps.ops);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto error;
+
+	bpf_link__destroy(link);
+error:
+	bpf_smc__destroy(smc_skel);
+}
+
+void test_update(void)
+{
+	struct bpf_smc *smc_skel;
+	struct bpf_link *link;
+	int err;
+
+	smc_skel = bpf_smc__open_and_load();
+	if (!ASSERT_OK_PTR(smc_skel, "skel_open"))
+		return;
+
+	link = bpf_map__attach_struct_ops(smc_skel->maps.accept);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto error;
+
+	run_smc();
+	ASSERT_EQ(smc_skel->bss->accept_cnt, 1, "accept_cnt");
+
+	err = bpf_link__update_map(link, smc_skel->maps.drop);
+	ASSERT_OK(err, "update_map");
+
+	run_smc();
+	ASSERT_EQ(smc_skel->bss->accept_cnt, 1, "accept_cnt");
+	ASSERT_EQ(smc_skel->bss->drop_cnt, 1, "drop_cnt");
+
+	bpf_link__destroy(link);
+error:
+	bpf_smc__destroy(smc_skel);
+}
+
+void test_ref(void)
+{
+	struct bpf_smc *smc_skel;
+	struct bpf_link *link;
+	int fd = 0, err;
+
+	smc_skel = bpf_smc__open_and_load();
+	if (!ASSERT_OK_PTR(smc_skel, "skel_open"))
+		return;
+
+	link = bpf_map__attach_struct_ops(smc_skel->maps.accept);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto error;
+
+	fd = socket(AF_SMC, SOCK_STREAM, 0);
+	ASSERT_GT(fd, 0, "create smc socket");
+	err = setsockopt(fd, SOL_SMC, SMC_NEGOTIATOR, name, sizeof(name) / sizeof(char));
+	ASSERT_EQ(err, 0, "setsockopt");
+	bpf_link__destroy(link);
+	if (fd > 0)
+		close(fd);
+	ASSERT_EQ(smc_skel->bss->accept_release_cnt, 1, "accept_release_cnt");
+error:
+	bpf_smc__destroy(smc_skel);
+}
+
+void test_bpf_smc(void)
+{
+	if (test__start_subtest("load"))
+		test_load();
+	if (test__start_subtest("update"))
+		test_update();
+	if (test__start_subtest("ref"))
+		test_ref();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_smc.c b/tools/testing/selftests/bpf/progs/bpf_smc.c
new file mode 100644
index 0000000..8ff70af
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_smc.c
@@ -0,0 +1,265 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_tracing.h>
+
+#define AF_SMC			(43)
+#define SMC_LISTEN		(10)
+#define SMC_SOCK_CLOSED_TIMING	(0)
+extern unsigned long CONFIG_HZ __kconfig;
+#define HZ CONFIG_HZ
+
+char _license[] SEC("license") = "GPL";
+#define max(a, b) ((a) > (b) ? (a) : (b))
+
+static __always_inline struct smc_sock *smc_sk(struct sock *sk)
+{
+	return (struct smc_sock *)sk;
+}
+
+struct smc_prediction {
+	/* protection for smc_prediction */
+	struct bpf_spin_lock lock;
+	/* start of time slice */
+	__u64	start_tstamp;
+	/* delta of pacing */
+	__u64	pacing_delta;
+	/* N of closed connections determined as long connections
+	 * in current time slice
+	 */
+	__u32	closed_long_cc;
+	/* N of closed connections in this time slice */
+	__u32	closed_total_cc;
+	/* N of incoming connections determined as long connections
+	 * in current time slice
+	 */
+	__u32	incoming_long_cc;
+	/* last splice rate of long cc */
+	__u32	last_rate_of_lcc;
+};
+
+#define SMC_PREDICTION_MIN_PACING_DELTA                (1llu)
+#define SMC_PREDICTION_MAX_PACING_DELTA                (HZ << 3)
+#define SMC_PREDICTION_MAX_LONGCC_PER_SPLICE           (8)
+#define SMC_PREDICTION_MAX_PORT                        (64)
+#define SMC_PREDICTION_MAX_SPLICE_GAP                  (1)
+#define SMC_PREDICTION_LONGCC_RATE_THRESHOLD           (13189)
+#define SMC_PREDICTION_LONGCC_PACKETS_THRESHOLD        (100)
+#define SMC_PREDICTION_LONGCC_BYTES_THRESHOLD	\
+		(SMC_PREDICTION_LONGCC_PACKETS_THRESHOLD * 1024)
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, SMC_PREDICTION_MAX_PORT);
+	__type(key, __u16);
+	__type(value, struct smc_prediction);
+} negotiator_map SEC(".maps");
+
+
+static inline __u32 smc_prediction_calt_rate(struct smc_prediction *smc_predictor)
+{
+	if (!smc_predictor->closed_total_cc)
+		return smc_predictor->last_rate_of_lcc;
+
+	return (smc_predictor->closed_long_cc << 14) / smc_predictor->closed_total_cc;
+}
+
+static inline struct smc_prediction *smc_prediction_get(__u16 key, __u64 tstamp)
+{
+	struct smc_prediction zero = {}, *smc_predictor;
+	__u32 gap;
+	int err;
+
+	smc_predictor = bpf_map_lookup_elem(&negotiator_map, &key);
+	if (!smc_predictor) {
+		zero.start_tstamp = bpf_jiffies64();
+		zero.pacing_delta = SMC_PREDICTION_MIN_PACING_DELTA;
+		err = bpf_map_update_elem(&negotiator_map, &key, &zero, 0);
+		if (err)
+			return NULL;
+		smc_predictor =  bpf_map_lookup_elem(&negotiator_map, &key);
+		if (!smc_predictor)
+			return NULL;
+	}
+
+	if (tstamp) {
+		bpf_spin_lock(&smc_predictor->lock);
+		gap = (tstamp - smc_predictor->start_tstamp) / smc_predictor->pacing_delta;
+		/* new splice */
+		if (gap > 0) {
+			smc_predictor->start_tstamp = tstamp;
+			smc_predictor->last_rate_of_lcc =
+				(smc_prediction_calt_rate(smc_predictor) * 7) >> (2 + gap);
+			smc_predictor->closed_long_cc = 0;
+			smc_predictor->closed_total_cc = 0;
+			smc_predictor->incoming_long_cc = 0;
+		}
+		bpf_spin_unlock(&smc_predictor->lock);
+	}
+	return smc_predictor;
+}
+
+int SEC("struct_ops/bpf_smc_negotiate")
+BPF_PROG(bpf_smc_negotiate, struct sock *sk)
+{
+	struct smc_prediction *smc_predictor;
+	struct smc_sock *smc = smc_sk(sk);
+	struct tcp_sock *tp;
+	__u32 rate = 0;
+	__u16 key;
+
+	/* client side */
+	if (smc == NULL || smc->sk.__sk_common.skc_state != SMC_LISTEN) {
+		/* use Global smc_predictor */
+		key = 0;
+	} else {	/* server side */
+		tp = bpf_skc_to_tcp_sock(sk);
+		if (!tp)
+			goto error;
+		key = tp->inet_conn.icsk_inet.sk.__sk_common.skc_num;
+	}
+
+	smc_predictor = smc_prediction_get(key, bpf_jiffies64());
+	if (!smc_predictor)
+		return SK_PASS;
+
+	bpf_spin_lock(&smc_predictor->lock);
+
+	if (smc_predictor->incoming_long_cc == 0)
+		goto out_locked_pass;
+
+	if (smc_predictor->incoming_long_cc > SMC_PREDICTION_MAX_LONGCC_PER_SPLICE)
+		goto out_locked_drop;
+
+	rate = smc_prediction_calt_rate(smc_predictor);
+	if (rate < SMC_PREDICTION_LONGCC_RATE_THRESHOLD)
+		goto out_locked_drop;
+
+out_locked_pass:
+	smc_predictor->incoming_long_cc++;
+	bpf_spin_unlock(&smc_predictor->lock);
+	return SK_PASS;
+out_locked_drop:
+	bpf_spin_unlock(&smc_predictor->lock);
+error:
+	return SK_DROP;
+}
+
+void SEC("struct_ops/bpf_smc_collect_info")
+BPF_PROG(bpf_smc_collect_info, struct sock *sk, int timing)
+{
+	struct smc_prediction *smc_predictor;
+	int use_fallback, sndbuf;
+	struct smc_sock *smc;
+	struct tcp_sock *tp;
+	bool match = false;
+	__u16 wrap, count;
+	__u16 key;
+
+	/* no info can collect */
+	if (sk == NULL)
+		return;
+
+	/* only fouces on closed */
+	if (timing != SMC_SOCK_CLOSED_TIMING)
+		return;
+
+	/* every full smc sock should contains a tcp sock */
+	tp = bpf_skc_to_tcp_sock(sk);
+	if (!tp)
+		return;
+
+	smc = smc_sk(sk);
+	if (smc->use_fallback) {
+		use_fallback = 1;
+		match = tp->delivered > SMC_PREDICTION_LONGCC_PACKETS_THRESHOLD;
+	} else {
+		wrap = smc->conn.tx_curs_sent.wrap;
+		count = smc->conn.tx_curs_sent.count;
+		sndbuf = tp->inet_conn.icsk_inet.sk.sk_sndbuf;
+		match = (count + wrap * sndbuf) > SMC_PREDICTION_LONGCC_BYTES_THRESHOLD;
+	}
+
+	key = tp->inet_conn.icsk_inet.sk.__sk_common.skc_num;
+
+	smc_predictor = smc_prediction_get(key, 0);
+	if (!smc_predictor)
+		goto error;
+
+	bpf_spin_lock(&smc_predictor->lock);
+	smc_predictor->closed_total_cc++;
+	if (match) {
+		/* increase stats */
+		smc_predictor->closed_long_cc++;
+		/* try more aggressive */
+		if (smc_predictor->pacing_delta > SMC_PREDICTION_MIN_PACING_DELTA) {
+			if (use_fallback) {
+				smc_predictor->pacing_delta = max(SMC_PREDICTION_MIN_PACING_DELTA,
+						(smc_predictor->pacing_delta * 3) >> 2);
+			}
+		}
+	} else if (!use_fallback) {
+		smc_predictor->pacing_delta <<= 1;
+	}
+	bpf_spin_unlock(&smc_predictor->lock);
+error:
+	return;
+}
+
+SEC(".struct_ops.link")
+struct smc_sock_negotiator_ops ops = {
+	.name = "apps",
+	.negotiate	= (void *)bpf_smc_negotiate,
+	.collect_info	= (void *)bpf_smc_collect_info,
+};
+
+int accept_cnt = 0;
+int drop_cnt = 0;
+int accept_release_cnt = 0;
+
+int SEC("struct_ops/bpf_smc_accept")
+BPF_PROG(bpf_smc_accept, struct sock *sk)
+{
+	return SK_PASS;
+}
+
+void SEC("struct_ops/bpf_smc_accept_init")
+BPF_PROG(bpf_smc_accept_init, struct sock *sk)
+{
+	accept_cnt++;
+}
+
+void SEC("struct_ops/bpf_smc_accept_release")
+BPF_PROG(bpf_smc_accept_release, struct sock *sk)
+{
+	accept_release_cnt++;
+}
+
+int SEC("struct_ops/bpf_smc_drop")
+BPF_PROG(bpf_smc_drop, struct sock *sk)
+{
+	return SK_DROP;
+}
+
+void SEC("struct_ops/bpf_smc_drop_init")
+BPF_PROG(bpf_smc_drop_init, struct sock *sk)
+{
+	drop_cnt++;
+}
+
+SEC(".struct_ops.link")
+struct smc_sock_negotiator_ops accept = {
+	.name = "apps",
+	.init = (void *) bpf_smc_accept_init,
+	.release = (void *) bpf_smc_accept_release,
+	.negotiate = (void *) bpf_smc_accept,
+};
+
+SEC(".struct_ops.link")
+struct smc_sock_negotiator_ops drop = {
+	.name = "apps",
+	.init = (void *) bpf_smc_drop_init,
+	.negotiate = (void *) bpf_smc_drop,
+};
-- 
1.8.3.1

