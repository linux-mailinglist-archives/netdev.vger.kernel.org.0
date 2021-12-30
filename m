Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02AC481B24
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 10:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhL3JdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 04:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbhL3JdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 04:33:05 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698A0C06173E;
        Thu, 30 Dec 2021 01:33:05 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id r5so21010082pgi.6;
        Thu, 30 Dec 2021 01:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4MIWnUQ311oZUFyrFV2+/Ms9zwvUduBI6ULnxlTFuc=;
        b=E958mzSMXYndbWLIQHok1sgQunWrX3zaIl80wi5GAdGEl3an/isnZjwxJG5a+xTup8
         ZUgrCZy+9gdXr3u7rojEiDWvdOt3abFYx6MzCY9xaOnc5FKcfqMXoQ9auX+IiZ9gfZ4a
         svvCSlkG2dc8tjpHPbGj4Xq5zDHZcd4laYF1QFFfG6k/ueOPAdkNZM5AAL48nK+ArA+h
         XTArDcQDxx53BJay4FgO+eZfBK1rKyQl6z5JpGlgbU09hvODbw1od6kBaDYelmsqDwV2
         SxAcq/5tjwl6fhtmyf50gKcZ4kt77jN4yGdn/Om3gsgdCxkhCckqAPq8RjBHzClodIS3
         D6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4MIWnUQ311oZUFyrFV2+/Ms9zwvUduBI6ULnxlTFuc=;
        b=65kDpFG+yga70jS4wxQCz17/yUnTJVT+42Xe9SKN1kiSrEYG1rV9AXOkKA0fjfA+A9
         weq+kj3K/kUm8amH3Sh4zoXs8tl20iDDsY6RKu9hWtBIxB9+VKGqP3A2AvqkfQCX/5DH
         NVytCdOLEeNeVpziu9kbmQg2fC2FcyYPalHJ9K2zDSZky6mXvu7cOUBJ2jPIlv3eSVc6
         07oaNNj6JqPM3nFev5rbQW1SZgVgjEKw41p3587EyfaWJual4mcfQbAr5RWVE6aIx6XE
         7xJwTveO2JHawPT2hQWKJ+k+M6GgJO3f8ay4LoGndML5AAcVzckFs40lS368UUKU8PL8
         TNjg==
X-Gm-Message-State: AOAM530CpsWxRVmsJ7b8e2Za0k5K9tJg9JKlGj0iATv2xjXUe27KXmnv
        rv/7h+/8tzMEzzN8mJuHH6c=
X-Google-Smtp-Source: ABdhPJw0nm4e+v+OIik0gpY8iW/gFURn/4tA1aqGL2QVJLZdCDq2DJT/QFhIZS9yJ4YO4YL5ct++XA==
X-Received: by 2002:a65:5547:: with SMTP id t7mr27387214pgr.510.1640856784943;
        Thu, 30 Dec 2021 01:33:04 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id f4sm23231052pfj.25.2021.12.30.01.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 01:33:04 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        keescook@chromium.org, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, imagedong@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mengensun@tencent.com, mungerjiang@tencent.com
Subject: [PATCH v2 net-next 1/3] net: skb: introduce kfree_skb_with_reason()
Date:   Thu, 30 Dec 2021 17:32:38 +0800
Message-Id: <20211230093240.1125937-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211230093240.1125937-1-imagedong@tencent.com>
References: <20211230093240.1125937-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Introduce the interface kfree_skb_with_reason(), which is used to pass
the reason why the skb is dropped to 'kfree_skb' tracepoint.

