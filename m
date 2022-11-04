Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C6618F06
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiKDD1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiKDD0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:26:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDAD224
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:25:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so1712712pff.0
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 20:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihZzJF7597DRgFfCfftxikAZGsxqS56nkA4DFFWfHYQ=;
        b=O6j3jw4WO9cDivd+XT++t4UGSmYM2Wyxlqvj+uDHKu+3LpChgapKTSsc6wJTTtGS3J
         bSE/CwSBUdDJwRYQ6POj8Rp4O462+z9t6/omTnSpBxJMaC0LeSNUWOp16la9DaRF6KAh
         DHv6rT89nH+BYY2H3AwYc8pJ7mnjEpOgX9lXytMoHu2hkLBRrPYoD7/CQtuoGgcHmAmY
         NmYFyB86RauO1QA0S6P0GGbWPsyvKM0ch2Z9ZMIVKsbf2LpPxSUmicUVsN8DiI5vUH61
         pfeOh9efwrog/ZEh7A/0SEsjexze6IFyOC8zs++rBKbSOXGwDybME32g9oGx9SIjZYRJ
         ugtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ihZzJF7597DRgFfCfftxikAZGsxqS56nkA4DFFWfHYQ=;
        b=m8891wiPnOU07JJRV6aiCEhMhrKxLqpTvhPU6zwDIlXFTvbVDOS/Si8XYk0L4lUqOi
         pS4wfX3HDJEMtCFFsjaocK/sdmNbFRONiCso9CLmRXSviG73hXq2/wveSNWQ1ELO8Qjs
         sGAYUrT1ST7zsArazagsozhhhR4ZcrhbJlDy6NkPoE3CI7X63EKj2jCgPV5vkthZ9z9K
         V8lkO2fa6lbgtkkAveLPI6Ip4osJTU2g40fjygKyw6N3HNFfoq8bn7n/NqToOAe0MCx5
         jFXzAHvoRWyQvLvkiAj4q3jMZPxGKHiEz9ICAc7PZvp+BigA2KcMzA74JyAwHoF8jmGA
         4tXg==
X-Gm-Message-State: ACrzQf1LkFz4rSt7b0RPiG02wweaZNjwg/qWV0foMsi5x8bo39e6FYEF
        +ybw48K2VgR0cnpFTEcvdE+paJM=
X-Google-Smtp-Source: AMsMyM6zo88022ftXuwN32uxpEBA+K1ujdaEzNR7jToX8ohFgGPpKWLwczxVgEEVqdYBlMGhzhQEXdA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:8a13:0:b0:56c:b5fc:9167 with SMTP id
 m19-20020aa78a13000000b0056cb5fc9167mr244736pfa.40.1667532344262; Thu, 03 Nov
 2022 20:25:44 -0700 (PDT)
Date:   Thu,  3 Nov 2022 20:25:24 -0700
In-Reply-To: <20221104032532.1615099-1-sdf@google.com>
Mime-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221104032532.1615099-7-sdf@google.com>
Subject: [RFC bpf-next v2 06/14] xdp: Carry over xdp metadata into skb context
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
or (unless already called) when XDP_PASS'ing the frame
into the kernel.

The implementation currently maintains xdp_to_skb_metadata
layout by calling bpf_xdp_metadata_rx_timestamp and placing
small magic number. From skb_metdata_set, when we get expected magic number,
we interpret metadata accordingly.

Both magic number and struct layout are randomized to make sure
it doesn't leak into the userspace.

skb_metadata_set is amended with skb_metadata_import_from_xdp which
tries to parse out the metadata and put it into skb.

See the comment for r1 vs r2/r3/r4/r5 conventions.

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
 drivers/net/veth.c        |   4 +-
 include/linux/bpf_patch.h |   2 +
 include/linux/skbuff.h    |   4 ++
 include/net/xdp.h         |  13 +++++
 kernel/bpf/bpf_patch.c    |  30 +++++++++++
 kernel/bpf/verifier.c     |  18 +++++++
 net/core/skbuff.c         |  25 +++++++++
 net/core/xdp.c            | 104 +++++++++++++++++++++++++++++++++++---
 8 files changed, 193 insertions(+), 7 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0e629ceb087b..d4cd0938360b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1673,7 +1673,9 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
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
diff --git a/include/linux/bpf_patch.h b/include/linux/bpf_patch.h
index 81ff738eef8d..359c165ad68b 100644
--- a/include/linux/bpf_patch.h
+++ b/include/linux/bpf_patch.h
@@ -16,6 +16,8 @@ size_t bpf_patch_len(const struct bpf_patch *patch);
 int bpf_patch_err(const struct bpf_patch *patch);
 void __bpf_patch_append(struct bpf_patch *patch, struct bpf_insn insn);
 struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch);
+void bpf_patch_resolve_jmp(struct bpf_patch *patch);
+u32 bpf_patch_magles_registers(const struct bpf_patch *patch);
 
 #define bpf_patch_append(patch, ...) ({ \
 	struct bpf_insn insn[] = { __VA_ARGS__ }; \
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 59c9fd55699d..dba857f212d7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4217,9 +4217,13 @@ static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
 	       true : __skb_metadata_differs(skb_a, skb_b, len_a);
 }
 
