Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9255EEA3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiF1Txb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiF1Tu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CAD1FCD4;
        Tue, 28 Jun 2022 12:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445790; x=1687981790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jaSXqFe1wqX1hqacI7CTj2oedil7nvHz4K/7STA+keI=;
  b=N0B9qgAboZogUAyD+8k87qAz7sQb5bvmMGkpwDW0iBJ4g8NBwUXZrMcN
   v89RTJ6zO0BRpcvQvPHbZW1OcYs10X0I++wJ68NdHaY3OUA7rY8k3PVR5
   oB9BI6iZROpFjqIu5bziauhVmqy8LwRKadfiRoWLrukqGk8E/HQR0guR7
   X50uFsKYUcxgJKfduxXgunJfUB4Haab2JD5oH1+eCfuR9Cai1vrl9yukf
   WmgaauBj036acS/qYGvp6BPqWlcOemwY8r0GF109k3DLNIY/LOgT1LUi3
   MoqwFWbcBY5eaHFmUxK2MMr0syH7pFIYSHSEVVFCguEsOzcsrRlJ3psnL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281869605"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281869605"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767288117"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:49:27 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9O022013;
        Tue, 28 Jun 2022 20:49:26 +0100
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
Subject: [PATCH RFC bpf-next 24/52] bpf, xdp: declare generic XDP metadata structure
Date:   Tue, 28 Jun 2022 21:47:44 +0200
Message-Id: <20220628194812.1453059-25-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

The generic XDP metadata is a driver-independent "header" which
carries the essential info such as the checksum status, the hash
etc. It can be composed by both hardware and software (drivers)
and is designed to pass that info, usually taken from the NIC
descriptors, between the different subsystems and layers in one
unified format.
As it's "cross-everything" and can be composed by hardware
(primarily SmartNICs), an explicit Endianness is required. Most
hardware and hosts operate in LE nowadays, so the choice was
obvious although network frames themselves are in BE. The byteswap
macros will be no-ops for LE systems.
The first and the last field must always be 2-byte one to have
a natural alignment of 4 and 8 byte members on 32-bit platforms
where there's an "IP align" 2-byte padding in front of the data:
the first member paired with that padding makes the next one
aligned to 4 bytes, the last one stacks with the Ethernet header
to make its end aligned to 4 bytes.
As it's being prepended right in front of the Ethernet header, it
grows to the left, so all new fields must be added at the beginning
of the structure in the future.
The related definitions are declared inside an enum so that they're
visible to BPF programs. The struct is declared in UAPI so AF_XDP
programs, which can work with metadata as well, would have access
to it.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Co-developed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Co-developed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/uapi/linux/bpf.h       | 173 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 173 +++++++++++++++++++++++++++++++++
 2 files changed, 346 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 372170ded1d8..1caaec1de625 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -8,6 +8,7 @@
 #ifndef _UAPI__LINUX_BPF_H__
 #define _UAPI__LINUX_BPF_H__
 
+#include <asm/byteorder.h>
 #include <linux/types.h>
 #include <linux/bpf_common.h>
 
@@ -6859,4 +6860,176 @@ struct bpf_core_relo {
 	enum bpf_core_relo_kind kind;
 };
 
