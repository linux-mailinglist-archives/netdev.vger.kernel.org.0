Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA2F5B08F9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIGPpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiIGPpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3277166A5D
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y6L2s1M+P9oqMPMrDrGBNL2SB10RA54bSv25oEqaLuI=;
        b=MFZOhudS1mbtAn/mmzs96ghFGuB+VaJwt77sOZZo6niClZXcpMNdgU4GWxP6BE73TGKbHK
        B0aARGbDedOVfKWaN4i2lvnNYR5fviWJg1Kp09AF1LlJ7HlGYkUOAE+1LD4SMNz5/X8zt9
        q7cBkQ/e6oCHAIlED7jRJodMAufD9HY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-9n1vZWZgMluD8HSmHxRelQ-1; Wed, 07 Sep 2022 11:45:23 -0400
X-MC-Unique: 9n1vZWZgMluD8HSmHxRelQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42BEC1C05EA8;
        Wed,  7 Sep 2022 15:45:22 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBA801410F38;
        Wed,  7 Sep 2022 15:45:21 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D3F8D30721A6C;
        Wed,  7 Sep 2022 17:45:20 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 04/18] net: create xdp_hints_common and set
 functions
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
Date:   Wed, 07 Sep 2022 17:45:20 +0200
Message-ID: <166256552083.1434226.577215984964402996.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP-hints via BTF are about giving drivers the ability to extend the
common set of hardware offload hints in a flexible way.

This patch start out with defining the common set, based on what is
used available in the SKB. Having this as a common struct in core
vmlinux makes it easier to implement xdp_frame to SKB conversion
routines as normal C-code, see later patches.

Drivers can redefine the layout of the entire metadata area, but are
encouraged to use this common struct as the base, on which they can
extend on top for their extra hardware offload hints. When doing so,
drivers can mark the xdp_buff (and xdp_frame) with flags indicating
this it compatible with the common struct.

Patch also provides XDP-hints driver helper functions for updating the
common struct. Helpers gets inlined and are defined for maximum
performance, which does require some extra care in drivers, e.g. to
keep track of flags to reduce data dependencies, see code DOC.

Userspace and BPF-prog's MUST not consider the common struct UAPI.
The common struct (and enum flags) are only exposed via BTF, which
implies consumers must read and decode this BTF before using/consuming
data layout.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |    5 ++
 2 files changed, 152 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 04c852c7a77f..ea5836ccee82 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -8,6 +8,151 @@
 
 #include <linux/skbuff.h> /* skb_shared_info */
 
