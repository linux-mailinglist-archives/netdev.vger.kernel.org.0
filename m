Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27AD3B3544
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhFXSKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhFXSKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:10:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75520C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j190-20020a253cc70000b029054c72781aa2so493018yba.9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kZOIrh4dR7tuqOMmKJOLzHoQySVqfkmJ+B+V9AQn0sw=;
        b=irAZra7AUUbQ3vP4ToCUXtLs2au5mvbfqBn32LimqtmC357LrYIVg1ZTR7OV26gBMF
         1Zy9BCLu++tDRE3p48ZFLKlFmzLj9KpPvc7/an50FhXHagE15y1vqF0G6agwymoZyf4V
         swr/kQU5qvnyfwcIkd/nC7SZJ08CChMsaeRonSa8u/hxQLeBkiufLIKxKxWQZoJuq9sa
         Y7zgIMQG5g9tzlMFI8qTqSILchbyuKePwQsdKZf1H7nEmbVXgLX09QWBwHSCc7WbNFBo
         SDTf6LJhKTIlq6UTqM9zjpDiBImnl3gIbuQC2hDVqJDxS+Cdnk2USwcuxSNOad7OVPcf
         PSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kZOIrh4dR7tuqOMmKJOLzHoQySVqfkmJ+B+V9AQn0sw=;
        b=DH4gMqWVPZ+d+xcmOmzsMH5ENIlsN0GE9A7qUDu8o6KvitI40eI6PwxvzhIPmqoJv3
         w5Gq0fUo87btgDIqPp71SlqMFmg5yIsjOdx1JKx8Vxb5z/Z6FU3hdg+qaVY6IQKMlndw
         rHfyvPsfq3SJv6sICxz+WUA4VKPKqgWqaZwJgw/0uZrQ5oKJSrIzfZSIBJ7r5zKz3S/t
         jId9VObYqVnxqW6MNrkVI76M5C+uEOEHYsTjBwUHhTT6joJ4DM920M88efeuj3MjB27S
         g5USO5WP1V4wP/rN2SA3YQWx0NFNI58lEHEqtmKE90Azf+dxHSsCXJ7Hn+jYvy8cdTvD
         V05g==
X-Gm-Message-State: AOAM532S1A7PVdLDJwFxtpRoR89Pp8UFgBlg1AIwpOOnr9Oxes9gqJJz
        CIw80mgPVTmr/xanBk0yM9s3xko=
X-Google-Smtp-Source: ABdhPJxGctHbp+HL0gvrVeaSuKGQQU7rl7f33i4ZSBEk5wZ1CWlLFWRGTEEo0AvfN2edNw/OZ2Y0uAs=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a25:2d55:: with SMTP id s21mr6803465ybe.338.1624558070665;
 Thu, 24 Jun 2021 11:07:50 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:25 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-10-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 09/16] gve: Add dqo descriptors
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

General description of rings and descriptors:

TX ring is used for sending TX packet buffers to the NIC. It has the
following descriptors:
- `gve_tx_pkt_desc_dqo` - Data buffer descriptor
- `gve_tx_tso_context_desc_dqo` - TSO context descriptor
- `gve_tx_general_context_desc_dqo` - Generic metadata descriptor

Metadata is a collection of 12 bytes. We define `gve_tx_metadata_dqo`
which represents the logical interpetation of the metadata bytes. It's
helpful to define this structure because the metadata bytes exist in
multiple descriptor types (including `gve_tx_tso_context_desc_dqo`),
and the device requires same field has the same value in all
descriptors.

The TX completion ring is used to receive completions from the NIC.
Having a separate ring allows for completions to be out of order. The
completion descriptor `gve_tx_compl_desc` has several different types,
most important are packet and descriptor completions. Descriptor
completions are used to notify the driver when descriptors sent on the
TX ring are done being consumed. The descriptor completion is only used
to signal that space is cleared in the TX ring. A packet completion will
be received when a packet transmitted on the TX queue is done being
transmitted.

