Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814426A2EE8
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjBZIw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBZIw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:52:26 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48517113FE;
        Sun, 26 Feb 2023 00:52:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id fd25so1840610pfb.1;
        Sun, 26 Feb 2023 00:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52o5xOJpDnxF18a8dnrnlktDs+mKjtH68NvHREbNkCE=;
        b=mvownvjlHRusIZIon1qr4lycdjG7ll4jBFc2/Xim5Wb2HArJdaV31GSnukJ97OMRpc
         oom+NA3+2G/KcIhqX95d3GSXf4x27S+ZpCo1KK17px6SRxOo5Mxox5vvpFDxTagki9TN
         9UJFNJViOhRvRgaSYs+64MlhsX5Hzqz9HRENjqc7r3a/CWw52UqGiKtJX21Ejecp7B7p
         4BOLbSteZh77qOI6EObZV0SuvqcJ3nzGfKde+GzMmahIV2DA/4TjEstSsMeoGZWxuq1/
         SxNLrx3rpCbFuk3h76MsvwV0Ih+61UEXWvZM3GMQyWJuhWdGW7XgIXSRT0EfnyaQ6qkS
         33Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=52o5xOJpDnxF18a8dnrnlktDs+mKjtH68NvHREbNkCE=;
        b=7ab1n9YdaOai6Uo5Fv+MVftG3mBnB0/K01rMcMr4ec+guU8XR14MAfiSLKjghwzhwi
         4tUEYL7oJkXcvEFWROg6CGt4iTlt43Rpf9F5yow6Zs7TUMmuGTsi3FW0xMekflZ3wtLL
         ynkaVms+UGz7AimBYpETAW71/tLdrMFeTf9F8zcv14+zExiYnY/jUOiMtTprzd+4rsGT
         DNfxYcfZja71EHyiOiZ5at1NjMMEWLJeyc+LldzZmBebhbKLgj6pZ6eTzgQA6PbAUdRs
         7p4jMq8skXylbJypmZN5C5On5yrtWl+cRwz8G3vBE27+WTBgXKCbsg9PVUwUHihIEBJY
         zBiQ==
X-Gm-Message-State: AO0yUKXkbJ7yup8QWcikJKxP4tstmfYnn+aFiE+9GqEsD+g+zb7CM7U4
        +84lAUWGmSBagv4SXY5oBxmGKoNd60k=
X-Google-Smtp-Source: AK7set8Fimu3zOoopSBJUzLP3DN0+ZnN3fIl07RbNeiRJc5l2+WVVl3oJiN2ntotS7ZNSR+fg6uWYg==
X-Received: by 2002:a62:505:0:b0:5a8:d97d:c346 with SMTP id 5-20020a620505000000b005a8d97dc346mr18366477pff.12.1677401529935;
        Sun, 26 Feb 2023 00:52:09 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:52:09 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 07/10] bpf: Add skb dynptrs
Date:   Sun, 26 Feb 2023 00:51:17 -0800
Message-Id: <20230226085120.3907863-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add skb dynptrs, which are dynptrs whose underlying pointer points
to a skb. The dynptr acts on skb data. skb dynptrs have two main
benefits. One is that they allow operations on sizes that are not
statically known at compile-time (eg variable-sized accesses).
Another is that parsing the packet data through dynptrs (instead of
through direct access of skb->data and skb->data_end) can be more
ergonomic and less brittle (eg does not need manual if checking for
being within bounds of data_end).

For bpf prog types that don't support writes on skb data, the dynptr is
read-only (bpf_dynptr_write() will return an error)

For reads and writes through the bpf_dynptr_read() and bpf_dynptr_write()
interfaces, reading and writing from/to data in the head as well as from/to
non-linear paged buffers is supported. Data slices through the
bpf_dynptr_data API are not supported; instead bpf_dynptr_slice() and
bpf_dynptr_slice_rdwr() (added in subsequent commit) should be used.

