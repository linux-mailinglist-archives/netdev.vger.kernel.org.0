Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D255EE59
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiF1TwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiF1Tuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17655223;
        Tue, 28 Jun 2022 12:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445774; x=1687981774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NHfK9H6RSRv2T0ejOH0djO6jg9We4wQHQ8pCfIZVGsQ=;
  b=lQQybeuzYeIdKVoitwuoX+OTzSkc8kyMsRZP1B2C7LF/Fxu3af3JsQyh
   OvQd+CsmdxTB2ALPlHvUFG94OrpzcylhHrlHWIGJC6aGs5ZrfEBeeYuAj
   OaPy+wfuWlX8lpru+GK0UalDJIdP16idEIJjuR1oGLzFe9NBslEAmqEQU
   e5Cj7s07tySYz9QKwl4A5TcgsImQVL+9+G4I5J1o05z0Rg/QGiIDcndBR
   HWD/Va2Ia9sAxoGcDQCS7+t705EPJnbXTYJvaLr6QxZunr8HGSLqwqq5i
   YIIyCvM+V21WdLT44TRB+t9C9aAjNy1HSMfdDUP9aj8f/DQX5YCgH309h
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523285"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523285"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="565181272"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2022 12:49:29 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9P022013;
        Tue, 28 Jun 2022 20:49:27 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 25/52] net, xdp: add basic generic metadata accessors
Date:   Tue, 28 Jun 2022 21:47:45 +0200
Message-Id: <20220628194812.1453059-26-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As all of the fields in the generic XDP metadata structure have
explicit Endianness, it's worth to provide some basic helpers.
Add get and set accessors for each field and get, set and rep
accessors for each bitfield of ::{rx,tx}_flags. rep are for the
cases when it's unknown whether a flags field is clear, so they
effectively replace the value in a bitfield instead of just ORing.
Also add a couple of helpers: to get a pointer to the generic
metadata structure and check whether a given metadata is generic
compatible.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/xdp_meta.h | 238 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/include/net/xdp_meta.h b/include/net/xdp_meta.h
index 3a40189d71c6..f61831e39eb0 100644
--- a/include/net/xdp_meta.h
+++ b/include/net/xdp_meta.h
@@ -4,6 +4,7 @@
 #ifndef __LINUX_NET_XDP_META_H__
 #define __LINUX_NET_XDP_META_H__
 
+#include <linux/bitfield.h>
 #include <net/xdp.h>
 #include <uapi/linux/bpf.h>
 
@@ -45,4 +46,241 @@ static inline bool xdp_metalen_invalid(unsigned long metalen)
 	return (metalen & (sizeof(u32) - 1)) || metalen > max;
 }
 
