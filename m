Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0055EEC4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiF1TxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiF1Tuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACFB24F00;
        Tue, 28 Jun 2022 12:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445776; x=1687981776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m0oceUhK3hnv1otJUNLutQy3sAaI+qAGxK7L6haMKZI=;
  b=nSIsnJphcuhXLkcH2HfNfEeKyPh9oDKz9JmT3EYe1Ncxklz0Kvm+eG5w
   KBpCSh/sNjru5IlS81X7ucX5un6NDcz/aIAj3LqXW/WOE+27xnyAvSdH+
   EurClCLaeiPmXOLpVS65F4W9EsfAVZonGkCnARThmJWF2ac9vHss7j9jz
   9Gwoxn+Ofx3/PAo1DZRCAbTebS2jtp5jsvb+35GJ5QRXlxtL9GVrvxMOL
   wIAlg37VyPWp0DCk+WMqEw2ID6SHc9a/YJSNTf7mfG5/fAPLRY+f2ROv5
   zisx5hV8pzhm+aHfYk1bG29Ecc3/cmvccZ8j/lg50jYxoIxyd3Yn1YOXA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="264874164"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="264874164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="623054140"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 28 Jun 2022 12:49:31 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9R022013;
        Tue, 28 Jun 2022 20:49:30 +0100
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
Subject: [PATCH RFC bpf-next 27/52] net, xdp: add &sk_buff <-> &xdp_meta_generic converters
Date:   Tue, 28 Jun 2022 21:47:47 +0200
Message-Id: <20220628194812.1453059-28-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two functions (with their underscored versions) to pass
HW-origined info (checksums, hashes, Rx queue ID etc.) from an skb
to an XDP generic metadata and vice versa. They can be used to carry
that info between hardware, xdp_buff/xdp_frame and sk_buff.
The &sk_buff -> &xdp_meta_generic converter uses a static,
init-time filled &xdp_meta_tail to not query BTF info on hotpath.
For the fields which values are being assigned directly, make sure
they match with the help of static asserts.
Also add a wrapper bpf_match_type_btf_id() designed especially for
drivers and taking care of corner-cases.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/net/xdp_meta.h | 112 +++++++++++++++++++++++++++++++
 net/bpf/core.c         | 148 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 259 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp_meta.h b/include/net/xdp_meta.h
index f61831e39eb0..d37ea873a6a8 100644
--- a/include/net/xdp_meta.h
+++ b/include/net/xdp_meta.h
@@ -46,6 +46,17 @@ static inline bool xdp_metalen_invalid(unsigned long metalen)
 	return (metalen & (sizeof(u32) - 1)) || metalen > max;
 }
 