For examples of how skb dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            | 14 ++++++-
 include/linux/filter.h         | 18 ++++++++
 include/uapi/linux/bpf.h       | 13 +++++-
 kernel/bpf/btf.c               | 18 ++++++++
 kernel/bpf/helpers.c           | 76 +++++++++++++++++++++++++++-------
 kernel/bpf/verifier.c          | 61 +++++++++++++++++++++++++++
 net/core/filter.c              | 67 ++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 13 +++++-
 8 files changed, 261 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 296841a31749..e7436d7615b0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -607,11 +607,14 @@ enum bpf_type_flag {
 	 */
 	NON_OWN_REF		= BIT(14 + BPF_BASE_TYPE_BITS),
 
+	/* DYNPTR points to sk_buff */
+	DYNPTR_TYPE_SKB		= BIT(15 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	= __BPF_TYPE_FLAG_MAX - 1,
 };
 
-#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF)
+#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB)
 
 /* Max number of base types. */
 #define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
@@ -1146,6 +1149,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_LOCAL,
 	/* Underlying data is a ringbuf record */
 	BPF_DYNPTR_TYPE_RINGBUF,
+	/* Underlying data is a sk_buff */
+	BPF_DYNPTR_TYPE_SKB,
 };
 
 int bpf_dynptr_check_size(u32 size);
@@ -2846,6 +2851,8 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 				struct bpf_insn *insn_buf,
 				struct bpf_prog *prog,
 				u32 *target_size);
+int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
+			       struct bpf_dynptr_kern *ptr);
 #else
 static inline bool bpf_sock_common_is_valid_access(int off, int size,
 						   enum bpf_access_type type,
@@ -2867,6 +2874,11 @@ static inline u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 {
 	return 0;
 }
+static inline int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
+					     struct bpf_dynptr_kern *ptr)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef CONFIG_INET
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1727898f1641..de18e844d15e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1542,4 +1542,22 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u64 index
 	return XDP_REDIRECT;
 }
 
+#ifdef CONFIG_NET
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
+			  u32 len, u64 flags);
+#else /* CONFIG_NET */
+static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset,
+				       void *to, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset,
+					const void *from, u32 len, u64 flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_NET */
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 62ce1f5d1b1d..d0351d30e551 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5325,11 +5325,17 @@ union bpf_attr {
  *	Description
  *		Write *len* bytes from *src* into *dst*, starting from *offset*
  *		into *dst*.
- *		*flags* is currently unused.
+ *
+ *		*flags* must be 0 except for skb-type dynptrs.
+ *
+ *		For skb-type dynptrs:
+ *		    *  For *flags*, please see the flags accepted by
+ *		       **bpf_skb_store_bytes**\ ().
  *	Return
  *		0 on success, -E2BIG if *offset* + *len* exceeds the length
  *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
- *		is a read-only dynptr or if *flags* is not 0.
+ *		is a read-only dynptr or if *flags* is not correct. For skb-type dynptrs,
+ *		other errors correspond to errors returned by **bpf_skb_store_bytes**\ ().
  *
  * void *bpf_dynptr_data(const struct bpf_dynptr *ptr, u32 offset, u32 len)
  *	Description
@@ -5337,6 +5343,9 @@ union bpf_attr {
  *
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
+ *
+ *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 84cca8473873..ef2d8969ed1f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -207,6 +207,11 @@ enum btf_kfunc_hook {
 	BTF_KFUNC_HOOK_TRACING,
 	BTF_KFUNC_HOOK_SYSCALL,
 	BTF_KFUNC_HOOK_FMODRET,
+	BTF_KFUNC_HOOK_CGROUP_SKB,
+	BTF_KFUNC_HOOK_SCHED_ACT,
+	BTF_KFUNC_HOOK_SK_SKB,
+	BTF_KFUNC_HOOK_SOCKET_FILTER,
+	BTF_KFUNC_HOOK_LWT,
 	BTF_KFUNC_HOOK_MAX,
 };
 
@@ -7708,6 +7713,19 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
 		return BTF_KFUNC_HOOK_TRACING;
 	case BPF_PROG_TYPE_SYSCALL:
 		return BTF_KFUNC_HOOK_SYSCALL;
+	case BPF_PROG_TYPE_CGROUP_SKB:
+		return BTF_KFUNC_HOOK_CGROUP_SKB;
+	case BPF_PROG_TYPE_SCHED_ACT:
+		return BTF_KFUNC_HOOK_SCHED_ACT;
+	case BPF_PROG_TYPE_SK_SKB:
+		return BTF_KFUNC_HOOK_SK_SKB;
+	case BPF_PROG_TYPE_SOCKET_FILTER:
+		return BTF_KFUNC_HOOK_SOCKET_FILTER;
+	case BPF_PROG_TYPE_LWT_OUT:
+	case BPF_PROG_TYPE_LWT_IN:
+	case BPF_PROG_TYPE_LWT_XMIT:
+	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
+		return BTF_KFUNC_HOOK_LWT;
 	default:
 		return BTF_KFUNC_HOOK_MAX;
 	}
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a784be6f8bac..1863bea0a21f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1420,11 +1420,21 @@ static bool bpf_dynptr_is_rdonly(const struct bpf_dynptr_kern *ptr)
 	return ptr->size & DYNPTR_RDONLY_BIT;
 }
 
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
+{
+	ptr->size |= DYNPTR_RDONLY_BIT;
+}
+
 static void bpf_dynptr_set_type(struct bpf_dynptr_kern *ptr, enum bpf_dynptr_type type)
 {
 	ptr->size |= type << DYNPTR_TYPE_SHIFT;
 }
 
