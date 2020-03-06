Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7307317B8D2
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 09:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgCFI7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 03:59:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33913 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726025AbgCFI7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 03:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583485182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=70iLRkaJI6Zw/KbC7jeNatLbT6z636bAkdrPi8hFVnY=;
        b=AIwEB57amwlM95l/EkaR1yOpZZuS9cJImenqJ0/20EXV+s5k8OpnMMJ0R+728JxHKuE0Xi
        2WWiZBTnaGzZ8F3CzeY6Op4oBDonRa7BdlbisPzqhkCT6GmJHOSd/n8w455VXgvv9Y0BJj
        jQnfcz/cTqjr0OlE6T30KmeNo28Yga4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-zYi-UrvKPDqRgWt15exzdw-1; Fri, 06 Mar 2020 03:59:39 -0500
X-MC-Unique: zYi-UrvKPDqRgWt15exzdw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89CA01005F72;
        Fri,  6 Mar 2020 08:59:37 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6BE75C21B;
        Fri,  6 Mar 2020 08:59:33 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next] bpf: add bpf_xdp_output() helper
Date:   Fri,  6 Mar 2020 08:59:23 +0000
Message-Id: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new helper that reuses existing xdp perf_event output
implementation, but can be called from raw_tracepoint programs
that receive 'struct xdp_buff *' as a tracepoint argument.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 include/uapi/linux/bpf.h                           |   27 ++++++++++
 kernel/bpf/verifier.c                              |    4 +-
 kernel/trace/bpf_trace.c                           |    3 +
 net/core/filter.c                                  |   16 ++++++
 tools/include/uapi/linux/bpf.h                     |   27 ++++++++++
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   53 ++++++++++++++=
++++++
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   24 +++++++++
 7 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 40b2d9476268..41a90e2d5821 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2914,6 +2914,30 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * int bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *d=
ata, u64 size)
+ *	Description
+ *		Write raw *data* blob into a special BPF perf event held by
+ *		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
+ *		event must have the following attributes: **PERF_SAMPLE_RAW**
+ *		as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
+ *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ *		The *flags* are used to indicate the index in *map* for which
+ *		the value must be put, masked with **BPF_F_INDEX_MASK**.
+ *		Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
+ *		to indicate that the index of the current CPU core should be
+ *		used.
+ *
+ *		The value to write, of *size*, is passed through eBPF stack and
+ *		pointed by *data*.
+ *
+ *		*ctx* is a pointer to in-kernel struct xdp_buff.
+ *
+ *		This helper is similar to **bpf_perf_eventoutput**\ () but
+ *		restricted to raw_tracepoint bpf programs.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3035,7 +3059,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(xdp_output),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ae32517d4ccd..66eb4b836000 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3650,7 +3650,8 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
 		if (func_id !=3D BPF_FUNC_perf_event_read &&
 		    func_id !=3D BPF_FUNC_perf_event_output &&
 		    func_id !=3D BPF_FUNC_skb_output &&
-		    func_id !=3D BPF_FUNC_perf_event_read_value)
+		    func_id !=3D BPF_FUNC_perf_event_read_value &&
+		    func_id !=3D BPF_FUNC_xdp_output)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_STACK_TRACE:
@@ -3740,6 +3741,7 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
 	case BPF_FUNC_perf_event_output:
 	case BPF_FUNC_perf_event_read_value:
 	case BPF_FUNC_skb_output:
+	case BPF_FUNC_xdp_output:
 		if (map->map_type !=3D BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 363e0a2c75cf..87c024ccdd1d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1143,6 +1143,7 @@ static const struct bpf_func_proto bpf_perf_event_o=
utput_proto_raw_tp =3D {
 };
=20
 extern const struct bpf_func_proto bpf_skb_output_proto;
+extern const struct bpf_func_proto bpf_xdp_output_proto;
=20
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, arg=
s,
 	   struct bpf_map *, map, u64, flags)
