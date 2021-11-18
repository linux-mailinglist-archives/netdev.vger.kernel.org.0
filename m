Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB82A455BDB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344952AbhKRMwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344833AbhKRMv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:51:59 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D0EC0613B9;
        Thu, 18 Nov 2021 04:48:35 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x131so5873292pfc.12;
        Thu, 18 Nov 2021 04:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NdeR00iS1+q0mlw4CfCMEaptDLpQYaSCzyT4H3XBiJA=;
        b=h3AKM1BtFV8aGLzwBa0e0XaAnsMedbBvzhHy8vBkpq8NSJU3/74KBm3YP80rN9i3P9
         PKZc9fhiyISa5f6+bnZ1xBSeznjJftdh0fa7K5Me6IseNPOKD7MOExvV7RxQqXuGtLas
         4p0RGK6IJyyKzZ+50aSEs/nw9oRfc+MIgL2ky5Cexx4k1C7ahDVKpbq4LqWkAUzrTBPx
         eWCawHIyZx0NKGdLioCWwXhW+i2Wr/LMKs3ImarQ8RwOBLj/G6mgUVNdLrUPM/ebdMUp
         WyC7MkwzIW+krd1D41KbcomIHmB75wtEt+ZzDjn2ZEWH/EPJ4zzCwY0hC1usW+y+m0eU
         2YPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NdeR00iS1+q0mlw4CfCMEaptDLpQYaSCzyT4H3XBiJA=;
        b=64pomvE19mhZ2I1yHGz1zys4P7gs9KzzonlKtJ7ifAWfzfmbjqHiNUbijPxOIHYjCS
         nNsUYOAYCrbN4SAEsPpLKAHYbEZdST168VFnXKlFgdVkzeW/WAMwkLpRvLRYjpeeWF4T
         sPA+doILrs3E3QJJuAPMlGn1I5ZzrNLtLDCl3z/aiurAog1a+pZH5xRLG17DzyJEb+af
         Cf99wRc2FMc1Gz+4tQYwpRcY2GM7MoJ9QcshXM2DPy/YRW9kLgAi86/dfPsHbBAgPZXv
         K2GJI1qyGXeDi3sOn64W3Hj/IOMfd+3IjjXpOW8TgOLSPHOOhArr38WT48N4SqfV2nnc
         6+DA==
X-Gm-Message-State: AOAM530VUPT3mympVQnqIqDBEpnOQu7VcOdC1pUQgTY6cIvAqFC+pfFE
        khDJ/i0ndaf3z0Gch9I3f+M=
X-Google-Smtp-Source: ABdhPJwtTsJFPuKfKAQTCe5MwglX1daGYQJzoZ01Y4fl7KzNims7s0H7HZobtzk7kFQBTRHkDgHjYg==
X-Received: by 2002:a63:f611:: with SMTP id m17mr10989154pgh.259.1637239715247;
        Thu, 18 Nov 2021 04:48:35 -0800 (PST)
Received: from desktop.cluster.local ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j16sm3679404pfj.16.2021.11.18.04.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 04:48:34 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, rostedt@goodmis.org
Cc:     davem@davemloft.net, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, ycheng@google.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] net: snmp: add tracepoint support for snmp
Date:   Thu, 18 Nov 2021 20:48:11 +0800
Message-Id: <20211118124812.106538-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211118124812.106538-1-imagedong@tencent.com>
References: <20211118124812.106538-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

snmp is the network package statistics module in kernel, and it is
useful in network issue diagnosis, such as packet drop.

However, it is hard to get the detail information about the packet.
For example, we can know that there is something wrong with the
checksum of udp packet though 'InCsumErrors' of UDP protocol in
/proc/net/snmp, but we can't figure out the ip and port of the packet
that this error is happening on.

Add tracepoint for snmp. Therefor, users can use some tools (such as
eBPF) to get the information of the exceptional packet.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
v2:
- use a single event, instead of creating events for every protocols
---
 include/trace/events/snmp.h | 44 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/snmp.h   | 21 ++++++++++++++++++
 net/core/net-traces.c       |  3 +++
 3 files changed, 68 insertions(+)
 create mode 100644 include/trace/events/snmp.h

diff --git a/include/trace/events/snmp.h b/include/trace/events/snmp.h
new file mode 100644
index 000000000000..1fa2e31056e0
--- /dev/null
+++ b/include/trace/events/snmp.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM snmp
+
+#if !defined(_TRACE_SNMP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SNMP_H
+
+#include <linux/tracepoint.h>
+#include <linux/skbuff.h>
+#include <linux/snmp.h>
+
+DECLARE_EVENT_CLASS(snmp_template,
+
+	TP_PROTO(struct sk_buff *skb, int type, int field, int val),
+
+	TP_ARGS(skb, type, field, val),
+
+	TP_STRUCT__entry(
+		__field(void *, skbaddr)
+		__field(int, type)
+		__field(int, field)
+		__field(int, val)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		__entry->type = type;
+		__entry->field = field;
+		__entry->val = val;
+	),
+
+	TP_printk("skbaddr=%p, type=%d, field=%d, val=%d",
+		  __entry->skbaddr, __entry->type,
+		  __entry->field, __entry->val)
+);
+
+DEFINE_EVENT(snmp_template, snmp,
+	TP_PROTO(struct sk_buff *skb, int type, int field, int val),
+	TP_ARGS(skb, type, field, val)
+);
+
+#endif
+
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..b96077e09a58 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -347,4 +347,25 @@ enum
 	__LINUX_MIB_TLSMAX
 };
 
+/* mib type definitions for trace event */
+enum {
+	TRACE_MIB_NUM = 0,
+	TRACE_MIB_IP,
+	TRACE_MIB_IPV6,
+	TRACE_MIB_TCP,
+	TRACE_MIB_NET,
+	TRACE_MIB_ICMP,
+	TRACE_MIB_ICMPV6,
+	TRACE_MIB_ICMPMSG,
+	TRACE_MIB_ICMPV6MSG,
+	TRACE_MIB_UDP,
+	TRACE_MIB_UDPV6,
+	TRACE_MIB_UDPLITE,
+	TRACE_MIB_UDPV6LITE,
+	TRACE_MIB_XFRM,
+	TRACE_MIB_TLS,
+	TRACE_MIB_MPTCP,
+	__TRACE_MIB_MAX
+};
+
 #endif	/* _LINUX_SNMP_H */
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index c40cd8dd75c7..e291c0974438 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -35,6 +35,7 @@
 #include <trace/events/tcp.h>
 #include <trace/events/fib.h>
 #include <trace/events/qdisc.h>
+#include <trace/events/snmp.h>
 #if IS_ENABLED(CONFIG_BRIDGE)
 #include <trace/events/bridge.h>
 EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_add);
@@ -61,3 +62,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(snmp);
-- 
2.27.0