+static enum bpf_dynptr_type bpf_dynptr_get_type(const struct bpf_dynptr_kern *ptr)
+{
+	return (ptr->size & ~(DYNPTR_RDONLY_BIT)) >> DYNPTR_TYPE_SHIFT;
+}
+
 u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr)
 {
 	return ptr->size & DYNPTR_SIZE_MASK;
@@ -1497,6 +1507,7 @@ static const struct bpf_func_proto bpf_dynptr_from_mem_proto = {
 BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern *, src,
 	   u32, offset, u64, flags)
 {
+	enum bpf_dynptr_type type;
 	int err;
 
 	if (!src->data || flags)
@@ -1506,13 +1517,23 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern
 	if (err)
 		return err;
 
-	/* Source and destination may possibly overlap, hence use memmove to
-	 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
-	 * pointing to overlapping PTR_TO_MAP_VALUE regions.
-	 */
-	memmove(dst, src->data + src->offset + offset, len);
+	type = bpf_dynptr_get_type(src);
 
-	return 0;
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		/* Source and destination may possibly overlap, hence use memmove to
+		 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
+		 * pointing to overlapping PTR_TO_MAP_VALUE regions.
+		 */
+		memmove(dst, src->data + src->offset + offset, len);
+		return 0;
+	case BPF_DYNPTR_TYPE_SKB:
+		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
+	default:
+		WARN_ONCE(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
+		return -EFAULT;
+	}
 }
 
 static const struct bpf_func_proto bpf_dynptr_read_proto = {
@@ -1529,22 +1550,36 @@ static const struct bpf_func_proto bpf_dynptr_read_proto = {
 BPF_CALL_5(bpf_dynptr_write, const struct bpf_dynptr_kern *, dst, u32, offset, void *, src,
 	   u32, len, u64, flags)
 {
+	enum bpf_dynptr_type type;
 	int err;
 
-	if (!dst->data || flags || bpf_dynptr_is_rdonly(dst))
+	if (!dst->data || bpf_dynptr_is_rdonly(dst))
 		return -EINVAL;
 
 	err = bpf_dynptr_check_off_len(dst, offset, len);
 	if (err)
 		return err;
 
-	/* Source and destination may possibly overlap, hence use memmove to
-	 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
-	 * pointing to overlapping PTR_TO_MAP_VALUE regions.
-	 */
-	memmove(dst->data + dst->offset + offset, src, len);
+	type = bpf_dynptr_get_type(dst);
 
-	return 0;
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		if (flags)
+			return -EINVAL;
+		/* Source and destination may possibly overlap, hence use memmove to
+		 * copy the data. E.g. bpf_dynptr_from_mem may create two dynptr
+		 * pointing to overlapping PTR_TO_MAP_VALUE regions.
+		 */
+		memmove(dst->data + dst->offset + offset, src, len);
+		return 0;
+	case BPF_DYNPTR_TYPE_SKB:
+		return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
+					     flags);
+	default:
+		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
+		return -EFAULT;
+	}
 }
 
 static const struct bpf_func_proto bpf_dynptr_write_proto = {
@@ -1560,6 +1595,7 @@ static const struct bpf_func_proto bpf_dynptr_write_proto = {
 
 BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u32, len)
 {
+	enum bpf_dynptr_type type;
 	int err;
 
 	if (!ptr->data)
@@ -1572,7 +1608,19 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
 	if (bpf_dynptr_is_rdonly(ptr))
 		return 0;
 
-	return (unsigned long)(ptr->data + ptr->offset + offset);
+	type = bpf_dynptr_get_type(ptr);
+
+	switch (type) {
+	case BPF_DYNPTR_TYPE_LOCAL:
+	case BPF_DYNPTR_TYPE_RINGBUF:
+		return (unsigned long)(ptr->data + ptr->offset + offset);
+	case BPF_DYNPTR_TYPE_SKB:
+		/* skb dynptrs should use bpf_dynptr_slice / bpf_dynptr_slice_rdwr */
+		return 0;
+	default:
+		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
+		return 0;
+	}
 }
 
 static const struct bpf_func_proto bpf_dynptr_data_proto = {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3a7f69b29053..ef38ec52569a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -750,6 +750,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_LOCAL;
 	case DYNPTR_TYPE_RINGBUF:
 		return BPF_DYNPTR_TYPE_RINGBUF;
+	case DYNPTR_TYPE_SKB:
+		return BPF_DYNPTR_TYPE_SKB;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -6295,6 +6297,9 @@ int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
 			case DYNPTR_TYPE_RINGBUF:
 				err_extra = "ringbuf";
 				break;
+			case DYNPTR_TYPE_SKB:
+				err_extra = "skb ";
+				break;
 			default:
 				err_extra = "<unknown>";
 				break;
@@ -6737,6 +6742,24 @@ static int dynptr_ref_obj_id(struct bpf_verifier_env *env, struct bpf_reg_state
 	return state->stack[spi].spilled_ptr.ref_obj_id;
 }
 
+static enum bpf_dynptr_type dynptr_get_type(struct bpf_verifier_env *env,
+					    struct bpf_reg_state *reg)
+{
+	struct bpf_func_state *state = func(env, reg);
+	int spi;
+
+	if (reg->type == CONST_PTR_TO_DYNPTR)
+		return reg->dynptr.type;
+
+	spi = __get_spi(reg->off);
+	if (spi < 0) {
+		verbose(env, "verifier internal error: invalid spi when querying dynptr type\n");
+		return BPF_DYNPTR_TYPE_INVALID;
+	}
+
+	return state->stack[spi].spilled_ptr.dynptr.type;
+}
+
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			  struct bpf_call_arg_meta *meta,
 			  const struct bpf_func_proto *fn,
@@ -8383,6 +8406,27 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 
 		break;
 	}
+	case BPF_FUNC_dynptr_write:
+	{
+		enum bpf_dynptr_type dynptr_type;
+		struct bpf_reg_state *reg;
+
+		reg = get_dynptr_arg_reg(env, fn, regs);
+		if (!reg)
+			return -EFAULT;
+
+		dynptr_type = dynptr_get_type(env, reg);
+		if (dynptr_type == BPF_DYNPTR_TYPE_INVALID)
+			return -EFAULT;
+
+		if (dynptr_type == BPF_DYNPTR_TYPE_SKB)
+			/* this will trigger clear_all_pkt_pointers(), which will
+			 * invalidate all dynptr slices associated with the skb
+			 */
+			changes_data = true;
+
+		break;
+	}
 	case BPF_FUNC_user_ringbuf_drain:
 		err = __check_func_call(env, insn, insn_idx_p, meta.subprogno,
 					set_user_ringbuf_callback_state);
@@ -8898,6 +8942,7 @@ enum special_kfunc_type {
 	KF_bpf_rbtree_remove,
 	KF_bpf_rbtree_add,
 	KF_bpf_rbtree_first,
+	KF_bpf_dynptr_from_skb,
 };
 
 BTF_SET_START(special_kfunc_set)
@@ -8912,6 +8957,7 @@ BTF_ID(func, bpf_rdonly_cast)
 BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
+BTF_ID(func, bpf_dynptr_from_skb)
 BTF_SET_END(special_kfunc_set)
 
 BTF_ID_LIST(special_kfunc_list)
@@ -8928,6 +8974,7 @@ BTF_ID(func, bpf_rcu_read_unlock)
 BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
+BTF_ID(func, bpf_dynptr_from_skb)
 
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *meta)
 {
@@ -9682,6 +9729,9 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 			if (is_kfunc_arg_uninit(btf, &args[i]))
 				dynptr_arg_type |= MEM_UNINIT;
 
+			if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
+				dynptr_arg_type |= DYNPTR_TYPE_SKB;
+
 			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
 				return ret;
@@ -16356,6 +16406,17 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		   desc->func_id == special_kfunc_list[KF_bpf_rdonly_cast]) {
 		insn_buf[0] = BPF_MOV64_REG(BPF_REG_0, BPF_REG_1);
 		*cnt = 1;
+	} else if (desc->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb]) {
+		bool seen_direct_write = env->seen_direct_write;
+		bool is_rdonly = !may_access_direct_pkt_data(env, NULL, BPF_WRITE);
+
+		if (is_rdonly)
+			insn->imm = BPF_CALL_IMM(bpf_dynptr_from_skb_rdonly);
+
+		/* restore env->seen_direct_write to its original value, since
+		 * may_access_direct_pkt_data mutates it
+		 */
+		env->seen_direct_write = seen_direct_write;
 	}
 	return 0;
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 1d6f165923bf..f3afa31a9b10 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1721,6 +1721,12 @@ static const struct bpf_func_proto bpf_skb_store_bytes_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
+			  u32 len, u64 flags)
+{
+	return ____bpf_skb_store_bytes(skb, offset, from, len, flags);
+}
+
 BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
 	   void *, to, u32, len)
 {
@@ -1751,6 +1757,11 @@ static const struct bpf_func_proto bpf_skb_load_bytes_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
+int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
+{
+	return ____bpf_skb_load_bytes(skb, offset, to, len);
+}
+
 BPF_CALL_4(bpf_flow_dissector_load_bytes,
 	   const struct bpf_flow_dissector *, ctx, u32, offset,
 	   void *, to, u32, len)
@@ -11621,3 +11632,59 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
 
 	return func;
 }
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in vmlinux BTF");
+__bpf_kfunc int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
+				    struct bpf_dynptr_kern *ptr__uninit)
+{
+	if (flags) {
+		bpf_dynptr_set_null(ptr__uninit);
+		return -EINVAL;
+	}
+
+	bpf_dynptr_init(ptr__uninit, skb, BPF_DYNPTR_TYPE_SKB, 0, skb->len);
+
+	return 0;
+}
+__diag_pop();
+
+int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
+			       struct bpf_dynptr_kern *ptr__uninit)
+{
+	int err;
+
+	err = bpf_dynptr_from_skb(skb, flags, ptr__uninit);
+	if (err)
+		return err;
+
+	bpf_dynptr_set_rdonly(ptr__uninit);
+
+	return 0;
+}
+
+BTF_SET8_START(bpf_kfunc_check_set_skb)
+BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
+BTF_SET8_END(bpf_kfunc_check_set_skb)
+
+static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
+	.owner = THIS_MODULE,
+	.set = &bpf_kfunc_check_set_skb,
+};
+
+static int __init bpf_kfunc_init(void)
+{
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SK_SKB, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCKET_FILTER, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
+	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
+}
+late_initcall(bpf_kfunc_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 62ce1f5d1b1d..d0351d30e551 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5325,11 +5325,17 @@ union bpf_attr {
  *	Description
  *		Write *len* bytes from *src* into *dst*, starting from *offset*
  *		into *dst*.
- *		*flags* is currently unused.
+ *
+ *		*flags* must be 0 except for skb-type dynptrs.
+ *
+ *		For skb-type dynptrs:
+ *		    *  For *flags*, please see the flags accepted by
+ *		       **bpf_skb_store_bytes**\ ().
  *	Return
  *		0 on success, -E2BIG if *offset* + *len* exceeds the length
  *		of *dst*'s data, -EINVAL if *dst* is an invalid dynptr or if *dst*
- *		is a read-only dynptr or if *flags* is not 0.
+ *		is a read-only dynptr or if *flags* is not correct. For skb-type dynptrs,
+ *		other errors correspond to errors returned by **bpf_skb_store_bytes**\ ().
  *
  * void *bpf_dynptr_data(const struct bpf_dynptr *ptr, u32 offset, u32 len)
  *	Description
@@ -5337,6 +5343,9 @@ union bpf_attr {
  *
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
+ *
+ *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
-- 
2.34.1

