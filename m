Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE38391E1C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhEZR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:28:58 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46307 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhEZR25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:28:57 -0400
Received: from ubuntu18.home (135.19-200-80.adsl-dyn.isp.belgacom.be [80.200.19.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id BFF07200DFBB;
        Wed, 26 May 2021 19:17:10 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be BFF07200DFBB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622049430;
        bh=zd6T88m0ywsXml7q9DhEmUr6rv4zabWc1VlRCgydCI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fvg4a+8tFQwI7xEUagavhe8dAMbUVbDC4O6goZYSRT1wodi4WO2X4WqX0po75wHzW
         zfg9zH73wQi9ihLc+fHtP44uyfvxV7hm6xzHnzQhzZyX0vgQhdzwCtKg+Om7QXAe2C
         NvHiAWmw/9+0STvG5rDUrVKH3L43ufcUOFThpweXhm32mNVCmVTzob2I9SjkktJWZE
         kLc68BpRJjAbgemAycxKHotOxNgZU2/4Wi+6wBdlw9YbPUANqZLjwxMilH1mazmEXQ
         YGkpSnjngRxjviM4CQHRD0m0sq9omhd1affPl6G3zjbHGEDQGEcIN5icx12WoAkOgF
         Vq5d1gosbktyg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [RESEND PATCH net-next v3 1/5] uapi: IPv6 IOAM headers definition
Date:   Wed, 26 May 2021 19:16:36 +0200
Message-Id: <20210526171640.9722-2-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526171640.9722-1-justin.iurman@uliege.be>
References: <20210526171640.9722-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides the IPv6 IOAM option header [1] as well as the IOAM
Trace header [2]. An IOAM option must be 4n-aligned. Here is an overview of
a Hop-by-Hop with an IOAM Trace option:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Next header  |  Hdr Ext Len  |    Padding    |    Padding    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Option Type  |  Opt Data Len |    Reserved   |   IOAM Type   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Namespace-ID          | NodeLen | Flags | RemainingLen|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                IOAM-Trace-Type                |    Reserved   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+<-+
|                                                               |  |
|                         node data [0]                         |  |
|                                                               |  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  D
|                                                               |  a
|                         node data [1]                         |  t
|                                                               |  a
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
~                             ...                               ~  S
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  p
|                                                               |  a
|                         node data [n-1]                       |  c
|                                                               |  e
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  |
|                                                               |  |
|                         node data [n]                         |  |
|                                                               |  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+<-+

The IOAM option header starts at "Option Type" and ends after "IOAM
Type". The IOAM Trace header starts at "Namespace-ID" and ends after
"IOAM-Trace-Type/Reserved".

IOAM Type: either Pre-allocated Trace (=0), Incremental Trace (=1),
Proof-of-Transit (=2) or Edge-to-Edge (=3). Note that both the
Pre-allocated Trace and the Incremental Trace look the same. The two
others are not implemented.

Namespace-ID: IOAM namespace identifier, not to be confused with network
namespaces. It adds further context to IOAM options and associated data,
and allows devices which are IOAM capable to determine whether IOAM
options must be processed or ignored. It can also be used by an operator
to distinguish different operational domains or to identify different
sets of devices.

NodeLen: Length of data added by each node. It depends on the Trace
Type.

Flags: Only the Overflow (O) flag for now. The O flag is set by a
transit node when there are not enough octets left to record its data.

RemainingLen: Remaining free space to record data.

IOAM-Trace-Type: Bit field where each bit corresponds to a specific kind
of IOAM data. See [2] for a detailed list.

  [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
  [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/uapi/linux/ioam6.h | 123 +++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 include/uapi/linux/ioam6.h

diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
new file mode 100644
index 000000000000..2177e4e49566
--- /dev/null
+++ b/include/uapi/linux/ioam6.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 IOAM implementation
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#ifndef _UAPI_LINUX_IOAM6_H
+#define _UAPI_LINUX_IOAM6_H
+
+#include <asm/byteorder.h>
+#include <linux/types.h>
+
+/*
+ * IPv6 IOAM Option Header
+ */
+struct ioam6_hdr {
+	__u8 opt_type;
+	__u8 opt_len;
+	__u8 :8;				/* reserved */
+#define IOAM6_TYPE_PREALLOC 0
+	__u8 type;
+} __attribute__((packed));
+
+/*
+ * IOAM Trace Header
+ */
+struct ioam6_trace_hdr {
+	__be16	namespace_id;
+
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+
+	__u8	:1,				/* unused */
+		:1,				/* unused */
+		overflow:1,
+		nodelen:5;
+
+	__u8	remlen:7,
+		:1;				/* unused */
+
+	union {
+		__be32 type_be32;
+
+		struct {
+			__u32	bit7:1,
+				bit6:1,
+				bit5:1,
+				bit4:1,
+				bit3:1,
+				bit2:1,
+				bit1:1,
+				bit0:1,
+				bit15:1,	/* unused */
+				bit14:1,	/* unused */
+				bit13:1,	/* unused */
+				bit12:1,	/* unused */
+				bit11:1,
+				bit10:1,
+				bit9:1,
+				bit8:1,
+				bit23:1,	/* reserved */
+				bit22:1,
+				bit21:1,	/* unused */
+				bit20:1,	/* unused */
+				bit19:1,	/* unused */
+				bit18:1,	/* unused */
+				bit17:1,	/* unused */
+				bit16:1,	/* unused */
+				:8;		/* reserved */
+		} type;
+	};
+
+#elif defined(__BIG_ENDIAN_BITFIELD)
+
+	__u8	nodelen:5,
+		overflow:1,
+		:1,				/* unused */
+		:1;				/* unused */
+
+	__u8	:1,				/* unused */
+		remlen:7;
+
+	union {
+		__be32 type_be32;
+
+		struct {
+			__u32	bit0:1,
+				bit1:1,
+				bit2:1,
+				bit3:1,
+				bit4:1,
+				bit5:1,
+				bit6:1,
+				bit7:1,
+				bit8:1,
+				bit9:1,
+				bit10:1,
+				bit11:1,
+				bit12:1,	/* unused */
+				bit13:1,	/* unused */
+				bit14:1,	/* unused */
+				bit15:1,	/* unused */
+				bit16:1,	/* unused */
+				bit17:1,	/* unused */
+				bit18:1,	/* unused */
+				bit19:1,	/* unused */
+				bit20:1,	/* unused */
+				bit21:1,	/* unused */
+				bit22:1,
+				bit23:1,	/* reserved */
+				:8;		/* reserved */
+		} type;
+	};
+
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+
+	__u8	data[0];
+} __attribute__((packed));
+
+#endif /* _UAPI_LINUX_IOAM6_H */
-- 
2.17.1

