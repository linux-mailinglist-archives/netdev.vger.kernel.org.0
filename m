Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920F2D866B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403770AbfJPDZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:25:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390973AbfJPDZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:25:32 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G3OwBc003733
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:30 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vnccac5g0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:25:30 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 20:25:29 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2644B760F32; Tue, 15 Oct 2019 20:25:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 11/11] selftests/bpf: add kfree_skb raw_tp test
Date:   Tue, 15 Oct 2019 20:25:05 -0700
Message-ID: <20191016032505.2089704-12-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016032505.2089704-1-ast@kernel.org>
References: <20191016032505.2089704-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 suspectscore=4 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160029
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
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/kfree_skb.c      |  89 +++++++++++++++
 tools/testing/selftests/bpf/progs/kfree_skb.c | 103 ++++++++++++++++++
 2 files changed, 192 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
new file mode 100644
index 000000000000..430b50de1583
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+static void on_sample(void *ctx, int cpu, void *data, __u32 size)
+{
+	int ifindex = *(int *)data, duration = 0;
+	struct ipv6_packet *pkt_v6 = data + 4;
+
+	if (ifindex != 1)
+		/* spurious kfree_skb not on loopback device */
+		return;
+	if (CHECK(size != 76, "check_size", "size %u != 76\n", size))
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
+	prog = bpf_object__find_program_by_title(obj2, "tp_btf/kfree_skb");
+	if (CHECK(!prog, "find_prog", "prog kfree_skb not found\n"))
+		goto close_prog;
+	link = bpf_program__attach_raw_tracepoint(prog, NULL);
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
index 000000000000..89af8a921ee4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+#include "bpf_endian.h"
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
+	struct dev_ifalias *ifalias;
+};
+
+typedef struct {
+        int counter;
+} atomic_t;
+typedef struct refcount_struct {
+        atomic_t refs;
+} refcount_t;
+
+struct sk_buff {
+	/* field names and sizes should match to those in the kernel */
+	unsigned int len, data_len;
+	__u16 mac_len, hdr_len, queue_mapping;
+	struct net_device *dev;
+	/* order of the fields doesn't matter */
+	refcount_t users;
+	unsigned char *data;
+	char __pkt_type_offset[0];
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
+SEC("tp_btf/kfree_skb")
+int trace_kfree_skb(struct trace_kfree_skb *ctx)
+{
+	struct sk_buff *skb = ctx->skb;
+	struct net_device *dev;
+	int ifindex;
+	struct callback_head *ptr;
+	void *func;
+	int users;
+	unsigned char *data;
+	unsigned short pkt_data;
+	char pkt_type;
+
+	__builtin_preserve_access_index(({
+		users = skb->users.refs.counter;
+		data = skb->data;
+		dev = skb->dev;
+		ifindex = dev->ifindex;
+		ptr = dev->ifalias->rcuhead.next;
+		func = ptr->func;
+	}));
+
+	bpf_probe_read(&pkt_type, sizeof(pkt_type), _(&skb->__pkt_type_offset));
+	pkt_type &= 7;
+
+	/* read eth proto */
+	bpf_probe_read(&pkt_data, sizeof(pkt_data), data + 12);
+
+	bpf_printk("rcuhead.next %llx func %llx\n", ptr, func);
+	bpf_printk("skb->len %d users %d pkt_type %x\n",
+		   _(skb->len), users, pkt_type);
+	bpf_printk("skb->queue_mapping %d\n", _(skb->queue_mapping));
+	bpf_printk("dev->ifindex %d data %llx pkt_data %x\n",
+		   ifindex, data, pkt_data);
+
+	if (users != 1 || pkt_data != bpf_htons(0x86dd) || ifindex != 1)
+		/* raw tp ignores return value */
+		return 0;
+
+	/* send first 72 byte of the packet to user space */
+	bpf_skb_output(skb, &perf_buf_map, (72ull << 32) | BPF_F_CURRENT_CPU,
+		       &ifindex, sizeof(ifindex));
+	return 0;
+}
-- 
2.17.1

