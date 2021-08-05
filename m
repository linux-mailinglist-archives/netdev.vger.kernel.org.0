Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925B73E1BD3
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241892AbhHES6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241866AbhHES6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:11 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D27C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:57:56 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v8-20020a0568301bc8b02904d5b4e5ca3aso6148691ota.13
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6kT6Vk2sprR6tKH7a6ctkmsP8co54EU62v99qfPXUNQ=;
        b=KUJwPCbniDvY5WKL7bjZ5L+6JhmrplMy61KVPoW8kJKGbWzSU1z1ph+BwELAXz8uMG
         yPA6udV25RLamSjOqI0Fews2kPAQTaA7YeIoHkTCTIv4WYNr16iCx5wQAwvkawLGUS3S
         TqGUzhVivDM0PC2fcG63KzwkhAdD4e8R2XBu9VPvbO0rLA/SREduA1YfRgWpyidJX5+2
         dm4Fe1VssnLWi9BqPK1l7ACho0ZYT6RN+UnYJe9mQG8RIwwjnBPfrTJLGIQSFM1N1QZh
         hXOZiTgcftmP1KvMOKpd2WVEPmsuf0vTGzlpsqxyqLy+VQLW9DlHAtuQYZ09DnjY+Hdn
         OaTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6kT6Vk2sprR6tKH7a6ctkmsP8co54EU62v99qfPXUNQ=;
        b=HMsy7qA72Kct071IcwWbLuhX+pntD7t5Bp802Wm2+EyXe9inzN/hAHVncQ9lYbNgW/
         decUxYGWj7dNewWqciXeG9EFsOkHMdrv4RuMT7YUBX5pL8FBNavzkYtuJnX/JrRpwg4A
         sOlbCk0YuXZd4CZ4McCJqQNJv7b/5AjFJ4wYOshHNTwDLhbqb52cxjAySuzKBFhBbkKR
         2NLoV+aKGaKP5tPE5Xto5uQyDmlO6WpG+T7/EW4YNRoFBi0lyIQ9xr0DadDdcjQ3HG53
         xw8dnMWLSIPZF4g/exdoXY3MjQxI9OlmTdAXVyXfVYtNtL3d4j7fLowHNobX3xXNII/m
         UraQ==
X-Gm-Message-State: AOAM531BOXjESd7QXiKX7Z3r8XzM7q6Rc5xPSvQkcvJYK4ZTGDBYihS6
        11Nks4E0Jc/3fIeuPXstxN/X7RkSvX4=
X-Google-Smtp-Source: ABdhPJw6kZDFSIDLG/PrYGmrCQAwI1DPfvWNZ1jnMxW8s3/e8EMhGEl4acNG0jMqtjUvmBpAzWFmRQ==
X-Received: by 2002:a9d:eed:: with SMTP id 100mr4951820otj.50.1628189875751;
        Thu, 05 Aug 2021 11:57:55 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 02/13] ipv4: introduce tracepoint trace_ip_queue_xmit()
Date:   Thu,  5 Aug 2021 11:57:39 -0700
Message-Id: <20210805185750.4522-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_ip_queue_xmit() is introduced to trace skb
at the entrance of IP layer on TX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/ip.h | 42 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/ip_output.c      | 10 +++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
index 008f821ebc50..553ae7276732 100644
--- a/include/trace/events/ip.h
+++ b/include/trace/events/ip.h
@@ -41,6 +41,48 @@
 	TP_STORE_V4MAPPED(__entry, saddr, daddr)
 #endif
 
+TRACE_EVENT(ip_queue_xmit,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+		__field(const void *, skaddr)
+		__field(__u16, sport)
+		__field(__u16, dport)
+		__array(__u8, saddr, 4)
+		__array(__u8, daddr, 4)
+		__array(__u8, saddr_v6, 16)
+		__array(__u8, daddr_v6, 16)
+	),
+
+	TP_fast_assign(
+		struct inet_sock *inet = inet_sk(sk);
+		__be32 *p32;
+
+		__entry->skbaddr = skb;
+		__entry->skaddr = sk;
+
+		__entry->sport = ntohs(inet->inet_sport);
+		__entry->dport = ntohs(inet->inet_dport);
+
+		p32 = (__be32 *) __entry->saddr;
+		*p32 = inet->inet_saddr;
+
+		p32 = (__be32 *) __entry->daddr;
+		*p32 =  inet->inet_daddr;
+
+		TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
+			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
+	),
+
+	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c skbaddr=%px",
+		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
+		  __entry->saddr_v6, __entry->daddr_v6, __entry->skbaddr)
+);
+
 #endif /* _TRACE_IP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6b04a88466b2..dcf94059112e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -82,6 +82,7 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netlink.h>
 #include <linux/tcp.h>
+#include <trace/events/ip.h>
 
 static int
 ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
@@ -536,7 +537,14 @@ EXPORT_SYMBOL(__ip_queue_xmit);
 
 int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
 {
-	return __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
+	int ret;
+
+	ret = __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
+	if (!ret)
+		trace_ip_queue_xmit(sk, skb);
+
+	return ret;
+
 }
 EXPORT_SYMBOL(ip_queue_xmit);
 
-- 
2.27.0

