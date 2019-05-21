Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75225923
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfEUUkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:40:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbfEUUki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdCXI007748;
        Tue, 21 May 2019 20:39:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=O+d3cs6EHBRMkNkmEa4i1nth8JR64IFRUfuHaAkdBBA=;
 b=SLgDVFW/oE5GfBNrIERrVRANFsn71H/6iYz3VGMbq/AhEFtxGtFQdcVacF3IJEZ93V/+
 ix7BbwVizwQ1a0A7VquzJoIgZxG/GG+CwjeSGQzHqLlJrh472DqED6p5stLz8y7uRNXJ
 jW9o8tbLMDBAPecIBtoST7wKefXeDuZPxsMaJYOyq7LfwfGtI+ZL4ttJspKe5ZgoQuaw
 joppu9GIMkDhNWvucjywBJRl4cYxCF8/AUEkOwobw8bI48F+2uoIORFKXEKwHfbvXr12
 ENKhgvhYuatZko+9nB1PU6ua1qXEWGD7kkg8E8Ch7SkFWKhoWWeWLEFPlbpez7Ls8KLk Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sjapqfvvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdaup128026;
        Tue, 21 May 2019 20:39:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1ydph5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:39:53 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKdq5x128935;
        Tue, 21 May 2019 20:39:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sks1ydpgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LKdpJ8024030;
        Tue, 21 May 2019 20:39:51 GMT
Message-Id: <201905212039.x4LKdpJ8024030@userv0122.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 21 May 2019 20:39:50 +0000
MIME-Version: 1.0
Date:   Tue, 21 May 2019 20:39:51 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 07/11] bpf: implement writable buffers in contexts
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, BPF supports writes to packet data in very specific cases.
The implementation can be of more general use and can be extended to any
number of writable buffers in a context.  The implementation adds two new
register types: PTR_TO_BUFFER and PTR_TO_BUFFER_END, similar to the types
PTR_TO_PACKET and PTR_TO_PACKET_END.  In addition, a field 'buf_id' is
added to the reg_state structure as a way to distinguish between different
buffers in a single context.

Buffers are specified in the context by a pair of members:
- a pointer to the start of the buffer (type PTR_TO_BUFFER)
- a pointer to the first byte beyond the buffer (type PTR_TO_BUFFER_END)

A context can contain multiple buffers.  Each buffer/buffer_end pair is
identified by a unique id (buf_id).  The start-of-buffer member offset is
usually a good unique identifier.

The semantics for using a writable buffer are the same as for packet data.
The BPF program must contain a range test (buf + num > buf_end) to ensure
that the verifier can verify that offsets are within the allowed range.