+/* We use direct assignments from &xdp_meta_generic to &sk_buff fields,
+ * thus they must match.
+ */
+static_assert((u32)XDP_META_RX_CSUM_NONE == (u32)CHECKSUM_NONE);
+static_assert((u32)XDP_META_RX_CSUM_OK == (u32)CHECKSUM_UNNECESSARY);
+static_assert((u32)XDP_META_RX_CSUM_COMP == (u32)CHECKSUM_COMPLETE);
+static_assert((u32)XDP_META_RX_HASH_NONE == (u32)PKT_HASH_TYPE_NONE);
+static_assert((u32)XDP_META_RX_HASH_L2 == (u32)PKT_HASH_TYPE_L2);
+static_assert((u32)XDP_META_RX_HASH_L3 == (u32)PKT_HASH_TYPE_L3);
+static_assert((u32)XDP_META_RX_HASH_L4 == (u32)PKT_HASH_TYPE_L4);
+
 /* This builds _get(), _set() and _rep() for each bitfield.
  * If you know for sure the field is empty (e.g. you zeroed the struct
  * previously), use faster _set() op to save several cycles, otherwise
@@ -283,4 +294,105 @@ static inline bool xdp_meta_skb_has_generic(const struct sk_buff *skb)
 	return xdp_meta_has_generic(skb_metadata_end(skb));
 }
 
+/**
+ * xdp_meta_init - initialize a metadata structure
+ * @md: pointer to xdp_meta_generic or its ::rx_full or its ::id member
+ * @id: full BTF + type ID for the metadata type (can be u* or __le64)
+ *
+ * Zeroes the passed metadata struct (or part) and initializes its tail, so
+ * it becomes ready for further processing. If a driver is responsible for
+ * composing metadata, it is important to zero the space it occupies in each
+ * Rx buffer as `xdp->data - xdp->data_hard_start` doesn't get initialized
+ * by default.
+ */
+#define _xdp_meta_init(md, id, locmd, locid) ({				      \
+	typeof(md) locmd = (md);					      \
+	typeof(id) locid = (id);					      \
+									      \
+	if (offsetof(typeof(*locmd), full_id))				      \
+		memset(locmd, 0, offsetof(typeof(*locmd), full_id));	      \
+									      \
+	locmd->full_id = __same_type(locid, __le64) ? (__force __le64)locid : \
+			 cpu_to_le64((__force u64)locid);		      \
+	locmd->magic_id = cpu_to_le16(XDP_META_GENERIC_MAGIC);		      \
+})
+#define xdp_meta_init(md, id)						      \
+	_xdp_meta_init((md), (id), __UNIQUE_ID(md_), __UNIQUE_ID(id_))
+
+void ___xdp_build_meta_generic_from_skb(struct xdp_meta_generic_rx *rx_md,
+					const struct sk_buff *skb);
+void ___xdp_populate_skb_meta_generic(struct sk_buff *skb,
+				      const struct xdp_meta_generic_rx *rx_md);
+
+#define _xdp_build_meta_generic_from_skb(md, skb, locmd) ({		      \
+	typeof(md) locmd = (md);					      \
+									      \
+	if (offsetof(typeof(*locmd), rx))				      \
+		memset(locmd, 0, offsetof(typeof(*locmd), rx));		      \
+									      \
+	___xdp_build_meta_generic_from_skb(to_rx_md(locmd), skb);	      \
+})
+#define __xdp_build_meta_generic_from_skb(md, skb)			      \
+	_xdp_build_meta_generic_from_skb((md), (skb), __UNIQUE_ID(md_))
+
+#define __xdp_populate_skb_meta_generic(skb, md)			      \
+	___xdp_populate_skb_meta_generic((skb), to_rx_md(md))
+
+/**
+ * xdp_build_meta_generic_from_skb - build the generic meta before the skb data
+ * @skb: a pointer to the &sk_buff
+ *
+ * Builds an XDP generic metadata in front of the skb data from its fields.
+ * Note: skb->mac_header must be set and valid.
+ */
+static inline void xdp_build_meta_generic_from_skb(struct sk_buff *skb)
+{
+	struct xdp_meta_generic *md;
+	u32 needed;
+
+	/* skb_headroom() is `skb->data - skb->head`, i.e. it doesn't account
+	 * for the pulled headers, e.g. MAC header. Metadata resides in front
+	 * of the MAC header, so counting starts from there, not the current
+	 * data pointer position.
+	 * CoW won't happen in here when coming from Generic XDP path as it
+	 * ensures that an skb has at least %XDP_PACKET_HEADROOM beforehand.
+	 * It won't be happening also as long as `sizeof(*md) <= NET_SKB_PAD`.
+	 */
+	needed = (void *)skb->data - skb_metadata_end(skb) + sizeof(*md);
+	if (unlikely(skb_cow_head(skb, needed)))
+		return;
+
+	md = xdp_meta_generic_ptr(skb_metadata_end(skb));
+	__xdp_build_meta_generic_from_skb(md, skb);
+
+	skb_metadata_set(skb, sizeof(*md));
+	skb_metadata_nocomp_set(skb);
+}
+
+/**
+ * xdp_populate_skb_meta_generic - fill an skb from the metadata in front of it
+ * @skb: a pointer to the &sk_buff
+ *
+ * Fills the skb fields from the metadata in front of its MAC header and marks
+ * its metadata as "non-comparable".
+ * Note: skb->mac_header must be set and valid.
+ */
+static inline void xdp_populate_skb_meta_generic(struct sk_buff *skb)
+{
+	const struct xdp_meta_generic *md;
+
+	if (skb_metadata_len(skb) < sizeof(*md))
+		return;
+
+	md = xdp_meta_generic_ptr(skb_metadata_end(skb));
+	__xdp_populate_skb_meta_generic(skb, md);
+
+	/* We know at this point that skb metadata may contain
+	 * unique values, mark it as nocomp to not confuse GRO.
+	 */
+	skb_metadata_nocomp_set(skb);
+}
+
+int xdp_meta_match_id(const char * const *list, u64 id);
+
 #endif /* __LINUX_NET_XDP_META_H__ */
