Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D01E6A7046
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCAPvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjCAPvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:51:32 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C13E46152;
        Wed,  1 Mar 2023 07:51:11 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p6so13602068plf.0;
        Wed, 01 Mar 2023 07:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7f7Y/svUcqb8Zmt0LrMojtqEq5uPXSbnWoh0G3uNtmk=;
        b=ChT56cWJ50V7+ER1psXQnLmgzG4h3mecDyDYhYklEX4CwtFrykeIhCKAV4JT4dYISg
         HLpdzx5j3qI6AWocgXtQ8HJKpmBSsSoZG0jC/1vi8domedeJzHOxXPlgeWfGfH9wkhsf
         62A67ghm1ewfyrus2P8U20nt2rJB+K3XMyrORUmQI6FpNBtN/TLvs+bHQmvx3hPyjkmY
         dYlRymvAqWoe5VpD4sBii5eZTkQnUlP/8DUSJhY0Qa9Gphf/GIV51SQRylSM6KTPpqp/
         ymXg8P+Dk1CgXvhC2h4XSii09OCy5BduORQ2a4yaZ/iCe3oLiOtjK5spm55Y2ASRi46V
         4g7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7f7Y/svUcqb8Zmt0LrMojtqEq5uPXSbnWoh0G3uNtmk=;
        b=d+nFmdri+boqmzKgh9KcUID3q+bCGKKBWss1TSzIEuMyejGxEWUJP4vu0LRMBs2TkL
         Y15FYcqMieo26DyGOj7VDT29xuH74luQtFC/0xRRP9k/feFhBPMwotAmJu0ZQfixMYml
         S0ygQ6AXI26LsEvf5R3CsK5YPBZxMiM7WJALol76wMEJHjAWYmE1iU36H1Zb3LC1UaFQ
         w5m6rLa+0R65/KMqUMQYNuuA0y0aNHqYbFBvWPSeY4LfxiMHwV+8WSeVSL/sfxyOWlB8
         IbHW+HjOGcFmH2CBjX4BUNx9VGgZkrEASNK2/zcNpkumQbv5JMJWVoYqLE6/fVYQbKSQ
         L1rQ==
X-Gm-Message-State: AO0yUKWwC6gtyRVvt6irD6sVnrL1QGI2WLyVlhC8fyq0NVWBmF8S6N86
        wfiE76OnJop0SyiD7gel3oHO5nV4hdM=
X-Google-Smtp-Source: AK7set85T/Pard4daYnoakYZqMlIPOes2lqnwr/m7pkV1Wl5BYZELReDoJvKj6TFS4aRvGmcikA1Ng==
X-Received: by 2002:a05:6a20:b045:b0:cb:c015:92b4 with SMTP id dx5-20020a056a20b04500b000cbc01592b4mr5714515pzb.45.1677685870170;
        Wed, 01 Mar 2023 07:51:10 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:51:09 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 08/10] bpf: Add xdp dynptrs
Date:   Wed,  1 Mar 2023 07:49:51 -0800
Message-Id: <20230301154953.641654-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
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

Add xdp dynptrs, which are dynptrs whose underlying pointer points
to a xdp_buff. The dynptr acts on xdp data. xdp dynptrs have two main
benefits. One is that they allow operations on sizes that are not
statically known at compile-time (eg variable-sized accesses).
Another is that parsing the packet data through dynptrs (instead of
through direct access of xdp->data and xdp->data_end) can be more
ergonomic and less brittle (eg does not need manual if checking for
being within bounds of data_end).

For reads and writes on the dynptr, this includes reading/writing
from/to and across fragments. Data slices through the bpf_dynptr_data
API are not supported; instead bpf_dynptr_slice() and
bpf_dynptr_slice_rdwr() should be used.

For examples of how xdp dynptrs can be used, please see the attached
selftests.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h            |  8 +++++++-
 include/linux/filter.h         | 14 +++++++++++++
 include/uapi/linux/bpf.h       |  2 +-
 kernel/bpf/helpers.c           |  9 ++++++++-
 kernel/bpf/verifier.c          | 10 +++++++++
 net/core/filter.c              | 37 ++++++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  2 +-
 7 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e7436d7615b0..23ec684e660d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -610,11 +610,15 @@ enum bpf_type_flag {
 	/* DYNPTR points to sk_buff */
 	DYNPTR_TYPE_SKB		= BIT(15 + BPF_BASE_TYPE_BITS),
 
+	/* DYNPTR points to xdp_buff */
+	DYNPTR_TYPE_XDP		= BIT(16 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	= __BPF_TYPE_FLAG_MAX - 1,
 };
 
-#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB)
+#define DYNPTR_TYPE_FLAG_MASK	(DYNPTR_TYPE_LOCAL | DYNPTR_TYPE_RINGBUF | DYNPTR_TYPE_SKB \
+				 | DYNPTR_TYPE_XDP)
 
 /* Max number of base types. */
 #define BPF_BASE_TYPE_LIMIT	(1UL << BPF_BASE_TYPE_BITS)
