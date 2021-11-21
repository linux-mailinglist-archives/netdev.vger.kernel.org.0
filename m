Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F82F45815D
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 01:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbhKUAfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 19:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbhKUAe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 19:34:57 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A320FC06175B
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 16:31:53 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso12028376pjb.2
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 16:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvyY56mMfwm+louWVWWja3u9QKO9HWFeYdYezwBPDys=;
        b=IWk4xWSDi8fNeHr1spA+s5EGlZeHlbb82q7/Cv9QDSjX6O10zuoTydWjKBHeiHDQsq
         tGWMYhhs5aVhpxmAqyw6vfoWrTJt00kNgqR6rNSwm6trLpoUHCHSfR3IFgAIbx0JNKCT
         AnkUn29WRrFLUgQCm2S1egt7AU7/iWuOo4Ewc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvyY56mMfwm+louWVWWja3u9QKO9HWFeYdYezwBPDys=;
        b=tEt7HHgj9ajsojBPSVyGwUvWotDwPEsSY7cD3K2l1u1TR+5XV6/doo61SCCT9h9byU
         nBxgfTxJGDEjPULqlo3664m6cFhUgWZ6tvcuUX0XxGAEy8hSLFFwQsDhejLCOq69t04t
         8I0jGn4yXyRRdzHpCJpbNSddspd8T2+tjLWR0NekMC9H6TNvjjBKuuwRNBG/FnLOvJwE
         IPmWDUWf2nwRYnS0UKBO0qMcU2IU5qpQWBX/ci7AYftN4ls7K/PlnHqb7wRN/iehBPZo
         ZS+xvB3yCTEOjSBMohkjJGFDp4YaHOJe6bKTajLtXFs6I6xAeWjI5Cu/VyP7d3jEESQI
         /aJg==
X-Gm-Message-State: AOAM53287EUx8rVio1pb3Jukc/du5i8DK2Sfj7D5oM8My/MdsG6ihe4Q
        VVeenGHhAJAbo471I30GWJ099A==
X-Google-Smtp-Source: ABdhPJzmap4vuMp21lhxM6eyokTFTwYGURGq6nlmluLmTZzhCJ9JMng7kY12kkIWK+ypaWoGAYU0pA==
X-Received: by 2002:a17:90b:4b01:: with SMTP id lx1mr15753957pjb.38.1637454713131;
        Sat, 20 Nov 2021 16:31:53 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p66sm2830788pga.31.2021.11.20.16.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 16:31:52 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] skbuff: Move conditional preprocessor directives out of struct sk_buff
Date:   Sat, 20 Nov 2021 16:31:48 -0800
Message-Id: <20211121003149.28397-2-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211121003149.28397-1-keescook@chromium.org>
References: <20211121003149.28397-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5726; h=from:subject; bh=F+mLsC6sVzx5ppQsH/LkJpts9lo79LZh5jTZx7uIYfI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhmZN06AVceoJlGStDjxotQeULvVB0r0DGx7YKGN4u oUMuFAuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZmTdAAKCRCJcvTf3G3AJrZkEA CGJquJaalgqiOXOJuDhkP2Gu5E2S6CaNEb0R1zHR0waZ+xYT57sXec/QJFaHBpFfqqJ/9txR1zWY0w yjXDirL1McQ7YucXbBrAlgHaLSUPJSVKRkMJadU2Jt+gqKH7MPRZHE8arBjJhh9SIFcUIooHn/XjeV +mfMCPU6LpHmJ/WJbfCvPbby0cW72uoIFErm1zYa+zdCWmBsNxzNlighr83K0L5ioN9T1nnAcGp1Kl ZJJmEyC4hTafQrSpewa1QO1hxgIw4qeUCMBRy3tlqXVRgPa8830tjCwq6bQVKA29uoxAVDb8ctkDoI YkzdbkTq/Bt31DNyJ0Z8IBImhrf3e6YUFWxXotGP1gzHWEduBOZ1wSI123vFMmgQGIzInGI4b03yIS c5yfOhTVLfQu8lGip1LFn10ofXAYyDQ6K3esCUVbrQcRWdusnaDkLoj8q7RizM15tTD8EaEXd4q90b KWGxUuyl4Sm7jdnBRacl1Wd6Ok4CB/XNnY+1d0iVKLRQh3hDb375+zXS0yamPih75HCuxvSV8WHmHA Ssl2foTomivKATHFtf5tjK++nIPETFrPT+2ybBTPla5i1g+zJaACH+Tz4ClAohKZeJmbK/+a7sMTmE wm/Uy6ix+yqSFRlbg+mmLNlQjjnWBOqco5kATVLG54LczOFiuyIXAETmIxeg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for using the struct_group() macro in struct sk_buff,
move the conditional preprocessor directives out of the region of struct
sk_buff that will be enclosed by struct_group(). While GCC and Clang are
happy with conditional preprocessor directives here, sparse is not, even
under -Wno-directive-within-macro[1], as would be seen under a C=1 build:

