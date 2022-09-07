Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651D75B08FD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIGPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIGPpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D8B6D9C5
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdxGJ5dHoOldEJkDFP9p+jriAkljx0MtUoRMntLWj64=;
        b=M87bLyn9t4CAXIGypWRizU4Y1n37eiVl8+5fRNR5eamOveLFMTdurjDD8G5dAXdTfXCR4a
        TE0VLrUfppJatdqmhBqIROpggV0Jue/2mnxcKA5ptJx0enji3U0myohaD5pJXCCyVU+IIw
        dRVndaqGXzScb8mrx1WPLui3JVOEYUk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-2-S1a2WbOIy9vbKF2elLxw-1; Wed, 07 Sep 2022 11:45:33 -0400
X-MC-Unique: 2-S1a2WbOIy9vbKF2elLxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 673DA85A58B;
        Wed,  7 Sep 2022 15:45:32 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF2671410F38;
        Wed,  7 Sep 2022 15:45:31 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 017C630721A6C;
        Wed,  7 Sep 2022 17:45:31 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 06/18] xdp: controlling XDP-hints from BPF-prog
 via helper
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:30 +0200
Message-ID: <166256553093.1434226.11320655607309623999.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP BPF-prog's need a way to interact with the XDP-hints. This patch
introduces a BPF-helper function, that allow XDP BPF-prog's to interact
with the XDP-hints.  Choosing BPF-helper to avoid directly exposing
xdp_buff_flags as UAPI.

BPF-prog can query if any XDP-hints have been setup and if this is
compatible with the xdp_hints_common struct.

Notice that XDP-hints are setup by the driver prior to calling the XDP
BPF-prog, which is useful as a BPF software layer for adjusting the HW
provided XDP-hints in-case of HW issues or missing HW features, for
use-case like xdp2skb or AF_XDP.

The BPF-prog might also prefer to use metadata area for other things,
either disabling XDP-hints or updating with another XDP-hints layout
that might still be compatible with common struct. Thus, helper have
"update" and "delete" mode flags.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h              |   41 ++++++++++++++++++++++++++++----
 include/uapi/linux/bpf.h       |   41 ++++++++++++++++++++++++++++++++
 net/core/filter.c              |   52 ++++++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |   43 ++++++++++++++++++++++++++++++++-
 4 files changed, 172 insertions(+), 5 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index ea5836ccee82..c7cdcef83fa5 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -213,14 +213,19 @@ struct xdp_txq_info {
 };
 
 enum xdp_buff_flags {
-	XDP_FLAGS_HAS_FRAGS		= BIT(0), /* non-linear xdp buff */
-	XDP_FLAGS_FRAGS_PF_MEMALLOC	= BIT(1), /* xdp paged memory is under
+	XDP_FLAGS_HINTS_ENABLED 	= BIT(0),/* enum xdp_hint */
+#define	XDP_FLAGS_HINTS_COMPAT_COMMON_	  BIT(1) /* HINTS_BTF_COMPAT_COMMON */
+	XDP_FLAGS_HINTS_COMPAT_COMMON	= XDP_FLAGS_HINTS_COMPAT_COMMON_,
+
+	XDP_FLAGS_HAS_FRAGS		= BIT(2), /* non-linear xdp buff */
+	XDP_FLAGS_FRAGS_PF_MEMALLOC	= BIT(3), /* xdp paged memory is under
 						   * pressure
 						   */
-	XDP_FLAGS_HAS_HINTS		= BIT(2),
-	XDP_FLAGS_HINTS_COMPAT_COMMON	= BIT(3),
 };
 
+#define XDP_FLAGS_HINTS_MASK	(XDP_FLAGS_HINTS_ENABLED |	\
+				 XDP_FLAGS_HINTS_COMPAT_COMMON)
+
 struct xdp_buff {
 	void *data;
 	void *data_end;
@@ -257,6 +262,34 @@ static __always_inline void xdp_buff_set_frag_pfmemalloc(struct xdp_buff *xdp)
 	xdp->flags |= XDP_FLAGS_FRAGS_PF_MEMALLOC;
 }
 
