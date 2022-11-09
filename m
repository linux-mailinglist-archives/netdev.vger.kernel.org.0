Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F26227C4
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKIJ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiKIJ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:58:07 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0B6248F3
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:58:04 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-348608c1cd3so161100237b3.10
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 01:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=px+BzkLW42g9tg6MpXcZpEFdmf9YBOhRfZK4GpJ+Vrc=;
        b=JU3HbAeNhO2ZGSlbL+sVJIsRNgDAEF0QccjHo9Y1meLT/FfhJEj2P68x6ja7171Hdp
         TcBUwl6E+lT/osr3kN4cE4uprJI0Gx3rdPIC3bWkEpFTAEuIvd/QFMaFnSvlS//5x8kH
         KsiLLTiBi2KfuBKbHpnhagAXHcBohqIWsvqgtLefrDatHfzkYQ5bMagtTFuPH+EhoDKx
         1u4r/UUa3ucMmuX0gc22YTQIcXQZ4sGtUdAMDkMARvHaJc6Q+0ninnIXJ4ULajW5FsKS
         LNBJ57tHSmSZ8F4qN2GakhHfTR4rKIFrfOs69S2bX3RfDNKuCYpxwsqPVrSo7rAGM3z1
         nZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=px+BzkLW42g9tg6MpXcZpEFdmf9YBOhRfZK4GpJ+Vrc=;
        b=b6++nuf3fgcBqla0pF56/f51hj8cw8h9IKI8eooGoJDj006TElwxk3ACjbVQUOnbd8
         EIQp+FfWrhb4J61GfHAPjI85UYaDkrnQVqIU7hCYDaawNwea7LrM472VQ769JNxJdTKZ
         d4sWyHLc9oBh4f9DkjhsAmDfywrrZ/DdvaM3ZA1swJZgTi9zKA9BWJ/7C/lsifPqQjpY
         Q9Vj6l8I7vPEciXUmy4AiceEs3/R6tzTTd14IT93nk7GVXQRPz3hqc2YucIMgrI0cM48
         gs9T5y8DCpBFJwZoXHwwmpLwS2v3IuKvtIm5FZjq8KjldEmIr5iiNpRKNGAnP7u2EKUV
         7ZKQ==
X-Gm-Message-State: ACrzQf1tg3jXqoxAJEN5E5Z1WU/UZEgMjyQIGweMVAK5Br4Qsp6jfbGA
        oUqSpHWLeIWqsCc0WBAoQz20tPEGFdQicQ==
X-Google-Smtp-Source: AMsMyM7nGNSDP3gIRHD3qlTIyskOPdZRlphSNk9wFjHPMAwWr7CXnhLtU2gjLCMMYmvvbGVwr88pyj6LIlgzkA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:d88c:0:b0:368:d11:50b1 with SMTP id
 a134-20020a0dd88c000000b003680d1150b1mr56013359ywe.27.1667987883660; Wed, 09
 Nov 2022 01:58:03 -0800 (PST)
Date:   Wed,  9 Nov 2022 09:57:58 +0000
In-Reply-To: <20221109095759.1874969-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221109095759.1874969-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109095759.1874969-2-edumazet@google.com>
Subject: [PATCH net-next 1/2] net: remove skb->vlan_present
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

skb->vlan_present seems redundant.

We can instead derive it from this boolean expression:

vlan_present = skb->vlan_proto != 0 || skb->vlan_tci != 0

Add a new union, to access both fields in a single load/store
when possible.

	union {
		u32	vlan_all;
		struct {
		__be16	vlan_proto;
		__u16	vlan_tci;
		};
	};

This allows following patch to remove a conditional test in GRO stack.

Note:
  We move remcsum_offload to keep TC_AT_INGRESS_MASK
  and SKB_MONO_DELIVERY_TIME_MASK unchanged.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 arch/sparc/net/bpf_jit_comp_32.c              | 10 ++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 include/linux/if_vlan.h                       |  9 +++-----
 include/linux/skbuff.h                        | 18 ++++++++-------
 lib/test_bpf.c                                |  1 -
 net/core/filter.c                             | 22 +++++++++----------
 6 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/sparc/net/bpf_jit_comp_32.c b/arch/sparc/net/bpf_jit_comp_32.c
