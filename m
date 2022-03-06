Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80514CEEB1
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiCFXo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiCFXoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:44:20 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBA240E78;
        Sun,  6 Mar 2022 15:43:25 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id bc27so12153446pgb.4;
        Sun, 06 Mar 2022 15:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=viufb9svbOee7nVQSmYexlXk/QoK2XrV/MZnnyUZYdM=;
        b=BCM4vtlICZ4xHLjwagUbQjAC9Obw+47okAL5vDAU2r65mClLmSp7zrhd6mzCcFX9La
         YmuSWZ3dV+zTd83YXzLfiL87AYHCkfeJmIIr5SSYwzQkbmicHXtgxSbXujt0pWB5Ge2j
         Rn3lVObLqvnKIjGO6abTjP7OoNwql5FY3UdjXRGfgcQIdqHJX+/LsKXUlBhM4KHko8hB
         qsoDOmKgzDb6womsIelJZtly6g3tZ5hsweVjoY9m1/S/EFQHltZgHOO6ZpOqGSWSlrMn
         MFfWjIfZZpiSwMxh8sFHkE9CidLC9HyJeR5KKS6eJWS1/6sCIq+HAeQ7tuQZetqbS8/y
         5TGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=viufb9svbOee7nVQSmYexlXk/QoK2XrV/MZnnyUZYdM=;
        b=HmQb3gbBc7CqC3rJUchEQdqHLrUH7de8sW7bvvHRNz6jCRlP/QBUn7kj9fav043O4M
         +CSvDIdGLJjxR3g1yl2yPR1FJvKB+bIklBAk4ber+niACF68LBWaGapSKmhlWHf3INzv
         QRcbv45rD7vPaXbBv7NNYd3yUYNQSHAdWu7ML1W9uBd1nDI/PleknMM4v8dYr8LSAo4p
         KENVkRugVRHBIGPbhFb0xAyPEgURbS968UBqCXAWOucMMZrMJzaNkbVCbavu2737aa4q
         FkNP9Jw9P6lw3stZF/jDKP6zz0xNCJxOUGG+XH18mPz0fjWNEUmk9OGLLbyJOcHcB50d
         xLAA==
X-Gm-Message-State: AOAM532faU9BU1wZJkQOJE7Boy06f6bsfh4KpcB8Q4UvpId+JPirvvQI
        FiJ6BDsvfuFsLQDIUJdE9TLmTncARFk=
X-Google-Smtp-Source: ABdhPJzKL30Eh/5E0zTyHdSO5QSaDje+44DFz8njRWrON5b5QJpBkQUUVhtOhPtfXKg5EOPCOyHnBg==
X-Received: by 2002:aa7:85d8:0:b0:4f6:8ae9:16a8 with SMTP id z24-20020aa785d8000000b004f68ae916a8mr10068931pfn.15.1646610204462;
        Sun, 06 Mar 2022 15:43:24 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id k7-20020a63ff07000000b00372dc67e854sm9984278pgi.14.2022.03.06.15.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:43:24 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 3/5] bpf: Introduce bpf_packet_pointer helper to do DPA
Date:   Mon,  7 Mar 2022 05:13:09 +0530
Message-Id: <20220306234311.452206-4-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306234311.452206-1-memxor@gmail.com>
References: <20220306234311.452206-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10943; h=from:subject; bh=E4Gz+N0WC+39oXuLsAtTzzz6Tby4HR9hqTU+laFyc2s=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiJUWoRgu92UDUVnnst7FwTltipumkolBF+PQKaOZQ Rt0ww+GJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYiVFqAAKCRBM4MiGSL8RyppDEA CdVE9NUvohDqu644WBVZuNQpjOYsi2gNHd6sDn2gWMCjBGVCcgf03J1Az89lWfhtmLQHlwVI7pae6m iRAixnWDzbHm7z35GHDir5QQTYdROnhnDn92K8oG2aJ16l/HBNkpO7rxv6CY/wKJ8q8KpTRjuR1ljT am+rNFzAwMQIL446Afq0scOBpkVbWiHCCRMYNulzUsqzZHFESu+4Y1zTWOW7WDJZVRvEqFrUlZHcsf V299V/FPZUQv9SfuvLXPPY0Z5Herfy42yelJqCvZAvcaX21T69ppqR4eLQQkpdL2aaZX214NY6IJ/M CbaSCIdn67oCX2VBuundCI7EWu4AddWI3YZ+L/YCeHTT3M2Rp/A5eO71kwCCTGG3LWbnW6QIdr9B1Z VhmpJ8w5jNoPvNRLBtbq17qaVp+B4sDLH/xv3lXyUZs98QsV9yNItoQYA5k/drB+Sc+W6YDIP2nBLF PJe3gwWRtuqq2XLLCek9IVln6K8eOwxYjRHy5oiQd6l7VSEaVhxuTgPxIZM8CIkayTlw3GQ4vI6gMJ lpEcX4+yw7WCQgV+8KKIhpD5ZQzoaa6kROjazsPL3yhyEaeggLZjoQIUL4JsqFgTEs4k7cIBqvDyhF qRenrzZk4qafsOatOd98y5DvoLEG59Mgh913gCn141DGJaG/CyzJhJuNhCbQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper 'bpf_packet_pointer', that returns a packet
pointer to a linear area in a possibly multi-buffer XDP buff. Earlier,
user had to use bpf_xdp_load_bytes and bpf_xdp_store_bytes to read from
and write to multi-bufer XDP buff, but this led to a memcpy for an ideal
case (where we detect a linear area in the initial frame or frags).
Instead, we can expose the bpf_packet_pointer function, and return a
packet pointer with a fixed range, so that user can do direct packet
access in the contiguous region.