+static __always_inline bool xdp_buff_has_hints(struct xdp_buff *xdp)
+{
+	return !!(xdp->flags & XDP_FLAGS_HINTS_MASK);
+}
+
+static __always_inline bool xdp_buff_has_hints_compat(struct xdp_buff *xdp)
+{
+	u32 flags = xdp->flags;
+
+	if (!(flags & XDP_FLAGS_HINTS_COMPAT_COMMON))
+		return false;
+
+	return !!(flags & XDP_FLAGS_HINTS_MASK);
+}
+
+static __always_inline void xdp_buff_set_hints_flags(struct xdp_buff *xdp,
+						     bool is_compat_common)
+{
+	u32 common = is_compat_common ? XDP_FLAGS_HINTS_COMPAT_COMMON : 0;
+
+	xdp->flags |= XDP_FLAGS_HINTS_ENABLED | common;
+}
+
+static __always_inline void xdp_buff_clear_hints_flags(struct xdp_buff *xdp)
+{
+	xdp->flags &= ~XDP_FLAGS_HINTS_MASK;
+}
+
 static __always_inline void
 xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 934a2a8beb87..36ba104e612e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5355,6 +5355,37 @@ union bpf_attr {
  *	Return
  *		Current *ktime*.
  *
+ * long xdp_hints_btf(struct xdp_buff *xdp_md, u64 flags)
+ *	Description
+ *		Update and get info on XDP hints ctx state.
+ *
+ *		Drivers can provide XDP-hints information via the metadata area,
+ *		which defines the layout of this area via BTF. The *full* BTF ID
+ *		is available as the last member.
+ *
+ *		This **full** BTF ID is a 64-bit value, encoding the BTF
+ *		**object** ID as the high 32-bit and BTF *type* ID as lower
+ *		32-bit.  This is needed as the BTF **type** ID (32-bit) can
+ *		originate from different BTF **object** sources, e.g.  vmlinux,
+ *		module or local BTF-object.
+ *
+ *		In-case a BPF-prog want to redefine the layout of this area it
+ *		should update the full BTF ID (last-member) and call this helper
+ *		to specify if the layout is compatible with kernel struct
+ *		xdp_hints_common.
+ *
+ *		The **flags** are used to control the mode of the helper.
+ *		See enum xdp_hints_btf_mode_flags.
+ *
+ *     Return
+ * 		0 if driver didn't populate XDP-hints.
+ *
+ *		Flag **HINTS_BTF_ENABLED** (1) if driver populated hints.
+ *
+ *		Flag **HINTS_BTF_COMPAT_COMMON** (2) if layout is compatible
+ *		with kernel struct xdp_hints_common. Thus, return value 3 as
+ *		both flags will be set.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5566,6 +5597,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
+	FN(xdp_hints_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5977,6 +6009,15 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
+/* Mode flags for BPF_FUNC_xdp_hints_btf helper. */
+enum xdp_hints_btf_mode_flags {
+	HINTS_BTF_QUERY_ONLY    = (1U << 0),
+	HINTS_BTF_ENABLED       = (1U << 0), /* Return value */
+	HINTS_BTF_COMPAT_COMMON = (1U << 1), /* Return and query value */
+	HINTS_BTF_UPDATE        = (1U << 2),
+	HINTS_BTF_DISABLE       = (1U << 3),
+};
+
 /* DEVMAP map-value layout
  *
  * The struct data-layout of map-value is a configuration interface.
diff --git a/net/core/filter.c b/net/core/filter.c
index 1acfaffeaf32..35f29990a67e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6094,6 +6094,56 @@ static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
 	.arg5_type      = ARG_ANYTHING,
 };
 
+/* flags type &enum xdp_hints_btf_mode_flags */
+BPF_CALL_2(bpf_xdp_hints_btf, struct xdp_buff *, xdp, u64, flags)
+{
+	bool is_compat_common;
+	s64 ret = 0;
+
+	/* UAPI value HINTS_BTF_COMPAT_COMMON happens to match xdp_buff->flags
+	 * XDP_FLAGS_HINTS_COMPAT_COMMON which makes below code easier
+	 */
+	BUILD_BUG_ON(HINTS_BTF_COMPAT_COMMON != XDP_FLAGS_HINTS_COMPAT_COMMON_);
+
+	if (flags & HINTS_BTF_QUERY_ONLY) {
+		ret = xdp->flags & XDP_FLAGS_HINTS_MASK;
+		goto out;
+	}
+	if (flags & HINTS_BTF_DISABLE) {
+		xdp_buff_clear_hints_flags(xdp);
+		goto out;
+	}
+	if (flags & HINTS_BTF_UPDATE) {
+		is_compat_common = !!(flags & HINTS_BTF_COMPAT_COMMON);
+
+		if (is_compat_common) {
+			unsigned long metalen = xdp_get_metalen(xdp);
+
+			if (sizeof(struct xdp_hints_common) < metalen)
+				is_compat_common = false;
+			/* TODO: Can kernel validate if hints are BTF compat
+			 * with common?
+			 */
+		}
+	/* TODO: Could BPF prog provide BTF as ARG_PTR_TO_BTF_ID to prove compat_common ? */
+		xdp_buff_set_hints_flags(xdp, is_compat_common);
+
+		ret = xdp->flags & XDP_FLAGS_HINTS_MASK;
+		goto out;
+	}
+
+ out:
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_xdp_hints_btf_proto = {
+	.func		= bpf_xdp_hints_btf,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+};
+
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len)
 {
@@ -7944,6 +7994,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
 		return &bpf_xdp_check_mtu_proto;
+	case BPF_FUNC_xdp_hints_btf:
+		return &bpf_xdp_hints_btf_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1d6085e15fc8..36ba104e612e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -79,7 +79,7 @@ struct bpf_insn {
 /* Key of an a BPF_MAP_TYPE_LPM_TRIE entry */
 struct bpf_lpm_trie_key {
 	__u32	prefixlen;	/* up to 32 for AF_INET, 128 for AF_INET6 */
-	__u8	data[0];	/* Arbitrary size */
+	__u8	data[];	/* Arbitrary size */
 };
 
 struct bpf_cgroup_storage_key {
@@ -5355,6 +5355,37 @@ union bpf_attr {
  *	Return
  *		Current *ktime*.
  *
+ * long xdp_hints_btf(struct xdp_buff *xdp_md, u64 flags)
+ *	Description
+ *		Update and get info on XDP hints ctx state.
+ *
+ *		Drivers can provide XDP-hints information via the metadata area,
+ *		which defines the layout of this area via BTF. The *full* BTF ID
+ *		is available as the last member.
+ *
+ *		This **full** BTF ID is a 64-bit value, encoding the BTF
+ *		**object** ID as the high 32-bit and BTF *type* ID as lower
+ *		32-bit.  This is needed as the BTF **type** ID (32-bit) can
+ *		originate from different BTF **object** sources, e.g.  vmlinux,
+ *		module or local BTF-object.
+ *
+ *		In-case a BPF-prog want to redefine the layout of this area it
+ *		should update the full BTF ID (last-member) and call this helper
+ *		to specify if the layout is compatible with kernel struct
+ *		xdp_hints_common.
+ *
+ *		The **flags** are used to control the mode of the helper.
+ *		See enum xdp_hints_btf_mode_flags.
+ *
+ *     Return
+ * 		0 if driver didn't populate XDP-hints.
+ *
+ *		Flag **HINTS_BTF_ENABLED** (1) if driver populated hints.
+ *
+ *		Flag **HINTS_BTF_COMPAT_COMMON** (2) if layout is compatible
+ *		with kernel struct xdp_hints_common. Thus, return value 3 as
+ *		both flags will be set.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5566,6 +5597,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
+	FN(xdp_hints_btf),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5977,6 +6009,15 @@ struct xdp_md {
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
 };
 
+/* Mode flags for BPF_FUNC_xdp_hints_btf helper. */
+enum xdp_hints_btf_mode_flags {
+	HINTS_BTF_QUERY_ONLY    = (1U << 0),
+	HINTS_BTF_ENABLED       = (1U << 0), /* Return value */
+	HINTS_BTF_COMPAT_COMMON = (1U << 1), /* Return and query value */
+	HINTS_BTF_UPDATE        = (1U << 2),
+	HINTS_BTF_DISABLE       = (1U << 3),
+};
+
 /* DEVMAP map-value layout
  *
  * The struct data-layout of map-value is a configuration interface.