index b1dbf2fa8c0ae82e4bdb5ed87b3ddc8964a96d6d..a74e5004c6c89c8267b0014cf78a72ae66ee4f89 100644
--- a/arch/sparc/net/bpf_jit_comp_32.c
+++ b/arch/sparc/net/bpf_jit_comp_32.c
@@ -555,11 +555,11 @@ void bpf_jit_compile(struct bpf_prog *fp)
 				emit_skb_load16(vlan_tci, r_A);
 				break;
 			case BPF_ANC | SKF_AD_VLAN_TAG_PRESENT:
-				__emit_skb_load8(__pkt_vlan_present_offset, r_A);
-				if (PKT_VLAN_PRESENT_BIT)
-					emit_alu_K(SRL, PKT_VLAN_PRESENT_BIT);
-				if (PKT_VLAN_PRESENT_BIT < 7)
-					emit_andi(r_A, 1, r_A);
+				emit_skb_load32(vlan_all, r_A);
+				emit_cmpi(r_A, 0);
+				emit_branch_off(BE, 12);
+				emit_nop();
+				emit_loadimm(1, r_A);
 				break;
 			case BPF_LD | BPF_W | BPF_LEN:
 				emit_skb_load32(len, r_A);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 892ca88e0cf43be6cb590b1925a8f5b065ce9575..436fa19fa03723ff93f143df0760079e9e32cee9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1898,7 +1898,7 @@ static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 #endif
 
 #ifdef CONFIG_DCB
-	if (!skb->vlan_present)
+	if (!skb_vlan_tag_present(skb))
 		goto pick_tx;
 
 	vlan_prio = skb->vlan_tci >> 13;
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index e00c4ee81ff7f82e4343fe45c14d8e5d81d80e95..6864b89ef86818c4c360dc3b2adca1dfe65a21ff 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -76,7 +76,7 @@ static inline bool is_vlan_dev(const struct net_device *dev)
         return dev->priv_flags & IFF_802_1Q_VLAN;
 }
 
-#define skb_vlan_tag_present(__skb)	((__skb)->vlan_present)
+#define skb_vlan_tag_present(__skb)	(!!(__skb)->vlan_all)
 #define skb_vlan_tag_get(__skb)		((__skb)->vlan_tci)
 #define skb_vlan_tag_get_id(__skb)	((__skb)->vlan_tci & VLAN_VID_MASK)
 #define skb_vlan_tag_get_cfi(__skb)	(!!((__skb)->vlan_tci & VLAN_CFI_MASK))
