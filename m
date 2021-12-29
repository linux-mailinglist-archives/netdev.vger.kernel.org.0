Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAE948141F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbhL2Oc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2Oc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:32:28 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE45C061574;
        Wed, 29 Dec 2021 06:32:28 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id a23so18685111pgm.4;
        Wed, 29 Dec 2021 06:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4MIWnUQ311oZUFyrFV2+/Ms9zwvUduBI6ULnxlTFuc=;
        b=jGtzIm3GHEAjyxn1c7KXPFRCacon4pxORuv6HqLdHGQ11vzUsDVzrotEZOsuRYRF5m
         5gldPepOnIPnFD8Onan8ErytY+v4+ZhFJqeuMTmpugz4Pexor13FE/2i6tI5cg9aF9jq
         nyz9wv4zHHoQtMHOCZ4NSDEFKq7kfAE1gZ2C4IA3X05efH+7NiKxK5YoWcyBQuUuEj0Z
         PTEU5N+KPKEKZE/Xy7CVbxNegmFWHqfAfLNS09yq6ayBX88JPHhPkeJ/YNpfBS/6KJpk
         4FIo+WSt/MLVOl+Zu8XhBlTtSXyVWuAoQ3TylS8VW1pqJxj2gNRQcaG6Q3PnWR+P2C+4
         UGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4MIWnUQ311oZUFyrFV2+/Ms9zwvUduBI6ULnxlTFuc=;
        b=KuIsy1eGGD9HCzDai84c85hiakHOC5bk1EoiIA87E7AjSScITNk5b3Ed75biUYCtuF
         Z1AF0XPfn1NFEImONeESlHtS3XXR61jh1jZJld1LM7oT+6K1qIVcOImbMzQVOEeegyKF
         /k6beQQyjRvZeYi/rEj+Zkozt1+oh72NKoHcb9qae8tNwIftRRk8u9MjXHIs4tgJtsZC
         +J38Wort9Fq8jeJjbUm5Nhalh4B8ltj80SUSMrUzAwq/oFBEDnD+QbyNNxDDhebVZTvF
         w+jhQJtV0ohXmcud+B+UoWJgtkz+fLJrCaIaSNNKf/a4cix77PAo0qrUKUwNrZBy3pDj
         CIUA==
X-Gm-Message-State: AOAM530MtmptMYx3/ZubPhHUw39bo0bhO5hyXek3pTNCDa1gAFtQq8PK
        9imlh6zBPfOSWQHULZnsjRzLf4TeidA=
X-Google-Smtp-Source: ABdhPJyGlJf/4DapuMtTSjO2nugeQ1NaHfQ4fdxIlqXMI6JHuQbP/e4CK0vMjpfK2YRZ8yno2zpTyA==
X-Received: by 2002:a63:ea0c:: with SMTP id c12mr23145483pgi.378.1640788348157;
        Wed, 29 Dec 2021 06:32:28 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id v16sm24860393pfu.131.2021.12.29.06.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:32:27 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        cong.wang@bytedance.com, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, keescook@chromium.org, imagedong@tencent.com,
        atenart@kernel.org, bigeasy@linutronix.de, weiwan@google.com,
        arnd@arndb.de, vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: skb: introduce kfree_skb_with_reason()
Date:   Wed, 29 Dec 2021 22:32:04 +0800
Message-Id: <20211229143205.410731-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211229143205.410731-1-imagedong@tencent.com>
References: <20211229143205.410731-1-imagedong@tencent.com>
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

