Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF01463387
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhK3L6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhK3L6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3721FC061574;
        Tue, 30 Nov 2021 03:54:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEA69B81867;
        Tue, 30 Nov 2021 11:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5283C53FC7;
        Tue, 30 Nov 2021 11:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273292;
        bh=drm3Tr2dAyIVp0FP5fvy+yEvtTqB0f9wTVl8BFb54B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAoosY3wy/ZMzmzBHTNImPbH5VeGElJ/xy1j7V/k16MttNJl0fG9+YGdDpIHvsf9r
         ALnvYASkPLW+9tpKuiP+fL9QlXrAq6cV50gu9k/qmSA78PBz10Bs2tZstbjfw9Z4ud
         NCM7L8D3lMvUK80dssJYQzHrIdN9hXVjOtBkYGVtr08GQ/o8SZtI3uRgoY7hxWnWDe
         AH8qBnepgrE3P/bRyMO7w5sr5ElJUSFZ+7+0XrX5DfTmFScvduMDvkTAJDinkjsNvq
         eKZzRKVWE6u/gRjhNu+YisQtw1YsZ49Eg4KY777OGt8pJgxCUctrv+xHrqeB2Y4VmO
         kP3auvlWnj3CQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 13/23] bpf: add multi-buffer support to xdp copy helpers
Date:   Tue, 30 Nov 2021 12:52:57 +0100
Message-Id: <7556d91fd9498b225f3bd1d76827aee756344bd3.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This patch adds support for multi-buffer for the following helpers:
  - bpf_xdp_output()
  - bpf_perf_event_output()

Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/trace/bpf_trace.c                      |   3 +
 net/core/filter.c                             |  57 ++++++-
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++++++++-----
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 4 files changed, 168 insertions(+), 45 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 25ea521fb8f1..495ca8717005 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1521,6 +1521,7 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 
 extern const struct bpf_func_proto bpf_skb_output_proto;
 extern const struct bpf_func_proto bpf_xdp_output_proto;
+extern const struct bpf_func_proto bpf_xdp_get_buff_len_trace_proto;
 
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags)
@@ -1620,6 +1621,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sock_from_file_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_ptr_cookie_proto;
+	case BPF_FUNC_xdp_get_buff_len:
+		return &bpf_xdp_get_buff_len_trace_proto;
 #endif
 	case BPF_FUNC_seq_printf:
 		return prog->expected_attach_type == BPF_TRACE_ITER ?
diff --git a/net/core/filter.c b/net/core/filter.c
index ace67957e685..19eabef702f0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3797,6 +3797,15 @@ static const struct bpf_func_proto bpf_xdp_get_buff_len_proto = {
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
@@ -4618,10 +4627,48 @@ static const struct bpf_func_proto bpf_sk_ancestor_cgroup_id_proto = {
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
 
@@ -4632,11 +4679,11 @@ BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct bpf_map *, map,
 
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
index c98a897ad692..c5cff4f2d9de 100644
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
@@ -25,25 +34,114 @@ static void on_sample(void *ctx, int cpu, void *data, __u32 size)
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
+#define BUF_SZ	9000
+
+static int run_xdp_bpf2bpf_pkt_size(int pkt_fd, struct perf_buffer *pb,
+				    struct test_xdp_bpf2bpf *ftrace_skel,
+				    int pkt_size)
 {
 	__u32 duration = 0, retval, size;
-	char buf[128];
+	__u8 *buf, *buf_in;
+	int err, ret = 0;
+
+	if (pkt_size > BUF_SZ || pkt_size < sizeof(pkt_v4))
+		return -EINVAL;
+
+	buf_in = malloc(BUF_SZ);
+	if (CHECK(!buf_in, "buf_in malloc()", "error:%s\n", strerror(errno)))
+		return -ENOMEM;
+
+	buf = malloc(BUF_SZ);
+	if (CHECK(!buf, "buf malloc()", "error:%s\n", strerror(errno))) {
+		ret = -ENOMEM;
+		goto free_buf_in;
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
+	if (CHECK(err || retval != XDP_PASS || size != pkt_size,
+		  "ipv4", "err %d errno %d retval %d size %d\n",
+		  err, errno, retval, size)) {
+		ret = err ? err : -EINVAL;
+		goto free_buf;
+	}
+
+	/* Make sure bpf_xdp_output() was triggered and it sent the expected
+	 * data to the perf ring buffer.
+	 */
+	err = perf_buffer__poll(pb, 100);
+	if (CHECK(err <= 0, "perf_buffer__poll", "err %d\n", err)) {
+		ret = -EINVAL;
+		goto free_buf;
+	}
+
+	if (CHECK_FAIL(!test_ctx.passed)) {
+		ret = -EINVAL;
+		goto free_buf;
+	}
+
+	/* Verify test results */
+	if (CHECK(ftrace_skel->bss->test_result_fentry != if_nametoindex("lo"),
+		  "result", "fentry failed err %llu\n",
+		  ftrace_skel->bss->test_result_fentry)) {
+		ret = -EINVAL;
+		goto free_buf;
+	}
+
+	if (CHECK(ftrace_skel->bss->test_result_fexit != XDP_PASS, "result",
+		  "fexit failed err %llu\n",
+		  ftrace_skel->bss->test_result_fexit))
+		ret = -EINVAL;
+
+free_buf:
+	free(buf);
+free_buf_in:
+	free(buf_in);
+
+	return ret;
+}
+
+void test_xdp_bpf2bpf(void)
+{
 	int err, pkt_fd, map_fd;
-	bool passed = false;
-	struct iphdr iph;
-	struct iptnl_info value4 = {.family = AF_INET};
+	__u32 duration = 0;
+	int pkt_sizes[] = {sizeof(pkt_v4), 1024, 4100, 8200};
+	struct iptnl_info value4 = {.family = AF_INET6};
 	struct test_xdp *pkt_skel = NULL;
 	struct test_xdp_bpf2bpf *ftrace_skel = NULL;
 	struct vip key4 = {.protocol = 6, .family = AF_INET};
@@ -85,39 +183,14 @@ void test_xdp_bpf2bpf(void)
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
-	if (CHECK(err || retval != XDP_TX || size != 74 ||
-		  iph.protocol != IPPROTO_IPIP, "ipv4",
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
2.31.1