Add the 'reason' field to 'trace_kfree_skb', therefor user can get
more detail information about abnormal skb with 'drop_monitor' or
eBPF.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h | 36 +++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 22 +++++++++++++++++++++-
 5 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index aa9d42724e20..3620b3ff2154 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -305,6 +305,17 @@ struct sk_buff_head {
 
 struct sk_buff;
 
+/* The reason of skb drop, which is used in kfree_skb_with_reason().
+ * en...maybe they should be splited by group?
+ *
+ * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
+ * used to translate the reason to string.
+ */
+enum skb_drop_reason {
+	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_MAX,
+};
+
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
@@ -1087,6 +1098,8 @@ static inline bool skb_unref(struct sk_buff *skb)
 
 void skb_release_head_state(struct sk_buff *skb);
 void kfree_skb(struct sk_buff *skb);
+void kfree_skb_with_reason(struct sk_buff *skb,
+			   enum skb_drop_reason reason);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 9e92f22eb086..cab1c08a30cd 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,29 +9,51 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
+#define TRACE_SKB_DROP_REASON					\
+	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
+
+#undef EM
+#undef EMe
+
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+TRACE_SKB_DROP_REASON
+
+#undef EM
+#undef EMe
+#define EM(a, b)	{ a, #b },
+#define EMe(a, b)	{ a, #b }
+
+
 /*
  * Tracepoint for free an sk_buff:
  */
 TRACE_EVENT(kfree_skb,
 
-	TP_PROTO(struct sk_buff *skb, void *location),
+	TP_PROTO(struct sk_buff *skb, void *location,
+		 enum skb_drop_reason reason),
 
-	TP_ARGS(skb, location),
+	TP_ARGS(skb, location, reason),
 
 	TP_STRUCT__entry(
-		__field(	void *,		skbaddr		)
-		__field(	void *,		location	)
-		__field(	unsigned short,	protocol	)
+		__field(void *,		skbaddr)
+		__field(void *,		location)
+		__field(unsigned short,	protocol)
+		__field(enum skb_drop_reason,	reason)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->location = location;
 		__entry->protocol = ntohs(skb->protocol);
+		__entry->reason = reason;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p",
-		__entry->skbaddr, __entry->protocol, __entry->location)
+	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
+		__entry->skbaddr, __entry->protocol, __entry->location,
+		__print_symbolic(__entry->reason, TRACE_SKB_DROP_REASON))
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 644b9c8be3a8..9464dbf9e3d6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4899,7 +4899,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
 				trace_consume_skb(skb);
 			else
-				trace_kfree_skb(skb, net_tx_action);
+				trace_kfree_skb(skb, net_tx_action,
+						SKB_DROP_REASON_NOT_SPECIFIED);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 3d0ab2eec916..7b288a121a41 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -110,7 +110,8 @@ static u32 net_dm_queue_len = 1000;
 
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
-				void *location);
+				void *location,
+				enum skb_drop_reason reason);
 	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
@@ -262,7 +263,9 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
+static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
+				void *location,
+				enum skb_drop_reason reason)
 {
 	trace_drop_common(skb, location);
 }
@@ -490,7 +493,8 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 
 static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 					      struct sk_buff *skb,
-					      void *location)
+					      void *location,
+					      enum skb_drop_reason reason)
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 275f7b8416fe..570dc022a8a1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -770,11 +770,31 @@ void kfree_skb(struct sk_buff *skb)
 	if (!skb_unref(skb))
 		return;
 
-	trace_kfree_skb(skb, __builtin_return_address(0));
+	trace_kfree_skb(skb, __builtin_return_address(0),
+			SKB_DROP_REASON_NOT_SPECIFIED);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb);
 
+/**
+ *	kfree_skb_with_reason - free an sk_buff with reason
+ *	@skb: buffer to free
+ *	@reason: reason why this skb is dropped
+ *
+ *	The same as kfree_skb() except that this function will pass
+ *	the drop reason to 'kfree_skb' tracepoint.
+ */
+void kfree_skb_with_reason(struct sk_buff *skb,
+			   enum skb_drop_reason reason)
+{
+	if (!skb_unref(skb))
+		return;
+
+	trace_kfree_skb(skb, __builtin_return_address(0), reason);
+	__kfree_skb(skb);
+}
+EXPORT_SYMBOL(kfree_skb_with_reason);
+
 void kfree_skb_list(struct sk_buff *segs)
 {
 	while (segs) {
-- 
2.30.2

