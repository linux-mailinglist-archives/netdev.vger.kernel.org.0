Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903E33609E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfFEP6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:58:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36200 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728390AbfFEP6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:58:01 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55FnYm6005270
        for <netdev@vger.kernel.org>; Wed, 5 Jun 2019 08:58:00 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxf95gc23-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 08:57:59 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 5 Jun 2019 08:57:57 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id EAEE723248ABD; Wed,  5 Jun 2019 08:57:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <toke@redhat.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 1/1] bpf: Allow bpf_map_lookup_elem() on an xskmap
Date:   Wed, 5 Jun 2019 08:57:56 -0700
Message-ID: <20190605155756.3779466-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190605155756.3779466-1-jonathan.lemon@gmail.com>
References: <20190605155756.3779466-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050099
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the AF_XDP code uses a separate map in order to
determine if an xsk is bound to a queue.  Instead of doing this,
have bpf_map_lookup_elem() return a xdp_sock.

Rearrange some xdp_sock members to eliminate structure holes.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/bpf.h                           |  8 ++++
 include/net/xdp_sock.h                        |  4 +-
 include/uapi/linux/bpf.h                      |  4 ++
 kernel/bpf/verifier.c                         | 26 +++++++++++-
 kernel/bpf/xskmap.c                           |  7 ++++
 net/core/filter.c                             | 40 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  4 ++
 .../bpf/verifier/prevent_map_lookup.c         | 15 -------
 tools/testing/selftests/bpf/verifier/sock.c   | 18 +++++++++
 9 files changed, 107 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ff3e00ff84d2..66b175bdc645 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -276,6 +276,7 @@ enum bpf_reg_type {
 	PTR_TO_TCP_SOCK,	 /* reg points to struct tcp_sock */
 	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
+	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -670,6 +671,13 @@ void __cpu_map_insert_ctx(struct bpf_map *map, u32 index);
 void __cpu_map_flush(struct bpf_map *map);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
+				  struct bpf_insn_access_aux *info);
+u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
+				    const struct bpf_insn *si,
+				    struct bpf_insn *insn_buf,
+				    struct bpf_prog *prog,
+				    u32 *target_size);
 
 /* Return map's numa specified by userspace */
 static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..ae0f368a62bb 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -58,11 +58,11 @@ struct xdp_sock {
 	struct xdp_umem *umem;
 	struct list_head flush_node;
 	u16 queue_id;
-	struct xsk_queue *tx ____cacheline_aligned_in_smp;
-	struct list_head list;
 	bool zc;
 	/* Protects multiple processes in the control path */
 	struct mutex mutex;
+	struct xsk_queue *tx ____cacheline_aligned_in_smp;
+	struct list_head list;
 	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
 	 * in the SKB destructor callback.
 	 */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7c6aef253173..ae0907d8c03a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3083,6 +3083,10 @@ struct bpf_sock_tuple {
 	};
 };
 
+struct bpf_xdp_sock {
+	__u32 queue_id;
+};
+
 #define XDP_PACKET_HEADROOM 256
 
 /* User return codes for XDP prog type.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2778417e6e0c..abe177405989 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -334,7 +334,8 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 {
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_SOCK_COMMON ||
-		type == PTR_TO_TCP_SOCK;
+		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_XDP_SOCK;
 }
 
 static bool reg_type_may_be_null(enum bpf_reg_type type)
@@ -406,6 +407,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_TCP_SOCK]	= "tcp_sock",
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
+	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 };
 
 static char slot_type_char[] = {
@@ -1363,6 +1365,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_XDP_SOCK:
 		return true;
 	default:
 		return false;
@@ -1843,6 +1846,9 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	case PTR_TO_TCP_SOCK:
 		valid = bpf_tcp_sock_is_valid_access(off, size, t, &info);
 		break;
+	case PTR_TO_XDP_SOCK:
+		valid = bpf_xdp_sock_is_valid_access(off, size, t, &info);
+		break;
 	default:
 		valid = false;
 	}
@@ -2007,6 +2013,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 		pointer_desc = "tcp_sock ";
 		break;
+	case PTR_TO_XDP_SOCK:
+		pointer_desc = "xdp_sock ";
+		break;
 	default:
 		break;
 	}
@@ -2905,10 +2914,14 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	 * appear.
 	 */
 	case BPF_MAP_TYPE_CPUMAP:
-	case BPF_MAP_TYPE_XSKMAP:
 		if (func_id != BPF_FUNC_redirect_map)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_map_lookup_elem)
+			goto error;
+		break;
 	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
 	case BPF_MAP_TYPE_HASH_OF_MAPS:
 		if (func_id != BPF_FUNC_map_lookup_elem)