diff --git a/net/bpf/core.c b/net/bpf/core.c
index 18174d6d8687..a8685bcc6e00 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2017 Jesper Dangaard Brouer, Red Hat Inc.
  */
-#include <linux/bpf.h>
+#include <linux/btf.h>
 #include <linux/filter.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -713,3 +713,149 @@ struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
 
 	return nxdpf;
 }
+
+/**
+ * xdp_meta_match_id - find a type name corresponding to a given full ID
+ * @list: pointer to the %NULL-terminated list of type names
+ * @id: full ID (BTF ID + type ID) of the type to look
+ *
+ * Convenience wrapper over bpf_match_type_btf_id() for usage in drivers which
+ * takes care of zeroed ID and BPF syscall being not compiled in (to not break
+ * code flow and return "no meta").
+ *
+ * Returns a string array element index on success, an error code otherwise.
+ */
+int xdp_meta_match_id(const char * const *list, u64 id)
+{
+	int ret;
+
+	if (unlikely(!list || !*list))
+		return id ? -EINVAL : 0;
+
+	ret = bpf_match_type_btf_id(list, id);
+	if (ret == -ENOSYS || !id) {
+		for (ret = 0; list[ret]; ret++)
+			;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(xdp_meta_match_id);
+
+/* Used in __xdp_build_meta_generic_from_skb() to quickly get the ID
+ * on hotpath.
+ */
+static __le64 xdp_meta_generic_id __ro_after_init;
+
+static int __init xdp_meta_generic_id_init(void)
+{
+	int ret;
+	u64 id;
+
+	ret = bpf_get_type_btf_id("struct xdp_meta_generic", &id);
+	xdp_meta_generic_id = cpu_to_le64(id);
+
+	return ret;
+}
+late_initcall(xdp_meta_generic_id_init);
+
+#define _xdp_meta_rx_hash_type_from_skb(skb, locskb) ({		\
+	typeof(skb) locskb = (skb);				\
+								\
+	likely((locskb)->l4_hash) ? XDP_META_RX_HASH_L4 :	\
+	skb_get_hash_raw(locskb) ? XDP_META_RX_HASH_L3 :	\
+	XDP_META_RX_HASH_NONE;					\
+})
+#define xdp_meta_rx_hash_type_from_skb(skb)			\
+	_xdp_meta_rx_hash_type_from_skb((skb), __UNIQUE_ID(skb_))
+
+#define xdp_meta_rx_vlan_from_prot(skb) ({			\
+	(skb)->vlan_proto == htons(ETH_P_8021Q) ?		\
+	XDP_META_RX_CVID : XDP_META_RX_SVID;			\
+})
+
+#define xdp_meta_rx_vlan_to_prot(md) ({				\
+	xdp_meta_rx_vlan_type_get(md) == XDP_META_RX_CVID ?	\
+	htons(ETH_P_8021Q) : htons(ETH_P_8021AD);		\
+})
+
+/**
+ * ___xdp_build_meta_generic_from_skb - fill a generic metadata from an skb
+ * @rx_md: a pointer to the XDP generic metadata to be filled
+ * @skb: a pointer to the skb to take the info from
+ *
+ * Fills a given generic metadata struct with the info set previously in
+ * an skb. @md can point to anywhere and the function doesn't use the
+ * skb_metadata_{end,len}().
+ */
+void ___xdp_build_meta_generic_from_skb(struct xdp_meta_generic_rx *rx_md,
+					const struct sk_buff *skb)
+{
+	struct xdp_meta_generic *md = to_gen_md(rx_md);
+	ktime_t ts;
+
+	xdp_meta_init(rx_md, xdp_meta_generic_id);
+
+	xdp_meta_rx_csum_level_set(md, skb->csum_level);
+	xdp_meta_rx_csum_status_set(md, skb->ip_summed);
+	xdp_meta_rx_csum_set(md, skb->csum);
+
+	xdp_meta_rx_hash_set(md, skb_get_hash_raw(skb));
+	xdp_meta_rx_hash_type_set(md, xdp_meta_rx_hash_type_from_skb(skb));
+
+	if (likely(skb_rx_queue_recorded(skb))) {
+		xdp_meta_rx_qid_present_set(md, 1);
+		xdp_meta_rx_qid_set(md, skb_get_rx_queue(skb));
+	}
+
+	if (skb_vlan_tag_present(skb)) {
+		xdp_meta_rx_vlan_type_set(md, xdp_meta_rx_vlan_from_prot(skb));
+		xdp_meta_rx_vid_set(md, skb_vlan_tag_get(skb));
+	}
+
+	ts = skb_hwtstamps(skb)->hwtstamp;
+	if (ts) {
+		xdp_meta_rx_tstamp_present_set(md, 1);
+		xdp_meta_rx_tstamp_set(md, ktime_to_ns(ts));
+	}
+}
+EXPORT_SYMBOL_GPL(___xdp_build_meta_generic_from_skb);
+
+/**
+ * ___xdp_populate_skb_meta_generic - fill the skb fields from a generic meta
+ * @skb: a pointer to the skb to be filled
+ * @rx_md: a pointer to the generic metadata to take the values from
+ *
+ * Populates the &sk_buff fields from a given XDP generic metadata. A meta
+ * can be from anywhere, the function doesn't use skb_metadata_{end,len}().
+ * Checks whether the metadata is generic-compatible before accessing other
+ * fields.
+ */
+void ___xdp_populate_skb_meta_generic(struct sk_buff *skb,
+				      const struct xdp_meta_generic_rx *rx_md)
+{
+	const struct xdp_meta_generic *md = to_gen_md(rx_md);
+
+	if (unlikely(!xdp_meta_has_generic(md + 1)))
+		return;
+
+	skb->csum_level = xdp_meta_rx_csum_level_get(md);
+	skb->ip_summed = xdp_meta_rx_csum_status_get(md);
+	skb->csum = xdp_meta_rx_csum_get(md);
+
+	skb_set_hash(skb, xdp_meta_rx_hash_get(md),
+		     xdp_meta_rx_hash_type_get(md));
+
+	if (likely(xdp_meta_rx_qid_present_get(md)))
+		skb_record_rx_queue(skb, xdp_meta_rx_qid_get(md));
+
+	if (xdp_meta_rx_vlan_type_get(md))
+		__vlan_hwaccel_put_tag(skb, xdp_meta_rx_vlan_to_prot(md),
+				       xdp_meta_rx_vid_get(md));
+
+	if (xdp_meta_rx_tstamp_present_get(md))
+		*skb_hwtstamps(skb) = (struct skb_shared_hwtstamps){
+			.hwtstamp = ns_to_ktime(xdp_meta_rx_tstamp_get(md)),
+		};
+}
+EXPORT_SYMBOL_GPL(___xdp_populate_skb_meta_generic);
-- 
2.36.1

