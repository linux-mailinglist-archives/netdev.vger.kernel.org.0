Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0B7397C54
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhFAWUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbhFAWUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:20:30 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B53FC061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 15:18:48 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id v8so490025qkv.1
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 15:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TI12Da2DK+F/H4zU+J2oYauCoENzMsqXu3l0ONH7SSo=;
        b=lz5E5Yv7DP7PJrBQJaKUhcBQkjcxZBIr3Vw8ELe+ODYOahqkJemMAotkq+WhXpeCXS
         oJO/d6hRVpLXaPnojGSsk/DQxXSH+QcVwsoMogeMRMlYgPFp/BuXQXtWEjmXdOsyZmar
         GEFnywDPDSoC9upvQvW5wi00KcKAEZrz4qaCITz+mzVziShnIfEYadPReyc8WMu9lQra
         X0k3wwz+449x0o2GMQ8TnfDeuQhbADlwCjGMFItxCKBB2euaRy/odasCU+gPtm5NXUvM
         cHRh6g44CW+XO9vhUr0/cBKjDK1iWTRhXVm14LBNqxBv2CuOW+8ZKPcPs+kP3YntzVcz
         +wpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TI12Da2DK+F/H4zU+J2oYauCoENzMsqXu3l0ONH7SSo=;
        b=fBOsidpElwKoc79tf8HcNJNExhczdb+ZP4sofjTYVb+ZxxTEgScTw4Xt6pusSXyE/C
         lI7CesyW9fYzVL6U1b/dbckXFXO526b4mPdjIe91rGFYjxk+IuZfo1eZmoscenR9KGZN
         lh5MhL+2giWBqE2MW7jh8vcW+Lh1eeso+5FzgYi6d/B/IdaX38AqiEtdV4OaSShor1vV
         ROFSdovgadEYmZBpSap67YsPx7e5kQPjKUosL+KqXRz1ucEDvK3gpcdicVUootBjCn/3
         9V1PmefdaENN3fobllfqi4Wi7FnIZwB9jnPOCfgjqnRaN5dpUHxwPVoTjcbj5gLa5W0s
         vdxg==
X-Gm-Message-State: AOAM530Bdv1VJdwJCR2YEO5nQj3ElNzEpvLMgxjLLx9rptR9iLcp+Pfc
        Llgz4sahtmVAkptUUqcPMV+x+0mLTHT2sQ==
X-Google-Smtp-Source: ABdhPJzjlTR8lcjr9YbsMUIfi3jhrVKM3LT9dp8YTXQ4FnmJ4VjlvlhrEicTjyWdhCF2t/bUxLtu+g==
X-Received: by 2002:a05:620a:70e:: with SMTP id 14mr6070208qkc.85.1622585927370;
        Tue, 01 Jun 2021 15:18:47 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:56ea:5ee7:bba5:d755])
        by smtp.gmail.com with ESMTPSA id n25sm1279282qtr.8.2021.06.01.15.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 15:18:47 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v3 1/3] net: flow_dissector: extend bpf flow dissector support with vnet hdr
Date:   Tue,  1 Jun 2021 18:18:38 -0400
Message-Id: <20210601221841.1251830-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
In-Reply-To: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Amend the bpf flow dissector program type to accept virtio_net_hdr
members. Do this to enable bpf flow dissector programs to perform
virtio-net header validation. The next patch in this series will add
a flow dissection hook in virtio_net_hdr_to_skb and make use of this
extended functionality. That commit message has more background on the
use case.

Signed-off-by: Tanner Love <tannerlove@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Petar Penkov <ppenkov@google.com>
---
 drivers/net/bonding/bond_main.c |  2 +-
 include/linux/skbuff.h          | 26 ++++++++++++----
 include/net/flow_dissector.h    |  6 ++++
 include/uapi/linux/bpf.h        |  6 ++++
 net/core/filter.c               | 55 +++++++++++++++++++++++++++++++++
 net/core/flow_dissector.c       | 24 ++++++++++++--
 tools/include/uapi/linux/bpf.h  |  6 ++++
 7 files changed, 116 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7e469c203ca5..5d2d7d5c5704 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3554,7 +3554,7 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 	case BOND_XMIT_POLICY_ENCAP34:
 		memset(fk, 0, sizeof(*fk));
 		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
