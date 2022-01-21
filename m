Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B24495D6B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379916AbiAUKLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:11:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35556 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379919AbiAUKLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:11:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6255F619E3;
        Fri, 21 Jan 2022 10:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C28C36AE3;
        Fri, 21 Jan 2022 10:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759898;
        bh=gBKJi/BzbLfdHEs4F/l8T41QVwXUjMFdMVWAAfmurTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9+mAIyUuNMeeInUbNDsqQXk9Gpe/CdGgOyvpa4lMUs9i09McrMphLbG2EvdJcbow
         s0BLKDTRDqCuTSuYdAZvKOmSRfD4U1knecrmcbp9Jb65TgDcdNJUfJ75OVPqU3HEIl
         9u6mTufEsn6p5ufxGCIUu+emmXkWFxyWE2PPE9ASq7zH11z9QnBLIXJrG0dGTCBtTy
         W87mtMykTBoAM12okhjKMXOOihQclofb+1DC1nHT148jX9k7UdT6IcEjnn0WQosW8o
         yci3NQnoalGCcjQIwjzEK+0DWOXz8k9QG9PBySd26V2+/31zEA2AY/9V87zaXNpJfE
         2omE3qfP5u2Cg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 13/23] bpf: add frags support to xdp copy helpers
Date:   Fri, 21 Jan 2022 11:09:56 +0100
Message-Id: <340b4a99cdc24337b40eaf8bb597f9f9e7b0373e.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This patch adds support for frags for the following helpers:
  - bpf_xdp_output()
  - bpf_perf_event_output()

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/trace/bpf_trace.c                      |   3 +
 net/core/filter.c                             |  57 ++++++++-
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 111 +++++++++++++-----
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 4 files changed, 137 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 21aa30644219..06a9e220069e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1562,6 +1562,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 
 extern const struct bpf_func_proto bpf_skb_output_proto;
 extern const struct bpf_func_proto bpf_xdp_output_proto;
+extern const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto;
 
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags)
@@ -1661,6 +1662,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sock_from_file_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_ptr_cookie_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_trace_proto;
 #endif
 	case BPF_FUNC_seq_printf:
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
diff --git a/net/core/filter.c b/net/core/filter.c
index 70e5874f19c3..e4ce138bf925 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3796,6 +3796,15 @@ static const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
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
 static unsigned long xdp_get_metalen(const struct xdp_buff *xdp)
 {
 	return xdp_data_meta_unsupported(xdp) ? 0 :
@@ -4668,10 +4677,48 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
 };
 #endif
 
-static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
+static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
 				  unsigned long off, unsigned long len)
 {
-	memcpy(dst_buff, src_buff + off, len);
+	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
+	unsigned long ptr_len, ptr_off = 0;
+	skb_frag_t *next_frag, *end_frag;
+	struct skb_shared_info *sinfo;
+	u8 *ptr_buf;
+
+	if (likely(xdp->data_end - xdp->data >= off + len)) {
+		memcpy(dst_buff, xdp->data + off, len);
+		return 0;
+	}
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	end_frag = &sinfo->frags[sinfo->nr_frags];
+	next_frag = &sinfo->frags[0];
+
+	ptr_len = xdp->data_end - xdp->data;
+	ptr_buf = xdp->data;
+
+	while (true) {
+		if (off < ptr_off + ptr_len) {
+			unsigned long copy_off = off - ptr_off;
+			unsigned long copy_len = min(len, ptr_len - copy_off);
+
+			memcpy(dst_buff, ptr_buf + copy_off, copy_len);
+
+			off += copy_len;
+			len -= copy_len;
+			dst_buff += copy_len;
+		}
+
+		if (!len || next_frag == end_frag)
+			break;
+
+		ptr_off += ptr_len;
+		ptr_buf = skb_frag_address(next_frag);
+		ptr_len = skb_frag_size(next_frag);
+		next_frag++;
+	}
+
 	return 0;
 }
 
@@ -4682,11 +4729,11 @@ BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct bpf_map *, map,
 
 	if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
 		return -EINVAL;
-	if (unlikely(!xdp ||
-		     xdp_size > (unsigned long)(xdp->data_end - xdp->data)))
+
+	if (unlikely(!xdp || xdp_size > xdp_get_buff_len(xdp)))
 		return -EFAULT;
 