@@ -1218,6 +1219,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, c=
onst struct bpf_prog *prog)
 #ifdef CONFIG_NET
 	case BPF_FUNC_skb_output:
 		return &bpf_skb_output_proto;
+	case BPF_FUNC_xdp_output:
+		return &bpf_xdp_output_proto;
 #endif
 	default:
 		return raw_tp_prog_func_proto(func_id, prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index cd0a532db4e7..22219544410f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4061,7 +4061,8 @@ BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *,=
 xdp, struct bpf_map *, map,
=20
 	if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
 		return -EINVAL;
-	if (unlikely(xdp_size > (unsigned long)(xdp->data_end - xdp->data)))
+	if (unlikely(!xdp ||
+		     xdp_size > (unsigned long)(xdp->data_end - xdp->data)))
 		return -EFAULT;
=20
 	return bpf_event_output(map, flags, meta, meta_size, xdp->data,
@@ -4079,6 +4080,19 @@ static const struct bpf_func_proto bpf_xdp_event_o=
utput_proto =3D {
 	.arg5_type	=3D ARG_CONST_SIZE_OR_ZERO,
 };
=20
+static int bpf_xdp_output_btf_ids[5];
+const struct bpf_func_proto bpf_xdp_output_proto =3D {
+	.func		=3D bpf_xdp_event_output,
+	.gpl_only	=3D true,
+	.ret_type	=3D RET_INTEGER,
+	.arg1_type	=3D ARG_PTR_TO_BTF_ID,
+	.arg2_type	=3D ARG_CONST_MAP_PTR,
+	.arg3_type	=3D ARG_ANYTHING,
+	.arg4_type	=3D ARG_PTR_TO_MEM,
+	.arg5_type	=3D ARG_CONST_SIZE_OR_ZERO,
+	.btf_id		=3D bpf_xdp_output_btf_ids,
+};
+
 BPF_CALL_1(bpf_get_socket_cookie, struct sk_buff *, skb)
 {
 	return skb->sk ? sock_gen_cookie(skb->sk) : 0;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 40b2d9476268..41a90e2d5821 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2914,6 +2914,30 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * int bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *d=
ata, u64 size)
+ *	Description
+ *		Write raw *data* blob into a special BPF perf event held by
+ *		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
+ *		event must have the following attributes: **PERF_SAMPLE_RAW**
+ *		as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
+ *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
+ *
+ *		The *flags* are used to indicate the index in *map* for which
+ *		the value must be put, masked with **BPF_F_INDEX_MASK**.
+ *		Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
+ *		to indicate that the index of the current CPU core should be
+ *		used.
+ *
+ *		The value to write, of *size*, is passed through eBPF stack and
+ *		pointed by *data*.
+ *
+ *		*ctx* is a pointer to in-kernel struct xdp_buff.
+ *
+ *		This helper is similar to **bpf_perf_eventoutput**\ () but
+ *		restricted to raw_tracepoint bpf programs.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3035,7 +3059,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(xdp_output),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
index 4ba011031d4c..a0f688c37023 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
@@ -4,17 +4,51 @@
 #include "test_xdp.skel.h"
 #include "test_xdp_bpf2bpf.skel.h"
=20
+struct meta {
+	int ifindex;
+	int pkt_len;
+};
+
+static void on_sample(void *ctx, int cpu, void *data, __u32 size)
+{
+	int duration =3D 0;
+	struct meta *meta =3D (struct meta *)data;
+	struct ipv4_packet *trace_pkt_v4 =3D data + sizeof(*meta);
+
+	if (CHECK(size < sizeof(pkt_v4) + sizeof(*meta),
+		  "check_size", "size %u < %zu\n",
+		  size, sizeof(pkt_v4) + sizeof(*meta)))
+		return;
+
+	if (CHECK(meta->ifindex !=3D if_nametoindex("lo"), "check_meta_ifindex"=
,
+		  "meta->ifindex =3D %d\n", meta->ifindex))
+		return;
+
+	if (CHECK(meta->pkt_len !=3D sizeof(pkt_v4), "check_meta_pkt_len",
+		  "meta->pkt_len =3D %zd\n", sizeof(pkt_v4)))
+		return;
+
+	if (CHECK(memcmp(trace_pkt_v4, &pkt_v4, sizeof(pkt_v4)),
+		  "check_packet_content", "content not the same\n"))
+		return;
+
+	*(bool *)ctx =3D true;
+}
+
 void test_xdp_bpf2bpf(void)
 {
 	__u32 duration =3D 0, retval, size;
 	char buf[128];
 	int err, pkt_fd, map_fd;
+	bool passed =3D false;
 	struct iphdr *iph =3D (void *)buf + sizeof(struct ethhdr);
 	struct iptnl_info value4 =3D {.family =3D AF_INET};
 	struct test_xdp *pkt_skel =3D NULL;
 	struct test_xdp_bpf2bpf *ftrace_skel =3D NULL;
 	struct vip key4 =3D {.protocol =3D 6, .family =3D AF_INET};
 	struct bpf_program *prog;
+	struct perf_buffer *pb =3D NULL;
+	struct perf_buffer_opts pb_opts =3D {};
=20
 	/* Load XDP program to introspect */
 	pkt_skel =3D test_xdp__open_and_load();
@@ -50,6 +84,14 @@ void test_xdp_bpf2bpf(void)
 	if (CHECK(err, "ftrace_attach", "ftrace attach failed: %d\n", err))
 		goto out;
=20
+	/* Set up perf buffer */
+	pb_opts.sample_cb =3D on_sample;
+	pb_opts.ctx =3D &passed;
+	pb =3D perf_buffer__new(bpf_map__fd(ftrace_skel->maps.perf_buf_map),
+			      1, &pb_opts);
+	if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
+		goto out;
+
 	/* Run test program */
 	err =3D bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
@@ -60,6 +102,15 @@ void test_xdp_bpf2bpf(void)
 		  err, errno, retval, size))
 		goto out;
=20
+	/* Make sure bpf_xdp_output() was triggered and it sent the expected
+	 * data to the perf ring buffer.
+	 */
+	err =3D perf_buffer__poll(pb, 100);
+	if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
+		goto out;
+
+	CHECK_FAIL(!passed);
+
 	/* Verify test results */
 	if (CHECK(ftrace_skel->bss->test_result_fentry !=3D if_nametoindex("lo"=
),
 		  "result", "fentry failed err %llu\n",
@@ -70,6 +121,8 @@ void test_xdp_bpf2bpf(void)
 	      "fexit failed err %llu\n", ftrace_skel->bss->test_result_fexit);
=20
 out:
+	if (pb)
+		perf_buffer__free(pb);
 	test_xdp__destroy(pkt_skel);
 	test_xdp_bpf2bpf__destroy(ftrace_skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index 42dd2fedd588..a038e827f850 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -3,6 +3,8 @@
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_helpers.h>
=20
+char _license[] SEC("license") =3D "GPL";
+
 struct net_device {
 	/* Structure does not need to contain all entries,
 	 * as "preserve_access_index" will use BTF to fix this...
@@ -27,10 +29,32 @@ struct xdp_buff {
 	struct xdp_rxq_info *rxq;
 } __attribute__((preserve_access_index));
=20
+struct meta {
+	int ifindex;
+	int pkt_len;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} perf_buf_map SEC(".maps");
+
 __u64 test_result_fentry =3D 0;
 SEC("fentry/FUNC")
 int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
 {
+	struct meta meta;
+	void *data_end =3D (void *)(long)xdp->data_end;
+	void *data =3D (void *)(long)xdp->data;
+
+	meta.ifindex =3D xdp->rxq->dev->ifindex;
+	meta.pkt_len =3D data_end - data;
+	bpf_xdp_output(xdp, &perf_buf_map,
+		       ((__u64) meta.pkt_len << 32) |
+		       BPF_F_CURRENT_CPU,
+		       &meta, sizeof(meta));
+
 	test_result_fentry =3D xdp->rxq->dev->ifindex;
 	return 0;
 }

