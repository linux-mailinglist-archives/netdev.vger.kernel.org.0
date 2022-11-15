Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A25629066
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbiKODEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiKODDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:15 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3AA2679
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:23 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id k15-20020a170902c40f00b001887cd71fe6so10300670plk.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dTHRlkKLabXAtQPLHvb8Vrt1mLuPnrRmBOPa7WfDJFo=;
        b=PSbO1KyGXRAvZ8j1J3jSGk9bHxjCktcbSbe4QgM9nd39etPIqzG2GeYPRqdEEuLE/t
         vadXutMRJql9/LPtK4MbUWpmGbfCoPDCII+aWNzEHbzwae6S4WjHzLeLPHp3ofY/B4eQ
         rDYUQHIxpGADNHf1XYF3IH8/Vs63ANPNQgFED0ewym9kJiv7pklXNyQoey99CEgJv6aC
         g1YxFnlhewNbV4+q1XvQpY/msGlOAlT9t5W0DXeBIWpd8KdiHIbbyeP/nIQg242Zyqqx
         kzJBl1m7x+Apo5QSGpUnGOXrJG+VoudvBEMJrbfX+4JetLE8KLgvbndHmDjXFn1ipHp1
         5YVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTHRlkKLabXAtQPLHvb8Vrt1mLuPnrRmBOPa7WfDJFo=;
        b=j2LqJLmGVUg/xzZ4XFSBfWxqI03uI36JFz9uvmQQKo3/6cF0tJo4hD+cpmvuoMu7YR
         22T8kKOnk+nejqoo3rVyxx7DlZR4MWjHdcXJlz9QpE98BCD0786/lRZMzhpcmfAzL/Lp
         1V5MMndHcLFQpw3FgLGm51RtVlqcTImO3SZcpz4hHHL4jwIaGD+ujDjApfFK4b4kE6QA
         VJZUWSmYimliAxI5Ru4nSqRS2+uLK3dIyXs43d6feFX3bbIp4etqQatVqEgJQfO0eP2v
         MPBdq2buJznzKPHc5TjDNDxhrDAvAT2S5JH3iQCfCn3DJAF0xJS+2278J+Dd2cZMhbcI
         8nZw==
X-Gm-Message-State: ANoB5plwmjCcJv/2auk5GB961K6ctuxmoEa4Xs2WCTu6SGj/aqWgflUU
        4ysNc6gB+aOLJzmM+9g3RHypclg=
X-Google-Smtp-Source: AA0mqf7KV4otaR0D1CCR7hnm1sbTUQBk76wwUgieCkNqG3pbAo/Knjb6lkgclLoShn7O+/WeTPlAdW0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:e919:0:b0:56d:3180:e885 with SMTP id
 j25-20020a62e919000000b0056d3180e885mr16605597pfh.82.1668481342776; Mon, 14
 Nov 2022 19:02:22 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:05 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-7-sdf@google.com>
Subject: [PATCH bpf-next 06/11] xdp: Carry over xdp metadata into skb context
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement new bpf_xdp_metadata_export_to_skb kfunc which
prepares compatible xdp metadata for kernel consumption.
This kfunc should be called prior to bpf_redirect
or when XDP_PASS'ing the frame into the kernel (note, the drivers
have to be updated to enable consuming XDP_PASS'ed metadata).

veth driver is amended to consume this metadata when converting to skb.

Internally, XDP_FLAGS_HAS_SKB_METADATA flag is used to indicate
whether the frame has skb metadata. The metadata is currently
stored prior to xdp->data_meta. bpf_xdp_adjust_meta refuses
to work after a call to bpf_xdp_metadata_export_to_skb (can lift
this requirement later on if needed, we'd have to memmove
xdp_skb_metadata).

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/veth.c             |  10 +--
 include/linux/skbuff.h         |   4 +
 include/net/xdp.h              |  17 ++++
 include/uapi/linux/bpf.h       |   7 ++
 kernel/bpf/verifier.c          |  15 ++++
 net/core/filter.c              |  40 +++++++++
 net/core/skbuff.c              |  20 +++++
 net/core/xdp.c                 | 145 +++++++++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |   7 ++
 9 files changed, 255 insertions(+), 10 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index c626580a2294..35349a232209 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -803,7 +803,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	void *orig_data, *orig_data_end;
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
-	u32 act, metalen;
+	u32 act;
 	int off;
 
 	skb_prepare_for_gro(skb);