+void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len);
+
 static inline void skb_metadata_set(struct sk_buff *skb, u8 meta_len)
 {
 	skb_shinfo(skb)->meta_len = meta_len;
+	if (meta_len)
+		skb_metadata_import_from_xdp(skb, meta_len);
 }
 
 static inline void skb_metadata_clear(struct sk_buff *skb)
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 2a82a98f2f9f..8c97c6996172 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -411,6 +411,8 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
 #define XDP_METADATA_KFUNC_xxx	\
+	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_EXPORT_TO_SKB, \
+			   bpf_xdp_metadata_export_to_skb) \
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
 			   bpf_xdp_metadata_rx_timestamp_supported) \
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
@@ -423,14 +425,25 @@ XDP_METADATA_KFUNC_xxx
 MAX_XDP_METADATA_KFUNC,
 };
 
+struct xdp_to_skb_metadata {
+	u32 magic; /* xdp_metadata_magic */
+	u64 rx_timestamp;
+} __randomize_layout;
+
+struct bpf_patch;
+
 #ifdef CONFIG_DEBUG_INFO_BTF
+extern u32 xdp_metadata_magic;
 extern struct btf_id_set8 xdp_metadata_kfunc_ids;
 static inline u32 xdp_metadata_kfunc_id(int id)
 {
 	return xdp_metadata_kfunc_ids.pairs[id].id;
 }
+void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch);
 #else
+#define xdp_metadata_magic 0
 static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
+static void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch) { return 0; }
 #endif
 
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/kernel/bpf/bpf_patch.c b/kernel/bpf/bpf_patch.c
index 82a10bf5624a..8f1fef74299c 100644
--- a/kernel/bpf/bpf_patch.c
+++ b/kernel/bpf/bpf_patch.c
@@ -49,3 +49,33 @@ struct bpf_insn *bpf_patch_data(const struct bpf_patch *patch)
 {
 	return patch->insn;
 }
+
+void bpf_patch_resolve_jmp(struct bpf_patch *patch)
+{
+	int i;
+
+	for (i = 0; i < patch->len; i++) {
+		if (BPF_CLASS(patch->insn[i].code) != BPF_JMP)
+			continue;
+
+		if (BPF_SRC(patch->insn[i].code) != BPF_X)
+			continue;
+
+		if (patch->insn[i].off != S16_MAX)
+			continue;
+
+		patch->insn[i].off = patch->len - i - 1;
+	}
+}
+
+u32 bpf_patch_magles_registers(const struct bpf_patch *patch)
+{
+	u32 mask = 0;
+	int i;
+
+	for (i = 0; i < patch->len; i++) {
+		mask |= 1 << patch->insn[i].dst_reg;
+	}
+
+	return mask;
+}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4e5c5ff35d5f..49f55f81e7f3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13902,6 +13902,24 @@ static int unroll_kfunc_call(struct bpf_verifier_env *env,
 		 */
 		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 0));
 	}
+
+	if (func_id != xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_EXPORT_TO_SKB)) {
+		u32 allowed = 0;
+		u32 mangled = bpf_patch_magles_registers(patch);
+
+		/* See xdp_metadata_export_to_skb comment for the
+		 * reason about these constraints.
+		 */
+
+		allowed |= 1 << BPF_REG_0;
+		allowed |= 1 << BPF_REG_2;
+		allowed |= 1 << BPF_REG_3;
+		allowed |= 1 << BPF_REG_4;
+		allowed |= 1 << BPF_REG_5;
+
+		WARN_ON_ONCE(mangled & ~allowed);
+	}
+
 	return bpf_patch_err(patch);
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 42a35b59fb1e..37e3aef46525 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -72,6 +72,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/xdp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6672,3 +6673,27 @@ nodefer:	__kfree_skb(skb);
 	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
 		smp_call_function_single_async(cpu, &sd->defer_csd);
 }
+
+void skb_metadata_import_from_xdp(struct sk_buff *skb, size_t len)
+{
+	struct xdp_to_skb_metadata *meta = (void *)(skb_mac_header(skb) - len);
+
+	/* Optional SKB info, currently missing:
+	 * - HW checksum info		(skb->ip_summed)
+	 * - HW RX hash			(skb_set_hash)
+	 * - RX ring dev queue index	(skb_record_rx_queue)
+	 */
+
+	if (len != sizeof(struct xdp_to_skb_metadata))
+		return;
+
+	if (meta->magic != xdp_metadata_magic)
+		return;
+
+	if (meta->rx_timestamp) {
+		*skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
+			.hwtstamp = ns_to_ktime(meta->rx_timestamp),
+		};
+	}
+}
+EXPORT_SYMBOL(skb_metadata_import_from_xdp);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 22f1e44700eb..8204fa05c5e9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -653,12 +653,6 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	/* Essential SKB info: protocol and skb->dev */
 	skb->protocol = eth_type_trans(skb, dev);
 
