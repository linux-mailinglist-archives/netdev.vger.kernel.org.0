Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3147D2D1668
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgLGQfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbgLGQeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:31 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 13/14] bpf: add new frame_length field to the XDP ctx
Date:   Mon,  7 Dec 2020 17:32:42 +0100
Message-Id: <0547d6f752e325f56a8e5f6466b50e81ff29d65f.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This patch adds a new field to the XDP context called frame_length,
which will hold the full length of the packet, including fragments
if existing.

eBPF programs can determine if fragments are present using something
like:

  if (ctx->data_end - ctx->data < ctx->frame_length) {
    /* Fragements exists. /*
  }

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h              | 22 +++++++++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/verifier.c          |  2 +-
 net/core/filter.c              | 83 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 5 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 09078ab6644c..e54d733c90ed 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -73,8 +73,30 @@ struct xdp_buff {
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
+	/* If any of the bitfield lengths for frame_sz or mb below change,
+	 * make sure the defines here are also updated!
+	 */
+#ifdef __BIG_ENDIAN_BITFIELD
+#define MB_SHIFT	  0
+#define MB_MASK		  0x00000001
+#define FRAME_SZ_SHIFT	  1
+#define FRAME_SZ_MASK	  0xfffffffe
+#else
+#define MB_SHIFT	  31
+#define MB_MASK		  0x80000000
+#define FRAME_SZ_SHIFT	  0
+#define FRAME_SZ_MASK	  0x7fffffff
+#endif
+#define FRAME_SZ_OFFSET() offsetof(struct xdp_buff, __u32_bit_fields_offset)
+#define MB_OFFSET()	  offsetof(struct xdp_buff, __u32_bit_fields_offset)
+	/* private: */
+	u32 __u32_bit_fields_offset[0];
+	/* public: */
 	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
 	u32 mb:1; /* xdp non-linear buffer */
+
+	/* Temporary registers to make conditional access/stores possible. */
+	u64 tmp_reg[2];
 };
 
 /* Reserve memory area at end-of data area.
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 30b477a26482..62c50ab28ea9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4380,6 +4380,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__u32 frame_length;
 };
 
 /* DEVMAP map-value layout
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 93def76cf32b..c50caea29fa2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10526,7 +10526,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 	const struct bpf_verifier_ops *ops = env->ops;
 	int i, cnt, size, ctx_field_size, delta = 0;
 	const int insn_cnt = env->prog->len;
-	struct bpf_insn insn_buf[16], *insn;
+	struct bpf_insn insn_buf[32], *insn;
 	u32 target_size, size_default, off;
 	struct bpf_prog *new_prog;
 	enum bpf_access_type type;
diff --git a/net/core/filter.c b/net/core/filter.c
index 4c4882d4d92c..278640db9e0a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8908,6 +8908,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 				  struct bpf_insn *insn_buf,
 				  struct bpf_prog *prog, u32 *target_size)
 {
+	int ctx_reg, dst_reg, scratch_reg;
 	struct bpf_insn *insn = insn_buf;
 
 	switch (si->off) {
@@ -8954,6 +8955,88 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
 				      offsetof(struct net_device, ifindex));
 		break;
+	case offsetof(struct xdp_md, frame_length):
+		/* Need tmp storage for src_reg in case src_reg == dst_reg,
+		 * and a scratch reg */
+		scratch_reg = BPF_REG_9;
+		dst_reg = si->dst_reg;
+
+		if (dst_reg == scratch_reg)
+			scratch_reg--;
+
+		ctx_reg = (si->src_reg == si->dst_reg) ? scratch_reg - 1 : si->src_reg;
+		while (dst_reg == ctx_reg || scratch_reg == ctx_reg)
+			ctx_reg--;
+
+		/* Save scratch registers */
+		if (ctx_reg != si->src_reg) {
+			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, ctx_reg,
+					      offsetof(struct xdp_buff,
+						       tmp_reg[1]));
+
+			*insn++ = BPF_MOV64_REG(ctx_reg, si->src_reg);
+		}
+
+		*insn++ = BPF_STX_MEM(BPF_DW, ctx_reg, scratch_reg,
+				      offsetof(struct xdp_buff, tmp_reg[0]));
+
+		/* What does this code do?
+		 *   dst_reg = 0
+		 *
+		 *   if (!ctx_reg->mb)
+		 *      goto no_mb:
+		 *
+		 *   dst_reg = (struct xdp_shared_info *)xdp_data_hard_end(xdp)
+		 *   dst_reg = dst_reg->data_length
+		 *
+		 * NOTE: xdp_data_hard_end() is xdp->hard_start +
+		 *       xdp->frame_sz - sizeof(shared_info)
+		 *
+		 * no_mb:
+		 *   dst_reg += ctx_reg->data_end - ctx_reg->data
+		 */
+		*insn++ = BPF_MOV64_IMM(dst_reg, 0);
+
+		*insn++ = BPF_LDX_MEM(BPF_W, scratch_reg, ctx_reg, MB_OFFSET());
+		*insn++ = BPF_ALU32_IMM(BPF_AND, scratch_reg, MB_MASK);
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, scratch_reg, 0, 7); /*goto no_mb; */
+
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff,
+						       data_hard_start),
+				      dst_reg, ctx_reg,
+				      offsetof(struct xdp_buff, data_hard_start));
+		*insn++ = BPF_LDX_MEM(BPF_W, scratch_reg, ctx_reg,
+				      FRAME_SZ_OFFSET());
+		*insn++ = BPF_ALU32_IMM(BPF_AND, scratch_reg, FRAME_SZ_MASK);
+		*insn++ = BPF_ALU32_IMM(BPF_RSH, scratch_reg, FRAME_SZ_SHIFT);
+		*insn++ = BPF_ALU64_REG(BPF_ADD, dst_reg, scratch_reg);
+		*insn++ = BPF_ALU64_IMM(BPF_SUB, dst_reg,
+					SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_shared_info,
+						       data_length),
+				      dst_reg, dst_reg,
+				      offsetof(struct xdp_shared_info,
+					       data_length));
+
+		/* no_mb: */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data_end),
+				      scratch_reg, ctx_reg,
+				      offsetof(struct xdp_buff, data_end));
+		*insn++ = BPF_ALU64_REG(BPF_ADD, dst_reg, scratch_reg);
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, data),
+				      scratch_reg, ctx_reg,
+				      offsetof(struct xdp_buff, data));
+		*insn++ = BPF_ALU64_REG(BPF_SUB, dst_reg, scratch_reg);
+
+		/* Restore scratch registers */
+		*insn++ = BPF_LDX_MEM(BPF_DW, scratch_reg, ctx_reg,
+				      offsetof(struct xdp_buff, tmp_reg[0]));
+
+		if (ctx_reg != si->src_reg)
+			*insn++ = BPF_LDX_MEM(BPF_DW, ctx_reg, ctx_reg,
+					      offsetof(struct xdp_buff,
+						       tmp_reg[1]));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 30b477a26482..62c50ab28ea9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4380,6 +4380,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__u32 frame_length;
 };
 
 /* DEVMAP map-value layout
-- 
2.28.0