@@ -471,7 +471,7 @@ static inline struct sk_buff *vlan_insert_tag_set_proto(struct sk_buff *skb,
  */
 static inline void __vlan_hwaccel_clear_tag(struct sk_buff *skb)
 {
-	skb->vlan_present = 0;
+	skb->vlan_all = 0;
 }
 
 /**
@@ -483,9 +483,7 @@ static inline void __vlan_hwaccel_clear_tag(struct sk_buff *skb)
  */
 static inline void __vlan_hwaccel_copy_tag(struct sk_buff *dst, const struct sk_buff *src)
 {
-	dst->vlan_present = src->vlan_present;
-	dst->vlan_proto = src->vlan_proto;
-	dst->vlan_tci = src->vlan_tci;
+	dst->vlan_all = src->vlan_all;
 }
 
 /*
@@ -519,7 +517,6 @@ static inline void __vlan_hwaccel_put_tag(struct sk_buff *skb,
 {
 	skb->vlan_proto = vlan_proto;
 	skb->vlan_tci = vlan_tci;
-	skb->vlan_present = 1;
 }
 
 /**
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 59c9fd55699d63ab966665db0d97ba0b58de7404..4e464a27adafbca281675c0a36ce6911cadcd6f1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -818,7 +818,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@mark: Generic packet mark
  *	@reserved_tailroom: (aka @mark) number of bytes of free space available
  *		at the tail of an sk_buff
- *	@vlan_present: VLAN tag is present
+ *	@vlan_all: vlan fields (proto & tci)
  *	@vlan_proto: vlan encapsulation protocol
  *	@vlan_tci: vlan tag control information
  *	@inner_protocol: Protocol (encapsulation)
@@ -951,7 +951,7 @@ struct sk_buff {
 	/* private: */
 	__u8			__pkt_vlan_present_offset[0];
 	/* public: */
-	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
+	__u8			remcsum_offload:1;
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
 	__u8			dst_pending_confirm:1;
@@ -966,7 +966,6 @@ struct sk_buff {
 
 	__u8			ipvs_property:1;
 	__u8			inner_protocol_type:1;
-	__u8			remcsum_offload:1;
 #ifdef CONFIG_NET_SWITCHDEV
 	__u8			offload_fwd_mark:1;
 	__u8			offload_l3_fwd_mark:1;
@@ -999,8 +998,13 @@ struct sk_buff {
 	__u32			priority;
 	int			skb_iif;
 	__u32			hash;
-	__be16			vlan_proto;
-	__u16			vlan_tci;
+	union {
+		u32		vlan_all;
+		struct {
+			__be16	vlan_proto;
+			__u16	vlan_tci;
+		};
+	};
 #if defined(CONFIG_NET_RX_BUSY_POLL) || defined(CONFIG_XPS)
 	union {
 		unsigned int	napi_id;
@@ -1059,15 +1063,13 @@ struct sk_buff {
 #endif
 #define PKT_TYPE_OFFSET		offsetof(struct sk_buff, __pkt_type_offset)
 
-/* if you move pkt_vlan_present, tc_at_ingress, or mono_delivery_time
+/* if you move tc_at_ingress or mono_delivery_time
  * around, you also must adapt these constants.
  */
 #ifdef __BIG_ENDIAN_BITFIELD
-#define PKT_VLAN_PRESENT_BIT	7
 #define TC_AT_INGRESS_MASK		(1 << 0)
 #define SKB_MONO_DELIVERY_TIME_MASK	(1 << 2)
 #else
-#define PKT_VLAN_PRESENT_BIT	0
 #define TC_AT_INGRESS_MASK		(1 << 7)
 #define SKB_MONO_DELIVERY_TIME_MASK	(1 << 5)
 #endif
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 5820704165a64ddcfc193b59158d06141f64fe92..ade9ac672adbbdb41504dbb639847be2ff8f6531 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -14346,7 +14346,6 @@ static struct sk_buff *populate_skb(char *buf, int size)
 	skb->hash = SKB_HASH;
 	skb->queue_mapping = SKB_QUEUE_MAP;
 	skb->vlan_tci = SKB_VLAN_TCI;
-	skb->vlan_present = SKB_VLAN_PRESENT;
 	skb->vlan_proto = htons(ETH_P_IP);
 	dev_net_set(&dev, &init_net);
 	skb->dev = &dev;
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e422b010477333c811db79aaf56e3f..358d5e70671a0808b4d10c2a59a78128925b0f31 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -325,11 +325,11 @@ static u32 convert_skb_access(int skb_field, int dst_reg, int src_reg,
 				      offsetof(struct sk_buff, vlan_tci));
 		break;
 	case SKF_AD_VLAN_TAG_PRESENT:
-		*insn++ = BPF_LDX_MEM(BPF_B, dst_reg, src_reg, PKT_VLAN_PRESENT_OFFSET);
-		if (PKT_VLAN_PRESENT_BIT)
-			*insn++ = BPF_ALU32_IMM(BPF_RSH, dst_reg, PKT_VLAN_PRESENT_BIT);
-		if (PKT_VLAN_PRESENT_BIT < 7)
-			*insn++ = BPF_ALU32_IMM(BPF_AND, dst_reg, 1);
+		BUILD_BUG_ON(sizeof_field(struct sk_buff, vlan_all) != 4);
+		*insn++ = BPF_LDX_MEM(BPF_W, dst_reg, src_reg,
+				      offsetof(struct sk_buff, vlan_all));
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, dst_reg, 0, 1);
+		*insn++ = BPF_ALU32_IMM(BPF_MOV, dst_reg, 1);
 		break;
 	}
 
@@ -9290,13 +9290,11 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct __sk_buff, vlan_present):
-		*target_size = 1;
-		*insn++ = BPF_LDX_MEM(BPF_B, si->dst_reg, si->src_reg,
-				      PKT_VLAN_PRESENT_OFFSET);
-		if (PKT_VLAN_PRESENT_BIT)
-			*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg, PKT_VLAN_PRESENT_BIT);
-		if (PKT_VLAN_PRESENT_BIT < 7)
-			*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, 1);
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct sk_buff,
+						     vlan_all, 4, target_size));
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
+		*insn++ = BPF_ALU32_IMM(BPF_MOV, si->dst_reg, 1);
 		break;
 
 	case offsetof(struct __sk_buff, vlan_tci):
-- 
2.38.1.431.g37b22c650d-goog