-					  fk, NULL, 0, 0, 0, 0);
+					  fk, NULL, 0, 0, 0, 0, NULL);
 	default:
 		break;
 	}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..fef8f4b5db6e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1312,18 +1312,20 @@ struct bpf_flow_dissector;
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 		      __be16 proto, int nhoff, int hlen, unsigned int flags);
 
+struct virtio_net_hdr;
 bool __skb_flow_dissect(const struct net *net,
 			const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
 			void *target_container, const void *data,
-			__be16 proto, int nhoff, int hlen, unsigned int flags);
+			__be16 proto, int nhoff, int hlen, unsigned int flags,
+			const struct virtio_net_hdr *vhdr);
 
 static inline bool skb_flow_dissect(const struct sk_buff *skb,
 				    struct flow_dissector *flow_dissector,
 				    void *target_container, unsigned int flags)
 {
 	return __skb_flow_dissect(NULL, skb, flow_dissector,
-				  target_container, NULL, 0, 0, 0, flags);
+				  target_container, NULL, 0, 0, 0, flags, NULL);
 }
 
 static inline bool skb_flow_dissect_flow_keys(const struct sk_buff *skb,
@@ -1332,7 +1334,20 @@ static inline bool skb_flow_dissect_flow_keys(const struct sk_buff *skb,
 {
 	memset(flow, 0, sizeof(*flow));
 	return __skb_flow_dissect(NULL, skb, &flow_keys_dissector,
-				  flow, NULL, 0, 0, 0, flags);
+				  flow, NULL, 0, 0, 0, flags, NULL);
+}
+
+static inline bool
+__skb_flow_dissect_flow_keys_basic(const struct net *net,
+				   const struct sk_buff *skb,
+				   struct flow_keys_basic *flow,
+				   const void *data, __be16 proto,
+				   int nhoff, int hlen, unsigned int flags,
+				   const struct virtio_net_hdr *vhdr)
+{
+	memset(flow, 0, sizeof(*flow));
+	return __skb_flow_dissect(net, skb, &flow_keys_basic_dissector, flow,
+				  data, proto, nhoff, hlen, flags, vhdr);
 }
 
 static inline bool
@@ -1342,9 +1357,8 @@ skb_flow_dissect_flow_keys_basic(const struct net *net,
 				 const void *data, __be16 proto,
 				 int nhoff, int hlen, unsigned int flags)
 {
-	memset(flow, 0, sizeof(*flow));
-	return __skb_flow_dissect(net, skb, &flow_keys_basic_dissector, flow,
-				  data, proto, nhoff, hlen, flags);
+	return __skb_flow_dissect_flow_keys_basic(net, skb, flow, data, proto,
+						  nhoff, hlen, flags, NULL);
 }
 
 void skb_flow_dissect_meta(const struct sk_buff *skb,
diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ffd386ea0dbb..0796ad745e69 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -370,6 +370,12 @@ struct bpf_flow_dissector {
 	const struct sk_buff	*skb;
 	const void		*data;
 	const void		*data_end;
+	__u8			vhdr_flags;
+	__u8			vhdr_gso_type;
+	__u16			vhdr_hdr_len;
+	__u16			vhdr_gso_size;
+	__u16			vhdr_csum_start;
+	__u16			vhdr_csum_offset;
 };
 
 static inline void
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 418b9b813d65..de525defd462 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5155,6 +5155,12 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
+	__u8  vhdr_flags;
+	__u8  vhdr_gso_type;
+	__u16 vhdr_hdr_len;
+	__u16 vhdr_gso_size;
+	__u16 vhdr_csum_start;
+	__u16 vhdr_csum_offset;
 };
 
 struct bpf_tunnel_key {
diff --git a/net/core/filter.c b/net/core/filter.c
index 239de1306de9..af45e769ced6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8358,6 +8358,16 @@ static bool flow_dissector_is_valid_access(int off, int size,
 			return false;
 		info->reg_type = PTR_TO_FLOW_KEYS;
 		return true;
+	case bpf_ctx_range(struct __sk_buff, len):
+		return size == size_default;
+	case bpf_ctx_range(struct __sk_buff, vhdr_flags):
+	case bpf_ctx_range(struct __sk_buff, vhdr_gso_type):
+		return size == sizeof(__u8);
+	case bpf_ctx_range(struct __sk_buff, vhdr_hdr_len):
+	case bpf_ctx_range(struct __sk_buff, vhdr_gso_size):
+	case bpf_ctx_range(struct __sk_buff, vhdr_csum_start):
+	case bpf_ctx_range(struct __sk_buff, vhdr_csum_offset):
+		return size == sizeof(__u16);
 	default:
 		return false;
 	}
@@ -8390,6 +8400,51 @@ static u32 flow_dissector_convert_ctx_access(enum bpf_access_type type,
 				      si->dst_reg, si->src_reg,
 				      offsetof(struct bpf_flow_dissector, flow_keys));
 		break;
+
+	case offsetof(struct __sk_buff, vhdr_flags):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, vhdr_flags),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, vhdr_flags));
+		break;
+
+	case offsetof(struct __sk_buff, vhdr_gso_type):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, vhdr_gso_type),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, vhdr_gso_type));
+		break;
+
+	case offsetof(struct __sk_buff, vhdr_hdr_len):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, vhdr_hdr_len),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, vhdr_hdr_len));
+		break;
+
+	case offsetof(struct __sk_buff, vhdr_gso_size):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, vhdr_gso_size),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, vhdr_gso_size));
+		break;
+
+	case offsetof(struct __sk_buff, vhdr_csum_start):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, vhdr_csum_start),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, vhdr_csum_start));
+		break;
+
+	case offsetof(struct __sk_buff, vhdr_csum_offset):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, vhdr_csum_offset),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, vhdr_csum_offset));
+		break;
+
+	case offsetof(struct __sk_buff, len):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_flow_dissector, skb),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_flow_dissector, skb));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct sk_buff, len));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3ed7c98a98e1..4b171ebec084 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -28,6 +28,7 @@
 #include <scsi/fc/fc_fcoe.h>
 #include <uapi/linux/batadv_packet.h>
 #include <linux/bpf.h>
