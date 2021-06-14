Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB73A671B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhFNMxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhFNMxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00EDF613CD;
        Mon, 14 Jun 2021 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675078;
        bh=s9Rn93MKq/iPUN5qoBunQMJx9PHnU06N5M0lfP/tGFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7DSQg8k/MQWuSyFvEW03IoTKaBpfxnXRdBe+q826w7WXMV089WnXqkwZ9sPLyoU8
         Ko5tYqUMekKje8c5DfBEq/y0BnpNXZtCIyP90iH1gSEXLW1GtXwZEfrJBnXbmIxThX
         EHJQHxooiTd57OnMxamgbb39iY5jJHN8DEDsOvqgWihEtjsccSXUlX/6ICik6JdOPS
         w89LGFGCYqbpRKz7MzVawuqunXAApqm6HrvmhZtF/uYJOes+1RRL2jrxxBgd1OKvSc
         m/jsowtNMXYBZVJZPScaLmJ2C0/qJd3LavXDLJCCQ+5cSvf5Z+1KoSC4dIZGXJu0Xj
         i28iMCgt78qbg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 10/14] bpf: add multi-buffer support to xdp copy helpers
Date:   Mon, 14 Jun 2021 14:49:48 +0200
Message-Id: <4d2a74f7389eb51e2b43c63df76d9cd76f57384c.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This patch adds support for multi-buffer for the following helpers:
  - bpf_xdp_output()
  - bpf_perf_event_output()

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/trace/bpf_trace.c                      |   3 +
 net/core/filter.c                             |  72 +++++++++-
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++++++------
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 4 files changed, 160 insertions(+), 44 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d2d7cf6cfe83..ee926ec64f78 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1365,6 +1365,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 
 extern const struct bpf_func_proto bpf_skb_output_proto;
 extern const struct bpf_func_proto bpf_xdp_output_proto;
+extern const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto;
 
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags)
@@ -1460,6 +1461,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sock_from_file_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_ptr_cookie_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_trace_proto;
 #endif
 	case BPF_FUNC_seq_printf:
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
diff --git a/net/core/filter.c b/net/core/filter.c
index b0855f2d4726..f7211b7908a9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3939,6 +3939,15 @@ const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BTF_ID_LIST_SINGLE(bpf_xdp_get_buff_len_bpf_ids, struct, xdp_buff)
+
+const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto = {
+	.func		= bpf_xdp_get_buff_len,
+	.gpl_only	= false,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_xdp_get_buff_len_bpf_ids[0],
+};
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
@@ -4606,10 +4615,56 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
 };
 #endif
 
-static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
+static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
 				  unsigned long off, unsigned long len)
 {
-	memcpy(dst_buff, src_buff + off, len);
+	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
+	struct skb_shared_info *sinfo;
+	unsigned long base_len;
+
+	if (likely(!xdp_buff_is_mb(xdp))) {
+		memcpy(dst_buff, xdp->data + off, len);
+		return 0;
+	}
+
+	base_len = xdp->data_end - xdp->data;
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	do {
+		const void *src_buff = NULL;
+		unsigned long copy_len = 0;
+
+		if (off < base_len) {
+			src_buff = xdp->data + off;
+			copy_len = min(len, base_len - off);
+		} else {
+			unsigned long frag_off_total = base_len;
+			int i;
+
+			for (i = 0; i < sinfo->nr_frags; i++) {
+				skb_frag_t *frag = &sinfo->frags[i];
+				unsigned long frag_len, frag_off;
+
+				frag_len = skb_frag_size(frag);
+				frag_off = off - frag_off_total;
+				if (frag_off < frag_len) {
+					src_buff = skb_frag_address(frag) +
+						   frag_off;
+					copy_len = min(len,
+						       frag_len - frag_off);
+					break;
+				}
+				frag_off_total += frag_len;
+			}
+		}
+		if (!src_buff)
+			break;
+
+		memcpy(dst_buff, src_buff, copy_len);
+		off += copy_len;
+		len -= copy_len;
+		dst_buff += copy_len;
+	} while (len);
+
 	return 0;
 }
 