The name bpf_packet_pointer is chosen so this helper can also be
implemented for TC programs in the future, using skb as ctx.

The helper either returns the pointer to linear contiguous area, or NULL
if it fails to find one. In that case, user can resort to the existing
helpers to do access across frame or frag boundaries. The case of offset
+ len > xdp_get_buff_len is still rejected, but the user can already
check for that beforehand so the error code is dropped for it, and NULL
is returned.

We use the support for ARG_SCALAR, ARG_CONSTANT, and pkt_uid for
PTR_TO_PACKET in this commit. First, it is enforced that offset is only
in range [0, 0xffff], and that len is a constant, with value in range
[1, 0xffff]. Then, we introduce ret_pkt_len member in bpf_call_arg_meta
to remember the length to set for the returned packet pointer. A fresh
ID is assigned to pkt_uid on each call, so that comparisons of these
PTR_TO_PACKET is rejected with existing packet pointers obtained from
ctx or other calls to bpf_packet_pointer, to prevent range manipulation.
The existing bpf_xdp_load_bytes/bpf_xdp_store_bytes now do a call to
bpf_xdp_copy_buf directly. The intended usage is that user first calls
bpf_packet_pointer, and on receiving NULL from the call, invokes these
'slow path' helpers that handle the access across head/frag boundary.

Note that the reason we choose PTR_TO_PACKET as the return value, and
not PTR_TO_MEM with a fixed mem_size, is because these pointers need
to be invalided (by clear_all_pkt_pointers) when a helper that changes
packet is invoked. Instead of special casing PTR_TO_MEM for that
purpose, it is better to adjust PTR_TO_PACKET to work for this mode with
minimal additions on the verifier side (from previous commit). Also, the
verifier errors related to bad access mention pkt pointer and not
pointer to memory, which is more meaningful to the BPF programmer.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h            |  2 ++
 include/uapi/linux/bpf.h       | 12 +++++++++
 kernel/bpf/verifier.c          | 37 ++++++++++++++++++++++++++
 net/core/filter.c              | 48 +++++++++++++++++-----------------
 tools/include/uapi/linux/bpf.h | 12 +++++++++
 5 files changed, 87 insertions(+), 24 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7841d90b83df..981e87c64e47 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -421,6 +421,7 @@ enum bpf_return_type {
 	RET_PTR_TO_ALLOC_MEM,		/* returns a pointer to dynamically allocated memory */
 	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
+	RET_PTR_TO_PACKET,		/* returns a pointer to a packet */
 	__BPF_RET_TYPE_MAX,
 
 	/* Extended ret_types. */
@@ -430,6 +431,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_SOCK_COMMON,
 	RET_PTR_TO_ALLOC_MEM_OR_NULL	= PTR_MAYBE_NULL | MEM_ALLOC | RET_PTR_TO_ALLOC_MEM,
 	RET_PTR_TO_BTF_ID_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_BTF_ID,
+	RET_PTR_TO_PACKET_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_PACKET,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4eebea830613..3736cfbb325e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5117,6 +5117,17 @@ union bpf_attr {
  *		0 on success.
  *		**-EINVAL** for invalid input
  *		**-EOPNOTSUPP** for unsupported delivery_time_type and protocol
+ *
+ * void *bpf_packet_pointer(void *ctx, u32 offset, u32 len)
+ *	Description
+ *		Return a pointer to linear area in packet at *offset* of length
+ *		*len*. The returned packet pointer cannot be compared to any
+ *		other packet pointers.
+ *
+ *		This helper is only available to XDP programs.
+ *	Return
+ *		Pointer to packet on success that can be accessed for *len*
+ *		bytes, or NULL when it fails.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5312,6 +5323,7 @@ union bpf_attr {
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
 	FN(skb_set_delivery_time),      \
+	FN(packet_pointer),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 88ac2c833bed..e6e494e07f4c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -257,6 +257,7 @@ struct bpf_call_arg_meta {
 	struct btf *ret_btf;
 	u32 ret_btf_id;
 	u32 subprogno;
+	int ret_pkt_len;
 };
 
 struct btf *btf_vmlinux;
@@ -5654,6 +5655,32 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			verbose(env, "R%d is not a known constant\n", regno);
 			return -EACCES;
 		}
+
+		if (meta->func_id == BPF_FUNC_packet_pointer) {
+			struct tnum range;
+
+			switch (arg + 1) {
+			case 2:
+				/* arg2 = offset, enforce that the range is [0, 0xffff] */
+				range = tnum_range(0, 0xffff);
+				if (!tnum_in(range, reg->var_off)) {
+					verbose(env, "R%d must be in range [0, 0xffff]\n", regno);
+					return -EINVAL;
+				}
+				break;
+			case 3:
+				/* arg3 = len, already checked to be constant */
+				if (!reg->var_off.value || reg->var_off.value > 0xffff) {
+					verbose(env, "R%d must be in range [1, 0xffff]\n", regno);
+					return -EINVAL;
+				}
+				meta->ret_pkt_len = reg->var_off.value;
+				break;
+			default:
+				verbose(env, "verifier internal error: bpf_xdp_pointer unknown arg\n");
+				return -EFAULT;
+			}
+		}
 	}
 
 	return err;
@@ -6873,6 +6900,16 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		 */
 		regs[BPF_REG_0].btf = btf_vmlinux;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
+	} else if (base_type(ret_type) == RET_PTR_TO_PACKET) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
+		regs[BPF_REG_0].pkt_uid = ++env->id_gen;
+		if (!meta.ret_pkt_len) {
+			verbose(env, "verifier internal error: ret_pkt_len unset\n");
+			return -EFAULT;
+		}
+		/* Already checked to be in range [1, 0xffff] */
+		regs[BPF_REG_0].range = meta.ret_pkt_len;
 	} else {
 		verbose(env, "unknown return type %u of func %s#%d\n",
 			base_type(ret_type), func_id_name(func_id), func_id);
diff --git a/net/core/filter.c b/net/core/filter.c
index 88767f7da150..4fc19b9e64c7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3889,18 +3889,15 @@ static void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
 	}
 }
 