Whenever a helper is called that might update the content of the context
all range information for registers that hold pointers to a buffer is
cleared, just as it is done for packet pointers.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/linux/bpf.h          |   3 +
 include/linux/bpf_verifier.h |   4 +-
 kernel/bpf/verifier.c        | 198 ++++++++++++++++++++++++-----------
 3 files changed, 145 insertions(+), 60 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e4bcb79656c4..fc3eda0192fb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -275,6 +275,8 @@ enum bpf_reg_type {
 	PTR_TO_TCP_SOCK,	 /* reg points to struct tcp_sock */
 	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
+	PTR_TO_BUFFER,		 /* reg points to ctx buffer */
+	PTR_TO_BUFFER_END,	 /* reg points to ctx buffer end */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -283,6 +285,7 @@ enum bpf_reg_type {
 struct bpf_insn_access_aux {
 	enum bpf_reg_type reg_type;
 	int ctx_field_size;
+	u32 buf_id;
 };
 
 static inline void
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1305ccbd8fe6..3538382184f3 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -45,7 +45,7 @@ struct bpf_reg_state {
 	/* Ordering of fields matters.  See states_equal() */
 	enum bpf_reg_type type;
 	union {
-		/* valid when type == PTR_TO_PACKET */
+		/* valid when type == PTR_TO_PACKET | PTR_TO_BUFFER */
 		u16 range;
 
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
@@ -132,6 +132,8 @@ struct bpf_reg_state {
 	 */
 	u32 frameno;
 	enum bpf_reg_liveness live;
+	/* For PTR_TO_BUFFER, to identify distinct buffers in a context. */
+	u32 buf_id;
 };
 
 enum bpf_stack_slot_type {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f9e5536fd1af..5fba4e6f5424 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -406,6 +406,8 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_TCP_SOCK]	= "tcp_sock",
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
+	[PTR_TO_BUFFER]		= "buf",
+	[PTR_TO_BUFFER_END]	= "buf_end",
 };
 
 static char slot_type_char[] = {
@@ -467,6 +469,9 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 				verbose(env, ",off=%d", reg->off);
 			if (type_is_pkt_pointer(t))
 				verbose(env, ",r=%d", reg->range);
+			else if (t == PTR_TO_BUFFER)
+				verbose(env, ",r=%d,bid=%d", reg->range,
+					reg->buf_id);
 			else if (t == CONST_PTR_TO_MAP ||
 				 t == PTR_TO_MAP_VALUE ||
 				 t == PTR_TO_MAP_VALUE_OR_NULL)
@@ -855,6 +860,12 @@ static bool reg_is_pkt_pointer_any(const struct bpf_reg_state *reg)
 	       reg->type == PTR_TO_PACKET_END;
 }
 
+static bool reg_is_buf_pointer_any(const struct bpf_reg_state *reg)
+{
+	return reg_is_pkt_pointer_any(reg) ||
+	       reg->type == PTR_TO_BUFFER || reg->type == PTR_TO_BUFFER_END;
+}
+
 /* Unmodified PTR_TO_PACKET[_META,_END] register from ctx access. */
 static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
 				    enum bpf_reg_type which)
@@ -1550,7 +1561,7 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
 	return err;
 }
 
-#define MAX_PACKET_OFF 0xffff
+#define MAX_BUFFER_OFF 0xffff
 
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 				       const struct bpf_call_arg_meta *meta,
@@ -1585,7 +1596,7 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 	}
 }
 
