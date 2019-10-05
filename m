Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B72CC80C
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 07:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfJEFDk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 01:03:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfJEFDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 01:03:37 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x954wmhQ004593
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 22:03:37 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ved839sab-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 22:03:36 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 4 Oct 2019 22:03:36 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 4D6FA76091D; Fri,  4 Oct 2019 22:03:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 10/10] selftests/bpf: add kfree_skb raw_tp test
Date:   Fri, 4 Oct 2019 22:03:14 -0700
Message-ID: <20191005050314.1114330-11-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191005050314.1114330-1-ast@kernel.org>
References: <20191005050314.1114330-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_02:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 impostorscore=0 clxscore=1034 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=4 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Load basic cls_bpf program.
Load raw_tracepoint program and attach to kfree_skb raw tracepoint.
Trigger cls_bpf via prog_test_run.
At the end of test_run kernel will call kfree_skb
which will trigger trace_kfree_skb tracepoint.
Which will call our raw_tracepoint program.
Which will take that skb and will dump it into perf ring buffer.
Check that user space received correct packet.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/kfree_skb.c      | 90 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/kfree_skb.c | 76 ++++++++++++++++
 2 files changed, 166 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
new file mode 100644
index 000000000000..238bc7024b36
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+static void on_sample(void *ctx, int cpu, void *data, __u32 size)
+{
+	int ifindex = *(int *)data, duration = 0;
+	struct ipv6_packet * pkt_v6 = data + 4;
+
+	if (ifindex != 1)
+		/* spurious kfree_skb not on loopback device */
+		return;
+	if (CHECK(size != 76, "check_size", "size %d != 76\n", size))
+		return;
+	if (CHECK(pkt_v6->eth.h_proto != 0xdd86, "check_eth",
+		  "h_proto %x\n", pkt_v6->eth.h_proto))
+		return;
+	if (CHECK(pkt_v6->iph.nexthdr != 6, "check_ip",
+		  "iph.nexthdr %x\n", pkt_v6->iph.nexthdr))
+		return;
+	if (CHECK(pkt_v6->tcp.doff != 5, "check_tcp",
+		  "tcp.doff %x\n", pkt_v6->tcp.doff))
+		return;
+
+	*(bool *)ctx = true;
+}
+
+void test_kfree_skb(void)
+{
+	struct bpf_prog_load_attr attr = {
+		.file = "./kfree_skb.o",
+		.log_level = 2,
+	};
+
+	struct bpf_object *obj, *obj2 = NULL;
+	struct perf_buffer_opts pb_opts = {};
+	struct perf_buffer *pb = NULL;
+	struct bpf_link *link = NULL;
+	struct bpf_map *perf_buf_map;
+	struct bpf_program *prog;
+	__u32 duration, retval;
+	int err, pkt_fd, kfree_skb_fd;
+	bool passed = false;
+
+	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS, &obj, &pkt_fd);
+	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
+		return;
+
+	err = bpf_prog_load_xattr(&attr, &obj2, &kfree_skb_fd);
+	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
+		goto close_prog;
+
+	prog = bpf_object__find_program_by_title(obj2, "raw_tracepoint/kfree_skb");
+	if (CHECK(!prog, "find_prog", "prog kfree_skb not found\n"))
+		goto close_prog;
+	link = bpf_program__attach_raw_tracepoint(prog, "kfree_skb");
+	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
+		goto close_prog;
+
+	perf_buf_map = bpf_object__find_map_by_name(obj2, "perf_buf_map");
+	if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
+		goto close_prog;
+
+	/* set up perf buffer */
+	pb_opts.sample_cb = on_sample;
+	pb_opts.ctx = &passed;
+	pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
+	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+		goto close_prog;
+
+	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
+				NULL, NULL, &retval, &duration);
+	CHECK(err || retval, "ipv6",
+	      "err %d errno %d retval %d duration %d\n",
+	      err, errno, retval, duration);
+
+	/* read perf buffer */
+	err = perf_buffer__poll(pb, 100);
+	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
+		goto close_prog;
+	/* make sure kfree_skb program was triggered
+	 * and it sent expected skb into ring buffer
+	 */
+	CHECK_FAIL(!passed);
+close_prog:
+	perf_buffer__free(pb);
+	if (!IS_ERR_OR_NULL(link))
+		bpf_link__destroy(link);
+	bpf_object__close(obj);
+	bpf_object__close(obj2);
+}
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
new file mode 100644
index 000000000000..61f1abfc4f48
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} perf_buf_map SEC(".maps");
+
+#define _(P) (__builtin_preserve_access_index(P))
+
+/* define few struct-s that bpf program needs to access */
+struct callback_head {
+	struct callback_head *next;
+	void (*func)(struct callback_head *head);
+};
+struct dev_ifalias {
+	struct callback_head rcuhead;
+};
+
+struct net_device /* same as kernel's struct net_device */ {
+	int ifindex;
+	volatile struct dev_ifalias *ifalias;
+};
+
+struct sk_buff {
+	/* field names and sizes should match to those in the kernel */
+        unsigned int            len,
+                                data_len;
+        __u16                   mac_len,
+                                hdr_len;
+        __u16                   queue_mapping;
+	struct net_device *dev;
+	/* order of the fields doesn't matter */
+};
+
+/* copy arguments from
+ * include/trace/events/skb.h:
+ * TRACE_EVENT(kfree_skb,
+ *         TP_PROTO(struct sk_buff *skb, void *location),
+ *
+ * into struct below:
+ */
+struct trace_kfree_skb {
+	struct sk_buff *skb;
+	void *location;
+};
+
+SEC("raw_tracepoint/kfree_skb")
+int trace_kfree_skb(struct trace_kfree_skb* ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	struct net_device *dev;
+	int ifindex;
+	struct callback_head *ptr;
+	void *func;
+	__builtin_preserve_access_index(({
+		dev = skb->dev;
+		ifindex = dev->ifindex;
+		ptr = dev->ifalias->rcuhead.next;
+		func = ptr->func;
+	}));
+
+	bpf_printk("rcuhead.next %llx func %llx\n", ptr, func);
+	bpf_printk("skb->len %d\n", _(skb->len));
+	bpf_printk("skb->queue_mapping %d\n", _(skb->queue_mapping));
+	bpf_printk("dev->ifindex %d\n", ifindex);
+
+	/* send first 72 byte of the packet to user space */
+	bpf_skb_output(skb, &perf_buf_map, (72ull << 32) | BPF_F_CURRENT_CPU,
+		       &ifindex, sizeof(ifindex));
+	return 0;
+}
-- 
2.20.0