@@ -886,9 +886,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 
 	skb->protocol = eth_type_trans(skb, rq->dev);
 
-	metalen = xdp.data - xdp.data_meta;
-	if (metalen)
-		skb_metadata_set(skb, metalen);
+	xdp_convert_skb_metadata(&xdp, skb);
 out:
 	return skb;
 drop:
@@ -1663,7 +1661,9 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
 			      struct bpf_patch *patch)
 {
-	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
+		return xdp_metadata_export_to_skb(prog, patch);
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
 		/* return true; */
 		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
 	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4e464a27adaf..be6a9559dbf1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4219,6 +4219,10 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
 	       true : __skb_metadata_differs(skb_a, skb_b, len_a);
 }
 
+struct xdp_skb_metadata;
+bool skb_metadata_import_from_xdp(struct sk_buff *skb,
+				  struct xdp_skb_metadata *meta);
+
 static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
 {
 	skb_shinfo(skb)->meta_len = meta_len;
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 2a82a98f2f9f..547a6a0e99f8 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -73,6 +73,7 @@ enum xdp_buff_flags {
 	XDP_FLAGS_FRAGS_PF_MEMALLOC	= BIT(1), /* xdp paged memory is under
 						   * pressure
 						   */
+	XDP_FLAGS_HAS_SKB_METADATA	= BIT(2), /* xdp_skb_metadata */
 };
 
 struct xdp_buff {
@@ -91,6 +92,11 @@ static __always_inline bool xdp_buff_has_frags(struct xdp_buff *xdp)
 	return !!(xdp->flags & XDP_FLAGS_HAS_FRAGS);
 }
 
+static __always_inline bool xdp_buff_has_skb_metadata(struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_HAS_SKB_METADATA);
+}
+
 static __always_inline void xdp_buff_set_frags_flag(struct xdp_buff *xdp)
 {
 	xdp->flags |= XDP_FLAGS_HAS_FRAGS;
@@ -306,6 +312,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 	return xdp_frame;
 }
 
+bool xdp_convert_skb_metadata(struct xdp_buff *xdp, struct sk_buff *skb);
+
 void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		  struct xdp_buff *xdp);
 void xdp_return_frame(struct xdp_frame *xdpf);
@@ -411,6 +419,8 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
 #define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_EXPORT_TO_SKB, \
+			   bpf_xdp_metadata_export_to_skb) \
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
 			   bpf_xdp_metadata_rx_timestamp_supported) \
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
@@ -423,14 +433,21 @@ XDP_METADATA_KFUNC_xxx
 MAX_XDP_METADATA_KFUNC,
 };
 
+struct bpf_patch;
+
 #ifdef CONFIG_DEBUG_INFO_BTF
 extern struct btf_id_set8 xdp_metadata_kfunc_ids;
 static inline u32 xdp_metadata_kfunc_id(int id)
 {
 	return xdp_metadata_kfunc_ids.pairs[id].id;
 }
+void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
 #else
 static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
+static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
+{
+	return 0;
+}
 #endif
 
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b444b1118c4f..71e3bc7ad839 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6116,6 +6116,12 @@ enum xdp_action {
 	XDP_REDIRECT,
 };
 
+/* Subset of XDP metadata exported to skb context.
+ */
+struct xdp_skb_metadata {
+	__u64 rx_timestamp;
+};
+
 /* user accessible metadata for XDP packet hook
  * new fields must be added to the end of this structure
  */
