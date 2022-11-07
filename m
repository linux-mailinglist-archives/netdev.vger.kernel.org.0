Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79119620338
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 00:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiKGXEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 18:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiKGXEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 18:04:30 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804D125C5A;
        Mon,  7 Nov 2022 15:04:29 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667862268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9d5E8cFGQW2JMKOQlKfEy4HjJCwGUnDk0RP9tD6S5Q=;
        b=kIBmDGPbNg0XfirwQ8ttdHP4zBFbUkkYZL2cp7fiPm/lPzRqcTF7fArZa4zlHBiidfplle
        HYyur5bsnr8qUEoVkxbekorDPFioSxo+0u7R4CtQnS2Nz9OfPfUmyOtc/dZJm5qY5m8f0k
        YUWBjb65NLNfCOlzoK6RbbnyhnEqF8Q=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 bpf-next 1/3] bpf: Add hwtstamp field for the sockops prog
Date:   Mon,  7 Nov 2022 15:04:18 -0800
Message-Id: <20221107230420.4192307-2-martin.lau@linux.dev>
In-Reply-To: <20221107230420.4192307-1-martin.lau@linux.dev>
References: <20221107230420.4192307-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The bpf-tc prog has already been able to access the
skb_hwtstamps(skb)->hwtstamp.  This patch extends the same hwtstamp
access to the sockops prog.

In sockops, the skb is also available to the bpf prog during
the BPF_SOCK_OPS_PARSE_HDR_OPT_CB event.  There is a use case
that the hwtstamp will be useful to the sockops prog to better
measure the one-way-delay when the sender has put the tx
timestamp in the tcp header option.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 39 +++++++++++++++++++++++++++-------
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 94659f6b3395..fb4c911d2a03 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6445,6 +6445,7 @@ struct bpf_sock_ops {
 				 * the outgoing header has not
 				 * been written yet.
 				 */
+	__u64 skb_hwtstamp;
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
diff --git a/net/core/filter.c b/net/core/filter.c
index cb3b635e35be..cd667cdbdb26 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8925,6 +8925,10 @@ static bool sock_ops_is_valid_access(int off, int size,
 			bpf_ctx_record_field_size(info, size_default);
 			return bpf_ctx_narrow_access_ok(off, size,
 							size_default);
+		case offsetof(struct bpf_sock_ops, skb_hwtstamp):
+			if (size != sizeof(__u64))
+				return false;
+			break;
 		default:
 			if (size != size_default)
 				return false;
@@ -9108,21 +9112,21 @@ static struct bpf_insn *bpf_convert_tstamp_type_read(const struct bpf_insn *si,
 	return insn;
 }
 
-static struct bpf_insn *bpf_convert_shinfo_access(const struct bpf_insn *si,
+static struct bpf_insn *bpf_convert_shinfo_access(__u8 dst_reg, __u8 skb_reg,
 						  struct bpf_insn *insn)
 {
 	/* si->dst_reg = skb_shinfo(SKB); */
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
-			      BPF_REG_AX, si->src_reg,
+			      BPF_REG_AX, skb_reg,
 			      offsetof(struct sk_buff, end));
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, head),
-			      si->dst_reg, si->src_reg,
+			      dst_reg, skb_reg,
 			      offsetof(struct sk_buff, head));
-	*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
+	*insn++ = BPF_ALU64_REG(BPF_ADD, dst_reg, BPF_REG_AX);
 #else
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, end),
-			      si->dst_reg, si->src_reg,
+			      dst_reg, skb_reg,
 			      offsetof(struct sk_buff, end));
 #endif
 
@@ -9515,7 +9519,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, gso_segs):
-		insn = bpf_convert_shinfo_access(si, insn);
+		insn = bpf_convert_shinfo_access(si->dst_reg, si->src_reg, insn);
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct skb_shared_info, gso_segs),
 				      si->dst_reg, si->dst_reg,
 				      bpf_target_off(struct skb_shared_info,
@@ -9523,7 +9527,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 						     target_size));
 		break;
 	case offsetof(struct __sk_buff, gso_size):
-		insn = bpf_convert_shinfo_access(si, insn);
+		insn = bpf_convert_shinfo_access(si->dst_reg, si->src_reg, insn);
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct skb_shared_info, gso_size),
 				      si->dst_reg, si->dst_reg,
 				      bpf_target_off(struct skb_shared_info,
@@ -9550,7 +9554,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		BUILD_BUG_ON(sizeof_field(struct skb_shared_hwtstamps, hwtstamp) != 8);
 		BUILD_BUG_ON(offsetof(struct skb_shared_hwtstamps, hwtstamp) != 0);
 
-		insn = bpf_convert_shinfo_access(si, insn);
+		insn = bpf_convert_shinfo_access(si->dst_reg, si->src_reg, insn);
 		*insn++ = BPF_LDX_MEM(BPF_DW,
 				      si->dst_reg, si->dst_reg,
 				      bpf_target_off(struct skb_shared_info,
@@ -10400,6 +10404,25 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 						       tcp_flags),
 				      si->dst_reg, si->dst_reg, off);
 		break;
+	case offsetof(struct bpf_sock_ops, skb_hwtstamp): {
+		struct bpf_insn *jmp_on_null_skb;
+
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
+						       skb),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sock_ops_kern,
+					       skb));
+		/* Reserve one insn to test skb == NULL */
+		jmp_on_null_skb = insn++;
+		insn = bpf_convert_shinfo_access(si->dst_reg, si->dst_reg, insn);
+		*insn++ = BPF_LDX_MEM(BPF_DW, si->dst_reg, si->dst_reg,
+				      bpf_target_off(struct skb_shared_info,
+						     hwtstamps, 8,
+						     target_size));
+		*jmp_on_null_skb = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0,
+					       insn - jmp_on_null_skb - 1);
+		break;
+	}
 	}
 	return insn - insn_buf;
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 94659f6b3395..fb4c911d2a03 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6445,6 +6445,7 @@ struct bpf_sock_ops {
 				 * the outgoing header has not
 				 * been written yet.
 				 */
+	__u64 skb_hwtstamp;
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
-- 
2.30.2