In addition there are "miss" and "reinjection" completions. The device
implements a "flow-miss model". Most packets will simply receive a
packet completion. The flow-miss system may choose to process a packet
based on its contents. A TX packet which experiences a flow miss would
receive a miss completion followed by a later reinjection completion.
The miss-completion is received when the packet starts to be processed
by the flow-miss system and the reinjection completion is received when
the flow-miss system completes processing the packet and sends it on the
wire.

The RX buffer ring is used to send buffers to HW via the
`gve_rx_desc_dqo` descriptor.

Received packets are put into the RX queue by the device, which
populates the `gve_rx_compl_desc_dqo` descriptor. The RX descriptors
refer to buffers posted by the buffer queue. Received buffers may be
returned out of order, such as when HW LRO is enabled.

Important concepts:
- "TX" and "RX buffer" queues, which send descriptors to the device, use
  MMIO doorbells to notify the device of new descriptors.

- "RX" and "TX completion" queues, which receive descriptors from the
  device, use a "generation bit" to know when a descriptor was populated
  by the device. The driver initializes all bits with the "current
  generation". The device will populate received descriptors with the
  "next generation" which is inverted from the current generation. When
  the ring wraps, the current/next generation are swapped.

- It's the driver's responsibility to ensure that the RX and TX
  completion queues are not overrun. This can be accomplished by
  limiting the number of descriptors posted to HW.

- TX packets have a 16 bit completion_tag and RX buffers have a 16 bit
  buffer_id. These will be returned on the TX completion and RX queues
  respectively to let the driver know which packet/buffer was completed.

Bitfields are used to describe descriptor fields. This notation is more
concise and readable than shift-and-mask. It is possible because the
driver is restricted to little endian platforms.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/Kconfig           |   2 +-
 .../net/ethernet/google/gve/gve_desc_dqo.h    | 256 ++++++++++++++++++
 2 files changed, 257 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/google/gve/gve_desc_dqo.h

diff --git a/drivers/net/ethernet/google/Kconfig b/drivers/net/ethernet/google/Kconfig
index b8f04d052fda..8641a00f8e63 100644
--- a/drivers/net/ethernet/google/Kconfig
+++ b/drivers/net/ethernet/google/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_GOOGLE
 
 config GVE
 	tristate "Google Virtual NIC (gVNIC) support"
-	depends on PCI_MSI
+	depends on (PCI_MSI && (X86 || CPU_LITTLE_ENDIAN))
 	help
 	  This driver supports Google Virtual NIC (gVNIC)"
 