@@ -6128,6 +6134,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__bpf_md_ptr(struct xdp_skb_metadata *, skb_metadata);
 };
 
 /* DEVMAP map-value layout
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b657ed6eb277..6879ad3a6026 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14023,6 +14023,7 @@ static int unroll_kfunc_call(struct bpf_verifier_env *env,
 	enum bpf_prog_type prog_type;
 	struct bpf_prog_aux *aux;
 	struct btf *desc_btf;
+	u32 allowed, mangled;
 	u32 *kfunc_flags;
 	u32 func_id;
 
@@ -14050,6 +14051,20 @@ static int unroll_kfunc_call(struct bpf_verifier_env *env,
 		 */
 		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 0));
 	}
+
+	allowed = 1 << BPF_REG_0;
+	allowed |= 1 << BPF_REG_1;
+	allowed |= 1 << BPF_REG_2;
+	allowed |= 1 << BPF_REG_3;
+	allowed |= 1 << BPF_REG_4;
+	allowed |= 1 << BPF_REG_5;
+	mangled = bpf_patch_magles_registers(patch);
+	if (WARN_ON_ONCE(mangled & ~allowed)) {
+		bpf_patch_free(patch);
+		verbose(env, "bpf verifier is misconfigured\n");
+		return -EINVAL;
+	}
+
 	return bpf_patch_err(patch);
 }
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 6dd2baf5eeb2..2497144e4216 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4094,6 +4094,8 @@ BPF_CALL_2(bpf_xdp_adjust_meta, struct xdp_buff *, xdp, int, offset)
 		return -EINVAL;
 	if (unlikely(xdp_metalen_invalid(metalen)))
 		return -EACCES;
+	if (unlikely(xdp_buff_has_skb_metadata(xdp)))
+		return -EACCES;
 
 	xdp->data_meta = meta;
 
@@ -8690,6 +8692,8 @@ static bool __is_valid_xdp_access(int off, int size)
 	return true;
 }
 
+BTF_ID_LIST_SINGLE(xdp_to_skb_metadata_btf_ids, struct, xdp_skb_metadata);
+
 static bool xdp_is_valid_access(int off, int size,
 				enum bpf_access_type type,
 				const struct bpf_prog *prog,
@@ -8722,6 +8726,18 @@ static bool xdp_is_valid_access(int off, int size,
 	case offsetof(struct xdp_md, data_end):
 		info->reg_type = PTR_TO_PACKET_END;
 		break;
+	case offsetof(struct xdp_md, skb_metadata):
+		info->btf = bpf_get_btf_vmlinux();
+		if (IS_ERR(info->btf))
+			return PTR_ERR(info->btf);
+		if (!info->btf)
+			return -EINVAL;
+
+		info->reg_type = PTR_TO_BTF_ID_OR_NULL;
+		info->btf_id = xdp_to_skb_metadata_btf_ids[0];
+		if (size == sizeof(__u64))
+			return true;
+		return false;
 	}
 
 	return __is_valid_xdp_access(off, size);
@@ -9814,6 +9830,30 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
 				      offsetof(struct net_device, ifindex));
 		break;
+	case offsetof(struct xdp_md, skb_metadata):
+		/* dst_reg = xdp_buff->flags; */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, flags),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, flags));
+		/* dst_reg &= XDP_FLAGS_HAS_SKB_METADATA; */
+		*insn++ = BPF_ALU64_IMM(BPF_AND, si->dst_reg,
+					XDP_FLAGS_HAS_SKB_METADATA);
+
+		/* if (dst_reg != 0) { */
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 3);
+		/*	dst_reg = xdp_buff->data_meta; */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_meta),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, data_meta));
+		/*	dst_reg -= sizeof(struct xdp_skb_metadata); */
+		*insn++ = BPF_ALU64_IMM(BPF_SUB, si->dst_reg,
+					sizeof(struct xdp_skb_metadata));
+		*insn++ = BPF_JMP_A(1);
+		/* } else { */
+		/*	return 0; */
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+		/* } */
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 90d085290d49..0cc24ca20e4d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/xdp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6675,3 +6676,22 @@ nodefer:	__kfree_skb(skb);
 	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
 		smp_call_function_single_async(cpu, &sd->defer_csd);
 }