net/core/filter.c: note: in included file (through include/linux/netlink.h, include/linux/sock_diag.h):
./include/linux/skbuff.h:820:1: warning: directive in macro's argument list
./include/linux/skbuff.h:822:1: warning: directive in macro's argument list
./include/linux/skbuff.h:846:1: warning: directive in macro's argument list
./include/linux/skbuff.h:848:1: warning: directive in macro's argument list

Additionally remove empty macro argument definitions and usage.

"objdump -d" shows no object code differences.

[1] https://www.spinics.net/lists/linux-sparse/msg10857.html

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/skbuff.h | 36 +++++++++++++++++++-----------------
 net/core/filter.c      | 10 +++++-----
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 686a666d073d..0bce88ac799a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -792,7 +792,7 @@ struct sk_buff {
 #else
 #define CLONED_MASK	1
 #endif
-#define CLONED_OFFSET()		offsetof(struct sk_buff, __cloned_offset)
+#define CLONED_OFFSET		offsetof(struct sk_buff, __cloned_offset)
 
 	/* private: */
 	__u8			__cloned_offset[0];
@@ -815,18 +815,10 @@ struct sk_buff {
 	__u32			headers_start[0];
 	/* public: */
 
-/* if you move pkt_type around you also must adapt those constants */
-#ifdef __BIG_ENDIAN_BITFIELD
-#define PKT_TYPE_MAX	(7 << 5)
-#else
-#define PKT_TYPE_MAX	7
-#endif
-#define PKT_TYPE_OFFSET()	offsetof(struct sk_buff, __pkt_type_offset)
-
 	/* private: */
 	__u8			__pkt_type_offset[0];
 	/* public: */
-	__u8			pkt_type:3;
+	__u8			pkt_type:3; /* see PKT_TYPE_MAX */
 	__u8			ignore_df:1;
 	__u8			nf_trace:1;
 	__u8			ip_summed:2;
@@ -842,16 +834,10 @@ struct sk_buff {
 	__u8			encap_hdr_csum:1;
 	__u8			csum_valid:1;
 
-#ifdef __BIG_ENDIAN_BITFIELD
-#define PKT_VLAN_PRESENT_BIT	7
-#else
-#define PKT_VLAN_PRESENT_BIT	0
-#endif
-#define PKT_VLAN_PRESENT_OFFSET()	offsetof(struct sk_buff, __pkt_vlan_present_offset)
 	/* private: */
 	__u8			__pkt_vlan_present_offset[0];
 	/* public: */
-	__u8			vlan_present:1;
+	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
 	__u8			csum_not_inet:1;
@@ -950,6 +936,22 @@ struct sk_buff {
 #endif
 };
 
+/* if you move pkt_type around you also must adapt those constants */
+#ifdef __BIG_ENDIAN_BITFIELD
+#define PKT_TYPE_MAX	(7 << 5)
+#else
+#define PKT_TYPE_MAX	7
+#endif
+#define PKT_TYPE_OFFSET		offsetof(struct sk_buff, __pkt_type_offset)
+
+/* if you move pkt_vlan_present around you also must adapt these constants */
+#ifdef __BIG_ENDIAN_BITFIELD
+#define PKT_VLAN_PRESENT_BIT	7
+#else
+#define PKT_VLAN_PRESENT_BIT	0
+#endif
+#define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff, __pkt_vlan_present_offset)
+
 #ifdef __KERNEL__
 /*
  *	Handling routines are only of interest to the kernel
diff --git a/net/core/filter.c b/net/core/filter.c
index e471c9b09670..0bf912a44099 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -301,7 +301,7 @@ static u32 convert_skb_access(int skb_field, int dst_reg, int src_reg,
 		break;
 
 	case SKF_AD_PKTTYPE:
-		*insn++ = BPF_LDX_MEM(BPF_B, dst_reg, src_reg, PKT_TYPE_OFFSET());
+		*insn++ = BPF_LDX_MEM(BPF_B, dst_reg, src_reg, PKT_TYPE_OFFSET);
 		*insn++ = BPF_ALU32_IMM(BPF_AND, dst_reg, PKT_TYPE_MAX);
 #ifdef __BIG_ENDIAN_BITFIELD
 		*insn++ = BPF_ALU32_IMM(BPF_RSH, dst_reg, 5);
@@ -323,7 +323,7 @@ static u32 convert_skb_access(int skb_field, int dst_reg, int src_reg,
 				      offsetof(struct sk_buff, vlan_tci));
 		break;
 	case SKF_AD_VLAN_TAG_PRESENT:
-		*insn++ = BPF_LDX_MEM(BPF_B, dst_reg, src_reg, PKT_VLAN_PRESENT_OFFSET());
+		*insn++ = BPF_LDX_MEM(BPF_B, dst_reg, src_reg, PKT_VLAN_PRESENT_OFFSET);
 		if (PKT_VLAN_PRESENT_BIT)
 			*insn++ = BPF_ALU32_IMM(BPF_RSH, dst_reg, PKT_VLAN_PRESENT_BIT);
 		if (PKT_VLAN_PRESENT_BIT < 7)
@@ -8027,7 +8027,7 @@ static int bpf_unclone_prologue(struct bpf_insn *insn_buf, bool direct_write,
 	 * (Fast-path, otherwise approximation that we might be
 	 *  a clone, do the rest in helper.)
 	 */
-	*insn++ = BPF_LDX_MEM(BPF_B, BPF_REG_6, BPF_REG_1, CLONED_OFFSET());
+	*insn++ = BPF_LDX_MEM(BPF_B, BPF_REG_6, BPF_REG_1, CLONED_OFFSET);
 	*insn++ = BPF_ALU32_IMM(BPF_AND, BPF_REG_6, CLONED_MASK);
 	*insn++ = BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 7);
 
@@ -8615,7 +8615,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct __sk_buff, pkt_type):
 		*target_size = 1;
 		*insn++ = BPF_LDX_MEM(BPF_B, si->dst_reg, si->src_reg,
-				      PKT_TYPE_OFFSET());
+				      PKT_TYPE_OFFSET);
 		*insn++ = BPF_ALU32_IMM(BPF_AND, si->dst_reg, PKT_TYPE_MAX);
 #ifdef __BIG_ENDIAN_BITFIELD
 		*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg, 5);
@@ -8640,7 +8640,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct __sk_buff, vlan_present):
 		*target_size = 1;
 		*insn++ = BPF_LDX_MEM(BPF_B, si->dst_reg, si->src_reg,
-				      PKT_VLAN_PRESENT_OFFSET());
+				      PKT_VLAN_PRESENT_OFFSET);
 		if (PKT_VLAN_PRESENT_BIT)
 			*insn++ = BPF_ALU32_IMM(BPF_RSH, si->dst_reg, PKT_VLAN_PRESENT_BIT);
 		if (PKT_VLAN_PRESENT_BIT < 7)
-- 
2.30.2