-static int __check_packet_access(struct bpf_verifier_env *env, u32 regno,
+static int __check_buffer_access(struct bpf_verifier_env *env, u32 regno,
 				 int off, int size, bool zero_size_allowed)
 {
 	struct bpf_reg_state *regs = cur_regs(env);
@@ -1593,14 +1604,15 @@ static int __check_packet_access(struct bpf_verifier_env *env, u32 regno,
 
 	if (off < 0 || size < 0 || (size == 0 && !zero_size_allowed) ||
 	    (u64)off + size > reg->range) {
-		verbose(env, "invalid access to packet, off=%d size=%d, R%d(id=%d,off=%d,r=%d)\n",
-			off, size, regno, reg->id, reg->off, reg->range);
+		verbose(env, "invalid access to %s, off=%d size=%d, R%d(id=%d,off=%d,r=%d)\n",
+			reg_is_pkt_pointer(reg) ? "packet" : "buffer", off,
+			size, regno, reg->id, reg->off, reg->range);
 		return -EACCES;
 	}
 	return 0;
 }
 
-static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
+static int check_buffer_access(struct bpf_verifier_env *env, u32 regno, int off,
 			       int size, bool zero_size_allowed)
 {
 	struct bpf_reg_state *regs = cur_regs(env);
@@ -1620,35 +1632,37 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 			regno);
 		return -EACCES;
 	}
-	err = __check_packet_access(env, regno, off, size, zero_size_allowed);
+	err = __check_buffer_access(env, regno, off, size, zero_size_allowed);
 	if (err) {
-		verbose(env, "R%d offset is outside of the packet\n", regno);
+		verbose(env, "R%d offset is outside of the %s\n",
+			regno, reg_is_pkt_pointer(reg) ? "packet" : "buffer");
 		return err;
 	}
 
-	/* __check_packet_access has made sure "off + size - 1" is within u16.
-	 * reg->umax_value can't be bigger than MAX_PACKET_OFF which is 0xffff,
-	 * otherwise find_good_pkt_pointers would have refused to set range info
-	 * that __check_packet_access would have rejected this pkt access.
-	 * Therefore, "off + reg->umax_value + size - 1" won't overflow u32.
-	 */
-	env->prog->aux->max_pkt_offset =
-		max_t(u32, env->prog->aux->max_pkt_offset,
-		      off + reg->umax_value + size - 1);
+	if (reg_is_pkt_pointer(reg)) {
+		/* __check_buffer_access ensures "off + size - 1" is within u16
+		 * reg->umax_value can't be bigger than * MAX_BUFFER_OFF which
+		 * is 0xffff, otherwise find_good_buf_pointers would have
+		 * refused to set range info and __check_buffer_access would
+		 * have rejected this pkt access.
+		 * Therefore, "off + reg->umax_value + size - 1" won't overflow
+		 * u32.
+		 */
+		env->prog->aux->max_pkt_offset =
+			max_t(u32, env->prog->aux->max_pkt_offset,
+			      off + reg->umax_value + size - 1);
+	}
 
 	return err;
 }
 
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
-static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
-			    enum bpf_access_type t, enum bpf_reg_type *reg_type)
+static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx,
+			    int off, int size, enum bpf_access_type t,
+			    struct bpf_insn_access_aux *info)
 {
-	struct bpf_insn_access_aux info = {
-		.reg_type = *reg_type,
-	};
-
 	if (env->ops->is_valid_access &&
-	    env->ops->is_valid_access(off, size, t, env->prog, &info)) {
+	    env->ops->is_valid_access(off, size, t, env->prog, info)) {
 		/* A non zero info.ctx_field_size indicates that this field is a
 		 * candidate for later verifier transformation to load the whole
 		 * field and then apply a mask when accessed with a narrower
@@ -1656,9 +1670,7 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
 		 * will only allow for whole field access and rejects any other
 		 * type of narrower access.
 		 */
-		*reg_type = info.reg_type;
-
-		env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
+		env->insn_aux_data[insn_idx].ctx_field_size = info->ctx_field_size;
 		/* remember the offset of last byte accessed in ctx */
 		if (env->prog->aux->max_ctx_offset < off + size)
 			env->prog->aux->max_ctx_offset = off + size;
@@ -1870,6 +1882,10 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 		pointer_desc = "tcp_sock ";
 		break;
+	case PTR_TO_BUFFER:
+		pointer_desc = "buffer ";
+		strict = true;
+		break;
 	default:
 		break;
 	}
@@ -2084,7 +2100,11 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			mark_reg_unknown(env, regs, value_regno);
 
 	} else if (reg->type == PTR_TO_CTX) {
-		enum bpf_reg_type reg_type = SCALAR_VALUE;
+		struct bpf_insn_access_aux info = {
+			.reg_type = SCALAR_VALUE,
+			.buf_id = 0,
+		};
+
 
 		if (t == BPF_WRITE && value_regno >= 0 &&
 		    is_pointer_value(env, value_regno)) {
@@ -2096,21 +2116,22 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err < 0)
 			return err;
 
-		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type);
+		err = check_ctx_access(env, insn_idx, off, size, t, &info);
 		if (!err && t == BPF_READ && value_regno >= 0) {
 			/* ctx access returns either a scalar, or a
 			 * PTR_TO_PACKET[_META,_END]. In the latter
 			 * case, we know the offset is zero.
 			 */
-			if (reg_type == SCALAR_VALUE) {
+			if (info.reg_type == SCALAR_VALUE) {
 				mark_reg_unknown(env, regs, value_regno);
 			} else {
 				mark_reg_known_zero(env, regs,
 						    value_regno);
-				if (reg_type_may_be_null(reg_type))
+				if (reg_type_may_be_null(info.reg_type))
 					regs[value_regno].id = ++env->id_gen;
 			}
-			regs[value_regno].type = reg_type;
+			regs[value_regno].type = info.reg_type;
+			regs[value_regno].buf_id = info.buf_id;
 		}
 
 	} else if (reg->type == PTR_TO_STACK) {
@@ -2141,7 +2162,17 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 				value_regno);
 			return -EACCES;
 		}