-	/* Optional SKB info, currently missing:
-	 * - HW checksum info		(skb->ip_summed)
-	 * - HW RX hash			(skb_set_hash)
-	 * - RX ring dev queue index	(skb_record_rx_queue)
-	 */
-
 	/* Until page_pool get SKB return path, release DMA here */
 	xdp_release_frame(xdpf);
 
@@ -712,6 +706,13 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 	return nxdpf;
 }
 
+/* For the packets directed to the kernel, this kfunc exports XDP metadata
+ * into skb context.
+ */
+noinline void bpf_xdp_metadata_export_to_skb(const struct xdp_md *ctx)
+{
+}
+
 /* Indicates whether particular device supports rx_timestamp metadata.
  * This is an optional helper to support marking some branches as
  * "dead code" in the BPF programs.
@@ -737,13 +738,104 @@ XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
 
+/* Make sure userspace doesn't depend on our layout by using
+ * different pseudo-generated magic value.
+ */
+u32 xdp_metadata_magic;
+
 static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
 	.owner = THIS_MODULE,
 	.set   = &xdp_metadata_kfunc_ids,
 };
 
+/* Since we're not actually doing a call but instead rewriting
+ * in place, we can only afford to use R0-R5 scratch registers.
+ *
+ * We reserve R1 for bpf_xdp_metadata_export_to_skb and let individual
+ * metadata kfuncs use only R0,R4-R5.
+ *
+ * The above also means we _cannot_ easily call any other helper/kfunc
+ * because there is no place for us to preserve our R1 argument;
+ * existing R6-R9 belong to the callee.
+ */
+void xdp_metadata_export_to_skb(const struct bpf_prog *prog, struct bpf_patch *patch)
+{
+	u32 func_id;
+
+	/*
+	 * The code below generates the following:
+	 *
+	 * void bpf_xdp_metadata_export_to_skb(struct xdp_md *ctx)
+	 * {
+	 *	struct xdp_to_skb_metadata *meta;
+	 *	int ret;
+	 *
+	 *	ret = bpf_xdp_adjust_meta(ctx, -sizeof(*meta));
+	 *	if (!ret)
+	 *		return;
+	 *
+	 *	meta = ctx->data_meta;
+	 *	meta->magic = xdp_metadata_magic;
+	 *	meta->rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
+	 * }
+	 *
+	 */
+
+	bpf_patch_append(patch,
+		/* r2 = ((struct xdp_buff *)r1)->data_meta; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
+			    offsetof(struct xdp_buff, data_meta)),
+		/* r3 = ((struct xdp_buff *)r1)->data; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
+			    offsetof(struct xdp_buff, data)),
+		/* if (data_meta != data) return;
+		 *
+		 *	data_meta > data: xdp_data_meta_unsupported()
+		 *	data_meta < data: already used, no need to touch
+		 */
+		BPF_JMP_REG(BPF_JNE, BPF_REG_2, BPF_REG_3, S16_MAX),
+
+		/* r2 -= sizeof(struct xdp_to_skb_metadata); */
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2,
+			      sizeof(struct xdp_to_skb_metadata)),
+		/* r3 = ((struct xdp_buff *)r1)->data_hard_start; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_1,
+			    offsetof(struct xdp_buff, data_hard_start)),
+		/* r3 += sizeof(struct xdp_frame) */
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3,
+			      sizeof(struct xdp_frame)),
+		/* if (data-sizeof(struct xdp_to_skb_metadata) < data_hard_start+sizeof(struct xdp_frame)) return; */
+		BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, S16_MAX),
+
+		/* ((struct xdp_buff *)r1)->data_meta = r2; */
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2,
+			    offsetof(struct xdp_buff, data_meta)),
+
+		/* *((struct xdp_to_skb_metadata *)r2)->magic = xdp_metadata_magic; */
+		BPF_ST_MEM(BPF_W, BPF_REG_2,
+			   offsetof(struct xdp_to_skb_metadata, magic),
+			   xdp_metadata_magic),
+	);
+
+	/*	r0 = bpf_xdp_metadata_rx_timestamp(ctx); */
+	func_id = xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP);
+	prog->aux->xdp_kfunc_ndo->ndo_unroll_kfunc(prog, func_id, patch);
+
+	bpf_patch_append(patch,
+		/* r2 = ((struct xdp_buff *)r1)->data_meta; */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1,
+			    offsetof(struct xdp_buff, data_meta)),
+		/* *((struct xdp_to_skb_metadata *)r2)->rx_timestamp = r0; */
+		BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_0,
+			    offsetof(struct xdp_to_skb_metadata, rx_timestamp)),
+	);
+
+	bpf_patch_resolve_jmp(patch);
+}
+
 static int __init xdp_metadata_init(void)
 {
+	xdp_metadata_magic = get_random_u32() | 1;
 	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
 }
 late_initcall(xdp_metadata_init);
-- 
2.38.1.431.g37b22c650d-goog