-static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
+BPF_CALL_3(bpf_xdp_pointer, struct xdp_buff *, xdp, u32, offset, u32, len)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 	u32 size = xdp->data_end - xdp->data;
 	void *addr = xdp->data;
 	int i;
 
-	if (unlikely(offset > 0xffff || len > 0xffff))
-		return ERR_PTR(-EFAULT);
-
 	if (offset + len > xdp_get_buff_len(xdp))
-		return ERR_PTR(-EINVAL);
+		return (unsigned long)NULL;
 
 	if (offset < size) /* linear area */
 		goto out;
@@ -3917,23 +3914,28 @@ static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 		offset -= frag_size;
 	}
 out:
-	return offset + len < size ? addr + offset : NULL;
+	return offset + len < size ? (unsigned long)addr + offset : (unsigned long)NULL;
 }
 
+static const struct bpf_func_proto bpf_xdp_pointer_proto = {
+	.func		= bpf_xdp_pointer,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_PACKET_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_SCALAR,
+	.arg3_type	= ARG_CONSTANT,
+};
+
 BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
 	   void *, buf, u32, len)
 {
-	void *ptr;
-
-	ptr = bpf_xdp_pointer(xdp, offset, len);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
+	if (unlikely(offset > 0xffff || len > 0xffff))
+		return -EFAULT;
 
-	if (!ptr)
-		bpf_xdp_copy_buf(xdp, offset, buf, len, false);
-	else
-		memcpy(buf, ptr, len);
+	if (offset + len > xdp_get_buff_len(xdp))
+		return -EINVAL;
 
+	bpf_xdp_copy_buf(xdp, offset, buf, len, false);
 	return 0;
 }
 
@@ -3950,17 +3952,13 @@ static const struct bpf_func_proto bpf_xdp_load_bytes_proto = {
 BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
 	   void *, buf, u32, len)
 {
-	void *ptr;
-
-	ptr = bpf_xdp_pointer(xdp, offset, len);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
+	if (unlikely(offset > 0xffff || len > 0xffff))
+		return -EFAULT;
 
-	if (!ptr)
-		bpf_xdp_copy_buf(xdp, offset, buf, len, true);
-	else
-		memcpy(ptr, buf, len);
+	if (offset + len > xdp_get_buff_len(xdp))
+		return -EINVAL;
 
+	bpf_xdp_copy_buf(xdp, offset, buf, len, true);
 	return 0;
 }
 
@@ -7820,6 +7818,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_load_bytes_proto;
 	case BPF_FUNC_xdp_store_bytes:
 		return &bpf_xdp_store_bytes_proto;
+	case BPF_FUNC_packet_pointer:
+		return &bpf_xdp_pointer_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4eebea830613..3736cfbb325e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5117,6 +5117,17 @@ union bpf_attr {
  *		0 on success.
  *		**-EINVAL** for invalid input
  *		**-EOPNOTSUPP** for unsupported delivery_time_type and protocol
+ *
+ * void *bpf_packet_pointer(void *ctx, u32 offset, u32 len)
+ *	Description
+ *		Return a pointer to linear area in packet at *offset* of length
+ *		*len*. The returned packet pointer cannot be compared to any
+ *		other packet pointers.
+ *
+ *		This helper is only available to XDP programs.
+ *	Return
+ *		Pointer to packet on success that can be accessed for *len*
+ *		bytes, or NULL when it fails.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5312,6 +5323,7 @@ union bpf_attr {
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
 	FN(skb_set_delivery_time),      \
+	FN(packet_pointer),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.35.1