diff --git a/drivers/net/ethernet/google/gve/gve_desc_dqo.h b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
new file mode 100644
index 000000000000..e8fe9adef7f2
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
@@ -0,0 +1,256 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2021 Google, Inc.
+ */
+
+/* GVE DQO Descriptor formats */
+
+#ifndef _GVE_DESC_DQO_H_
+#define _GVE_DESC_DQO_H_
+
+#include <linux/build_bug.h>
+
+#define GVE_TX_MAX_HDR_SIZE_DQO 255
+#define GVE_TX_MIN_TSO_MSS_DQO 88
+
+#ifndef __LITTLE_ENDIAN_BITFIELD
+#error "Only little endian supported"
+#endif
+
+/* Basic TX descriptor (DTYPE 0x0C) */
+struct gve_tx_pkt_desc_dqo {
+	__le64 buf_addr;
+
+	/* Must be GVE_TX_PKT_DESC_DTYPE_DQO (0xc) */
+	u8 dtype: 5;
+
+	/* Denotes the last descriptor of a packet. */
+	u8 end_of_packet: 1;
+	u8 checksum_offload_enable: 1;
+
+	/* If set, will generate a descriptor completion for this descriptor. */
+	u8 report_event: 1;
+	u8 reserved0;
+	__le16 reserved1;
+
+	/* The TX completion associated with this packet will contain this tag.
+	 */
+	__le16 compl_tag;
+	u16 buf_size: 14;
+	u16 reserved2: 2;
+} __packed;
+static_assert(sizeof(struct gve_tx_pkt_desc_dqo) == 16);
+
+#define GVE_TX_PKT_DESC_DTYPE_DQO 0xc
+#define GVE_TX_MAX_BUF_SIZE_DQO ((16 * 1024) - 1)
+
+/* Maximum number of data descriptors allowed per packet, or per-TSO segment. */
+#define GVE_TX_MAX_DATA_DESCS 10
+
+/* Min gap between tail and head to avoid cacheline overlap */
+#define GVE_TX_MIN_DESC_PREVENT_CACHE_OVERLAP 4
+
+/* "report_event" on TX packet descriptors may only be reported on the last
+ * descriptor of a TX packet, and they must be spaced apart with at least this
+ * value.
+ */
+#define GVE_TX_MIN_RE_INTERVAL 32
+
+struct gve_tx_context_cmd_dtype {
+	u8 dtype: 5;
+	u8 tso: 1;
+	u8 reserved1: 2;
+
+	u8 reserved2;
+};
+
+static_assert(sizeof(struct gve_tx_context_cmd_dtype) == 2);
+
+/* TX Native TSO Context DTYPE (0x05)
+ *
+ * "flex" fields allow the driver to send additional packet context to HW.
+ */
+struct gve_tx_tso_context_desc_dqo {
+	/* The L4 payload bytes that should be segmented. */
+	u32 tso_total_len: 24;
+	u32 flex10: 8;
+
+	/* Max segment size in TSO excluding headers. */
+	u16 mss: 14;
+	u16 reserved: 2;
+
+	u8 header_len; /* Header length to use for TSO offload */
+	u8 flex11;
+	struct gve_tx_context_cmd_dtype cmd_dtype;
+	u8 flex0;
+	u8 flex5;
+	u8 flex6;
+	u8 flex7;
+	u8 flex8;
+	u8 flex9;
+} __packed;
+static_assert(sizeof(struct gve_tx_tso_context_desc_dqo) == 16);
+
+#define GVE_TX_TSO_CTX_DESC_DTYPE_DQO 0x5
+
+/* General context descriptor for sending metadata. */
+struct gve_tx_general_context_desc_dqo {
+	u8 flex4;
+	u8 flex5;
+	u8 flex6;
+	u8 flex7;
+	u8 flex8;
+	u8 flex9;
+	u8 flex10;
+	u8 flex11;
+	struct gve_tx_context_cmd_dtype cmd_dtype;
+	u16 reserved;
+	u8 flex0;
+	u8 flex1;
+	u8 flex2;
+	u8 flex3;
+} __packed;
+static_assert(sizeof(struct gve_tx_general_context_desc_dqo) == 16);
+
+#define GVE_TX_GENERAL_CTX_DESC_DTYPE_DQO 0x4
+
+/* Logical structure of metadata which is packed into context descriptor flex
+ * fields.
+ */
+struct gve_tx_metadata_dqo {
+	union {
+		struct {
+			u8 version;
+
+			/* If `skb->l4_hash` is set, this value should be
+			 * derived from `skb->hash`.
+			 *
+			 * A zero value means no l4_hash was associated with the
+			 * skb.
+			 */
+			u16 path_hash: 15;
+
+			/* Should be set to 1 if the flow associated with the
+			 * skb had a rehash from the TCP stack.
+			 */
+			u16 rehash_event: 1;
+		}  __packed;
+		u8 bytes[12];
+	};
+}  __packed;
+static_assert(sizeof(struct gve_tx_metadata_dqo) == 12);
+
+#define GVE_TX_METADATA_VERSION_DQO 0
+
+/* TX completion descriptor */
+struct gve_tx_compl_desc {
+	/* For types 0-4 this is the TX queue ID associated with this
+	 * completion.
+	 */
+	u16 id: 11;
+
+	/* See: GVE_COMPL_TYPE_DQO* */
+	u16 type: 3;
+	u16 reserved0: 1;
+
+	/* Flipped by HW to notify the descriptor is populated. */
+	u16 generation: 1;
+	union {
+		/* For descriptor completions, this is the last index fetched
+		 * by HW + 1.
+		 */
+		__le16 tx_head;
+
+		/* For packet completions, this is the completion tag set on the
+		 * TX packet descriptors.
+		 */
+		__le16 completion_tag;
+	};
+	__le32 reserved1;
+} __packed;
+static_assert(sizeof(struct gve_tx_compl_desc) == 8);
+
+#define GVE_COMPL_TYPE_DQO_PKT 0x2 /* Packet completion */
+#define GVE_COMPL_TYPE_DQO_DESC 0x4 /* Descriptor completion */
+#define GVE_COMPL_TYPE_DQO_MISS 0x1 /* Miss path completion */
+#define GVE_COMPL_TYPE_DQO_REINJECTION 0x3 /* Re-injection completion */
+
+/* Descriptor to post buffers to HW on buffer queue. */
+struct gve_rx_desc_dqo {
+	__le16 buf_id; /* ID returned in Rx completion descriptor */
+	__le16 reserved0;
+	__le32 reserved1;
+	__le64 buf_addr; /* DMA address of the buffer */
+	__le64 header_buf_addr;
+	__le64 reserved2;
+} __packed;
+static_assert(sizeof(struct gve_rx_desc_dqo) == 32);
+
+/* Descriptor for HW to notify SW of new packets received on RX queue. */
+struct gve_rx_compl_desc_dqo {
+	/* Must be 1 */
+	u8 rxdid: 4;
+	u8 reserved0: 4;
+
+	/* Packet originated from this system rather than the network. */
+	u8 loopback: 1;
+	/* Set when IPv6 packet contains a destination options header or routing
+	 * header.
+	 */
+	u8 ipv6_ex_add: 1;
+	/* Invalid packet was received. */
+	u8 rx_error: 1;
+	u8 reserved1: 5;
+
+	u16 packet_type: 10;
+	u16 ip_hdr_err: 1;
+	u16 udp_len_err: 1;
+	u16 raw_cs_invalid: 1;
+	u16 reserved2: 3;
+
+	u16 packet_len: 14;
+	/* Flipped by HW to notify the descriptor is populated. */
+	u16 generation: 1;
+	/* Should be zero. */
+	u16 buffer_queue_id: 1;
+
+	u16 header_len: 10;
+	u16 rsc: 1;
+	u16 split_header: 1;
+	u16 reserved3: 4;
+
+	u8 descriptor_done: 1;
+	u8 end_of_packet: 1;
+	u8 header_buffer_overflow: 1;
+	u8 l3_l4_processed: 1;
+	u8 csum_ip_err: 1;
+	u8 csum_l4_err: 1;
+	u8 csum_external_ip_err: 1;
+	u8 csum_external_udp_err: 1;
+
+	u8 status_error1;
+
+	__le16 reserved5;
+	__le16 buf_id; /* Buffer ID which was sent on the buffer queue. */
+
+	union {
+		/* Packet checksum. */
+		__le16 raw_cs;
+		/* Segment length for RSC packets. */
+		__le16 rsc_seg_len;
+	};
+	__le32 hash;
+	__le32 reserved6;
+	__le64 reserved7;
+} __packed;
+
+static_assert(sizeof(struct gve_rx_compl_desc_dqo) == 32);
+
+/* Ringing the doorbell too often can hurt performance.
+ *
+ * HW requires this value to be at least 8.
+ */
+#define GVE_RX_BUF_THRESH_DQO 32
+
+#endif /* _GVE_DESC_DQO_H_ */
-- 
2.32.0.288.g62a8d224e6-goog

