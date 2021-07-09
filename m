Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE6F3C1ECD
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 07:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhGIFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 01:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhGIFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 01:20:18 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884E4C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 22:17:34 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id w2so1645276qvh.13
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 22:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LzFVuQ4zDEROFYzo0Am3kB669NMvqwXUgLvP/TxfEbM=;
        b=uKW239G0AUee6tAGwCIsc7IvOSzmGdEW8HTw4GWTrjAv4ymJny166CGpLesV81wJQ6
         DJhTiXs66OVTcI4pVCNtt0LucC/F2caCRsiljs7W3WweokmccnHU9l2lGbZij3hbhMgP
         WtOyzJz/oME5uYBOUPoCP3C40faJKEyuN/VGGvwsruvCK8J7rJtLEkfvTKWcQem7zbaF
         bHxTI1nMVkmBePGgzqpOSsw6E6LRnyT6tgemPhYlwIwEribEUY2V0YaxNeFyywxlV5bw
         FUxe6DUXtYeG6szQnA7VD1w4Xjqkw+PxVIV9sFfMKhnCv1skW3ILCJsYc6vKSFUvclxO
         1axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LzFVuQ4zDEROFYzo0Am3kB669NMvqwXUgLvP/TxfEbM=;
        b=C7v/BmKWaV56c0StkDombpIueCeTTltnmNa1dBUBjrnXqSfh3qKqCM4GSJd8deXikM
         OlDx9U0caPk4RvmM5+8unP3fsRKxpQlc/3pRB5KUiAbpl98NJWRLf3kdfQQcYPAGmTFY
         Mz01cmQO0KzDcWOHS3QvKVkNLQAWww6mt/AXtM/qh8J6MD2MZUEE0f46PxAKCHcO14B0
         OLDHuJuCOCbkmm0H6LDGeSs/gnxCUb/nXBX/Qb/R1g1yySUo7bypBlfGouun1bYdjIFv
         E5pp/IIsR3otub5uro5SNnSfVQjzDUSZccKXu+91S48l710jl9xY4EJiU6azNs+pO56G
         SyFw==
X-Gm-Message-State: AOAM531Hgvm/f2bJR65J10PAbMO7tFlYxDC8GMhdcVBRg0rLEbDful8k
        8XpKFtVwvXOqNVpyutlPlCqc+Rl9Rhs=
X-Google-Smtp-Source: ABdhPJwirOnbGoZu+zt7SEhXKRBFGbVCXP2w+Ekl/2nHQO73UESZH1wzAfWEb747a7/gEfAEMCVqSQ==
X-Received: by 2002:ad4:442d:: with SMTP id e13mr19048074qvt.18.1625807853606;
        Thu, 08 Jul 2021 22:17:33 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id y9sm2028246qkb.3.2021.07.08.22.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 22:17:33 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next] net_sched: introduce tracepoint trace_qdisc_enqueue()
Date:   Thu,  8 Jul 2021 22:17:10 -0700
Message-Id: <20210709051710.15831-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
References: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
the entrance of TC layer on TX side. This is similar to
trace_qdisc_dequeue().

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
 net/core/dev.c               |  9 +++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 58209557cb3a..c3006c6b4a87 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
 
+TRACE_EVENT(qdisc_enqueue,
+
+	TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
+
+	TP_ARGS(qdisc, txq, skb),
+
+	TP_STRUCT__entry(
+		__field(struct Qdisc *, qdisc)
+		__field(void *,	skbaddr)
+		__field(int, ifindex)
+		__field(u32, handle)
+		__field(u32, parent)
+	),
+
+	TP_fast_assign(
+		__entry->qdisc = qdisc;
+		__entry->skbaddr = skb;
+		__entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
+		__entry->handle	 = qdisc->handle;
+		__entry->parent	 = qdisc->parent;
+	),
+
+	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
+		  __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
+);
+
 TRACE_EVENT(qdisc_reset,
 
 	TP_PROTO(struct Qdisc *q),
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..20b9376de301 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -131,6 +131,7 @@
 #include <trace/events/napi.h>
 #include <trace/events/net.h>
 #include <trace/events/skb.h>
+#include <trace/events/qdisc.h>
 #include <linux/inetdevice.h>
 #include <linux/cpu_rmap.h>
 #include <linux/static_key.h>
@@ -3864,6 +3865,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 			if (unlikely(!nolock_qdisc_is_empty(q))) {
 				rc = q->enqueue(skb, q, &to_free) &
 					NET_XMIT_MASK;
+				if (rc == NET_XMIT_SUCCESS)
+					trace_qdisc_enqueue(q, txq, skb);
 				__qdisc_run(q);
 				qdisc_run_end(q);
 
@@ -3880,6 +3883,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		}
 
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		if (rc == NET_XMIT_SUCCESS)
+			trace_qdisc_enqueue(q, txq, skb);
+
 		qdisc_run(q);
 
 no_lock_out:
@@ -3924,6 +3930,9 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		rc = NET_XMIT_SUCCESS;
 	} else {
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		if (rc == NET_XMIT_SUCCESS)
+			trace_qdisc_enqueue(q, txq, skb);
+
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
-- 
2.27.0