-		err = check_packet_access(env, regno, off, size, false);
+		err = check_buffer_access(env, regno, off, size, false);
+		if (!err && t == BPF_READ && value_regno >= 0)
+			mark_reg_unknown(env, regs, value_regno);
+	} else if (reg->type == PTR_TO_BUFFER) {
+		if (t == BPF_WRITE && value_regno >= 0 &&
+		    is_pointer_value(env, value_regno)) {
+			verbose(env, "R%d leaks addr into buffer\n",
+				value_regno);
+			return -EACCES;
+		}
+		err = check_buffer_access(env, regno, off, size, false);
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_FLOW_KEYS) {
@@ -2382,7 +2413,7 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 	switch (reg->type) {
 	case PTR_TO_PACKET:
 	case PTR_TO_PACKET_META:
-		return check_packet_access(env, regno, reg->off, access_size,
+		return check_buffer_access(env, regno, reg->off, access_size,
 					   zero_size_allowed);
 	case PTR_TO_MAP_VALUE:
 		if (check_map_access_type(env, regno, reg->off, access_size,
@@ -2962,34 +2993,35 @@ static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
 	       check_refcount_ok(fn, func_id) ? 0 : -EINVAL;
 }
 
-/* Packet data might have moved, any old PTR_TO_PACKET[_META,_END]
- * are now invalid, so turn them into unknown SCALAR_VALUE.
+/* Packet or buffer data might have moved, any old PTR_TO_PACKET[_META,_END]
+ * and/or PTR_TO_BUFFER[_END] are now invalid, so turn them into unknown
+ * SCALAR_VALUE.
  */
-static void __clear_all_pkt_pointers(struct bpf_verifier_env *env,
+static void __clear_all_buf_pointers(struct bpf_verifier_env *env,
 				     struct bpf_func_state *state)
 {
 	struct bpf_reg_state *regs = state->regs, *reg;
 	int i;
 
 	for (i = 0; i < MAX_BPF_REG; i++)
-		if (reg_is_pkt_pointer_any(&regs[i]))
+		if (reg_is_buf_pointer_any(&regs[i]))
 			mark_reg_unknown(env, regs, i);
 
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg_is_pkt_pointer_any(reg))
+		if (reg_is_buf_pointer_any(reg))
 			__mark_reg_unknown(reg);
 	}
 }
 
-static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
+static void clear_all_buf_pointers(struct bpf_verifier_env *env)
 {
 	struct bpf_verifier_state *vstate = env->cur_state;
 	int i;
 
 	for (i = 0; i <= vstate->curframe; i++)
-		__clear_all_pkt_pointers(env, vstate->frame[i]);
+		__clear_all_buf_pointers(env, vstate->frame[i]);
 }
 
 static void release_reg_references(struct bpf_verifier_env *env,
@@ -3417,7 +3449,7 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	}
 
 	if (changes_data)
-		clear_all_pkt_pointers(env);
+		clear_all_buf_pointers(env);
 	return 0;
 }
 
@@ -4349,7 +4381,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	return 0;
 }
 
-static void __find_good_pkt_pointers(struct bpf_func_state *state,
+static void __find_good_buf_pointers(struct bpf_func_state *state,
 				     struct bpf_reg_state *dst_reg,
 				     enum bpf_reg_type type, u16 new_range)
 {
@@ -4358,7 +4390,11 @@ static void __find_good_pkt_pointers(struct bpf_func_state *state,
 
 	for (i = 0; i < MAX_BPF_REG; i++) {
 		reg = &state->regs[i];
-		if (reg->type == type && reg->id == dst_reg->id)
+		if (reg->type != type)
+			continue;
+		if (type == PTR_TO_BUFFER && reg->buf_id != dst_reg->buf_id)
+			continue;
+		if (reg->id == dst_reg->id)
 			/* keep the maximum range already checked */
 			reg->range = max(reg->range, new_range);
 	}
@@ -4366,12 +4402,16 @@ static void __find_good_pkt_pointers(struct bpf_func_state *state,
 	bpf_for_each_spilled_reg(i, state, reg) {
 		if (!reg)
 			continue;
-		if (reg->type == type && reg->id == dst_reg->id)
+		if (reg->type != type)
+			continue;
+		if (type == PTR_TO_BUFFER && reg->buf_id != dst_reg->buf_id)
+			continue;
+		if (reg->id == dst_reg->id)
 			reg->range = max(reg->range, new_range);
 	}
 }
 
-static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
+static void find_good_buf_pointers(struct bpf_verifier_state *vstate,
 				   struct bpf_reg_state *dst_reg,
 				   enum bpf_reg_type type,
 				   bool range_right_open)
@@ -4384,8 +4424,8 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 		/* This doesn't give us any range */
 		return;
 
-	if (dst_reg->umax_value > MAX_PACKET_OFF ||
-	    dst_reg->umax_value + dst_reg->off > MAX_PACKET_OFF)
+	if (dst_reg->umax_value > MAX_BUFFER_OFF ||
+	    dst_reg->umax_value + dst_reg->off > MAX_BUFFER_OFF)
 		/* Risk of overflow.  For instance, ptr + (1<<63) may be less
 		 * than pkt_end, but that's because it's also less than pkt.
 		 */
@@ -4440,10 +4480,10 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 	/* If our ids match, then we must have the same max_value.  And we
 	 * don't care about the other reg's fixed offset, since if it's too big
 	 * the range won't allow anything.
-	 * dst_reg->off is known < MAX_PACKET_OFF, therefore it fits in a u16.
+	 * dst_reg->off is known < MAX_BUFFER_OFF, therefore it fits in a u16.
 	 */
 	for (i = 0; i <= vstate->curframe; i++)
-		__find_good_pkt_pointers(vstate->frame[i], dst_reg, type,
+		__find_good_buf_pointers(vstate->frame[i], dst_reg, type,
 					 new_range);
 }
 
@@ -4934,7 +4974,7 @@ static void __mark_ptr_or_null_regs(struct bpf_func_state *state, u32 id,
 	}
 }
 
-/* The logic is similar to find_good_pkt_pointers(), both could eventually
+/* The logic is similar to find_good_buf_pointers(), both could eventually
  * be folded together at some point.
  */
 static void mark_ptr_or_null_regs(struct bpf_verifier_state *vstate, u32 regno,
@@ -4977,14 +5017,24 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 		    (dst_reg->type == PTR_TO_PACKET_META &&
 		     reg_is_init_pkt_pointer(src_reg, PTR_TO_PACKET))) {
 			/* pkt_data' > pkt_end, pkt_meta' > pkt_data */
-			find_good_pkt_pointers(this_branch, dst_reg,
+			find_good_buf_pointers(this_branch, dst_reg,
 					       dst_reg->type, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
 			    src_reg->type == PTR_TO_PACKET_META)) {
 			/* pkt_end > pkt_data', pkt_data > pkt_meta' */
-			find_good_pkt_pointers(other_branch, src_reg,
+			find_good_buf_pointers(other_branch, src_reg,
+					       src_reg->type, true);
+		} else if (dst_reg->type == PTR_TO_BUFFER &&
+			   src_reg->type == PTR_TO_BUFFER_END) {
+			/* buf' > buf_end */
+			find_good_buf_pointers(this_branch, dst_reg,
+					       dst_reg->type, false);
+		} else if (dst_reg->type == PTR_TO_BUFFER_END &&
+			   src_reg->type == PTR_TO_BUFFER) {
+			/* buf_end > buf' */
+			find_good_buf_pointers(other_branch, src_reg,
 					       src_reg->type, true);
 		} else {
 			return false;
@@ -4996,14 +5046,24 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 		    (dst_reg->type == PTR_TO_PACKET_META &&
 		     reg_is_init_pkt_pointer(src_reg, PTR_TO_PACKET))) {
 			/* pkt_data' < pkt_end, pkt_meta' < pkt_data */
-			find_good_pkt_pointers(other_branch, dst_reg,
+			find_good_buf_pointers(other_branch, dst_reg,
 					       dst_reg->type, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
 			    src_reg->type == PTR_TO_PACKET_META)) {
 			/* pkt_end < pkt_data', pkt_data > pkt_meta' */
-			find_good_pkt_pointers(this_branch, src_reg,
+			find_good_buf_pointers(this_branch, src_reg,
+					       src_reg->type, false);
+		} else if (dst_reg->type == PTR_TO_BUFFER &&
+			   src_reg->type == PTR_TO_BUFFER_END) {
+			/* buf' < buf_end */
+			find_good_buf_pointers(other_branch, dst_reg,
+					       dst_reg->type, true);
+		} else if (dst_reg->type == PTR_TO_BUFFER_END &&
+			   src_reg->type == PTR_TO_BUFFER) {
+			/* buf_end < buf' */
+			find_good_buf_pointers(this_branch, src_reg,
 					       src_reg->type, false);
 		} else {
 			return false;
@@ -5015,14 +5075,24 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 		    (dst_reg->type == PTR_TO_PACKET_META &&
 		     reg_is_init_pkt_pointer(src_reg, PTR_TO_PACKET))) {
 			/* pkt_data' >= pkt_end, pkt_meta' >= pkt_data */
-			find_good_pkt_pointers(this_branch, dst_reg,
+			find_good_buf_pointers(this_branch, dst_reg,
 					       dst_reg->type, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
 			    src_reg->type == PTR_TO_PACKET_META)) {
 			/* pkt_end >= pkt_data', pkt_data >= pkt_meta' */
-			find_good_pkt_pointers(other_branch, src_reg,
+			find_good_buf_pointers(other_branch, src_reg,
+					       src_reg->type, false);
+		} else if (dst_reg->type == PTR_TO_BUFFER &&
+			   src_reg->type == PTR_TO_BUFFER_END) {
+			/* buf' >= buf_end */
+			find_good_buf_pointers(this_branch, dst_reg,
+					       dst_reg->type, true);
+		} else if (dst_reg->type == PTR_TO_BUFFER_END &&
+			   src_reg->type == PTR_TO_BUFFER) {
+			/* buf_end >= buf' */
+			find_good_buf_pointers(other_branch, src_reg,
 					       src_reg->type, false);
 		} else {
 			return false;
@@ -5034,15 +5104,25 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 		    (dst_reg->type == PTR_TO_PACKET_META &&
 		     reg_is_init_pkt_pointer(src_reg, PTR_TO_PACKET))) {
 			/* pkt_data' <= pkt_end, pkt_meta' <= pkt_data */
-			find_good_pkt_pointers(other_branch, dst_reg,
+			find_good_buf_pointers(other_branch, dst_reg,
 					       dst_reg->type, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
 			    src_reg->type == PTR_TO_PACKET_META)) {
 			/* pkt_end <= pkt_data', pkt_data <= pkt_meta' */
-			find_good_pkt_pointers(this_branch, src_reg,
+			find_good_buf_pointers(this_branch, src_reg,
 					       src_reg->type, true);
+		} else if (dst_reg->type == PTR_TO_BUFFER &&
+			   src_reg->type == PTR_TO_BUFFER_END) {
+			/* buf' <= buf_end */
+			find_good_buf_pointers(other_branch, dst_reg,
+					       dst_reg->type, true);
+		} else if (dst_reg->type == PTR_TO_BUFFER_END &&
+			   src_reg->type == PTR_TO_BUFFER) {
+			/* buf_end <= buf' */
+			find_good_buf_pointers(this_branch, src_reg,
+					       src_reg->type, false);
 		} else {
 			return false;
 		}
@@ -7972,7 +8052,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			 */
 			prog->cb_access = 1;
 			env->prog->aux->stack_depth = MAX_BPF_STACK;
-			env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
+			env->prog->aux->max_pkt_offset = MAX_BUFFER_OFF;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpeter for every normal
-- 
2.20.1