@@ -1151,6 +1155,8 @@ enum bpf_dynptr_type {
 	BPF_DYNPTR_TYPE_RINGBUF,
 	/* Underlying data is a sk_buff */
 	BPF_DYNPTR_TYPE_SKB,
+	/* Underlying data is a xdp_buff */
+	BPF_DYNPTR_TYPE_XDP,
 };
 
 int bpf_dynptr_check_size(u32 size);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index de18e844d15e..3f6992261ec5 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1546,6 +1546,8 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u64 index
 int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len);
 int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from,
 			  u32 len, u64 flags);
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len);
 #else /* CONFIG_NET */
 static inline int __bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset,
 				       void *to, u32 len)
@@ -1558,6 +1560,18 @@ static inline int __bpf_skb_store_bytes(struct sk_buff *skb, u32 offset,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset,
+				       void *buf, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset,
+					void *buf, u32 len)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_NET */
 
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d0351d30e551..faa304c926cf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5344,7 +5344,7 @@ union bpf_attr {
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
  *
- *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		skb and xdp type dynptrs may not use bpf_dynptr_data. They should
  *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index e8e2414d1587..114a875a05b1 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1530,6 +1530,8 @@ BPF_CALL_5(bpf_dynptr_read, void *, dst, u32, len, const struct bpf_dynptr_kern
 		return 0;
 	case BPF_DYNPTR_TYPE_SKB:
 		return __bpf_skb_load_bytes(src->data, src->offset + offset, dst, len);
+	case BPF_DYNPTR_TYPE_XDP:
+		return __bpf_xdp_load_bytes(src->data, src->offset + offset, dst, len);
 	default:
 		WARN_ONCE(true, "bpf_dynptr_read: unknown dynptr type %d\n", type);
 		return -EFAULT;
@@ -1576,6 +1578,10 @@ BPF_CALL_5(bpf_dynptr_write, const struct bpf_dynptr_kern *, dst, u32, offset, v
 	case BPF_DYNPTR_TYPE_SKB:
 		return __bpf_skb_store_bytes(dst->data, dst->offset + offset, src, len,
 					     flags);
+	case BPF_DYNPTR_TYPE_XDP:
+		if (flags)
+			return -EINVAL;
+		return __bpf_xdp_store_bytes(dst->data, dst->offset + offset, src, len);
 	default:
 		WARN_ONCE(true, "bpf_dynptr_write: unknown dynptr type %d\n", type);
 		return -EFAULT;
@@ -1615,7 +1621,8 @@ BPF_CALL_3(bpf_dynptr_data, const struct bpf_dynptr_kern *, ptr, u32, offset, u3
 	case BPF_DYNPTR_TYPE_RINGBUF:
 		return (unsigned long)(ptr->data + ptr->offset + offset);
 	case BPF_DYNPTR_TYPE_SKB:
-		/* skb dynptrs should use bpf_dynptr_slice / bpf_dynptr_slice_rdwr */
+	case BPF_DYNPTR_TYPE_XDP:
+		/* skb and xdp dynptrs should use bpf_dynptr_slice / bpf_dynptr_slice_rdwr */
 		return 0;
 	default:
 		WARN_ONCE(true, "bpf_dynptr_data: unknown dynptr type %d\n", type);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4f5fce16543b..5e42946e53ab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -752,6 +752,8 @@ static enum bpf_dynptr_type arg_to_dynptr_type(enum bpf_arg_type arg_type)
 		return BPF_DYNPTR_TYPE_RINGBUF;
 	case DYNPTR_TYPE_SKB:
 		return BPF_DYNPTR_TYPE_SKB;
+	case DYNPTR_TYPE_XDP:
+		return BPF_DYNPTR_TYPE_XDP;
 	default:
 		return BPF_DYNPTR_TYPE_INVALID;
 	}
@@ -6300,6 +6302,9 @@ static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn
 			case DYNPTR_TYPE_SKB:
 				err_extra = "skb ";
 				break;
+			case DYNPTR_TYPE_XDP:
+				err_extra = "xdp ";
+				break;
 			default:
 				err_extra = "<unknown>";
 				break;
@@ -8943,6 +8948,7 @@ enum special_kfunc_type {
 	KF_bpf_rbtree_add,
 	KF_bpf_rbtree_first,
 	KF_bpf_dynptr_from_skb,
+	KF_bpf_dynptr_from_xdp,
 };
 
 BTF_SET_START(special_kfunc_set)
@@ -8958,6 +8964,7 @@ BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
+BTF_ID(func, bpf_dynptr_from_xdp)
 BTF_SET_END(special_kfunc_set)
 
 BTF_ID_LIST(special_kfunc_list)
@@ -8975,6 +8982,7 @@ BTF_ID(func, bpf_rbtree_remove)
 BTF_ID(func, bpf_rbtree_add)
 BTF_ID(func, bpf_rbtree_first)
 BTF_ID(func, bpf_dynptr_from_skb)
+BTF_ID(func, bpf_dynptr_from_xdp)
 
 static bool is_kfunc_bpf_rcu_read_lock(struct bpf_kfunc_call_arg_meta *meta)
 {
@@ -9731,6 +9739,8 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 
 			if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
 				dynptr_arg_type |= DYNPTR_TYPE_SKB;
+			else if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_xdp])
+				dynptr_arg_type |= DYNPTR_TYPE_XDP;
 
 			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
diff --git a/net/core/filter.c b/net/core/filter.c
index f3afa31a9b10..c692046fa7f6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3839,7 +3839,7 @@ static const struct bpf_func_proto sk_skb_change_head_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
-BPF_CALL_1(bpf_xdp_get_buff_len, struct  xdp_buff*, xdp)
+BPF_CALL_1(bpf_xdp_get_buff_len, struct xdp_buff*, xdp)
 {
 	return xdp_get_buff_len(xdp);
 }
@@ -3999,6 +3999,11 @@ static const struct bpf_func_proto bpf_xdp_load_bytes_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
+int __bpf_xdp_load_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len)
+{
+	return ____bpf_xdp_load_bytes(xdp, offset, buf, len);
+}
+
 BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
 	   void *, buf, u32, len)
 {
@@ -4026,6 +4031,11 @@ static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
+int __bpf_xdp_store_bytes(struct xdp_buff *xdp, u32 offset, void *buf, u32 len)
+{
+	return ____bpf_xdp_store_bytes(xdp, offset, buf, len);
+}
+
 static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
@@ -11648,6 +11658,19 @@ __bpf_kfunc int bpf_dynptr_from_skb(struct sk_buff *skb, u64 flags,
 
 	return 0;
 }
+
+__bpf_kfunc int bpf_dynptr_from_xdp(struct xdp_buff *xdp, u64 flags,
+				    struct bpf_dynptr_kern *ptr__uninit)
+{
+	if (flags) {
+		bpf_dynptr_set_null(ptr__uninit);
+		return -EINVAL;
+	}
+
+	bpf_dynptr_init(ptr__uninit, xdp, BPF_DYNPTR_TYPE_XDP, 0, xdp_get_buff_len(xdp));
+
+	return 0;
+}
 __diag_pop();
 
 int bpf_dynptr_from_skb_rdonly(struct sk_buff *skb, u64 flags,
@@ -11668,11 +11691,20 @@ BTF_SET8_START(bpf_kfunc_check_set_skb)
 BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
 BTF_SET8_END(bpf_kfunc_check_set_skb)
 
+BTF_SET8_START(bpf_kfunc_check_set_xdp)
+BTF_ID_FLAGS(func, bpf_dynptr_from_xdp)
+BTF_SET8_END(bpf_kfunc_check_set_xdp)
+
 static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
 	.owner = THIS_MODULE,
 	.set = &bpf_kfunc_check_set_skb,
 };
 
+static const struct btf_kfunc_id_set bpf_kfunc_set_xdp = {
+	.owner = THIS_MODULE,
+	.set = &bpf_kfunc_check_set_xdp,
+};
+
 static int __init bpf_kfunc_init(void)
 {
 	int ret;
@@ -11685,6 +11717,7 @@ static int __init bpf_kfunc_init(void)
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_OUT, &bpf_kfunc_set_skb);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_IN, &bpf_kfunc_set_skb);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_XMIT, &bpf_kfunc_set_skb);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_LWT_SEG6LOCAL, &bpf_kfunc_set_skb);
+	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &bpf_kfunc_set_xdp);
 }
 late_initcall(bpf_kfunc_init);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d0351d30e551..faa304c926cf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5344,7 +5344,7 @@ union bpf_attr {
  *		*len* must be a statically known value. The returned data slice
  *		is invalidated whenever the dynptr is invalidated.
  *
- *		skb type dynptrs may not use bpf_dynptr_data. They should
+ *		skb and xdp type dynptrs may not use bpf_dynptr_data. They should
  *		instead use bpf_dynptr_slice and bpf_dynptr_slice_rdwr.
  *	Return
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
-- 
2.34.1

