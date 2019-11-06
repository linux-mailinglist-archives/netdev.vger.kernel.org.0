Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC5F1D16
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbfKFSCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:02:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64102 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728191AbfKFSCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:02:18 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6Hx7F6015583
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 10:02:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=8Bbx/q0j2y0t31Iul8vO07aQOZQKM1jLAIjZkWvrUxQ=;
 b=oEkMHxUVqRqHHmMT7cXfQhygXO6gE8gYBThmoRyuBpcbt3LIPSI0g1PyuVCOQ4ANzO4+
 owVdc5WPyOEHb+JF9p+WvXdM1dz3RttGWAy5HNfpYnKc2ax6pbUES9mSYNOFwvRxUWJc
 cx/tZin21XKllOE2coo+KsyrMswTO2T+n5I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u2ge7k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 10:02:17 -0800
Received: from 2401:db00:2120:80e1:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 10:02:16 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 89550294200E; Wed,  6 Nov 2019 10:02:15 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] bpf: Add cb access in kfree_skb test
Date:   Wed, 6 Nov 2019 10:02:15 -0800
Message-ID: <20191106180215.2175714-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106180212.2175046-1-kafai@fb.com>
References: <20191106180212.2175046-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_06:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=9 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911060174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Access the skb->cb[] in the kfree_skb test.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/kfree_skb.c      | 54 +++++++++++++++----
 tools/testing/selftests/bpf/progs/kfree_skb.c | 25 +++++++--
 2 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
index 430b50de1583..6e6fbfba2322 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -1,15 +1,38 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 
+struct meta {
+	int ifindex;
+	__u32 cb32_0;
+	__u8 cb8_0;
+};
+
+union {
+	__u32 cb32[5];
+	__u8 cb8[20];
+} cb = {
+	.cb32[0] = 0x81828384,
+};
+
 static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 {
-	int ifindex = *(int *)data, duration = 0;
-	struct ipv6_packet *pkt_v6 = data + 4;
+	struct meta *meta = (struct meta *)data;
+	struct ipv6_packet *pkt_v6 = data + sizeof(*meta);
+	int duration = 0;
 
-	if (ifindex != 1)
+	if (CHECK(size != 72 + sizeof(*meta), "check_size", "size %u != %zu\n",
+		  size, 72 + sizeof(*meta)))
+		return;
+	if (CHECK(meta->ifindex != 1, "check_meta_ifindex",
+		  "meta->ifindex = %d\n", meta->ifindex))
 		/* spurious kfree_skb not on loopback device */
 		return;
-	if (CHECK(size != 76, "check_size", "size %u != 76\n", size))
+	if (CHECK(meta->cb8_0 != cb.cb8[0], "check_cb8_0", "cb8_0 %x != %x\n",
+		  meta->cb8_0, cb.cb8[0]))
+		return;
+	if (CHECK(meta->cb32_0 != cb.cb32[0], "check_cb32_0",
+		  "cb32_0 %x != %x\n",
+		  meta->cb32_0, cb.cb32[0]))
 		return;
 	if (CHECK(pkt_v6->eth.h_proto != 0xdd86, "check_eth",
 		  "h_proto %x\n", pkt_v6->eth.h_proto))
@@ -26,6 +49,13 @@ static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 
 void test_kfree_skb(void)
 {
+	struct __sk_buff skb = {};
+	struct bpf_prog_test_run_attr tattr = {
+		.data_in = &pkt_v6,
+		.data_size_in = sizeof(pkt_v6),
+		.ctx_in = &skb,
+		.ctx_size_in = sizeof(skb),
+	};
 	struct bpf_prog_load_attr attr = {
 		.file = "./kfree_skb.o",
 	};
@@ -36,11 +66,12 @@ void test_kfree_skb(void)
 	struct bpf_link *link = NULL;
 	struct bpf_map *perf_buf_map;
 	struct bpf_program *prog;
-	__u32 duration, retval;
-	int err, pkt_fd, kfree_skb_fd;
+	int err, kfree_skb_fd;
 	bool passed = false;
+	__u32 duration = 0;
 
-	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS, &obj, &pkt_fd);
+	err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS,
+			    &obj, &tattr.prog_fd);
 	if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
 		return;
 
@@ -66,11 +97,12 @@ void test_kfree_skb(void)
 	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
 		goto close_prog;
 
-	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
-				NULL, NULL, &retval, &duration);
-	CHECK(err || retval, "ipv6",
+	memcpy(skb.cb, &cb, sizeof(cb));
+	err = bpf_prog_test_run_xattr(&tattr);
+	duration = tattr.duration;
+	CHECK(err || tattr.retval, "ipv6",
 	      "err %d errno %d retval %d duration %d\n",
-	      err, errno, retval, duration);
+	      err, errno, tattr.retval, duration);
 
 	/* read perf buffer */
 	err = perf_buffer__poll(pb, 100);
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index 489319ea1d6a..f769fdbf6725 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -43,6 +43,7 @@ struct sk_buff {
 	refcount_t users;
 	unsigned char *data;
 	char __pkt_type_offset[0];
+	char cb[48];
 };
 
 /* copy arguments from
@@ -57,28 +58,41 @@ struct trace_kfree_skb {
 	void *location;
 };
 
+struct meta {
+	int ifindex;
+	__u32 cb32_0;
+	__u8 cb8_0;
+};
+
 SEC("tp_btf/kfree_skb")
 int trace_kfree_skb(struct trace_kfree_skb *ctx)
 {
 	struct sk_buff *skb = ctx->skb;
 	struct net_device *dev;
-	int ifindex;
 	struct callback_head *ptr;
 	void *func;
 	int users;
 	unsigned char *data;
 	unsigned short pkt_data;
+	struct meta meta = {};
 	char pkt_type;
+	__u32 *cb32;
+	__u8 *cb8;
 
 	__builtin_preserve_access_index(({
 		users = skb->users.refs.counter;
 		data = skb->data;
 		dev = skb->dev;
-		ifindex = dev->ifindex;
 		ptr = dev->ifalias->rcuhead.next;
 		func = ptr->func;
+		cb8 = (__u8 *)&skb->cb;
+		cb32 = (__u32 *)&skb->cb;
 	}));
 
+	meta.ifindex = _(dev->ifindex);
+	meta.cb8_0 = cb8[8];
+	meta.cb32_0 = cb32[2];
+
 	bpf_probe_read_kernel(&pkt_type, sizeof(pkt_type), _(&skb->__pkt_type_offset));
 	pkt_type &= 7;
 
@@ -90,14 +104,15 @@ int trace_kfree_skb(struct trace_kfree_skb *ctx)
 		   _(skb->len), users, pkt_type);
 	bpf_printk("skb->queue_mapping %d\n", _(skb->queue_mapping));
 	bpf_printk("dev->ifindex %d data %llx pkt_data %x\n",
-		   ifindex, data, pkt_data);
+		   meta.ifindex, data, pkt_data);
+	bpf_printk("cb8_0:%x cb32_0:%x\n", meta.cb8_0, meta.cb32_0);
 
-	if (users != 1 || pkt_data != bpf_htons(0x86dd) || ifindex != 1)
+	if (users != 1 || pkt_data != bpf_htons(0x86dd) || meta.ifindex != 1)
 		/* raw tp ignores return value */
 		return 0;
 
 	/* send first 72 byte of the packet to user space */
 	bpf_skb_output(skb, &perf_buf_map, (72ull << 32) | BPF_F_CURRENT_CPU,
-		       &ifindex, sizeof(ifindex));
+		       &meta, sizeof(meta));
 	return 0;
 }
-- 
2.17.1