-	return bpf_event_output(map, flags, meta, meta_size, xdp->data,
+	return bpf_event_output(map, flags, meta, meta_size, xdp,
 				xdp_size, bpf_xdp_copy);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
index 500a302cb3e9..9c395ea680c6 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
@@ -10,28 +10,97 @@ struct meta {
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
 	struct meta *meta = (struct meta *)data;
 	struct ipv4_packet *trace_pkt_v4 = data + sizeof(*meta);
+	unsigned char *raw_pkt = data + sizeof(*meta);
+	struct test_ctx_s *tst_ctx = ctx;
 
 	ASSERT_GE(size, sizeof(pkt_v4) + sizeof(*meta), "check_size");
 	ASSERT_EQ(meta->ifindex, if_nametoindex("lo"), "check_meta_ifindex");
-	ASSERT_EQ(meta->pkt_len, sizeof(pkt_v4), "check_meta_pkt_len");
+	ASSERT_EQ(meta->pkt_len, tst_ctx->pkt_size, "check_meta_pkt_len");
 	ASSERT_EQ(memcmp(trace_pkt_v4, &pkt_v4, sizeof(pkt_v4)), 0,
 		  "check_packet_content");
 
-	*(bool *)ctx = true;
+	if (meta->pkt_len > sizeof(pkt_v4)) {
+		for (int i = 0; i < meta->pkt_len - sizeof(pkt_v4); i++)
+			ASSERT_EQ(raw_pkt[i + sizeof(pkt_v4)], (unsigned char)i,
+				  "check_packet_content");
+	}
+
+	tst_ctx->passed = true;
 }
 
-void test_xdp_bpf2bpf(void)
+#define BUF_SZ	9000
+
+static void run_xdp_bpf2bpf_pkt_size(int pkt_fd, struct perf_buffer *pb,
+				     struct test_xdp_bpf2bpf *ftrace_skel,
+				     int pkt_size)
 {
 	__u32 duration = 0, retval, size;
-	char buf[128];
+	__u8 *buf, *buf_in;
+	int err;
+
+	if (!ASSERT_LE(pkt_size, BUF_SZ, "pkt_size") ||
+	    !ASSERT_GE(pkt_size, sizeof(pkt_v4), "pkt_size"))
+		return;
+
+	buf_in = malloc(BUF_SZ);
+	if (!ASSERT_OK_PTR(buf_in, "buf_in malloc()"))
+		return;
+
+	buf = malloc(BUF_SZ);
+	if (!ASSERT_OK_PTR(buf, "buf malloc()")) {
+		free(buf_in);
+		return;
+	}
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
+	ASSERT_OK(err, "ipv4");
+	ASSERT_EQ(retval, XDP_PASS, "ipv4 retval");
+	ASSERT_EQ(size, pkt_size, "ipv4 size");
+
+	/* Make sure bpf_xdp_output() was triggered and it sent the expected
+	 * data to the perf ring buffer.
+	 */
+	err = perf_buffer__poll(pb, 100);
+
+	ASSERT_GE(err, 0, "perf_buffer__poll");
+	ASSERT_TRUE(test_ctx.passed, "test passed");
+	/* Verify test results */
+	ASSERT_EQ(ftrace_skel->bss->test_result_fentry, if_nametoindex("lo"),
+		  "fentry result");
+	ASSERT_EQ(ftrace_skel->bss->test_result_fexit, XDP_PASS, "fexit result");
+
+	free(buf);
+	free(buf_in);
+}
+
+void test_xdp_bpf2bpf(void)
+{
 	int err, pkt_fd, map_fd;
-	bool passed = false;
-	struct iphdr iph;
-	struct iptnl_info value4 = {.family = AF_INET};
+	int pkt_sizes[] = {sizeof(pkt_v4), 1024, 4100, 8200};
+	struct iptnl_info value4 = {.family = AF_INET6};
 	struct test_xdp *pkt_skel = NULL;
 	struct test_xdp_bpf2bpf *ftrace_skel = NULL;
 	struct vip key4 = {.protocol = 6, .family = AF_INET};
@@ -73,32 +142,14 @@ void test_xdp_bpf2bpf(void)
 		goto out;
 
 	/* Set up perf buffer */
-	pb = perf_buffer__new(bpf_map__fd(ftrace_skel->maps.perf_buf_map), 1,
-			      on_sample, NULL, &passed, NULL);
+	pb = perf_buffer__new(bpf_map__fd(ftrace_skel->maps.perf_buf_map), 8,
+			      on_sample, NULL, &test_ctx, NULL);
 	if (!ASSERT_OK_PTR(pb, "perf_buf__new"))
 		goto out;
 
-	/* Run test program */
-	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
-				buf, &size, &retval, &duration);
-	memcpy(&iph, buf + sizeof(struct ethhdr), sizeof(iph));
-
-	ASSERT_OK(err, "ipv4");
-	ASSERT_EQ(retval, XDP_TX, "ipv4 retval");
-	ASSERT_EQ(size, 74, "ipv4 size");
-	ASSERT_EQ(iph.protocol, IPPROTO_IPIP, "ipv4 proto");
-
-	/* Make sure bpf_xdp_output() was triggered and it sent the expected
-	 * data to the perf ring buffer.
-	 */
-	err = perf_buffer__poll(pb, 100);
-
-	ASSERT_GE(err, 0, "perf_buffer__poll");
-	ASSERT_TRUE(passed, "test passed");
-	/* Verify test results */
-	ASSERT_EQ(ftrace_skel->bss->test_result_fentry, if_nametoindex("lo"),
-		  "fentry result");
-	ASSERT_EQ(ftrace_skel->bss->test_result_fexit, XDP_TX, "fexit result");
+	for (int i = 0; i < ARRAY_SIZE(pkt_sizes); i++)
+		run_xdp_bpf2bpf_pkt_size(pkt_fd, pb, ftrace_skel,
+					 pkt_sizes[i]);
 out:
 	perf_buffer__free(pb);
 	test_xdp__destroy(pkt_skel);
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index 58cf4345f5cc..3379d303f41a 100644
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
2.34.1