+/* Definitions being used to work with &xdp_meta_generic, declared as an enum
+ * so they are visible for BPF programs via vmlinux.h.
+ */
+enum xdp_meta_generic_defs {
+	/* xdp_meta_generic::tx_flags */
+
+	/* Mask of bits containing Tx timestamp action */
+	XDP_META_TX_TSTAMP_TYPE		= (0x3 << 4),
+	/* No action is needed */
+	XDP_META_TX_TSTAMP_ACT		= 0x0,
+	/* %SO_TIMESTAMP command */
+	XDP_META_TX_TSTAMP_SOCK		= 0x1,
+	/* Set the value to the actual time when a packet is sent */
+	XDP_META_TX_TSTAMP_COMP		= 0x2,
+	/* Mask of bits containing Tx VLAN action */
+	XDP_META_TX_VLAN_TYPE		= (0x3 << 2),
+	/* No action is needed */
+	XDP_META_TX_VLAN_NONE		= 0x0,
+	/* NIC must push C-VLAN tag */
+	XDP_META_TX_CVID		= 0x1,
+	/* NIC must push S-VLAN tag */
+	XDP_META_TX_SVID		= 0x2,
+	/* Mask of bits containing Tx checksum action */
+	XDP_META_TX_CSUM_ACT		= (0x3 << 0),
+	/* No action for checksum */
+	XDP_META_TX_CSUM_ASIS		= 0x0,
+	/* NIC must compute checksum, no start/offset are provided */
+	XDP_META_TX_CSUM_AUTO		= 0x1,
+	/* NIC must compute checksum using the provided start and offset */
+	XDP_META_TX_CSUM_HELP		= 0x2,
+
+	/* xdp_meta_generic::rx_flags */
+
+	/* Metadata contains valid Rx queue ID */
+	XDP_META_RX_QID_PRESENT		= (0x1 << 9),
+	/* Metadata contains valid Rx timestamp */
+	XDP_META_RX_TSTAMP_PRESENT	= (0x1 << 8),
+	/* Mask of bits containing Rx VLAN status */
+	XDP_META_RX_VLAN_TYPE		= (0x3 << 6),
+	/* Metadata does not have any VLAN tags */
+	XDP_META_RX_VLAN_NONE		= 0x0,
+	/* Metadata carries valid C-VLAN tag */
+	XDP_META_RX_CVID		= 0x1,
+	/* Metadata carries valid S-VLAN tag */
+	XDP_META_RX_SVID		= 0x2,
+	/* Mask of bits containing Rx hash status */
+	XDP_META_RX_HASH_TYPE		= (0x3 << 4),
+	/* Metadata has no RSS hash */
+	XDP_META_RX_HASH_NONE		= 0x0,
+	/* Metadata has valid L2 hash */
+	XDP_META_RX_HASH_L2		= 0x1,
+	/* Metadata has valid L3 hash */
+	XDP_META_RX_HASH_L3		= 0x2,
+	/* Metadata has valid L4 hash */
+	XDP_META_RX_HASH_L4		= 0x3,
+	/* Mask of the field containing checksum level (if there's encap) */
+	XDP_META_RX_CSUM_LEVEL		= (0x3 << 2),
+	/* Mask of bits containing Rx checksum status */
+	XDP_META_RX_CSUM_STATUS		= (0x3 << 0),
+	/* Metadata has no checksum info */
+	XDP_META_RX_CSUM_NONE		= 0x0,
+	/* Checksum has been verified by NIC */
+	XDP_META_RX_CSUM_OK		= 0x1,
+	/* Metadata carries valid checksum */
+	XDP_META_RX_CSUM_COMP		= 0x2,
+
+	/* xdp_meta_generic::magic_id indicates that the metadata is either
+	 * struct xdp_meta_generic itself or contains it at the end -> can be
+	 * used to get/set HW hints.
+	 * Direct btf_id comparison is not enough here as a custom structure
+	 * caring xdp_meta_generic at the end will have a different ID.
+	 */
+	XDP_META_GENERIC_MAGIC	= 0xeda6,
+};
+
+/* Generic metadata can be composed directly by HW, plus it should always
+ * have the first field as __le16 to account the 2 bytes of "IP align", so
+ * we pack it to avoid unexpected paddings. Also, it should be aligned to
+ * sizeof(__be16) as any other Ethernet data, and to optimize access on the
+ * 32-bit platforms.
+ */
+#define __xdp_meta_generic_attrs			\
+	__attribute__((__packed__))			\
+	__attribute__((aligned(sizeof(__be16))))
+
+/* Depending on the field layout inside the structure, it might or might not
+ * emit a "packed attribute is unnecessary" warning (when enabled, e.g. in
+ * libbpf). To not add and remove the attributes on each field addition,
+ * just suppress it.
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wpacked"
+
+/* All fields have explicit endianness, as it might be composed by HW.
+ * Byteswaps are needed for the Big Endian architectures to access the
+ * fields.
+ */
+struct xdp_meta_generic {
+	/* Add new fields here */
+
+	/* Egress part */
+	__struct_group(/* no tag */, tx, __xdp_meta_generic_attrs,
+		/* Offset from the start of the frame to the L4 header
+		 * to compute checksum for
+		 */
+		__le16 tx_csum_start;
+		/* Offset inside the L4 header to the checksum field */
+		__le16 tx_csum_off;
+		/* ID for hardware VLAN push */
+		__le16 tx_vid;
+		/* Flags indicating which Tx metadata is used */
+		__le32 tx_flags;
+		/* Tx timestamp value */
+		__le64 tx_tstamp;
+	);
+
+	/* Shortcut for the half relevant on ingress: Rx + IDs */
+	__struct_group(xdp_meta_generic_rx, rx_full, __xdp_meta_generic_attrs,
+		/* Ingress part */
+		__struct_group(/* no tag */, rx, __xdp_meta_generic_attrs,
+			/* Rx timestamp value */
+			__le64 rx_tstamp;
+			/* Rx hash value */
+			__le32 rx_hash;
+			/* Rx checksum value */
+			__le32 rx_csum;
+			/* VLAN ID popped on Rx */
+			__le16 rx_vid;
+			/* Rx queue ID on which the frame has arrived */
+			__le16 rx_qid;
+			/* Flags indicating which Rx metadata is used */
+			__le32 rx_flags;
+		);
+
+		/* Unique metadata identifiers */
+		__struct_group(/* no tag */, id, __xdp_meta_generic_attrs,
+			union {
+				struct {
+#ifdef __BIG_ENDIAN_BITFIELD
+					/* Indicates the ID of the BTF which
+					 * the below type ID comes from, as
+					 * several kernel modules may have
+					 * identical type IDs
+					 */
+					__le32 btf_id;
+					/* Indicates the ID of the actual
+					 * structure passed as metadata,
+					 * within the above BTF ID
+					 */
+					__le32 type_id;
+#else /* __LITTLE_ENDIAN_BITFIELD */
+					__le32 type_id;
+					__le32 btf_id;
+#endif /* __LITTLE_ENDIAN_BITFIELD */
+				};
+				/* BPF program gets IDs coded as one __u64:
+				 * `btf_id << 32 | type_id`, allow direct
+				 * comparison
+				 */
+				__le64 full_id;
+			};
+			/* If set to the correct value, indicates that the
+			 * meta is generic-compatible and can be used by
+			 * the consumers of generic metadata
+			 */
+			__le16 magic_id;
+		);
+	);
+} __xdp_meta_generic_attrs;
+
+#pragma GCC diagnostic pop
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 372170ded1d8..436b925adfb3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -8,6 +8,7 @@
 #ifndef _UAPI__LINUX_BPF_H__
 #define _UAPI__LINUX_BPF_H__
 