@@ -4621,10 +4676,19 @@ BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct bpf_map *, map,
 	if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
 		return -EINVAL;
 	if (unlikely(!xdp ||
-		     xdp_size > (unsigned long)(xdp->data_end - xdp->data)))
+		     (likely(!xdp_buff_is_mb(xdp)) &&
+		      xdp_size > (unsigned long)(xdp->data_end - xdp->data))))
 		return -EFAULT;
+	if (unlikely(xdp_buff_is_mb(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		if (unlikely(xdp_size > ((int)(xdp->data_end - xdp->data) +
+					 sinfo->data_len)))
+			return -EFAULT;
+	}
 
-	return bpf_event_output(map, flags, meta, meta_size, xdp->data,
+	return bpf_event_output(map, flags, meta, meta_size, xdp,
 				xdp_size, bpf_xdp_copy);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
index 3bd5904b4db5..cc9be5912be8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
@@ -10,11 +10,20 @@ struct meta {
 	int pkt_len;
 };
 
+struct test_ctx_s {
+	bool passed;
+	int pkt_size;
+};
+
+struct test_ctx_s test_ctx;
+
 static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 {
-	int duration = 0;
 	struct meta *meta = (struct meta *)data;
 	struct ipv4_packet *trace_pkt_v4 = data + sizeof(*meta);
+	unsigned char *raw_pkt = data + sizeof(*meta);
+	struct test_ctx_s *tst_ctx = ctx;
+	int duration = 0;
 
 	if (CHECK(size < sizeof(pkt_v4) + sizeof(*meta),
 		  "check_size", "size %u < %zu\n",
@@ -25,25 +34,90 @@ static void on_sample(void *ctx, int cpu, void *data, __u32 size)
 		  "meta->ifindex = %d\n", meta->ifindex))
 		return;
 
-	if (CHECK(meta->pkt_len != sizeof(pkt_v4), "check_meta_pkt_len",
-		  "meta->pkt_len = %zd\n", sizeof(pkt_v4)))
+	if (CHECK(meta->pkt_len != tst_ctx->pkt_size, "check_meta_pkt_len",
+		  "meta->pkt_len = %d\n", tst_ctx->pkt_size))
 		return;
 
 	if (CHECK(memcmp(trace_pkt_v4, &pkt_v4, sizeof(pkt_v4)),
 		  "check_packet_content", "content not the same\n"))
 		return;
 
-	*(bool *)ctx = true;
+	if (meta->pkt_len > sizeof(pkt_v4)) {
+		for (int i = 0; i < (meta->pkt_len - sizeof(pkt_v4)); i++) {
+			if (raw_pkt[i + sizeof(pkt_v4)] != (unsigned char)i) {
+				CHECK(true, "check_packet_content",
+				      "byte %zu does not match %u != %u\n",
+				      i + sizeof(pkt_v4),
+				      raw_pkt[i + sizeof(pkt_v4)],
+				      (unsigned char)i);
+				break;
+			}
+		}
+	}
+
+	tst_ctx->passed = true;
 }
 
-void test_xdp_bpf2bpf(void)
+static int run_xdp_bpf2bpf_pkt_size(int pkt_fd, struct perf_buffer *pb,
+				    struct test_xdp_bpf2bpf *ftrace_skel,
+				    int pkt_size)
 {
 	__u32 duration = 0, retval, size;
-	char buf[128];
+	unsigned char buf_in[9000];
+	unsigned char buf[9000];
+	int err;
+
+	if (pkt_size > sizeof(buf_in) || pkt_size < sizeof(pkt_v4))
+		return -EINVAL;
+
+	test_ctx.passed = false;
+	test_ctx.pkt_size = pkt_size;
+
+	memcpy(buf_in, &pkt_v4, sizeof(pkt_v4));
+	if (pkt_size > sizeof(pkt_v4)) {
+		for (int i = 0; i < (pkt_size - sizeof(pkt_v4)); i++)
+			buf_in[i + sizeof(pkt_v4)] = i;
+	}
+
+	/* Run test program */
+	err = bpf_prog_test_run(pkt_fd, 1, buf_in, pkt_size,
+				buf, &size, &retval, &duration);
+
+	if (CHECK(err || retval != XDP_PASS || size != pkt_size,
+		  "ipv4", "err %d errno %d retval %d size %d\n",
+		  err, errno, retval, size))
+		return -1;
+
+	/* Make sure bpf_xdp_output() was triggered and it sent the expected
+	 * data to the perf ring buffer.
+	 */
+	err = perf_buffer__poll(pb, 100);
+	if (CHECK(err <= 0, "perf_buffer__poll", "err %d\n", err))
+		return -1;
+
+	if (CHECK_FAIL(!test_ctx.passed))
+		return -1;
+
+	/* Verify test results */
+	if (CHECK(ftrace_skel->bss->test_result_fentry != if_nametoindex("lo"),
+		  "result", "fentry failed err %llu\n",
+		  ftrace_skel->bss->test_result_fentry))
+		return -1;
+
+	if (CHECK(ftrace_skel->bss->test_result_fexit != XDP_PASS, "result",
+		  "fexit failed err %llu\n",
+		  ftrace_skel->bss->test_result_fexit))
+		return -1;
+
+	return 0;
+}
+
+void test_xdp_bpf2bpf(void)
+{
 	int err, pkt_fd, map_fd;
-	bool passed = false;
-	struct iphdr *iph = (void *)buf + sizeof(struct ethhdr);
-	struct iptnl_info value4 = {.family = AF_INET};
+	__u32 duration = 0;
+	int pkt_sizes[] = {sizeof(pkt_v4), 1024, 4100, 8200};
+	struct iptnl_info value4 = {.family = AF_INET6};
 	struct test_xdp *pkt_skel = NULL;
 	struct test_xdp_bpf2bpf *ftrace_skel = NULL;
 	struct vip key4 = {.protocol = 6, .family = AF_INET};
@@ -87,40 +161,15 @@ void test_xdp_bpf2bpf(void)
 
 	/* Set up perf buffer */
 	pb_opts.sample_cb = on_sample;
-	pb_opts.ctx = &passed;
+	pb_opts.ctx = &test_ctx;
 	pb = perf_buffer__new(bpf_map__fd(ftrace_skel->maps.perf_buf_map),
-			      1, &pb_opts);
+			      8, &pb_opts);
 	if (!ASSERT_OK_PTR(pb, "perf_buf__new"))
 		goto out;
 
-	/* Run test program */
-	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
-				buf, &size, &retval, &duration);
-
-	if (CHECK(err || retval != XDP_TX || size != 74 ||
-		  iph->protocol != IPPROTO_IPIP, "ipv4",
-		  "err %d errno %d retval %d size %d\n",
-		  err, errno, retval, size))
-		goto out;
-
-	/* Make sure bpf_xdp_output() was triggered and it sent the expected
-	 * data to the perf ring buffer.
-	 */
-	err = perf_buffer__poll(pb, 100);
-	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
-		goto out;
-
-	CHECK_FAIL(!passed);
-
-	/* Verify test results */
-	if (CHECK(ftrace_skel->bss->test_result_fentry != if_nametoindex("lo"),
-		  "result", "fentry failed err %llu\n",
-		  ftrace_skel->bss->test_result_fentry))
-		goto out;
-
-	CHECK(ftrace_skel->bss->test_result_fexit != XDP_TX, "result",
-	      "fexit failed err %llu\n", ftrace_skel->bss->test_result_fexit);
-
+	for (int i = 0; i < ARRAY_SIZE(pkt_sizes); i++)
+		run_xdp_bpf2bpf_pkt_size(pkt_fd, pb, ftrace_skel,
+					 pkt_sizes[i]);
 out:
 	if (pb)
 		perf_buffer__free(pb);
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index a038e827f850..902b54190377 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -49,7 +49,7 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
 	void *data = (void *)(long)xdp->data;
 
 	meta.ifindex = xdp->rxq->dev->ifindex;
-	meta.pkt_len = data_end - data;
+	meta.pkt_len = bpf_xdp_get_buff_len((struct xdp_md *)xdp);
 	bpf_xdp_output(xdp, &perf_buf_map,
 		       ((__u64) meta.pkt_len << 32) |
 		       BPF_F_CURRENT_CPU,
-- 
2.31.1