+#include <linux/virtio_net.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_labels.h>
@@ -904,6 +905,7 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
  * @hlen: packet header length, if @data is NULL use skb_headlen(skb)
  * @flags: flags that control the dissection process, e.g.
  *         FLOW_DISSECTOR_F_STOP_AT_ENCAP.
+ * @vhdr: virtio_net_header to include in kernel context for BPF flow dissector
  *
  * The function will try to retrieve individual keys into target specified
  * by flow_dissector from either the skbuff or a raw buffer specified by the
@@ -915,7 +917,8 @@ bool __skb_flow_dissect(const struct net *net,
 			const struct sk_buff *skb,
 			struct flow_dissector *flow_dissector,
 			void *target_container, const void *data,
-			__be16 proto, int nhoff, int hlen, unsigned int flags)
+			__be16 proto, int nhoff, int hlen, unsigned int flags,
+			const struct virtio_net_hdr *vhdr)
 {
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
@@ -1001,6 +1004,23 @@ bool __skb_flow_dissect(const struct net *net,
 			__be16 n_proto = proto;
 			struct bpf_prog *prog;
 
+			if (vhdr) {
+				ctx.vhdr_flags = vhdr->flags;
+				ctx.vhdr_gso_type = vhdr->gso_type;
+				ctx.vhdr_hdr_len =
+					__virtio16_to_cpu(virtio_legacy_is_little_endian(),
+							  vhdr->hdr_len);
+				ctx.vhdr_gso_size =
+					__virtio16_to_cpu(virtio_legacy_is_little_endian(),
+							  vhdr->gso_size);
+				ctx.vhdr_csum_start =
+					__virtio16_to_cpu(virtio_legacy_is_little_endian(),
+							  vhdr->csum_start);
+				ctx.vhdr_csum_offset =
+					__virtio16_to_cpu(virtio_legacy_is_little_endian(),
+							  vhdr->csum_offset);
+			}
+
 			if (skb) {
 				ctx.skb = skb;
 				/* we can't use 'proto' in the skb case
@@ -1610,7 +1630,7 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
 	memset(&keys, 0, sizeof(keys));
 	__skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
 			   &keys, NULL, 0, 0, 0,
-			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL, NULL);
 
 	return __flow_hash_from_keys(&keys, &hashrnd);
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 418b9b813d65..de525defd462 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5155,6 +5155,12 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
+	__u8  vhdr_flags;
+	__u8  vhdr_gso_type;
+	__u16 vhdr_hdr_len;
+	__u16 vhdr_gso_size;
+	__u16 vhdr_csum_start;
+	__u16 vhdr_csum_offset;
 };
 
 struct bpf_tunnel_key {
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