+/* This builds _get(), _set() and _rep() for each bitfield.
+ * If you know for sure the field is empty (e.g. you zeroed the struct
+ * previously), use faster _set() op to save several cycles, otherwise
+ * use _rep() to avoid mixing values.
+ */
+#define XDP_META_BUILD_FLAGS_ACC(dir, pfx, FLD)				     \
+static inline u32							     \
+xdp_meta_##dir##_##pfx##_get(const struct xdp_meta_generic *md)		     \
+{									     \
+	static_assert(__same_type(md->dir##_flags, __le32));		     \
+									     \
+	return le32_get_bits(md->dir##_flags, XDP_META_##FLD);		     \
+}									     \
+									     \
+static inline void							     \
+xdp_meta_##dir##_##pfx##_set(struct xdp_meta_generic *md, u32 val)	     \
+{									     \
+	md->dir##_flags |= le32_encode_bits(val, XDP_META_##FLD);	     \
+}									     \
+									     \
+static inline void							     \
+xdp_meta_##dir##_##pfx##_rep(struct xdp_meta_generic *md, u32 val)	     \
+{									     \
+	le32p_replace_bits(&md->dir##_flags, val, XDP_META_##FLD);	     \
+}									     \
+
+/* This builds _get() and _set() for each structure field -- those are just
+ * byteswap operations however.
+ * The second static assertion is due to that all of the fields in the
+ * structure should be naturally-aligned when ::magic_id starts at
+ * `XDP_PACKET_HEADROOM + 8n`, which is the default and recommended case.
+ * This check makes no sense for the efficient unaligned access platforms,
+ * but helps the rest.
+ */
+#define XDP_META_BUILD_ACC(dir, pfx, sz)				     \
+static inline u##sz							     \
+xdp_meta_##dir##_##pfx##_get(const struct xdp_meta_generic *md)		     \
+{									     \
+	static_assert(__same_type(md->dir##_##pfx, __le##sz));		     \
+									     \
+	return le##sz##_to_cpu(md->dir##_##pfx);			     \
+}									     \
+									     \
+static inline void							     \
+xdp_meta_##dir##_##pfx##_set(struct xdp_meta_generic *md, u##sz val)	     \
+{									     \
+	static_assert((XDP_PACKET_HEADROOM - sizeof(*md) +		     \
+		       sizeof_field(typeof(*md), magic_id) +		     \
+		       offsetof(typeof(*md), dir##_##pfx)) %		     \
+		      sizeof_field(typeof(*md), dir##_##pfx) == 0);	     \
+									     \
+	md->dir##_##pfx = cpu_to_le##sz(val);				     \
+}
+
+#if 0 /* For grepping/indexers */
+u16 xdp_meta_tx_csum_action_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_csum_action_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_tx_csum_action_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_tx_vlan_type_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_vlan_type_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_tx_vlan_type_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_tx_tstamp_action_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_tstamp_action_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_tx_tstamp_action_rep(struct xdp_meta_generic *md, u16 val);
+#endif
+XDP_META_BUILD_FLAGS_ACC(tx, csum_action, TX_CSUM_ACT);
+XDP_META_BUILD_FLAGS_ACC(tx, vlan_type, TX_VLAN_TYPE);
+XDP_META_BUILD_FLAGS_ACC(tx, tstamp_action, TX_TSTAMP_ACT);
+
+#if 0
+u16 xdp_meta_tx_csum_start_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_csum_start_set(struct xdp_meta_generic *md, u64 val);
+u16 xdp_meta_tx_csum_off_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_csum_off_set(struct xdp_meta_generic *md, u64 val);
+u16 xdp_meta_tx_vid_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_vid_set(struct xdp_meta_generic *md, u64 val);
+u32 xdp_meta_tx_flags_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_flags_set(struct xdp_meta_generic *md, u32 val);
+u64 xdp_meta_tx_tstamp_get(const struct xdp_meta_generic *md);
+void xdp_meta_tx_tstamp_set(struct xdp_meta_generic *md, u64 val);
+#endif
+XDP_META_BUILD_ACC(tx, csum_start, 16);
+XDP_META_BUILD_ACC(tx, csum_off, 16);
+XDP_META_BUILD_ACC(tx, vid, 16);
+XDP_META_BUILD_ACC(tx, flags, 32);
+XDP_META_BUILD_ACC(tx, tstamp, 64);
+
+#if 0
+u16 xdp_meta_rx_csum_status_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_csum_status_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_rx_csum_status_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_rx_csum_level_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_csum_level_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_rx_csum_level_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_rx_hash_type_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_hash_type_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_rx_hash_type_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_rx_vlan_type_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_vlan_type_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_rx_vlan_type_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_rx_tstamp_present_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_tstamp_present_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_rx_tstamp_present_rep(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_rx_qid_present_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_qid_present_set(struct xdp_meta_generic *md, u16 val);
+void xdp_meta_rx_qid_present_rep(struct xdp_meta_generic *md, u16 val);
+#endif
+XDP_META_BUILD_FLAGS_ACC(rx, csum_status, RX_CSUM_STATUS);
+XDP_META_BUILD_FLAGS_ACC(rx, csum_level, RX_CSUM_LEVEL);
+XDP_META_BUILD_FLAGS_ACC(rx, hash_type, RX_HASH_TYPE);
+XDP_META_BUILD_FLAGS_ACC(rx, vlan_type, RX_VLAN_TYPE);
+XDP_META_BUILD_FLAGS_ACC(rx, tstamp_present, RX_TSTAMP_PRESENT);
+XDP_META_BUILD_FLAGS_ACC(rx, qid_present, RX_QID_PRESENT);
+
+#if 0
+u64 xdp_meta_rx_tstamp_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_tstamp_set(struct xdp_meta_generic *md, u64 val);
+u32 xdp_meta_rx_hash_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_hash_set(struct xdp_meta_generic *md, u32 val);
+u32 xdp_meta_rx_csum_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_csum_set(struct xdp_meta_generic *md, u32 val);
+u16 xdp_meta_rx_vid_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_vid_set(struct xdp_meta_generic *md, u16 val);
+u16 xdp_meta_rx_qid_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_qid_set(struct xdp_meta_generic *md, u16 val);
+u32 xdp_meta_rx_flags_get(const struct xdp_meta_generic *md);
+void xdp_meta_rx_flags_set(struct xdp_meta_generic *md, u32 val);
+#endif
+XDP_META_BUILD_ACC(rx, tstamp, 64);
+XDP_META_BUILD_ACC(rx, hash, 32);
+XDP_META_BUILD_ACC(rx, csum, 32);
+XDP_META_BUILD_ACC(rx, vid, 16);
+XDP_META_BUILD_ACC(rx, qid, 16);
+XDP_META_BUILD_ACC(rx, flags, 32);
+
+#if 0
+u32 xdp_meta_btf_id_get(const struct xdp_meta_generic *md);
+void xdp_meta_btf_id_set(struct xdp_meta_generic *md, u32 val);
+u32 xdp_meta_type_id_get(const struct xdp_meta_generic *md);
+void xdp_meta_type_id_set(struct xdp_meta_generic *md, u32 val);
+u64 xdp_meta_full_id_get(const struct xdp_meta_generic *md);
+void xdp_meta_full_id_set(struct xdp_meta_generic *md, u64 val);
+u16 xdp_meta_magic_id_get(const struct xdp_meta_generic *md);
+void xdp_meta_magic_id_set(struct xdp_meta_generic *md, u16 val);
+#endif
+XDP_META_BUILD_ACC(btf, id, 32);
+XDP_META_BUILD_ACC(type, id, 32);
+XDP_META_BUILD_ACC(full, id, 64);
+XDP_META_BUILD_ACC(magic, id, 16);
+
+/* This allows to jump from xdp_metadata_generic::{tx,rx_full,rx,id} to the
+ * parent if needed. For example, declare one of them on stack for convenience
+ * and still pass a generic pointer.
+ * No out-of-bound checks, a caller must sanitize it on its side.
+ */
+#define _to_gen_md(ptr, locptr, locmd) ({				      \
+	struct xdp_meta_generic *locmd;					      \
+	typeof(ptr) locptr = (ptr);					      \
+									      \
+	if (__same_type(*locptr, typeof(locmd->tx)))			      \
+		locmd = (void *)locptr - offsetof(typeof(*locmd), tx);	      \
+	else if (__same_type(*locptr, typeof(locmd->rx_full)))		      \
+		locmd = (void *)locptr - offsetof(typeof(*locmd), rx_full);   \
+	else if (__same_type(*locptr, typeof(locmd->rx)))		      \
+		locmd = (void *)locptr - offsetof(typeof(*locmd), rx);	      \
+	else if (__same_type(*locptr, typeof(locmd->id)))		      \
+		locmd = (void *)locptr - offsetof(typeof(*locmd), id);	      \
+	else if (__same_type(*locptr, typeof(locmd)) ||			      \
+		 __same_type(*locptr, void))				      \
+		locmd = (void *)locptr;					      \
+	else								      \
+		BUILD_BUG();						      \
+									      \
+	locmd;								      \
+})
+#define to_gen_md(ptr)	_to_gen_md((ptr), __UNIQUE_ID(ptr_), __UNIQUE_ID(md_))
+
+/* This allows to pass an xdp_meta_generic pointer instead of an
+ * xdp_meta_generic::rx{,_full} pointer for convenience.
+ */
+#define _to_rx_md(ptr, locptr, locmd) ({				      \
+	struct xdp_meta_generic_rx *locmd;				      \
+	typeof(ptr) locptr = (ptr);					      \
+									      \
+	if (__same_type(*locptr, struct xdp_meta_generic_rx))		      \
+		locmd = (struct xdp_meta_generic_rx *)locptr;		      \
+	else if (__same_type(*locptr, struct xdp_meta_generic) ||	      \
+		 __same_type(*locptr, void))				      \
+		locmd = &((struct xdp_meta_generic *)locptr)->rx_full;	      \
+	else								      \
+		BUILD_BUG();						      \
+									      \
+	locmd;								      \
+})
+#define to_rx_md(ptr)	_to_rx_md((ptr), __UNIQUE_ID(ptr_), __UNIQUE_ID(md_))
+
+/**
+ * xdp_meta_has_generic - get a pointer to the generic metadata before a frame
+ * @data: a pointer to the beginning of the frame
+ *
+ * Note: the function does not perform any access sanity checks, they should
+ * be done manually prior to calling it.
+ *
+ * Returns a pointer to the beginning of the generic metadata.
+ */
+static inline struct xdp_meta_generic *xdp_meta_generic_ptr(const void *data)
+{
+	BUILD_BUG_ON(xdp_metalen_invalid(sizeof(struct xdp_meta_generic)));
+
+	return (void *)data - sizeof(struct xdp_meta_generic);
+}
+
+/**
+ * xdp_meta_has_generic - check whether a frame has a generic meta in front
+ * @data: a pointer to the beginning of the frame
+ *
+ * Returns true if it does, false otherwise.
+ */
+static inline bool xdp_meta_has_generic(const void *data)
+{
+	return xdp_meta_generic_ptr(data)->magic_id ==
+	       cpu_to_le16(XDP_META_GENERIC_MAGIC);
+}
+
+/**
+ * xdp_meta_skb_has_generic - check whether an skb has a generic meta
+ * @skb: a pointer to the &sk_buff
+ *
+ * Note: must be called only when skb_mac_header_was_set(skb) == true.
+ *
+ * Returns true if it does, false otherwise.
+ */
+static inline bool xdp_meta_skb_has_generic(const struct sk_buff *skb)
+{
+	return xdp_meta_has_generic(skb_metadata_end(skb));
+}
+
 #endif /* __LINUX_NET_XDP_META_H__ */
-- 
2.36.1