@@ -3799,6 +3812,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_XDP_SOCK:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
@@ -5038,6 +5052,9 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 			if (reg->map_ptr->inner_map_meta) {
 				reg->type = CONST_PTR_TO_MAP;
 				reg->map_ptr = reg->map_ptr->inner_map_meta;
+			} else if (reg->map_ptr->map_type ==
+				   BPF_MAP_TYPE_XSKMAP) {
+				reg->type = PTR_TO_XDP_SOCK;
 			} else {
 				reg->type = PTR_TO_MAP_VALUE;
 			}
@@ -6289,6 +6306,7 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_XDP_SOCK:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
 		 */
@@ -6683,6 +6701,7 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type type)
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_XDP_SOCK:
 		return false;
 	default:
 		return true;
@@ -7816,6 +7835,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		case PTR_TO_TCP_SOCK:
 			convert_ctx_access = bpf_tcp_sock_convert_ctx_access;
 			break;
+		case PTR_TO_XDP_SOCK:
+			convert_ctx_access = bpf_xdp_sock_convert_ctx_access;
+			break;
 		default:
 			continue;
 		}
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 686d244e798d..b5c58e9c4835 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -153,6 +153,12 @@ void __xsk_map_flush(struct bpf_map *map)
 }
 
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return __xsk_map_lookup_elem(map, *(u32 *)key);
+}
+
+static void *xsk_map_lookup_elem_sys_only(struct bpf_map *map, void *key)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
@@ -220,6 +226,7 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_free = xsk_map_free,
 	.map_get_next_key = xsk_map_get_next_key,
 	.map_lookup_elem = xsk_map_lookup_elem,
+	.map_lookup_elem_sys_only = xsk_map_lookup_elem_sys_only,
 	.map_update_elem = xsk_map_update_elem,
 	.map_delete_elem = xsk_map_delete_elem,
 	.map_check_btf = map_check_no_btf,
diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..f2d9d77b4b57 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5680,6 +5680,46 @@ BPF_CALL_1(bpf_skb_ecn_set_ce, struct sk_buff *, skb)
 	return INET_ECN_set_ce(skb);
 }
 
+bool bpf_xdp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
+				  struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= offsetofend(struct bpf_xdp_sock, queue_id))
+		return false;
+
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	default:
+		return size == sizeof(__u32);
+	}
+}
+
+u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
+				    const struct bpf_insn *si,
+				    struct bpf_insn *insn_buf,
+				    struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+#define BPF_XDP_SOCK_GET(FIELD)						\
+	do {								\
+		BUILD_BUG_ON(FIELD_SIZEOF(struct xdp_sock, FIELD) >	\
+			     FIELD_SIZEOF(struct bpf_xdp_sock, FIELD));	\
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_sock, FIELD),\
+				      si->dst_reg, si->src_reg,		\
+				      offsetof(struct xdp_sock, FIELD)); \
+	} while (0)
+
+	switch (si->off) {
+	case offsetof(struct bpf_xdp_sock, queue_id):
+		BPF_XDP_SOCK_GET(queue_id);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
 static const struct bpf_func_proto bpf_skb_ecn_set_ce_proto = {
 	.func           = bpf_skb_ecn_set_ce,
 	.gpl_only       = false,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7c6aef253173..ae0907d8c03a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3083,6 +3083,10 @@ struct bpf_sock_tuple {
 	};
 };
 
+struct bpf_xdp_sock {
+	__u32 queue_id;
+};
+
 #define XDP_PACKET_HEADROOM 256
 
 /* User return codes for XDP prog type.
diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
index bbdba990fefb..da7a4b37cb98 100644
--- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
@@ -28,21 +28,6 @@
 	.errstr = "cannot pass map_type 18 into func bpf_map_lookup_elem",
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },
-{
-	"prevent map lookup in xskmap",
-	.insns = {
-	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-	BPF_LD_MAP_FD(BPF_REG_1, 0),
-	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_EXIT_INSN(),
-	},
-	.fixup_map_xskmap = { 3 },
-	.result = REJECT,
-	.errstr = "cannot pass map_type 17 into func bpf_map_lookup_elem",
-	.prog_type = BPF_PROG_TYPE_XDP,
-},
 {
 	"prevent map lookup in stack trace",
 	.insns = {
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index b31cd2cf50d0..9ed192e14f5f 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -498,3 +498,21 @@
 	.result = REJECT,
 	.errstr = "cannot pass map_type 24 into func bpf_map_lookup_elem",
 },
+{
+	"bpf_map_lookup_elem(xskmap, &key); xs->queue_id",
+	.insns = {
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_xdp_sock, queue_id)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_xskmap = { 3 },
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.result = ACCEPT,
+},
-- 
2.17.1

