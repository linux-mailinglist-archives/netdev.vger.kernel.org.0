Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983A93E1BD6
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241917AbhHES6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241878AbhHES6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:15 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90104C06179C
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:57:59 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 13-20020a4ae1ad0000b029024b19a4d98eso1586894ooy.5
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Er+z0V/78NtCvK3pvfWA7OY3Y0ErSPtfUBuSQfWUBy4=;
        b=Yo3gz8BHOlbKfCzNggFthMBzBqj4KE7ZuqBdT0BMfjEla3GtOGZjT7cmHEmNlQZC7N
         2pkxId5RatKY92R306cUZkRxGqSRKu1TP0e3iKnC2TO6SLHmBzYnhlsiX5AwpwePV7FK
         1S7pIPPybc9yThCyREmhpDMUC4HBtLh8drkPbeyvCvGUQDdsEgMIG0UV5r5XsTfZE8ET
         U5Ksa+6LLX9h1R2BWfkboDvtyeLp7FbVPLnAHtwROA5f6uMyB20/VBRl3df2fJYiCGLy
         rBJzLpx3WiuJK3hHbnebHXZZZTmBIzdIbBLdPGtce/4rNTxM+Mfvu/xjoaxsu2Bzp2Q/
         ZTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Er+z0V/78NtCvK3pvfWA7OY3Y0ErSPtfUBuSQfWUBy4=;
        b=nRh10/Z5WsVEreXsVl4r3ZoyksSi/S0UEyfsSJHvhcifqogM2aht9k7ijUJvahi0X4
         Qn5fz8Jw0rEyFL0PbyleQQ/zt+1PbvhakhW7pujLv759o9xf73mf/2+YJAiar8IcF/fD
         ATUV4HwdqTVCdwO/uQxHApOPorbAvNWf/iKnUSSMA0b+0ByyJZm7FmzAl6sBShY7hzKH
         f5agS7Iiyi2Kq20KIzFWx7mSmB0ubVnp0Ia59UZeZRtYBxmzdIToWIxkFECZaHQphZaQ
         XyuTkIHX1MZMqrztiui5w2iNZd1uk/HzXurcngjp3/6kJymg28qpD0hePSsIz8G5UKU2
         AoVQ==
X-Gm-Message-State: AOAM532HouwEp3YdoeN5tM4sTYTQpDRLCXtGCi2PpUFVYCwusTo/6vsl
        qmHcdP/4xTfQa1Ns1rptooSQLyptEwk=
X-Google-Smtp-Source: ABdhPJyYzEEY+OJUzeNcpDc59JwjHwA3XTZeo47Oezp3CAyaP7Q7cp9xLT7A9S3A52/x3NjrE5OPug==
X-Received: by 2002:a4a:e703:: with SMTP id y3mr4348002oou.24.1628189878741;
        Thu, 05 Aug 2021 11:57:58 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:58 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 05/13] udp: introduce tracepoint trace_udp_v6_send_skb()
Date:   Thu,  5 Aug 2021 11:57:42 -0700
Message-Id: <20210805185750.4522-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_udp_v6_send_skb() is introduced to trace skb
at the exit of UDPv6 layer on TX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/udp.h | 21 +++++++++++++++++++++
 net/core/net-traces.c      |  3 +++
 net/ipv6/udp.c             |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index 7babc1a11693..6af4b402237a 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -46,6 +46,27 @@ TRACE_EVENT(udp_send_skb,
 	TP_printk("skaddr=%px, skbaddr=%px", __entry->skaddr, __entry->skbaddr)
 );
 
+#if IS_ENABLED(CONFIG_IPV6)
+TRACE_EVENT(udp_v6_send_skb,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skaddr)
+		__field(const void *, skbaddr)
+	),
+
+	TP_fast_assign(
+		__entry->skaddr = sk;
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skaddr=%px, skbaddr=%px", __entry->skaddr, __entry->skbaddr)
+);
+#endif
+
 #endif /* _TRACE_UDP_H */
 
 /* This part must be outside protection */
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index e1bd46076ad0..0aca299dfb55 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -62,3 +62,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
 EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
+#if IS_ENABLED(CONFIG_IPV6)
+EXPORT_TRACEPOINT_SYMBOL_GPL(udp_v6_send_skb);
+#endif
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index c5e15e94bb00..84895ca40e5c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -52,6 +52,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <trace/events/skb.h>
+#include <trace/events/udp.h>
 #include "udp_impl.h"
 
 static u32 udp6_ehashfn(const struct net *net,
@@ -1255,6 +1256,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 	} else {
 		UDP6_INC_STATS(sock_net(sk),
 			       UDP_MIB_OUTDATAGRAMS, is_udplite);
+		trace_udp_v6_send_skb(sk, skb);
 	}
 	return err;
 }
-- 
2.27.0

