Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D748393B5E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhE1C3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbhE1C3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 22:29:45 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B7BC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 19:28:10 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id h21so1751474qtu.5
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 19:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TI12Da2DK+F/H4zU+J2oYauCoENzMsqXu3l0ONH7SSo=;
        b=Myzf1oVgCHvX+17QqOND/OeBy/Lvdl81F9OWGE1LZXHUshFW8L2x2e7T6cRffZp+PU
         UBgX6MQgKNU78P/qLJ2EdUSB7BzmRQ4gLRZe9qBr2pa2OE6N2fkFA6jK0anyIeMz4e9d
         ds1WMRFgxRq/3fEhpVQc/rS/j8UY0eyVtJJutqbU9vUQ7P4uWbk7/09jnKIDOmUlLpj4
         TW92BKmzRZsBqz9FsgyqS0i6+E5m/DPZfOsN4UAFbwxg2+ulylM2Hf/3rIjJuYyiI5cE
         60Za4kj6WpiGVhrDqPyEFGLSBm6kux+XgGujOZM497dx3lMfJoyKyZW2JbAvNdfQSlnD
         C8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TI12Da2DK+F/H4zU+J2oYauCoENzMsqXu3l0ONH7SSo=;
        b=Xl6ZdA0rn4fpFkoiYyJQtxBK6OUmWExq6xStp/7yckUtx4z15b6m8SReC4THhOQQw/
         NCpSFG6IIQ4sOGIaB+baRpM+k3TVpiKlsmZ9mQWtlYHEFsz85ParqLSs0cLYk5qm0MjQ
         sjrxiI9exEo/5qDF9dOdZo3TthiG0gihTxhrCN15d8a7hAmfrDl4bPZeFx2eOXgdRg+R
         KSRbDJ2J8fj8S7j4h8vEfVGyJ6jUpF8Rhbgx9/uY56xm1Scq7RFfd0SYoF08mDN6iCpU
         LmjUWT1NJHoqEyoUEd690jLyVTHi2pFkChhbycHiA+VB35K/LmgVaO+KD+8OqAvxMfJd
         4QYQ==
X-Gm-Message-State: AOAM5326/pC3e8mQLP9Dg0ILpJ57PL3a/YcWk/rRSVvSBL6EmDcYEVyT
        MLifkm9LVZTmry/BPpUiEL2vxP27BWQ=
X-Google-Smtp-Source: ABdhPJwMJcysFvFg+pxBYDT0U3VF++BfdvsIwAwTVv8h3FKfAgl7+uADP0/GqxySZV8yC9TV+ypVpQ==
X-Received: by 2002:ac8:5a44:: with SMTP id o4mr1426338qta.189.1622168889776;
        Thu, 27 May 2021 19:28:09 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:2437:9aae:c493:2542])
        by smtp.gmail.com with ESMTPSA id a14sm2488071qtj.57.2021.05.27.19.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 19:28:09 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v2 1/3] net: flow_dissector: extend bpf flow dissector support with vnet hdr
Date:   Thu, 27 May 2021 22:28:01 -0400
Message-Id: <20210528022803.778578-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
In-Reply-To: <20210528022803.778578-1-tannerlove.kernel@gmail.com>
References: <20210528022803.778578-1-tannerlove.kernel@gmail.com>
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