+#include <asm/byteorder.h>
 #include <linux/types.h>
 #include <linux/bpf_common.h>
 
@@ -6859,4 +6860,176 @@ struct bpf_core_relo {
 	enum bpf_core_relo_kind kind;
 };
 
+/* Definitions being used to work with &xdp_meta_generic, declared as an enum
+ * so they are visible for BPF programs via vmlinux.h.
+ */
+enum xdp_meta_generic_defs {
+	/* xdp_meta_generic::tx_flags */
+
+	/* Mask of bits containing Tx timestamp action */
+	XDP_META_TX_TSTAMP_ACT		= (0x3 << 4),
+	/* No action is needed */
+	XDP_META_TX_TSTAMP_NONE		= 0x0,
+	/* %SO_TIMESTAMP command */
+	XDP_META_TX_TSTAMP_SOCK		= 0x1,
+	/* Set the value to the actual time when a packet is sent */
+	XDP_META_TX_TSTAMP_COMP		= 0x2,
+	/* Mask of bits containing Tx VLAN action */
+	XDP_META_TX_VLAN_TYPE		= (0x3 << 2),
+	/* No action is needed */
+	XDP_META_TX_VLAN_NONE		= 0x0,
+	/* NIC must push C-VLAN tag */
+	XDP_META_TX_CVID		= 0x1,
+	/* NIC must push S-VLAN tag */
+	XDP_META_TX_SVID		= 0x2,
+	/* Mask of bits containing Tx checksum action */
+	XDP_META_TX_CSUM_ACT		= (0x3 << 0),
+	/* No action for checksum */
+	XDP_META_TX_CSUM_ASIS		= 0x0,
+	/* NIC must compute checksum, no start/offset are provided */
+	XDP_META_TX_CSUM_AUTO		= 0x1,
+	/* NIC must compute checksum using the provided start and offset */
+	XDP_META_TX_CSUM_HELP		= 0x2,
+
+	/* xdp_meta_generic::rx_flags */
+
+	/* Metadata contains valid Rx queue ID */
+	XDP_META_RX_QID_PRESENT		= (0x1 << 9),
+	/* Metadata contains valid Rx timestamp */
+	XDP_META_RX_TSTAMP_PRESENT	= (0x1 << 8),
+	/* Mask of bits containing Rx VLAN status */
+	XDP_META_RX_VLAN_TYPE		= (0x3 << 6),
+	/* Metadata does not have any VLAN tags */
+	XDP_META_RX_VLAN_NONE		= 0x0,
+	/* Metadata carries valid C-VLAN tag */
+	XDP_META_RX_CVID		= 0x1,
+	/* Metadata carries valid S-VLAN tag */
+	XDP_META_RX_SVID		= 0x2,
+	/* Mask of bits containing Rx hash status */
+	XDP_META_RX_HASH_TYPE		= (0x3 << 4),
+	/* Metadata has no RSS hash */
+	XDP_META_RX_HASH_NONE		= 0x0,
+	/* Metadata has valid L2 hash */
+	XDP_META_RX_HASH_L2		= 0x1,
+	/* Metadata has valid L3 hash */
+	XDP_META_RX_HASH_L3		= 0x2,
+	/* Metadata has valid L4 hash */
+	XDP_META_RX_HASH_L4		= 0x3,
+	/* Mask of the field containing checksum level (if there's encap) */
+	XDP_META_RX_CSUM_LEVEL		= (0x3 << 2),
+	/* Mask of bits containing Rx checksum status */
+	XDP_META_RX_CSUM_STATUS		= (0x3 << 0),
+	/* Metadata has no checksum info */
+	XDP_META_RX_CSUM_NONE		= 0x0,
+	/* Checksum has been verified by NIC */
+	XDP_META_RX_CSUM_OK		= 0x1,
+	/* Metadata carries valid checksum */
+	XDP_META_RX_CSUM_COMP		= 0x2,
+
+	/* xdp_meta_generic::magic_id indicates that the metadata is either
+	 * struct xdp_meta_generic itself or contains it at the end -> can be
+	 * used to get/set HW hints.
+	 * Direct btf_id comparison is not enough here as a custom structure
+	 * caring xdp_meta_generic at the end will have a different ID.
+	 */
+	XDP_META_GENERIC_MAGIC	= 0xeda6,
+};
+
+/* Generic metadata can be composed directly by HW, plus it should always
+ * have the first field as __le16 to account the 2 bytes of "IP align", so
+ * we pack it to avoid unexpected paddings. Also, it should be aligned to
+ * sizeof(__be16) as any other Ethernet data, and to optimize access on the
+ * 32-bit platforms.
+ */
+#define __xdp_meta_generic_attrs			\
+	__attribute__((__packed__))			\
+	__attribute__((aligned(sizeof(__be16))))
+
+/* Depending on the field layout inside the structure, it might or might not
+ * emit a "packed attribute is unnecessary" warning (when enabled, e.g. in
+ * libbpf). To not add and remove the attributes on each field addition,
+ * just suppress it.
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wpacked"
+
+/* All fields have explicit endianness, as it might be composed by HW.
+ * Byteswaps are needed for the Big Endian architectures to access the
+ * fields.
+ */
+struct xdp_meta_generic {
+	/* Add new fields here */
+
+	/* Egress part */
+	__struct_group(/* no tag */, tx, __xdp_meta_generic_attrs,
+		/* Offset from the start of the frame to the L4 header
+		 * to compute checksum for
+		 */
+		__le16 tx_csum_start;
+		/* Offset inside the L4 header to the checksum field */
+		__le16 tx_csum_off;
+		/* ID for hardware VLAN push */
+		__le16 tx_vid;
+		/* Flags indicating which Tx metadata is used */
+		__le32 tx_flags;
+		/* Tx timestamp value */
+		__le64 tx_tstamp;
+	);
+
+	/* Shortcut for the half relevant on ingress: Rx + IDs */
+	__struct_group(xdp_meta_generic_rx, rx_full, __xdp_meta_generic_attrs,
+		/* Ingress part */
+		__struct_group(/* no tag */, rx, __xdp_meta_generic_attrs,
+			/* Rx timestamp value */
+			__le64 rx_tstamp;
+			/* Rx hash value */
+			__le32 rx_hash;
+			/* Rx checksum value */
+			__le32 rx_csum;
+			/* VLAN ID popped on Rx */
+			__le16 rx_vid;
+			/* Rx queue ID on which the frame has arrived */
+			__le16 rx_qid;
+			/* Flags indicating which Rx metadata is used */
+			__le32 rx_flags;
+		);
+
+		/* Unique metadata identifiers */
+		__struct_group(/* no tag */, id, __xdp_meta_generic_attrs,
+			union {
+				struct {
+#ifdef __BIG_ENDIAN_BITFIELD
+					/* Indicates the ID of the BTF which
+					 * the below type ID comes from, as
+					 * several kernel modules may have
+					 * identical type IDs
+					 */
+					__le32 btf_id;
+					/* Indicates the ID of the actual
+					 * structure passed as metadata,
+					 * within the above BTF ID
+					 */
+					__le32 type_id;
+#else /* __LITTLE_ENDIAN_BITFIELD */
+					__le32 type_id;
+					__le32 btf_id;
+#endif /* __LITTLE_ENDIAN_BITFIELD */
+				};
+				/* BPF program gets IDs coded as one __u64:
+				 * `btf_id << 32 | type_id`, allow direct
+				 * comparison
+				 */
+				__le64 full_id;
+			};
+			/* If set to the correct value, indicates that the
+			 * meta is generic-compatible and can be used by
+			 * the consumers of generic metadata
+			 */
+			__le16 magic_id;
+		);
+	);
+} __xdp_meta_generic_attrs;
+
+#pragma GCC diagnostic pop
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.36.1