+/**
+ * struct xdp_hints_common - Common XDP-hints offloads shared with netstack
+ * @btf_full_id: The modules BTF object + type ID for specific struct
+ * @vlan_tci: Hardware provided VLAN tag + proto type in @xdp_hints_flags
+ * @rx_hash32: Hardware provided RSS hash value
+ * @xdp_hints_flags: see &enum xdp_hints_flags
+ *
+ * This structure contains the most commonly used hardware offloads hints
+ * provided by NIC drivers and supported by the SKB.
+ *
+ * Driver are expected to extend this structure by include &struct
+ * xdp_hints_common as part of the drivers own specific xdp_hints struct's, but
+ * at the end-of their struct given XDP metadata area grows backwards.
+ *
+ * The member @btf_full_id is populated by driver modules to uniquely identify
+ * the BTF struct.  The high 32-bits store the modules BTF object ID and the
+ * lower 32-bit the BTF type ID within that BTF object.
+ */
+struct xdp_hints_common {
+	union {
+		__wsum		csum;
+		struct {
+			__u16	csum_start;
+			__u16	csum_offset;
+		};
+	};
+	u16 rx_queue;
+	u16 vlan_tci;
+	u32 rx_hash32;
+	u32 xdp_hints_flags;
+	u64 btf_full_id; /* BTF object + type ID */
+} __attribute__((aligned(4))) __attribute__((packed));
+
+
+/**
+ * enum xdp_hints_flags - flags used by &struct xdp_hints_common
+ *
+ * The &enum xdp_hints_flags have reserved the first 16 bits for common flags
+ * and drivers can introduce use their own flags bits from BIT(16). For
+ * BPF-progs to find these flags (via BTF) drivers should define an enum
+ * xdp_hints_flags_driver.
+ */
+enum xdp_hints_flags {
+	HINT_FLAG_CSUM_TYPE_BIT0  = BIT(0),
+	HINT_FLAG_CSUM_TYPE_BIT1  = BIT(1),
+	HINT_FLAG_CSUM_TYPE_MASK  = 0x3,
+
+	HINT_FLAG_CSUM_LEVEL_BIT0 = BIT(2),
+	HINT_FLAG_CSUM_LEVEL_BIT1 = BIT(3),
+	HINT_FLAG_CSUM_LEVEL_MASK = 0xC,
+	HINT_FLAG_CSUM_LEVEL_SHIFT = 2,
+
+	HINT_FLAG_RX_HASH_TYPE_BIT0 = BIT(4),
+	HINT_FLAG_RX_HASH_TYPE_BIT1 = BIT(5),
+	HINT_FLAG_RX_HASH_TYPE_MASK = 0x30,
+	HINT_FLAG_RX_HASH_TYPE_SHIFT = 0x4,
+
+	HINT_FLAG_RX_QUEUE = BIT(7),
+
+	HINT_FLAG_VLAN_PRESENT            = BIT(8),
+	HINT_FLAG_VLAN_PROTO_ETH_P_8021Q  = BIT(9),
+	HINT_FLAG_VLAN_PROTO_ETH_P_8021AD = BIT(10),
+	/* Flags from BIT(16) can be used by drivers */
+};
+
+/**
+ * enum xdp_hints_csum_type - BTF exposing checksum defines
+ *
+ * This enum is primarily for BTF exposing ``CHECKSUM_*`` defines (as an enum)
+ * used by &struct skb->ip_summed (see Documentation/networking/skbuff.rst
+ * section "Checksum information").
+ *
+ * These values are stored in &enum xdp_hints_flags as bit locations
+ * ``HINT_FLAG_CSUM_TYPE_BIT*``
+ */
+enum xdp_hints_csum_type {
+	HINT_CHECKSUM_NONE        = CHECKSUM_NONE,
+	HINT_CHECKSUM_UNNECESSARY = CHECKSUM_UNNECESSARY,
+	HINT_CHECKSUM_COMPLETE    = CHECKSUM_COMPLETE,
+	HINT_CHECKSUM_PARTIAL     = CHECKSUM_PARTIAL,
+};
+
+/** DOC: XDP hints driver helpers
+ *
+ * Helpers for drivers updating struct xdp_hints_common.
+ *
+ * Avoid creating a data dependency on xdp_hints_flags via returning the flags
+ * that need to be set.  Drivers MUST update the xdp_hints_flags member
+ * themselves, which allows drivers to construct code with less data dependency
+ * between instructions by OR'ing the final flags together.
+ */
+
+/* Drivers please use this simple helper to ease changes across drives */
+static __always_inline void xdp_hints_set_flags(struct xdp_hints_common *hints,
+						u32 flags)
+{
+	hints->xdp_hints_flags = flags;
+}
+
+static __always_inline u32 xdp_hints_set_rx_csum(
+	struct xdp_hints_common *hints,
+	u16 type, u16 level)
+{
+	u32 flags;
+
+	flags = type & HINT_FLAG_CSUM_TYPE_MASK;
+	flags |= (level << HINT_FLAG_CSUM_LEVEL_SHIFT)
+		& HINT_FLAG_CSUM_LEVEL_MASK;
+
+	// TODO: handle CHECKSUM_PARTIAL and COMPLETE (needs updating *hints)
+	return flags;
+}
+
+/* @type	Must be &enum enum pkt_hash_types (PKT_HASH_TYPE_*) */
+static __always_inline u32 xdp_hints_set_rx_hash(
+	struct xdp_hints_common *hints,
+	u32 hash, u32 type)
+{
+	hints->rx_hash32 = hash;
+	return (type << HINT_FLAG_RX_HASH_TYPE_SHIFT) &
+		HINT_FLAG_RX_HASH_TYPE_MASK;
+}
+
+static __always_inline u32 xdp_hints_set_rxq(struct xdp_hints_common *hints,
+					     u16 q_idx)
+{
+	hints->rx_queue = q_idx;
+	return HINT_FLAG_RX_QUEUE;
+}
+
+/* @proto	Must be ETH_P_8021Q or ETH_P_8021AD in network order */
+static __always_inline u32 xdp_hints_set_vlan(struct xdp_hints_common *hints,
+					      u16 vlan_tag, const u16 proto)
+{
+	u32 flags = HINT_FLAG_VLAN_PRESENT;
+
+	hints->vlan_tci = vlan_tag;
+	if (proto == htons(ETH_P_8021Q))
+		flags |= HINT_FLAG_VLAN_PROTO_ETH_P_8021Q;
+	if (proto == htons(ETH_P_8021AD))
+		flags |= HINT_FLAG_VLAN_PROTO_ETH_P_8021AD;
+
+	return flags;
+}
+
 /**
  * DOC: XDP RX-queue information
  *
@@ -72,6 +217,8 @@ enum xdp_buff_flags {
 	XDP_FLAGS_FRAGS_PF_MEMALLOC	= BIT(1), /* xdp paged memory is under
 						   * pressure
 						   */
+	XDP_FLAGS_HAS_HINTS		= BIT(2),
+	XDP_FLAGS_HINTS_COMPAT_COMMON	= BIT(3),
 };
 
 struct xdp_buff {
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 24420209bf0e..a57bd5278b47 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -33,6 +33,11 @@ static int mem_id_next = MEM_ID_MIN;
 static bool mem_id_init; /* false */
 static struct rhashtable *mem_id_ht;
 
+/* Make xdp_hints part of core vmlinux BTF */
+struct xdp_hints_common  xdp_hints_common;
+enum xdp_hints_flags     xdp_hints_flags;
+enum xdp_hints_csum_type xdp_hints_csum_type;
+
 static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
 {
 	const u32 *k = data;