+
+bool skb_metadata_import_from_xdp(struct sk_buff *skb,
+				  struct xdp_skb_metadata *meta)
+{
+	/* Optional SKB info, currently missing:
+	 * - HW checksum info		(skb->ip_summed)
+	 * - HW RX hash			(skb_set_hash)
+	 * - RX ring dev queue index	(skb_record_rx_queue)
+	 */
+
+	if (meta->rx_timestamp) {
+		*skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
+			.hwtstamp = ns_to_ktime(meta->rx_timestamp),
+		};
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(skb_metadata_import_from_xdp);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 22f1e44700eb..ede9b1b987d9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -368,6 +368,22 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 
+bool xdp_convert_skb_metadata(struct xdp_buff *xdp, struct sk_buff *skb)
+{
+	struct xdp_skb_metadata *meta;
+	u32 metalen;
+
+	metalen = xdp->data - xdp->data_meta;
+	if (metalen)
+		skb_metadata_set(skb, metalen);
+	if (xdp_buff_has_skb_metadata(xdp)) {
+		meta = xdp->data_meta - sizeof(*meta);
+		return skb_metadata_import_from_xdp(skb, meta);
+	}
+	return false;
+}
+EXPORT_SYMBOL(xdp_convert_skb_metadata);
+
 /* XDP RX runs under NAPI protection, and in different delivery error
  * scenarios (e.g. queue full), it is possible to return the xdp_frame
  * while still leveraging this protection.  The @napi_direct boolean
@@ -619,6 +635,7 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
 	unsigned int headroom, frame_size;
+	struct xdp_skb_metadata *meta;
 	void *hard_start;
 	u8 nr_frags;
 
@@ -653,11 +670,10 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-	/* Optional SKB info, currently missing:
-	 * - HW checksum info		(skb->ip_summed)
-	 * - HW RX hash			(skb_set_hash)
-	 * - RX ring dev queue index	(skb_record_rx_queue)
-	 */
+	if (xdpf->flags & XDP_FLAGS_HAS_SKB_METADATA) {
+		meta = xdpf->data - xdpf->metasize - sizeof(*meta);
+		skb_metadata_import_from_xdp(skb, meta);
+	}
 
 	/* Until page_pool get SKB return path, release DMA here */
 	xdp_release_frame(xdpf);
@@ -712,6 +728,14 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 	return nxdpf;
 }
 
+/* For the packets directed to the kernel, this kfunc exports XDP metadata
+ * into skb context.
+ */
+noinline int bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx)
+{
+	return 0;
+}
+
 /* Indicates whether particular device supports rx_timestamp metadata.
  * This is an optional helper to support marking some branches as
  * "dead code" in the BPF programs.
@@ -736,15 +760,126 @@ BTF_SET8_START_GLOBAL(xdp_metadata_kfunc_ids)
 XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
+EXPORT_SYMBOL(xdp_metadata_kfunc_ids);
 
 static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
 	.owner = THIS_MODULE,
 	.set   = &xdp_metadata_kfunc_ids,
 };
 
+/* Since we're not actually doing a call but instead rewriting
+ * in place, we can only afford to use R0-R5 scratch registers
+ * and hidden BPF_PUSH64/BPF_POP64 opcodes to spill to the stack.
+ */
+void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
+{
+	u32 func_id;
+
+	/* The code below generates the following:
+	 *
+	 * int bpf_xdp_metadata_export_to_skb(struct xdp_md *ctx)
+	 * {
+	 *	struct xdp_skb_metadata *meta = ctx->data_meta - sizeof(*meta);
+	 *	int ret;
+	 *
+	 *	if (ctx->flags & XDP_FLAGS_HAS_SKB_METADATA)
+	 *		return -1;
+	 *
+	 *	if (meta < ctx->data_hard_start + sizeof(struct xdp_frame))
+	 *		return -1;
+	 *
+	 *	meta->rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
+	 *	ctx->flags |= BPF_F_XDP_HAS_METADATA;
+	 *
+	 *	return 0;
+	 * }
+	 */
+
+	bpf_patch_append(patch,
+		BPF_MOV64_IMM(BPF_REG_0, -1),
+
+		/* r2 = ((struct xdp_buff *)r1)->flags; */
+		BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, flags),
+			    BPF_REG_2, BPF_REG_1,
+			    offsetof(struct xdp_buff, flags)),
+
+		/* r2 &= XDP_FLAGS_HAS_SKB_METADATA; */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, XDP_FLAGS_HAS_SKB_METADATA),
+
+		/* if (xdp_buff->flags & XDP_FLAGS_HAS_SKB_METADATA) return -1; */
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_2, 0, S16_MAX),
+
+		/* r2 = ((struct xdp_buff *)r1)->data_meta; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
+			    offsetof(struct xdp_buff, data_meta)),
+		/* r2 -= sizeof(struct xdp_skb_metadata); */
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2,
+			      sizeof(struct xdp_skb_metadata)),
+		/* r3 = ((struct xdp_buff *)r1)->data_hard_start; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
+			    offsetof(struct xdp_buff, data_hard_start)),
+		/* r3 += sizeof(struct xdp_frame) */
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3,
+			      sizeof(struct xdp_frame)),
+		/* if (data_meta-sizeof(struct xdp_skb_metadata) <
+		 *     data_hard_start+sizeof(struct xdp_frame)) return -1;
+		 */
+		BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, S16_MAX),
+
+		/* r2 = ((struct xdp_buff *)r1)->flags; */
+		BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, flags),
+			    BPF_REG_2, BPF_REG_1,
+			    offsetof(struct xdp_buff, flags)),
+
+		/* r2 |= XDP_FLAGS_HAS_SKB_METADATA; */
+		BPF_ALU64_IMM(BPF_OR, BPF_REG_2, XDP_FLAGS_HAS_SKB_METADATA),
+
+		/* ((struct xdp_buff *)r1)->flags = r2; */
+		BPF_STX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, flags),
+			    BPF_REG_1, BPF_REG_2,
+			    offsetof(struct xdp_buff, flags)),
+
+		/* push r1 */
+		BPF_PUSH64(BPF_REG_1),
+	);
+
+	/*	r0 = bpf_xdp_metadata_rx_timestamp(ctx); */
+	func_id = xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP);
+	prog->aux->xdp_kfunc_ndo->ndo_unroll_kfunc(prog, func_id, patch);
+
+	bpf_patch_append(patch,
+		/* pop r1 */
+		BPF_POP64(BPF_REG_1),
+
+		/* r2 = ((struct xdp_buff *)r1)->data_meta; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
+			    offsetof(struct xdp_buff, data_meta)),
+		/* r2 -= sizeof(struct xdp_skb_metadata); */
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2,
+			      sizeof(struct xdp_skb_metadata)),
+
+		/* *((struct xdp_skb_metadata *)r2)->rx_timestamp = r0; */
+		BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_0,
+			    offsetof(struct xdp_skb_metadata, rx_timestamp)),
+
+		/* return 0; */
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+	);
+
+	bpf_patch_resolve_jmp(patch);
+}
+EXPORT_SYMBOL(xdp_metadata_export_to_skb);
+
 static int __init xdp_metadata_init(void)
 {
 	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
 }
 late_initcall(xdp_metadata_init);
+#else
+struct btf_id_set8 xdp_metadata_kfunc_ids = {};
+EXPORT_SYMBOL(xdp_metadata_kfunc_ids);
+void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
+{
+}
+EXPORT_SYMBOL(xdp_metadata_export_to_skb);
 #endif
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b444b1118c4f..71e3bc7ad839 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6116,6 +6116,12 @@ enum xdp_action {
 	XDP_REDIRECT,
 };
 
+/* Subset of XDP metadata exported to skb context.
+ */
+struct xdp_skb_metadata {
+	__u64 rx_timestamp;
+};
+
 /* user accessible metadata for XDP packet hook
  * new fields must be added to the end of this structure
  */
@@ -6128,6 +6134,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__bpf_md_ptr(struct xdp_skb_metadata *, skb_metadata);
 };
 
 /* DEVMAP map-value layout
-- 
2.38.1.431.g37b22c650d-goog

